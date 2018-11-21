//
//  GTUITextInputControllerOutlined.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputControllerBase.h"

/**
 Material Design compliant text field with border and border-crossing, floating label from 2017. It
 is intended to be used on single-line text fields.

 The placeholder text is laid out inline. It will float above the field when there is content or the
 field is being edited. The character count is below text.

 The background is opaque, the corners are rounded, there is a border, there is an underline, and
 the placeholder crosses the border cutting out a space.

 Defaults:

 Active Color - Blue A700

 Border Stroke Color - Clear
 Border Fill Color - Clear

 Disabled Color = [UIColor lightGrayColor]

 Error Color - Red A400

 Floating Placeholder Color Active - Blue A700
 Floating Placeholder Color Normal - Black, 54% opacity

 Inline Placeholder Color - Black, 54% opacity

 Leading Underline Label Text Color - Black, 54% opacity

 Normal Color - Black, 54% opacity

 Rounded Corners - All

 Trailing Underline Label Text Color - Black, 54% opacity

 Underline Color Normal - Black, 54% opacity

 Underline Height Active - 2p
 Underline Height Normal - 1p

 Underline View Mode - While editing
 */
@interface GTUITextInputControllerOutlined : GTUITextInputControllerBase

@end
