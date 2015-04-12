//
//  HNNewsDetailViewController.m
//  Habari News
//
//  Created by edwin bosire on 27/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNNewsDetailViewController.h"

//Flowlayout
#import "SPHGridViewFlowLayout.h"

//Model
#import "Article.h"

//Libs
#import "NSDate+DateTools.h"

//Viewcontroller
#import "BrowserViewController.h"

//Context menu
#import "YALContextMenuTableView.h"
#import "HNContextMenuDelegate.h"

#define kHEADER_IMAGE_HEIGHT 250.0f
#define kHEADER_NO_IMAGE_HEIGHT 0.0f
#define kSTANDARD_WIDTH  300.0f
#define kBUTTON_HEIGHT 50.0f

//static dispatch_once_t presentOnceToken;

@interface HNNewsDetailViewController () <UIScrollViewDelegate, UIWebViewDelegate>{
    CGFloat headerFade;
    CGRect headerRect;
    dispatch_once_t presentOnceToken;
    CGFloat kANIMATION_OFFSET;
}

@property (nonatomic, strong) BrowserViewController *browser;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UIView *transparentNavigationBarView;
@property (nonatomic, strong) UILabel *navigationBarTitle;
@property (nonatomic) UIImageView *navigationBarGradientView;

@property (nonatomic, strong) YALContextMenuTableView *contextMenuTableView;

@end

@implementation HNNewsDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    
    kANIMATION_OFFSET = 100.0f;
    
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

     [self setupScrollView];
    dispatch_once(&presentOnceToken, ^{
        [self presentationAnimation];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [self.scrollView addSubview:self.webButtonView];
        [UIView animateWithDuration:0.4 animations:^{
            self.webButtonView.alpha = 1.0f;
        }];
        
    });
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}

- (void)presentationAnimation {
    
    if (self.article.largeImage) {
        kANIMATION_OFFSET = 100.0f;
    }else{
        kANIMATION_OFFSET = 0.0f;
    }
    
    [UIView animateKeyframesWithDuration:0.6f
                                   delay:0.3f
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  
                                  self.titleView.alpha = self.authorView.alpha = self.contentView.alpha = 1.0f;
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5 animations:^{
                                      self.titleView.frame = CGRectOffset(self.titleView.frame, 0.0f, -kANIMATION_OFFSET);
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.35 animations:^{
                                      self.authorView.frame = CGRectOffset(self.authorView.frame, 0.0f, -kANIMATION_OFFSET);
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.4f relativeDuration:0.25 animations:^{
                                      self.contentView.frame = CGRectOffset(self.contentView.frame, 0.0f, -kANIMATION_OFFSET);
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.0625 animations:^{
                                      self.webButtonView.frame = CGRectOffset(self.webButtonView.frame, 0.0f, -kANIMATION_OFFSET);
                                  }];
                                  
                              } completion:^(BOOL finished) {
                                  
                                 
                                  
                              }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.scrollView.delegate = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    self.headerView = nil;
    self.contentView = nil;
    self.authorView = nil;
    self.titleView = nil;
}

#pragma mark -

- (void)setupNavigationBar {
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.navigationBarView.frame)-1, 320.0f, 1)];
    separator.backgroundColor = [UIColor concreteColor];
    separator.alpha = 0.3f;
    [self.navigationBarView addSubview:separator];
    
    self.navigationBarGradientView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_asset_details_page"]];
    self.navigationBarGradientView.frame = self.transparentNavigationBarView.bounds;
    self.navigationBarGradientView.contentMode = UIViewContentModeScaleToFill;
    [self.transparentNavigationBarView addSubview:self.navigationBarGradientView];
    
    UIButton *buttonShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonShare.frame = CGRectMake(275.0f, 15.0f, 44.0f, 44.0f);
    [buttonShare setImage:[UIImage imageNamed:@"contextMenu"] forState:UIControlStateNormal];
    [buttonShare addTarget:self action:@selector(presentContextMenu:) forControlEvents:UIControlEventTouchUpInside];
    buttonShare.tintColor = self.navigationController.navigationBar.tintColor;
    [self.transparentNavigationBarView addSubview:buttonShare];
    
    UIButton *buttonClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonClose.frame = CGRectMake(10.0f, 15.0f, 44.0f, 44.0f);
    [buttonClose setImage:[UIImage imageNamed:@"closeMenu"] forState:UIControlStateNormal];
    [buttonClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    buttonClose.tintColor = self.navigationController.navigationBar.tintColor;
    [self.transparentNavigationBarView addSubview:buttonClose];
    
    self.navigationBarTitle = [[UILabel alloc] initWithFrame:CGRectMake(44.0f, 20.0f, 232.0f, 44.0f)];
    self.navigationBarTitle.backgroundColor = [UIColor clearColor];
    self.navigationBarTitle.numberOfLines = 2;
    self.navigationBarTitle.font = [UIFont boldSystemFontOfSize: 14.0f];
    self.navigationBarTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationBarTitle.textColor = [UIColor asbestosColor];
    self.navigationBarTitle.text = self.article.title;
    self.navigationBarTitle.alpha = 0.0f;
    self.navigationBarTitle.hidden = YES;
    
    [self.transparentNavigationBarView addSubview:self.navigationBarTitle];
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)closeView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)presentActionSheet:(id)sender{
    
    UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.article.title, self.article.uri] applicationActivities:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)presentContextMenu:(UIBarButtonItem *)sender {
       // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
}

