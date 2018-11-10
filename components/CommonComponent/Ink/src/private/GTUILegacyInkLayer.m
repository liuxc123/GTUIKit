//
//  GTUILegacyInkLayer.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUILegacyInkLayer.h"
#import "GTUILegacyInkLayer+Testing.h"

#import <UIKit/UIKit.h>

static NSString *const GTUILegacyInkLayerBoundedKey = @"GTUILegacyInkLayerBoundedKey";
static NSString *const GTUILegacyInkLayerMaxRippleRadiusKey = @"GTUILegacyInkLayerMaxRippleRadiusKey";
static NSString *const GTUILegacyInkLayerInkColorKey = @"GTUILegacyInkLayerInkColorKey";
static NSString *const GTUILegacyInkLayerSpreadDurationKey = @"GTUILegacyInkLayerSpreadDurationKey";
static NSString *const GTUILegacyInkLayerEvaporateDurationKey =
@"GTUILegacyInkLayerEvaporateDurationKey";
static NSString *const GTUILegacyInkLayerUseCustomInkCenterKey =
@"GTUILegacyInkLayerUseCustomInkCenterKey";
static NSString *const GTUILegacyInkLayerCustomInkCenterKey = @"GTUILegacyInkLayerCustomInkCenterKey";
static NSString *const GTUILegacyInkLayerUseLinearExpansionKey =
@"GTUILegacyInkLayerUseLinearExpansionKey";

static inline CGPoint GTUILegacyInkLayerInterpolatePoint(CGPoint start,
                                                        CGPoint end,
                                                        CGFloat offsetPercent) {
    CGPoint centerOffsetPoint = CGPointMake(start.x + (end.x - start.x) * offsetPercent,
                                            start.y + (end.y - start.y) * offsetPercent);
    return centerOffsetPoint;
}

static inline CGFloat GTUILegacyInkLayerRadiusBounds(CGFloat maxRippleRadius,
                                                    CGFloat inkLayerRectHypotenuse,
                                                    __unused BOOL bounded) {
    if (maxRippleRadius > 0) {
#ifdef GTUI_BOUNDED_INK_IGNORES_MAX_RIPPLE_RADIUS
        if (!bounded) {
            return maxRippleRadius;
        } else {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                NSLog(@"Implementation of GTUIInkView with |GTUIInkStyle| GTUIInkStyleBounded and "
                      @"maxRippleRadius has changed.\n\n"
                      @"GTUIInkStyleBounded ignores maxRippleRadius. "
                      @"Please use |GTUIInkStyle| GTUIInkStyleUnbounded to continue using maxRippleRadius.");
            });
            return inkLayerRectHypotenuse;
        }
#else
        return maxRippleRadius;
#endif
    } else {
        return inkLayerRectHypotenuse;
    }
}

static inline CGFloat GTUILegacyInkLayerRandom() {
    const uint32_t max_value = 10000;
    return (CGFloat)arc4random_uniform(max_value + 1) / max_value;
}

static inline CGPoint GTUILegacyInkLayerRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

static inline CGFloat GTUILegacyInkLayerRectHypotenuse(CGRect rect) {
    return (CGFloat)hypot(CGRectGetWidth(rect), CGRectGetHeight(rect));
}

static NSString *const kInkLayerOpacity = @"opacity";
static NSString *const kInkLayerPosition = @"position";
static NSString *const kInkLayerScale = @"transform.scale";

// State tracking for ink.
typedef NS_ENUM(NSInteger, GTUIInkRippleState) {
    kInkRippleNone,
    kInkRippleSpreading,
    kInkRippleComplete,
    kInkRippleCancelled,
};

#if defined(__IPHONE_10_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0)
@interface GTUILegacyInkLayerRipple () <CAAnimationDelegate>
@end
#endif

@interface GTUILegacyInkLayerRipple ()

@property(nonatomic, assign, getter=isAnimationCleared) BOOL animationCleared;
@property(nonatomic, weak) id<GTUILegacyInkLayerRippleDelegate> animationDelegate;
@property(nonatomic, assign) BOOL bounded;
@property(nonatomic, weak) CALayer *inkLayer;
@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, assign) CGPoint point;
@property(nonatomic, assign) CGRect targetFrame;
@property(nonatomic, assign) GTUIInkRippleState rippleState;
@property(nonatomic, strong) UIColor *color;
@end

