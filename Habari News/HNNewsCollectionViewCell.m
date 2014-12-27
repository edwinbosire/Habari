//
//  HNNewsCollectionViewCell.m
//  Habari News
//
//  Created by edwin bosire on 18/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNNewsCollectionViewCell.h"

//Data
#import "Article.h"

//Helper
#import "RelativeDateDescriptor.h"
#import "UIImage+BlurredFrame.h"


@interface HNNewsCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *imageContainer;

@end
@implementation HNNewsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor cloudsColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 1.0f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.layer.bounds] CGPath];
    self.layer.masksToBounds = NO;

    self.imageContainer.clipsToBounds = YES;
    self.title.textColor = [UIColor cloudsColor];
    self.timeStampLabel.textColor = [UIColor cloudsColor];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    self.image.image = nil;
    self.title.text = nil;
    self.timeStampLabel.text = nil;
}

- (void)setArticle:(HNArticle *)article{
    
    _article = article;
    self.title.text = article.title;
    self.timeStampLabel.text = article.dateStamp;

    if (article.largeImage) {
        [self.image setImageWithProgressIndicatorAndURL:[NSURL URLWithString:article.largeImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }else{
        [self.image setImage:[UIImage imageNamed:@"placeholder"]];
    }

}

- (void)setImage:(UIImageView *)image{
    _image = image;
    // Update padding
    
    // Grow image view
    CGRect frame = self.image.bounds;
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame)+IMAGE_OFFSET_SPEED/2, CGRectGetMinY(frame), CGRectGetWidth(frame)+IMAGE_OFFSET_SPEED, (CGRectGetHeight(frame) + IMAGE_OFFSET_SPEED));
    self.image.frame = newFrame;
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset{
    
    // Store padding value
    _imageOffset = imageOffset;
    
    // Grow image view
    CGRect frame = self.image.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.image.frame = offsetFrame;
}
@end
