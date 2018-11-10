//
//  GTUIShadowElevations.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#ifdef NS_TYPED_EXTENSIBLE_ENUM // This macro is introduced in Xcode 9.
#define GTUI_SHADOW_ELEVATION_TYPED_EXTENSIBLE_ENUM NS_TYPED_EXTENSIBLE_ENUM
#elif __has_attribute(swift_wrapper) // Backwards compatibility for Xcode 8.
#define GTUI_SHADOW_ELEVATION_TYPED_EXTENSIBLE_ENUM __attribute__((swift_wrapper(struct)))
#else
#define GTUI_SHADOW_ELEVATION_TYPED_EXTENSIBLE_ENUM
#endif

NS_SWIFT_NAME(ShadowElevation)
typedef CGFloat GTUIShadowElevation GTUI_SHADOW_ELEVATION_TYPED_EXTENSIBLE_ENUM;

/** The shadow elevation of the app bar. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationAppBar;

/** The shadow elevation of the Bottom App Bar. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationBottomNavigationBar;

/** The shadow elevation of a card in its picked up state. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationCardPickedUp;

/** The shadow elevation of a card in its resting state. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationCardResting;

/** The shadow elevation of dialogs. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationDialog;

/** The shadow elevation of the floating action button in its pressed state. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationFABPressed;

/** The shadow elevation of the floating action button in its resting state. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationFABResting;

/** The shadow elevation of a menu. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationMenu;

/** The shadow elevation of a modal bottom sheet. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationModalBottomSheet;

/** The shadow elevation of the navigation drawer. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationNavDrawer;

/** No shadow elevation at all. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationNone;

/** The shadow elevation of a picker. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationPicker;

/** The shadow elevation of the quick entry in the scrolled state. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationQuickEntry;

/** The shadow elevation of the quick entry in the resting state. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationQuickEntryResting;

/** The shadow elevation of a raised button in the pressed state. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationRaisedButtonPressed;

/** The shadow elevation of a raised button in the resting state. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationRaisedButtonResting;

/** The shadow elevation of a refresh indicator. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationRefresh;

/** The shadow elevation of the right drawer. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationRightDrawer;

/** The shadow elevation of the search bar in the resting state. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationSearchBarResting;

/** The shadow elevation of the search bar in the scrolled state. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationSearchBarScrolled;

/** The shadow elevation of the snackbar. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationSnackbar;

/** The shadow elevation of a sub menu (+1 for each additional sub menu). */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationSubMenu;

/** The shadow elevation of a switch. */
FOUNDATION_EXPORT const GTUIShadowElevation GTUIShadowElevationSwitch;
