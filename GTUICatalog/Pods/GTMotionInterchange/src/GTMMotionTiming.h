//
//  GTMMotionTiming.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#import "GTMMotionCurve.h"
#import "GTMMotionRepetition.h"

/**
 A representation of timing for an animation.
 */
struct GTMMotionTiming {
    /**
     The amount of time, in seconds, before this animation's value interpolation should begin.
     */
    CFTimeInterval delay;

    /**
     The amount of time, in seconds, over which this animation should interpolate between its values.
     */
    CFTimeInterval duration;

    /**
     The velocity and acceleration of the animation over time.
     */
    GTMMotionCurve curve;

    /**
     The repetition characteristics of the animation.
     */
    GTMMotionRepetition repetition;

} NS_SWIFT_NAME(MotionTiming);
typedef struct GTMMotionTiming GTMMotionTiming;

