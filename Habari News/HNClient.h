//
//  HNClient.h
//  Habari News
//
//  Created by edwin bosire on 16/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OVCClient.h"

typedef NS_OPTIONS(NSUInteger, HNNewsType){
    HNNewsLatest,
    HNNewsBusiness,
    HNNewsTech,
    HNNewsSports
};

@interface HNClient : OVCClient

- (void)retrieveLatestNewsWithType:(HNNewsType)type WithcompletionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)loadNewsFromCacheWithType:(HNNewsType)type completion:(void (^)(NSArray *results, NSError *error))completion;
@end
