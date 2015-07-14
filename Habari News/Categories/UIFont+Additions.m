//
//  UIFont+Additions.m
//  SafariPark
//
//  Created by edwin bosire on 02/03/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "UIFont+Additions.h"



@implementation UIFont (Additions)
+ (UIFont *) titleFont {	
	return [UIFont fontWithType:SHFontTypeSemiBold size:16.0f];
}

+ (UIFont *) timeStampFont {
	return [UIFont fontWithType:SHFontTypeLight size:10.0f];
}

+ (UIFont *) regular {
	return [UIFont fontWithType:SHFontTypeRegular size:18.0f];
}

+ (UIFont*) fontWithType:(SHFontType)fontType size:(CGFloat)pointSize {
    NSString *fontFamilyName = @"OpenSans";
    UIFont *font = nil;
    switch (fontType) {
        case SHFontTypeSemiBold:
            font = [UIFont fontWithName:[fontFamilyName stringByAppendingFormat:@"-Semibold"] size:pointSize];
            break;
        case SHFontTypeRegular:
            font = [UIFont fontWithName:@"Open Sans"  size:pointSize];
            break;
        case SHFontTypeLight:
            font = [UIFont fontWithName:[fontFamilyName stringByAppendingFormat:@"-Light"] size:pointSize];
            break;
        case SHFontTypeItalic:
            font = [UIFont fontWithName:[fontFamilyName stringByAppendingFormat:@"-Italic"] size:pointSize];
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
