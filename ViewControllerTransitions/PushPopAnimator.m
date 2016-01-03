//
//  PushPopAnimator.m
//  ViewControllerTransitions
//
//  Created by Ash Robinson on 03/01/2016.
//  Copyright © 2016 Example. All rights reserved.
//

#import "PushPopAnimator.h"

@implementation PushPopAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *container = [transitionContext containerView];
    UIView *animatingView = self.isPresenting ? toVC.view : fromVC.view;
    
    CGRect offsetFrame = CGRectOffset(container.frame, CGRectGetWidth(container.frame), 0);
    CGRect finalFrame = self.isPresenting ?  container.frame : offsetFrame;
    
    if (self.isPresenting) {

        animatingView.frame = offsetFrame;
        [container addSubview:animatingView];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:2.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         animatingView.frame = finalFrame;
        
    } completion:^(BOOL finished) {
        
        BOOL cancelled = [transitionContext transitionWasCancelled];
        
        [transitionContext completeTransition:!cancelled];
        
        if (self.isPresenting && toVC.navigationController) {
            [container insertSubview:fromVC.view belowSubview:toVC.view];
            
        } else if (fromVC.navigationController && cancelled) {
            [container insertSubview:toVC.view belowSubview:fromVC.view];
        }
    }];
}

@end
