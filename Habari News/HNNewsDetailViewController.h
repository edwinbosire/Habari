//
//  HNNewsDetailViewController.h
//  Habari News
//
//  Created by edwin bosire on 27/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Article;
@interface HNNewsDetailViewController : UIViewController

@property (nonatomic, strong) Article *article;
@property (nonatomic, strong) UIImage *placeholderImage;


@end
