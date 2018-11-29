//
//  GTUIDialogPresentationController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import "GTUIDialogPresentationController.h"

#import "GTKeyboardWatcher.h"
#import "GTShadowLayer.h"
#import "private/GTUIDialogShadowedView.h"

static CGFloat GTUIDialogMinimumWidth = 280.0f;
// TODO: Spec indicates 40 side margins and 280 minimum width.
// That is incompatible with a 320 wide device.
// Side margins set to 20 until we have a resolution
static UIEdgeInsets GTUIDialogEdgeInsets = {24, 20, 24, 20};

@interface GTUIDialogPresentationController ()

// View matching the container's bounds that dims the entire screen and catchs taps to dismiss.
@property(nonatomic) UIView *dimmingView;

// Tracking view that adds a shadow under the presented view. This view's frame should always match
// the presented view's.
@property(nonatomic) GTUIDialogShadowedView *trackingView;

@end

@implementation GTUIDialogPresentationController{
    UITapGestureRecognizer *_dismissGestureRecognizer;
}

#pragma mark - UIPresentationController

// dismissOnBackgroundTap wraps the enable property of our gesture recognizer to
// avoid duplication.
- (void)setDismissOnBackgroundTap:(BOOL)dismissOnBackgroundTap {
    _dismissGestureRecognizer.enabled = dismissOnBackgroundTap;
}

- (BOOL)dismissOnBackgroundTap {
    return _dismissGestureRecognizer.enabled;
}

// presentedViewCornerRadius wraps the cornerRadius property of our tracking view to avoid
// duplication.
- (void)setDialogCornerRadius:(CGFloat)cornerRadius {
    _trackingView.layer.cornerRadius = cornerRadius;
}

- (CGFloat)dialogCornerRadius {
    return _trackingView.layer.cornerRadius;
}

- (void)setScrimColor:(UIColor *)scrimColor {
    self.dimmingView.backgroundColor = scrimColor;
}

- (UIColor *)scrimColor {
    return self.dimmingView.backgroundColor;
}

- (void)setDialogElevation:(GTUIShadowElevation)dialogElevation {
    _trackingView.elevation = dialogElevation;
}

- (CGFloat)dialogElevation {
    return _trackingView.elevation;
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if (self) {
        _dimmingView = [[UIView alloc] initWithFrame:CGRectZero];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.32f];
        _dimmingView.alpha = 0.0f;
        _dismissGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [_dimmingView addGestureRecognizer:_dismissGestureRecognizer];

        _trackingView = [[GTUIDialogShadowedView alloc] init];

        [self registerKeyboardNotifications];
    }

    return self;
}

- (void)dealloc {
    [self unregisterKeyboardNotifications];
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGRect containerBounds = CGRectStandardize(self.containerView.bounds);

    // For pre iOS 11 devices, we are assuming a safeAreaInset of UIEdgeInsetsZero
    UIEdgeInsets containerSafeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        containerSafeAreaInsets = self.containerView.safeAreaInsets;
    }

    // Take the larger of the Safe Area insets and the Material specified insets.
    containerSafeAreaInsets.top = MAX(containerSafeAreaInsets.top, GTUIDialogEdgeInsets.top);
    containerSafeAreaInsets.left = MAX(containerSafeAreaInsets.left, GTUIDialogEdgeInsets.left);
    containerSafeAreaInsets.right = MAX(containerSafeAreaInsets.right, GTUIDialogEdgeInsets.right);
    containerSafeAreaInsets.bottom = MAX(containerSafeAreaInsets.bottom, GTUIDialogEdgeInsets.bottom);

    // Take into account a visible keyboard
    CGFloat keyboardHeight = [GTUIKeyboardWatcher sharedKeyboardWatcher].visibleKeyboardHeight;
    containerSafeAreaInsets.bottom = MAX(containerSafeAreaInsets.bottom, keyboardHeight);

    // Area that the presented dialog can use.
    CGRect standardPresentableBounds = UIEdgeInsetsInsetRect(containerBounds, containerSafeAreaInsets);

    CGRect presentedViewFrame = CGRectZero;
    presentedViewFrame.size = [self sizeForChildContentContainer:self.presentedViewController
                                         withParentContainerSize:standardPresentableBounds.size];

    presentedViewFrame.origin.x =
    containerSafeAreaInsets.left + (standardPresentableBounds.size.width - presentedViewFrame.size.width) * 0.5f;
    presentedViewFrame.origin.y =
    containerSafeAreaInsets.top + (standardPresentableBounds.size.height - presentedViewFrame.size.height) * 0.5f;

    presentedViewFrame.origin.x = (CGFloat)floor(presentedViewFrame.origin.x);
    presentedViewFrame.origin.y = (CGFloat)floor(presentedViewFrame.origin.y);

    return presentedViewFrame;
}

