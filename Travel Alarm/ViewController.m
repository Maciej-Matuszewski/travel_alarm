//
//  ViewController.m
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 31.08.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoTextWHITE"]];
    
    self.conteinerBtns.layer.cornerRadius = 20;
    self.conteinerBtns.clipsToBounds = YES;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"status"] == true)[self performSegueWithIdentifier:@"statusON" sender:self];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareBtn:(id)sender {
    NSString *text = @"Travel Alarm when You want to wake up on right place! Check in App Store";
    NSURL *url = [NSURL URLWithString:@"http://imaniac.cba.pl"];
    
    UIActivityViewController *controller =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[text,url]
     applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"statusPRO"]) {
        
        [self.banner setHidden:true];
    }
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"statusPRO"]) {
        
        [banner setHidden:false];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
}
@end
