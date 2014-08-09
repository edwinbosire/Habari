//
//  UIFont+Additions.h
//  SafariPark
//
//  Created by edwin bosire on 02/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SHFontTypeDefault,
    SHFontTypeMedium,
    SHFontTypeRegular,
    SHFontTypeLight,
    SHFontTypeThin,
    SHFontTypeBold,
} SHFontType;

@interface UIFont (Additions)

+ (UIFont*) fontWithType:(SHFontType)fontType size:(CGFloat)pointSize;
+ (UIFont*) italicFont:(UIFont*)font;


@end
