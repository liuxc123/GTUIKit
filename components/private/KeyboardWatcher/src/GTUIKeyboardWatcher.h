//
//  GTUIKeyboardWatcher.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

OBJC_EXTERN NSString *const GTUIKeyboardWatcherKeyboardWillShowNotification;
OBJC_EXTERN NSString *const GTUIKeyboardWatcherKeyboardWillHideNotification;
OBJC_EXTERN NSString *const GTUIKeyboardWatcherKeyboardWillChangeFrameNotification;


@interface GTUIKeyboardWatcher : NSObject

/**
 Shared singleton instance of GTUIKeyboardWatcher.
 */
+ (instancetype)sharedKeyboardWatcher;

/** Extract the animation duration from the keyboard notification */
+ (NSTimeInterval)animationDurationFromKeyboardNotification:(NSNotification *)notification;

/** Extract the animation curve option from the keyboard notification */
+ (UIViewAnimationOptions)animationCurveOptionFromKeyboardNotification:
(NSNotification *)notification;

/**
 The height of the visible keyboard view.

 Zero if the keyboard is not currently showing or is not docked.
 */
@property(nonatomic, readonly) CGFloat visibleKeyboardHeight;


@end
