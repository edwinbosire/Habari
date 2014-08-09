//
//  HNTechViewController.m
//  Habari News
//
//  Created by edwin bosire on 21/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNTechViewController.h"

@interface HNTechViewController ()

@end

@implementation HNTechViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.viewControllerTitle = @"Tech";
    
    [self setNewsType:HNNewsTech];
    
}

@end
