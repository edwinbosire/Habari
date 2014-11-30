//
//  Article.m
//  HABARI V3.0
//
//  Created by edwin bosire on 20/08/2012.
//
//

#import "Article.h"

#define kScreenWidth  300.0f

@implementation Article

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id":         @"id",
             @"title":      @"title",
             @"excerpt": @"summary",
             @"category":   @"category",
             @"content":    @"content",
             @"author":     @"author",
             @"url":   @"uri",
             @"image": @"image_medium",
             @"thumbnail": @"image_thumb",
             @"smallImage": @"image_small",
             @"largeImage": @"image_large",
             @"attribute": @"caption",
             @"publisher": @"source",
             @"published": @"published",
             @"date":@"UTC",
             @"imageWidth": @"original_image_width",
             @"imageHeight": @"original_image_height",
             };
}


+ (NSValueTransformer *)publishedJSONTransformer {
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    
    return [MTLValueTransformer transformerWithBlock:^id(NSString *string) {
        return [dateFormatter dateFromString:string];
    }];
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)imageJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)thumbnailJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)smallImageJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)largeImageJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (NSAttributedString *)attributedStringForTitle{
    
    static NSMutableParagraphStyle *paraStyle = nil;
    static dispatch_once_t onceTokenBottomParagraphStyle;
    dispatch_once(&onceTokenBottomParagraphStyle, ^{
        paraStyle = [[NSMutableParagraphStyle alloc] init];
        //        paraStyle.paragraphSpacing = 1.0;
        //        paraStyle.lineHeightMultiple = 1.2f;
        paraStyle.alignment = NSTextAlignmentLeft;
    });
    
    static NSDictionary *titleTextAttributes = nil;
    static dispatch_once_t onceTokenTitleTextAttributes;
    dispatch_once(&onceTokenTitleTextAttributes, ^{
        
        titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:37.0f], NSParagraphStyleAttributeName: paraStyle, NSForegroundColorAttributeName: [UIColor midnightBlueColor]};
    });
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.title attributes:titleTextAttributes];
    
    return attributedString;
}

- (NSAttributedString *)attributedStringForAuthor{
    
    static NSMutableParagraphStyle *paraStyle = nil;
    static dispatch_once_t onceTokenBottomParagraphStyle;
    dispatch_once(&onceTokenBottomParagraphStyle, ^{
        paraStyle = [[NSMutableParagraphStyle alloc] init];
//        paraStyle.paragraphSpacing = 1.0;
//        paraStyle.lineHeightMultiple = 1.2f;
        paraStyle.alignment = NSTextAlignmentCenter;
    });
    
    static NSDictionary *titleTextAttributes = nil;
    static dispatch_once_t onceTokenTitleTextAttributes;
    dispatch_once(&onceTokenTitleTextAttributes, ^{
        
        titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:14.0f], NSParagraphStyleAttributeName: paraStyle, NSForegroundColorAttributeName: [UIColor midnightBlueColor]};
    });
    NSString *author = [NSString stringWithFormat:@"By %@",(self.author)?self.author : @"Unknown"];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:author attributes:titleTextAttributes];
    
    return attributedString;
}



- (NSAttributedString *)attributedStringForContent{
    static NSDictionary *titleTextAttributes = nil;
    static NSMutableParagraphStyle *paraStyle = nil;
    static dispatch_once_t onceTokenBottomParagraphStyle;
    dispatch_once(&onceTokenBottomParagraphStyle, ^{
        paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.paragraphSpacing = 2.0;
        paraStyle.lineHeightMultiple = 1.2f;
        paraStyle.alignment = NSTextAlignmentLeft;
    });
    
    
    static dispatch_once_t onceTokenTitleTextAttributes;
    dispatch_once(&onceTokenTitleTextAttributes, ^{
        titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f],
                                NSParagraphStyleAttributeName: paraStyle,
                                NSForegroundColorAttributeName: [UIColor wetAsphaltColor]};
    });
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[self cleanString] attributes:titleTextAttributes];
    
    return attributedString;
}

- (NSAttributedString *)attributedStringForCaption{
    static NSDictionary *titleTextAttributes = nil;
    static NSMutableParagraphStyle *paraStyle = nil;
    static dispatch_once_t onceTokenBottomParagraphStyle;
    dispatch_once(&onceTokenBottomParagraphStyle, ^{
        paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentLeft;
    });
    
    
    static dispatch_once_t onceTokenTitleTextAttributes;
    dispatch_once(&onceTokenTitleTextAttributes, ^{
        titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f],
                                NSParagraphStyleAttributeName: paraStyle,
                                NSForegroundColorAttributeName: [UIColor cloudsColor]};
    });
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.excerpt attributes:titleTextAttributes];
    
    return attributedString;
}

- (CGSize)cellSizeForTitle{
    
    CGSize textSize = [[self attributedStringForTitle] boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    textSize.width = 300;
    return textSize;
}

- (CGSize)cellSizeForAuthor{
    
    CGSize textSize = [[self attributedStringForAuthor] boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    textSize.width = kScreenWidth;
    textSize.height = 30.0f;
    return textSize;
}

- (CGSize)cellSizeForContent{
    CGSize textSize = [[self attributedStringForContent] boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
   textSize.width = 310.0f;
    textSize.height += 30.0f;
    return textSize;
}


- (NSString *)cleanString{
    NSString *cleanContent = [self.content stringByReplacingOccurrencesOfString:@"</p><p>" withString:@"\n\n"];
    cleanContent = [cleanContent stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    NSRange range;
    while ((range = [cleanContent rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        cleanContent = [cleanContent stringByReplacingCharactersInRange:range withString:@""];
    
    return cleanContent;
}


#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
 
    self.attribute = [decoder decodeObjectForKey:@"attribute"];
    self.author = [decoder decodeObjectForKey:@"author"];
    self.category = [decoder decodeObjectForKey:@"category"];
    self.content = [decoder decodeObjectForKey:@"content"];
    self.published = [decoder decodeObjectForKey:@"published"];
    self.excerpt = [decoder decodeObjectForKey:@"excerpt"];
    self.favourite = [decoder decodeObjectForKey:@"favourite"];
    self.id = [decoder decodeObjectForKey:@"id"];
    self. image = [decoder decodeObjectForKey:@"image"];
    self. largeImage = [decoder decodeObjectForKey:@"largeImage"];
    self. smallImage = [decoder decodeObjectForKey:@"smallImage"];
    self.thumbnail = [decoder decodeObjectForKey:@"thumbnail"];
    self.url = [decoder decodeObjectForKey:@"url"];
    self.publisher = [decoder decodeObjectForKey:@"publisher"];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.imageHeight = [decoder decodeObjectForKey:@"imageHeight"];
    self.imageWidth = [decoder decodeObjectForKey:@"imageWidth"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.attribute forKey:@"attribute"];
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeObject:self.category forKey:@"category"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.published forKey:@"published"];
    [encoder encodeObject:self.excerpt forKey:@"excerpt"];
    [encoder encodeObject:self.favourite forKey:@"favourite"];
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.largeImage forKey:@"largeImage"];
    [encoder encodeObject:self.smallImage forKey:@"smallImage"];
    [encoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.publisher forKey:@"publisher"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.imageHeight forKey:@"imageHeight"];
    [encoder encodeObject:self.imageWidth forKey:@"imageWidth"];
}
@end
