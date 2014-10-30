//
//  TableViewControllerSettings.m
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 20.09.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import "TableViewControllerSettings.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TableViewControllerSettings ()

@end

SystemSoundID soundID;
NSUserDefaults *defaults;
@implementation TableViewControllerSettings

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"alarmSound"] isEqualToString:@"alarm_000"])[self.soundCell1 setAccessoryType:UITableViewCellAccessoryCheckmark];
    else if ([[defaults objectForKey:@"alarmSound"] isEqualToString:@"alarm_001"])[self.soundCell2 setAccessoryType:UITableViewCellAccessoryCheckmark];
    else if ([[defaults objectForKey:@"alarmSound"] isEqualToString:@"alarm_002"])[self.soundCell3 setAccessoryType:UITableViewCellAccessoryCheckmark];
    self.productID = @"travel_alarmUpgradeToPro";
    [self getProductID];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"statusPRO"]){
        [self.buyCell.textLabel setText:@"Purchased"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AudioServicesDisposeSystemSoundID(soundID);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            if ([defaults boolForKey:@"statusPRO"]) {
                switch (indexPath.row) {
                    case 0:{
                        
                        [defaults setObject:@"alarm_000" forKey:@"alarmSound"];
                        
                        [defaults synchronize];
                        
                        AudioServicesDisposeSystemSoundID(soundID);
                        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"alarm_000" ofType:@"mp3"]]), &soundID);
                        
                        
                        AudioServicesPlayAlertSound(soundID);
                        
                        [self.soundCell1 setAccessoryType:UITableViewCellAccessoryCheckmark];
                        [self.soundCell2 setAccessoryType:UITableViewCellAccessoryNone];
                        [self.soundCell3 setAccessoryType:UITableViewCellAccessoryNone];
                        
                        
                        
                        break;
                    }
                    case 1:
                        [defaults setObject:@"alarm_001" forKey:@"alarmSound"];
                        
                        [defaults synchronize];
                        
                        AudioServicesDisposeSystemSoundID(soundID);
                        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"alarm_001" ofType:@"mp3"]]), &soundID);
                        
                        
                        AudioServicesPlayAlertSound(soundID);
                        
                        [self.soundCell1 setAccessoryType:UITableViewCellAccessoryNone];
                        [self.soundCell2 setAccessoryType:UITableViewCellAccessoryCheckmark];
                        [self.soundCell3 setAccessoryType:UITableViewCellAccessoryNone];
                        
                        
                        
                        break;
                    case 2:
                        
                        [defaults setObject:@"alarm_002" forKey:@"alarmSound"];
                        
                        [defaults synchronize];
                        
                        AudioServicesDisposeSystemSoundID(soundID);
                        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"alarm_002" ofType:@"mp3"]]), &soundID);
                        
                        
                        AudioServicesPlayAlertSound(soundID);
                        
                        
                        [self.soundCell1 setAccessoryType:UITableViewCellAccessoryNone];
                        [self.soundCell2 setAccessoryType:UITableViewCellAccessoryNone];
                        [self.soundCell3 setAccessoryType:UITableViewCellAccessoryCheckmark];
                        
                        
                        
                        break;
                        
                    default:
                        break;
                }

            }else{
                [[[UIAlertView alloc] initWithTitle:@"Error!"
                                            message:@"If You want to set up another sounds please buy pro version!"
                                           delegate:nil
                                  cancelButtonTitle:@"ok"
                                  otherButtonTitles:nil] show];
            }
                        break;
        case 1:
            
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"statusPRO"]) {
                switch (indexPath.row) {
                    case 0:{
                        
                        SKPayment *payment = [SKPayment paymentWithProduct:_product];
                        [[SKPaymentQueue defaultQueue] addPayment:payment];
                        
                        break;
                    }
                    case 1:{
                        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
                        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
                        
                        break;
                    }
                        
                    default:
                        break;
                }
            }
            
            
            break;
        case 2:{
            NSLog(@"mail");
            NSString *url = @"mailto:gr3mlin106@gmail.com?subject=Travel%20Alarm";
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
            
            break;
        }
        default:
            break;
    }
}


#pragma payments

- (void)getProductID{
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.productID]];
        request.delegate =self;
        
        [request start];
    }else{
        
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"Please enable payments in your settings!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSArray *products = response.products;
    
    if (products.count !=0) {
        _product = products[0];
        
    }else NSLog(@"product not found");
    
    products = response.invalidProductIdentifiers;
    for ( SKProduct *product in products) {
        NSLog(@"Product not Found: %@",product);
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions) {
        
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [self UnlockPurchase];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }else if (transaction.transactionState == SKPaymentTransactionStateFailed){
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
        
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    [self UnlockPurchase];
    
}

-(void)UnlockPurchase{
    
    [defaults setBool:true forKey:@"statusPRO"];
    [self.buyCell.textLabel setText:@"Purchased"];
    
    [defaults synchronize];
    [[[UIAlertView alloc] initWithTitle:@"Success!"
                                message:@"Thank You for purchase!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    
    
    
}
@end
