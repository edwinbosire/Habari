//
//  HNSwitchTableViewCell.m
//  Habari
//
//  Created by edwin bosire on 15/03/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "HNSwitchTableViewCell.h"

@implementation HNSwitchTableViewCell

- (void)awakeFromNib {
    self.titleLabel.textColor = [UIColor asbestosColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