@implementation GTUILegacyInkLayerRipple

- (instancetype)init {
    self = [super init];
    if (self) {
        _rippleState = kInkRippleNone;
        _animationCleared = YES;
    }
    return self;
}

- (void)setupRipple {
    self.fillColor = self.color.CGColor;
    CGFloat dim = self.radius * 2.f;
    self.frame = CGRectMake(0, 0, dim, dim);
    UIBezierPath *ripplePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, dim, dim)];
    self.path = ripplePath.CGPath;
}

- (void)enter {
    _rippleState = kInkRippleSpreading;
    [_inkLayer addSublayer:self];
    _animationCleared = NO;
}

- (void)exit {
    if (_rippleState != kInkRippleCancelled) {
        _rippleState = kInkRippleComplete;
    }
}

- (CAKeyframeAnimation *)opacityAnimWithValues:(NSArray<NSNumber *> *)values
                                         times:(NSArray<NSNumber *> *)times {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:kInkLayerOpacity];
    anim.fillMode = kCAFillModeForwards;
    anim.keyTimes = times;
    anim.removedOnCompletion = NO;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.values = values;
    return anim;
}

- (CAKeyframeAnimation *)positionAnimWithPath:(CGPathRef)path
                                     duration:(CGFloat)duration
                               timingFunction:(CAMediaTimingFunction *)timingFunction {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:kInkLayerPosition];
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.path = path;
    anim.removedOnCompletion = NO;
    anim.timingFunction = timingFunction;
    return anim;
}

- (CAKeyframeAnimation *)scaleAnimWithValues:(NSArray<NSNumber *> *)values
                                       times:(NSArray<NSNumber *> *)times {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:kInkLayerScale];
    anim.fillMode = kCAFillModeForwards;
    anim.keyTimes = times;
    anim.removedOnCompletion = NO;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.values = values;
    return anim;
}

