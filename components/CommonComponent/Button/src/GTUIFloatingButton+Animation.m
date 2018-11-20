//
//  GTUIFloatingButton+Animation.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUIFloatingButton+Animation.h"

#if TARGET_IPHONE_SIMULATOR
float UIAnimationDragCoefficient(void);  // Private API for simulator animation speed
#endif

static NSString *const kGTUIFloatingButtonTransformKey = @"kGTUIFloatingButtonTransformKey";
static NSString *const kGTUIFloatingButtonOpacityKey = @"kGTUIFloatingButtonOpacityKey";

// By using a power of 2 (2^-12), we can reduce rounding errors during transform multiplication
static const CGFloat kGTUIFloatingButtonTransformScale = (CGFloat)0.000244140625;

static const NSTimeInterval kGTUIFloatingButtonEnterDuration = 0.270f;
static const NSTimeInterval kGTUIFloatingButtonExitDuration = 0.180f;

static const NSTimeInterval kGTUIFloatingButtonEnterIconDuration = 0.180f;
static const NSTimeInterval kGTUIFloatingButtonEnterIconOffset = 0.090f;
static const NSTimeInterval kGTUIFloatingButtonExitIconDuration = 0.135f;
static const NSTimeInterval kGTUIFloatingButtonExitIconOffset = 0.000f;

static const NSTimeInterval kGTUIFloatingButtonOpacityDuration = 0.015f;
static const NSTimeInterval kGTUIFloatingButtonOpacityEnterOffset = 0.030f;
static const NSTimeInterval kGTUIFloatingButtonOpacityExitOffset = 0.150f;

@implementation GTUIFloatingButton (Animation)





+ (CATransform3D)collapseTransform {
    return CATransform3DMakeScale(kGTUIFloatingButtonTransformScale, kGTUIFloatingButtonTransformScale,
                                  1);
}

+ (CATransform3D)expandTransform {
    return CATransform3DInvert([GTUIFloatingButton collapseTransform]);
}

+ (CABasicAnimation *)animationWithKeypath:(nonnull NSString *)keyPath
                                   toValue:(nonnull id)toValue
                                 fromValue:(nullable id)fromValue
                            timingFunction:(nonnull CAMediaTimingFunction *)timingFunction
                                  fillMode:(nonnull NSString *)fillMode
                                  duration:(NSTimeInterval)duration
                               beginOffset:(NSTimeInterval)beginOffset {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.toValue = toValue;
    animation.fromValue = fromValue;
    animation.timingFunction = timingFunction;
    animation.fillMode = fillMode;
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    if (fabs(beginOffset) > DBL_EPSILON) {
        animation.beginTime = CACurrentMediaTime() + beginOffset;
    }

#if TARGET_IPHONE_SIMULATOR
    animation.duration *= [self fab_dragCoefficient];
    if (fabs(beginOffset) > DBL_EPSILON) {
        animation.beginTime = CACurrentMediaTime() + (beginOffset * [self fab_dragCoefficient]);
    }
#endif

    return animation;
}

#if TARGET_IPHONE_SIMULATOR
+ (float)fab_dragCoefficient {
    if (&UIAnimationDragCoefficient) {
        float coeff = UIAnimationDragCoefficient();
        if (coeff > 1) {
            return coeff;
        }
    }
    return 1;
}
#endif

