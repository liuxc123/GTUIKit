//
//  GTUIFlexibleHeaderContainerViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import <UIKit/UIKit.h>

@class GTUIFlexibleHeaderViewController;

/**
 The GTUIFlexibleHeaderContainerViewController controller is a straightforward container of a
 content view controller and a GTUIFlexibleHeaderViewController.

 This view controller may be used in situations where the content view controller can't have a
 header injected into its view hierarchy. UIPageViewController is one such view controller.
 */
@interface GTUIFlexibleHeaderContainerViewController : UIViewController

- (nonnull instancetype)initWithContentViewController:
(nullable UIViewController *)contentViewController NS_DESIGNATED_INITIALIZER;

/**
 The header view controller that lives alongside the content view controller.

 This view controller's view will be placed in front of the content view controller's view.
 */
@property(nonatomic, strong, nonnull, readonly)
GTUIFlexibleHeaderViewController *headerViewController;

/**
 The content view controller to be displayed behind the header.

 This view controller's layout will be owned and managed by the container view controller. If the
 content view controller has prior layout constraints associated with it, the behavior is undefined.
 */
@property(nonatomic, strong, nullable) UIViewController *contentViewController;

#pragma mark - Enabling top layout guide adjustment behavior

/**
 If enabled, the content view controller's top layout guide will be adjusted as the flexible
 header's height changes and the content view controller view's frame will be set to the container
 view controller's bounds.

 This behavior is disabled by default, but it will be enabled by default in the future. Consider
 enabling this behavior and making use of the topLayoutGuide in your view controller accordingly.

 Example positioning a view using constraints:

 [NSLayoutConstraint constraintWithItem:view
 attribute:NSLayoutAttributeTop
 relatedBy:NSLayoutRelationEqual
 toItem:self.topLayoutGuide
 attribute:NSLayoutAttributeBottom
 multiplier:1
 constant:32]

 Example positioning a view without constraints:

 frame.origin.y = self.topLayoutGuide.length + 32
 */
@property(nonatomic, getter=isTopLayoutGuideAdjustmentEnabled) BOOL topLayoutGuideAdjustmentEnabled;

@end

