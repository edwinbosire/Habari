//
//  HNArticle.h
//  Habari
//
//  Created by edwin bosire on 22/09/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HNArticle : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, strong) NSString * excerpt;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * newsId;
@property (nonatomic, retain) NSDate * datePublished;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSString * largeImage;
@property (nonatomic, retain) NSString * smallImage;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSNumber * originalImageWidth;
@property (nonatomic, retain) NSNumber * originalImageHeight;

@end
