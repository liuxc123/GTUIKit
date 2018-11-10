//
//  GTUIInkView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <UIKit/UIKit.h>

@protocol GTUIInkViewDelegate;

/** Completion block signature for all ink animations. */
typedef void (^GTUIInkCompletionBlock)(void);

/** Ink styles. */
typedef NS_ENUM(NSInteger, GTUIInkStyle) {
    GTUIInkStyleBounded,  /** Ink is clipped to the view's bounds. */
    GTUIInkStyleUnbounded /** Ink is not clipped to the view's bounds. */
};

/**
 A UIView that draws and animates the Material Design ink effect for touch interactions.

 There are two kinds of ink:

 Bounded ink: Ink that spreads from a point and is contained in the bounds of a UI element such as a
 button. The ink is visually clipped to the bounds of the UI element. Bounded ink is the most
 commonly-used ink in the system. Examples include basic Material buttons, list menu items, and tile
 grids.

 Unbounded ink: Ink that spreads out from a point "on top" of other UI elements. It typically
 reaches a maximum circle radius and then fades, unclipped by other UI elements. Typically used
 when interacting with small UI elements such as navigation bar icons or slider "thumb" controls.
 Examples include overflow menus, icon toggle buttons, and phone dialer keys.

 Note that the two kinds of ink are designed to have different animation parameters, that is,
 bounded ink isn't just clipped unbounded ink. Whether the ink is bounded or not depends on the kind
 of UI element the user is interacting with.
 */
@interface GTUIInkView : UIView

/**
 Ink view animation delegate. Clients set this delegate to receive updates when ink animations
 start and end.
 */
@property(nonatomic, weak, nullable) id<GTUIInkViewDelegate> animationDelegate;

/**
 The style of ink for this view. Defaults to GTUIInkStyleBounded.

 Changes only affect subsequent animations, not animations in progress.
 */
@property(nonatomic, assign) GTUIInkStyle inkStyle;

/** The foreground color of the ink. The default value is defaultInkColor. */
@property(nonatomic, strong, nonnull) UIColor *inkColor UI_APPEARANCE_SELECTOR;

/** Default color used for ink if no color is specified. */
@property(nonatomic, strong, readonly, nonnull) UIColor *defaultInkColor;

/**
 Maximum radius of the ink. If the radius <= 0 then half the length of the diagonal of self.bounds
 is used. This value is ignored if @c inkStyle is set to |GTUIInkStyleBounded|.

 Ignored if updated ink is used.
 */
@property(nonatomic, assign) CGFloat maxRippleRadius;

/**
 Use the older legacy version of the ink ripple. Default is YES.
 */
@property(nonatomic, assign) BOOL usesLegacyInkRipple;

/**
 Use a custom center for the ink splash. If YES, then customInkCenter is used, otherwise the
 center of self.bounds is used. Default is NO.

 Affects behavior only if usesLegacyInkRipple is enabled.
 */
@property(nonatomic, assign) BOOL usesCustomInkCenter;

/**
 Custom center for the ink splash in the view’s coordinate system.

 Affects behavior only if both usesCustomInkCenter and usesLegacyInkRipple are enabled.
 */
@property(nonatomic, assign) CGPoint customInkCenter;

/**
 Start the first part of the "press and release" animation at a particular point.

 The "press and release" animation begins by fading in the ink ripple when this method is called.

 @param point The user interaction position in the view’s coordinate system.
 @param completionBlock Block called after the completion of the animation.
 */
- (void)startTouchBeganAnimationAtPoint:(CGPoint)point
                             completion:(nullable GTUIInkCompletionBlock)completionBlock;

/**
 Start the second part of the "press and release" animation at a particular point.

 The "press and release" animation ends by completing the ink ripple expansion while fading out when
 this method is called.

 @param point The user interaction position in the view’s coordinate system.
 @param completionBlock Block called after the completion of the animation.
 */
- (void)startTouchEndedAnimationAtPoint:(CGPoint)point
                             completion:(nullable GTUIInkCompletionBlock)completionBlock;

/**
 Cancel all animations.

 @param animated If false, remove the animations immediately.
 */
- (void)cancelAllAnimationsAnimated:(BOOL)animated;

/**
 Start the first part of spreading the ink at a particular point.

 This begins by fading in the ink ripple when this method is called.

 @param point The user interaction position in the view’s coordinate system.
 @param animated to add the ink sublayer with animation or not.
 @param completionBlock Block called after the completion of the animation.
 */
- (void)startTouchBeganAtPoint:(CGPoint)point
                      animated:(BOOL)animated
                withCompletion:(nullable GTUIInkCompletionBlock)completionBlock;

/**
 Start the second part of evaporating the ink at a particular point.

 This ends by completing the ink ripple expansion while fading out when
 this method is called.

 @param point The user interaction position in the view’s coordinate system.
 @param animated to remove the ink sublayer with animation or not.
 @param completionBlock Block called after the completion of the animation.
 */
- (void)startTouchEndAtPoint:(CGPoint)point
                    animated:(BOOL)animated
              withCompletion:(nullable GTUIInkCompletionBlock)completionBlock;

/**
 Enumerates the given view's subviews for an instance of GTUIInkView and returns it if found, or
 creates and adds a new instance of GTUIInkView if not.

 This method is a convenience method for adding ink to an arbitrary view without needing to subclass
 the target view. Use this method in situations where you expect there to be many distinct ink views
 in existence for a single ink touch controller. Example scenarios include:

 - Adding ink to individual collection view/table view cells

 This method can be used in your GTUIInkTouchController delegate's
 -inkTouchController:inkViewAtTouchLocation; implementation.
 */
+ (nonnull GTUIInkView *)injectedInkViewForView:(nonnull UIView *)view;

@end

/**
 Delegate protocol for GTUIInkView. Clients may implement this protocol to receive updates when ink
 layer start and end.
 */
@protocol GTUIInkViewDelegate <NSObject>

@optional

/**
 Called when the ink ripple animation begins.

 @param inkView The GTUIInkView that starts animating.
 */
- (void)inkAnimationDidStart:(nonnull GTUIInkView *)inkView;

/**
 Called when the ink ripple animation ends.

 @param inkView The GTUIInkView that ends animating.
 */
- (void)inkAnimationDidEnd:(nonnull GTUIInkView *)inkView;

@end
