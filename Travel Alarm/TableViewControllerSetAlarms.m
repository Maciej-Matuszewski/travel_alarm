//
//  TableViewControllerSetAlarms.m
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 01.09.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import "TableViewControllerSetAlarms.h"
#import "TableViewCellAlarmsCell.h"
#import "ViewControllerAlarmDetail.h"
#import "AppDelegate.h"

@interface TableViewControllerSetAlarms ()

@end
AppDelegate *ad;
NSMutableArray *alarms;
NSString *cellType;
int selectedRow;
NSTimer *timer;

@implementation TableViewControllerSetAlarms


- (void)viewDidLoad
{
    [super viewDidLoad];
    cellType = @"alarmsCell";
    selectedRow = 0;
    ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    alarms = [[NSMutableArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [self.distanceLabel setText:[NSString stringWithFormat:@"Distance to target: %ld km",(long)[defaults integerForKey:@"distanceToTarget"]]];
    
    if ([defaults objectForKey:@"alarms"]){
        
        alarms = [[defaults arrayForKey:@"alarms"] mutableCopy];
    }else{
        [alarms addObject:@"30"];
        
        [defaults setObject:alarms forKey:@"alarms"];
        
        [defaults synchronize];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"statusPRO"]) {
        
        [banner setHidden:false];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [alarms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellAlarmsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
    
    cell.clipsToBounds = YES;
    
    [cell.label setText:[NSString stringWithFormat:@"%@ km",[alarms objectAtIndex:indexPath.row]]];
    
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"distanceToTarget"] <= [[alarms objectAtIndex:indexPath.row] integerValue])[cell.label setTextColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.6]];
    
    else [cell.label setTextColor:[UIColor darkGrayColor]];
    
    return cell;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([alarms count]>1) return YES;
    else return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [alarms removeObjectAtIndex:indexPath.row];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:alarms forKey:@"alarms"];
        
        [defaults synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetail" sender:[NSNumber numberWithInteger:indexPath.row]];
}
 
- (IBAction)addAlarmAction:(id)sender {
    if ([alarms count]<3||[[NSUserDefaults standardUserDefaults] boolForKey:@"statusPRO"]) {
        [alarms addObject:@"30"];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[alarms count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:alarms forKey:@"alarms"];
        
        [defaults synchronize];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"If You want to set up more alarms please buy pro version!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 74;
}

#pragma seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        ViewControllerAlarmDetail *vc = [segue destinationViewController];
        
        [vc setAlarmId:sender];
    }
    
    
}
- (IBAction)startBtn:(id)sender {
    BOOL status = true;
    for (int i=0; i<[alarms count]; i++) {
        if ([[alarms objectAtIndex:i] integerValue]>=[[NSUserDefaults standardUserDefaults] integerForKey:@"distanceToTarget"]) {
            status = false;
        }
    }
    if (status) [self performSegueWithIdentifier:@"start" sender:nil];
    else {
        [self.tableView reloadData];
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"Distance to target is shorter than alarm."
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
}
@end
