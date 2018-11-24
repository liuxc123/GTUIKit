//
//  GTUIAlertController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import <UIKit/UIKit.h>
#import "GTButton.h"

#import "GTUIShadowElevations.h"

@class GTUIAlertAction;


@interface GTUIAlertController : UIViewController
/**
 Convenience constructor to create and return a view controller for displaying an alert to the user.

 After creating the alert controller, add actions to the controller by calling -addAction.

 @note Most alerts don't need titles. Use only for high-risk situations.

 @param title The title of the alert.
 @param message Descriptive text that summarizes a decision in a sentence of two.
 @return An initialized GTUIAlertController object.
 */
+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title
                                         message:(nullable NSString *)message;

/** Alert controllers must be created with alertControllerWithTitle:message: */
- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                                 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/** Alert controllers must be created with alertControllerWithTitle:message: */
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_UNAVAILABLE;

/** The font applied to the title of Alert Controller.*/
@property(nonatomic, strong, nullable) UIFont *titleFont;

/** The color applied to the title of Alert Controller.*/
@property(nonatomic, strong, nullable) UIColor *titleColor;

/** The alignment applied to the title of the Alert Controller.*/
@property(nonatomic, assign) NSTextAlignment titleAlignment;

/** An optional icon appearing above the title of the Alert Controller.*/
@property(nonatomic, strong, nullable) UIImage *titleIcon;

/** The tint color applied to the titleIcon. Leave empty to preserve original image color(s).*/
@property(nonatomic, strong, nullable) UIColor *titleIconTintColor;

/** The font applied to the message of Alert Controller.*/
@property(nonatomic, strong, nullable) UIFont *messageFont;

/** The color applied to the message of Alert Controller.*/
@property(nonatomic, strong, nullable) UIColor *messageColor;

/** The alignment applied to the message of the Alert Controller.*/
@property(nonatomic, assign) NSTextAlignment messageAlignment;

// b/117717380: Will be deprecated
/** The font applied to the button of Alert Controller.*/
@property(nonatomic, strong, nullable) UIFont *buttonFont;

// b/117717380: Will be deprecated
/** The color applied to the button title text of Alert Controller.*/
@property(nonatomic, strong, nullable) UIColor *buttonTitleColor;

// b/117717380: Will be deprecated
/** The color applied to the button ink effect of Alert Controller.*/
@property(nonatomic, strong, nullable) UIColor *buttonInkColor;

/** The color applied to the Alert's background when presented by GTUIDialogPresentationController.*/
@property(nonatomic, strong, nullable) UIColor *scrimColor;

/** The corner radius applied to the Alert Controller view. Default to 0 (no round corners) */
@property(nonatomic, assign) CGFloat cornerRadius;

/** The elevation that will be applied to the Alert Controller view. Default to 24. */
@property(nonatomic, assign) GTUIShadowElevation elevation;

// TODO(iangordon): Add support for preferredAction to match UIAlertController.
// TODO(iangordon): Consider adding support for UITextFields to match UIAlertController.

/**
 High level description of the alert or decision being made.

 Use title only for high-risk situations, such as the potential loss of connectivity. If used,
 users should be able to understand the choices based on the title and button text alone.
 */
@property(nonatomic, nullable, copy) NSString *title;

/** Descriptive text that summarizes a decision in a sentence of two. */
@property(nonatomic, nullable, copy) NSString *message;

/*
 Indicates whether the alert contents should automatically update their font when the device’s
 UIContentSizeCategory changes.

 This property is modeled after the adjustsFontForContentSizeCategory property in the
 UIContentSizeCategoryAdjusting protocol added by Apple in iOS 10.0.

 Default value is NO.
 */
@property(nonatomic, readwrite, setter=gtui_setAdjustsFontForContentSizeCategory:)
BOOL gtui_adjustsFontForContentSizeCategory;

/** GTUIAlertController handles its own transitioning delegate. */
- (void)setTransitioningDelegate:
(_Nullable id<UIViewControllerTransitioningDelegate>)transitioningDelegate NS_UNAVAILABLE;

/** GTUIAlertController.modalPresentationStyle is always UIModalPresentationCustom. */
- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle NS_UNAVAILABLE;

/**
 The actions that the user can take in response to the alert.

 The order of the actions in the array matches the order in which they were added to the alert.
 */
@property(nonatomic, nonnull, readonly) NSArray<GTUIAlertAction *> *actions;

/**
 Adds an action to the alert dialog.

 Actions are the possible reactions of the user to the presented alert. Actions are added as a
 button at the bottom of the alert. Affirmative actions should be added before dismissive actions.
 Action buttons will be laid out from right to left if possible or top to bottom depending on space.

 Material spec recommends alerts should not have more than two actions.

 @param action Will be added to the end of GTUIAlertController.actions.
 */
- (void)addAction:(nonnull GTUIAlertAction *)action;

@end

typedef NS_ENUM(NSInteger, GTUIActionEmphasis) {
    /* Low emphasis attribute produces low emphasis appearance when attached to actions or buttons */
    GTUIActionEmphasisLow = 0,
    /* a Medium emphasis attribute produces a medium emphasis appearance */
    GTUIActionEmphasisMedium = 1,
    /* a High emphasis attribute produces a high emphasis appearance */
    GTUIActionEmphasisHigh = 2,
};

/**
 GTUIActionHandler is a block that will be invoked when the action is selected.
 */
typedef void (^GTUIActionHandler)(GTUIAlertAction *_Nonnull action);

/**
 GTUIAlertAction is passed to an GTUIAlertController to add a button to the alert dialog.
 */
@interface GTUIAlertAction : NSObject <NSCopying, UIAccessibilityIdentification>

/**
 A convenience method for adding actions that will be rendered as low emphasis buttons at the
 bottom of an alert controller.

 @param title The title of the button shown on the alert dialog.
 @param handler A block to execute when the user selects the action.
 @return An initialized GTUIActionAlert object.
 */
+ (nonnull instancetype)actionWithTitle:(nonnull NSString *)title
                                handler:(__nullable GTUIActionHandler)handler;

/**
 An action that renders at the bottom of an alert controller as a button of the given emphasis.

 @param title The title of the button shown on the alert dialog.
 @param emphasis The emphasis of the button that will be rendered in the alert dialog.
 Unthemed actions will render all emphases as text. Apply themers to the alert
 to achieve different appearance for different emphases.
 @param handler A block to execute when the user selects the action.
 @return An initialized GTUIActionAlert object.
 */
+ (nonnull instancetype)actionWithTitle:(nonnull NSString *)title
                               emphasis:(GTUIActionEmphasis)emphasis
                                handler:(__nullable GTUIActionHandler)handler;

/** Alert actions must be created with actionWithTitle:handler: */
- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 Title of the button shown on the alert dialog.
 */
@property(nonatomic, nullable, readonly) NSString *title;

/**
 The GTUIActionEmphasis emphasis of the button that will be rendered for the action.
 */
@property(nonatomic, readonly) GTUIActionEmphasis emphasis;

// TODO(iangordon): Add support for enabled property to match UIAlertAction

/**
 The @c accessibilityIdentifier for the view associated with this action.
 */
@property(nonatomic, nullable, copy) NSString *accessibilityIdentifier;

@end
