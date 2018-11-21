//
//  GTUIMultilineTextField.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

#import "GTUITextInput.h"

@class GTUIIntrinsicHeightTextView;

@protocol GTUIMultilineTextInputDelegate;
@protocol GTUIMultilineTextInputLayoutDelegate;

/**
 Material Design themed mutiline text field (multiline text input).
 https://www.google.com/design/spec/components/text-fields.html#text-fields-multi-line-text-field
 */
@interface GTUIMultilineTextField : UIView <GTUITextInput, GTUIMultilineTextInput>

/** A mirror of the same property that already exists on UITextField, UITextView, and UILabel. */
@property(nonatomic, assign) BOOL adjustsFontForContentSizeCategory;

/**
 Should the text field grow vertically as new lines are added.

 Default is YES.

 Note: Inherited from GTUIMultilineTextInput protocol. Added here to declare Interface Builder
 support (IBInspectable).
 */
@property(nonatomic, assign) IBInspectable BOOL expandsOnOverflow;

/**
 The delegate for changes to preferred content size.

 If using auto layout, it is not necessary to have a layout delegate.
 */
@property(nonatomic, nullable, weak) IBOutlet id<GTUIMultilineTextInputLayoutDelegate>
layoutDelegate;

/** An optional delegate for useful methods not included in UITextViewDelegate.*/
@property(nonatomic, nullable, weak) IBOutlet id<GTUIMultilineTextInputDelegate> multilineDelegate;

/**
 The text string of the placeholder label.
 Bringing convenience api found in UITextField to all GTUITextInputs. Maps to the .text of the
 placeholder label.

 Note: Inherited from GTUITextInput protocol. Added here to declare Interface Builder support
 (IBInspectable).
 */
@property(nonatomic, nullable, copy) IBInspectable NSString *placeholder;

/** Insets used to calculate the spacing of subviews. */
@property(nonatomic, assign, readonly) UIEdgeInsets textInsets;

/**
 Embedded textView. Can be set from storyboard or will be auto-created during initialization.
 */
@property(nonatomic, nullable, strong) IBOutlet GTUIIntrinsicHeightTextView *textView;

@end

/** Delegate for GTUITextInput size changes. */
@protocol GTUIMultilineTextInputLayoutDelegate <NSObject>

@optional
/**
 Notifies the delegate that the text field's content size changed, requiring the size provided for
 best display.

 If using auto layout, this method is unnecessary; this is a way for views not implementing auto
 layout to know when to grow and shrink height to accomodate changes in content.

 @param multilineTextField  The text field for which the content size changed.
 @param size                The size required by the text view to fit all of its content.
 */
- (void)multilineTextField:(id<GTUIMultilineTextInput> _Nonnull)multilineTextField
      didChangeContentSize:(CGSize)size;

@end