- (CAMediaTimingFunction *)logDecelerateEasing {
    // This bezier curve is an approximation of a log curve.
    return [[CAMediaTimingFunction alloc] initWithControlPoints:0.157f:0.72f:0.386f:0.987f];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished {
    if (!self.isAnimationCleared) {
        [self.animationDelegate animationDidStop:anim shapeLayer:self finished:finished];
    }
}

@end

static CGFloat const kInkLayerForegroundBoundedOpacityExitDuration = 0.4f;
static CGFloat const kInkLayerForegroundBoundedPositionExitDuration = 0.3f;
static CGFloat const kInkLayerForegroundBoundedRadiusExitDuration = 0.8f;
static CGFloat const kInkLayerForegroundRadiusGrowthMultiplier = 350.f;
static CGFloat const kInkLayerForegroundUnboundedEnterDelay = 0.08f;
static CGFloat const kInkLayerForegroundUnboundedOpacityEnterDuration = 0.12f;
static CGFloat const kInkLayerForegroundWaveTouchDownAcceleration = 1024.f;
static CGFloat const kInkLayerForegroundWaveTouchUpAcceleration = 3400.f;
static NSString *const kInkLayerForegroundOpacityAnim = @"foregroundOpacityAnim";
static NSString *const kInkLayerForegroundPositionAnim = @"foregroundPositionAnim";
static NSString *const kInkLayerForegroundScaleAnim = @"foregroundScaleAnim";

@interface GTUILegacyInkLayerForegroundRipple ()
@property(nonatomic, assign) BOOL useCustomInkCenter;
@property(nonatomic, assign) CGPoint customInkCenter;
@property(nonatomic, strong) CAKeyframeAnimation *foregroundOpacityAnim;
@property(nonatomic, strong) CAKeyframeAnimation *foregroundPositionAnim;
@property(nonatomic, strong) CAKeyframeAnimation *foregroundScaleAnim;
@end

@implementation GTUILegacyInkLayerForegroundRipple

- (void)setupRipple {
    CGFloat random = GTUILegacyInkLayerRandom();
    self.radius = (CGFloat)(0.9f + random * 0.1f) * kInkLayerForegroundRadiusGrowthMultiplier;
    [super setupRipple];
}

- (void)enterWithCompletion:(void (^)(void))completionBlock {
    [super enter];

    if (self.bounded) {
        _foregroundOpacityAnim = [self opacityAnimWithValues:@[ @0 ] times:@[ @0 ]];
        _foregroundScaleAnim = [self scaleAnimWithValues:@[ @0 ] times:@[ @0 ]];
    } else {
        _foregroundOpacityAnim = [self opacityAnimWithValues:@[ @0, @1 ] times:@[ @0, @1 ]];
        _foregroundOpacityAnim.duration = kInkLayerForegroundUnboundedOpacityEnterDuration;

        CGFloat duration = (CGFloat)sqrt(self.radius / kInkLayerForegroundWaveTouchDownAcceleration);
        _foregroundScaleAnim =
        [self scaleAnimWithValues:@[ @0, @1 ]
                            times:@[ @(kInkLayerForegroundUnboundedEnterDelay), @1 ]];
        _foregroundScaleAnim.duration = duration;

        CGFloat xOffset = self.targetFrame.origin.x - self.inkLayer.frame.origin.x;
        CGFloat yOffset = self.targetFrame.origin.y - self.inkLayer.frame.origin.y;

        UIBezierPath *movePath = [UIBezierPath bezierPath];
        CGPoint startPoint = CGPointMake(self.point.x + xOffset, self.point.y + yOffset);
        CGPoint endPoint = GTUILegacyInkLayerRectGetCenter(self.targetFrame);
        if (self.useCustomInkCenter) {
            endPoint = self.customInkCenter;
        }
        endPoint = CGPointMake(endPoint.x + xOffset, endPoint.y + yOffset);
        [movePath moveToPoint:startPoint];
        [movePath addLineToPoint:endPoint];

        CAMediaTimingFunction *linearTimingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _foregroundPositionAnim = [self positionAnimWithPath:movePath.CGPath
                                                    duration:duration
                                              timingFunction:linearTimingFunction];
        _foregroundPositionAnim.keyTimes = @[ @(kInkLayerForegroundUnboundedEnterDelay), @1 ];
        [self addAnimation:_foregroundPositionAnim forKey:kInkLayerForegroundPositionAnim];
    }

    [CATransaction begin];
    if (completionBlock) {
        __weak GTUILegacyInkLayerForegroundRipple *weakSelf = self;
        [CATransaction setCompletionBlock:^{
            GTUILegacyInkLayerForegroundRipple *strongSelf = weakSelf;
            if (strongSelf.rippleState != kInkRippleCancelled) {
                completionBlock();
            }
        }];
    }
    [self addAnimation:_foregroundOpacityAnim forKey:kInkLayerForegroundOpacityAnim];
    [self addAnimation:_foregroundScaleAnim forKey:kInkLayerForegroundScaleAnim];
    [CATransaction commit];
}

- (void)exit:(BOOL)animated {
    self.rippleState = kInkRippleCancelled;
    [self exit:animated completion:nil];
}

- (void)exit:(BOOL)animated completion:(void (^)(void))completionBlock {
    [super exit];

    if (!animated) {
        [self removeAllAnimations];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.opacity = 0;
        __weak GTUILegacyInkLayerForegroundRipple *weakSelf = self;
        [CATransaction setCompletionBlock:^(void) {
            GTUILegacyInkLayerForegroundRipple *strongSelf = weakSelf;
            [strongSelf removeFromSuperlayer];

            if ([strongSelf.animationDelegate
                 respondsToSelector:@selector(animationDidStop:shapeLayer:finished:)]) {
                [strongSelf.animationDelegate animationDidStop:nil shapeLayer:strongSelf finished:YES];
            }
        }];
        [CATransaction commit];
        return;
    }

    if (self.bounded) {
        _foregroundOpacityAnim.values = @[ @1, @0 ];
        _foregroundOpacityAnim.duration = kInkLayerForegroundBoundedOpacityExitDuration;

        // Bounded ripples move slightly towards the center of the tap target. Unbounded ripples
        // move to the center of the tap target.

        CGFloat xOffset = self.targetFrame.origin.x - self.inkLayer.frame.origin.x;
        CGFloat yOffset = self.targetFrame.origin.y - self.inkLayer.frame.origin.y;

        CGPoint startPoint = CGPointMake(self.point.x + xOffset, self.point.y + yOffset);
        CGPoint endPoint = GTUILegacyInkLayerRectGetCenter(self.targetFrame);
        if (self.useCustomInkCenter) {
            endPoint = self.customInkCenter;
        }
        endPoint = CGPointMake(endPoint.x + xOffset, endPoint.y + yOffset);
        CGPoint centerOffsetPoint = GTUILegacyInkLayerInterpolatePoint(startPoint, endPoint, 0.3f);
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:startPoint];
        [movePath addLineToPoint:centerOffsetPoint];

        _foregroundPositionAnim =
        [self positionAnimWithPath:movePath.CGPath
                          duration:kInkLayerForegroundBoundedPositionExitDuration
                    timingFunction:[self logDecelerateEasing]];
        _foregroundScaleAnim.values = @[ @0, @1 ];
        _foregroundScaleAnim.keyTimes = @[ @0, @1 ];
        _foregroundScaleAnim.duration = kInkLayerForegroundBoundedRadiusExitDuration;
    } else {
        NSNumber *opacityVal = [self.presentationLayer valueForKeyPath:kInkLayerOpacity];
        if (opacityVal == nil) {
            opacityVal = [NSNumber numberWithFloat:0];
        }
        CGFloat adjustedDuration = kInkLayerForegroundBoundedPositionExitDuration;
        CGFloat normOpacityVal = opacityVal.floatValue;
        CGFloat opacityDuration = normOpacityVal / 3.f;
        _foregroundOpacityAnim.values = @[ opacityVal, @0 ];
        _foregroundOpacityAnim.duration = opacityDuration + adjustedDuration;

        NSNumber *scaleVal = [self.presentationLayer valueForKeyPath:kInkLayerScale];
        if (scaleVal == nil) {
            scaleVal = [NSNumber numberWithFloat:0];
        }
        CGFloat unboundedDuration = (CGFloat)sqrt(((1.f - scaleVal.floatValue) * self.radius) /
                                                  (kInkLayerForegroundWaveTouchDownAcceleration +
                                                   kInkLayerForegroundWaveTouchUpAcceleration));
        _foregroundPositionAnim.duration = unboundedDuration + adjustedDuration;
        _foregroundScaleAnim.values = @[ scaleVal, @1 ];
        _foregroundScaleAnim.duration = unboundedDuration + adjustedDuration;
    }

    _foregroundOpacityAnim.keyTimes = @[ @0, @1 ];
    if (_foregroundOpacityAnim.duration < _foregroundScaleAnim.duration) {
        _foregroundScaleAnim.delegate = self;
    } else {
        _foregroundOpacityAnim.delegate = self;
    }

    _foregroundOpacityAnim.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    _foregroundPositionAnim.timingFunction = [self logDecelerateEasing];
    _foregroundScaleAnim.timingFunction = [self logDecelerateEasing];

    [CATransaction begin];
    if (completionBlock) {
        __weak GTUILegacyInkLayerForegroundRipple *weakSelf = self;
        [CATransaction setCompletionBlock:^{
            GTUILegacyInkLayerForegroundRipple *strongSelf = weakSelf;
            if (strongSelf.rippleState != kInkRippleCancelled) {
                completionBlock();
            }
        }];
    }
    [self addAnimation:_foregroundOpacityAnim forKey:kInkLayerForegroundOpacityAnim];
    [self addAnimation:_foregroundPositionAnim forKey:kInkLayerForegroundPositionAnim];
    [self addAnimation:_foregroundScaleAnim forKey:kInkLayerForegroundScaleAnim];
    [CATransaction commit];
}

