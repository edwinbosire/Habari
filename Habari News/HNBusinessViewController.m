//
//  HNBusinessViewController.m
//  Habari News
//
//  Created by edwin bosire on 21/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNBusinessViewController.h"

@interface HNBusinessViewController ()

@end

@implementation HNBusinessViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.viewControllerTitle = @"Business";
    
    [self setNewsType:HNNewsBusiness];
    
}

@end
