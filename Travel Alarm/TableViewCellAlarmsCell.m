//
//  TableViewCellAlarmsCell.m
//  Travel Alarm
//
//  Created by Maciej Matuszewski on 01.09.2014.
//  Copyright (c) 2014 Maciej Matuszewski. All rights reserved.
//

#import "TableViewCellAlarmsCell.h"
#import "TableViewControllerSetAlarms.h"

@implementation TableViewCellAlarmsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
