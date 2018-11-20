//
//  GTUIStatusBarShifter.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import <UIKit/UIKit.h>

@protocol GTUIStatusBarShifterDelegate;

/**
 The status bar shifter is responsible for the management of the status bar's offset as a header
 view is shifting off-screen.

 This class is not intended to be subclassed.
 */
@interface GTUIStatusBarShifter : NSObject

#pragma mark Shifting the status bar

/**
 Provides the status bar shifter with the current desired y offset of the status bar.

 A value of 0 means the status bar is unshifted. Values > 0 shift the status bar by that amount
 off-screen. Negative values are treated as zero.
 */
- (void)setOffset:(CGFloat)offset;

#pragma mark Configuring behavior

/**
 Whether or not the status bar shifter is enabled.

 If the status bar shifter is disabled midway through shifting the status bar then the shifter
 will move the status bar to a reasonable location.
 */
@property(nonatomic, getter=isEnabled) BOOL enabled;

/**
 A Boolean value indicating whether this class should use snapshotting when rendering the status
 bar shift.

 Defaults to YES.
 */
@property(nonatomic, getter=isSnapshottingEnabled) BOOL snapshottingEnabled;

#pragma mark Responding to state changes

@property(nonatomic, weak) id<GTUIStatusBarShifterDelegate> delegate;

#pragma mark Introspection

/**
 A Boolean value indicating whether the receiver is able to shift the status bar.

 There are certain scenarios where the status bar shifter won't try to adjust the frame of the
 status bar. For example, if the status bar is showing the tap-to-return-to-call effect. In these
 cases this method returns NO.
 */
- (BOOL)canUpdateStatusBarFrame;

#pragma mark UIViewController events

/**
 A Boolean value indicating whether the true status bar should be hidden.

 The implementor of GTUIStatusBarShifterDelegate should use this to inform UIKit of the expected
 status bar visibility via UIViewController::prefersStatusBarHidden.
 */
- (BOOL)prefersStatusBarHidden;

/** Must be called when the owning UIViewController's interface orientation is about to change. */
- (void)interfaceOrientationWillChange;

/** Must be called when the owning UIViewController's interface orientation has changed. */
- (void)interfaceOrientationDidChange;

/** Must be called when the owning UIViewController's view moves to a window. */
- (void)didMoveToWindow;

@end

/**
 The GTUIStatusBarShifterDelegate protocol allows a delegate to react to changes in the status bar
 shifter's state.
 */
@protocol GTUIStatusBarShifterDelegate <NSObject>
@required

/** Informs the receiver that the preferred status bar visibility has changed. */
- (void)statusBarShifterNeedsStatusBarAppearanceUpdate:(GTUIStatusBarShifter *)statusBarShifter;

/**
 Informs the receiver that a snapshot view would like to be added to a view hierarchy.

 The receiver is expected to add `view` as a subview. The superview should be shifting off-screen,
 which will cause the snapshot view to shift off-screen as well.
 */
- (void)statusBarShifter:(GTUIStatusBarShifter *)statusBarShifter
  wantsSnapshotViewAdded:(UIView *)view;

@end
