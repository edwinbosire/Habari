//
//  HNNewsDetailViewController.h
//  Habari News
//
//  Created by edwin bosire on 27/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>

//SubViews
#import "HNHeaderView.h"
#import "HNTitleView.h"
#import "HNAuthorTextView.h"
#import "HNContentView.h"
#import "HNWebButton.h"

@class HNArticle;
@class HNHeaderView;
@interface HNNewsDetailViewController : UIViewController

@property (nonatomic, strong) HNArticle *article;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic) HNHeaderView *headerView;
@property (nonatomic) HNTitleView *titleView;
@property (nonatomic) HNAuthorTextView *authorView;
@property (nonatomic) HNContentView *contentView;
@property (nonatomic) HNWebButton *webButtonView;
@end
