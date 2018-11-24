//
//  GTUITextInputControllerBase.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputControllerFloatingPlaceholder.h"

extern const CGFloat GTUITextInputControllerBaseDefaultBorderRadius;

/**
 Base class providing floating placeholder animation and other functionality.

 NOTE: This class is intended to be subclassed. It contains the logic for 'automagic' error states.

 The placeholder text is laid out inline. If floating is enabled, it will float above the field when
 there is content or the field is being edited. The character count is below text. The Material
 Design guidelines call this 'Floating inline labels.'
 https://material.io/go/design-text-fields#text-fields-labels

 Defaults:

 Active Color - Blue A700

 Border Fill Color - Clear
 Border Stroke Color - Clear

 Disabled Color = [UIColor lightGrayColor]

 Error Color - Red A400

 Floating Placeholder Color Active - Blue A700
 Floating Placeholder Color Normal - Black, 54% opacity

 Inline Placeholder Color - Black, 54% opacity

 Leading Underline Label Text Color - Black, 54% opacity

 Normal Color - Black, 54% opacity

 Rounded Corners - None

 Trailing Underline Label Text Color - Black, 54% opacity

 Underline Height Active - 0p
 Underline Height Normal - 0p

 Underline View Mode - While editing
 */
@interface GTUITextInputControllerBase : NSObject <GTUITextInputControllerFloatingPlaceholder>

/**
 The color behind the input and label that defines the preferred tap zone.

 Default is borderFillColorDefault.
 */
@property(nonatomic, nullable, strong) UIColor *borderFillColor;

/**
 Default value for borderFillColor.

 Default is clear.
 */
@property(class, nonatomic, null_resettable, strong) UIColor *borderFillColorDefault;

/**
 Should the controller's .textInput grow vertically as new lines are added.

 If the text input does not conform to GTUIMultilineTextInput, this parameter has no effect.

 Default is YES.

 跟随内容拓展 默认是YES
 */
@property(nonatomic, assign) BOOL expandsOnOverflow;

/**
 The minimum number of lines the controller's .textInput should use for rendering text.

 The height of an empty text field is measured in potential lines. If the value were 3, the height
 of would never be shorter than 3 times the line height of the input font (plus clearance for
 auxillary views like the underline and the underline labels.)

 The smallest number of lines allowed is 1. A value of 0 has no effect.

 If the text input does not conform to GTUIMultilineTextInput, this parameter has no effect.

 Default is 1.

 最小行数 默认1行
 */
@property(nonatomic, assign) NSUInteger minimumLines;

@end
