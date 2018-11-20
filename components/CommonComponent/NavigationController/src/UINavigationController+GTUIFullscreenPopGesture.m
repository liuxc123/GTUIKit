//
//  UINavigationController+GTUIFullscreenPopGesture.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "UINavigationController+GTUIFullscreenPopGesture.h"
#import <objc/runtime.h>

@interface _GTUIFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation _GTUIFullscreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }

    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.gtui_interactivePopDisabled) {
        return NO;
    }

    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.gtui_interactivePopMaxAllowedInitialDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }

    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }

    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }

    return YES;
}

@end

typedef void (^_GTUIViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (GTUIFullscreenPopGesturePrivate)

@property (nonatomic, copy) _GTUIViewControllerWillAppearInjectBlock gtui_willAppearInjectBlock;

@end


@implementation UINavigationController (GTUIFullscreenPopGesture)

+ (void)load
{
    // Inject "-pushViewController:animated:"
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(gtui_pushViewController:animated:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)gtui_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.gtui_fullscreenPopGestureRecognizer]) {

        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.gtui_fullscreenPopGestureRecognizer];

        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.gtui_fullscreenPopGestureRecognizer.delegate = self.gtui_popGestureRecognizerDelegate;
        [self.gtui_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];

        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }

    // Handle perferred navigation bar appearance.
    [self gtui_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];

    // Forward to primary implementation.
    if (![self.viewControllers containsObject:viewController]) {
        [self gtui_pushViewController:viewController animated:animated];
    }
}

- (void)gtui_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.gtui_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
}

- (_GTUIFullscreenPopGestureRecognizerDelegate *)gtui_popGestureRecognizerDelegate
{
    _GTUIFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);

    if (!delegate) {
        delegate = [[_GTUIFullscreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;

        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)gtui_fullscreenPopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);

    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;

        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (BOOL)gtui_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.gtui_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setGtui_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(gtui_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (GTUIFullscreenPopGesture)

- (BOOL)gtui_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setGtui_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(gtui_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)gtui_interactivePopMaxAllowedInitialDistanceToLeftEdge
{
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)setGtui_interactivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance
{
    SEL key = @selector(gtui_interactivePopMaxAllowedInitialDistanceToLeftEdge);
    objc_setAssociatedObject(self, key, @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
