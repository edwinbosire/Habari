//
//  HNButtonTableViewCell.m
//  Habari
//
//  Created by edwin bosire on 15/03/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "HNButtonTableViewCell.h"

@implementation HNButtonTableViewCell

- (void)awakeFromNib {
    
    self.clearCacheButton.backgroundColor = [UIColor wetAsphaltColor];
    self.clearCacheButton.layer.cornerRadius = 5.0f;
    self.clearCacheButton.layer.masksToBounds = YES;
    self.clearCacheButton.tintColor = [UIColor cloudsColor];
    
    self.feedbackButton.backgroundColor = [UIColor wetAsphaltColor];
    self.feedbackButton.layer.cornerRadius = 5.0f;
    self.feedbackButton.layer.masksToBounds = YES;
    self.feedbackButton.tintColor = [UIColor cloudsColor];

    self.donateButton.backgroundColor = [UIColor wetAsphaltColor];
    self.donateButton.layer.cornerRadius = 5.0f;
    self.donateButton.layer.masksToBounds = YES;
    self.donateButton.tintColor = [UIColor cloudsColor];
    
    NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    self.versionLabel.textColor = [UIColor silverColor];
    self.versionLabel.text = [NSString stringWithFormat:@"%@  Version %@", bundleName, versionNumber];


}

- (IBAction)clearCacheSelected:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(clearCache:)]) {
        [self.delegate clearCache:sender];
    }
}

- (IBAction)feedback:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(presentFeedBackSheet:)]) {
        [self.delegate presentFeedBackSheet:sender];
    }
}

- (IBAction)donate:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(presentDonateSheet:)]) {
        [self.delegate presentDonateSheet:sender];
    }
}

@end
