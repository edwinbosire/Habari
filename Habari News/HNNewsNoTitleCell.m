//
//  HNNewsNoTitleCell.m
//  Habari
//
//  Created by edwin bosire on 21/02/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "HNNewsNoTitleCell.h"

@interface HNNewsNoTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation HNNewsNoTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = [UIColor asbestosColor];
    self.timeLabel.textColor = [UIColor concreteColor];
    
    self.timeLabel.text = @"";
    self.titleLabel.text = @"";
    self.contentLabel.text = @"";

}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    self.timeLabel.text = nil;
    self.titleLabel.text = nil;
}

- (void)setArticle:(HNArticle *)article {
    
    _article = article;
    
    self.titleLabel.text = _article.title;
    self.timeLabel.text = _article.dateStamp;
    
    NSString *captionText = (_article.caption.length > 10) ? _article.caption : _article.content;
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f],
                                 NSForegroundColorAttributeName: [UIColor asbestosColor]};
    captionText = [captionText stringByReplacingOccurrencesOfString:@"<p>" withString:@" "];
    NSAttributedString *caption = [[NSAttributedString alloc] initWithString:captionText attributes:attributes];
    self.contentLabel.attributedText = caption;
}

@end
