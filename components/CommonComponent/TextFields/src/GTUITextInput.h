//
//  GTUITextInput.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

/**
 The Material Design guidelines have many suggestions for handling text input. The inputs that
 conform to this protocol have all the API necessary to achieve those suggestions.

 They are, however, dumb; they do not handle error state nor validation.

 - For handling error states and other Material behaviors use an GTUITextInputController on your
 inputs.
 - For validation, there are many 3rd party libraries you can use like:
 - https://github.com/3lvis/Validation
 - https://github.com/adamwaite/Validator
 */

/**
 This represents different options for the relationship between the labels and the alignment rect.
 */
typedef NS_ENUM(NSUInteger, GTUITextInputTextInsetsMode) {
    GTUITextInputTextInsetsModeNever = 0,
    GTUITextInputTextInsetsModeIfContent,
    GTUITextInputTextInsetsModeAlways,
};

@class GTUITextInputBorderView;
@class GTUITextInputUnderlineView;

@protocol GTUITextInputPositioningDelegate;

/** Common API for Material Design compliant text inputs. */
@protocol GTUITextInput <NSObject>

/**
 The attributed text string of the placeholder label.
 Bringing convenience api found in UITextField to all GTUITextInputs. Maps to the .attributedText of
 the
 placeholder label.
 */
@property(nonatomic, nullable, copy) NSAttributedString *attributedPlaceholder;

/** The text displayed in the text input with style attributes. */
@property(nonatomic, nullable, copy) NSAttributedString *attributedText;

/**
 The path of the area to be highlighted with a border. This could either be with a drawn line or a
 drawn fill.

 Note: The settable properties of the UIBezierPath are respected (.lineWidth, etc).

 Default is a rectangle of the same width as the input with rounded top corners. That means the
 underline labels are not included inside the border. Settable properties of UIBezierPath are left
 at
 system defaults.
 */
@property(nonatomic, nullable, copy) UIBezierPath *borderPath UI_APPEARANCE_SELECTOR;

/** The view that implements a bordered or background filled area. */
@property(nonatomic, nullable, strong) GTUITextInputBorderView *borderView;

/**
 A button that can appear inline that when touched clears all entered text and resets the input to
 an empty state.
 */
@property(nonatomic, nonnull, strong, readonly) UIButton *clearButton;

/**
 Controls when the clear button will display.

 Note: The clear button will never display when there is no entered text.
 */
@property(nonatomic, assign) UITextFieldViewMode clearButtonMode UI_APPEARANCE_SELECTOR;

/**
 The color of the blinking cursor (in the text).

 Applied via .tintColor on the UITextField or UITextView instance.

 Default is [GTUIPalette bluePalette].accent700.
 */
@property(nonatomic, nullable, strong) UIColor *cursorColor UI_APPEARANCE_SELECTOR;

/** A Boolean value indicating whether the text field is currently in edit mode. */
@property(nonatomic, assign, readonly, getter=isEditing) BOOL editing;

/**
 A Boolean value indicating whether the input is enabled.

 The main use of this is to change the appearance when isEnabled = NO to look 'disabled'.

 Some inputs will inherit this from UIControl.
 */
@property(nonatomic, assign, getter=isEnabled) BOOL enabled;

/** The font of the text in the input. */
@property(nonatomic, nullable, strong) UIFont *font;

/** Should it have the standard behavior of disappearing when you type? Defaults to YES. */
@property(nonatomic, assign) BOOL hidesPlaceholderOnInput;

/**
 The label on the leading side under the input.

 This will usually be used for placeholder text to be displayed when no text has been entered. The
 Material Design guidelines call this 'helper text.'
 */
@property(nonatomic, nonnull, strong, readonly) UILabel *leadingUnderlineLabel;

/*
 Indicates whether the alert contents should automatically update their font when the device’s
 UIContentSizeCategory changes.

 This property is modeled after the adjustsFontForContentSizeCategory property in the
 UIConnectSizeCategoryAdjusting protocol added by Apple in iOS 10.0.

 Default value is NO.
 */
@property(nonatomic, setter=gtui_setAdjustsFontForContentSizeCategory:)
BOOL gtui_adjustsFontForContentSizeCategory UI_APPEARANCE_SELECTOR;

/**
 The text string of the placeholder label.
 Bringing convenience api found in UITextField to all GTUITextInputs. Maps to the .text of the
 placeholder label.
 */
@property(nonatomic, nullable, copy) NSString *placeholder;

/**
 The label displaying text when no input text has been entered. The Material Design guidelines call
 this 'Hint text.'
 */
@property(nonatomic, nonnull, strong, readonly) UILabel *placeholderLabel;

/**
 An optional delegate that can be queried for important layout information like the text insets for
 any input and the editing rect, clear button rect for a text field.
 */
@property(nonatomic, nullable, weak) id<GTUITextInputPositioningDelegate> positioningDelegate;

/** The text displayed in the text input. */
@property(nonatomic, nullable, copy) NSString *text;

/** The color of the text in the input. */
@property(nonatomic, nullable, strong) UIColor *textColor;

/**
 Insets used to calculate the spacing of subviews.

 NOTE: This is always in LTR. It's automatically flipped when used in RTL.
 */
@property(nonatomic, assign, readonly) UIEdgeInsets textInsets;

/**
 Used to calculate text insets.

 The different options apply to the text insets of the entire text input in relation to the
 underline labels and the placeholder should any of them be outside the border view.

 GTUITextInputTextInsetsModeNever:      Text insets never includes the labels.

 GTUITextInputTextInsetsModeIfContent:  Text insets height includes space for each label that has
 text.

 GTUITextInputTextInsetsModeAlways:     Text insets always includes the labels.

 Default is GTUITextInputTextInsetsModeIfContent.
 */
@property(nonatomic, assign) GTUITextInputTextInsetsMode textInsetsMode UI_APPEARANCE_SELECTOR;

/**
 The label on the trailing side under the input.

 This will usually be for the character count / limit.
 */
@property(nonatomic, nonnull, strong, readonly) UILabel *trailingUnderlineLabel;

/**
 An overlay view on the side of the input opposite from where reading and writing lines begin. In
 LTR this means it will show on the Right side. In LTR, the Left side.
 */
@property(nonatomic, nullable, strong) UIView *trailingView;

/**
 Controls when the trailing view will display.
 */
@property(nonatomic, assign) UITextFieldViewMode trailingViewMode;

/** The underline view */
@property(nonatomic, nullable, strong, readonly) GTUITextInputUnderlineView *underline;

@end

/**
 Common API for text inputs that support having a leading view.

 GTUITextField implements this protocol but GTUIMultilineTextField does not because the designers
 determined multiline text fields should only have trailing views.
 */
@protocol GTUILeadingViewTextInput <GTUITextInput>

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

/** Common API for Material Design compliant multi-line text inputs. */
@protocol GTUIMultilineTextInput <GTUITextInput>

/**
 Should the text field grow vertically as new lines are added.

 Default is YES.
 */
@property(nonatomic, assign) BOOL expandsOnOverflow;

/**
 The minimum number of lines to use for rendering text.

 The height of an empty text field is measured in potential lines. If the value were 3, the height
 of would never be shorter than 3 times the line height of the input font (plus clearance for
 auxillary views like the underline and the underline labels.)

 The smallest number of lines allowed is 1. A value of 0 has no effect.

 Default is 1.
 */
@property(nonatomic, assign) NSUInteger minimumLines UI_APPEARANCE_SELECTOR;

@end
