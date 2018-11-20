//
//  GTUIFloatingButton+Animation.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUIFloatingButton.h"

@interface GTUIFloatingButton (Animation)

/**
 Expand this button to its unscaled (normal) size.

 @param animated YES if the size change should be animated.
 @param completion a completion block to call after the size change is complete.

 @note This method will modify the transform property of the button. Apple's documentation about
 UIView frames and transforms states that whenever the transform is not the identity
 transform, the frame is undefined and should be ignored.
 https://developer.apple.com/documentation/uikit/uiview/1622621-frame
 */
- (void)expand:(BOOL)animated completion:(void (^_Nullable)(void))completion;

/**
 Collapses this button so that it becomes smaller than 0.1% of its normal size.

 @param animated YES if the size change should be animated.
 @param completion a completion block to call after the size change is complete.

 @note This method will modify the transform property of the button. Apple's documentation about
 UIView frames and transforms states that whenever the transform is not the identity
 transform, the frame is undefined and should be ignored.
 https://developer.apple.com/documentation/uikit/uiview/1622621-frame
 */
- (void)collapse:(BOOL)animated completion:(void (^_Nullable)(void))completion;

@end
