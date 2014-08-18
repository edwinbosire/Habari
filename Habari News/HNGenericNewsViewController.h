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
@interface HNGenericNewsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *latestNews;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) HNNewsType newsType;
@property (nonatomic, strong) NSString *viewControllerTitle;

@property (nonatomic) HNNewsCollectionViewCell *selectedCell;

- (void)refresh:(id)sender;

@end
