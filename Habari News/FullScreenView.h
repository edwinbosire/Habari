/*
  */
//
//  FullScreenView.h
//  FlipView
//
//  Created by Edwin Bosire on 26/02/12.
 
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "Article.h"
#import "BrowserViewController.h"


@interface FullScreenView : UIViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate >{
    UIWebView           *newsArticle;
    
    BOOL isConnected;
    float height;
    BrowserViewController *browser;
}

@property (nonatomic, strong) NSString *fullcontent;
@property (nonatomic, strong) Article *currentArticle;
@property (strong, nonatomic) NSArray *permissions;

-(void)newsViewContent:(Article*)content;

@end
