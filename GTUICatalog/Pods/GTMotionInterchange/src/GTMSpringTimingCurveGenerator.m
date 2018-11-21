//
//  GTMSpringTimingCurveGenerator.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMSpringTimingCurveGenerator.h"

#import "GTMSpringTimingCurve.h"

#import <UIKit/UIKit.h>

@implementation GTMSpringTimingCurveGenerator

- (instancetype)initWithDuration:(NSTimeInterval)duration dampingRatio:(CGFloat)dampingRatio {
    return [self initWithDuration:duration dampingRatio:dampingRatio initialVelocity:0];
}

- (nonnull instancetype)initWithDuration:(NSTimeInterval)duration
                            dampingRatio:(CGFloat)dampingRatio
                         initialVelocity:(CGFloat)initialVelocity {
    self = [super init];
    if (self) {
        _duration = duration;
        _dampingRatio = dampingRatio;
        _initialVelocity = initialVelocity;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] initWithDuration:self.duration
                                                  dampingRatio:self.dampingRatio
                                               initialVelocity:self.initialVelocity];
}

- (GTMSpringTimingCurve *)springTimingCurve {
    UIView *view = [[UIView alloc] init];
    [UIView animateWithDuration:self.duration
                          delay:0
         usingSpringWithDamping:self.dampingRatio
          initialSpringVelocity:self.initialVelocity
                        options:0
                     animations:^{
                         view.center = CGPointMake(100, 100);
                     } completion:nil];

    NSString *animationKey = [view.layer.animationKeys firstObject];
    NSAssert(animationKey != nil, @"Unable to extract animation timing curve: no animation found.");
#pragma clang diagnostic push
    // CASpringAnimation is a private API on iOS 8 - we're able to make use of it because we're
    // linking against the public API on iOS 9+.
#pragma clang diagnostic ignored "-Wpartial-availability"
    CASpringAnimation *springAnimation =
    (CASpringAnimation *)[view.layer animationForKey:animationKey];
    NSAssert([springAnimation isKindOfClass:[CASpringAnimation class]],
             @"Unable to extract animation timing curve: unexpected animation type.");
#pragma clang diagnostic pop

    return [[GTMSpringTimingCurve alloc] initWithMass:springAnimation.mass
                                              tension:springAnimation.stiffness
                                             friction:springAnimation.damping
                                      initialVelocity:self.initialVelocity];
}

@end

