//
//  HNSection.h
//  Habari
//
//  Created by edwin bosire on 23/12/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HNArticle;

@interface HNSection : NSManagedObject

@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSString * endpoint;
@property (nonatomic, retain) NSString * newsType;
@property (nonatomic, retain) NSString * primaryColor;
@property (nonatomic, retain) NSString * secondaryColor;
@property (nonatomic, retain) NSNumber * sectionId;
@property (nonatomic, retain) NSNumber * show;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSOrderedSet *articles;
@end

@interface HNSection (CoreDataGeneratedAccessors)

- (void)insertObject:(HNArticle *)value inArticlesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromArticlesAtIndex:(NSUInteger)idx;
- (void)insertArticles:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeArticlesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInArticlesAtIndex:(NSUInteger)idx withObject:(HNArticle *)value;
- (void)replaceArticlesAtIndexes:(NSIndexSet *)indexes withArticles:(NSArray *)values;
- (void)addArticlesObject:(HNArticle *)value;
- (void)removeArticlesObject:(HNArticle *)value;
- (void)addArticles:(NSOrderedSet *)values;
- (void)removeArticles:(NSOrderedSet *)values;
@end
