//
//  HNGenericNewsViewController.m
//  Habari News
//
//  Created by edwin bosire on 16/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNGenericNewsViewController.h"
#import "HNNewsFlowLayout.h"
#import "HNNewsCollectionViewCell.h"
#import "Article.h"
#import "HNNewsDetailViewController.h"
#import "HNDetailViewAnimationController.h"
#import "HNListViewAnimationController.h"
#import "HNSection.h"
#import "HNArticle.h"
#import "HNArticle+Extension.h"
#import "MRProgress.h"
#import "HNNewsNoTitleCell.h"

//Ads
#import "MPServerAdPositioning.h"
#import "MPCollectionViewAdPlacer.h"
#import "MPNativeAdRequestTargeting.h"
#import "MPNativeAdConstants.h"
#import "HNAdpositionCell.h"

NSUInteger const maxRetryCount = 3;
CGFloat const kDefaultItemWidth = 320.0f;
CGFloat const kDefaultItemHeight = 330.0f;
CGFloat const kDefaultImageHeight = 250.0f;

@interface HNGenericNewsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@property (nonatomic) HNSection *sectionItem;
@property (nonatomic) NSUInteger retryCount;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) MPCollectionViewAdPlacer *adPlacer;
@end

static NSString *reusableCellWithImageIdentifier = @"reusableNewsCell";
static NSString *reusableCellWithNoImageIdentifier = @"reusableCellWithNoImageIdentifier";
static NSString *kAdUniID = @"8ce943e5b65a4689b434d72736dbed02";

@implementation HNGenericNewsViewController

