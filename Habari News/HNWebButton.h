//
//  HNWebButton.h
//  Habari News
//
//  Created by edwin bosire on 30/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OpenInWebBrowserBlock)(void);

@interface HNWebButton : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *webViewButton;
@property (strong, nonatomic) OpenInWebBrowserBlock openInWebBrowserBlock;
@end
