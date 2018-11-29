//
//  GTUIBottomSheetPresentationController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import <UIKit/UIKit.h>
#import "GTUIBottomSheetController.h"

@class GTUIBottomSheetPresentationController;

/**
 Delegate for GTUIBottomSheetPresentationController.
 */
@protocol GTUIBottomSheetPresentationControllerDelegate <UIAdaptivePresentationControllerDelegate>
@optional

/**
 Called before the bottom sheet is presented.

 @param bottomSheet The GTUIBottomSheetPresentationController being presented.
 */
- (void)prepareForBottomSheetPresentation:
(nonnull GTUIBottomSheetPresentationController *)bottomSheet;

/**
 Called after dimissing the bottom sheet to let clients know it is no longer onscreen. The bottom
 sheet controller calls this method only in response to user actions such as tapping the background
 or dragging the sheet offscreen. This method is not called if the bottom sheet is dismissed
 programmatically.

 @param bottomSheet The GTUIBottomSheetPresentationController that was dismissed.
 */
- (void)bottomSheetPresentationControllerDidDismissBottomSheet:
(nonnull GTUIBottomSheetPresentationController *)bottomSheet;

- (void)bottomSheetWillChangeState:(nonnull GTUIBottomSheetPresentationController *)bottomSheet
                        sheetState:(GTUISheetState)sheetState;
@end

/**
 A UIPresentationController for presenting a modal view controller as a bottom sheet.
 */
@interface GTUIBottomSheetPresentationController : UIPresentationController

/**
 Interactions with the tracking scroll view will affect the bottom sheet's drag behavior.

 If no trackingScrollView is provided, then one will be inferred from the associated view
 controller.
 */
@property(nonatomic, weak, nullable) UIScrollView *trackingScrollView;

/**
 When set to false, the bottom sheet controller can't be dismissed by tapping outside of sheet area.
 */
@property(nonatomic, assign) BOOL dismissOnBackgroundTap;

/**
 关闭完成回调
 */
@property (nonatomic , copy ) void (^closeFinishHandler)(void);

/**
 This is used to set a custom height on the sheet view.

 @note If a positive value is passed then the sheet view will be that height even if
 perferredContentSize has been set. Otherwise the sheet will open up to half the screen height or
 the size of the presentedViewController's preferredContentSize whatever value is smaller.
 @note The preferredSheetHeight can never be taller than the height of the content, if the content
 is smaller than the value passed to preferredSheetHeight then the sheet view will be the size of
 the content height.
 */
@property(nonatomic, assign) CGFloat preferredSheetHeight;

/**
 If @c YES, then the dimmed scrim view will act as an accessibility element for dismissing the
 bottom sheet.

 Defaults to @c NO.
 */
@property(nonatomic, assign) BOOL isScrimAccessibilityElement;

/**
 The @c accessibilityLabel value of the dimmed scrim view.

 Defaults to @c nil.
 */
@property(nullable, nonatomic, copy) NSString *scrimAccessibilityLabel;

/**
 The @c accessibilityHint value of the dimmed scrim view.

 Defaults to @c nil.
 */
@property(nullable, nonatomic, copy) NSString *scrimAccessibilityHint;

/**
 The @c accessibilityTraits of the dimmed scrim view.

 Defaults to @c UIAccessibilityTraitButton.
 */
@property(nonatomic, assign) UIAccessibilityTraits scrimAccessibilityTraits;

/**
 Delegate to tell the presenter when to dismiss.
 */
@property(nonatomic, weak, nullable) id<GTUIBottomSheetPresentationControllerDelegate> delegate;

@end
