//
//  UIFont+GTUITypography.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import <UIKit/UIKit.h>

#import "GTUIFontTextStyle.h"

@interface UIFont (GTUITypography)


/**
 Returns an instance of the font associated with the Material text style and scaled based on the content size category.

 @param style The Material font text style for which to return a font.
 @return The font associated with the specified style.
 */
+ (nonnull UIFont *)gtui_preferredFontForTextStyle:(GTUIFontTextStyle)style;


/**
 Returns an instance of the font associated with the Material text style
 This font is *not* scaled based on the content size category (Dynamic Type).

 @param style The Material font text style for which to return a font.
 @return The font associated with the specified style.
 */
+ (nonnull UIFont *)gtui_standardFontForTextStyle:(GTUIFontTextStyle)style;


/**
 Returns an new instance of the font sized according to the text-style and whether the content
 size category (Dynamic Type) should be taken into account.

 @param style The Material font text style that will determine the fontSize of the new font
 @param scaled Should the new font be scaled according to the content size category (Dynamic Type)
 @return The font associated with the specified style.
 */
- (nonnull UIFont *)gtui_fontSizedForFontTextStyle:(GTUIFontTextStyle)style
                                 scaledForDynamicType:(BOOL)scaled;


@end
