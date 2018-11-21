//
//  GTMMotionRepetition.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

/**
 The possible kinds of repetition that can be used to describe an animation.
 */
typedef NS_ENUM(NSUInteger, GTMMotionRepetitionType) {
    /**
     The animation will be not be repeated.
     */
    GTMMotionRepetitionTypeNone,

    /**
     The animation will be repeated a given number of times.
     */
    GTMMotionRepetitionTypeCount,

    /**
     The animation will be repeated for a given number of seconds.
     */
    GTMMotionRepetitionTypeDuration,

} NS_SWIFT_NAME(MotionReptitionType);

/**
 A generalized representation of a motion curve.
 */
struct GTMMotionRepetition {
    /**
     The type defines how to interpret the amount.
     */
    GTMMotionRepetitionType type;

    /**
     The amount of repetition.
     */
    double amount;

    /**
     Whether the animation should animate backwards after animating forwards.
     */
    BOOL autoreverses;

} NS_SWIFT_NAME(MotionRepetition);
typedef struct GTMMotionRepetition GTMMotionRepetition;

// Objective-C-specific macros

#define _GTMNoRepetition                 \
(GTMMotionRepetition) {                \
.type = GTMMotionRepetitionTypeNone, \
.amount = 0,                         \
.autoreverses = false                \
}

