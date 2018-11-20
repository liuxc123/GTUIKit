//
//  GTUIFlexibleHeaderMinMaxHeight.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@class GTUIFlexibleHeaderTopSafeArea;
@protocol GTUIFlexibleHeaderMinMaxHeightDelegate;

/**
 Manages the height behavior for GTUIFlexibleHeaderView.

 In an ideal configuration, minMaxHeightIncludesSafeArea is disabled and the behavior of this class
 is as follows.

 minimumHeight and maximumHeight define the lower and upper bounds of GTUIFlexibleHeaderView
 without safe area insets taken into account. This class calculates minimum and maximum height
 values that include the top safe area value and, most importantly, will react to changes of the top
 safe area value.

 Note: the top safe area value varies based on both the hardware (iPhone SE vs iPhone X) and the
 hardware's orientation (iPhone X portrait, iPhone X landscape).

 ## When minMaxHeightIncludesSafeArea is true

 If minMaxHeightIncludesSafeArea is enabled then the behavior of this class is a bit more complex.
 Notably, minimumHeight and maximumHeight are assumed to *include* the top safe area inset value.
 This means that the client is expected to update the minimumHeight and maximumHeight any time the
 top safe area value changes.

 minMaxHeightIncludesSafeArea being set to true is the "legacy" behavior that existed prior to the
 iPhone X and the existence of dynamic top safe areas. At the time of this property's introduction
 we wanted to ensure that as many clients as possible would support the correct safe area behavior
 with minimal code modifications. This meant assuming that minMaxHeightIncludesSafeArea was true but
 finding a way for minimumHeight and maximumHeight to update in reaction to changes in the top safe
 area.

 If neither the minimumHeight nor maximumHeight are modified, this class will dynamically update
 both properties as the top safe area inset changes with the assumption that it completely owns
 both property's values. This covers the majority case of clients that are using the default
 values. For all other clients that set explicit minimumHeight and maximumHeight values, we
 recommend that they disable minMaxHeightIncludesSafeArea rather than attempt to implement the
 correct top safe area logic themselves.
 */
__attribute__((objc_subclassing_restricted)) @interface GTUIFlexibleHeaderMinMaxHeight : NSObject

#pragma mark Initializing a min/max height object

/**
 Initializes this instance with a given top safe area instance.
 */
- (nonnull instancetype)initWithTopSafeArea:(nonnull GTUIFlexibleHeaderTopSafeArea *)topSafeArea
NS_DESIGNATED_INITIALIZER;

#pragma mark Configuring the minimum and maximum height

/**
 See GTUIFlexibleHeaderView.h for complete documentation of this property.
 */
@property(nonatomic) CGFloat minimumHeight;

/**
 See GTUIFlexibleHeaderView.h for complete documentation of this property.
 */
@property(nonatomic) CGFloat maximumHeight;

#pragma mark Calculating the minimum and maximum height with/without the top safe area

/**
 Returns minimum height including the top safe area amount.
 */
- (CGFloat)minimumHeightWithTopSafeArea;

/**
 Returns maximum height including the top safe area amount.
 */
- (CGFloat)maximumHeightWithTopSafeArea;

/**
 Returns maximum height without the top safe area amount.
 */
- (CGFloat)maximumHeightWithoutTopSafeArea;

#pragma mark Delegating changes in minimum and maximum height

/**
 The delegate may react to changes in the minimumHeight and maximumHeight.
 */
@property(nonatomic, weak, nullable) id<GTUIFlexibleHeaderMinMaxHeightDelegate> delegate;

/**
 Unavailable. Use initWithTopSafeArea: instead.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

@end

#pragma mark APIs that will be deprecated

@interface GTUIFlexibleHeaderMinMaxHeight ()

/**
 See GTUIFlexibleHeaderView.h for complete documentation of this property.

 This property will eventually be disabled by default, deprecated, and then removed.
 */
@property(nonatomic) BOOL minMaxHeightIncludesSafeArea;

/**
 Informs the receiver that it should update the minimumHeight and maximumHeight.

 Does nothing if minMaxHeightIncludesSafeArea is disabled.
 This property can be removed once minMaxHeightIncludesSafeArea is removed.
 */
- (void)recalculateMinMaxHeight;

@end

/**
 The delegate protocol through which GTUIFlexibleHeaderMinMaxHeight communicates changes in the
 minimum and maximum height.
 */
@protocol GTUIFlexibleHeaderMinMaxHeightDelegate <NSObject>
@required

/**
 Informs the receiver that the maximum height has changed.
 */
- (void)flexibleHeaderMaximumHeightDidChange:(nonnull GTUIFlexibleHeaderMinMaxHeight *)safeAreas;

/**
 Informs the receiver that either the minimum or maximum height have changed.
 */
- (void)flexibleHeaderMinMaxHeightDidChange:(nonnull GTUIFlexibleHeaderMinMaxHeight *)safeAreas;

@end
