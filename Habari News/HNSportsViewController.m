//
//  HNSportsViewController.m
//  Habari News
//
//  Created by edwin bosire on 21/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNSportsViewController.h"

@interface HNSportsViewController ()

@end

@implementation HNSportsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.viewControllerTitle = @"Sports";
    [self setNewsType:HNNewsSports];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
