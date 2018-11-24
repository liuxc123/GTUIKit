//
//  GTUIBottomSheetController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import <UIKit/UIKit.h>
#import "GTUISheetState.h"
#import "GTShapes.h"

@protocol GTUIBottomSheetControllerDelegate;

/**
 A view controller for presenting other view controllers as bottom sheets.

 https://material.io/go/design-sheets-bottom

 Show a bottom sheet by creating an GTUIBottomSheetController instance with a contentViewController
 and presenting it with -[UIViewController presentViewController:animated:completion].
 GTUIBottomSheetController automatically sets the appropriate presentation style and
 transitioningDelegate for the bottom sheet behavior.
 */
@interface GTUIBottomSheetController : UIViewController

/**
 The view controller being presented as a bottom sheet.
 */
@property(nonatomic, strong, nonnull, readonly) UIViewController *contentViewController;

/**
 Interactions with the tracking scroll view will affect the bottom sheet's drag behavior.

 If no trackingScrollView is provided, then one will be inferred from the associated view
 controller.

 Changes to this value will be ignored after the bottom sheet controller has been presented.
 */
@property(nonatomic, weak, nullable) UIScrollView *trackingScrollView;

/**
 When set to false, the bottom sheet controller can't be dismissed by tapping outside of sheet area.
 */
@property(nonatomic, assign) BOOL dismissOnBackgroundTap;

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
 The bottom sheet delegate.
 */
@property(nonatomic, weak, nullable) id<GTUIBottomSheetControllerDelegate> delegate;

/**
 The current state of the bottom sheet.
 */
@property(nonatomic, readonly) GTUISheetState state;

/**
 Sets the shape generator for state that is used to define the bottom sheet's shape for that state.

 note: If a layer property is explicitly set after the shapeGenerator has been set,
 it can lead to unexpected behavior. As an example, changes to the view layer's properties such as
 cornerRadius, mask, or shadow properties are not advised when the shapeGenerator is set.

 When the shapeGenerator for a state is nil, GTUIBottomSheetController will use the default view's
 underlying layer (self.view.layer) with its default settings.

 @param shapeGenerator The shape generator holding the desired shape of the sheet.
 @param state The state of the bottom sheet.
 */
- (void)setShapeGenerator:(nullable id<GTUIShapeGenerating>)shapeGenerator
                 forState:(GTUISheetState)state;

/**
 Returns the shape generator for an GTUISheetState state.

 @param state The state of the bottom sheet
 @return the shape generator for the state given.
 */
- (nullable id<GTUIShapeGenerating>)shapeGeneratorForState:(GTUISheetState)state;

/**
 Initializes the controller with a content view controller.

 @param contentViewController The view controller to be presented as a bottom sheet.
 */
- (nonnull instancetype)initWithContentViewController:
(nonnull UIViewController *)contentViewController;

@end

/**
 Delegate for GTUIBottomSheetController.
 */
@protocol GTUIBottomSheetControllerDelegate <NSObject>

/**
 Called when the user taps the dimmed background or swipes the bottom sheet off to dismiss the
 bottom sheet. Also called with accessibility escape "two finger Z" gestures.

 This method is not called if the bottom sheet is dismissed programatically.

 @param controller The GTUIBottomSheetController that was dismissed.
 */
- (void)bottomSheetControllerDidDismissBottomSheet:(nonnull GTUIBottomSheetController *)controller;

@end
