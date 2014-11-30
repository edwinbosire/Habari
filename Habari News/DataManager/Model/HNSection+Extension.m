//
//  HNSection+Extension.m
//  Habari
//
//  Created by edwin bosire on 22/09/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNSection+Extension.h"
#import "EBDataManager.h"

@implementation HNSection (Extension)


+ (HNSection *)create{
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([HNSection class]) inManagedObjectContext:[EBDataManager shared].managedObjectContext];
}

+ (HNSection *)sectionForID:(NSNumber *)sectionID{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sectionId == %@", sectionID];
    NSArray *sections = [HNSection executeRequestWithPredicate:predicate];
    return [sections firstObject];
}

+ (NSArray *)fetchSectionsToBeShown {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"enabled == YES"];
    NSArray *sections = [HNSection executeRequestWithPredicate:predicate];

    return sections;
}
+ (NSArray *)fetchAllSections{
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.returnsObjectsAsFaults = NO;
    
    NSManagedObjectContext* managedObjectContext = [EBDataManager shared].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([HNSection class]) inManagedObjectContext:managedObjectContext];
    [request setEntity:entityDescription];
    
    NSError* error;
    return [managedObjectContext executeFetchRequest:request error:&error];
}


+ (NSArray *)executeRequestWithPredicate:(NSPredicate *)predicate {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.returnsObjectsAsFaults = NO;
    
    NSManagedObjectContext* managedObjectContext = [EBDataManager shared].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([HNSection class])
                                                         inManagedObjectContext:managedObjectContext];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    NSError* error;
    return [managedObjectContext executeFetchRequest:request error:&error];
}
@end
