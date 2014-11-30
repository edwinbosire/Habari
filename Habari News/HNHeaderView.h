//
//  SPHHeaderReusableView.h
//  SafariPark
//
//  Created by edwin bosire on 01/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface HNHeaderView : UIView

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIImageView *headerImage;
@property (nonatomic) Article *article;
@property (nonatomic) UIImage *placeholder;

- (void)startOscillating;
- (void)stopOscillating;
@end
