//
//  TableViewControllerSetAlarms.h
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 01.09.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <iAd/iAd.h>

@interface TableViewControllerSetAlarms : UIViewController<UITableViewDataSource, UITableViewDelegate,ADBannerViewDelegate>

- (IBAction)addAlarmAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
- (IBAction)startBtn:(id)sender;

@end
