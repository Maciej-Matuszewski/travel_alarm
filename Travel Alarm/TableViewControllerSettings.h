//
//  TableViewControllerSettings.h
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 20.09.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface TableViewControllerSettings : UITableViewController<SKPaymentTransactionObserver,SKProductsRequestDelegate>


@property (strong, nonatomic) IBOutlet UITableViewCell *soundCell1;

@property (strong, nonatomic) IBOutlet UITableViewCell *soundCell2;

@property (strong, nonatomic) IBOutlet UITableViewCell *soundCell3;

@property (strong, nonatomic) SKProduct *product;

@property (strong, nonatomic) NSString *productID;

@property (strong, nonatomic) IBOutlet UITableViewCell *buyCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *restoreCell;

@end
