//
//  HNNewsCollectionViewCell.h
//  Habari News
//
//  Created by edwin bosire on 18/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNArticle;

@interface HNNewsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;

//Data
@property (strong, nonatomic) HNArticle *article;

@end
