/*
 */
//
//  FullScreenView.m
//  FlipView
//
//  Created by Edwin Bosire on 26/02/12.

//
#import "FullScreenView.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


#define NOTIFICATION_DISPLAY_TAG 100
#define kMargin 0
#define kEMAIL [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"feedback" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil]
#define kSUPPORT_EMAIL @"dev@edwinb.co.uk"
#define kAppId @"237744553004370"

//237744553004370


@implementation FullScreenView
@synthesize
fullcontent,
currentArticle,
permissions;

- (void)loadView{
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    self.view = view;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
        newsArticle = [[UIWebView alloc] initWithFrame:CGRectZero];
        [newsArticle setAllowsInlineMediaPlayback:YES];
        [newsArticle setBackgroundColor:[UIColor clearColor]];
        newsArticle.delegate = self;
        
        [self.view addSubview:newsArticle];
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        [close setImage:[UIImage imageNamed:@"ico_close"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        [close sizeToFit];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:close];
        
        
    }
    return self;
}


-(void)viewDidLoad{

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

}


-(void)viewDidLayoutSubviews{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	

	if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            newsArticle.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height );

        }else {
            newsArticle.frame = CGRectMake(0, 0, 1024, self.view.bounds.size.height );

        }
        
	}
    if (UIInterfaceOrientationIsPortrait(orientation)){
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            newsArticle.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height );

        }else {
            newsArticle.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height );

        }
        
	}
    
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark Rotation Fix for ios6

-(void)newsViewContent:(Article*)content{

    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:resourcePath isDirectory:YES];
    NSString *fullPath;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        fullPath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    else
        fullPath = [[NSBundle mainBundle] pathForResource:@"iPhoneStyle" ofType:@"css"];
    
    NSString *css = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *newsImage         = [NSString stringWithFormat:@"<div class=\"figure\"> <img class=\"scaledImage\" src=\"%@\" alt=\"\"><p> %@</> </div> ", content.largeImage, content.attribute];
    NSString *webViewButton     = [NSString stringWithFormat:@"<a class=\"webview\" href=\"Return://\"></a>"];
    NSString *webBrowserButton  = [NSString stringWithFormat:@"<a class=\"browser\" href=\"%@\"></a>", content.url];
    NSString *cleanString       = [content.content stringByReplacingOccurrencesOfString:@"In Summary" withString:@"\n \n"];
    NSString *contentWithTags   = [cleanString stringByReplacingOccurrencesOfString:@"\n" withString:@"<p>"];
    self.fullcontent = [NSString stringWithFormat:@"%@ <br><h1>%@</h1> <hr> %@ <div id=\"article_text\">\r\n <p>%@</p> </div> <hr> <br> <br> <div class=\"navigation\"> %@ %@ </div> <hr> </body></html>",css,content.title,newsImage,contentWithTags, webViewButton,webBrowserButton ];
    [newsArticle stopLoading];
    [newsArticle loadHTMLString:fullcontent baseURL:baseURL];
    newsArticle.alpha = 1;
    
    self.currentArticle = content;
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSLog(@"uiwebview requesting to open %@", url);
    NSLog(@"request scheme %@", url.scheme);
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        
        if ([url.scheme isEqual:@"http"] || [url.scheme isEqual:@"https"]) {
            
            if ([self.currentArticle.url isEqual:[url relativeString]]) {
                NSLog (@"open a custom uiwebview here and do what it does");
                [self presentBrowser];
                return NO;
            }
            NSLog (@"current url is %@", self.currentArticle.url);
            
        }
        
        if ([url.scheme isEqual:@"return"] ) {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            
        }
    }
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}
- (void) presentBrowser{
    browser = [[BrowserViewController alloc] initWithUrls:self.currentArticle.url];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:browser animated:YES];
    
}

-(void)dismissBrowser{
    [browser dismissViewControllerAnimated:YES completion:NULL];
}

@end
