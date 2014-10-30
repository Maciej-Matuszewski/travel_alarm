//
//  ViewController.h
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 31.08.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController<ADBannerViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *startBtnView;
@property (strong, nonatomic) IBOutlet UIView *settingsBtnView;
@property (strong, nonatomic) IBOutlet UIView *conteinerBtns;
- (IBAction)shareBtn:(id)sender;
@property (strong, nonatomic) IBOutlet ADBannerView *banner;

@end
