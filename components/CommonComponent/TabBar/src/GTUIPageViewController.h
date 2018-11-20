//
//  GTUIPageViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>

#import "GTUITabBar.h"

@protocol GTUIPageViewControllerDelegate;

/**
 The GTUIPageViewController class manages a set of view controllers, showing their UITabBarItems
 as tappable items in a bottom GTUITabBar. When the user taps one of those items, the corresponding
 view controller appears.
 */
IB_DESIGNABLE
@interface GTUIPageViewController : UIViewController

@end

/** The delegate protocol for GTUIPageViewController */
@protocol GTUIPageViewControllerDelegate <NSObject>
@optional

/**
 Called when the user taps on a tab bar item. Not called for programmatic selection.

 If you provide this method, you can control whether tapping on a tab bar item actually
 switches to that viewController. If not provided, GTUIPageViewController will always switch.

 @note The tab bar controller will call this method even when the tapped tab bar
 item is the currently-selected tab bar item.

 You can also use this method as a willSelectViewController.
 */
- (BOOL)tabBarController:(nonnull GTUIPageViewController *)pageController
shouldSelectViewController:(nonnull UIViewController *)viewController;

/**
 Called when the user taps on a tab bar item. Not called for programmatic selection.
 GTUIPageViewController will call your delegate once it has responded to the user's tap
 by changing the selected view controller.

 @note The tab bar controller will call this method even when the tapped tab bar
 item is the currently-selected tab bar item.
 */
- (void)tabBarController:(nonnull GTUIPageViewController *)pageController
 didSelectViewController:(nonnull UIViewController *)viewController;

@end
