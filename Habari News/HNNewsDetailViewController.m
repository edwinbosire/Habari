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
#import "RelativeDateDescriptor.h"

//Viewcontroller
#import "BrowserViewController.h"

#define kHEADER_IMAGE_HEIGHT 250.0f
#define kSTANDARD_WIDTH  300.0f
#define kBUTTON_HEIGHT 50.0f
#define kANIMATION_OFFSET 100.0f

@interface HNNewsDetailViewController () <UIScrollViewDelegate, UIWebViewDelegate>{
    CGRect headerRect;
}

@property (nonatomic, strong) BrowserViewController *browser;

@end

@implementation HNNewsDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = YES;
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Share-black"] style:UIBarButtonItemStylePlain target:self action:@selector(presentActionSheet:)];
    self.navigationItem.rightBarButtonItem = actionButton;
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeView)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    [self.view addSubview:self.scrollView];
    
    [self setupScrollView];
    
    
    self.navigationItem.titleView = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.font = [UIFont boldSystemFontOfSize: 14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor midnightBlueColor];
        label.text = self.article.title;
        label;
    });
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
              [UIView animateKeyframesWithDuration:0.6f
                                             delay:0.3f
                                           options:UIViewKeyframeAnimationOptionCalculationModeCubic
                                        animations:^{
                                            
                                            self.titleView.alpha = self.authorView.alpha = self.contentView.alpha = self.webButtonView.alpha = 1.0f;

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
    
    self.scrollView.delegate = nil;
    [self.headerView stopOscillating];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    self.headerView = nil;
    self.contentView = nil;
    self.authorView = nil;
    self.titleView = nil;
}

- (void)closeView{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)presentActionSheet:(id)sender{
    
    UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.article.uri] applicationActivities:nil];
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}


- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
            scrollView.backgroundColor = [UIColor cloudsColor];
            scrollView.contentInset = UIEdgeInsetsMake(-10.0f, 0.0f, 0.0f, 0.0f);
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


- (void)setupScrollView {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    self.webButtonView = [[mainBundle loadNibNamed:NSStringFromClass([HNWebButton class]) owner:self options:nil] firstObject];
    
    //set the header
    self.headerView.placeholder = self.placeholderImage;
    self.headerView.article = _article;
    
    //set title
    self.titleView.titleTextView.attributedText = [self.article attributedStringForTitle];
    
    //set author
    self.authorView.authorTextTitle.attributedText = [self.article attributedStringForAuthor];
    
    //set content
//    self.contentView.contentTextView.attributedText = [self.article attributedStringForContent];
    [self.contentView.webview loadHTMLString:self.article.formattedContent baseURL:nil];

    //adjust sizes
    
    CGSize titleSize =  [self.article cellSizeForTitle];
    CGSize authorSize =  [self.article cellSizeForAuthor];
    CGSize contentSize =  self.contentView.webview.scrollView.contentSize;//[self.article cellSizeForContent];
    
    self.headerView.frame = CGRectMake(0.0f, 0.0f, 320.0f, kHEADER_IMAGE_HEIGHT);
    self.titleView.frame = CGRectMake(10.0f, kHEADER_IMAGE_HEIGHT - 20 + kANIMATION_OFFSET, kSTANDARD_WIDTH, titleSize.height+10.0f);
    self.authorView.frame = CGRectMake(10.0f, CGRectGetMaxY(self.titleView.frame), kSTANDARD_WIDTH, authorSize.height);
    self.contentView.frame = CGRectMake(10.0f, CGRectGetMaxY(self.authorView.frame), kSTANDARD_WIDTH, contentSize.height);
    self.webButtonView.frame = CGRectMake(10.0f, CGRectGetMaxY(self.contentView.frame), kSTANDARD_WIDTH, kBUTTON_HEIGHT);
    
    self.titleView.alpha = self.authorView.alpha = self.contentView.alpha = self.webButtonView.alpha = 0.0f;
    self.scrollView.contentSize = [self contentHeight];
    
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.titleView];
    [self.scrollView addSubview:self.authorView];
    [self.scrollView addSubview:self.contentView];
    [self.scrollView addSubview:self.webButtonView];
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
    
    return CGSizeMake(320.0f, (kHEADER_IMAGE_HEIGHT + titleSize.height + authorSize.height + contentSize.height + kBUTTON_HEIGHT + 20.0f));
}

- (void)presentBrowser:(id)sender {
    
    self.browser = [[BrowserViewController alloc] initWithUrls:[NSURL URLWithString:self.article.uri]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.browser];
    [self.navigationController presentViewController:nav animated:YES completion:NULL];
}
#pragma mark - property

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

#pragma - mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat maxStretch = -140.0f;
    
    if (contentOffset.y < maxStretch) {
        [scrollView setContentOffset:CGPointMake(contentOffset.x, maxStretch)];
        return;
    }
    
    CGFloat minY = -54;
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

#pragma mark - webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self position];
}
@end
