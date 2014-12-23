//
//  SPHHeaderReusableView.m
//  SafariPark
//
//  Created by edwin bosire on 01/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNHeaderView.h"
#import "RelativeDateDescriptor.h"
#import "Article.h"

@interface HNHeaderView ()<UITextViewDelegate>{
    UIView *gradientOverlay;
}


@end

@implementation HNHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];

    self.backgroundColor = [UIColor cloudsColor];
    self.backgroundColor = [UIColor whiteColor];
    [self bringSubviewToFront:self.textView];
}


- (void)setArticle:(HNArticle *)article{
    
    if (_article == article) {
        return;
    }
    
    _article = article;
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:article.largeImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    
    NSString *timestamp = [descriptor describeDate:self.article.datePublished relativeTo:[NSDate date]];
    NSString *publisher = nil;
    if ([_article.uri isEqualToString:@"www.nation.co.ke"]) {
        publisher = @"Nation Media";
    }else{
        publisher = @"Standard";
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentRight;
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *timeStringAttr  = [[NSAttributedString alloc] initWithString:timestamp attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f], NSForegroundColorAttributeName:[UIColor silverColor], NSParagraphStyleAttributeName: paraStyle}];
    NSAttributedString *separatorStringAttr  = [[NSAttributedString alloc] initWithString:@" | " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f], NSForegroundColorAttributeName:[UIColor concreteColor]}];
    NSAttributedString *publisherStringAttr  = [[NSAttributedString alloc] initWithString:publisher attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f], NSForegroundColorAttributeName:[UIColor cloudsColor], NSParagraphStyleAttributeName: paraStyle}];
    
    [mutableAttr appendAttributedString:publisherStringAttr];
    [mutableAttr appendAttributedString:separatorStringAttr];
    [mutableAttr appendAttributedString:timeStringAttr];
    
    self.textView.attributedText = mutableAttr;
    [self setNeedsDisplay];
    
}

- (void)setHeaderImage:(UIImageView *)headerImage{
    _headerImage = headerImage;
    
    [self performSelector:@selector(animateImage) withObject:nil afterDelay:0.5f];
}

#pragma mark - Oscillating image
- (void)startOscillating {
    
    if (self.headerImage.image) {
         [self animateImage];
    }
}

- (void)stopOscillating {
    
    self.headerImage.transform  = CGAffineTransformIdentity;
}

- (void)animateImage{
    
    NSInteger randInt = arc4random()%3;
    
    NSInteger translationX = 0;
    NSInteger translationY = 0;
    NSInteger scaleX = 0;
    NSInteger scaleY = 0;
    
    switch (randInt) {
        case 0:
            translationX = 90;
            translationY = -100;
            scaleX = 2.5;
            scaleY = 2.5;
            break;
            
        case 1:
            translationX = 20;
            translationY = -70;
            scaleX = 2.7;
            scaleY = 2.7;
            break;
            
        case 2:
            translationX = 40;
            translationY = -50;
            scaleX = 2.0;
            scaleY = 2.0;
            break;
            
        default:
            break;
    }
    
    // re-animate image background
    [UIView animateWithDuration:50.0f
                          delay:0.0f
                        options:
     UIViewAnimationOptionCurveLinear |
     UIViewAnimationOptionAutoreverse |
     UIViewAnimationOptionRepeat
                     animations:^{
                         [UIView setAnimationRepeatCount:10];
                         CGAffineTransform moveRight = CGAffineTransformMakeTranslation(translationX, translationY);
                         CGAffineTransform zoomIn = CGAffineTransformMakeScale(scaleX, scaleY);
                         CGAffineTransform transform = CGAffineTransformConcat(zoomIn, moveRight);
                         self.headerImage.transform = transform;
                     } completion:nil];
}
@end
