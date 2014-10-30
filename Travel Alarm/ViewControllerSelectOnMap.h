//
//  ViewControllerSelectOnMap.h
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 01.09.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewControllerSelectOnMap : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextBtn;
- (IBAction)centerBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *centerBG;

@end
