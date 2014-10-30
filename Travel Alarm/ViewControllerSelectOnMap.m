//
//  ViewControllerSelectOnMap.m
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 01.09.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import "ViewControllerSelectOnMap.h"
#import "AppDelegate.h"

@interface ViewControllerSelectOnMap ()

@property (strong, nonatomic) MKPointAnnotation *point;

@end

@implementation ViewControllerSelectOnMap{
    MKLocalSearch *localSearch;
    MKLocalSearchResponse *results;
}

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
    self.centerBG.layer.cornerRadius = 5;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:0.4]];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
        [(AppDelegate*)[[UIApplication sharedApplication]delegate] gpsAlert:YES];
    } else {
        CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
        locationManager.delegate = self;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [locationManager requestAlwaysAuthorization];
            
            
            
        }
    }

    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] checkGPSPermission];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma maps pines

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    self.point = [[MKPointAnnotation alloc] init];
    
    self.point.coordinate = touchMapCoordinate;
    for (id annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    [self getAddressFromLatLon:self.point.coordinate.latitude withLongitude:self.point.coordinate.longitude];
    
    
    [self.mapView addAnnotation:self.point];
    [self.nextBtn setEnabled:YES];
}


- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id) annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"myPin"] ; } else { pin.annotation = annotation;
        }
    
    pin.animatesDrop = YES;
    pin.draggable = YES;
    
    pin.canShowCallout = YES;
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        [annotationView.annotation setCoordinate:droppedAt];
        
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
        [self getAddressFromLatLon:self.point.coordinate.latitude withLongitude:self.point.coordinate.longitude];
    }
    
}

- (void)getAddressFromLatLon:(float)pdblLatitude withLongitude:(float)pdblLongitude
{
    
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:pdblLatitude longitude:pdblLongitude];
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         
         [defaults setFloat:pdblLatitude forKey:@"targetLatitude"];
         [defaults setFloat:pdblLongitude forKey:@"targetLongitude"];
         [defaults setObject:placemark.locality forKey:@"targetTitle"];
         [defaults setObject:placemark.country forKey:@"targetSubtitle"];
         
         
         int distanceInInt = (int)roundf([[[CLLocation alloc] initWithLatitude:pdblLatitude longitude:pdblLongitude] distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude]]/1000-0.5);
         
         [defaults setInteger:distanceInInt forKey:@"distanceToTarget"];
         
         [defaults synchronize];
         
         
         
         
         [self.point setTitle:[NSString stringWithFormat:@"%@",placemark.name]];
         [self.point setSubtitle:[NSString stringWithFormat:@"%@, %@",placemark.locality , placemark.country]];
         [self.mapView selectAnnotation:self.point animated:YES];
     }
     ];
}

#pragma Table View Metods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [results.mapItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *IDENTIFIER = @"SearchResultsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
    }
    
    
    [cell setBackgroundColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:0.4]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    MKMapItem *item = results.mapItems[indexPath.row];
    
    cell.textLabel.text = item.name;
    
    if (![item.placemark.addressDictionary[@"Street"] isEqualToString:@"(null"])cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@",item.placemark.addressDictionary[@"Street"],item.placemark.addressDictionary[@"City"],item.placemark.addressDictionary[@"Country"]];
    else cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",item.placemark.addressDictionary[@"City"],item.placemark.addressDictionary[@"Country"]];
    
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",item.name,item.placemark.addressDictionary[@"Country"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@",item.placemark.addressDictionary[@"Street"],item.placemark.addressDictionary[@"City"],item.placemark.addressDictionary[@"Country"]];
    //item.placemark.addressDictionary[@"Street"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchDisplayController setActive:NO animated:YES];
    
    MKMapItem *item = results.mapItems[indexPath.row];
    [self.mapView addAnnotation:item.placemark];
    [self.mapView selectAnnotation:item.placemark animated:YES];
    
    [self.mapView setCenterCoordinate:item.placemark.location.coordinate animated:YES];
    
    
    self.point = [[MKPointAnnotation alloc] init];
    
    self.point.coordinate = item.placemark.coordinate;
    for (id annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    
    [self getAddressFromLatLon:self.point.coordinate.latitude withLongitude:self.point.coordinate.longitude];
    
    [self.mapView addAnnotation:self.point];
    [self.nextBtn setEnabled:YES];
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    
    
}



#pragma Search metods


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [localSearch cancel];
    if (searchString.length>0) {
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = searchString;
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        localSearch = [[MKLocalSearch alloc] initWithRequest:request];
        
        [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            
            
            if ([response.mapItems count] == 0) {
                return;
            }
            
            
            results = response;
            
            [self.searchDisplayController.searchResultsTableView reloadData];
        }];
    }
    

    
    
    
    
    
    
    return YES;
}

- (IBAction)centerBtnAction:(id)sender {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}
@end
