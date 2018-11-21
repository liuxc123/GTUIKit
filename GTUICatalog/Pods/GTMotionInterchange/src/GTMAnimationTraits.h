//
//  GTMAnimationTraits.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GTMMotionTiming.h"
#import "GTMRepetitionTraits.h"
#import "GTMSubclassingRestricted.h"
#import "GTMTimingCurve.h"

/**
 A generic representation of animation traits.
 */
GTM_SUBCLASSING_RESTRICTED
@interface GTMAnimationTraits: NSObject <NSCopying>

/**
 Initializes the instance with the provided duration and kCAMediaTimingFunctionEaseInEaseOut timing
 curve.

 @param duration The animation will occur over this length of time, in seconds.
 */
- (nonnull instancetype)initWithDuration:(NSTimeInterval)duration;

/**
 Initializes the instance with the provided duration and named bezier timing curve.

 @param duration The animation will occur over this length of time, in seconds.
 @param animationCurve A UIKit bezier animation curve type.
 */
- (nonnull instancetype)initWithDuration:(NSTimeInterval)duration
                          animationCurve:(UIViewAnimationCurve)animationCurve;

/**
 Initializes the instance with the provided duration, delay, and
 kCAMediaTimingFunctionEaseInEaseOut timing curve.

 @param delay The amount of time, in seconds, to wait before starting the animation.
 @param duration The animation will occur over this length of time, in seconds, after the delay time
 has passed.
 */
- (nonnull instancetype)initWithDelay:(NSTimeInterval)delay duration:(NSTimeInterval)duration;

/**
 Initializes the instance with the provided duration, delay, and named bezier timing curve.

 This is a convenience API for defining a timing curve using the Core Animation timing function
 names. See the documentation for CAMediaTimingFunction for more details.

 @param delay The amount of time, in seconds, to wait before starting the animation.
 @param duration The animation will occur over this length of time, in seconds, after the delay time
 has passed.
 @param animationCurve A UIKit bezier animation curve type.
 */
- (nonnull instancetype)initWithDelay:(NSTimeInterval)delay
                             duration:(NSTimeInterval)duration
                       animationCurve:(UIViewAnimationCurve)animationCurve;

/**
 Initializes the instance with the provided duration, delay, and timing curve.

 @param delay The amount of time, in seconds, to wait before starting the animation.
 @param duration The animation will occur over this length of time, in seconds, after the delay time
 has passed.
 @param timingCurve If provided, defines the acceleration timing for the animation. If nil, the
 animation will be treated as instant and the duration/delay will be ignored.
 */
- (nonnull instancetype)initWithDelay:(NSTimeInterval)delay
                             duration:(NSTimeInterval)duration
                          timingCurve:(nullable id<GTMTimingCurve>)timingCurve;

/**
 Initializes an animation trait with the provided timing curve, duration, delay, and repetition.

 @param duration The animation will occur over this length of time, in seconds, after the delay time
 has passed.
 @param delay The amount of time, in seconds, to wait before starting the animation.
 @param timingCurve If provided, defines the acceleration timing for the animation. If nil, the
 animation will be treated as instant and the duration/delay will be ignored.
 @param repetition The repetition traits of the animation. Most often an instance of GTMRepetition
 or GTMRepetitionOverTime. If nil, the animation will not repeat.
 */
- (nonnull instancetype)initWithDelay:(NSTimeInterval)delay
                             duration:(NSTimeInterval)duration
                          timingCurve:(nullable id<GTMTimingCurve>)timingCurve
                           repetition:(nullable id<GTMRepetitionTraits>)repetition
NS_DESIGNATED_INITIALIZER;

#pragma mark - Traits

/**
 The amount of time, in seconds, before this animation's value interpolation should begin.
 */
@property(nonatomic, assign) NSTimeInterval delay;

/**
 The amount of time, in seconds, over which this animation should interpolate between its values.
 */
@property(nonatomic, assign) NSTimeInterval duration;

/**
 The velocity and acceleration of the animation over time.

 If the timing curve is nil then the timing is assumed to be "instant", regardless of duration and
 delay.
 */
@property(nonatomic, strong, nullable) id<GTMTimingCurve> timingCurve;

/**
 The repetition characteristics of the animation.

 If the repetition is nil then no repetition should occur.
 */
@property(nonatomic, strong, nullable) id<GTMRepetitionTraits> repetition;

#pragma mark - Unavailable

/**
 Unavailable.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

@end

@interface GTMAnimationTraits (SystemTraits)

/**
 Animation traits for an iOS modal presentation slide animation.
 */
@property(nonatomic, class, strong, nonnull, readonly) GTMAnimationTraits *systemModalMovement;

@end

@interface GTMAnimationTraits (Legacy)

/**
 Initializes the instance with the provided legacy C-style animation trait structure.

 @param timing A legacy C-style representation of animation traits.
 */
- (nonnull instancetype)initWithMotionTiming:(GTMMotionTiming)timing;

@end

