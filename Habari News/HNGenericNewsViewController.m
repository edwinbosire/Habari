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
#import "RelativeDateDescriptor.h"
#import "HNNewsDetailViewController.h"
#import "HNDetailViewAnimationController.h"
#import "HNListViewAnimationController.h"

@interface HNGenericNewsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@property (nonatomic) UIActivityIndicatorView *indicator;
@end

static NSString *reusableCellIdentifier = @"reusableNewsCell";

@implementation HNGenericNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *sideMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sideMenuButton setImage:[UIImage imageNamed:@"side_menu_quicklist_icon"] forState:UIControlStateNormal];
    [sideMenuButton setImage:[UIImage imageNamed:@"side_menu_quicklist_icon_selected"] forState:UIControlStateHighlighted];
    [sideMenuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [sideMenuButton sizeToFit];
    sideMenuButton.tintColor = [UIColor midnightBlueColor];
    
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.tintColor = [UIColor midnightBlueColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sideMenuButton];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[HNNewsFlowLayout new]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HNNewsCollectionView" bundle:nil] forCellWithReuseIdentifier:reusableCellIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor cloudsColor];
    
    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)showIndicator:(BOOL)show{
    
    if (!_indicator) {
         _indicator = [[UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.frame = CGRectMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame), 50.0f, 50.0f);
        [_indicator startAnimating];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame) - 70.0f, 300.0f, 50.0f)];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.text = @"Loading News";
        
        [self.view addSubview:_indicator];
        [self.view addSubview:loadingLabel];
    }
}

- (void)setNewsType:(HNNewsType)newsType{
    _newsType = newsType;
     HNClient *client = [HNClient new];
    [client loadNewsFromCacheWithType:newsType completion:^(NSArray *results, NSError *error) {
        if (!error){
            self.latestNews = [NSMutableArray arrayWithArray:results];
            [self.collectionView reloadData];
        }
       
    }];
}

- (void)refresh:(id)sender{
 
    HNClient *client = [HNClient new];
    [client retrieveLatestNewsWithType:_newsType WithcompletionBlock:^(NSArray *results, NSError *error) {
        self.latestNews = [NSMutableArray arrayWithArray:results];
        [self.collectionView reloadData];
        
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self refresh:nil];
}

- (void)showMenu {
    [self.sideMenuViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _latestNews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HNNewsCollectionViewCell *cell = (HNNewsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reusableCellIdentifier forIndexPath:indexPath];
    Article *anArticle = [_latestNews objectAtIndex:indexPath.row];
    [cell setArticle:anArticle];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Article *anArticle = [_latestNews objectAtIndex:indexPath.row];
    
    HNNewsDetailViewController *detailView = [[HNNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
    HNNewsCollectionViewCell *cell = (HNNewsCollectionViewCell *)[collectionView cellForItemAtIndexPath:[collectionView.indexPathsForSelectedItems firstObject]];
    
    detailView.article = anArticle;
//    detailView.placeholderImage = cell.image.image;
    self.selectedCell = cell;
    [self.navigationController pushViewController:detailView animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(300.0f, 300.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
}

#pragma mark - UINavigationController Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if ([fromVC isKindOfClass:[HNGenericNewsViewController class]] && [toVC isKindOfClass:[HNNewsDetailViewController class]])
    {
        return [HNListViewAnimationController new];
    }
    else if ([fromVC isKindOfClass:[HNNewsDetailViewController class]] && [toVC isKindOfClass:[HNGenericNewsViewController class]])
    {
        return [HNDetailViewAnimationController new];
    }
    return nil;

}
#pragma mark - Helper

- (void)setViewControllerTitle:(NSString *)viewControllerTitle{
    
    self.navigationItem.titleView = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 44.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:24];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor midnightBlueColor];
        label.text = viewControllerTitle;
        label;
    });
    
}

@end
