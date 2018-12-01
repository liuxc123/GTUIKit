//
//  GTUIOverlayObserver.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import <UIKit/UIKit.h>

/**
 Class responsible for reporting changes to overlays on a given screen.
 */
@interface GTUIOverlayObserver : NSObject

/**
 Returns the overlay observer for the given screen.

 If @c screen is nil, the main screen is used.
 */
+ (instancetype)observerForScreen:(UIScreen *)screen;

/**
 Adds a target/action pair to listen for changes to overlays.

 If an overlay is already showing when this method is called, then a call to the target/action will
 be made immediately with an unanimated transition.

 @param target The object which will be the target of @c action
 @param action The method to invoke on @c target. This method should take a single argument, an
 object that conforms to @c GTUIOverlayTransitioning.
 */
- (void)addTarget:(id)target action:(SEL)action;

/**
 Prevents the given target/action pair from being notified of overlay changes.

 @param target The target to stop notifying of changes. If multiple @c actions have been
 registered, then @c target may still receive notifications via other selectors.
 @param action The method which will no longer be called when overlay changes occur.
 */
- (void)removeTarget:(id)target action:(SEL)action;

/**
 Prevents the given target from being notified of any overlay changes.

 @param target The target to stop notifying of changes. This will remove any and all target-action
 pairs registered via @c addTarget:action:.
 */
- (void)removeTarget:(id)target;

@end