- (void)expand:(BOOL)animated completion:(void (^_Nullable)(void))completion {
    void (^expandActions)(void) = ^{
        self.layer.transform =
        CATransform3DConcat(self.layer.transform, [GTUIFloatingButton expandTransform]);
        self.layer.opacity = 1;
        self.imageView.layer.transform =
        CATransform3DConcat(self.imageView.layer.transform, [GTUIFloatingButton expandTransform]);
        [self.layer removeAnimationForKey:kGTUIFloatingButtonTransformKey];
        [self.layer removeAnimationForKey:kGTUIFloatingButtonOpacityKey];
        [self.imageView.layer removeAnimationForKey:kGTUIFloatingButtonTransformKey];
        if (completion) {
            completion();
        }
    };

    if (animated) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:expandActions];

        CABasicAnimation *overallScaleAnimation = [GTUIFloatingButton
                                                   animationWithKeypath:@"transform"
                                                   toValue:[NSValue
                                                            valueWithCATransform3D:CATransform3DConcat(
                                                                                                       self.layer.transform,
                                                                                                       [GTUIFloatingButton expandTransform])]
                                                   fromValue:nil
                                                   timingFunction:[[CAMediaTimingFunction alloc]
                                                                   initWithControlPoints:0.0f:0.0f:0.2f:1.0f]
                                                   fillMode:kCAFillModeForwards
                                                   duration:kGTUIFloatingButtonEnterDuration
                                                   beginOffset:0];
        [self.layer addAnimation:overallScaleAnimation forKey:kGTUIFloatingButtonTransformKey];

        CALayer *iconPresentationLayer = self.imageView.layer.presentationLayer;
        if (iconPresentationLayer) {
            // Transform from a scale of 0, up to the icon view's current (animated) transform
            CALayer *presentationLayer = self.layer.presentationLayer;
            NSValue *fromValue =
            presentationLayer ? [NSValue valueWithCATransform3D:CATransform3DConcat(
                                                                                    presentationLayer.transform,
                                                                                    CATransform3DMakeScale(0, 0, 1))]
            : nil;
            CABasicAnimation *iconScaleAnimation = [GTUIFloatingButton
                                                    animationWithKeypath:@"transform"
                                                    toValue:[NSValue valueWithCATransform3D:iconPresentationLayer.transform]
                                                    fromValue:fromValue
                                                    timingFunction:[[CAMediaTimingFunction alloc]
                                                                    initWithControlPoints:0.0f:0.0f:0.2f:1.0f]
                                                    fillMode:kCAFillModeBoth
                                                    duration:kGTUIFloatingButtonEnterIconDuration
                                                    beginOffset:kGTUIFloatingButtonEnterIconOffset];
            [self.imageView.layer addAnimation:iconScaleAnimation forKey:kGTUIFloatingButtonTransformKey];
        }

        CABasicAnimation *opacityAnimation = [GTUIFloatingButton
                                              animationWithKeypath:@"opacity"
                                              toValue:[NSNumber numberWithInt:1]
                                              fromValue:nil
                                              timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]
                                              fillMode:kCAFillModeForwards
                                              duration:kGTUIFloatingButtonOpacityDuration
                                              beginOffset:kGTUIFloatingButtonOpacityEnterOffset];
        [self.layer addAnimation:opacityAnimation forKey:kGTUIFloatingButtonOpacityKey];

        [CATransaction commit];
    } else {
        expandActions();
    }
}

- (void)collapse:(BOOL)animated completion:(void (^_Nullable)(void))completion {
    void (^collapseActions)(void) = ^{
        self.layer.transform =
        CATransform3DConcat(self.layer.transform, [GTUIFloatingButton collapseTransform]);
        self.layer.opacity = 0;
        self.imageView.layer.transform =
        CATransform3DConcat(self.imageView.layer.transform, [GTUIFloatingButton collapseTransform]);
        [self.layer removeAnimationForKey:kGTUIFloatingButtonTransformKey];
        [self.layer removeAnimationForKey:kGTUIFloatingButtonOpacityKey];
        [self.imageView.layer removeAnimationForKey:kGTUIFloatingButtonTransformKey];
        if (completion) {
            completion();
        }
    };

    if (animated) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:collapseActions];

        CABasicAnimation *overallScaleAnimation = [GTUIFloatingButton
                                                   animationWithKeypath:@"transform"
                                                   toValue:[NSValue
                                                            valueWithCATransform3D:CATransform3DConcat(
                                                                                                       self.layer.transform,
                                                                                                       [GTUIFloatingButton collapseTransform])]
                                                   fromValue:nil
                                                   timingFunction:[[CAMediaTimingFunction alloc]
                                                                   initWithControlPoints:0.4f:0.0f:1.0f:1.0f]
                                                   fillMode:kCAFillModeForwards
                                                   duration:kGTUIFloatingButtonExitDuration
                                                   beginOffset:0];
        [self.layer addAnimation:overallScaleAnimation forKey:kGTUIFloatingButtonTransformKey];

        CABasicAnimation *iconScaleAnimation = [GTUIFloatingButton
                                                animationWithKeypath:@"transform"
                                                toValue:[NSValue
                                                         valueWithCATransform3D:CATransform3DConcat(
                                                                                                    self.imageView.layer.transform,
                                                                                                    [GTUIFloatingButton collapseTransform])]
                                                fromValue:nil
                                                timingFunction:[[CAMediaTimingFunction alloc]
                                                                initWithControlPoints:0.4f:0.0f:1.0f:1.0f]
                                                fillMode:kCAFillModeForwards
                                                duration:kGTUIFloatingButtonExitIconDuration
                                                beginOffset:kGTUIFloatingButtonExitIconOffset];
        [self.imageView.layer addAnimation:iconScaleAnimation forKey:kGTUIFloatingButtonTransformKey];

        CABasicAnimation *opacityAnimation = [GTUIFloatingButton
                                              animationWithKeypath:@"opacity"
                                              toValue:[NSNumber numberWithFloat:0]
                                              fromValue:nil
                                              timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]
                                              fillMode:kCAFillModeForwards
                                              duration:kGTUIFloatingButtonOpacityDuration
                                              beginOffset:kGTUIFloatingButtonOpacityExitOffset];
        [self.layer addAnimation:opacityAnimation forKey:kGTUIFloatingButtonOpacityKey];

        [CATransaction commit];
    } else {
        collapseActions();
    }
}

@end
