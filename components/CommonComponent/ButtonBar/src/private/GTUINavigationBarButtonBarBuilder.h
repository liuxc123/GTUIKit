//
//  GTUINavigationBarButtonBarBuilder.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import "GTUIButtonBar.h"

@interface GTUINavigationBarButtonBarBuilder : NSObject

/**
 Returns a view that represents the given bar button item.
 */
- (UIView *)buttonBar:(GTUIButtonBar *)buttonBar
          viewForItem:(UIBarButtonItem *)barButtonItem
          layoutHints:(GTUIBarButtonItemLayoutHints)layoutHints;

/** The title color for the bar button items. */
@property(nonatomic, strong) UIColor *buttonTitleColor;

/** The underlying color for the bar button items. */
@property(nonatomic, strong) UIColor *buttonUnderlyingColor;

/**
 Sets the desired button title font for a given state. Will only affect buttons created after this
 invocation.

 @param font The font that should be displayed on text buttons for the given state.
 @param state The state for which the font should be displayed.
 */
- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state;

/**
 Gets the desired button title font for a given state.

 If no font has been set for a given state, the returned value will fall back to the value
 set for UIControlStateNormal.

 @param state The state for which the font should be returned.
 @return The font associated with the given state.
 */
- (UIFont *)titleFontForState:(UIControlState)state;

/**
 Sets the title label color for the given state for all buttons.

 @param color The color that should be used on text buttons labels for the given state.
 @param state The state for which the color should be used.
 */
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

/**
 Returns the color set for @c state that was set by setButtonsTitleColor:forState:.

 If no value has been set for a given state, the returned value will fall back to the value
 set for UIControlStateNormal.

 @param state The state for which the color should be returned.
 @return The color associated with the given state.
 */
- (UIColor *)titleColorForState:(UIControlState)state;

@end
