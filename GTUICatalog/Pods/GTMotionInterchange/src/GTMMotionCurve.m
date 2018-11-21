//
//  GTMMotionCurve.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMMotionCurve.h"

GTMMotionCurve GTMMotionCurveMakeBezier(CGFloat p1x, CGFloat p1y, CGFloat p2x, CGFloat p2y) {
    return _GTMBezier(p1x, p1y, p2x, p2y);
}

GTMMotionCurve GTMMotionCurveMakeSpring(CGFloat mass, CGFloat tension, CGFloat friction) {
    return GTMMotionCurveMakeSpringWithInitialVelocity(mass, tension, friction, 0);
}

GTMMotionCurve GTMMotionCurveMakeSpringWithInitialVelocity(CGFloat mass,
                                                           CGFloat tension,
                                                           CGFloat friction,
                                                           CGFloat initialVelocity) {
    return _GTMSpringWithInitialVelocity(mass, tension, friction, initialVelocity);
}

GTMMotionCurve GTMMotionCurveFromTimingFunction(CAMediaTimingFunction *timingFunction) {
    float pt1[2];
    float pt2[2];
    [timingFunction getControlPointAtIndex:1 values:pt1];
    [timingFunction getControlPointAtIndex:2 values:pt2];
    return GTMMotionCurveMakeBezier(pt1[0], pt1[1], pt2[0], pt2[1]);
}

GTMMotionCurve GTMMotionCurveReversedBezier(GTMMotionCurve motionCurve) {
    GTMMotionCurve reversed = motionCurve;
    if (motionCurve.type == GTMMotionCurveTypeBezier) {
        reversed.data[0] = 1 - motionCurve.data[2];
        reversed.data[1] = 1 - motionCurve.data[3];
        reversed.data[2] = 1 - motionCurve.data[0];
        reversed.data[3] = 1 - motionCurve.data[1];
    }
    return reversed;
}

