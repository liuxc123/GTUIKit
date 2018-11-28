//
//  GTUIActionSheetController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import <UIKit/UIKit.h>

@class GTUIBottomSheetTransitionController;
@class GTUIActionSheetAction;

/**
 GTUIActionSheet样式

 - GTUIActionSheetTypeNormal: 默认样式 类似于微信
 - GTUIActionSheetTypeUIKit: iOS系统默认样式
 - GTUIActionSheetTypeMaterial: Material样式
 */
typedef NS_ENUM(NSUInteger, GTUIActionSheetType) {
    GTUIActionSheetTypeNormal,
    GTUIActionSheetTypeUIKit,
    GTUIActionSheetTypeMaterial
};


__attribute__((objc_subclassing_restricted))
@interface GTUIActionSheetController : UIViewController


/**
 Designated initializer to create and return a view controller for displaying an alert to the user.

 After creating the alert controller, add actions to the controller by calling -addAction.

 @param title The title of the alert.
 @param message Descriptive text that summarizes a decision in a sentence or two.
 @param type Descriptive ActionSheet Type that summarizes a decision in a sentence or two.
 @return An initialized GTUIActionSheetController object.
 */
+ (nonnull instancetype)actionSheetControllerWithTitle:(nullable NSString *)title
                                               message:(nullable NSString *)message
                                            customView:(UIView *)customView
                                                  type:(GTUIActionSheetType)type;

/**
 Designated initializer to create and return a view controller for displaying an alert to the user.

 After creating the alert controller, add actions to the controller by calling -addAction.

 @param title The title of the alert.
 @param message Descriptive text that summarizes a decision in a sentence or two.
 @param type Descriptive ActionSheet Type that summarizes a decision in a sentence or two.
 @return An initialized GTUIActionSheetController object.
 */
+ (nonnull instancetype)actionSheetControllerWithTitle:(nullable NSString *)title
                                               message:(nullable NSString *)message
                                                  type:(GTUIActionSheetType)type;

/**
 Designated initializer to create and return a view controller for displaying an alert to the user.

 After creating the alert controller, add actions to the controller by calling -addAction.

 @param title The title of the alert.
 @param message Descriptive text that summarizes a decision in a sentence or two.
 @return An initialized GTUIActionSheetController object.
 */
+ (nonnull instancetype)actionSheetControllerWithTitle:(nullable NSString *)title
                                               message:(nullable NSString *)message;

/**
 Convenience initializer to create and return a view controller for displaying an alert to the user.

 After creating the alert controller, add actions to the controller by calling -
 addAction.

 @param title The title of the alert.
 @return An initialized GTUIActionSheetController object.
 */
+ (nonnull instancetype)actionSheetControllerWithTitle:(nullable NSString *)title;

/**
 Action sheet controllers must be created with actionSheetControllerWithTitle: or
 with actionSheetControllerWithTitle:message:
 */
- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                                 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/**
 Action sheet controllers must be created with actionSheetControllerwithTitle:
 or with actionSheetControllerWithTitle:message:
 */
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 Adds an action to the action sheet.

 Actions are the possible reactions of the user to the presented alert. Actions
 are added as a list item in the list of the action sheet.
 Action buttons will be laid out from top to bottom depending on the order they
 were added.

 @param action Will be added to the end of GTUIActionSheetController.actions.
 */
- (void)addAction:(nonnull GTUIActionSheetAction *)action;

/**
 The actions that the user can take in response to the action sheet.

 The order of the actions in the array matches the order in which they were added
 to the action sheet.
 */
@property (nonatomic, nonnull, readonly, copy) NSArray<GTUIActionSheetAction *> *actions;

/**
 The title of the action sheet controller.

 If this is updated after presentation the view will be updated to match the
 new value.
 */
@property (nonatomic, nullable, copy) NSString *title;

/**
 The message of the action sheet controller.

 If this is updated after presentation the view will be updated to match the new value.
 */
@property (nonatomic, nullable, copy) NSString *message;


/**
 custom view 自定义视图
*/
@property (nonatomic, nullable, strong) UIView *customView;


/**
 GTUIActionSheet type

 Default GTUIActionSheetTypeUIKit
 */
@property (nonatomic, assign) GTUIActionSheetType actionSheetType;

/**
 Indicates whether the button should automatically update its font when the device’s
 UIContentSizeCategory is changed.

 This property is modeled after the adjustsFontForContentSizeCategory property in the
 UIContentSizeCategoryAdjusting protocol added by Apple in iOS 10.0.

 If set to YES, this button will base its text font on GTUIFontTextStyleButton.

 Defaults value is NO.
 */
@property(nonatomic, setter=gtui_setAdjustsFontForContentSizeCategory:)
BOOL gtui_adjustsFontForContentSizeCategory;

/**
 The font applied to the title of the action sheet controller.
 */
@property(nonatomic, nonnull, strong) UIFont *titleFont;

/**
 The font applied to the message of the action sheet controller.
 */
@property(nonatomic, nonnull, strong) UIFont *messageFont;

/**
 The font applied to the action items of the action sheet controller.
 */
@property(nonatomic, nullable, strong) UIFont *actionFont;


/**
 The font applied to the title of the action sheet controller.
 */
@property(nonatomic, assign) NSTextAlignment titleAlignment;

/**
 The font applied to the message of the action sheet controller.
 */
@property(nonatomic, assign) NSTextAlignment messageAlignment;

/**
 The font applied to the action item of the action sheet controller.
 */
