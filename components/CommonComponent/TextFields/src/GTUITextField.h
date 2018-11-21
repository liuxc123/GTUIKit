//
//  GTUITextField.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

#import "GTUITextInput.h"

/** When text is manually set via .text or setText:, this notification fires. */
extern NSString *_Nonnull const GTUITextFieldTextDidSetTextNotification;

/** When the value of `enabled` changes on the text input, this notification fires. */
extern NSString *_Nonnull const GTUITextInputDidToggleEnabledNotification;

/**
 Material Design compliant single-line text input.
 https://www.google.com/design/spec/components/text-fields.html#text-fields-single-line-text-field
 */
@interface GTUITextField : UITextField <GTUITextInput, GTUILeadingViewTextInput>

/** GTUITextField does not implement borders that conform to UITextBorderStyle. */
@property(nonatomic, assign) UITextBorderStyle borderStyle NS_UNAVAILABLE;

/**
 This label should always have the same layout as the input field (which is private API.)

 Unfortunately the included private baseline strut (which is the label returned for baseline-based
 auto layout) has bugs that keep it from matching custom layout. We recreate it but also allow it to
 have a width in case someone needs other kinds of auto layout constraints based off the input.

 It always has an alpha of 0.0.
 */
@property(nonatomic, nonnull, strong, readonly) UILabel *inputLayoutStrut;

/**
 An overlay view on the leading side.

 Note: if RTL is engaged, this will return the .rightView and if LTR, it will return the .leftView.
 */
@property(nonatomic, nullable, strong) UIView *leadingView;

/**
 Controls when the leading view will display.
 */
@property(nonatomic, assign) UITextFieldViewMode leadingViewMode;

@end

