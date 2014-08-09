//
//  HNNewsDetailViewController.m
//  Habari News
//
//  Created by edwin bosire on 27/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNNewsDetailViewController.h"

//Cells
#import "HNHeaderReusableView.h"
#import "HNTitleCell.h"
#import "HNAuthorCell.h"
#import "HNContentCell.h"
#import "HNWebButton.h"

//Flowlayout
#import "SPHGridViewFlowLayout.h"

//Model
#import "Article.h"

//Libs
#import "RelativeDateDescriptor.h"

//Viewcontroller
#import "BrowserViewController.h"

#import "ZoomTransitionProtocol.h"


#define HEADER_TITLE 0
#define AUTHOR_CELL 1
#define CONTENT_CELL 2

#define kHEADER_IMAGE_HEIGHT 250.0f

static NSString *const headerReusableCell = @"headerReusableCell";
static NSString *const titleReusableCell = @"titleReusableCell";
static NSString *const authorReusableCell = @"authorReusableCell";
static NSString *const contentReusableCell = @"contentReusableCell";
static NSString *const webButtonReusableCell = @"webButtonReusableCell";

@interface HNNewsDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) BrowserViewController *browser;
@end

@implementation HNNewsDetailViewController

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
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.alpha = 0.95f;
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(presentActionSheet:)];
    self.navigationItem.rightBarButtonItem = actionButton;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[SPHGridViewFlowLayout new]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor cloudsColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HNHeaderReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusableCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HNTitleCell class]) bundle:nil] forCellWithReuseIdentifier:titleReusableCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HNAuthorCell class]) bundle:nil] forCellWithReuseIdentifier:authorReusableCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HNContentCell class]) bundle:nil] forCellWithReuseIdentifier:contentReusableCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HNWebButton class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:webButtonReusableCell];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(-10.0f, 0.0f, 0.0f, 0.0f);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentActionSheet:(id)sender{
    
    UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.article.url] applicationActivities:nil];
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

#pragma mark - UICollectionView
- (UICollectionReusableView *)collectionView:(UICollectionView *)cv viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader){
      
        HNHeaderReusableView *header = (HNHeaderReusableView *)[cv dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerReusableCell forIndexPath:indexPath];
        [header.headerImage setImageWithURL:self.article.largeImage placeholderImage:self.placeholderImage];
        RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
        
        NSString *timestamp = [descriptor describeDate:self.article.published relativeTo:[NSDate date]];
        NSString *publisher = nil;
        if ([self.article.url.host isEqualToString:@"www.nation.co.ke"]) {
            publisher = @"Nation Media";
        }else{
            publisher = @"Standard";
        }
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentRight;
        
        NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
        NSAttributedString *timeStringAttr  = [[NSAttributedString alloc] initWithString:timestamp attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f], NSForegroundColorAttributeName:[UIColor concreteColor], NSParagraphStyleAttributeName: paraStyle}];
        NSAttributedString *separatorStringAttr  = [[NSAttributedString alloc] initWithString:@" | " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f], NSForegroundColorAttributeName:[UIColor wetAsphaltColor]}];
        NSAttributedString *publisherStringAttr  = [[NSAttributedString alloc] initWithString:publisher attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f], NSForegroundColorAttributeName:[UIColor cloudsColor], NSParagraphStyleAttributeName: paraStyle}];
        [mutableAttr appendAttributedString:publisherStringAttr];
        [mutableAttr appendAttributedString:separatorStringAttr];
        [mutableAttr appendAttributedString:timeStringAttr];
        
        header.textView.attributedText = mutableAttr;
        [header setNeedsDisplay];
        
        return header;
    }else if (kind == UICollectionElementKindSectionFooter){
        
        HNWebButton *webButtonFooter = (HNWebButton *)[cv dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:webButtonReusableCell forIndexPath:indexPath];
        [webButtonFooter.webViewButton addTarget:self action:@selector(presentBrowser:) forControlEvents:UIControlEventTouchUpInside];
        
        return webButtonFooter;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return CONTENT_CELL + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case HEADER_TITLE:{
            HNTitleCell *titleCell = (HNTitleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:titleReusableCell forIndexPath:indexPath];
            titleCell.titleTextView.attributedText = [self.article attributedStringForTitle];
            return titleCell;
        }
            break;
        case AUTHOR_CELL:{
            HNAuthorCell *authorCell = (HNAuthorCell *)[collectionView dequeueReusableCellWithReuseIdentifier:authorReusableCell forIndexPath:indexPath];
            authorCell.authorTextTitle.attributedText = [self.article attributedStringForAuthor];
            return authorCell;
        }
            break;
        default:{
            HNContentCell *contentCell = (HNContentCell *)[collectionView dequeueReusableCellWithReuseIdentifier:contentReusableCell forIndexPath:indexPath];
            contentCell.contentTextView.attributedText = [self.article attributedStringForContent];
            return contentCell;
        }
            
            break;
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case HEADER_TITLE:{
            return [self.article cellSizeForTitle];
        }
            break;
        case AUTHOR_CELL:{
            return  [self.article cellSizeForAuthor];
        }
        case CONTENT_CELL:{
            return [self.article cellSizeForContent];
        }

    }
    return CGSizeZero;
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(320.0f, kHEADER_IMAGE_HEIGHT);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(300.0f, 70.0f);
}

- (void)presentBrowser:(id)sender{
    self.browser = [[BrowserViewController alloc] initWithUrls:self.article.url];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.browser];
    [self.navigationController presentViewController:nav animated:YES completion:NULL];
}

- (UIView *)viewForZoomTransition{
    HNHeaderReusableView * cell = (HNHeaderReusableView *)[self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusableCell forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

    return cell.headerImage;
}
@end
