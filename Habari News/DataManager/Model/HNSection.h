//
//  HNSection.h
//  Habari
//
//  Created by edwin bosire on 22/09/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HNSection : NSManagedObject

@property (nonatomic, retain) NSNumber * sectionId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * endpoint;
@property (nonatomic, retain) NSString * newsType;
@property (nonatomic, retain) NSString * primaryColor;
@property (nonatomic, retain) NSString * secondaryColor;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSNumber * show;

@end
