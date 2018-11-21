//
//  GTUIProgressView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

/** The animation mode when animating backward progress. */
typedef NS_ENUM(NSInteger, GTUIProgressViewBackwardAnimationMode) {

    /** Animate negative progress by resetting to 0 and then animating to the new value. */
    GTUIProgressViewBackwardAnimationModeReset,

    /** Animate negative progress by animating from the current value. */
    GTUIProgressViewBackwardAnimationModeAnimate
};

IB_DESIGNABLE
@interface GTUIProgressView : UIView

/**
 The color shown for the portion of the progress view that is filled.

 The default is a blue color. When changed, the trackTintColor is reset.
 */
@property(nonatomic, strong, null_resettable) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;

/**
 The color shown for the portion of the progress view that is not filled.

 The default is a light version of the current progressTintColor.
 */
@property(nonatomic, strong, null_resettable) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;

/**
 The current progress.

 The current progress is represented by a floating-point value between 0.0 and 1.0, inclusive, where
 1.0 indicates the completion of the task. The default value is 0.0. Values less than 0.0 and
 greater than 1.0 are pinned to those limits.
 To animate progress changes, use -setProgress:animated:completion:.
 */
@property(nonatomic, assign) float progress;

/**
 The backward progress animation mode.

 When animating progress which is lower than the current progress value, this mode
 will determine which animation to use. The default is GTUIProgressViewBackwardAnimationModeReset.
 */
@property(nonatomic, assign) GTUIProgressViewBackwardAnimationMode backwardProgressAnimationMode;

/**
 Adjusts the current progress, optionally animating the change.

 @param progress The progress to set.
 @param animated Whether the change should be animated.
 @param completion The completion block executed at the end of the animation.
 */
- (void)setProgress:(float)progress
           animated:(BOOL)animated
         completion:(void (^__nullable)(BOOL finished))completion;

/**
 Changes the hidden state, optionally animating the change.

 @param hidden The hidden state to set.
 @param animated Whether the change should be animated.
 @param completion The completion block executed at the end of the animation.
 */
- (void)setHidden:(BOOL)hidden
         animated:(BOOL)animated
       completion:(void (^__nullable)(BOOL finished))completion;

@end
