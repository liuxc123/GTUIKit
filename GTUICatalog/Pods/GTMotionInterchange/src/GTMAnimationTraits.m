//
//  GTMAnimationTraits.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMAnimationTraits.h"

#import "CAMediaTimingFunction+GTMTimingCurve.h"
#import "GTMRepetition.h"
#import "GTMRepetitionOverTime.h"
#import "GTMSpringTimingCurve.h"

@implementation GTMAnimationTraits

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (nonnull instancetype)initWithDuration:(NSTimeInterval)duration {
    return [self initWithDelay:0 duration:duration];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration
                  animationCurve:(UIViewAnimationCurve)animationCurve {
    return [self initWithDelay:0 duration:duration animationCurve:animationCurve];
}

- (instancetype)initWithDelay:(NSTimeInterval)delay duration:(NSTimeInterval)duration {
    return [self initWithDelay:delay duration:duration animationCurve:UIViewAnimationCurveEaseInOut];
}

- (instancetype)initWithDelay:(NSTimeInterval)delay
                     duration:(NSTimeInterval)duration
               animationCurve:(UIViewAnimationCurve)animationCurve {
    CAMediaTimingFunction *timingCurve;
    switch (animationCurve) {
        case UIViewAnimationCurveEaseInOut:
            timingCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            break;
        case UIViewAnimationCurveEaseIn:
            timingCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            break;
        case UIViewAnimationCurveEaseOut:
            timingCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            break;
        case UIViewAnimationCurveLinear:
            timingCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            break;
    }
    return [self initWithDelay:delay duration:duration timingCurve:timingCurve];
}

- (instancetype)initWithDelay:(NSTimeInterval)delay
                     duration:(NSTimeInterval)duration
                  timingCurve:(id<GTMTimingCurve>)timingCurve {
    return [self initWithDelay:delay duration:duration timingCurve:timingCurve repetition:nil];
}

- (instancetype)initWithDelay:(NSTimeInterval)delay
                     duration:(NSTimeInterval)duration
                  timingCurve:(id<GTMTimingCurve>)timingCurve
                   repetition:(id<GTMRepetitionTraits>)repetition {
    self = [super init];
    if (self) {
        _duration = duration;
        _delay = delay;
        _timingCurve = timingCurve;
        _repetition = repetition;
    }
    return self;
}

- (nonnull instancetype)initWithMotionTiming:(GTMMotionTiming)timing {
    id<GTMTimingCurve> timingCurve;
    switch (timing.curve.type) {
        case GTMMotionCurveTypeInstant:
            timingCurve = nil;
            break;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case GTMMotionCurveTypeDefault:
#pragma clang diagnostic pop
        case GTMMotionCurveTypeBezier:
            timingCurve = [CAMediaTimingFunction functionWithControlPoints:(float)timing.curve.data[0]
                                                                          :(float)timing.curve.data[1]
                                                                          :(float)timing.curve.data[2]
                                                                          :(float)timing.curve.data[3]];
            break;
        case GTMMotionCurveTypeSpring: {
            CGFloat *data = timing.curve.data;
            timingCurve =
            [[GTMSpringTimingCurve alloc] initWithMass:data[GTMSpringMotionCurveDataIndexMass]
                                               tension:data[GTMSpringMotionCurveDataIndexTension]
                                              friction:data[GTMSpringMotionCurveDataIndexFriction]
                                       initialVelocity:data[GTMSpringMotionCurveDataIndexInitialVelocity]];
            break;
        }
    }
    id<GTMRepetitionTraits> repetition;
    switch (timing.repetition.type) {
        case GTMMotionRepetitionTypeNone:
            repetition = nil;
            break;

        case GTMMotionRepetitionTypeCount:
            repetition = [[GTMRepetition alloc] initWithNumberOfRepetitions:timing.repetition.amount
                                                               autoreverses:timing.repetition.autoreverses];
            break;
        case GTMMotionRepetitionTypeDuration:
            repetition = [[GTMRepetitionOverTime alloc] initWithDuration:timing.repetition.amount
                                                            autoreverses:timing.repetition.autoreverses];
            break;
    }
    return [self initWithDelay:timing.delay
                      duration:timing.duration
                   timingCurve:timingCurve
                    repetition:repetition];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithDelay:self.delay
                                      duration:self.duration
                                   timingCurve:[self.timingCurve copyWithZone:zone]
                                    repetition:[self.repetition copyWithZone:zone]];
}

@end

@implementation GTMAnimationTraits (SystemTraits)

+ (GTMAnimationTraits *)systemModalMovement {
    GTMSpringTimingCurve *timingCurve = [[GTMSpringTimingCurve alloc] initWithMass:3
                                                                           tension:1000
                                                                          friction:500];
    return [[GTMAnimationTraits alloc] initWithDelay:0 duration:0.500 timingCurve:timingCurve];
}

@end


