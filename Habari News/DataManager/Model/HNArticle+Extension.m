//
//  HNArticle+Extension.m
//  Habari
//
//  Created by edwin bosire on 22/09/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNArticle+Extension.h"
#import "EBDataManager.h"
#import "HNSection.h"

#define kScreenWidth  300.0f


@implementation HNArticle (Extension)

+ (HNArticle *)create {
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([HNArticle class]) inManagedObjectContext:[EBDataManager shared].managedObjectContext];
}

+ (HNArticle *)articleWithObject:(NSDictionary *)obj{
    
    NSString *newsID = [obj[@"id"] description];
    HNArticle *anArticle = [HNArticle articleWithId:newsID];
    
    if (!anArticle) {
        
        anArticle = [HNArticle create];
    }
    
    anArticle.newsId = newsID;
    anArticle.author = [obj[@"author"] description];
    anArticle.caption = [obj[@"caption"] description];
    anArticle.category = [obj[@"category"] description];
    anArticle.excerpt = [obj[@"excerpt"] description];
    anArticle.content = [obj[@"content"] description];
    anArticle.datePublished = [self dateFromString:[obj[@"published"] description]];
    anArticle.source = [obj[@"source"] description];
    anArticle.summary = [obj[@"summary"] description];
    anArticle.title = [obj[@"title"] description];
    anArticle.uri = [obj[@"uri"] description];
    anArticle.largeImage = [obj[@"image_large"] description];
    anArticle.smallImage = [obj[@"image_small"] description];
    anArticle.thumbnail = [obj[@"image_thumb"] description];
    anArticle.originalImageWidth = @([[obj[@"original_image_width"] description] integerValue]);
    anArticle.originalImageHeight = @([[obj[@"original_image_heigh"] description] integerValue]);
    
    return anArticle;
}


+ (HNArticle *)articleWithId:(NSString *)identification {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"newsId == %@", identification];
    return  [[self executeRequestWithPredicate:predicate] firstObject];
}

+(NSDate *)dateFromString:(NSString *)stringDate {
    
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    
    return [dateFormatter dateFromString:stringDate];
}

+ (NSArray *)getNewsForSection:(HNSection *)section {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", [section.sectionId description]];
    NSArray *news = [HNArticle executeRequestWithPredicate:predicate];
    
    return news;
}


+ (NSArray *)executeRequestWithPredicate:(NSPredicate *)predicate {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.returnsObjectsAsFaults = NO;
    
    NSManagedObjectContext* managedObjectContext = [EBDataManager shared].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([HNArticle class])
                                                         inManagedObjectContext:managedObjectContext];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    NSError* error;
    return [managedObjectContext executeFetchRequest:request error:&error];
}


#pragma mark - Styling Elements

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

@end
