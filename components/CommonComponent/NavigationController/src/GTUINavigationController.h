//
//  GTUINavigationController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>

@class GTUIAppBarViewController;
@class GTUINavigationController;
/**
 Defines the events that an GTUINavigationController may send to a delegate.
 */
@protocol GTUINavigationControllerDelegate <UINavigationControllerDelegate>
@optional

/**
 Informs the receiver that the given App Bar will be added as a child of the given view controller.

 This event is primarily intended to allow any configuration or theming of the App Bar to occur
 before it becomes part of the view controller hierarchy.

 By the time this event has fired, the navigation controller will already have attempted to infer
 the tracking scroll view from the provided view controller.

 @note This method will only be invoked if a new App Bar instance is about to be added to the view
 controller. If a flexible header is already present in the view controller, this method will not
 be invoked.
 */
- (void)navigationController:(nonnull GTUINavigationController *)navigationController
       willAddAppBarViewController:(nonnull GTUIAppBarViewController *)appBarViewController
           asChildOfViewController:(nonnull UIViewController *)viewController;

@end


/**
 A custom navigation controller instance that auto-injects App Bar instances into pushed view
 controllers.

 If a pushed view controller already has an App Bar or a Flexible Header then the navigation
 controller will not inject a new App Bar.

 To theme the injected App Bar, implement the delegate's
 -appBarNavigationController:willAddAppBar:asChildOfViewController: API.

 @note If you use the initWithRootViewController: API you will not have been able to provide a
 delegate yet. In this case, use the -appBarForViewController: API to retrieve the injected App Bar
 for your root view controller and execute your delegate logic on the returned result, if any.
 */
__attribute__((objc_subclassing_restricted))
@interface GTUINavigationController : UINavigationController

#pragma mark - Reacting to state changes

/**
 An extension of the UINavigationController's delegate.
 */
@property(nonatomic, weak, nullable) id<GTUINavigationControllerDelegate> delegate;

#pragma mark - Getting App Bar view controller instances

/**
 Returns the injected App Bar view controller for a given view controller, if an App Bar was
 injected.
 */
- (nullable GTUIAppBarViewController *)naviBarViewControllerForViewController:
(nonnull UIViewController *)viewController;

@end
