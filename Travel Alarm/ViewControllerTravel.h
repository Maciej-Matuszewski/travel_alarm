//
//  ViewControllerTravel.h
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 02.09.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewControllerTravel : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *centerView;
- (IBAction)stopBtn:(id)sender;


@property (strong, nonatomic) IBOutlet UIImageView *alarmBell;
@property (strong, nonatomic) IBOutlet UIButton *alarmCheckBtn;
@property (strong, nonatomic) IBOutlet UILabel *alarmDistanceLabel;

- (IBAction)alarmCheckBtnAction:(id)sender;

- (void)moveToAlarm;

@property (strong, nonatomic) IBOutlet UILabel *cityName;
@property (strong, nonatomic) IBOutlet UILabel *countryName;

@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) IBOutlet UILabel *etaLabel;

- (void)update:(int)distance speed:(int)speed eta:(NSString *)eta;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
