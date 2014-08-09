//
//  UIFont+Additions.m
//  SafariPark
//
//  Created by edwin bosire on 02/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "UIFont+Additions.h"



@implementation UIFont (Additions)

+ (UIFont*) fontWithType:(SHFontType)fontType size:(CGFloat)pointSize {
    NSString *fontFamilyName = @"HelveticaNeue";
    UIFont *font = nil;
    switch (fontType) {
        case SHFontTypeMedium:
            font = [UIFont fontWithName:[fontFamilyName stringByAppendingFormat:@"-Medium"] size:pointSize];
            break;
        case SHFontTypeRegular:
            font = [UIFont fontWithName:fontFamilyName size:pointSize];
            break;
        case SHFontTypeLight:
            font = [UIFont fontWithName:[fontFamilyName stringByAppendingFormat:@"-Light"] size:pointSize];
            break;
        case SHFontTypeThin:
            font = [UIFont fontWithName:[fontFamilyName stringByAppendingFormat:@"-Thin"] size:pointSize];
            break;
        case SHFontTypeBold:
            font = [UIFont fontWithName:[fontFamilyName stringByAppendingFormat:@"-Bold"] size:pointSize];
            break;
        default:
            break;
    }
    return font;
}

+ (UIFont*) italicFont:(UIFont*)font {
    UIFontDescriptor *fontDesc = [font fontDescriptor];
    fontDesc = [fontDesc fontDescriptorWithSymbolicTraits:fontDesc.symbolicTraits|UIFontDescriptorTraitItalic];
    font = [UIFont fontWithDescriptor:fontDesc size:font.pointSize];
    return font;
}

@end
