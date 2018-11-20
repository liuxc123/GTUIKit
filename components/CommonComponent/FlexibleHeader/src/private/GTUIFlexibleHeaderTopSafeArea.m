//
//  GTUIFlexibleHeaderTopSafeArea.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import "GTUIFlexibleHeaderTopSafeArea.h"

#import "GTUIFlexibleHeaderView.h"

// The default status bar height for non-X devices.
static const CGFloat kNonXStatusBarHeight = 20;

@interface GTUIFlexibleHeaderTopSafeArea ()
// We use this value to correctly handle top safe area insets on non-iPhone X devices.
@property(nonatomic) CGFloat lastNonZeroTopSafeAreaInset;
@property(nonatomic) CGFloat extractedTopSafeAreaInset;
@end

@implementation GTUIFlexibleHeaderTopSafeArea

@synthesize extractedTopSafeAreaInset = _extractedTopSafeAreaInset;

#pragma mark - Public

- (void)setTopSafeAreaSourceViewController:(UIViewController *)topSafeAreaSourceViewController {
    _topSafeAreaSourceViewController = topSafeAreaSourceViewController;

    if (self.inferTopSafeAreaInsetFromViewController) {
        [self extractTopSafeAreaInset];
    }
}

- (CGFloat)topSafeAreaInset {
    if (self.inferTopSafeAreaInsetFromViewController) {
        // Generally-speaking, we consider the top safe area inset to equate to the length of any
        // "device-owned" pixels.
        //
        // On an iPhone X, the top safe area inset is a fixed hardware constant, varying only based on
        // device orientation.
        //
        // On non-X devices, however, the top safe area inset is a flexible software value reflecting
        // the status bar's current height. If the status bar is hidden, the top safe area inset is
        // zero.
        //
        // This affects the flexible header mostly when the status bar shift behavior is enabled. The
        // flexible header is able to hide the status bar interactively, meaning our top safe area inset
        // can fluctuate between 0 and 20 on non-X devices as we show/hide the status bar. This can
        // cause the tracking scroll view's content inset to "jump" because we make the scroll view's
        // top content inset equal maximumHeight + topSafeAreaInset.
        //
        // Aside: If we only supported iOS 11 and up we'd likely be able to simplify a lot of this
        // behavior by solely relying on additionalSafeAreaInsets. Alas, that will likely be sometime
        // after 2020.
        //
        // So, to avoid the jumping behavior, we keep track of what the last non-zero top safe area
        // inset was. If it was 20 and we know we've programmatically hidden the status bar, we continue
        // to pretend that the top safe area inset is 20. Once the status bar is visible again we rely
        // on the actual topSafeAreaInset value.
        BOOL topSafeAreaInsetLikelyAffectedByStatusBarVisibility =
        self.lastNonZeroTopSafeAreaInset == kNonXStatusBarHeight;
        if (topSafeAreaInsetLikelyAffectedByStatusBarVisibility &&
            [self.delegate flexibleHeaderSafeAreaIsStatusBarShifted:self]) {
            return self.lastNonZeroTopSafeAreaInset;
        } else {
            return self.extractedTopSafeAreaInset;
        }
    } else {
        return [self.delegate flexibleHeaderSafeAreaDeviceTopSafeAreaInset:self];
    }
}

- (void)safeAreaInsetsDidChange {
    if (self.inferTopSafeAreaInsetFromViewController) {
        [self extractTopSafeAreaInset];
    } else {
        // The device safe area insets may have changed, so we always fall back to calling the delegate.
        [self.delegate flexibleHeaderSafeAreaTopSafeAreaInsetDidChange:self];
    }
}

- (void)setInferTopSafeAreaInsetFromViewController:(BOOL)inferTopSafeAreaInsetFromViewController {
    if (_inferTopSafeAreaInsetFromViewController == inferTopSafeAreaInsetFromViewController) {
        return;
    }
    _inferTopSafeAreaInsetFromViewController = inferTopSafeAreaInsetFromViewController;

    if (_inferTopSafeAreaInsetFromViewController) {
        [self extractTopSafeAreaInset];
    } else {
        [self.delegate flexibleHeaderSafeAreaTopSafeAreaInsetDidChange:self];
    }
}

#pragma mark - Private

- (void)setExtractedTopSafeAreaInset:(CGFloat)extractedTopSafeAreaInset {
    _extractedTopSafeAreaInset = extractedTopSafeAreaInset;

    if (_extractedTopSafeAreaInset > 0) {
        self.lastNonZeroTopSafeAreaInset = _extractedTopSafeAreaInset;
    }

    // No need to inform the delegate if this behavior is diabled.
    if (self.inferTopSafeAreaInsetFromViewController) {
        [self.delegate flexibleHeaderSafeAreaTopSafeAreaInsetDidChange:self];
    }
}

- (void)extractTopSafeAreaInset {
    UIViewController *viewController = self.topSafeAreaSourceViewController;
    if (![viewController isViewLoaded]) {
        self.extractedTopSafeAreaInset = 0;
        return;
    }

    if (@available(iOS 11.0, *)) {
        self.extractedTopSafeAreaInset = viewController.view.safeAreaInsets.top;
    } else {
        self.extractedTopSafeAreaInset = viewController.topLayoutGuide.length;
    }
}

@end

