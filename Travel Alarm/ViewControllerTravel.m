//
//  ViewControllerTravel.m
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 02.09.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import "ViewControllerTravel.h"
#import "AppDelegate.h"

@interface ViewControllerTravel ()

@end

NSUserDefaults *defaults;
int kmLeft;
AppDelegate *ad;
@implementation ViewControllerTravel

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    kmLeft=999999;
    
    [self.view removeConstraints:self.centerView.constraints];
    
    ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [ad.locationTracker startLocationTracking];
    ad.travelView = self;
    [ad updateGPS];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:true forKey:@"status"];
    
    [defaults setInteger:-1 forKey:@"lastAlarm"];
    
    [self.cityName setText:[defaults objectForKey:@"targetTitle"]];
    [self.countryName setText:[defaults objectForKey:@"targetSubtitle"]];
    
    
    
    
    
    [defaults synchronize];

    
    self.view.clipsToBounds = YES;
    self.topView.layer.cornerRadius = 320;
    
    
    [self.bottomView removeFromSuperview];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 640)];
    [self.bottomView setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height+225)];
    
    [self.bottomView setBackgroundColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.20 alpha:0.65]];
    
    [self.view addSubview:self.bottomView];
    
    
    self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width/2-160, 0, 320, 68)];
    [self.speedLabel setTextColor:[UIColor whiteColor]];
    [self.speedLabel setFont:[UIFont boldSystemFontOfSize:40.0]];
    [self.speedLabel setTextAlignment:NSTextAlignmentCenter];
    [self.speedLabel setText:@"0 km/h"];
    
    
    [self.bottomView addSubview:self.speedLabel];
    
    
    self.etaLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width/2-160, 53, 320, 43)];
    [self.etaLabel setTextColor:[UIColor whiteColor]];
    [self.etaLabel setFont:[UIFont systemFontOfSize:20.0]];
    [self.etaLabel setTextAlignment:NSTextAlignmentCenter];
    [self.etaLabel setText:@"ETA: 0h 0min"];
    
    
    
    
    [self.bottomView addSubview:self.etaLabel];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width/2-self.view.frame.size.width/2, 100, self.view.frame.size.width, self.view.frame.size.height-130)];
    self.mapView.layer.cornerRadius = 10;
    self.mapView.showsUserLocation = YES;
    
    
    CLLocationCoordinate2D myCoordinate = {[defaults floatForKey:@"targetLatitude"], [defaults floatForKey:@"targetLongitude"]};
    //Create your annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    // Set your annotation to point at your coordinate
    point.coordinate = myCoordinate;
    //If you want to clear other pins/annotations this is how to do it
    for (id annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    //Drop pin on map
    [self.mapView addAnnotation:point];
    
    [self.bottomView addSubview:self.mapView];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    
    
    
    
    
    
    
    
    
    self.bottomView.layer.cornerRadius = 320;
    
    [self.centerView removeFromSuperview];
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(30, 154, 260, 260)];
    [self.centerView setCenter:self.view.center];
    [self.centerView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.75 blue:0.0 alpha:0.85]];
    
    
    self.alarmBell = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alarmBell"]];
    [self.alarmBell setFrame:CGRectMake(self.centerView.frame.size.width/2-65, self.centerView.frame.size.height/2-85, 130, 130)];
    
    [self.centerView addSubview:self.alarmBell];
    
    self.alarmDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.centerView.frame.size.width/2-115, self.centerView.frame.size.height/2+60, 230, 23)];
    [self.alarmDistanceLabel setText:@"Waiting for GPS"];
    self.alarmDistanceLabel.textAlignment = NSTextAlignmentCenter;
    self.alarmDistanceLabel.textColor=[UIColor whiteColor];
    
    [self.centerView addSubview:self.alarmDistanceLabel];
    
    
    self.alarmCheckBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.centerView.frame.size.width/2-100, self.centerView.frame.size.height+20, 200, 200)];
    [self.alarmCheckBtn setImage:[UIImage imageNamed:@"alarmCheck"] forState:UIControlStateNormal];
    
    [self.alarmCheckBtn addTarget:self action:@selector(alarmCheckBtnAction:) forControlEvents:UIControlEventTouchDown];
    
    [self.centerView addSubview:self.alarmCheckBtn];
    
    
    self.centerView.layer.cornerRadius = self.centerView.frame.size.width/2;
    
    self.centerView.clipsToBounds = YES;
    
    [self.view insertSubview:self.centerView belowSubview:self.topView];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIPanGestureRecognizer * panGestureTop = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveObjectTop:)];
    panGestureTop.minimumNumberOfTouches = 1;
    [self.topView addGestureRecognizer:panGestureTop];
    
    
    UIPanGestureRecognizer * panGestureBottom = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveObjectBottom:)];
    panGestureBottom.minimumNumberOfTouches = 1;
    [self.bottomView addGestureRecognizer:panGestureBottom];
    
    
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)moveObjectTop:(UIPanGestureRecognizer *)pan;
{
    if(pan.state == UIGestureRecognizerStateBegan){
        [UIView animateWithDuration:0.2 animations:^{
            self.topView.center = CGPointMake(self.topView.center.x,-83);
        } completion:nil];
    }
    
    CGPoint translation = [pan translationInView:self.topView.superview];
    if(translation.y>0 && translation.y<193)self.topView.center = CGPointMake(self.topView.center.x,-83+translation.y);
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            if (translation.y>170) self.topView.center = CGPointMake(self.topView.center.x,-83+194);
            else self.topView.center = CGPointMake(self.topView.center.x,-83);
        } completion:nil];
    }
}

