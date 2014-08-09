//
//  SPHHeaderReusableView.m
//  SafariPark
//
//  Created by edwin bosire on 01/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNHeaderReusableView.h"
@interface HNHeaderReusableView ()<UITextViewDelegate>{
    UIView *gradientOverlay;
    CGFloat ambientTimer;
    CGPoint oscillatingOffset;
}

@property (nonatomic) CGFloat timerDelta;
@property (nonatomic) CGFloat refreshRate;

@end

@implementation HNHeaderReusableView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:[self gradientOverlay]];

    self.refreshRate = 0.0001f;
    oscillatingOffset = CGPointMake(20.0f, 20.0f);
    
    self.headerImage.frame = [self boundsWithOscialltionMargins];
    [self bringSubviewToFront:self.textView];
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

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat height = self.textView.contentSize.height;
    self.textView.frame = CGRectMake(0.0f, CGRectGetHeight(self.bounds) - height, self.textView.contentSize.width, height);
    gradientOverlay.frame = CGRectMake(0.0f, CGRectGetHeight(self.bounds) - 60.0f, 320.0f, 80.0f);
 
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

-(CGRect)boundsWithOscialltionMargins {
    return CGRectMake(-oscillatingOffset.x, -oscillatingOffset.y,
                      self.headerImage.bounds.size.width+oscillatingOffset.x*2.0f, self.headerImage.bounds.size.height+oscillatingOffset.y*2.0f);
}
@end
