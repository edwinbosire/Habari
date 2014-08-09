//
//  HNLatestNewsViewController.m
//  Habari News
//
//  Created by edwin bosire on 21/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNLatestNewsViewController.h"
#import "HNNewsCollectionViewCell.h"


@interface HNLatestNewsViewController ()

@end

@implementation HNLatestNewsViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.viewControllerTitle = @"Latest News";
    [self setNewsType:HNNewsLatest];
    
}


- (UIView *)viewForZoomTransition{
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    HNNewsCollectionViewCell * cell = (HNNewsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.image;
}

@end
