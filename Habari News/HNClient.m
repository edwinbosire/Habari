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
    
    /**
     *  If last update was less than 4hours ago, retrieve stored data, else try and fetch new data
     */
    
    NSTimeInterval secsSince = [[NSDate date] timeIntervalSinceDate:section.lastUpdate];
    if (secsSince > 21600 || isnan(secsSince)) { //4 * 60 * 60 = 4 hours
         [self loadNewsFromSection:section completion:block];
    }else{
        
        NSArray *news = [HNArticle getNewsForSection:section];
        if (block) {
            block(news);
        }
    }
}

// Load remote data
- (void)loadNewsFromSection:(HNSection *)section completion:(void(^)(NSArray *articles))block {
        
    [self GET:section.endpoint
       parameters:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
              
//              NSError *error = nil;
//              NSArray *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:&error];
              
              NSMutableArray *results = [NSMutableArray new];
              for (NSDictionary *article in responseObject) {
                  
                  HNArticle *anArticle = [HNArticle articleWithObject:article];
                  [anArticle addSectionsObject:section];
                  [results addObject:anArticle];
              }
             
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"freshDataReceived" object:nil];
                  section.lastUpdate = [NSDate date];
              });
               [[EBDataManager shared] saveContext];
              NSArray *news = [HNArticle getNewsForSection:section];
              if (block) {
                  block(news);
              }
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              
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
        
        if (dict[@"enabled"]) {
            
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
        
    }
    
    [[EBDataManager shared] saveContext];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kINITIAL_LOAD];
    
}

@end
