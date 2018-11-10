//
//  GTUIInkLayer.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUIInkLayer.h"
#import "GTMath.h"

static NSString *const GTUIInkLayerAnimationDelegateClassNameKey = @"GTUIInkLayerAnimationDelegateClassNameKey";
static NSString *const GTUIInkLayerAnimationDelegateKey = @"GTUIInkLayerAnimationDelegateKey";
static NSString *const GTUIInkLayerEndAnimationDelayKey = @"GTUIInkLayerEndAnimationDelayKey";
static NSString *const GTUIInkLayerFinalRadiusKey = @"GTUIInkLayerFinalRadiusKey";
static NSString *const GTUIInkLayerInitialRadiusKey = @"GTUIInkLayerInitialRadiusKey";
static NSString *const GTUIInkLayerMaxRippleRadiusKey = @"GTUIInkLayerMaxRippleRadiusKey";
static NSString *const GTUIInkLayerInkColorKey = @"GTUIInkLayerInkColorKey";

static const CGFloat GTUIInkLayerCommonDuration = 0.083f;
static const CGFloat GTUIInkLayerEndFadeOutDuration = 0.15f;
static const CGFloat GTUIInkLayerStartScalePositionDuration = 0.333f;
static const CGFloat GTUIInkLayerStartFadeHalfDuration = 0.167f;
static const CGFloat GTUIInkLayerStartFadeHalfBeginTimeFadeOutDuration = 0.25f;

static const CGFloat GTUIInkLayerScaleStartMin = 0.2f;
static const CGFloat GTUIInkLayerScaleStartMax = 0.6f;
static const CGFloat GTUIInkLayerScaleDivisor = 300.f;

static NSString *const GTUIInkLayerOpacityString = @"opacity";
static NSString *const GTUIInkLayerPositionString = @"position";
static NSString *const GTUIInkLayerScaleString = @"transform.scale";

@implementation GTUIInkLayer

+ (BOOL)supportsSecureCoding {
    return YES;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _inkColor = [UIColor colorWithWhite:0 alpha:(CGFloat)0.08];
    }
    return self;
}


- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        _endAnimationDelay = 0;
        _finalRadius = 0;
        _initialRadius = 0;
        _inkColor = [UIColor colorWithWhite:0 alpha:(CGFloat)0.08];
        _startAnimationActive = NO;
        if ([layer isKindOfClass:[GTUIInkLayer class]]) {
            GTUIInkLayer *inkLayer = (GTUIInkLayer *)layer;
            _endAnimationDelay = inkLayer.endAnimationDelay;
            _finalRadius = inkLayer.finalRadius;
            _initialRadius = inkLayer.initialRadius;
            _maxRippleRadius = inkLayer.maxRippleRadius;
            _inkColor = inkLayer.inkColor;
            _startAnimationActive = NO;
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        NSString *delegateClassName;
        if ([aDecoder containsValueForKey:GTUIInkLayerAnimationDelegateClassNameKey]) {
            delegateClassName = [aDecoder decodeObjectOfClass:[NSString class]
                                                       forKey:GTUIInkLayerAnimationDelegateClassNameKey];
        }
        if (delegateClassName.length > 0 &&
            [aDecoder containsValueForKey:GTUIInkLayerAnimationDelegateKey]) {
            _animationDelegate = [aDecoder decodeObjectOfClass:NSClassFromString(delegateClassName)
                                                        forKey:GTUIInkLayerAnimationDelegateKey];
        }
        if ([aDecoder containsValueForKey:GTUIInkLayerInkColorKey]) {
            _inkColor = [aDecoder decodeObjectOfClass:[UIColor class] forKey:GTUIInkLayerInkColorKey];
        } else {
            _inkColor = [UIColor colorWithWhite:0 alpha:(CGFloat)0.08];
        }
        if ([aDecoder containsValueForKey:GTUIInkLayerEndAnimationDelayKey]) {
            _endAnimationDelay = (CGFloat)[aDecoder decodeDoubleForKey:GTUIInkLayerEndAnimationDelayKey];
        }
        if ([aDecoder containsValueForKey:GTUIInkLayerFinalRadiusKey]) {
            _finalRadius = (CGFloat)[aDecoder decodeDoubleForKey:GTUIInkLayerFinalRadiusKey];
        }
        if ([aDecoder containsValueForKey:GTUIInkLayerInitialRadiusKey]) {
            _initialRadius = (CGFloat)[aDecoder decodeDoubleForKey:GTUIInkLayerInitialRadiusKey];
        }
        if ([aDecoder containsValueForKey:GTUIInkLayerMaxRippleRadiusKey]) {
            _maxRippleRadius = (CGFloat)[aDecoder decodeDoubleForKey:GTUIInkLayerMaxRippleRadiusKey];
        }
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];

    if (self.animationDelegate && [self.animationDelegate conformsToProtocol:@protocol(NSCoding)]) {
        [aCoder encodeObject:NSStringFromClass([self.animationDelegate class])
                      forKey:GTUIInkLayerAnimationDelegateClassNameKey];
        [aCoder encodeObject:self.animationDelegate forKey:GTUIInkLayerAnimationDelegateKey];
    }
    [aCoder encodeDouble:self.endAnimationDelay forKey:GTUIInkLayerEndAnimationDelayKey];
    [aCoder encodeDouble:self.finalRadius forKey:GTUIInkLayerFinalRadiusKey];
    [aCoder encodeDouble:self.initialRadius forKey:GTUIInkLayerInitialRadiusKey];
    [aCoder encodeDouble:self.maxRippleRadius forKey:GTUIInkLayerMaxRippleRadiusKey];
    [aCoder encodeObject:self.inkColor forKey:GTUIInkLayerInkColorKey];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setRadiiWithRect:self.bounds];
}

