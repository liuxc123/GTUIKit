//
//  GTUINotificationBarMessageView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import <UIKit/UIKit.h>
#import "GTButton.h"

/**
 Class which provides the default implementation of a notificationBar.
 */
@interface GTUINotificationBarMessageView : UIView

/**
 The color for the background of the notificationBar message view.

 The default color is a dark gray color.
 */
@property(nonatomic, strong, nullable)
UIColor *notificationBarMessageViewBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 The color for the shadow color for the notificationBar message view.

 The default color is @c blackColor.
 */
@property(nonatomic, strong, nullable)
UIColor *notificationBarMessageViewShadowColor UI_APPEARANCE_SELECTOR;

/**
 The color for the message text in the notificationBar message view.

 The default color is @c whiteColor.
 */
@property(nonatomic, strong, nullable) UIColor *messageTextColor UI_APPEARANCE_SELECTOR;

/**
 The font for the message text in the notificationBar message view.
 */
@property(nonatomic, strong, nullable) UIFont *messageFont UI_APPEARANCE_SELECTOR;

/**
 The font for the button text in the notificationBar message view.
 */
@property(nonatomic, strong, nullable) UIFont *buttonFont UI_APPEARANCE_SELECTOR;

/**
 The array of action buttons of the notificationBar.
 */
@property(nonatomic, strong, nullable) NSMutableArray<GTUIButton *> *actionButtons;

/**
 The @c accessibilityLabel to apply to the message of the notificationBar.
 */
@property(nullable, nonatomic, copy) NSString *accessibilityLabel;

/**
 The @c accessibilityHint to apply to the message of the notificationBar.
 */
@property(nullable, nonatomic, copy) NSString *accessibilityHint;

/**
 Returns the button title color for a particular control state.

 Default for UIControlStateNormal is MDCRGBAColor(0xFF, 0xFF, 0xFF, 0.6f).
 Default for UIControlStatehighlighted is white.

 @param state The control state.
 @return The button title color for the requested state.
 */
- (nullable UIColor *)buttonTitleColorForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

/**
 Sets the button title color for a particular control state.

 @param titleColor The title color.
 @param state The control state.
 */
- (void)setButtonTitleColor:(nullable UIColor *)titleColor forState:(UIControlState)state
UI_APPEARANCE_SELECTOR;


/**
 Indicates whether the notificationBar should automatically update its font when the device’s
 UIContentSizeCategory is changed.

 This property is modeled after the adjustsFontForContentSizeCategory property in the
 UIContentSizeCategoryAdjusting protocol added by Apple in iOS 10.0.

 If set to YES, this button will base its message font on MDCFontTextStyleBody2
 and its button font on MDCFontTextStyleButton.

 Default value is NO.
 */
@property(nonatomic, readwrite, setter=gtui_setAdjustsFontForContentSizeCategory:)
BOOL gtui_adjustsFontForContentSizeCategory UI_APPEARANCE_SELECTOR;

@end
