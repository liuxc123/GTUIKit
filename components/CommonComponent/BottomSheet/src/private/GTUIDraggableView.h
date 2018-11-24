//
//  GTUIDraggableView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import <UIKit/UIKit.h>

@protocol GTUIDraggableViewDelegate;

@interface GTUIDraggableView : UIView

/**
 * The @c UIScrollView passed in the initializer.
 */
@property(nonatomic, strong, readonly, nullable) UIScrollView *scrollView;

/**
 * Delegate for handling drag events.
 */
@property(nonatomic, weak, nullable) id <GTUIDraggableViewDelegate> delegate;

/**
 * Initializes a GTUIDraggableView.
 *
 * @param frame Initial frame for the view.
 * @param scrollView A @c UIScrollView contained as a subview of this view. The view will block
 *  scrolling of the content in the scrollview when it is being drag-resized. This can be nil.
 */
- (nonnull instancetype)initWithFrame:(CGRect)frame
                           scrollView:(nullable UIScrollView *)scrollView NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(nullable NSCoder *)aDecoder NS_UNAVAILABLE;

@end

/**
 * Delegate protocol to control when dragging should be allowed and to respond to dragging events.
 */
@protocol GTUIDraggableViewDelegate <NSObject>

/**
 * Allows the delegate to specify a maximum threshold height that the view cannot be dragged above.
 * @param view The draggable view.
 * @return The maximum height this view can be dragged to be.
 */
- (CGFloat)maximumHeightForDraggableView:(nonnull GTUIDraggableView *)view;

/**
 * Called when an attempt is made to drag the view up or down.
 * @return NO to prevent a new drag from starting.
 * @param view The draggable view.
 * @param velocity The current velocity of the drag gesture. This only contains a vertical
 *   component.
 */
- (BOOL)draggableView:(nonnull GTUIDraggableView *)view
shouldBeginDraggingWithVelocity:(CGPoint)velocity;

/**
 * Called when a new drag starts.
 * @param view The draggable view.
 */
- (void)draggableViewBeganDragging:(nonnull GTUIDraggableView *)view;

/**
 * Called when a drag ends.
 * @param view The draggable view.
 * @param velocity The current velocity of the drag gesture. This only contains a vertical
 *   component.
 */
- (void)draggableView:(nonnull GTUIDraggableView *)view draggingEndedWithVelocity:(CGPoint)velocity;

@end

