//
//  GTMSpringTimingCurve.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#import "GTMSubclassingRestricted.h"
#import "GTMTimingCurve.h"

/**
 A timing curve that represents the motion of a single-dimensional attached spring.
 */
GTM_SUBCLASSING_RESTRICTED
@interface GTMSpringTimingCurve: NSObject <NSCopying, GTMTimingCurve>

/**
 Initializes the timing curve with the given parameters and an initial velocity of zero.

 @param mass The mass of the spring simulation. Affects the animation's momentum.
 @param tension The tension of the spring simulation. Affects how quickly the animation moves
 toward its destination.
 @param friction The friction of the spring simulation. Affects how quickly the animation starts
 and stops.
 */
- (nonnull instancetype)initWithMass:(CGFloat)mass
                             tension:(CGFloat)tension
                            friction:(CGFloat)friction;

/**
 Initializes the timing curve with the given parameters.

 @param mass The mass of the spring simulation. Affects the animation's momentum.
 @param tension The tension of the spring simulation. Affects how quickly the animation moves
 toward its destination.
 @param friction The friction of the spring simulation. Affects how quickly the animation starts
 and stops.
 @param initialVelocity The initial velocity of the spring simulation. Measured in units of
 translation per second. For example, if the property being animated is positional, then this value
 is in screen units per second.
 */
- (nonnull instancetype)initWithMass:(CGFloat)mass
                             tension:(CGFloat)tension
                            friction:(CGFloat)friction
                     initialVelocity:(CGFloat)initialVelocity
NS_DESIGNATED_INITIALIZER;

#pragma mark - Traits

/**
 The mass of the spring simulation.

 Affects the animation's momentum. This is usually 1.
 */
@property(nonatomic, assign) CGFloat mass;

/**
 The tension of the spring simulation.

 Affects how quickly the animation moves toward its destination.
 */
@property(nonatomic, assign) CGFloat tension;

/**
 The friction of the spring simulation.

 Affects how quickly the animation starts and stops.
 */
@property(nonatomic, assign) CGFloat friction;

/**
 The initial velocity of the spring simulation.

 Measured in units of translation per second.

 If this timing curve was initialized using a damping ratio then setting a new initial velocity
 will also change the the mass/tension/friction values according to the new UIKit damping
 coefficient calculation.
 */
@property(nonatomic, assign) CGFloat initialVelocity;

/** Unavailable. */
- (nonnull instancetype)init NS_UNAVAILABLE;

@end

