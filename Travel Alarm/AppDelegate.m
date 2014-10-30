//
//  AppDelegate.m
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 31.08.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AppDelegate{
    CLLocationManager *locationManager;
}
UIAlertView *alertGPSisNotAvalible;
NSMutableArray *alarms;
CLLocation *target;
NSUserDefaults *defaults;
SystemSoundID soundID;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"alarmSound"])[defaults setObject:@"alarm_000" forKey:@"alarmSound"];
    
    if (![defaults objectForKey:@"status"])[defaults setBool:false forKey:@"status"];
    if (![defaults objectForKey:@"statusPRO"])[defaults setBool:false forKey:@"statusPRO"];
    
    
    [defaults setBool:false forKey:@"alarmStatus"];
    
    [defaults synchronize];
    
    self.speed = 0;
    self.distance = 0;
    
    
    self.locationTracker = [[LocationTracker alloc]init];
    
    NSTimeInterval time = 4.0;
    self.locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                                target:self
                                                              selector:@selector(updateLocation)
                                                              userInfo:nil
                                                               repeats:YES];
    
    
    
    [self checkGPSPermission];
    return YES;
}

-(void)updateLocation {
    
    [self.locationTracker updateLocationToServer];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    NSLog(@"BACKGROUND");
    
    [self gpsAlert:NO];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self checkGPSPermission];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Remote Notification Recieved");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody =  @"Looks like i got a notification - fetch thingy";
    [application presentLocalNotificationNow:notification];
    completionHandler(UIBackgroundFetchResultNewData);
    
}
#pragma gpsServices

- (void)checkGPSPermission{
    if ([CLLocationManager locationServicesEnabled] == NO) {
        [(AppDelegate*)[[UIApplication sharedApplication]delegate] gpsAlert:YES];
    } else {
        
        [(AppDelegate*)[[UIApplication sharedApplication]delegate] gpsAlert:NO];
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            [(AppDelegate*)[[UIApplication sharedApplication]delegate] gpsAlert:YES];
        } 
    }
}

- (void)locationDataWitLocation:(CLLocationCoordinate2D)location{
    
    target = [[CLLocation alloc] initWithLatitude:[defaults floatForKey:@"targetLatitude"] longitude:[defaults floatForKey:@"targetLongitude"]];
    CLLocationDistance distance = [target distanceFromLocation:[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude]];
    
    int distanceInInt = (int)roundf(distance/1000-0.5);
    int eta = (int)roundf(distance/self.speed/60);
    self.distance = distanceInInt;
    
    if (self.speed*3.6>0) {
        
        if (eta>=60)[self.travelView update:distanceInInt speed:(int)roundf(self.speed*3.6) eta:[NSString stringWithFormat:@"%dh %dmin",(int)(eta/60),eta%60]];
        
        else [self.travelView update:distanceInInt speed:(int)roundf(self.speed*3.6) eta:[NSString stringWithFormat:@"%dmin",eta]];
        
    }else [self.travelView update:distanceInInt speed:0 eta:[NSString stringWithFormat:@"∞"]];
    
    if ([defaults boolForKey:@"alarmStatus"] == false){
        
        if ([defaults boolForKey:@"status"] == true){
            
            
            
            
            
            if ([defaults objectForKey:@"alarms"]){
                
                alarms = [[defaults arrayForKey:@"alarms"] mutableCopy];
                
                for (int i = 0; i<alarms.count; i++) {
                    
                    
                    if (([[alarms objectAtIndex:i]intValue] >= distanceInInt && [defaults integerForKey:@"lastAlarm"]>[[alarms objectAtIndex:i]intValue])||([[alarms objectAtIndex:i]intValue] >= distanceInInt && [defaults integerForKey:@"lastAlarm"]==-1)) {
                        
                        [defaults setInteger:distanceInInt forKey:@"lastAlarm"];
                        [defaults synchronize];
                        
                        [self startAlarm];
                        
                    }
                }
                
                
                
                
            }
        }
    }



}


- (void)updateGPS{
    [self.locationTracker updateLocationToServer];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"error");
    [self gpsAlert:YES];
    
}



- (void)gpsAlert:(BOOL)show{
    if (show) {
        alertGPSisNotAvalible = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                           message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:nil];
        [alertGPSisNotAvalible show];
    }else [alertGPSisNotAvalible dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma alarm

- (void) startAlarm{
    
    [defaults setBool:true forKey:@"alarmStatus"];
    
    [defaults synchronize];
    
    [self.travelView moveToAlarm];
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    localNotification.alertBody = @"Time to wake up!";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [self alarmSound];
    
    
    
    
}

- (void)alarmSound{
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[defaults objectForKey:@"alarmSound"] ofType:@"mp3"]]), &soundID);
    
    AudioServicesAddSystemSoundCompletion(soundID, nil, nil, SoundFinished, nil);
    
    AudioServicesPlayAlertSound(soundID);
}

void SoundFinished (SystemSoundID snd, void* context) {
    [(AppDelegate*)[[UIApplication sharedApplication]delegate] alarmSound];
}

- (void)finishAlarm{
    
    AudioServicesRemoveSystemSoundCompletion(soundID);
    AudioServicesDisposeSystemSoundID(soundID);
}

@end