- (void)removeAllAnimations {
    [super removeAllAnimations];
    _foregroundOpacityAnim = nil;
    _foregroundPositionAnim = nil;
    _foregroundScaleAnim = nil;
    self.animationCleared = YES;
}

@end

static CGFloat const kInkLayerBackgroundOpacityEnterDuration = 0.6f;
static CGFloat const kInkLayerBackgroundBaseOpacityExitDuration = 0.48f;
static CGFloat const kInkLayerBackgroundFastEnterDuration = 0.12f;
static NSString *const kInkLayerBackgroundOpacityAnim = @"backgroundOpacityAnim";

@interface GTUILegacyInkLayerBackgroundRipple ()
@property(nonatomic, strong, nullable) CAKeyframeAnimation *backgroundOpacityAnim;
@end

@implementation GTUILegacyInkLayerBackgroundRipple

- (void)enter {
    [super enter];
    _backgroundOpacityAnim = [self opacityAnimWithValues:@[ @0, @1 ] times:@[ @0, @1 ]];
    _backgroundOpacityAnim.duration = kInkLayerBackgroundOpacityEnterDuration;
    [self addAnimation:_backgroundOpacityAnim forKey:kInkLayerBackgroundOpacityAnim];
}

- (void)exit:(BOOL)animated {
    [super exit];

    if (!animated) {
        [self removeAllAnimations];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.opacity = 0;
        __weak GTUILegacyInkLayerBackgroundRipple *weakSelf = self;
        [CATransaction setCompletionBlock:^(void) {
            GTUILegacyInkLayerBackgroundRipple *strongSelf = weakSelf;
            [strongSelf removeFromSuperlayer];

            if ([strongSelf.animationDelegate
                 respondsToSelector:@selector(animationDidStop:shapeLayer:finished:)]) {
                [strongSelf.animationDelegate animationDidStop:nil shapeLayer:strongSelf finished:YES];
            }
        }];
        [CATransaction commit];
        return;
    }

    NSNumber *opacityVal = [self.presentationLayer valueForKeyPath:kInkLayerOpacity];
    if (opacityVal == nil) {
        opacityVal = [NSNumber numberWithFloat:0];
    }
    CGFloat duration = kInkLayerBackgroundBaseOpacityExitDuration;
    if (self.bounded) {
        // The end (tap release) animation should continue at the opacity level of the start animation.
        CGFloat enterDuration = (1 - opacityVal.floatValue / 1) * kInkLayerBackgroundFastEnterDuration;
        duration += enterDuration;
        _backgroundOpacityAnim = [self opacityAnimWithValues:@[ opacityVal, @1, @0 ]
                                                       times:@[ @0, @(enterDuration / duration), @1 ]];
    } else {
        _backgroundOpacityAnim = [self opacityAnimWithValues:@[ opacityVal, @0 ] times:@[ @0, @1 ]];
    }
    _backgroundOpacityAnim.duration = duration;
    _backgroundOpacityAnim.delegate = self;
    [self addAnimation:_backgroundOpacityAnim forKey:kInkLayerBackgroundOpacityAnim];
}

