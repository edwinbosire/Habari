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
#import "NSDate+DateTools.h"
#import "UIFont+Additions.h"

#define kScreenWidth  300.0f


@implementation HNArticle (Extension)

+ (HNArticle *)create {
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([HNArticle class]) inManagedObjectContext:[EBDataManager shared].managedObjectContext];
}

+ (HNArticle *)articleWithObject:(NSDictionary *)obj{
    
    NSString *newsTitle = [obj[@"title"] description];
    HNArticle *anArticle = [HNArticle articleWithTitle:newsTitle];
    
    if (!anArticle) {
        
        anArticle = [HNArticle create];
    }
    
    anArticle.title = newsTitle;
    anArticle.newsId = [obj[@"id"] description];;
    anArticle.author = [obj[@"author"][@"name"] description];
    anArticle.caption = [obj[@"excerpt"] description];
    anArticle.category = [obj[@"channel"] description];
    anArticle.excerpt = [obj[@"excerpt"] description];
    anArticle.content = [obj[@"content"] description];
    anArticle.datePublished = [HNArticle dateFromString:[obj[@"date"] description]];
    anArticle.source = @"Techweeze"; //[obj[@"source"] description];
    anArticle.summary = [obj[@"excerpt"] description];
    anArticle.uri = [obj[@"url"] description];
	anArticle.largeImage = [HNArticle fullImageURL: [obj[@"thumbnail"] description]];
    anArticle.smallImage = [obj[@"thumbnail"] description];
    anArticle.thumbnail = [obj[@"thumbnail"] description];
    
    return anArticle;
}

+ (NSString *)fullImageURL:(NSString *)url {
	
	if (![url containsString:@"resize="]) {
		return nil;
	}
	
	NSRange range = [url rangeOfString:@"?resize="];
	NSString *fullURL = [url substringToIndex:range.location];
	return fullURL;
}
+ (HNArticle *)articleWithTitle:(NSString *)title {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title LIKE[cd] %@", title];
    return  [[self executeRequestWithPredicate:predicate] firstObject];
}

+(NSDate *)dateFromString:(NSString *)stringDate {
    
    // 2015-04-02T19:30:18+00:00 mashable
    //2015-05-11 20:31:02 //WP
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd' 'HH:mm:ss";
    });
    
    return [dateFormatter dateFromString:stringDate];
}

+ (NSArray *)retrieveLatestItemsWithLimit:(NSInteger)limit {
    
    NSPredicate *predicate = nil;
    NSArray *news = [HNArticle executeRequestWithPredicate:predicate];
    return news;
}

+ (NSArray *)getNewsForSection:(HNSection *)section {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY sections.sectionId == %@", section.sectionId];
    NSArray *news = [HNArticle executeRequestWithPredicate:predicate];
    
    return news;
}

+ (NSArray *)executeRequestWithPredicate:(NSPredicate *)predicate {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.returnsObjectsAsFaults = NO;
    NSManagedObjectContext* managedObjectContext = [EBDataManager shared].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([HNArticle class]) inManagedObjectContext:managedObjectContext];

    //Using two sort descriptors to ensure that order is maintained between requests
    NSSortDescriptor *newsIdSort = [NSSortDescriptor sortDescriptorWithKey:@"newsId" ascending:NO];
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"datePublished" ascending:NO];
    [request setSortDescriptors:@[dateSort, newsIdSort]];
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
        paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paraStyle.alignment = NSTextAlignmentCenter;
    });
    
    static NSDictionary *titleTextAttributes = nil;
    static dispatch_once_t onceTokenTitleTextAttributes;
    dispatch_once(&onceTokenTitleTextAttributes, ^{
        
        titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithType:SHFontTypeBold size:24.0f],
                                NSParagraphStyleAttributeName: paraStyle,
                                NSForegroundColorAttributeName: [UIColor midnightBlueColor]};
    });
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.title attributes:titleTextAttributes];
    
    return attributedString;
}

- (NSAttributedString *)attributedStringForAuthor{
    
    static NSMutableParagraphStyle *paraStyle = nil;
    static dispatch_once_t onceTokenBottomParagraphStyle;
    dispatch_once(&onceTokenBottomParagraphStyle, ^{
        paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentCenter;
    });
    
    static NSDictionary *titleTextAttributes = nil;
    static dispatch_once_t onceTokenTitleTextAttributes;
    dispatch_once(&onceTokenTitleTextAttributes, ^{
        
        titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithType:SHFontTypeLight size:12.0f], NSParagraphStyleAttributeName: paraStyle, NSForegroundColorAttributeName: [UIColor midnightBlueColor]};
    });
    NSString *cleanAuthor = [self.author stringByReplacingOccurrencesOfString:@"By " withString:@""];
    NSString *author = [NSString stringWithFormat:@"By %@",(cleanAuthor.length > 2)?cleanAuthor : @"News Team"];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:author attributes:titleTextAttributes];
    
    return attributedString;
}



- (NSAttributedString *)attributedStringForContent{
    static NSDictionary *titleTextAttributes = nil;
    static NSMutableParagraphStyle *paraStyle = nil;
    static dispatch_once_t onceTokenBottomParagraphStyle;
    dispatch_once(&onceTokenBottomParagraphStyle, ^{
        paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.paragraphSpacing = 9.0;
        paraStyle.lineHeightMultiple = 1.2f;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    });
    
    
    static dispatch_once_t onceTokenTitleTextAttributes;
    dispatch_once(&onceTokenTitleTextAttributes, ^{
        titleTextAttributes = @{NSFontAttributeName: [UIFont regular],
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
    
    CGSize textSize = [[self attributedStringForTitle] boundingRectWithSize:CGSizeMake(kScreenWidth-50, CGFLOAT_MAX)
                                                                    options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                                                    context:nil].size;
    textSize.width = kScreenWidth;
    return textSize;
}

- (CGSize)cellSizeForAuthor{
    
    CGSize textSize;// = [[self attributedStringForAuthor] boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    textSize.width = kScreenWidth;
    textSize.height = 30.0f;
    return textSize;
}

- (CGSize)cellSizeForContent{
    CGSize textSize = [[self attributedStringForContent] boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                      context:nil].size;
    
    textSize.width = 310.0f;
    textSize.height =  ceilf(textSize.height) * 1.08f;
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

- (NSString *)formattedContent {
    
    NSString *style = @"<style> body {font-family: 'HelveticaNeue-Light', 'Helvetica Neue Light'; font-size: 18px; background-color: transparent; color: #777; text-indent: 10px;} img, alt, figcaption {display:none} </style>";
    
    NSString *content = [self.content stringByReplacingOccurrencesOfString:@"\n" withString:@"<p>"];
    NSString *formattedString = [NSString stringWithFormat:@"<html><head> %@ </head><body> %@ </html>", style, content];
    
    return formattedString;
}

#pragma mark - Apple bug fix
/*
 This is a fix for Apple's own bug that they wont rectify
 */

- (void)addSectionsObject:(HNSection *)value {
    
    NSMutableOrderedSet *sections = [NSMutableOrderedSet orderedSetWithOrderedSet:self.sections];
    [sections addObject:value];
    self.sections = sections;
}


- (NSString *)dateStamp {

    if (!self.datePublished) {
        return @"";
    }
    NSString *timestamp = [NSDate timeAgoSinceDate:self.datePublished];

    return (timestamp) ? timestamp : @"";
}
@end