- (instancetype)initWithItem:(HNSection *)item
{
    self = [super init];
    if (self) {
        
        self.sectionItem = item;
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    UIButton *sideMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sideMenuButton setImage:[UIImage imageNamed:@"burgerMenu"] forState:UIControlStateNormal];
    [sideMenuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [sideMenuButton sizeToFit];
    sideMenuButton.tintColor = [UIColor redColor];
    
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.tintColor = [UIColor colorFromHexCode:self.sectionItem.secondaryColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sideMenuButton];
    
    self.navigationItem.titleView = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 44.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:24];
        label.textAlignment = NSTextAlignmentRight;
        UIColor *hex = [UIColor colorFromHexCode:self.sectionItem.primaryColor];
        label.textColor = (self.sectionItem.primaryColor)? hex : [UIColor midnightBlueColor];
        label.text = self.sectionItem.title;
        label;
    });
    

    [self.collectionView registerNib:[UINib nibWithNibName:@"HNNewsCollectionView" bundle:nil] forCellWithReuseIdentifier:reusableCellWithImageIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HNNewsNoTitleCell" bundle:nil] forCellWithReuseIdentifier:reusableCellWithNoImageIdentifier];
    
     [self refresh:nil];
    
    //Ads
    
    MPServerAdPositioning *positioning = [[MPServerAdPositioning alloc] init];
    self.adPlacer = [MPCollectionViewAdPlacer placerWithCollectionView:self.collectionView
                                                        viewController:self
                                                         adPositioning:positioning
                                               defaultAdRenderingClass:[HNAdpositionCell class]];
    
    MPNativeAdRequestTargeting *targeting = [MPNativeAdRequestTargeting targeting];
    targeting.desiredAssets = [NSSet setWithObjects:kAdIconImageKey, kAdMainImageKey, kAdCTATextKey, kAdTextKey, kAdTitleKey, nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableAds"]){
        [self.adPlacer loadAdsForAdUnitID:kAdUniID targeting:targeting];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)showIndicator:(BOOL)show{
    
    if (show) {
       MRProgressOverlayView *overlay = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
        overlay.tintColor = [UIColor colorFromHexCode:self.sectionItem.secondaryColor];
    }else{
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
    }
}

- (void)refresh:(id)sender{
    
    [self showIndicator:YES];
    
        if (self.retryCount < maxRetryCount) {
            
            [[HNClient shareClient] retrieveLatestNewsWithSectionItem:self.sectionItem completionBlock:^(NSArray *articles) {
                
                self.retryCount ++;
                
                self.latestNews = [articles copy];
                [self.collectionView reloadData];
                [self showIndicator:NO];
                [self.refreshControl endRefreshing];
            }];
        }
}

- (void)pullToRefresh:(id)sender {
    
    [[HNClient shareClient] retrieveLatestNewsWithSectionItem:self.sectionItem completionBlock:^(NSArray *articles) {
        
        self.retryCount ++;
        
        self.latestNews = [articles copy];
        [self.collectionView reloadData];
        [self showIndicator:NO];
        [self.refreshControl endRefreshing];
    }];

}

- (void)showMenu {
    [self.sideMenuViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.latestNews = nil;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _latestNews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HNArticle *anArticle = [_latestNews objectAtIndex:indexPath.row];

    if (anArticle.largeImage) {
        
        HNNewsCollectionViewCell *cell = (HNNewsCollectionViewCell *)[collectionView mp_dequeueReusableCellWithReuseIdentifier:reusableCellWithImageIdentifier forIndexPath:indexPath];
        [cell setArticle:anArticle];
        return cell;
    }else {
        
        HNNewsNoTitleCell *cell = (HNNewsNoTitleCell *)[collectionView mp_dequeueReusableCellWithReuseIdentifier:reusableCellWithNoImageIdentifier forIndexPath:indexPath];
        [cell setArticle:anArticle];
        return cell;
    }
  
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HNArticle *anArticle = [_latestNews objectAtIndex:indexPath.row];
    
    HNNewsDetailViewController *detailView = [[HNNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
    HNNewsCollectionViewCell *cell = (HNNewsCollectionViewCell *)[collectionView mp_cellForItemAtIndexPath:indexPath];
    
    detailView.article = anArticle;
    self.selectedCell = cell;

    if (!anArticle.largeImage) {
        self.navigationController.delegate = nil;
    }else {
        self.navigationController.delegate = self;
    }
    
    [self.navigationController pushViewController:detailView animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HNArticle *anArticle = [_latestNews objectAtIndex:indexPath.row];
    HNAdpositionCell *cell = (HNAdpositionCell *)[collectionView mp_cellForItemAtIndexPath:indexPath];

    CGSize size;
    if (anArticle.largeImage || [cell isKindOfClass:[HNAdpositionCell class]]) {
        size = CGSizeMake(kDefaultItemWidth, kDefaultItemHeight);
    }else {
        size = CGSizeMake(kDefaultItemWidth, 155.0f);
    }
    return size;
}

#pragma mark - UINavigationController Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if ([fromVC isKindOfClass:[HNGenericNewsViewController class]] && [toVC isKindOfClass:[HNNewsDetailViewController class]]){
        return [HNListViewAnimationController new];
    }
    else if ([fromVC isKindOfClass:[HNNewsDetailViewController class]] && [toVC isKindOfClass:[HNGenericNewsViewController class]]){
        return [HNDetailViewAnimationController new];
    }
    return nil;

}

/**
 *  Creating the parallax effects means moving components with relative speed depending on scroll offset
 *
 */
#pragma mark - UIScrollViewdelegate methods

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    for(HNNewsCollectionViewCell *view in self.collectionView.visibleCells) {
//        CGFloat yOffset = ((self.collectionView.contentOffset.y - view.frame.origin.y) / kDefaultItemHeight) * IMAGE_OFFSET_SPEED;
//        if ([view respondsToSelector:@selector(setImageOffset:)]) {
//            view.imageOffset = CGPointMake(0.0f, yOffset);
//        }
//        
//    }
//}
#pragma mark - Properties

- (void)setPrimaryColor:(UIColor *)primaryColor{
    
    _primaryColor = primaryColor;
    self.navigationController.navigationBar.tintColor = _primaryColor;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[HNNewsFlowLayout new]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor cloudsColor];
        [self.view addSubview:_collectionView];

        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
        [_collectionView addSubview:self.refreshControl];
    }
    return _collectionView;
}
@end
