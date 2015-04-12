//
//  HNAdpositionCell.m
//  Habari
//
//  Created by edwin bosire on 28/03/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "HNAdpositionCell.h"

#define kNativeAdCellHeight 250
@implementation HNAdpositionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutAdAssets:(MPNativeAd *)adObject
{
    [adObject loadTitleIntoLabel:self.titleLabel];
    [adObject loadTextIntoLabel:self.mainTextLabel];
    [adObject loadCallToActionTextIntoLabel:self.callToActionButton.titleLabel];
    [adObject loadIconIntoImageView:self.iconImageView];
    [adObject loadImageIntoImageView:self.mainImageView];
}

+ (CGSize)sizeWithMaximumWidth:(CGFloat)maximumWidth
{
    return CGSizeMake(maximumWidth, kNativeAdCellHeight);
}

// You MUST implement this method if YourNativeAdCell uses a nib
+ (UINib *)nibForAd
{
    return [UINib nibWithNibName:@"HNAdpositionCell" bundle:nil];
}
@end
