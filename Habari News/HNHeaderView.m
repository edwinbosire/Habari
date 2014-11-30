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
    CGFloat ambientTimer;
    CGPoint oscillatingOffset;
    BOOL stopOscillating;
}

@property (nonatomic) CGFloat timerDelta;
@property (nonatomic) CGFloat refreshRate;

@end

@implementation HNHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
//    [self addSubview:[self gradientOverlay]];
    self.backgroundColor = [UIColor cloudsColor];
    self.refreshRate = 0.001f;
    oscillatingOffset = CGPointMake(20.0f, 20.0f);
    
//    self.headerImage.frame = CGRectInset(self.headerImage.frame, -20.0f, -20.0f);
    self.backgroundColor = [UIColor whiteColor];
    [self bringSubviewToFront:self.textView];
}


- (void)setArticle:(Article *)article{
    
    if (_article == article) {
        return;
    }
    
    _article = article;
    
    [_headerImage setImageWithURL:_article.largeImage placeholderImage:self.placeholder];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    
    NSString *timestamp = [descriptor describeDate:self.article.published relativeTo:[NSDate date]];
    NSString *publisher = nil;
    if ([_article.url.host isEqualToString:@"www.nation.co.ke"]) {
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
    
    stopOscillating = NO;
}

- (void)setTextView:(UITextView *)textView{
    _textView = textView;
    
}

- (void)setHeaderImage:(UIImageView *)headerImage{
    _headerImage = headerImage;
    
    [self startOscillating];
}

- (void)textViewDidChange:(UITextView *)textView{
    
}

#pragma mark - Oscillating image

- (void)startOscillating {
    
    ambientTimer += self.refreshRate;
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation( sinf(ambientTimer*2.0) * oscillatingOffset.x ,sinf(ambientTimer*1.0) * oscillatingOffset.y);
    self.headerImage.transform = transform;
    
    if (stopOscillating) {
        return;
    }
    [self performSelector:@selector(startOscillating) withObject:nil afterDelay:self.refreshRate inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];

//    [self oscillate];
}

- (void)stopOscillating{
    stopOscillating = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oscillate) object:nil];
    
}

- (void)oscillate{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oscillate) object:nil];
    
    ambientTimer += self.refreshRate;
    [self offsetImageWithTimer:ambientTimer];
    
    [self performSelector:@selector(oscillate) withObject:nil afterDelay:self.refreshRate inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];

}

- (void)offsetImageWithTimer:(CGFloat)timer{
    
    ambientTimer += self.refreshRate;
    CGAffineTransform transform = CGAffineTransformMakeTranslation( sinf(timer*2.0) * oscillatingOffset.x ,sinf(timer*3.0) * oscillatingOffset.y);
    self.headerImage.transform = transform;
}

- (CGRect)boundsWithOscialltionMargins {
    return CGRectMake(-oscillatingOffset.x, -oscillatingOffset.y,
                      self.headerImage.bounds.size.width+oscillatingOffset.x*2.0f, self.headerImage.bounds.size.height+oscillatingOffset.y*2.0f);
}
@end
