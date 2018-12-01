//
//  GTUIOverlayObserverTransition.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import "GTUIOverlayObserverTransition.h"
#import "GTUIOverlayObserverOverlay.h"
#import "GTUIOverlayUtilities.h"

#import <QuartzCore/QuartzCore.h>

@interface GTUIOverlayObserverTransition ()

/**
 Blocks to run as part of the transition.
 */
@property(nonatomic) NSMutableArray *animationBlocks;

/**
 Completion blocks to run when the transition animation finishes.
 */
@property(nonatomic) NSMutableArray *completionBlocks;

@end

@implementation GTUIOverlayObserverTransition

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _animationBlocks = [NSMutableArray array];
        _completionBlocks = [NSMutableArray array];
    }
    return self;
}

/**
 Runs the given animation block with the provided animation options, knowing that this method will
 only run as part of @c runAnimation.
 */
- (void)runAnimationWithOptions:(UIViewAnimationOptions)options
                     animations:(void (^)(void))animations {
    if (self.duration > 0) {
        UIViewAnimationOptions optionsToUse = options;

        // Don't let the caller override the curve or the duration.
        optionsToUse &= ~UIViewAnimationOptionOverrideInheritedDuration;
        optionsToUse &= ~UIViewAnimationOptionOverrideInheritedOptions;

        // Run a nested animation. We'll use a token animation duration, which will be ignored because
        // this will be a nested animation.
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:optionsToUse
                         animations:animations
                         completion:nil];
    } else {
        // Just execute the animation block if non-animated.
        animations();
    }
}

- (void)animateAlongsideTransitionWithOptions:(UIViewAnimationOptions)options
                                   animations:(void (^)(void))animations
                                   completion:(void (^)(BOOL finished))completion {
    if (animations != nil) {
        // Capture the options and animation block, to be executed later when @c runAnimation is called.
        __weak GTUIOverlayObserverTransition *weakSelf = self;
        void (^animationToRun)(void) = ^{
            GTUIOverlayObserverTransition *strongSelf = weakSelf;
            [strongSelf runAnimationWithOptions:options animations:animations];
        };

        [self.animationBlocks addObject:[animationToRun copy]];
    }

    if (completion != nil) {
        [self.completionBlocks addObject:[completion copy]];
    }
}

- (void)animateAlongsideTransition:(void (^)(void))animations {
    [self animateAlongsideTransitionWithOptions:0 animations:animations completion:nil];
}

- (void)runAnimation {
    void (^animations)(void) = ^{
        for (void (^animation)(void) in self.animationBlocks) {
            animation();
        }
    };

    void (^completions)(BOOL) = ^(BOOL finished) {
        for (void (^completion)(BOOL) in self.completionBlocks) {
            completion(finished);
        }
    };

    if (self.duration > 0) {
        CAMediaTimingFunction *customTiming = self.customTimingFunction;

        BOOL animationsEnabled = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:YES];

        if (customTiming != nil) {
            [CATransaction begin];
            [CATransaction setAnimationTimingFunction:customTiming];
        }

        [UIView animateWithDuration:self.duration
                              delay:0
                            options:self.animationCurve << 16
                         animations:animations
                         completion:completions];

        if (customTiming != nil) {
            [CATransaction commit];
        }

        [UIView setAnimationsEnabled:animationsEnabled];
    } else {
        animations();
        completions(YES);
    }
}

- (CGRect)compositeFrame {
    CGRect frame = CGRectNull;

    for (GTUIOverlayObserverOverlay *overlay in self.overlays) {
        frame = CGRectUnion(frame, overlay.frame);
    }

    return frame;
}

- (CGRect)compositeFrameInView:(UIView *)targetView {
    return GTUIOverlayConvertRectToView(self.compositeFrame, targetView);
}

- (void)enumerateOverlays:(void (^)(id<GTUIOverlay> overlay, NSUInteger idx, BOOL *stop))handler {
    if (handler == nil) {
        return;
    }

    [self.overlays
     enumerateObjectsUsingBlock:^(GTUIOverlayObserverOverlay *overlay, NSUInteger idx, BOOL *stop) {
         handler(overlay, idx, stop);
     }];
}

@end
