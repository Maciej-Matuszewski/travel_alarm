//
//  ViewControllerAlarmDetail.h
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 20.09.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewControllerAlarmDetail : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,ADBannerViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong,nonatomic) NSNumber * alarmId;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;


@end