- (void)setupScrollView {
    
    //set the header
    self.headerView.placeholder = self.placeholderImage;
    self.headerView.article = _article;
    
    //set title
    self.titleView.titleTextView.attributedText = [self.article attributedStringForTitle];
    
    //set author
    self.authorView.authorTextTitle.attributedText = [self.article attributedStringForAuthor];
    
    //set content
    [self.contentView.webview loadHTMLString:self.article.formattedContent baseURL:nil];

    //adjust sizes
    
    CGSize titleSize =  [self.article cellSizeForTitle];
    CGSize authorSize =  [self.article cellSizeForAuthor];
    CGSize contentSize =  CGSizeMake(300.0f, 400.0f);//self.contentView.webview.scrollView.contentSize;//[self.article cellSizeForContent];
    
    CGFloat height = kHEADER_IMAGE_HEIGHT;
    if (!self.article.largeImage) {
        self.headerView.alpha = 0.0f;
        height = kHEADER_NO_IMAGE_HEIGHT;
    }
    self.headerView.frame = CGRectMake(0.0f, 0.0f, 320.0f, height);
    self.titleView.frame = CGRectMake(10.0f, CGRectGetHeight(self.headerView.frame) - 20 + kANIMATION_OFFSET, kSTANDARD_WIDTH, titleSize.height+10.0f);
    self.authorView.frame = CGRectMake(10.0f, CGRectGetMaxY(self.titleView.frame), kSTANDARD_WIDTH, authorSize.height);
    self.contentView.frame = CGRectMake(10.0f, CGRectGetMaxY(self.authorView.frame), kSTANDARD_WIDTH, contentSize.height);
    self.webButtonView.frame = CGRectMake(10.0f, CGRectGetMaxY(self.contentView.frame), kSTANDARD_WIDTH, kBUTTON_HEIGHT);
    self.scrollView.contentSize = [self contentHeight];
    
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.titleView];
    [self.scrollView addSubview:self.authorView];
    [self.scrollView addSubview:self.contentView];
    
}

- (void)position {
    
    self.contentView.frame = CGRectMake(10.0f, CGRectGetMinY(self.contentView.frame), kSTANDARD_WIDTH, self.contentView.webview.scrollView.contentSize.height);
    self.webButtonView.frame = CGRectMake(10.0f, CGRectGetMaxY(self.contentView.frame), kSTANDARD_WIDTH, kBUTTON_HEIGHT);
    self.scrollView.contentSize = [self contentHeight];
}

- (CGSize)contentHeight{
    
    CGSize titleSize =  [self.article cellSizeForTitle];
    CGSize authorSize =  [self.article cellSizeForAuthor];
    CGSize contentSize =  self.contentView.webview.scrollView.contentSize;//[self.article cellSizeForContent];
    CGFloat noImagePadding = kHEADER_NO_IMAGE_HEIGHT;
    
    if  (!self.article.largeImage) {
        noImagePadding = 80.0f;
    }
    return CGSizeMake(320.0f, (CGRectGetHeight(self.headerView.frame) + titleSize.height + authorSize.height + contentSize.height + kBUTTON_HEIGHT + noImagePadding + 20.0f));
}

#pragma mark - property

- (UIView *)navigationBarView {
    
    if (!_navigationBarView){
        _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 64.0f)];
        _navigationBarView.backgroundColor = [UIColor cloudsColor];
        _navigationBarView.alpha = 0.0f;
        _navigationBarView.hidden = YES;
        
        [self.view insertSubview:_navigationBarView belowSubview:self.transparentNavigationBarView];
        
        CGFloat height = kHEADER_IMAGE_HEIGHT;
        if (!self.article.largeImage) {
            self.headerView.alpha = 0.0f;
            height = kHEADER_NO_IMAGE_HEIGHT;
        }
        headerFade = height - self.navigationBarView.frame.size.height - 20.0f;
    }
    
    return  _navigationBarView;
}

