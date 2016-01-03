//
//  ViewController.m
//  ViewControllerTransitions
//
//  Created by Ash Robinson on 03/01/2016.
//  Copyright © 2016 Example. All rights reserved.
//

#import "ViewController.h"
#import "ModalViewController.h"
#import "PushPopAnimator.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition* interactionController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.navigationController.view addGestureRecognizer:panRecognizer];
}

- (IBAction)presentModal:(UIButton *)sender {
    [self presentViewController:[self modalController] animated:YES completion:nil];
}

- (IBAction)pushModal:(UIButton *)sender {
    [self.navigationController pushViewController:[self modalController] animated:YES];
}

- (UIViewController *)modalController {
    UIViewController *modal = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ModalViewController class])];
    modal.modalPresentationStyle = UIModalPresentationCustom;
    modal.transitioningDelegate = self;
    return modal;
}

- (id<UIViewControllerAnimatedTransitioning>)pushPopAnimatorForPresentation:(BOOL)presenting {
    PushPopAnimator *animator = [PushPopAnimator new];
    animator.presenting = presenting;
    return animator;
}

- (void)pan:(UIPanGestureRecognizer*)recognizer
{
    UIView* view = self.navigationController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:view];
        if (location.x <  CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) { // left half
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactionController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:view].x > 0) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source {
    return [self pushPopAnimatorForPresentation:YES];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self pushPopAnimatorForPresentation:NO];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    return [self pushPopAnimatorForPresentation:operation == UINavigationControllerOperationPush];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactionController;
}

@end
