//
//  GTUIBottomSheetPresentationController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import "GTUIBottomSheetPresentationController.h"
#import "GTMath.h"
#import "private/GTUISheetContainerView.h"

static UIScrollView *GTUIBottomSheetGetPrimaryScrollView(UIViewController *viewController) {
    UIScrollView *scrollView = nil;

    // Ensure the view is loaded - occasionally during non-animated transitions the view may not be
    // loaded yet (but the scrollview is still needed for scroll-tracking to work properly).
    if (![viewController isViewLoaded]) {
        (void)viewController.view;
    }

    if ([viewController isKindOfClass:[GTUIBottomSheetController class]]) {
        viewController = ((GTUIBottomSheetController *)viewController).contentViewController;
    }

    if ([viewController.view isKindOfClass:[UIScrollView class]]) {
        scrollView = (UIScrollView *)viewController.view;
    } else if ([viewController.view isKindOfClass:[UIWebView class]]) {
        scrollView = ((UIWebView *)viewController.view).scrollView;
    } else if ([viewController isKindOfClass:[UICollectionViewController class]]) {
        scrollView = ((UICollectionViewController *)viewController).collectionView;
    }
    return scrollView;
}

@interface GTUIBottomSheetPresentationController () <GTUISheetContainerViewDelegate>
@end

@interface GTUIBottomSheetPresentationController ()
@property(nonatomic, strong) GTUISheetContainerView *sheetView;
@end

@implementation GTUIBottomSheetPresentationController {
    UIView *_dimmingView;
@private BOOL _scrimIsAccessibilityElement;
@private NSString *_scrimAccessibilityLabel;
@private NSString *_scrimAccessibilityHint;
@private UIAccessibilityTraits _scrimAccessibilityTraits;
}

@synthesize delegate;

- (UIView *)presentedView {
    return self.sheetView;
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGSize containerSize = self.containerView.frame.size;
    CGSize preferredSize = self.presentedViewController.preferredContentSize;

    if (preferredSize.width > 0 && preferredSize.width < containerSize.width) {
        // We only customize the width and not the height here. GTUISheetContainerView lays out the
        // presentedView taking the preferred height in to account.
        CGFloat width = preferredSize.width;
        CGFloat leftPad = (containerSize.width - width) / 2;
        return CGRectMake(leftPad, 0, width, containerSize.height);
    } else {
        return [super frameOfPresentedViewInContainerView];
    }
}

- (void)presentationTransitionWillBegin {
    id<GTUIBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(prepareForBottomSheetPresentation:)]) {
        [strongDelegate prepareForBottomSheetPresentation:self];
    }

    UIView *containerView = [self containerView];

    _dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
    _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    _dimmingView.translatesAutoresizingMaskIntoConstraints = NO;
    _dimmingView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _dimmingView.accessibilityTraits |= UIAccessibilityTraitButton;
    _dimmingView.isAccessibilityElement = _scrimIsAccessibilityElement;
    _dimmingView.accessibilityTraits = _scrimAccessibilityTraits;
    _dimmingView.accessibilityLabel = _scrimAccessibilityLabel;
    _dimmingView.accessibilityHint = _scrimAccessibilityHint;

    UIScrollView *scrollView = self.trackingScrollView;
    if (scrollView == nil) {
        scrollView = GTUIBottomSheetGetPrimaryScrollView(self.presentedViewController);
    }
    CGRect sheetFrame = [self frameOfPresentedViewInContainerView];
    self.sheetView = [[GTUISheetContainerView alloc] initWithFrame:sheetFrame
                                                      contentView:self.presentedViewController.view
                                                       scrollView:scrollView];
    self.sheetView.delegate = self;
    self.sheetView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    [containerView addSubview:_dimmingView];
    [containerView addSubview:self.sheetView];

    [self updatePreferredSheetHeight];

    // Add tap handler to dismiss the sheet.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:
                                          @selector(dismissPresentedControllerIfNecessary:)];
    tapGesture.cancelsTouchesInView = NO;
    containerView.userInteractionEnabled = YES;
    [containerView addGestureRecognizer:tapGesture];

    id <UIViewControllerTransitionCoordinator> transitionCoordinator =
    [[self presentingViewController] transitionCoordinator];

    // Fade in the dimming view during the transition.
    _dimmingView.alpha = 0.0;
    [transitionCoordinator animateAlongsideTransition:
     ^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
         self->_dimmingView.alpha = 1.0;
     }                                  completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        [_dimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    id <UIViewControllerTransitionCoordinator> transitionCoordinator =
    [[self presentingViewController] transitionCoordinator];

    [transitionCoordinator animateAlongsideTransition:
     ^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
         self->_dimmingView.alpha = 0.0;
     }                                  completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [_dimmingView removeFromSuperview];
    }
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    self.sheetView.frame = [self frameOfPresentedViewInContainerView];
    [self.sheetView layoutIfNeeded];
    [self updatePreferredSheetHeight];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator
     animateAlongsideTransition:^(
                                  __unused id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
         self.sheetView.frame = [self frameOfPresentedViewInContainerView];
         [self.sheetView layoutIfNeeded];
         [self updatePreferredSheetHeight];
     }
     completion:nil];
}

