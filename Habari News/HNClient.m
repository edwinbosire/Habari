//
//  HNClient.m
//  Habari News
//
//  Created by edwin bosire on 16/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNClient.h"
#import "Article.h"
#import "AFOAuth2Client.h"



@implementation HNClient


- (id)init {
    return [super initWithBaseURL:[NSURL URLWithString:@"http://5.79.0.216/"]];
}


- (void)retrieveLatestNewsWithType:(HNNewsType)type WithcompletionBlock:(void (^)(NSArray *results, NSError *error))block {
    NSParameterAssert(block);
    
//    NSString *path = [NSString stringWithFormat:@"/categories/%@.json?api=rxTXJZA9deBeoDsqq6DD&limit=10", [self enumToString:type]];
    NSString *path = [NSString stringWithFormat:@"/popular%@", [self enumToString:type]];

    OVCClient *client = [[OVCClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://5.79.0.216/"]];
    OVCQuery *products = [OVCQuery queryWithMethod:OVCQueryMethodGet
                                              path:(type == HNNewsLatest)? @"": path
                                        parameters:nil
                                        modelClass:[Article class]
                                     objectKeyPath:nil];
    
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client executeQuery:products completionBlock:^(OVCRequestOperation *operation, NSArray *articles, NSError *error) {
        if (!error) {
            NSLog(@"success");
            block(articles, nil);
            [NSKeyedArchiver archiveRootObject:articles toFile:[self pathForNewsOfType:type]];
        }
    }];
    
}

- (void)loadNewsFromCacheWithType:(HNNewsType)type completion:(void (^)(NSArray *results, NSError *error))completion{
    NSParameterAssert(completion);

    NSString *path = [self pathForNewsOfType:type];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = [NSError errorWithDomain:@"HabariNews" code:0001 userInfo:@{@"reason": @"file does not exist"}];
        completion(nil, error);
    }
    NSArray *results = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForNewsOfType:type]];
    completion(results, nil);
}

- (NSString *)pathForNewsOfType:(HNNewsType)type{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/x%@",[paths firstObject],[self enumToString:type]];
}

- (NSString *)enumToString:(HNNewsType)type{
    
    NSString *results = nil;
    
    switch(type){
        case HNNewsBusiness:
            results = @"/Business";
            break;
        case HNNewsLatest:
            results = @"";
            break;
        case HNNewsSports:
            results = @"/Sports";
            break;
        case HNNewsTech:
            results = @"/Technology";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected News Type."];
    }
    return results;
}

- (void)cacheNewArticles:(NSArray *)articles{
    
    //Find old cache & Delete it.
    
    //Save new cache
    
}
@end
