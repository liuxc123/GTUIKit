//
//  GTUIInkView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUIInkView.h"

#import "GTMath.h"
#import "private/GTUIInkLayer.h"
#import "private/GTUILegacyInkLayer.h"

@interface GTUIInkPendingAnimation : NSObject <CAAction>

@property(nonatomic, weak) CALayer *animationSourceLayer;
@property(nonatomic, strong) NSString *keyPath;
@property(nonatomic, strong) id fromValue;
@property(nonatomic, strong) id toValue;

@end

@interface GTUIInkView () <CALayerDelegate, GTUIInkLayerDelegate>

@property(nonatomic, strong) CAShapeLayer *maskLayer;
@property(nonatomic, copy) GTUIInkCompletionBlock startInkRippleCompletionBlock;
@property(nonatomic, copy) GTUIInkCompletionBlock endInkRippleCompletionBlock;
@property(nonatomic, strong) GTUIInkLayer *activeInkLayer;

// Legacy ink ripple
@property(nonatomic, readonly) GTUILegacyInkLayer *inkLayer;

@end

@implementation GTUIInkView {
    CGFloat _maxRippleRadius;
}

+ (Class)layerClass {
    return [GTUILegacyInkLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTUIInkViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTUIInkViewInit];
    }
    return self;
}

- (void)commonGTUIInkViewInit {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.layer.delegate = self;
    self.inkColor = self.defaultInkColor;
    _usesLegacyInkRipple = YES;

    // Use mask layer when the superview has a shadowPath.
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.delegate = self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // If the superview has a shadowPath make sure ink does not spread outside of the shadowPath.
    if (self.superview.layer.shadowPath) {
        self.maskLayer.path = self.superview.layer.shadowPath;
        self.layer.mask = _maskLayer;
    }

    CGRect inkBounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.layer.bounds = inkBounds;

    // When bounds change ensure all ink layer bounds are changed too.
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[GTUIInkLayer class]]) {
            GTUIInkLayer *inkLayer = (GTUIInkLayer *)layer;
            inkLayer.bounds = inkBounds;
        }
    }
}

- (void)setInkStyle:(GTUIInkStyle)inkStyle {
    _inkStyle = inkStyle;
    if (self.usesLegacyInkRipple) {
        switch (inkStyle) {
            case GTUIInkStyleBounded:
                self.inkLayer.masksToBounds = YES;
                self.inkLayer.bounded = YES;
                break;
            case GTUIInkStyleUnbounded:
                self.inkLayer.masksToBounds = NO;
                self.inkLayer.bounded = NO;
                break;
        }
    } else {
        switch(inkStyle) {
            case GTUIInkStyleBounded:
                self.inkLayer.maxRippleRadius = 0;
                break;
            case GTUIInkStyleUnbounded:
                self.inkLayer.maxRippleRadius = _maxRippleRadius;
                break;
        }
    }
}

- (void)setInkColor:(UIColor *)inkColor {
    if (inkColor == nil) {
        return;
    }
    self.inkLayer.inkColor = inkColor;
}

- (UIColor *)inkColor {
    return self.inkLayer.inkColor;
}

- (CGFloat)maxRippleRadius {
    return self.inkLayer.maxRippleRadius;
}

- (void)setMaxRippleRadius:(CGFloat)radius {
    // Keep track of the set value in case the caller will change inkStyle later
    _maxRippleRadius = radius;
    if (GTUICGFloatEqual(self.inkLayer.maxRippleRadius, radius)) {
        return;
    }

    // Legacy Ink updates inkLayer.maxRippleRadius regardless of inkStyle
    if (self.usesLegacyInkRipple) {
        self.inkLayer.maxRippleRadius = radius;
        // This is required for legacy Ink so that the Ink bounds will be adjusted correctly
        [self setNeedsLayout];
    } else {
        // New Ink Bounded style ignores maxRippleRadius
        switch(self.inkStyle) {
            case GTUIInkStyleUnbounded:
                self.inkLayer.maxRippleRadius = radius;
                break;
            case GTUIInkStyleBounded:
                // No-op
                break;
        }
    }
}

- (BOOL)usesCustomInkCenter {
    return self.inkLayer.useCustomInkCenter;
}

- (void)setUsesCustomInkCenter:(BOOL)usesCustomInkCenter {
    self.inkLayer.useCustomInkCenter = usesCustomInkCenter;
}

- (CGPoint)customInkCenter {
    return self.inkLayer.customInkCenter;
}

- (void)setCustomInkCenter:(CGPoint)customInkCenter {
    self.inkLayer.customInkCenter = customInkCenter;
}

- (GTUILegacyInkLayer *)inkLayer {
    return (GTUILegacyInkLayer *)self.layer;
}

- (void)startTouchBeganAnimationAtPoint:(CGPoint)point
                             completion:(GTUIInkCompletionBlock)completionBlock {
    [self startTouchBeganAtPoint:point animated:YES withCompletion:completionBlock];
}

