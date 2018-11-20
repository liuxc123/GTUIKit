//
//  GTUIButtonBar.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import <UIKit/UIKit.h>

/**
 The position of the button bar, typically aligned with the leading or trailing edge of the screen.

 Default: GTUIBarButtonLayoutPositionNone
 */
typedef NS_OPTIONS(NSUInteger, GTUIButtonBarLayoutPosition) {
    GTUIButtonBarLayoutPositionNone = 0,

    /** The button bar is on the leading side of the screen. */
    GTUIButtonBarLayoutPositionLeading = 1 << 0,
    GTUIButtonBarLayoutPositionLeft = GTUIButtonBarLayoutPositionLeading,

    /** The button bar is on the trailing side of the screen. */
    GTUIButtonBarLayoutPositionTrailing = 1 << 1,
    GTUIButtonBarLayoutPositionRight = GTUIButtonBarLayoutPositionTrailing,
};

@protocol GTUIButtonBarDelegate;

/**
 The GTUIButtonBar class provides a view comprised of a horizontal list of buttons.

 This view will register KVO listeners on the provided button items for the following properties:

 - accessibilityHint
 - accessibilityIdentifier
 - accessibilityLabel
 - accessibilityValue
 - enabled
 - image
 - tag
 - tintColor
 - title

 If any of the above properties change, the GTUIButtonBar will immediately reflect the change
 in the visible UIButton instance.
 */
IB_DESIGNABLE
@interface GTUIButtonBar : UIView

#pragma mark Delegating

/**
 The delegate will be informed of events related to the layout of the button bar.
 */
@property(nonatomic, weak, nullable) id<GTUIButtonBarDelegate> delegate;

#pragma mark Button Items

/**
 An array of UIBarButtonItem objects that will be used to populate the button views in this bar.

 Setting a new array of items will result in immediate recreation of the button views.

 Once set, changes made to the UIBarButtonItem properties will be observed and applied to the
 created button views.

 ### Item target/action method signature

 The complete action method signature is:

 - (void)didTap:(UIBarButtonItem *)item event:(UIEvent *)event button:(UIButton *)button;

 Each argument can be optionally-specified. E.g. @selector(didTap) is an acceptable action.

 ### iPad popover support

 GTUIButtonBar is not able to associate UIBarButtonItem instances with their corresponding UIButton
 instance, so certain UIKit methods that accept a UIBarButtonItem cannot be used. This includes,
 but may not be limited to:

 - UIPopoverController::presentPopoverFromBarButtonItem:permittedArrowDirections:animated:
 - UIPrinterPickerController::presentFromBarButtonItem:animated:completionHandler:
 - UIPrintInteractionController::presentFromBarButtonItem:animated:completionHandler:
 - UIDocumentInteractionController::presentOptionsMenuFromBarButtonItem:animated:
 - UIDocumentInteractionController::presentOpenInMenuFromBarButtonItem:animated:

 Instead, you must use the related -FromRect: variant which requires a CGRect and view. You can
 use the provided UIButton by implementing the complete action method signature:

 - (void)didTap:(UIBarButtonItem *)item event:(UIEvent *)event button:(UIButton *)button;
 */
@property(nonatomic, copy, nullable) NSArray<UIBarButtonItem *> *items;

/**
 If greater than zero, will ensure that any UIButton with a title is aligned to the provided
 baseline.

 The baseline is expressed in number of points from the top edge of the receiver’s
 bounds.

 Default: 0
 */
@property(nonatomic) CGFloat buttonTitleBaseline;

/**
 If true, all button titles will be converted to uppercase.

 Changing this property to NO will update the current title string for all buttons.

 Default is YES.
 */
@property(nonatomic) BOOL uppercasesButtonTitles;

/**
 Sets the title font for the given state for all buttons.

 @param font The font that should be displayed on text buttons for the given state.
 @param state The state for which the font should be displayed.
 */
- (void)setButtonsTitleFont:(nullable UIFont *)font forState:(UIControlState)state;

/**
 Returns the font set for @c state that was set by setButtonsTitleFont:forState:.

 If no font has been set for a given state, the returned value will fall back to the value
 set for UIControlStateNormal.

 @param state The state for which the font should be returned.
 @return The font associated with the given state.
 */
- (nullable UIFont *)buttonsTitleFontForState:(UIControlState)state;

/**
 Sets the title label color for the given state for all buttons.

 @param color The color that should be used on text buttons labels for the given state.
 @param state The state for which the color should be used.
 */
- (void)setButtonsTitleColor:(nullable UIColor *)color forState:(UIControlState)state;

/**
 Returns the color set for @c state that was set by setButtonsTitleColor:forState:.

 If no value has been set for a given state, the returned value will fall back to the value
 set for UIControlStateNormal.

 @param state The state for which the color should be returned.
 @return The color associated with the given state.
 */
- (nullable UIColor *)buttonsTitleColorForState:(UIControlState)state;

/**
 The position of the button bar, usually positioned on the leading or trailing edge of the screen.

 Default: GTUIBarButtonLayoutPositionNone
 */
@property(nonatomic) GTUIButtonBarLayoutPosition layoutPosition;

/**
 The inkColor that is used for all buttons in the button bar.

 If set to nil, button bar buttons use default ink color.
 */
@property(nonatomic, strong, nullable) UIColor *inkColor;

/**
 Returns a height adhering to the Material spec for Bars and a width that is able to accommodate
 every item present in the `items` property. The provided size is ignored.
 */
- (CGSize)sizeThatFits:(CGSize)size;

@end

typedef NS_OPTIONS(NSUInteger, GTUIBarButtonItemLayoutHints) {
    GTUIBarButtonItemLayoutHintsNone = 0,

    /** Whether or not this bar button item is the first button in the list. */
    GTUIBarButtonItemLayoutHintsIsFirstButton = 1 << 0,

    /** Whether or not this bar button item is the last button in the list. */
    GTUIBarButtonItemLayoutHintsIsLastButton = 1 << 1,
};

/**
 The GTUIButtonBarDelegate protocol defines the means by which GTUIButtonBar can request that a
 view be created for a bar button item.

 An object that conforms to this protocol must forward UIControlEventTouchUpInside events to the
 button bar's didTapButton:event: method signature in order to pass the correct UIBarButtonItem
 argument to the item's target/action invocation. This method signature is made available by
 importing the GTUIAppBarButtonBarBuilder.h header. The GTUIAppBarButtonBarBuilder.h header should
 *only* be
 imported in files that implement objects conforming to GTUIButtonBarDelegate.

 @seealso GTUIBarButtonItemLayoutHints
 */
@protocol GTUIButtonBarDelegate <NSObject>
@optional

/**
 Informs the receiver that the button bar requires a layout pass.

 The receiver is expected to call propagate this setNeedsLayout call to the view responsible for
 setting the frame of the button bar so that the button bar can expand or contract as necessary.

 This method is typically called as a result of a UIBarButtonItem property changing or as a result
 of the items property being changed.
 */
- (void)buttonBarDidInvalidateIntrinsicContentSize:(nonnull GTUIButtonBar *)buttonBar;

/** Asks the receiver to return a view that represents the given bar button item. */
- (nonnull UIView *)buttonBar:(nonnull GTUIButtonBar *)buttonBar
                  viewForItem:(nonnull UIBarButtonItem *)barButtonItem
                  layoutHints:(GTUIBarButtonItemLayoutHints)layoutHints
__deprecated_msg("There will be no replacement for this API.");

@end

