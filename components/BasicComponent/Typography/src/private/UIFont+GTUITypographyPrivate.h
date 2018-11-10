//
//  UIFont+GTUITypographyPrivate.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import <UIKit/UIKit.h>

@interface UIFont (GTUITypographyPrivate)

/**
 Returns the weight of the font.

 @return A value between -1.0 (very thin) to 1.0 (very thick).

 Regular weight is 0.0.
 */
- (CGFloat)gtui_weight;

/**
 Returns the slant of the font.

 @return more than 0 when italic and 0 when not italic.

 Regular slant is 0.0.
 */
- (CGFloat)gtui_slant;

/**
 Returns an extended description of the font including name, pointsize and weight.
 */
- (nonnull NSString *)gtui_extendedDescription;

@end
