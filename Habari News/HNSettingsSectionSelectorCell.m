//
//  HNSettingsSectionSelectorCell.m
//  Habari
//
//  Created by edwin bosire on 20/08/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNSettingsSectionSelectorCell.h"
#import "UIColor+FlatUI.h"

@interface HNSettingsSectionSelectorCell ()

@property (nonatomic) UIView *highlightedView;
@end

@implementation HNSettingsSectionSelectorCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.checkmarkImage.tintColor = [UIColor cloudsColor];
    self.titleLabel.textColor = [UIColor cloudsColor];
    self.numberBadge.textColor = [UIColor cloudsColor];
}


@end
