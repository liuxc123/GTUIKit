//
//  GTUIFlexibleHeaderTopSafeArea.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GTUIFlexibleHeaderSafeAreaDelegate;

/**
 Extracts the top safe area for a given view controller.

 @note This class implements legacy behavior gated behind the
 inferTopSafeAreaInsetFromViewController flag. When this flag is disabled (currently the default),
 we don't extract the top safe area from the given view controller - we extract it from
 GTUIDeviceTopSafeAreaInset. We hope to deprecate GTUIDeviceTopSafeAreaInset, but this work is blocked
 on all clients enabling inferTopSafeAreaInsetFromViewController on their flexible header view
 controller.
 */
@interface GTUIFlexibleHeaderTopSafeArea : NSObject

#pragma mark Configuring the top safe area source

/**
 See GTUIFlexibleHeaderViewController.h for detailed documentation.
 */
@property(nonatomic, weak, nullable) UIViewController *topSafeAreaSourceViewController;

#pragma mark Querying the top safe area

/**
 Returns the top safe area inset value in a manner that depends on the
 inferTopSafeAreaInsetFromViewController runtime flag.

 If inferTopSafeAreaInsetFromViewController is enabled, returns the most recent top safe area inset
 value we've extracted from the top safe area source view controller.

 If inferTopSafeAreaInsetFromViewController is disabled, returns the device's top safe area insets.
 */
- (CGFloat)topSafeAreaInset;

#pragma mark Informing the object of safe area inset changes

/**
 Informs the receiver that the safe area insets have changed.
 */
- (void)safeAreaInsetsDidChange;

#pragma mark Migratory behavioral flags

/**
 See GTUIFlexibleHeaderViewController.h for detailed documentation.

 Defaults to NO, but we eventually want to default it to YES and remove this property altogether.
 */
@property(nonatomic) BOOL inferTopSafeAreaInsetFromViewController;

#pragma mark Delegating changes in state

/**
 The delegate may react to changes in the top safe area inset.
 */
@property(nonatomic, weak, nullable) id<GTUIFlexibleHeaderSafeAreaDelegate> delegate;

@end

/**
 The delegate protocol through which GTUIFlexibleHeaderTopSafeArea communicates changes in the top
 safe area inset.
 */
@protocol GTUIFlexibleHeaderSafeAreaDelegate
@required

/**
 Informs the receiver that the topSafeAreaInset value has changed.
 */
- (void)flexibleHeaderSafeAreaTopSafeAreaInsetDidChange:
(nonnull GTUIFlexibleHeaderTopSafeArea *)safeAreas;

/**
 Asks the receiver whether the status bar is likely shifted off-screen by the owner.
 */
- (BOOL)flexibleHeaderSafeAreaIsStatusBarShifted:(nonnull GTUIFlexibleHeaderTopSafeArea *)safeAreas;

/**
 Asks the receiver to return the device's top safe area inset.
 */
- (CGFloat)flexibleHeaderSafeAreaDeviceTopSafeAreaInset:
(nonnull GTUIFlexibleHeaderTopSafeArea *)safeAreas;

@end
