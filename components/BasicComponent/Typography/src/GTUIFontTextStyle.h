//
//  GTUIFontTextStyle.h
//  Pods
//
//  Created by liuxc on 2018/11/8.
//

#import <Foundation/Foundation.h>

/**
 Material font text styles

 These styles are defined in:
 https://material.io/go/design-typography
 This enumeration is a set of semantic descriptions intended to describe the fonts returned by
 + [UIFont gtui_preferredFontForMaterialTextStyle:]
 + [UIFontDescriptor gtui_preferredFontDescriptorForMaterialTextStyle:]
 */
typedef NS_ENUM(NSInteger, GTUIFontTextStyle) {
    GTUIFontTextStyleBody1,
    GTUIFontTextStyleBody2,
    GTUIFontTextStyleCaption,
    GTUIFontTextStyleHeadline,
    GTUIFontTextStyleSubheadline,
    GTUIFontTextStyleTitle,
    GTUIFontTextStyleDisplay1,
    GTUIFontTextStyleDisplay2,
    GTUIFontTextStyleDisplay3,
    GTUIFontTextStyleDisplay4,
    GTUIFontTextStyleButton,
};