- (void)removeAllAnimations {
    [super removeAllAnimations];
    _backgroundOpacityAnim = nil;
    self.animationCleared = YES;
}

@end

@interface GTUILegacyInkLayer ()

/**
 Reset the bottom-most ink applied to the layer with a completion handler to be called on completion
 if applicable.

 @param animated Enables the ink ripple fade out animation.
 @param completionBlock Block called after the completion of the animation.
 */
- (void)resetBottomInk:(BOOL)animated completion:(void (^)(void))completionBlock;

/**
 Reset the bottom-most ink applied to the layer with a completion handler to be called on completion
 if applicable.

 @param animated Enables the ink ripple fade out animation.
 @param point Evaporate the ink towards the point.
 @param completionBlock Block called after the completion of the animation.
 */
- (void)resetBottomInk:(BOOL)animated
               toPoint:(CGPoint)point
            completion:(void (^)(void))completionBlock;

@property(nonatomic, strong, nonnull) CAShapeLayer *compositeRipple;
@property(nonatomic, strong, nonnull)
NSMutableArray<GTUILegacyInkLayerForegroundRipple *> *foregroundRipples;
@property(nonatomic, strong, nonnull)
NSMutableArray<GTUILegacyInkLayerBackgroundRipple *> *backgroundRipples;

@end

