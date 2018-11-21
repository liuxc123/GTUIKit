//
//  GTUITextInputControllerUnderline.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputControllerBase.h"

/**
 Material Design compliant text field from early 2017 with floating placeholder and an underline.
 https://www.google.com/design/spec/components/text-fields.html#text-fields-single-line-text-field
 https://material.io/go/design-text-fields#text-fields-labels

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

Rounded Corners - None

Trailing Underline Label Text Color - Black, 54% opacity

Underline Color Normal - Black, 54% opacity

Underline Height Active - 2p
Underline Height Normal - 1p

Underline View Mode - While editing
*/
@interface GTUITextInputControllerUnderline : GTUITextInputControllerBase

@end
