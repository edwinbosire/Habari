//
//  HNNewsCollectionViewCell.h
//  Habari News
//
//  Created by edwin bosire on 18/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_HEIGHT 300
#define IMAGE_OFFSET_SPEED 15

@class HNArticle;

@interface HNNewsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;

//Data
@property (strong, nonatomic) HNArticle *article;

/*
 Image will always animate according to the imageOffset provided. Higher the value means higher offset for the image
 */
@property (nonatomic, assign, readwrite) CGPoint imageOffset;

@end
