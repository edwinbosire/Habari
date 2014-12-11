//
//  HNGenericNewsViewController.h
//  Habari News
//
//  Created by edwin bosire on 16/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "HNClient.h"

@class HNNewsCollectionViewCell;
@class HNSection;

@interface HNGenericNewsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *latestNews;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) HNNewsType newsType;
@property (nonatomic, strong) NSString *viewControllerTitle;
@property (nonatomic) UIColor *primaryColor;
@property (nonatomic) UIColor *secondaryColor;
@property (nonatomic) HNNewsCollectionViewCell *selectedCell;

- (instancetype)initWithItem:(HNSection *)item;

- (void)refresh:(id)sender;

@end
