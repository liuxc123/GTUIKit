//
//  GTUIInkGestureRecognizer.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <UIKit/UIKit.h>

/**
 Custom gesture recognizer to observe the various ink response states.

 GTUIInkGestureRecognizer is a continuous recognizer that tracks single touches and optionally
 fails if the touch moves outside the recongizer's view. Multiple touches will cause the
 recognizer to transition to the UIGestureRecognizerStateCancelled state.
 */
@interface GTUIInkGestureRecognizer : UIGestureRecognizer

/**
 Set the distance that causes the recognizer to cancel.
 */
@property(nonatomic, assign) CGFloat dragCancelDistance;

/**
 Set when dragging outside of the view causes the gesture recognizer to cancel.

 Defaults to YES.
 */
@property(nonatomic, assign) BOOL cancelOnDragOut;

/**
 Bounds inside of which the recognizer will recognize ink gestures, relative to self.view.frame.

 If set to CGRectNull (the default), then the recognizer will use self.view.bounds as the target
 bounds.

 If cancelOnDragOut is YES and the user's touch moves beyond the target bounds inflated by
 dragCancelDistance then the gesture is cancelled.
 */
@property(nonatomic) CGRect targetBounds;

/**
 Returns the point where the ink starts spreading from.

 @param view View which the point is relative to.
 */
- (CGPoint)touchStartLocationInView:(UIView *)view;

/** Returns YES if the touch's current location is still within the target bounds. */
- (BOOL)isTouchWithinTargetBounds;

@end
