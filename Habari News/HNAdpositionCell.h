//
//  HNAdpositionCell.h
//  Habari
//
//  Created by edwin bosire on 28/03/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPNativeAdRendering.h"

@interface HNAdpositionCell : UICollectionViewCell <MPNativeAdRendering>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (strong, nonatomic) IBOutlet UIButton *callToActionButton;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;

@end
