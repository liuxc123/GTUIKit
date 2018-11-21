//
//  GTUITextInputCommonFundament.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInput.h"

extern const CGFloat GTUITextInputBorderRadius;
extern const CGFloat GTUITextInputFullPadding;
extern const CGFloat GTUITextInputHalfPadding;

UIKIT_EXTERN UIColor *_Nonnull GTUITextInputCursorColor(void);

/** A controller for common traits shared by text inputs. */
@interface GTUITextInputCommonFundament : NSObject <GTUITextInput, NSCopying>

/**
 An overlay view on the side of the input where reading and writing lines begin. In LTR this is
 the Left side. In RTL, the Right side.
 */
@property(nonatomic, nullable, strong) UIView *leadingView;

@property(nonatomic) UITextFieldViewMode leadingViewMode;

/** The color of the input's text. */
@property(nonatomic, nullable, strong) UIColor *textColor;

/** Designated initializer with the controlled text input. */
- (nonnull instancetype)initWithTextInput:(UIView<GTUITextInput> *_Nonnull)textInput
NS_DESIGNATED_INITIALIZER;

/** Please use initWithTextInput:. */
- (nonnull instancetype)init NS_UNAVAILABLE;

/** Text began being edited event. */
- (void)didBeginEditing;

/** Text did change event. */
- (void)didChange;

/** Text stopped being edited event. */
- (void)didEndEditing;

/** Called by the controlled text input to notify the controller that it's font was set. */
- (void)didSetFont;

/** Called by the controlled text input to notify the controller that it's text was set manually. */
- (void)didSetText;

/** Mirror of UIView's layoutSubviews(). */
- (void)layoutSubviewsOfInput;

/** Mirror of UIView's updateConstraints(). */
- (void)updateConstraintsOfInput;

/** Clear button did touch event. */
- (void)clearButtonDidTouch;

- (nullable instancetype)initWithCoder:(NSCoder *_Nonnull)aDecoder NS_DESIGNATED_INITIALIZER;

@end
