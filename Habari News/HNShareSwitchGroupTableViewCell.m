//
//  HNShareSwitchGroupTableViewCell.m
//  Habari
//
//  Created by edwin bosire on 15/03/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "HNShareSwitchGroupTableViewCell.h"

@interface HNShareSwitchGroupTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *twitterTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *facebookTitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *facebookSwitch;

@end
@implementation HNShareSwitchGroupTableViewCell

- (void)awakeFromNib {
   self.twitterTitleLabel.textColor = [UIColor asbestosColor];
    self.facebookTitleLabel.textColor = [UIColor asbestosColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
