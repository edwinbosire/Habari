//
//  Habari_NewsTests.m
//  Habari NewsTests
//
//  Created by edwin bosire on 16/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HNClient.h"
#import <Foundation/Foundation.h>

@interface Habari_NewsTests : XCTestCase

@end

@implementation Habari_NewsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBackgroundImage {
	
	HNClient *sut = [HNClient shareClient];
	UIImage *bgImage = [sut retrieveBackgroundImage];
	
	XCTAssert(bgImage, @"background image exists");
}

@end
