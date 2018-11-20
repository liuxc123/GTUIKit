//
//  CAMediaTimingFunction+GTAnimationTiming.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "CAMediaTimingFunction+GTUIAnimationTiming.h"

@implementation CAMediaTimingFunction (GTUIAnimationTiming)


+ (CAMediaTimingFunction *)gtui_functionWithType:(GTUIAnimationTimingFunction)type {
    switch (type) {
        case GTUIAnimationTimingFunctionStandard:
            return [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f:0.0f:0.2f:1.0f];
        case GTUIAnimationTimingFunctionDeceleration:
            return [[CAMediaTimingFunction alloc] initWithControlPoints:0.0f:0.0f:0.2f:1.0f];
        case GTUIAnimationTimingFunctionAcceleration:
            return [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f:0.0f:1.0f:1.0f];
        case GTUIAnimationTimingFunctionSharp:
            return [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f:0.0f:0.6f:1.0f];
    }
    NSAssert(NO, @"Invalid GTUIAnimationTimingFunction value %i.", (int)type);
    // Reasonable default to use in Release mode for garbage input.
    return nil;
}


@end