@implementation GTUILegacyInkLayer

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.masksToBounds = YES;
        _inkColor = [UIColor colorWithWhite:0 alpha:(CGFloat)0.08];
        _bounded = YES;
        _compositeRipple = [CAShapeLayer layer];
        _foregroundRipples = [NSMutableArray array];
        _backgroundRipples = [NSMutableArray array];
        [self addSublayer:_compositeRipple];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        if ([aDecoder containsValueForKey:GTUILegacyInkLayerBoundedKey]) {
            _bounded = [aDecoder decodeBoolForKey:GTUILegacyInkLayerBoundedKey];
        } else {
            _bounded = YES;
        }
        if ([aDecoder containsValueForKey:GTUILegacyInkLayerMaxRippleRadiusKey]) {
            _maxRippleRadius = (CGFloat)[aDecoder decodeDoubleForKey:GTUILegacyInkLayerMaxRippleRadiusKey];
        }
        if ([aDecoder containsValueForKey:GTUILegacyInkLayerInkColorKey]) {
            _inkColor = [aDecoder decodeObjectOfClass:[UIColor class]
                                               forKey:GTUILegacyInkLayerInkColorKey];
        } else {
            _inkColor = [UIColor colorWithWhite:0 alpha:(CGFloat)0.08];
        }
        if ([aDecoder containsValueForKey:GTUILegacyInkLayerSpreadDurationKey]) {
            _spreadDuration = [aDecoder decodeDoubleForKey:GTUILegacyInkLayerSpreadDurationKey];
        }
        if ([aDecoder containsValueForKey:GTUILegacyInkLayerEvaporateDurationKey]) {
            _evaporateDuration = [aDecoder decodeDoubleForKey:GTUILegacyInkLayerEvaporateDurationKey];
        }
        if ([aDecoder containsValueForKey:GTUILegacyInkLayerUseCustomInkCenterKey]) {
            _useCustomInkCenter = [aDecoder decodeBoolForKey:GTUILegacyInkLayerUseCustomInkCenterKey];
        }
        if ([aDecoder containsValueForKey:GTUILegacyInkLayerCustomInkCenterKey]) {
            _customInkCenter = [aDecoder decodeCGPointForKey:GTUILegacyInkLayerCustomInkCenterKey];
        }
        if ([aDecoder containsValueForKey:GTUILegacyInkLayerUseLinearExpansionKey]) {
            _userLinearExpansion = [aDecoder decodeBoolForKey:GTUILegacyInkLayerUseLinearExpansionKey];
        }

        // Discard any sublayers, which should be the composite ripple and any active ripples
        if (self.sublayers.count > 0) {
            NSArray<CALayer *> *sublayers = [self.sublayers copy];
            for (CALayer *sublayer in sublayers) {
                [sublayer removeFromSuperlayer];
            }
        }
        _compositeRipple = [CAShapeLayer layer];
        _foregroundRipples = [NSMutableArray array];
        _backgroundRipples = [NSMutableArray array];
        [self addSublayer:_compositeRipple];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeBool:self.bounded forKey:GTUILegacyInkLayerBoundedKey];
    [aCoder encodeDouble:self.maxRippleRadius forKey:GTUILegacyInkLayerMaxRippleRadiusKey];
    [aCoder encodeObject:self.inkColor forKey:GTUILegacyInkLayerInkColorKey];
    [aCoder encodeDouble:self.spreadDuration forKey:GTUILegacyInkLayerSpreadDurationKey];
    [aCoder encodeDouble:self.evaporateDuration forKey:GTUILegacyInkLayerEvaporateDurationKey];
    [aCoder encodeBool:self.useCustomInkCenter forKey:GTUILegacyInkLayerUseCustomInkCenterKey];
    [aCoder encodeCGPoint:self.customInkCenter forKey:GTUILegacyInkLayerCustomInkCenterKey];
    [aCoder encodeBool:self.userLinearExpansion forKey:GTUILegacyInkLayerUseLinearExpansionKey];
}

- (void)layoutSublayers {
    [super layoutSublayers];
    CGFloat radius = GTUILegacyInkLayerRadiusBounds(_maxRippleRadius,
                                                   GTUILegacyInkLayerRectHypotenuse(self.bounds) / 2.f, _bounded);

    CGRect rippleFrame =
    CGRectMake(-(radius * 2.f - self.bounds.size.width) / 2.f,
               -(radius * 2.f - self.bounds.size.height) / 2.f, radius * 2.f, radius * 2.f);
    _compositeRipple.frame = rippleFrame;
    CGRect rippleBounds = CGRectMake(0, 0, radius * 2.f, radius * 2.f);
    CAShapeLayer *rippleMaskLayer = [CAShapeLayer layer];
    UIBezierPath *ripplePath = [UIBezierPath bezierPathWithOvalInRect:rippleBounds];
    rippleMaskLayer.path = ripplePath.CGPath;
    _compositeRipple.mask = rippleMaskLayer;
}

- (void)resetAllInk:(BOOL)animated {
    for (GTUILegacyInkLayerForegroundRipple *foregroundRipple in self.foregroundRipples) {
        [foregroundRipple exit:animated];
    }
    for (GTUILegacyInkLayerBackgroundRipple *backgroundRipple in self.backgroundRipples) {
        [backgroundRipple exit:animated];
    }
}

