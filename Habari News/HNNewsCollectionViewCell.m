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
#import "UIFont+Additions.h"
#import "UIColor+FlatUI.h"

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
    
    self.title.textColor = [UIColor cloudsColor];
    self.timeStampLabel.textColor = [UIColor concreteColor];

}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    self.image.image = nil;
    self.title.text = nil;
    self.timeStampLabel.text = nil;
}

- (void)setArticle:(HNArticle *)article{
    
    _article = article;
	
	NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:[article.title stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"]
																	attributes:@{NSFontAttributeName: [UIFont titleFont],
																				 NSForegroundColorAttributeName: [UIColor midnightBlueColor]}];
	
	NSAttributedString *attrTime = [[NSAttributedString alloc] initWithString:article.dateStamp
																	attributes:@{NSFontAttributeName: [UIFont timeStampFont],
																				 NSForegroundColorAttributeName: [UIColor asbestosColor]}];

	self.title.attributedText = attrTitle;
    self.timeStampLabel.attributedText = attrTime;

    if (article.largeImage) {
		self.image.alpha = 0.0f;
        [self.image setImageWithProgressIndicatorAndURL:[NSURL URLWithString:article.largeImage]
                                       placeholderImage:[UIImage imageNamed:@"placeholder"]
                                    imageDidAppearBlock:^(UIImageView *imageView) {
										
                                        self.image = imageView;

                                        [UIView animateWithDuration:0.4 animations:^{
                                            self.image.alpha = 1.0f;
                                        }];
        }];
    }else{
        [self.image setImage:[UIImage imageNamed:@"placeholder"]];
    }

}

- (void)setImage:(UIImageView *)image{
    _image = image;
    // Update padding
    
    // Grow image view
//    CGRect frame = self.image.bounds;
//    CGRect newFrame = CGRectMake(CGRectGetMinX(frame)+IMAGE_OFFSET_SPEED/2, CGRectGetMinY(frame), CGRectGetWidth(frame), (CGRectGetHeight(frame) + IMAGE_OFFSET_SPEED));
//    self.image.frame = newFrame;
//    self.image.contentMode = UIViewContentModeScaleAspectFill;
////    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset{
    
    // Store padding value
    _imageOffset = imageOffset;
    
//    // Grow image view
//    CGRect frame = self.image.bounds;
//    CGRect offsetFrame = CGRectOffset(frame, 0.0f, _imageOffset.y);
//    self.image.frame = offsetFrame;
}
@end
