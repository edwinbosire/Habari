//
//  HNSettingsSlider.m
//  Habari
//
//  Created by edwin bosire on 20/08/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNSettingsFontSizeCell.h"

typedef NS_OPTIONS(NSInteger, FontSizeButton) {
    FontSizeButtonSmallest = 0,
    FontSizeButtonMedium,
    FontSizeButtonLargest = 2
};

@implementation HNSettingsFontSizeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self setBackgroundColorForButton:self.mediumFontButton];
    [self setBackgroundColor:[UIColor pomegranateColor]];
}

- (IBAction)smallestFontSelected:(id)sender {
    
    [self setBackgroundColorForButton:sender];
}


- (IBAction)mediumFontSelected:(id)sender {
    
    [self setBackgroundColorForButton:sender];
}

- (IBAction)largeFontSelected:(id)sender {
    
    [self setBackgroundColorForButton:sender];
}

- (void)setBackgroundColorForButton:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case FontSizeButtonSmallest:{
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.smallFontButton.backgroundColor = [UIColor carrotColor];
                                 self.mediumFontButton.backgroundColor = self.largeFontButton.backgroundColor = [UIColor pumpkinColor];
                             }];
            
            break;
        }
        case FontSizeButtonMedium:{
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.mediumFontButton.backgroundColor = [UIColor carrotColor];
                                 self.largeFontButton.backgroundColor = self.smallFontButton.backgroundColor = [UIColor pumpkinColor];
                             }];
            break;
        }
        case FontSizeButtonLargest:{
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.largeFontButton.backgroundColor = [UIColor carrotColor];
                                 self.mediumFontButton.backgroundColor = self.smallFontButton.backgroundColor = [UIColor pumpkinColor];
                             }];
            break;
        }
        default:
            break;
    }
    
}


@end
