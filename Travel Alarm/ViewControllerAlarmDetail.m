//
//  ViewControllerAlarmDetail.m
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 20.09.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import "ViewControllerAlarmDetail.h"

@interface ViewControllerAlarmDetail ()

@end
int distance;
NSMutableArray *alarms;
@implementation ViewControllerAlarmDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.alarmId);
    
    
    alarms = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"alarms"] mutableCopy];
    
    [self.pickerView selectRow:[[alarms objectAtIndex:[self.alarmId integerValue]] integerValue]/100 inComponent:0 animated:NO];
    [self.pickerView selectRow:[[alarms objectAtIndex:[self.alarmId integerValue]] integerValue]%100/10 inComponent:1 animated:NO];
    [self.pickerView selectRow:[[alarms objectAtIndex:[self.alarmId integerValue]] integerValue]%10 inComponent:2 animated:NO];
    [self.label setText:[NSString stringWithFormat:@"%ld km",(long)[[alarms objectAtIndex:[self.alarmId integerValue]] integerValue]]];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0)return 10;
    if (component == 1)return 10;
    if (component == 2)return 10;
    if (component == 3)return 1;
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%ld",(long)row];
            break;
            
        case 1:
            return [NSString stringWithFormat:@"%ld",(long)row];
            break;
            
        case 2:
            return [NSString stringWithFormat:@"%ld",(long)row];
            break;
            
        case 3:
            if (row==0) {
                return @"km";
            }else return @"mile";
            break;
            
        default:
            break;
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    distance = (int)[pickerView selectedRowInComponent:0]*100 + (int)[pickerView selectedRowInComponent:1]*10 + (int)[pickerView selectedRowInComponent:2];
    [self.label setText:[NSString stringWithFormat:@"%d km",distance]];
    
    [alarms replaceObjectAtIndex:[self.alarmId integerValue] withObject:[NSString stringWithFormat:@"%d",distance]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:alarms forKey:@"alarms"];
    
    [defaults synchronize];
}


- (void)bannerViewWillLoadAd:(ADBannerView *)banner{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"statusPRO"]) {
        
        [banner setHidden:false];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