@property(nonatomic, assign) NSTextAlignment actionAlignment;

/**
 The color applied to the sheet view of the action sheet controller.
 */
@property(nonatomic, nonnull, strong) UIColor *backgroundColor;

/**
 Header ackground Color
 */
@property(nonatomic, nonnull, strong) UIColor *headerBackgroundColor;

/**
 按钮背景颜色
 */
@property(nonatomic, nonnull, strong) UIColor *actionBackgroundColor;


@property(nonatomic, nonnull, strong) UIColor *cancelActionSpaceColor;




/**
 The color applied to the title of the action sheet controller.

 @note If only using a title and the actions have no icons make sure they are different colors so
 there is a distinction between the title and actions.
 */
@property(nonatomic, strong, nullable) UIColor *titleTextColor;

/**
 The color applied to the message of the action sheet controller.

 @note To make for a better user experience we recommend using a different color for the message and
 actions if there are no icons so there is a distinction between the message and actions.
 */
@property(nonatomic, strong, nullable) UIColor *messageTextColor;

/**
 The color for the text for all action items within an action sheet.
 */
@property(nonatomic, strong, nullable) UIColor *actionTextColor;

/**
 The tint color for the action items within an action sheet.
 */
@property(nonatomic, strong, nullable) UIColor *actionTintColor;

/**
 The image rendering mode for all actions within an action sheet.
 */
@property(nonatomic) UIImageRenderingMode actionImageRenderingMode;

/**
 The ink color for the action items within an action sheet.
 */
@property(nonatomic, strong, nullable) UIColor *inkColor;

/**
 整个ActionSheet圆角
 */
@property(nonatomic, assign) CGFloat cornerRadius;

/**
 按钮圆角
 */
@property(nonatomic, assign) CGFloat actionCornerRadius;

/**
 按钮高度
 */
@property(nonatomic, assign) CGFloat actionHeight;

/**
 actionsheet取消按钮间隔宽度
 */
@property(nonatomic, assign) CGFloat cancelActionSpaceWidth;

/**
 actionsheet距离屏幕底部距离
 */
@property(nonatomic, assign) CGFloat actionSheetBottomMargin;

/**
  actionsheet距离屏幕最大宽度
 */
@property(nonatomic, assign) CGFloat actionSheetMaxWidth;

/**
 默认模糊效果类型Dark
 */
@property(nonatomic, assign) UIBlurEffectStyle backgroundBlurEffectStyle;

/**
 支持方向 , 默认所有方向
 */
@property(nonatomic, assign) UIInterfaceOrientation *supportedInterfaceOrientations;

@property(nonatomic, assign) UIStatusBarStyle *statusBarStyle;





/**
 阴影样式
 */
@property(nonatomic, assign) CGFloat shadowOpacity;
@property(nonatomic, assign) CGFloat shadowRadius;
@property(nonatomic, assign) CGSize shadowOffset;



@property(nonatomic, strong, readonly, nonnull)
GTUIBottomSheetTransitionController *transitionController;

- (void)setTransitioningDelegate:
(nullable id<UIViewControllerTransitioningDelegate>)transitioningDelegate NS_UNAVAILABLE;

- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle NS_UNAVAILABLE;

@end


typedef NS_ENUM(NSUInteger, GTUIActionSheetActionType) {
    GTUIActionSheetActionTypeDefault,
    GTUIActionSheetActionTypeCancel,
    GTUIActionSheetActionTypeDestructive,
};


/**
 GTUIActionSheetActionHandler is a block that will be invoked when the action is
 selected.
 */
typedef void (^GTUIActionSheetHandler)(GTUIActionSheetAction *_Nonnull action);

/**
 An instance of GTUIActionSheetAction is passed to GTUIActionSheetController to
 add an action to the action sheet.
 */
@interface GTUIActionSheetAction : NSObject <NSCopying, UIAccessibilityIdentification>


/**
 Returns an action sheet action with the populated given values.

 @param title The title of the list item shown in the list
 @param image The icon of the list item shown in the list
 @param type  The type of the list item shown in the list
 @param handler A block to execute when the user selects the action.
 @return An initialized GTUIActionSheetAction object.
 */
+ (nonnull instancetype)actionWithTitle:(nonnull NSString *)title
                                  image:(nullable UIImage *)image
                                   type:(GTUIActionSheetActionType)type
                                handler:(__nullable GTUIActionSheetHandler)handler;

/**
 Action sheet actions must be created with actionWithTitle:image:handler:
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 Title of the list item shown on the action sheet.

 Action sheet actions must have a title that will be set within actionWithTitle:image:handler:
 method.
 */
@property (nonatomic, nonnull, readonly) NSString *title;

/**
 Image of the list item shown on the action sheet.

 Action sheet actions must have an image that will be set within actionWithTitle:image:handler:
 method.
 */
@property (nonatomic, nullable, readonly) UIImage *image;

/**
 GTUIActionSheetAction type  default GTUIActionSheetActionDefault
 */
@property (nonatomic, assign, readonly) GTUIActionSheetActionType type;

/**
 The @c accessibilityIdentifier for the view associated with this action.
 */
@property(nonatomic, nullable, copy) NSString *accessibilityIdentifier;

@property (nonatomic, assign, readonly) GTUIActionBorderPosition borderPosition;
@property (nonatomic , strong ) UIColor *borderColor;
@property (nonatomic , assign ) CGFloat borderWidth;
@property (nonatomic , assign ) CGFloat cornerRadius;

@end
