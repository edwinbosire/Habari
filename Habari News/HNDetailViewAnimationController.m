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
    HNHeaderView *fromHeaderView = fromViewController.headerView;

    HNNewsCollectionViewCell *toCell = toViewController.selectedCell;
	
	UIGraphicsBeginImageContext(fromHeaderView.headerImage.frame.size);
	[fromHeaderView.headerImage.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageView *headerImageSnapShot = [[UIImageView alloc] initWithImage:viewImage];
	
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
		 [transitionContext completeTransition:YES];
		return;
    }
    
    [UIView animateWithDuration: [self transitionDuration:transitionContext]
                     animations:^{

                         toViewController.view.alpha = 1.0f;
                         CGRect finalFrame = [containerView convertRect:toCell.frame fromView:toViewController.collectionView];
						 finalFrame.size = CGSizeMake(finalFrame.size.width, kDefaultImageHeight);
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