- (void)setRadiiWithRect:(CGRect)rect {
    self.initialRadius = (CGFloat)(GTUIHypot(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2 * 0.6f);
    self.finalRadius = (CGFloat)(GTUIHypot(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2 + 10.f);
}

- (void)startAnimationAtPoint:(CGPoint)point {
    [self startInkAtPoint:point animated:YES];
}

- (void)startInkAtPoint:(CGPoint)point animated:(BOOL)animated {
    CGFloat radius = self.finalRadius;
    if (self.maxRippleRadius > 0) {
        radius = self.maxRippleRadius;
    }
    CGRect ovalRect = CGRectMake(CGRectGetWidth(self.bounds) / 2 - radius,
                                 CGRectGetHeight(self.bounds) / 2 - radius,
                                 radius * 2,
                                 radius * 2);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    self.path = circlePath.CGPath;
    self.fillColor = self.inkColor.CGColor;
    if (!animated) {
        self.opacity = 1;
        self.position = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    } else {
        self.opacity = 0;
        self.position = point;
        _startAnimationActive = YES;

        CAMediaTimingFunction *materialTimingFunction =
        [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f:0:0.2f:1.f];

        CGFloat scaleStart =
        MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / GTUIInkLayerScaleDivisor;
        if (scaleStart < GTUIInkLayerScaleStartMin) {
            scaleStart = GTUIInkLayerScaleStartMin;
        } else if (scaleStart > GTUIInkLayerScaleStartMax) {
            scaleStart = GTUIInkLayerScaleStartMax;
        }

        CABasicAnimation *scaleAnim = [[CABasicAnimation alloc] init];
        scaleAnim.keyPath = GTUIInkLayerScaleString;
        scaleAnim.fromValue = @(scaleStart);
        scaleAnim.toValue = @1.0f;
        scaleAnim.duration = GTUIInkLayerStartScalePositionDuration;
        scaleAnim.beginTime = GTUIInkLayerCommonDuration;
        scaleAnim.timingFunction = materialTimingFunction;
        scaleAnim.fillMode = kCAFillModeForwards;
        scaleAnim.removedOnCompletion = NO;

        UIBezierPath *centerPath = [UIBezierPath bezierPath];
        CGPoint startPoint = point;
        CGPoint endPoint = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
        [centerPath moveToPoint:startPoint];
        [centerPath addLineToPoint:endPoint];
        [centerPath closePath];

        CAKeyframeAnimation *positionAnim = [[CAKeyframeAnimation alloc] init];
        positionAnim.keyPath = GTUIInkLayerPositionString;
        positionAnim.path = centerPath.CGPath;
        positionAnim.keyTimes = @[ @0, @1.0f ];
        positionAnim.values = @[ @0, @1.0f ];
        positionAnim.duration = GTUIInkLayerStartScalePositionDuration;
        positionAnim.beginTime = GTUIInkLayerCommonDuration;
        positionAnim.timingFunction = materialTimingFunction;
        positionAnim.fillMode = kCAFillModeForwards;
        positionAnim.removedOnCompletion = NO;

        CABasicAnimation *fadeInAnim = [[CABasicAnimation alloc] init];
        fadeInAnim.keyPath = GTUIInkLayerOpacityString;
        fadeInAnim.fromValue = @0;
        fadeInAnim.toValue = @1.0f;
        fadeInAnim.duration = GTUIInkLayerCommonDuration;
        fadeInAnim.beginTime = GTUIInkLayerCommonDuration;
        fadeInAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        fadeInAnim.fillMode = kCAFillModeForwards;
        fadeInAnim.removedOnCompletion = NO;

        [CATransaction begin];
        CAAnimationGroup *animGroup = [[CAAnimationGroup alloc] init];
        animGroup.animations = @[ scaleAnim, positionAnim, fadeInAnim ];
        animGroup.duration = GTUIInkLayerStartScalePositionDuration;
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.removedOnCompletion = NO;
        [CATransaction setCompletionBlock:^{
            self->_startAnimationActive = NO;
        }];
        [self addAnimation:animGroup forKey:nil];
        [CATransaction commit];
    }
    if ([self.animationDelegate respondsToSelector:@selector(inkLayerAnimationDidStart:)]) {
        [self.animationDelegate inkLayerAnimationDidStart:self];
    }
}

- (void)changeAnimationAtPoint:(CGPoint)point {
    CGFloat animationDelay = 0;
    if (self.startAnimationActive) {
        animationDelay = GTUIInkLayerStartFadeHalfBeginTimeFadeOutDuration +
        GTUIInkLayerStartFadeHalfDuration;
    }

    BOOL viewContainsPoint = CGRectContainsPoint(self.bounds, point) ? YES : NO;
    CGFloat currOpacity = self.presentationLayer.opacity;
    CGFloat updatedOpacity = 0;
    if (viewContainsPoint) {
        updatedOpacity = 1.0f;
    }

    CABasicAnimation *changeAnim = [[CABasicAnimation alloc] init];
    changeAnim.keyPath = GTUIInkLayerOpacityString;
    changeAnim.fromValue = @(currOpacity);
    changeAnim.toValue = @(updatedOpacity);
    changeAnim.duration = GTUIInkLayerCommonDuration;
    changeAnim.beginTime = [self convertTime:(CACurrentMediaTime() + animationDelay) fromLayer:nil];
    changeAnim.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    changeAnim.fillMode = kCAFillModeForwards;
    changeAnim.removedOnCompletion = NO;
    [self addAnimation:changeAnim forKey:nil];
}

- (void)endAnimationAtPoint:(CGPoint)point {
    [self endInkAtPoint:point animated:YES];
}

- (void)endInkAtPoint:(CGPoint)point animated:(BOOL)animated {
    if (self.startAnimationActive) {
        self.endAnimationDelay = GTUIInkLayerStartFadeHalfBeginTimeFadeOutDuration;
    }

    CGFloat opacity = 1.0f;
    BOOL viewContainsPoint = CGRectContainsPoint(self.bounds, point) ? YES : NO;
    if (!viewContainsPoint) {
        opacity = 0;
    }

    if (!animated) {
        self.opacity = 0;
        if ([self.animationDelegate respondsToSelector:@selector(inkLayerAnimationDidEnd:)]) {
            [self.animationDelegate inkLayerAnimationDidEnd:self];
        }
        [self removeFromSuperlayer];
    } else {
        [CATransaction begin];
        CABasicAnimation *fadeOutAnim = [[CABasicAnimation alloc] init];
        fadeOutAnim.keyPath = GTUIInkLayerOpacityString;
        fadeOutAnim.fromValue = @(opacity);
        fadeOutAnim.toValue = @0;
        fadeOutAnim.duration = GTUIInkLayerEndFadeOutDuration;
        fadeOutAnim.beginTime = [self convertTime:(CACurrentMediaTime() + self.endAnimationDelay)
                                        fromLayer:nil];
        fadeOutAnim.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        fadeOutAnim.fillMode = kCAFillModeForwards;
        fadeOutAnim.removedOnCompletion = NO;
        [CATransaction setCompletionBlock:^{
            if ([self.animationDelegate respondsToSelector:@selector(inkLayerAnimationDidEnd:)]) {
                [self.animationDelegate inkLayerAnimationDidEnd:self];
            }
            [self removeFromSuperlayer];
        }];
        [self addAnimation:fadeOutAnim forKey:nil];
        [CATransaction commit];
    }
}


@end
