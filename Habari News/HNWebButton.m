//
//  HNWebButton.m
//  Habari News
//
//  Created by edwin bosire on 30/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNWebButton.h"

@interface HNWebButton ()

@end

@implementation HNWebButton

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
    self.webViewButton.backgroundColor =  [UIColor silverColor];
    
}
- (IBAction)openInWeb:(id)sender {
    
    if (self.openInWebBrowserBlock) {
        self.openInWebBrowserBlock();
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
