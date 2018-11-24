//
//  GTUIDialogTransitionController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import "GTUIDialogTransitionController.h"

#import "GTUIDialogPresentationController.h"

@implementation GTUIDialogTransitionController

static const NSTimeInterval GTUIDialogTransitionDuration = 0.27;

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:
(__unused id<UIViewControllerContextTransitioning>)transitionContext {
    return GTUIDialogTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // If a view in the transitionContext is nil, it likely hasn't been loaded by its ViewController
    // yet.  Ask for it directly to initiate a loadView on the ViewController.
    UIViewController *fromViewController =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    if (fromView == nil) {
        fromView = fromViewController.view;
    }

    UIViewController *toViewController =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    if (toView == nil) {
        toView = toViewController.view;
    }

    UIViewController *toPresentingViewController = toViewController.presentingViewController;
    BOOL presenting = (toPresentingViewController == fromViewController) ? YES : NO;

    UIViewController *animatingViewController = presenting ? toViewController : fromViewController;
    UIView *animatingView = presenting ? toView : fromView;

    UIView *containerView = transitionContext.containerView;

    if (presenting) {
        [containerView addSubview:toView];
    }

    CGFloat startingAlpha = presenting ? 0.0f : 1.0f;
    CGFloat endingAlpha = presenting ? 1.0f : 0.0f;

    animatingView.frame = [transitionContext finalFrameForViewController:animatingViewController];
    animatingView.alpha = startingAlpha;

    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    UIViewAnimationOptions options =
    UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;

    [UIView animateWithDuration:transitionDuration
                          delay:0.0
                        options:options
                     animations:^{
                         animatingView.alpha = endingAlpha;
                     }
                     completion:^(__unused BOOL finished) {
                         // If we're dismissing, remove the presented view from the hierarchy
                         if (!presenting) {
                             [fromView removeFromSuperview];
                         }

                         // From ADC : UIViewControllerContextTransitioning
                         // When you do create transition animations, always call the
                         // completeTransition: from an appropriate completion block to let UIKit know
                         // when all of your animations have finished.
                         [transitionContext completeTransition:YES];
                     }];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *) presentationControllerForPresentedViewController:(UIViewController *)presented
                                                       presentingViewController:(UIViewController *)presenting
                                                           sourceViewController:(__unused UIViewController *)source {
    return [[GTUIDialogPresentationController alloc] initWithPresentedViewController:presented
                                                           presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(__unused UIViewController *)presented
                                                                  presentingController:(__unused UIViewController *)presenting
                                                                      sourceController:(__unused UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:
(__unused UIViewController *)dismissed {
    return self;
}


@end
