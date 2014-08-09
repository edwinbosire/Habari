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

    self.title.textColor = [UIColor midnightBlueColor];
    self.timeStampLabel.textColor = [UIColor wetAsphaltColor];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    self.image.image = nil;
    self.title.text = nil;
    self.timeStampLabel.text = nil;
}

- (void)setArticle:(Article *)article{
    
    _article = article;
    self.title.text = article.title;
    
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    NSString *timestamp = [descriptor describeDate:_article.published relativeTo:[NSDate date]];
    self.timeStampLabel.text = timestamp;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:article.largeImage];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak UIImageView *weakIV = self.image;
    [self.image setImageWithURLRequest:request
                      placeholderImage:nil
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                   weakIV.image =  [image applyExtraLightEffectAtFrame:CGRectMake(0.0f, image.size.height - 80.0f , image.size.width, 80.0f)];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}

- (void)setImage:(UIImageView *)image{
    _image = image;
}
@end
