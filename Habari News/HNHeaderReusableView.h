//
//  SPHHeaderReusableView.h
//  SafariPark
//
//  Created by edwin bosire on 01/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNHeaderReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIImageView *headerImage;
@end
