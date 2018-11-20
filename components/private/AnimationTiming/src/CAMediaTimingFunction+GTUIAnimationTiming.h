//
//  CAMediaTimingFunction+GTAnimationTiming.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Material Design easing curve animation values.

 Use these easing curves to create smooth and consistent motion that conforms to Material Design.
 */
typedef NS_ENUM(NSUInteger, GTUIAnimationTimingFunction) {
    /**
     This is the most frequently used interpolation curve for Material Design animations. This curve
     is slow both at the beginning and end. It has similar characteristics to the system's EaseInOut.
     This is known as Standard in the Material Design spec.
     */
    GTUIAnimationTimingFunctionStandard,

    /**
     This curve should be used for motion when entering frame or when fading in from 0% opacity. This
     curve is slow at the end. It has similar characteristics to the system's EaseOut. This is known
     as Deceleration in the Material Design spec.
     */
    GTUIAnimationTimingFunctionDeceleration,

    /**
     This curve should be used for motion when exiting frame or when fading out to 0% opacity. This
     curve is slow at the beginning. It has similar characteristics to the system's EaseIn. This
     is known as Acceleration in the Material Design spec.
     */
    GTUIAnimationTimingFunctionAcceleration,

    /**
     This curve should be used for motion when elements quickly accelerate and decelerate. It is
     used by exiting elements that may return to the screen at any time. The deceleration is
     faster than the standard curve since it doesn't follow an exact path to the off-screen point.
     */
    GTUIAnimationTimingFunctionSharp,

    /**
     Aliases for depreciated names
     */
    GTUIAnimationTimingFunctionEaseInOut = GTUIAnimationTimingFunctionStandard,
    GTUIAnimationTimingFunctionEaseOut = GTUIAnimationTimingFunctionDeceleration,
    GTUIAnimationTimingFunctionEaseIn = GTUIAnimationTimingFunctionAcceleration,

    /**
     Aliases for various specific timing curve recommendations.
     */
    GTUIAnimationTimingFunctionTranslate = GTUIAnimationTimingFunctionStandard,
    GTUIAnimationTimingFunctionTranslateOnScreen = GTUIAnimationTimingFunctionDeceleration,
    GTUIAnimationTimingFunctionTranslateOffScreen = GTUIAnimationTimingFunctionAcceleration,
    GTUIAnimationTimingFunctionFadeIn = GTUIAnimationTimingFunctionDeceleration,
    GTUIAnimationTimingFunctionFadeOut = GTUIAnimationTimingFunctionAcceleration,
};

/**
 Material Design animation curves.
 */
@interface CAMediaTimingFunction (GTUIAnimationTiming)

/**
 Returns the corresponding CAMediaTimingFunction for the given curve specified by an enum. The most
 common curve is GTUIAnimationTimingFunctionEaseInOut.

 @param type A Material Design media timing function.
 */
+ (nullable CAMediaTimingFunction *)gtui_functionWithType:(GTUIAnimationTimingFunction)type;

@end
