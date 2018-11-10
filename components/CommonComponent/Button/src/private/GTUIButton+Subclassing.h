//
//  GTUIButton+Subclassing.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import "GTUIButton.h"

@class GTUIInkView;

@interface GTUIButton (Subclassing)

/** Access to the ink view layer. Mainly used for subclasses to override ink properties. */
@property(nonatomic, readonly, strong, nonnull) GTUIInkView *inkView;

/** Whether the background color should be opaque. */
- (BOOL)shouldHaveOpaqueBackground;

/** Updates the background color based on the button's current configuration. */
- (void)updateBackgroundColor;

/**
 Should the button raise when touched?

 Default is YES.
 */
@property(nonatomic) BOOL shouldRaiseOnTouch;

/** The bounding path of the button. The shadow will follow that path. */
- (nonnull UIBezierPath *)boundingPath;


/** The default content edge insets of the button. They are set at initialization time. */
- (UIEdgeInsets)defaultContentEdgeInsets;

@end
