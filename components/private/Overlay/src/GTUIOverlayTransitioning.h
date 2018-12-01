//
//  GTUIOverlayTransitioning.h
//  Pods
//
//  Created by liuxc on 2018/12/1.
//

#import <UIKit/UIKit.h>

/**
 Protocol representing a single overlay on the screen.
 */
@protocol GTUIOverlay <NSObject>

/**
 A unique identifier for the overlay. Opaque.
 */
@property(nonatomic, readonly, copy) NSString *identifier;

/**
 The frame of the overlay, in screen coordinates.
 */
@property(nonatomic, readonly) CGRect frame;

@end

/**
 Protocol representing a change in the overlays currently on screen.
 */
@protocol GTUIOverlayTransitioning <NSObject>

/**
 The duration of the animation used to change the overlay frames.

 A duration of 0 means the transition is not animated.
 */
@property(nonatomic, readonly) NSTimeInterval duration;

/**
 If animated, the timing function that should be used when animating the overlay frame change.

 If @c duration is 0, this value is undefined.
 */
@property(nonatomic, readonly) CAMediaTimingFunction *customTimingFunction;

/**
 If animated, the curve that should be used when animating the overlay frame change.

 If @c duration is 0, or if @c customTimingFunction is non-nil, then this value is undefined.
 */
@property(nonatomic, readonly) UIViewAnimationCurve animationCurve;

/**
 The union of the frames for every overlay currently on screen, in screen coordinates.

 This frame is the smallest frame which encompasses all of the overlays currently on screen.

 @note This is generally the frame you want, but it can be "greedy" in that the reported frame may
 not be the most accurate reflection of the overlays on screen. Imagine an overlay that is
 half the screen's width above a full-width view. The resulting composite frame will be the
 full width of the screen plus the height of the two views.
 */
@property(nonatomic, readonly) CGRect compositeFrame;

/**
 The value of @c compositeFrame in @c targetView's coordinate space.

 The result may go outside of the bounds of @c targetView.
 */
- (CGRect)compositeFrameInView:(UIView *)targetView;

/**
 Enumerates through each overlay on the screen, calling @c handler for each one.
 */
- (void)enumerateOverlays:(void (^)(id<GTUIOverlay> overlay, NSUInteger idx, BOOL *stop))handler;

/**
 Runs @c animations alongside the overlay transition animation.
 */
- (void)animateAlongsideTransition:(void (^)(void))animations;

/**
 Runs @c animations alongside the overlay transition animation, calling @c completion when the
 animation is finished.

 @note Any curves specified in @c options will be ignored.
 */
- (void)animateAlongsideTransitionWithOptions:(UIViewAnimationOptions)options
                                   animations:(void (^)(void))animations
                                   completion:(void (^)(BOOL finished))completion;

@end

