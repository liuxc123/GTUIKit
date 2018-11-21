//
//  GTUITextFieldPositioningDelegate.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

/**
 GTUITextInputPositioningDelegate allows objects outside an GTUITextInput, like
 GTUITextInputController, to pass the GTUITextInput important layout information.

 Usually, these methods are direct mirrors of internal methods with the addition of a default value.
 */

@protocol GTUITextInputPositioningDelegate <NSObject>

@optional

/**
 The actual input view and the rendered inputted text's position is determined by applying these
 insets to the bounds.

 @param defaultInsets The value of text container insets that the GTUITextInput has calculated by
 default.
 */
- (UIEdgeInsets)textInsets:(UIEdgeInsets)defaultInsets;

/**
 The area that inputted text should be displayed while isEditing = true.

 @param defaultRect The default value of the editing rect. It is usually the text rect shrunk or
 enlarged depending on rightView, leftView, or clearButton presences.
 */
- (CGRect)editingRectForBounds:(CGRect)bounds defaultRect:(CGRect)defaultRect;

/**
 The area that the leadingView should inhabit when shown.

 @param defaultRect The default value of the leading view rect.
 */
- (CGRect)leadingViewRectForBounds:(CGRect)bounds defaultRect:(CGRect)defaultRect;

/**
 The amount of horizontal space between the leading view and the text input box.

 Defaults to 0.0;
 */
- (CGFloat)leadingViewTrailingPaddingConstant;

/** Called from the end of the input's layoutSubviews. */
- (void)textInputDidLayoutSubviews;

/** Called from the end of the input's updateConstraints. */
- (void)textInputDidUpdateConstraints;

/**
 The area that the trailingView should inhabit when shown.

 @param defaultRect The default value of the trailing view rect.
 */
- (CGRect)trailingViewRectForBounds:(CGRect)bounds defaultRect:(CGRect)defaultRect;

/**
 The amount of horizontal space between the trailing view and the text input box.

 Defaults to 0.0;
 */
- (CGFloat)trailingViewTrailingPaddingConstant;

@end


