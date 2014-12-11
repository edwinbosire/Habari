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
    
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    NSString *timestamp = [descriptor describeDate:_article.datePublished relativeTo:[NSDate date]];
    self.timeStampLabel.text = timestamp;
    
    
    typeof(UIImageView) __weak *weakIV = self.image;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:article.largeImage]
                  placeholderImage:[UIImage imageNamed:@"placeholder"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 weakIV.image =  image;//[image applyExtraLightEffectAtFrame:CGRectMake(0.0f, image.size.height - 80.0f , weakIV.image.size.width, 80.0f)];

                             });
                             
                         }];

}

- (void)setImage:(UIImageView *)image{
    _image = image;
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
