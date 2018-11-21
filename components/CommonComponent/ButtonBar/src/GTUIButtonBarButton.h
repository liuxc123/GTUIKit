//
//  GTUIButtonBarButton.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import "GTButton.h"

/**
 The GTUIButtonBarButton class is used by GTUIButtonBar.
 */
@interface GTUIButtonBarButton : GTUIButton

/**
 The font used by the button's @c title.

 If left unset or reset to nil for a given state, then a default font is used.

 @param font The font.
 @param state The state.
 */
- (void)setTitleFont:(nullable UIFont *)font forState:(UIControlState)state
UI_APPEARANCE_SELECTOR;

@end
