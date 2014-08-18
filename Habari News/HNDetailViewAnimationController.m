//
//  HNDetailViewAnimationController.m
//  Habari News
//
//  Created by edwin bosire on 16/08/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNDetailViewAnimationController.h"
#import "HNNewsDetailViewController.h"
#import "HNGenericNewsViewController.h"
#import "HNNewsCollectionViewCell.h"
#import "HNHeaderView.h"

@implementation HNDetailViewAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    HNNewsDetailViewController *fromViewController = (HNNewsDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    HNGenericNewsViewController *toViewController = (HNGenericNewsViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    [containerView addSubview:toViewController.view];
//    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    UICollectionView *toCollectionView = toViewController.collectionView;
    HNHeaderView *fromHeaderView = fromViewController.headerView;

    HNNewsCollectionViewCell *toCell = toViewController.selectedCell; //(HNNewsCollectionViewCell *)[toCollectionView cellForItemAtIndexPath:toViewController.selectedIndexPath];
    
    UIImageView *headerImageSnapShot = [[UIImageView alloc] initWithFrame:fromHeaderView.headerImage.frame];
    headerImageSnapShot.image = fromHeaderView.headerImage.image;
    headerImageSnapShot.contentMode = UIViewContentModeScaleAspectFill;
    headerImageSnapShot.clipsToBounds = YES;
    headerImageSnapShot.frame = [containerView convertRect:fromHeaderView.headerImage.frame fromView:fromHeaderView.headerImage.superview];
   
    if (CGRectGetMinY(headerImageSnapShot.frame) < 0) { //Scenario where the image has been scrolled past screen
        headerImageSnapShot.frame = CGRectOffset(headerImageSnapShot.frame, 0, -CGRectGetMinY(headerImageSnapShot.frame) + 64.0f);
    }
    
    fromHeaderView.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0.0f;
    toCell.hidden = YES;
    [containerView insertSubview:headerImageSnapShot aboveSubview:toViewController.collectionView];
    
    if (!toCell) {
        NSLog(@"No destination cell, wait for animation to complete before navigating away");
    }
    
    [UIView animateWithDuration: [self transitionDuration:transitionContext]
                     animations:^{
                         
                         CGFloat offScreenOffset = 200;
                         fromViewController.titleView.frame = CGRectOffset(fromViewController.titleView.frame, 0.0f, offScreenOffset);
                         fromViewController.authorView.frame = CGRectOffset(fromViewController.authorView.frame, 0.0f, offScreenOffset);
                         fromViewController.contentView.frame = CGRectOffset(fromViewController.contentView.frame, 0.0f, offScreenOffset);
                         fromViewController.webButtonView.frame = CGRectOffset(fromViewController.webButtonView.frame, 0.0f, offScreenOffset);
                         
                         fromViewController.titleView.alpha = fromViewController.authorView.alpha = fromViewController.contentView.alpha = fromViewController.webButtonView.alpha = 0.0f;

                         toViewController.view.alpha = 1.0f;
                         CGRect finalFrame = [containerView convertRect:toCell.frame fromView:toViewController.collectionView];
                         headerImageSnapShot.frame = finalFrame;
                         
                     } completion:^(BOOL finished) {
                         fromViewController.view.alpha = 1;
                         toCell.hidden = NO;
                          fromHeaderView.hidden = NO;
                        
                         [UIView animateWithDuration:0.3f
                                          animations:^{
                                              
                                              headerImageSnapShot.alpha = 0.0f;
                                          } completion:^(BOOL finished) {
                                              [headerImageSnapShot removeFromSuperview];
                                                [transitionContext completeTransition:YES];
                                          }];
                       
                     }];
    
    
}


@end
