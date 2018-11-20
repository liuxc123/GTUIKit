//
//  GTUITabBarIndicatorView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>

@class GTUITabBarIndicatorAttributes;

/** View responsible for drawing the indicator behind tab content and animating changes. */
@interface GTUITabBarIndicatorView : UIView

/**
 Called to indicate that the indicator should update to display new attributes. This method may be
 called from an implicit animation block.
 */
- (void)applySelectionIndicatorAttributes:(GTUITabBarIndicatorAttributes *)attributes;

@end
