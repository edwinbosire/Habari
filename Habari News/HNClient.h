//
//  HNClient.h
//  Habari News
//
//  Created by edwin bosire on 16/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_OPTIONS(NSUInteger, HNNewsType){
    HNNewsLatest,
    HNNewsBusiness,
    HNNewsTech,
    HNNewsSports
};

@class HNSection;
@interface HNClient : AFHTTPSessionManager

@property (nonatomic) NSMutableArray *sectionItems;

+ (id)shareClient;

- (void)retrieveLatestNewsWithSectionItem:(HNSection *)section completionBlock:(void (^)(NSArray *articles))block;

- (UIImage *)retrieveBackgroundImage;

@end
