//
//  GTUIMultilineTextInputDelegate.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

/**
 GTUIMultilineTextInputDelegate has a method common to the UITextFieldDelegate protocol but not
 found in UITextViewDelegate.
 */

#import <UIKit/UIKit.h>

@protocol GTUIMultilineTextInputDelegate <NSObject>

@optional

/**
 Called when the clear button is tapped.

 Return YES to set the textfield's .text to nil.
 Return NO to ignore and keep the .text.

 A direct mirror of UITextFieldDelegate's textFieldShouldClear:.

 UITextView's don't require this method already because they do not have clear buttons. The clear
 button in GTUIMultilineTextField is custom.
 */
- (BOOL)multilineTextFieldShouldClear:(UIView<GTUITextInput> *)textField;

@end