/**
 Sets the new value of @c sheetView.preferredSheetHeight.
 If @c preferredContentHeight is non-positive, it will set it to half of sheetView's
 frame's height.
 */
- (void)updatePreferredSheetHeight {
    // If |preferredSheetHeight| has not been specified, use half of the current height.
    CGFloat preferredSheetHeight;
    if (self.preferredSheetHeight > 0.f) {
        preferredSheetHeight = self.preferredSheetHeight;
    } else {
        preferredSheetHeight = self.presentedViewController.preferredContentSize.height;
    }

    if (GTUICGFloatEqual(preferredSheetHeight, 0)) {
        preferredSheetHeight = GTUIRound(CGRectGetHeight(self.sheetView.frame) / 2);
    }
    self.sheetView.preferredSheetHeight = preferredSheetHeight;
}

- (void)dismissPresentedControllerIfNecessary:(UITapGestureRecognizer *)tapRecognizer {
    if (!_dismissOnBackgroundTap) {
        return;
    }
    // Only dismiss if the tap is outside of the presented view.
    UIView *contentView = self.presentedViewController.view;
    CGPoint pointInContentView = [tapRecognizer locationInView:contentView];
    if ([contentView pointInside:pointInContentView withEvent:nil]) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.closeFinishHandler) weakSelf.closeFinishHandler();
    }];

    id<GTUIBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:
         @selector(bottomSheetPresentationControllerDidDismissBottomSheet:)]) {
        [strongDelegate bottomSheetPresentationControllerDidDismissBottomSheet:self];
    }
}

#pragma mark - Properties

- (void)setIsScrimAccessibilityElement:(BOOL)isScrimAccessibilityElement {
    _scrimIsAccessibilityElement = isScrimAccessibilityElement;
    _dimmingView.isAccessibilityElement = isScrimAccessibilityElement;
}

- (BOOL)isScrimAccessibilityElement {
    return _scrimIsAccessibilityElement;
}

- (void)setScrimAccessibilityLabel:(NSString *)scrimAccessibilityLabel {
    _scrimAccessibilityLabel = scrimAccessibilityLabel;
    _dimmingView.accessibilityLabel = scrimAccessibilityLabel;
}

- (NSString *)scrimAccessibilityLabel {
    return _scrimAccessibilityLabel;
}

- (void)setScrimAccessibilityHint:(NSString *)scrimAccessibilityHint {
    _scrimAccessibilityHint = scrimAccessibilityHint;
    _dimmingView.accessibilityHint = scrimAccessibilityHint;
}

- (NSString *)scrimAccessibilityHint {
    return _scrimAccessibilityHint;
}

- (void)setScrimAccessibilityTraits:(UIAccessibilityTraits)scrimAccessibilityTraits {
    _scrimAccessibilityTraits = scrimAccessibilityTraits;
    _dimmingView.accessibilityTraits = scrimAccessibilityTraits;
}

- (UIAccessibilityTraits)scrimAccessibilityTraits {
    return _scrimAccessibilityTraits;
}

- (void)setPreferredSheetHeight:(CGFloat)preferredSheetHeight {
    _preferredSheetHeight = preferredSheetHeight;
    [self updatePreferredSheetHeight];
}

#pragma mark - GTUISheetContainerViewDelegate

- (void)sheetContainerViewDidHide:(nonnull __unused GTUISheetContainerView *)containerView {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    id<GTUIBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:
         @selector(bottomSheetPresentationControllerDidDismissBottomSheet:)]) {
        [strongDelegate bottomSheetPresentationControllerDidDismissBottomSheet:self];
    }
}

- (void)sheetContainerViewWillChangeState:(nonnull GTUISheetContainerView *)containerView
                               sheetState:(GTUISheetState)sheetState {
    id<GTUIBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:
         @selector(bottomSheetWillChangeState:sheetState:)]) {
        [strongDelegate bottomSheetWillChangeState:self sheetState:sheetState];
    }
}

@end

