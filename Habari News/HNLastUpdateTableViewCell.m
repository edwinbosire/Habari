//
//  HNLastUpdateTableViewCell.m
//  Habari
//
//  Created by edwin bosire on 15/03/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "HNLastUpdateTableViewCell.h"
#import "NSDate+DateTools.h"

@interface HNLastUpdateTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HNLastUpdateTableViewCell

- (void)awakeFromNib {
   self.titleLabel.textColor = [UIColor asbestosColor];
    self.dateStampLabel.textColor = [UIColor silverColor];
    
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] valueForKey:@"LastUpdateKey"];
    self.dateStampLabel.text = [NSDate timeAgoSinceDate:date];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
