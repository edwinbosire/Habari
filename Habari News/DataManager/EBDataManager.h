//
//  EBDataManager.h
//  xinder
//
//  Created by edwin bosire on 31/08/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface EBDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (instancetype)shared;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;
@end
