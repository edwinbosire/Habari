//
//  HNListViewAnimationController.m
//  Habari News
//
//  Created by edwin bosire on 16/08/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNListViewAnimationController.h"
#import "HNNewsDetailViewController.h"
#import "HNGenericNewsViewController.h"
#import "HNNewsCollectionViewCell.h"
#import "HNHeaderView.h"

@implementation HNListViewAnimationController


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    HNNewsDetailViewController *toViewController = (HNNewsDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    HNGenericNewsViewController *fromViewController = (HNGenericNewsViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
    
    UICollectionView *fromCollectionView = fromViewController.collectionView;
    HNNewsCollectionViewCell *fromCell = (HNNewsCollectionViewCell *)[fromCollectionView cellForItemAtIndexPath:[fromCollectionView.indexPathsForSelectedItems firstObject]];
 
    UIImageView *cellImageSnapShot = [[UIImageView alloc] initWithFrame:fromCell.image.frame];
    cellImageSnapShot.image = fromCell.image.image;
    cellImageSnapShot.contentMode = UIViewContentModeScaleAspectFill;
    cellImageSnapShot.clipsToBounds = YES;
    cellImageSnapShot.frame = [containerView convertRect:fromCell.image.frame fromView:fromCell.image.superview];
   
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:fromCell.title.frame];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font =  [UIFont boldSystemFontOfSize: 14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = fromCell.title.text;
    
    label.frame = [containerView.window convertRect:fromCell.title.frame fromView:fromCell.title.superview];
    
    fromCell.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0.0f;
    toViewController.headerView.hidden = YES;
//    toViewController.navigationItem.titleView.hidden = YES;
    [containerView insertSubview:cellImageSnapShot aboveSubview:toViewController.view];
//    [containerView.window insertSubview:label aboveSubview:cellImageSnapShot];
   
    [UIView animateWithDuration: [self transitionDuration:transitionContext]
                     animations:^{
                         
                         toViewController.view.alpha = 1.0f;
                         cellImageSnapShot.frame = [containerView convertRect:toViewController.headerView.frame fromView:toViewController.scrollView];
//                         label.frame = CGRectMake(55.0f, 20.0f, 190, 44.0f);//[containerView.window convertRect:toViewController.navigationController.navigationBar.frame fromView:toViewController.view.superview];
                         
                     } completion:^(BOOL finished) {
                         fromViewController.view.alpha = 1;
                         toViewController.headerView.hidden = NO;
                         fromCell.hidden = NO;
//                         toViewController.navigationItem.titleView.hidden = NO;

                         [UIView animateWithDuration:0.3f
                                          animations:^{
                                              
                                              cellImageSnapShot.alpha = 0.0f;
                                              label.alpha = 0.0f;
                                          } completion:^(BOOL finished) {
                                              [cellImageSnapShot removeFromSuperview];
                                              [transitionContext completeTransition:YES];
                                          }];
                         
                     }];
    
    
}

@end
