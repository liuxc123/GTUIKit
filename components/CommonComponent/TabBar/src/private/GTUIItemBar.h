//
//  GTUIItemBar.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>

#import "GTUIItemBarAlignment.h"

@class GTUIItemBarStyle;
@protocol GTUIItemBarDelegate;

/**
 A horizontally-scrollable list of tab-like items.

 This is the private shared implementation of GTUITabBar and GTUIBottomNavigationBar. It should not
 be used directly and is not guaranteed to have a stable API.
 */
@interface GTUIItemBar : UIView

/** Return the default height for the item bar given a style. */
+ (CGFloat)defaultHeightForStyle:(nonnull GTUIItemBarStyle *)style;

/**
 Items displayed in the item bar.

 The bar determines the newly-selected item using the following logic:
 * Reselect the previously-selected item if it's still present in `items` after the update.
 * If there was no selection previously or if the old selected item is gone, select the first item.
 Clients that need empty selection to be preserved across updates to `items` must manually reset
 selectedItem to nil after the update.

 Changes to this property are not animated.
 */
@property(nonatomic, copy, nonnull) NSArray<UITabBarItem *> *items;

/**
 The currently selected item. May be nil if `items` is empty.

 Changes to `selectedItem` are not animated.
 */
@property(nonatomic, strong, nullable) UITabBarItem *selectedItem;

/** The item bar's delegate. */
@property(nonatomic, weak, nullable) id<GTUIItemBarDelegate> delegate;

/**
 Select an item with optional animation. Raises an NSInvalidArgumentException if selectedItem is
 not in `items`.
 */
- (void)setSelectedItem:(nullable UITabBarItem *)selectedItem animated:(BOOL)animated;

/**
 Horizontal alignment of items. Changes are not animated. Default alignment is
 GTUIItemBarAlignmentLeading.
 */
@property(nonatomic) GTUIItemBarAlignment alignment;

/** Updates the alignment with optional animation. */
- (void)setAlignment:(GTUIItemBarAlignment)alignment animated:(BOOL)animated;

#pragma mark - Styling

/** Updates the bar to use the given style properties. */
- (void)applyStyle:(nonnull GTUIItemBarStyle *)itemStyle;

@end

/**
 Delegate protocol for GTUIItemBar. Clients may implement this protocol to receive notifications of
 selection changes.
 */
@protocol GTUIItemBarDelegate <NSObject>
/**
 Called before the selected item changes by user action. This method is not called for programmatic
 changes to the bar's selected item. Return YES to allow the selection.
 */
- (BOOL)itemBar:(nonnull GTUIItemBar *)itemBar shouldSelectItem:(nonnull UITabBarItem *)item;

/**
 Called when the selected item changes by user action. This method is not called for programmatic
 changes to the bar's selected item.
 */
- (void)itemBar:(nonnull GTUIItemBar *)itemBar didSelectItem:(nonnull UITabBarItem *)item;

@end

#pragma mark -

/** Accessibility-related methods on GTUIItemBar. */
@interface GTUIItemBar (GTUIItemBarAccessibility)

/**
 * Get the accessibility element representing the given item. Returns nil if item is not in `items`
 * or if the item is not on screen.
 *
 * The accessibility element returned from this method may be used as the focused element after a
 * run loop iteration.
 */
- (nullable id)accessibilityElementForItem:(nonnull UITabBarItem *)item;

@end