- (UIView *)transparentNavigationBarView {
    
    if (!_transparentNavigationBarView){
        _transparentNavigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 64.0f)];
        _transparentNavigationBarView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_transparentNavigationBarView];

    }
    return _transparentNavigationBarView;
}

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
            scrollView.backgroundColor = [UIColor cloudsColor];
            scrollView.contentInset = UIEdgeInsetsMake(-20.0f, 0.0f, 0.0f, 0.0f);
            scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);
            scrollView.delegate = self;
            scrollView;
        });
    }
    return _scrollView;
}


- (void)setArticle:(HNArticle *)article{
    
    if (_article == article) {
        return;
    }
    _article = article;
    
}

- (HNHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HNHeaderView class]) owner:self options:nil] firstObject];
    }
    return _headerView;
}

- (HNTitleView *)titleView{
    
    if (!_titleView) {
        _titleView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HNTitleView class]) owner:self options:nil] firstObject];
    }
    return _titleView;
}

- (HNAuthorTextView *)authorView{
    
    if (!_authorView) {
        _authorView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HNAuthorTextView class]) owner:self options:nil] firstObject];

    }
    return _authorView;
}

- (HNContentView *)contentView{
    
    if (!_contentView) {
        _contentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HNContentView class]) owner:self options:nil] firstObject];
        _contentView.webview.delegate = self;
    }
    return _contentView;
}

- (HNWebButton *)webButtonView {
    
    if (!_webButtonView) {
        _webButtonView = [[ [NSBundle mainBundle] loadNibNamed:NSStringFromClass([HNWebButton class]) owner:self options:nil] firstObject];
        _webButtonView.backgroundColor = [UIColor blackColor];
        _webButtonView.alpha = 0.0f;
    }
    
    typeof(self) _weakSelf = self;
    [_webButtonView setOpenInWebBrowserBlock:^{
        [_weakSelf openWebView];
    }];
    return _webButtonView;
}

- (YALContextMenuTableView *)contextMenuTableView {
    
    if (!_contextMenuTableView) {
        _contextMenuTableView = [[HNContextMenuDelegate create] contextMenuView];
    }
    return  _contextMenuTableView;

}
#pragma - mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat maxStretch = -140.0f;
    
    [self scrollViewDidScrollWithOffset:contentOffset.y];
    
    if (contentOffset.y < maxStretch) {
        [scrollView setContentOffset:CGPointMake(contentOffset.x, maxStretch)];
        return;
    }
    
    CGFloat minY = 0.0f;
    headerRect = self.headerView.frame;
    CGFloat deltaY = fabsf(contentOffset.y - minY);
    
    if (contentOffset.y < minY) {
        headerRect.origin.y -= headerRect.origin.y + deltaY;
        self.headerView.frame = headerRect;
    }
    
    //Lets scroll the image once the title has scrolled off it. Gives a nice effect
    minY = (minY - 20);
    deltaY = fabsf(contentOffset.y - minY);
    if (contentOffset.y < minY ) {
        headerRect.size.height = MAX(minY, kHEADER_IMAGE_HEIGHT + deltaY);
        self.headerView.frame = headerRect;
    }
}

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset {
    
    if(scrollOffset > headerFade && self.navigationBarView.alpha == 0.0){ //make the header appear
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.navigationBarView.hidden = NO;
        self.navigationBarTitle.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationBarView.alpha = 1.0f;
            self.navigationBarTitle.alpha = 1.0f;
            self.navigationBarGradientView.alpha = 0.0f;
        }];
    }
    else if(scrollOffset < headerFade && self.navigationBarView.alpha == 1.0){ //make the header disappear
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationBarView.alpha = 0.0f;
            self.navigationBarTitle.alpha = 0.0f;
            self.navigationBarGradientView.alpha = 1.0f;
        } completion: ^(BOOL finished) {
            self.navigationBarView.hidden = YES;
            self.navigationBarTitle.hidden = YES;
            
        }];
    }
}
#pragma mark - webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self performSelector:@selector(position) withObject:nil afterDelay:0.8f]; // allow for presentation before re-adjusting size
}

#pragma mark - open web browser

- (void)openWebView {
    
    BrowserViewController *browser = [[BrowserViewController alloc] initWithUrls:[NSURL URLWithString:self.article.uri]];
    [self.navigationController pushViewController:browser animated:YES];
}
@end
