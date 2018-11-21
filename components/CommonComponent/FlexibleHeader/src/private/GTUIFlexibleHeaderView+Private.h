//
//  GTUIFlexibleHeaderView+Private.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import "GTUIFlexibleHeaderView.h"

@interface GTUIFlexibleHeaderView ()

/*
 The view controller from which the top safe area insets should be extracted.

 This is typically the root parent of the view controller that owns the flexible header view
 controller.
 */
@property(nonatomic, weak, nullable) UIViewController *topSafeAreaSourceViewController;

/*
 A behavioral flag affecting whether the flexible header view should extract top safe area insets
 from topSafeAreaSourceViewController or not.
 */
@property(nonatomic) BOOL inferTopSafeAreaInsetFromViewController;

/*
 Forces an extraction of the top safe area inset. Intended to be called any time the top safe area
 inset is known to have changed.
 */
- (void)topSafeAreaInsetDidChange;

/**
 The height of the top safe area guide.
 */
@property(nonatomic, readonly) CGFloat topSafeAreaGuideHeight;

#pragma mark - WebKit compatibility

/**
 Returns YES if the trackingScrollView is a scroll view of a WKWebView instance.
 */
- (BOOL)trackingScrollViewIsWebKit;

/**
 See GTUIFlexibleHeaderViewController.h for documentation on this flag.
 */
@property(nonatomic) BOOL useAdditionalSafeAreaInsetsForWebKitScrollViews;

@end
