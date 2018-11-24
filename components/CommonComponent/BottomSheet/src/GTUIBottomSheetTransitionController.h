//
//  GTUIBottomSheetTransitionController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import <UIKit/UIKit.h>

/**
 GTUIBottomSheetTransitionController is be used to setup a custom transition and animationed
 presentation and dismissal for material-styled bottom-sheet presentation.

 This class provides a basic implementation of UIViewControllerAnimatedTransitioning and
 UIViewControllerTransitioningDelegate.

 In order to use a custom modal transition, the UIViewController to be presented must set two
 properties. The UIViewControllers transitioningDelegate should be set to an instance of this class.
 myDialogViewController.modalPresentationStyle = UIModalPresentationCustom;
 myDialogViewController.transitioningDelegate = bottomSheetTransitionController;

 The presenting UIViewController then calls presentViewController:animated:completion:
 [rootViewController presentViewController:myDialogViewController animated:YES completion:...];
 */
@interface GTUIBottomSheetTransitionController
: NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

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
 This is used to set a custom height on the sheet view. This is can be used to set the initial
 height when the ViewController is presented.

 @note If a positive value is passed then the sheet view will be that height even if
 perferredContentSize has been set. Otherwise the sheet will open up to half the screen height or
 the size of the presentedViewController's preferredContentSize whatever value is smaller.
 @note The preferredSheetHeight can never be taller than the height of the content, if the content
 is smaller than the value passed to preferredSheetHeight then the sheet view will be the size of
 the content height.
 */
@property(nonatomic, assign) CGFloat preferredSheetHeight;

@end

@interface GTUIBottomSheetTransitionController (ScrimAccessibility)

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

@end
