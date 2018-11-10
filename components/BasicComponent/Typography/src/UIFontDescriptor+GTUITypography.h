//
//  UIFontDescriptor+GTUITypography.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import <UIKit/UIKit.h>

#import "GTUIFontTextStyle.h"

@interface UIFontDescriptor (GTUITypography)

/**
 Returns an instance of the font descriptor associated with the Material text style and scaled
 based on the content size category.

 @param style The Material font text style for which to return a font descriptor.
 @return The font descriptor associated with the specified style.
 */
+ (nonnull UIFontDescriptor *)gtui_preferredFontDescriptorForTextStyle:
(GTUIFontTextStyle)style;

/**
 Returns an instance of the font descriptor associated with the Material text style.
 This font descriptor is *not* scaled based on the content size category (Dynamic Type).

 @param style The Material font text style for which to return a font descriptor.
 @return The font descriptor associated with the specified style.
 */
+ (nonnull UIFontDescriptor *)gtui_standardFontDescriptorForTextStyle:
(GTUIFontTextStyle)style;

@end
