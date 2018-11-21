//
//  GTUIProgressViewMotionSpec.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUIProgressViewMotionSpec.h"

@implementation GTUIProgressViewMotionSpec

+ (GTMMotionTiming)willChangeProgress {
    return (GTMMotionTiming){
        .duration = 0.250, .curve = GTMMotionCurveMakeBezier(0, 0, 1, 1),
    };
}

+ (GTMMotionTiming)willChangeHidden {
    return (GTMMotionTiming){
        .duration = 0.250, .curve = GTMMotionCurveMakeBezier(0, 0, 1, 1),
    };
}

@end
