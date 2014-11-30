//
//  HNSection.h
//  Habari
//
//  Created by edwin bosire on 23/08/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "MTLModel.h"

//typedef NS_OPTIONS(NSUInteger, HNNewsType){
//    HNNewsLatest,
//    HNNewsBusiness,
//    HNNewsTech,
//    HNNewsSports
//};

@interface HNSection : MTLModel <MTLJSONSerializing, NSCoding>


@property (nonatomic) NSNumber *identifier;
@property (nonatomic) NSString *title;
@property (nonatomic) UIColor *primaryColor;
@property (nonatomic) UIColor *secondaryColor;
@property (nonatomic) id contentViewController;
@property (nonatomic) NSString *endpoint;
@property (nonatomic) NSInteger newsType;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL show;
@end
