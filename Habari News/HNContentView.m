//
//  HNContentCell.m
//  Habari News
//
//  Created by edwin bosire on 27/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNContentView.h"


@implementation HNContentView

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
    self.backgroundColor = [UIColor cloudsColor];
    
}


@end
