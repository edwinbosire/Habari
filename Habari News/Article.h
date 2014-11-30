//
//  Article.h
//  HABARI V3.0
//
//  Created by edwin bosire on 20/08/2012.
//
//

#import <Foundation/Foundation.h>


@interface Article : NSObject <NSCoding>

@property (nonatomic, strong) NSString * attribute;
@property (nonatomic, strong) NSString * author;
@property (nonatomic, strong) NSString * category;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSDate   * published;
@property (nonatomic, strong) NSString * excerpt;
@property (nonatomic, strong) NSNumber * favourite;
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSURL * image;
@property (nonatomic, strong) NSURL * largeImage;
@property (nonatomic, strong) NSURL * smallImage;
@property (nonatomic, strong) NSURL * thumbnail;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * publisher;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * imageHeight;
@property (nonatomic, strong) NSNumber * imageWidth;
@property (nonatomic, strong) NSNumber *date;

- (CGSize)cellSizeForTitle;
- (NSAttributedString *)attributedStringForTitle;

- (CGSize)cellSizeForAuthor;
- (NSAttributedString *)attributedStringForAuthor;

- (CGSize)cellSizeForContent;
- (NSAttributedString *)attributedStringForContent;

- (NSAttributedString *)attributedStringForCaption;
@end
