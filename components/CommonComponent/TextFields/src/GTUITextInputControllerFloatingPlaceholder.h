//
//  GTUITextInputControllerFloatingPlaceholder.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputController.h"

/** Controllers that have the ability to move the placeholder to a title position. */
@protocol GTUITextInputControllerFloatingPlaceholder <GTUITextInputController>

/**
 The color applied to the placeholder when floating and the text field is first responder. However,
 when in error state, it will be colored with the error color.

 Only relevent when floatingEnabled is true.

 Default is floatingPlaceholderActiveColorDefault.
 */
@property(nonatomic, null_resettable, strong) UIColor *floatingPlaceholderActiveColor;

/**
 Default value for floatingPlaceholderActiveColor.

 Default is activeColor.
 */
@property(class, nonatomic, null_resettable, strong) UIColor *floatingPlaceholderActiveColorDefault;

/**
 The color applied to the placeholder when floating. However, when in error state, it will be
 colored with the error color and when in active state, it will be colored with the active color.

 Only relevent when floatingEnabled is true.

 Default is floatingPlaceholderNormalColorDefault.
 */
@property(nonatomic, null_resettable, strong) UIColor *floatingPlaceholderNormalColor;

/**
 Default value for floatingPlaceholderNormalColor.

 Default is black with Material Design hint text opacity (textInput's tint).
 */
@property(class, nonatomic, null_resettable, strong) UIColor *floatingPlaceholderNormalColorDefault;

/**
 When the placeholder floats up, constraints are created that use this value for constants.
 */
@property(nonatomic, readonly) UIOffset floatingPlaceholderOffset;

/**
 The scale of the the floating placeholder label in comparison to the inline placeholder specified
 as a value from 0.0 to 1.0. Only relevent when floatingEnabled = true.

 If nil, the floatingPlaceholderScale is @(floatingPlaceholderScaleDefault).
 */
@property(nonatomic, null_resettable, strong) NSNumber *floatingPlaceholderScale;

/**
 Default value for the floating placeholder scale.
 NOTE:Setting this value to 0 or lower would automatically set the scale to default.
 Default is 0.75.
 */
@property(class, nonatomic, assign) CGFloat floatingPlaceholderScaleDefault;

/**
 If enabled, the inline placeholder label will float above the input when there is inputted text or
 the field is being edited.

 Default is floatingEnabledDefault.
 */
@property(nonatomic, assign, getter=isFloatingEnabled) BOOL floatingEnabled;

/**
 Default value for floatingEnabled.

 Default is YES.
 */
@property(class, nonatomic, assign, getter=isFloatingEnabledDefault) BOOL floatingEnabledDefault;

@end
