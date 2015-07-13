//
//  ArticleTest.m
//  Windmill
//
//  Created by edwin bosire on 08/07/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HNArticle+Extension.h"

@interface ArticleTest : XCTestCase

@end

@implementation ArticleTest

-(void)testThatFullImageURLExtractionWorks {
	
	NSString *url = @"http://i1.wp.com/www.techweez.com/wp-content/uploads/2015/07/NYSE.jpg?resize=150%2C150";
	NSString *expectedFullURL = @"http://i1.wp.com/www.techweez.com/wp-content/uploads/2015/07/NYSE.jpg";
	NSString *fullURL = [HNArticle fullImageURL:url];
	
	XCTAssert(fullURL, @"Full url should not be nil");
	XCTAssertNotEqual(url, fullURL, @"The full url should not have the resize parameter");
	XCTAssert([fullURL isEqualToString:expectedFullURL], @"Extracted url should be similar to expected url");
	
}

- (void)testPerfomanceformanceForDataConversion {
	
	NSString *dateString = @"2015-06-29 11:30:05";
	
	[self measureBlock:^{
		
		NSDate *date =	[HNArticle dateFromString:dateString];
		date = nil;
	}];
}
@end
