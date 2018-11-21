//
//  GTUITextInputControllerFilled.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputControllerBase.h"

/**
 Material Design compliant filled background text field from 2017.

 NOTE: All 'automagic' logic is inherited from GTUITextInputControllerBase.

 The background is filled, the corners are rounded, there's no border, there is an underline, and
 the placeholder is centered vertically in the filled area.

 Defaults:

 Active Color - Blue A700

 Border Fill Color - Black, 6% opacity
 Border Stroke Color - Clear

 Disabled Color = [UIColor lightGrayColor]

 Error Color - Red A400

 Floating Placeholder Color Active - Blue A700
 Floating Placeholder Color Normal - Black, 54% opacity

 Inline Placeholder Color - Black, 54% opacity

 Leading Underline Label Text Color - Black, 54% opacity

 Normal Color - Black, 54% opacity

 Rounded Corners - All

 Trailing Underline Label Text Color - Black, 54% opacity

 Underline Height Active - 2p
 Underline Height Normal - 1p

 Underline View Mode - While editing
 */
@interface GTUITextInputControllerFilled : GTUITextInputControllerBase

@end
