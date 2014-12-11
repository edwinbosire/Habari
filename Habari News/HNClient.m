//
//  HNClient.m
//  Habari News
//
//  Created by edwin bosire on 16/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNClient.h"
#import "HNSection.h"
#import "HNArticle.h"
#import "HNSection+Extension.h"
#import "HNArticle+Extension.h"
#import "UIImage+ImageEffects.h"
#import "EBDataManager.h"

#define kINITIAL_LOAD @"initialLoad"

@implementation HNClient

+ (instancetype) shareClient {
    static id shared = nil;
    if (shared == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared = [[self alloc] init];
        });
    }
    return shared;
}

- (id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:@"http://5.79.0.216/"]];
    
    if (self) {
        
        [self loadSectionsFromFile];
    }
    
    return self;
}


- (void)retrieveLatestNewsWithSectionItem:(HNSection *)section completionBlock:(void (^)(NSArray *articles))block {
    
    NSArray *news = [HNArticle getNewsForSection:section];
    
    if (!news || news.count < 1){
        [self loadNewsFromSection:section completion:block];
    }
    
    if (block) {
        block(news);
    }
}

// Load remote data
- (void)loadNewsFromSection:(HNSection *)section completion:(void(^)(NSArray *articles))block {
    
    [self setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    [self getPath:section.endpoint
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSError *error = nil;
              NSArray *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:&error];
              
              NSMutableArray *results = [NSMutableArray new];
              for (NSDictionary *article in response) {
                  
                  HNArticle *anArticle = [HNArticle articleWithObject:article];
                  [anArticle addSectionsObject:section];
                  [results addObject:anArticle];
              }
              [[EBDataManager shared] saveContext];
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"freshDataReceived" object:nil];
              });
              
              if (block) {
                  block(results);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Shits hit the fan, fetching feeds for %@ failed", section.title);
              if (block) {
                  block(nil);
              }
          }];
    
    
}

#pragma mark - Image Tings

- (UIImage *)saveBackgroundImage{
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"Stars"] applyLightEffect];
    NSData *pngData = UIImagePNGRepresentation(backgroundImage);
    
    [pngData writeToFile:[self documentPathWithName:@"blurredImage.png"] atomically:YES];
    
    return backgroundImage;
}

- (UIImage *)retrieveBackgroundImage{
    
    NSData *pngData = [NSData dataWithContentsOfFile:[self documentPathWithName:@"blurredImage.png"]];
    UIImage *image =  [UIImage imageWithData:pngData];
    if (!pngData) {
        image = [self saveBackgroundImage];
    }
    return image;
}

- (NSString *)documentPathWithName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

- (void)loadSectionsFromFile{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kINITIAL_LOAD]) {
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NewsSections" ofType:@"plist"];
    NSArray *sections = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSMutableArray *sectionItems = [NSMutableArray new];
    
    for (NSDictionary *dict in sections) {
        
        HNSection *sect = [HNSection create];
        sect.sectionId = @([[dict[@"sectionId"] description] integerValue]);
        sect.title = dict[@"title"];
        sect.endpoint = dict[@"url"];
        sect.primaryColor = dict[@"primaryColor"];
        sect.secondaryColor = dict[@"secondaryColor"];
        sect.enabled = dict[@"enabled"];
        sect.show = dict[@"show"];
        
        [sectionItems addObject:sect];
    }
    
    [[EBDataManager shared] saveContext];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kINITIAL_LOAD];
    
}

@end
