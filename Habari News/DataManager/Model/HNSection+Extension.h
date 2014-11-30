//
//  HNSection+Extension.h
//  Habari
//
//  Created by edwin bosire on 22/09/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNSection.h"

@interface HNSection (Extension)

+ (HNSection *)create;

+ (HNSection *)sectionForID:(NSNumber *)sectionID;

+ (NSArray *)fetchAllSections;

+ (NSArray *)fetchSectionsToBeShown;

+ (NSArray *)executeRequestWithPredicate:(NSPredicate *)predicate andSortDescriptor:(NSArray *)descriptors;
@end
