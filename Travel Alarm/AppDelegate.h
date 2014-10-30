//
//  AppDelegate.h
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 31.08.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewControllerTravel.h"
#import "LocationTracker.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewControllerTravel *travelView;

@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

@property (nonatomic) float speed;
@property (nonatomic) int distance;

- (void)alarmSound;
- (void)finishAlarm;
- (void)updateGPS;
- (void)gpsAlert:(BOOL)show;
- (void)locationDataWitLocation:(CLLocationCoordinate2D)location;
- (void)checkGPSPermission;
@end
