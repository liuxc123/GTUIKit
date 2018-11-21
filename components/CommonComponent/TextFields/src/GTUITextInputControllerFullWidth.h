//
//  GTUITextInputControllerFullWidth.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputController.h"

/**
 Material Design compliant text field for full width applications like email forms.
 https://material.io/go/design-text-fields#text-fields-field-variations

 NOTE: This class does not inherit from GTUITextInputControllerBase. It does not have a floating
 placeholder.

 The placeholder is laid out inline and the character count is also inline to the trailing side.

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
@interface GTUITextInputControllerFullWidth : NSObject <GTUITextInputController>

/**
 Color for background for the various views making up a text field.

 Default is backgroundColorDefault.
 */
@property(nonatomic, null_resettable, strong) UIColor *backgroundColor;

/**
 Default value for backgroundColor.
 */
@property(class, nonatomic, null_resettable, strong) UIColor *backgroundColorDefault;

@end
