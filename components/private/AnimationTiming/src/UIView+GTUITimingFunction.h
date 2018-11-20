//
//  UIView+GTUITimingFunction.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>

@interface UIView (GTUITimingFunction)

/**
 A convienence method for applying a timing function to animations.

 @param timingFunction A timing function for the easing curve animation.
 @param duration The time the animation takes.
 @param delay The time to wait before the animation begins.
 @param options Configuration options for the timing function.
 @param animations Animations to which the timing function will apply.
 @param completion A completion block fired after the animations complete.
 */
+ (void)gtui_animateWithTimingFunction:(nullable CAMediaTimingFunction *)timingFunction
                             duration:(NSTimeInterval)duration
                                delay:(NSTimeInterval)delay
                              options:(UIViewAnimationOptions)options
                           animations:(void (^ __nonnull)(void))animations
                           completion:(void (^ __nullable)(BOOL finished))completion;

@end
