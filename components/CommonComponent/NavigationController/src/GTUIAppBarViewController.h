//
//  GTUIAppBarViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>
#import "GTFlexibleHeader.h"
#import "GTHeaderStackView.h"
#import "GTNavigationBar.h"

@class GTUIAppBarViewController;

/**
 GTUIAppBarViewController is a flexible header view controller that manages a navigation bar and
 header stack view in order to provide the Material Top App Bar user interface.
 */
@interface GTUIAppBarViewController : GTUIFlexibleHeaderViewController

/**
 The navigation bar often represents the information stored in a view controller's navigationItem
 propoerty, but it can also be directly configured.
 */
@property(nonatomic, strong, nonnull) GTUINavigationBar *navigationBar;

/**
 The header stack view owns the navigationBar (as the top bar) and an optional bottom bar (typically
 a tab bar).
 */
@property(nonatomic, strong, nonnull) GTUIHeaderStackView *headerStackView;

@end

#pragma mark - To be deprecated

/**
 The GTUIAppBar class creates and configures the constellation of components required to represent a
 Material App Bar.

 A Material App Bar consists of a Flexible Header View with a shadow, a Navigation Bar, and space
 for flexible content such as a photo.

 Learn more at the [Material
 spec](https://material.io/guidelines/patterns/scrolling-techniques.html)

 ### Dependencies

 AppBar depends on the FlexibleHeader, HeaderStackView, and NavigationBar Material Components.

 @warning This API will be deprecated in favor of GTUIAppBarViewController. Learn more at
 https://github.com/material-components/material-components-ios/blob/develop/components/AppBar/docs/migration-guide-appbar-appbarviewcontroller.md
 */
@interface GTUIAppBar : NSObject

/**
 Adds headerViewController.view to headerViewController.parentViewController.view and registers
 navigationItem observation on headerViewController.parentViewController.
 */
- (void)addSubviewsToParent;

/** The header view controller instance manages the App Bar's flexible header view behavior. */
@property(nonatomic, strong, nonnull, readonly)
GTUIFlexibleHeaderViewController *headerViewController;

/** The App Bar view controller instance manages the App Bar's flexible header view behavior. */
@property(nonatomic, strong, nonnull, readonly) GTUIAppBarViewController *appBarViewController;

/** The navigation bar. */
@property(nonatomic, strong, nonnull, readonly) GTUINavigationBar *navigationBar;

/**
 The header stack view that owns the navigationBar (as the top bar) and an optional bottom bar.
 */
@property(nonatomic, strong, nonnull, readonly) GTUIHeaderStackView *headerStackView;

/**
 Whether the App Bar should attempt to extract safe area insets from the view controller hierarchy
 or not.

 This behavior provides better support for App Bars on iPad, extensions, and anywhere else where the
 view controller might not be directly behind the status bar / device safe area insets.

 Enabling this behavior will do the following:

 - Enable the same-named behavior on the headerViewController.
 - Enable the headerViewController's topLayoutGuideAdjustmentEnabled behavior. Consider setting a
 topLayoutGuideViewController to your content view controller if you want to use topLayoutGuide.
 - The header stack view's frame will be inset by the flexible header view's topSafeAreaGuide rather
 than the global device safe area insets.

 Disabling this behavior will not disable headerViewController's topLayoutGuideAdjustmentEnabled
 behavior.

 This behavior will eventually be enabled by default.

 See GTUIFlexibleHeaderViewController's documentation for the API of the same name.

 Default is NO.
 */
@property(nonatomic) BOOL inferTopSafeAreaInsetFromViewController;

@end