- (void)resetBottomInk:(BOOL)animated completion:(void (^)(void))completionBlock {
    if (self.foregroundRipples.count > 0) {
        [[self.foregroundRipples objectAtIndex:(self.foregroundRipples.count - 1)]
         exit:animated
         completion:completionBlock];
    }
    if (self.backgroundRipples.count > 0) {
        [[self.backgroundRipples objectAtIndex:(self.backgroundRipples.count - 1)] exit:animated];
    }
}

- (void)resetBottomInk:(BOOL)animated
               toPoint:(CGPoint)point
            completion:(void (^)(void))completionBlock {
    if (self.foregroundRipples.count > 0) {
        GTUILegacyInkLayerForegroundRipple *foregroundRipple =
        [self.foregroundRipples objectAtIndex:(self.foregroundRipples.count - 1)];
        foregroundRipple.point = point;
        [foregroundRipple exit:animated completion:completionBlock];
    }
    if (self.backgroundRipples.count > 0) {
        [[self.backgroundRipples objectAtIndex:(self.backgroundRipples.count - 1)] exit:animated];
    }
}

#pragma mark - Properties

- (void)spreadFromPoint:(CGPoint)point completion:(void (^)(void))completionBlock {
    // Create a mask layer before drawing the ink using the superlayer's shadowPath
    // if it exists. This helps the FAB when it is not rectangular.
    if (self.masksToBounds && self.superlayer.shadowPath) {
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.path = self.superlayer.shadowPath;
        mask.fillColor = [UIColor whiteColor].CGColor;
        self.mask = mask;
    } else {
        self.mask = nil;
    }

    CGFloat radius = GTUILegacyInkLayerRadiusBounds(_maxRippleRadius,
                                                   GTUILegacyInkLayerRectHypotenuse(self.bounds) / 2.f,
                                                   _bounded);

    GTUILegacyInkLayerBackgroundRipple *backgroundRipple =
    [[GTUILegacyInkLayerBackgroundRipple alloc] init];
    backgroundRipple.inkLayer = _compositeRipple;
    backgroundRipple.targetFrame = self.bounds;
    backgroundRipple.point = point;
    backgroundRipple.color = self.inkColor;
    backgroundRipple.radius = radius;
    backgroundRipple.bounded = self.bounded;
    backgroundRipple.animationDelegate = self;
    [backgroundRipple setupRipple];

    GTUILegacyInkLayerForegroundRipple *foregroundRipple =
    [[GTUILegacyInkLayerForegroundRipple alloc] init];
    foregroundRipple.inkLayer = _compositeRipple;
    foregroundRipple.targetFrame = self.bounds;
    foregroundRipple.point = point;
    foregroundRipple.color = self.inkColor;
    foregroundRipple.radius = radius;
    foregroundRipple.bounded = self.bounded;
    foregroundRipple.animationDelegate = self;
    foregroundRipple.useCustomInkCenter = self.useCustomInkCenter;
    foregroundRipple.customInkCenter = self.customInkCenter;
    [foregroundRipple setupRipple];

    [backgroundRipple enter];
    [self.backgroundRipples addObject:backgroundRipple];
    [foregroundRipple enterWithCompletion:completionBlock];
    [self.foregroundRipples addObject:foregroundRipple];
}

- (void)evaporateWithCompletion:(void (^)(void))completionBlock {
    [self resetBottomInk:YES completion:completionBlock];
}

- (void)evaporateToPoint:(CGPoint)point completion:(void (^)(void))completionBlock {
    [self resetBottomInk:YES toPoint:point completion:completionBlock];
}

#pragma mark - GTUILegacyInkLayerRippleDelegate

- (void)animationDidStop:(__unused CAAnimation *)anim
              shapeLayer:(CAShapeLayer *)shapeLayer
                finished:(__unused BOOL)finished {
    // Even when the ripple is "exited" without animation, we need to remove it from compositeRipple
    [shapeLayer removeFromSuperlayer];
    [shapeLayer removeAllAnimations];

    if ([shapeLayer isMemberOfClass:[GTUILegacyInkLayerForegroundRipple class]]) {
        [self.foregroundRipples removeObject:(GTUILegacyInkLayerForegroundRipple *)shapeLayer];
    } else if ([shapeLayer isMemberOfClass:[GTUILegacyInkLayerBackgroundRipple class]]) {
        [self.backgroundRipples removeObject:(GTUILegacyInkLayerBackgroundRipple *)shapeLayer];
    }
}

@end