- (void)presentationTransitionWillBegin {
    // TODO: Follow the Material spec description of Autonomous surface creation for both
    // presentation and dismissal of the dialog.
    // https://material.io/guidelines/motion/choreography.html#choreography-creation

    // Set the dimming view to the container's bounds and fully transparent.
    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.alpha = 0.0f;
    [self.containerView addSubview:self.dimmingView];

    // Set the shadowing view to the same frame as the presented view.
    CGRect presentedFrame = [self frameOfPresentedViewInContainerView];
    self.trackingView.frame = presentedFrame;
    self.trackingView.alpha = 0.0f;
    [self.containerView addSubview:self.trackingView];

    // Fade-in chrome views to be fully visible.
    id<UIViewControllerTransitionCoordinator> transitionCoordinator =
    [self.presentedViewController transitionCoordinator];
    if (transitionCoordinator) {
        [transitionCoordinator
         animateAlongsideTransition:
         ^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
             self.dimmingView.alpha = 1.0f;
             self.trackingView.alpha = 1.0f;
         }
         completion:NULL];
    } else {
        self.dimmingView.alpha = 1.0f;
        self.trackingView.alpha = 1.0f;
    }
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (completed) {
        // Stop the presenting view from being tapped for voiceover while this view is up.
        // Setting @c accessibilityViewIsModal on the presented view (or its parent) should be enough,
        // but it's not.
        // b/19519321
        self.presentingViewController.view.accessibilityElementsHidden = YES;
        self.presentedView.accessibilityViewIsModal = YES;
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, [self presentedView]);
    } else {
        // Transition was cancelled.
        [self.dimmingView removeFromSuperview];
        [self.trackingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    // Fade-out dimmingView and trackingView to be fully transparent.
    id<UIViewControllerTransitionCoordinator> transitionCoordinator =
    [self.presentedViewController transitionCoordinator];
    if (transitionCoordinator != nil) {
        [transitionCoordinator
         animateAlongsideTransition:
         ^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
             self.dimmingView.alpha = 0.0f;
             self.trackingView.alpha = 0.0f;
         }
         completion:NULL];
    } else {
        self.dimmingView.alpha = 0.0f;
        self.trackingView.alpha = 0.0f;
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.dimmingView removeFromSuperview];
        [self.trackingView removeFromSuperview];

        // Re-enable accessibilityElements on the presenting view controller.
        self.presentingViewController.view.accessibilityElementsHidden = NO;
    }

    [super dismissalTransitionDidEnd:completed];
}

/**
 Indicate that the presenting view controller's view should not be removed when the presentation
 animations finish.

 GTUIDialogPresentationController does not cover the presenting view controller's content entirely
 so we must return NO.
 */
- (BOOL)shouldRemovePresentersView {
    return NO;
}

#pragma mark - UIContentContainer

/**
 Determines the size of the presented container's view based on available space and the preferred
 content size of the container.
 */
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container
               withParentContainerSize:(CGSize)parentSize {
    if (CGSizeEqualToSize(parentSize, CGSizeZero)) {
        return CGSizeZero;
    }

    CGSize targetSize = parentSize;

    const CGSize preferredContentSize = container.preferredContentSize;
    if (!CGSizeEqualToSize(preferredContentSize, CGSizeZero)) {
        targetSize = preferredContentSize;

        // If the targetSize.width is greater than 0.0 it must be at least GTUIDialogMinimumWidth.
        if (0.0f < targetSize.width && targetSize.width < GTUIDialogMinimumWidth) {
            targetSize.width = GTUIDialogMinimumWidth;
        }
        // targetSize cannot exceed parentSize.
        targetSize.width = MIN(targetSize.width, parentSize.width);
        targetSize.height = MIN(targetSize.height, parentSize.height);
    }

    targetSize.width = (CGFloat)ceil(targetSize.width);
    targetSize.height = (CGFloat)ceil(targetSize.height);

    return targetSize;
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:
     ^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
         self.dimmingView.frame = self.containerView.bounds;
         CGRect presentedViewFrame = [self frameOfPresentedViewInContainerView];
         self.presentedView.frame = presentedViewFrame;
         self.trackingView.frame = presentedViewFrame;
     }
                                 completion:NULL];
}

/**
 If the container's preferred content size has changed and we are able to accommidate the new size,
 update the frame of the presented view and the shadowing view.
 */
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];

    CGSize existingSize = self.presentedView.bounds.size;
    CGSize newSize = [self sizeForChildContentContainer:container
                                withParentContainerSize:self.containerView.bounds.size];

    if (!CGSizeEqualToSize(existingSize, newSize)) {
        CGRect presentedViewFrame = [self frameOfPresentedViewInContainerView];
        self.presentedView.frame = presentedViewFrame;
        self.trackingView.frame = presentedViewFrame;
    }
}

#pragma mark - Internal

- (void)dismiss:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        __weak typeof(self) weakSelf = self;
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.closeFinishHandler) weakSelf.closeFinishHandler();
        }];
    }
}

#pragma mark - Keyboard handling

- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWatcherHandler:)
                                                 name:GTUIKeyboardWatcherKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWatcherHandler:)
                                                 name:GTUIKeyboardWatcherKeyboardWillHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWatcherHandler:)
     name:GTUIKeyboardWatcherKeyboardWillChangeFrameNotification
     object:nil];
}

- (void)unregisterKeyboardNotifications {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:GTUIKeyboardWatcherKeyboardWillShowNotification
     object:nil];

    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:GTUIKeyboardWatcherKeyboardWillHideNotification
     object:nil];

    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:GTUIKeyboardWatcherKeyboardWillChangeFrameNotification
     object:nil];
}

#pragma mark - KeyboardWatcher Notifications

- (void)keyboardWatcherHandler:(NSNotification *)aNotification {
    NSTimeInterval animationDuration =
    [GTUIKeyboardWatcher animationDurationFromKeyboardNotification:aNotification];

    UIViewAnimationOptions animationCurveOption =
    [GTUIKeyboardWatcher animationCurveOptionFromKeyboardNotification:aNotification];

    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:animationCurveOption | UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGRect presentedViewFrame = [self frameOfPresentedViewInContainerView];
                         self.presentedView.frame = presentedViewFrame;
                         self.trackingView.frame = presentedViewFrame;
                     }
                     completion:NULL];
}


@end
