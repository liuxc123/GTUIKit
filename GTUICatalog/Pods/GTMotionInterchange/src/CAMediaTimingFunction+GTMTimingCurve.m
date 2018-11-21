//
//  CAMediaTimingFunction+MDMTimingCurve.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "CAMediaTimingFunction+GTMTimingCurve.h"

@implementation CAMediaTimingFunction (MotionInterchangeExtension)

- (CAMediaTimingFunction *)gtm_reversed {
    float pt1[2];
    float pt2[2];
    [self getControlPointAtIndex:1 values:pt1];
    [self getControlPointAtIndex:2 values:pt2];

    float reversedPt1[2];
    float reversedPt2[2];
    reversedPt1[0] = 1 - pt2[0];
    reversedPt1[1] = 1 - pt2[1];
    reversedPt2[0] = 1 - pt1[0];
    reversedPt2[1] = 1 - pt1[1];
    return [CAMediaTimingFunction functionWithControlPoints:reversedPt1[0] :reversedPt1[1]
                                                           :reversedPt2[0] :reversedPt2[1]];
}

- (CGPoint)gtm_point1 {
    float point[2];
    [self getControlPointAtIndex:1 values:point];
    return CGPointMake(point[0], point[1]);
}

- (CGPoint)gtm_point2 {
    float point[2];
    [self getControlPointAtIndex:2 values:point];
    return CGPointMake(point[0], point[1]);
}

@end
