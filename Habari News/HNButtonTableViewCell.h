//
//  HNButtonTableViewCell.h
//  Habari
//
//  Created by edwin bosire on 15/03/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HNButtonGroupDelegate <NSObject>

- (void)clearCache:(id)sender;
- (void)presentFeedBackSheet:(id)sender;
- (void)presentDonateSheet:(id)sender;

@end

@interface HNButtonTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HNButtonGroupDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *clearCacheButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *donateButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end
