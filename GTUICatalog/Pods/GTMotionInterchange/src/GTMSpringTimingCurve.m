//
//  GTMSpringTimingCurve.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMSpringTimingCurve.h"

@implementation GTMSpringTimingCurve

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithMass:(CGFloat)mass tension:(CGFloat)tension friction:(CGFloat)friction {
    return [self initWithMass:mass tension:tension friction:friction initialVelocity:0];
}

- (instancetype)initWithMass:(CGFloat)mass
                     tension:(CGFloat)tension
                    friction:(CGFloat)friction
             initialVelocity:(CGFloat)initialVelocity {
    self = [super init];
    if (self) {
        _mass = mass;
        _tension = tension;
        _friction = friction;
        _initialVelocity = initialVelocity;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] initWithMass:self.mass
                                                   tension:self.tension
                                                  friction:self.friction
                                           initialVelocity:self.initialVelocity];;
}

#pragma mark - Private

@end
