//
//  GTMMotionCurve.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

/**
 The possible kinds of motion curves that can be used to describe an animation.
 */
typedef NS_ENUM(NSUInteger, GTMMotionCurveType) {
    /**
     The value will be instantly set with no animation.
     */
    GTMMotionCurveTypeInstant,

    /**
     The value will be animated using a cubic bezier curve to model its velocity.
     */
    GTMMotionCurveTypeBezier,

    /**
     The value will be animated using a spring simulation.

     A spring will treat the duration property of the motion timing as a suggestion and may choose to
     ignore it altogether.
     */
    GTMMotionCurveTypeSpring,

    /**
     The default curve will be used.
     */
    GTMMotionCurveTypeDefault __deprecated_enum_msg("Use GTMMotionCurveTypeBezier instead."),

} NS_SWIFT_NAME(MotionCurveType);

/**
 A generalized representation of a motion curve.
 */
struct GTMMotionCurve {
    /**
     The type defines how to interpret the data values.
     */
    GTMMotionCurveType type;

    /**
     The data values corresponding with this curve.
     */
    CGFloat data[4];
} NS_SWIFT_NAME(MotionCurve);
typedef struct GTMMotionCurve GTMMotionCurve;

/**
 Creates a bezier motion curve with the provided control points.

 A cubic bezier has four control points in total. We assume that the first control point is 0, 0 and
 the last control point is 1, 1. This method requires that you provide the second and third control
 points.

 See the documentation for CAMediaTimingFunction for more information.
 */
// clang-format off
FOUNDATION_EXTERN
GTMMotionCurve GTMMotionCurveMakeBezier(CGFloat p1x, CGFloat p1y, CGFloat p2x, CGFloat p2y)
NS_SWIFT_NAME(MotionCurveMakeBezier(p1x:p1y:p2x:p2y:));
// clang-format on

// clang-format off
FOUNDATION_EXTERN
GTMMotionCurve GTMMotionCurveFromTimingFunction(CAMediaTimingFunction * _Nonnull timingFunction)
NS_SWIFT_NAME(MotionCurve(fromTimingFunction:));
// clang-format on

/**
 Creates a spring curve with the provided configuration.

 Tension and friction map to Core Animation's stiffness and damping, respectively.

 See the documentation for CASpringAnimation for more information.
 */
// clang-format off
FOUNDATION_EXTERN GTMMotionCurve GTMMotionCurveMakeSpring(CGFloat mass,
                                                          CGFloat tension,
                                                          CGFloat friction)
NS_SWIFT_NAME(MotionCurveMakeSpring(mass:tension:friction:));
// clang-format on

/**
 Creates a spring curve with the provided configuration.

 Tension and friction map to Core Animation's stiffness and damping, respectively.

 See the documentation for CASpringAnimation for more information.
 */
// clang-format off
FOUNDATION_EXTERN
GTMMotionCurve GTMMotionCurveMakeSpringWithInitialVelocity(CGFloat mass,
                                                           CGFloat tension,
                                                           CGFloat friction,
                                                           CGFloat initialVelocity)
NS_SWIFT_NAME(MotionCurveMakeSpring(mass:tension:friction:initialVelocity:));
// clang-format on

/**
 For cubic bezier curves, returns a reversed cubic bezier curve. For all other curve types, a copy
 of the original curve is returned.
 */
// clang-format off
FOUNDATION_EXTERN GTMMotionCurve GTMMotionCurveReversedBezier(GTMMotionCurve motionCurve)
NS_SWIFT_NAME(MotionCurveReversedBezier(fromMotionCurve:));
// clang-format on

/**
 Named indices for the bezier motion curve's data array.
 */
typedef NS_ENUM(NSUInteger, GTMBezierMotionCurveDataIndex) {
    GTMBezierMotionCurveDataIndexP1X,
    GTMBezierMotionCurveDataIndexP1Y,
    GTMBezierMotionCurveDataIndexP2X,
    GTMBezierMotionCurveDataIndexP2Y
} NS_SWIFT_NAME(BezierMotionCurveDataIndex);

/**
 Named indices for the spring motion curve's data array.
 */
typedef NS_ENUM(NSUInteger, GTMSpringMotionCurveDataIndex) {
    GTMSpringMotionCurveDataIndexMass,
    GTMSpringMotionCurveDataIndexTension,
    GTMSpringMotionCurveDataIndexFriction,

    /**
     The initial velocity of the animation.

     A value of zero indicates no initial velocity.
     A positive value indicates movement toward the destination.
     A negative value indicates movement away from the destination.

     The value's units are dependent on the context and the value being animated.
     */
    GTMSpringMotionCurveDataIndexInitialVelocity
} NS_SWIFT_NAME(SpringMotionCurveDataIndex);

// Objective-C-specific macros

#define _GTMBezier(p1x, p1y, p2x, p2y) \
((GTMMotionCurve) {                   \
.type = GTMMotionCurveTypeBezier,  \
.data = { p1x,                     \
p1y,                     \
p2x,                     \
p2y }                    \
})

#define _GTMSpring(mass, tension, friction) \
((GTMMotionCurve) {                        \
.type = GTMMotionCurveTypeSpring,       \
.data = { mass,                         \
tension,                      \
friction }                    \
})

#define _GTMSpringWithInitialVelocity(mass, tension, friction, initialVelocity) \
((GTMMotionCurve) {                        \
.type = GTMMotionCurveTypeSpring,       \
.data = { mass,                         \
tension,                      \
friction,                     \
initialVelocity }             \
})

/**
 A linear bezier motion curve.
 */
#define GTMLinearMotionCurve _GTMBezier(0, 0, 1, 1)

/**
 Timing information for an iOS modal presentation slide animation.
 */
#define GTMModalMovementTiming { \
.delay = 0.000, .duration = 0.500, .curve = _GTMSpring(3, 1000, 500) \
}

