//
//  UIView+GTUITimingFunction.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "UIView+GTUITimingFunction.h"

@implementation UIView (GTUITimingFunction)

+ (void)gtui_animateWithTimingFunction:(CAMediaTimingFunction *)timingFunction
                             duration:(NSTimeInterval)duration
                                delay:(NSTimeInterval)delay
                              options:(UIViewAnimationOptions)options
                           animations:(void (^)(void))animations
                           completion:(void (^)(BOOL finished))completion {
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:timingFunction];
    [UIView animateWithDuration:duration
                          delay:delay
                        options:options
                     animations:animations
                     completion:completion];
    [CATransaction commit];
}

@end
