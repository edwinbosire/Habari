//
//  HNSwitchTableViewCell.h
//  Habari
//
//  Created by edwin bosire on 15/03/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNSwitchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end