-(void)moveObjectBottom:(UIPanGestureRecognizer *)pan;
{
    
    
    if(pan.state == UIGestureRecognizerStateBegan){
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomView.center = CGPointMake(self.bottomView.center.x,self.view.frame.size.height+225);
        } completion:nil];
    }
    CGPoint translation = [pan translationInView:self.bottomView.superview];
    NSLog(@"%f",translation.y);
    if(translation.y<0 && translation.y>-360)self.bottomView.center = CGPointMake(self.bottomView.center.x,self.view.frame.size.height+225+translation.y);
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            if (translation.y<-170){
                self.bottomView.center = CGPointMake(self.bottomView.center.x,self.view.frame.size.height+65-194);
                [self.bottomView setBackgroundColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.20 alpha:1.0]];
                [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
            }
            else{
                self.bottomView.center = CGPointMake(self.bottomView.center.x,self.view.frame.size.height+225);
                [self.bottomView setBackgroundColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.20 alpha:0.65]];
            }
        } completion:nil];
    }
}

- (IBAction)alarmCheckBtnAction:(id)sender {
    
    [defaults setBool:false forKey:@"alarmStatus"];
    
    
    
    [defaults synchronize];
    
    [(AppDelegate *)[[UIApplication sharedApplication]delegate] finishAlarm];
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.8 animations:^{
            
            [self.centerView setFrame:CGRectMake(self.centerView.frame.origin.x, self.centerView.frame.origin.y+125, self.centerView.frame.size.width, self.centerView.frame.size.height-250)];
            [self.topView setHidden:false];
            [self.bottomView setHidden:false];
            
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
            [self.topView setAlpha:1.0];
            
            [self.bottomView setAlpha:1.0];
            
            
        }];
        
    } completion:^(BOOL finished){
        if (kmLeft==0) {
            
            [defaults setBool:false forKey:@"status"];
            
            [defaults synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    
}

- (void)moveToAlarm{
    
    
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.8 animations:^{
            
            [self.centerView setFrame:CGRectMake(self.centerView.frame.origin.x, self.centerView.frame.origin.y-125, self.centerView.frame.size.width, self.centerView.frame.size.height+250)];
            
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
            [self.topView setAlpha:0.0];
            [self.bottomView setAlpha:0.0];
            
            
        }];
        
    } completion:^(BOOL finished){
        
        [self.topView setHidden:false];
        [self.bottomView setHidden:false];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)stopBtn:(id)sender {
    [defaults setBool:false forKey:@"status"];
    
    [defaults synchronize];
    [ad.locationTracker stopLocationTracking];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)update:(int)distance speed:(int)speed eta:(NSString *)eta{
    kmLeft = distance;
    if (kmLeft !=0)[self.alarmDistanceLabel setText:[NSString stringWithFormat:@"%d km to destination",distance]];
    else [self.alarmDistanceLabel setText:@"You are on the place!"];
    [self.speedLabel setText:[NSString stringWithFormat:@"%d km/h",speed]];
    [self.etaLabel setText:[NSString stringWithFormat:@"ETA: %@",eta]];
}
@end