- (void)startTouchBeganAtPoint:(CGPoint)point animated:(BOOL)animated
                withCompletion:(nullable GTUIInkCompletionBlock)completionBlock {
    if (self.usesLegacyInkRipple) {
        [self.inkLayer spreadFromPoint:point completion:completionBlock];
    } else {
        self.startInkRippleCompletionBlock = completionBlock;
        GTUIInkLayer *inkLayer = [GTUIInkLayer layer];
        inkLayer.inkColor = self.inkColor;
        inkLayer.maxRippleRadius = self.maxRippleRadius;
        inkLayer.animationDelegate = self;
        inkLayer.opacity = 0;
        inkLayer.frame = self.bounds;
        [self.layer addSublayer:inkLayer];
        [inkLayer startInkAtPoint:point animated:animated];
        self.activeInkLayer = inkLayer;
    }
}

- (void)startTouchEndAtPoint:(CGPoint)point animated:(BOOL)animated
              withCompletion:(nullable GTUIInkCompletionBlock)completionBlock {
    if (self.usesLegacyInkRipple) {
        [self.inkLayer evaporateWithCompletion:completionBlock];
    } else {
        self.endInkRippleCompletionBlock = completionBlock;
        [self.activeInkLayer endInkAtPoint:point animated:animated];
    }
}

- (void)startTouchEndedAnimationAtPoint:(CGPoint)point
                             completion:(GTUIInkCompletionBlock)completionBlock {
    [self startTouchEndAtPoint:point animated:YES withCompletion:completionBlock];
}

- (void)cancelAllAnimationsAnimated:(BOOL)animated {
    if (self.usesLegacyInkRipple) {
        [self.inkLayer resetAllInk:animated];
    } else {
        NSArray<CALayer *> *sublayers = [self.layer.sublayers copy];
        for (CALayer *layer in sublayers) {
            if ([layer isKindOfClass:[GTUIInkLayer class]]) {
                GTUIInkLayer *inkLayer = (GTUIInkLayer *)layer;
                if (animated) {
                    [inkLayer endAnimationAtPoint:CGPointZero];
                } else {
                    [inkLayer removeFromSuperlayer];
                }
            }
        }
    }
}

- (UIColor *)defaultInkColor {
    return [[UIColor alloc] initWithWhite:0 alpha:0.14f];
}

+ (GTUIInkView *)injectedInkViewForView:(UIView *)view {
    GTUIInkView *foundInkView = nil;
    for (GTUIInkView *subview in view.subviews) {
        if ([subview isKindOfClass:[GTUIInkView class]]) {
            foundInkView = subview;
            break;
        }
    }
    if (!foundInkView) {
        foundInkView = [[GTUIInkView alloc] initWithFrame:view.bounds];
        foundInkView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view addSubview:foundInkView];
    }
    return foundInkView;
}

#pragma mark - GTUIInkLayerDelegate

- (void)inkLayerAnimationDidStart:(GTUIInkLayer *)inkLayer {
    if (self.activeInkLayer == inkLayer && self.startInkRippleCompletionBlock) {
        self.startInkRippleCompletionBlock();
    }
    if ([self.animationDelegate respondsToSelector:@selector(inkAnimationDidStart:)]) {
        [self.animationDelegate inkAnimationDidStart:self];
    }
}

- (void)inkLayerAnimationDidEnd:(GTUIInkLayer *)inkLayer {
    if (self.activeInkLayer == inkLayer && self.endInkRippleCompletionBlock) {
        self.endInkRippleCompletionBlock();
    }
    if ([self.animationDelegate respondsToSelector:@selector(inkAnimationDidEnd:)]) {
        [self.animationDelegate inkAnimationDidEnd:self];
    }
}

#pragma mark - CALayerDelegate

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    if ([event isEqualToString:@"path"] || [event isEqualToString:@"shadowPath"]) {

        // We have to create a pending animation because if we are inside a UIKit animation block we
        // won't know any properties of the animation block until it is commited.
        GTUIInkPendingAnimation *pendingAnim = [[GTUIInkPendingAnimation alloc] init];
        pendingAnim.animationSourceLayer = self.superview.layer;
        pendingAnim.fromValue = [layer.presentationLayer valueForKey:event];
        pendingAnim.toValue = nil;
        pendingAnim.keyPath = event;

        return pendingAnim;
    }
    return nil;
}

@end

@implementation GTUIInkPendingAnimation

- (void)runActionForKey:(NSString *)event object:(id)anObject arguments:(NSDictionary *)dict {
    if ([anObject isKindOfClass:[CAShapeLayer class]]) {
        CAShapeLayer *layer = (CAShapeLayer *)anObject;

        // In order to synchronize our animation with UIKit animations we have to fetch the resizing
        // animation created by UIKit and copy the configuration to our custom animation.
        CAAnimation *boundsAction = [self.animationSourceLayer animationForKey:@"bounds.size"];
        if ([boundsAction isKindOfClass:[CABasicAnimation class]]) {
            CABasicAnimation *animation = (CABasicAnimation *)[boundsAction copy];
            animation.keyPath = self.keyPath;
            animation.fromValue = self.fromValue;
            animation.toValue = self.toValue;

            [layer addAnimation:animation forKey:event];
        }
    }
}

@end
