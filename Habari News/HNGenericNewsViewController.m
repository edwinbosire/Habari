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

#import "FullScreenView.h"

#import "MRProgress.h"

#import "HNNewsDetailViewController.h"
#import "ZoomInteractiveTransition.h"
#import "ZoomTransitionProtocol.h"

@interface HNGenericNewsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ZoomTransitionProtocol>

@property (nonatomic, strong) ZoomInteractiveTransition * transition;

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sideMenuButton];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[HNNewsFlowLayout new]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HNNewsCollectionView" bundle:nil] forCellWithReuseIdentifier:reusableCellIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor cloudsColor];
    
    [self.view addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:UIApplicationDidBecomeActiveNotification object:nil];

    self.transition = [[ZoomInteractiveTransition alloc] initWithNavigationController:self.navigationController];

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
    
    /*  present artcile view here*/
//    FullScreenView *browser = [[FullScreenView alloc] initWithNibName:nil bundle:nil];
//    [browser newsViewContent:anArticle];

    HNNewsDetailViewController *detailView = [[HNNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailView.article = anArticle;
    [self.navigationController pushViewController:detailView animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(300.0f, 180.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
}
#pragma mark - Helper

- (void)setViewControllerTitle:(NSString *)viewControllerTitle{
    self.title = viewControllerTitle;
}


#pragma mark - View Transition Delegate

- (UIView *)viewForZoomTransition{
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    HNNewsCollectionViewCell * cell = (HNNewsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.image;
}
@end
