//
//  HNArticle+Extension.h
//  Habari
//
//  Created by edwin bosire on 22/09/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNArticle.h"

@class HNSection;
@interface HNArticle (Extension)


+ (HNArticle *)create;

+ (HNArticle *)articleWithObject:(NSDictionary *)obj;

+ (NSArray *)retrieveLatestItemsWithLimit:(NSInteger)limit;

+ (NSArray *)getNewsForSection:(HNSection *)section;

- (CGSize)cellSizeForTitle;
- (NSAttributedString *)attributedStringForTitle;

- (CGSize)cellSizeForAuthor;
- (NSAttributedString *)attributedStringForAuthor;

- (CGSize)cellSizeForContent;
- (NSAttributedString *)attributedStringForContent;

- (NSAttributedString *)attributedStringForCaption;

- (NSString *)formattedContent;

+ (NSString *)fullImageURL:(NSString *)url;

+(NSDate *)dateFromString:(NSString *)stringDate;

@end
