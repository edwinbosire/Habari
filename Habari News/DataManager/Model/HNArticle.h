//
//  HNArticle.h
//  Habari
//
//  Created by edwin bosire on 11/12/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HNSection;

@interface HNArticle : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * datePublished;
@property (nonatomic, retain) NSString * excerpt;
@property (nonatomic, retain) NSString * largeImage;
@property (nonatomic, retain) NSString * newsId;
@property (nonatomic, retain) NSNumber * originalImageHeight;
@property (nonatomic, retain) NSNumber * originalImageWidth;
@property (nonatomic, retain) NSString * smallImage;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSOrderedSet *sections;
@end

@interface HNArticle (CoreDataGeneratedAccessors)

- (void)insertObject:(HNSection *)value inSectionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSectionsAtIndex:(NSUInteger)idx;
- (void)insertSections:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSectionsAtIndex:(NSUInteger)idx withObject:(HNSection *)value;
- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray *)values;
- (void)addSectionsObject:(HNSection *)value;
- (void)removeSectionsObject:(HNSection *)value;
- (void)addSections:(NSOrderedSet *)values;
- (void)removeSections:(NSOrderedSet *)values;
@end
