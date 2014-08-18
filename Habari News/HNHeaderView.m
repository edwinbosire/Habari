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
}

@property (nonatomic) CGFloat timerDelta;
@property (nonatomic) CGFloat refreshRate;

@end

@implementation HNHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
//    [self addSubview:[self gradientOverlay]];
    self.backgroundColor = [UIColor cloudsColor];
    self.refreshRate = 0.0001f;
    oscillatingOffset = CGPointMake(20.0f, 20.0f);
    
    self.headerImage.frame = [self boundsWithOscialltionMargins];
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


- (UIView *)gradientOverlay{
    
		gradientOverlay = [[UIView alloc] initWithFrame:CGRectMake(-oscillatingOffset.x, CGRectGetHeight(self.bounds) - 60.0f, 320.0f + oscillatingOffset.x, 80.0f)];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
		gradientLayer.frame = gradientOverlay.bounds;
		gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                                (id)[[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor],
                                (id)[[[UIColor blackColor] colorWithAlphaComponent:0.9] CGColor],
                                (id)[[[UIColor blackColor] colorWithAlphaComponent:1.0] CGColor],nil];
		[gradientOverlay.layer insertSublayer:gradientLayer atIndex:0];
	
	return gradientOverlay;
}

#pragma mark - Oscillating image

- (void)startOscillating{
    
    [self oscillate];
}

- (void)stopOscillating{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oscillate) object:nil];
}

- (void)oscillate{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oscillate) object:nil];
    
    ambientTimer += self.refreshRate;
    [self offsetImageWithTimer:ambientTimer];
    
    [self performSelector:@selector(oscillate) withObject:nil afterDelay:self.refreshRate inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];

}

- (void)offsetImageWithTimer:(CGFloat)timer{
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation( sinf(timer*2.0) * oscillatingOffset.x ,sinf(timer*3.0) * oscillatingOffset.y);
    self.headerImage.transform = transform;
    
}

- (CGRect)boundsWithOscialltionMargins {
    return CGRectMake(-oscillatingOffset.x, -oscillatingOffset.y,
                      self.headerImage.bounds.size.width+oscillatingOffset.x*2.0f, self.headerImage.bounds.size.height+oscillatingOffset.y*2.0f);
}
@end
