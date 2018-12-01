//
//  GTUIOverlayWindow.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import "GTUIOverlayWindow.h"

#import <objc/runtime.h>

#import "GTApplication.h"


/**
 A container view for overlay views.

 Used by GTUIOverlayWindow, overlay views are added to the overlay window container when
 @c activateOverlay is called and removed from the overlay window when @c deactivateOverlay is
 called.
 */
@interface GTUIOverlayWindowContainerView : UIView
@end

@interface GTUIOverlayWindow ()

@property(nonatomic, strong) NSMutableArray *overlays;
@property(nonatomic, strong) GTUIOverlayWindowContainerView *overlayView;

// Forward declaration so that GTUIOverlayWindowContainerView can call this method.
- (void)noteOverlayRemoved:(UIView *)overlay;

@end

@implementation GTUIOverlayWindowContainerView

- (void)willRemoveSubview:(UIView *)subview {
    [super willRemoveSubview:subview];

    GTUIOverlayWindow *window = (GTUIOverlayWindow *)self.window;
    [window noteOverlayRemoved:subview];
}

// Only allow a tap if it explicitly hit one of the overlays. Otherwise, behave as if this view
// doesn't exist at all.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    return hitView == self ? nil : hitView;
}

@end

@implementation GTUIOverlayWindow

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];

    _overlays = [[NSMutableArray alloc] init];

    _overlayView = [[GTUIOverlayWindowContainerView alloc] initWithFrame:self.bounds];
    _overlayView.autoresizingMask =
    (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _overlayView.backgroundColor = [UIColor clearColor];
    [self addSubview:_overlayView];

    // Set a sane hidden state.
    [self updateOverlayHiddenState];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Window positioning

// Regardless of what was added to this window, ensure that the overlay view is on top.
- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];

    [self bringSubviewToFront:self.overlayView];
}

#pragma mark - Overlay Activation

- (void)updateOverlayHiddenState {
    BOOL hasOverlays = [self.overlays count] > 0;
    self.overlayView.hidden = !hasOverlays;
    [self updateAccessibilityIsModal];
}

- (void)updateAccessibilityIsModal {
    BOOL containsModal = NO;
    for (UIView *overlay in self.overlays) {
        if (overlay.accessibilityViewIsModal) {
            containsModal = YES;
            break;
        }
    }
    self.overlayView.accessibilityViewIsModal = containsModal;
}

- (void)noteOverlayRemoved:(UIView *)overlay {
    if (!overlay) {
        return;
    }

    // If the overlay argument wasn't managed by us, don't do anything when it goes away.
    if (![self.overlays containsObject:overlay]) {
        return;
    }

    // Clean up the level information stored on the view.
    [self removeLevelForOverlay:overlay];

    // Stop tracking the overlay view.
    [self.overlays removeObject:overlay];

    // Show or hide ourself as needed.
    [self updateOverlayHiddenState];
}

- (void)activateOverlay:(UIView *)overlay withLevel:(UIWindowLevel)level {
    if (!overlay) {
        return;
    }

    // Make sure the that the overlay is out of the view hierarchy, even our own (if this is a
    // re-activation with a new level). If @c overlay is already in the overlay view, then this call
    // will take care of cleaning up @c self.overlays, by way of @c noteOverlayRemoved:.
    [overlay removeFromSuperview];

    // Default to adding the overlay at the very end (on top) of all the other overlays. We'll check
    // the existing overlays to see if this one needs to go in before.
    __block NSUInteger insertionIndex = self.overlays.count;

    // Because @c self.overlays is already sorted by level, we can pick the first index which has a
    // level larger than @c level.
    [self.overlays enumerateObjectsUsingBlock:^(UIView *existing, NSUInteger idx, BOOL *stop) {
        UIWindowLevel existingLevel = [self windowLevelForOverlay:existing];
        if (level < existingLevel) {
            insertionIndex = idx;
            *stop = YES;
        }
    }];

    // Make sure that the overlay is as large as the overlay container view before adding it.
    overlay.bounds = self.overlayView.bounds;
    overlay.center = CGPointMake(CGRectGetMidX(overlay.bounds), CGRectGetMidY(overlay.bounds));
    overlay.translatesAutoresizingMaskIntoConstraints = YES;
    overlay.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    [self setLevel:level forOverlay:overlay];
    [self.overlayView insertSubview:overlay atIndex:insertionIndex];
    [self.overlays insertObject:overlay atIndex:insertionIndex];

    [self updateOverlayHiddenState];
}

- (void)deactivateOverlay:(UIView *)overlay {
    if (!overlay) {
        return;
    }

    // If the overlay wasn't managed by us, don't do anything to deactivate it.
    if (![self.overlays containsObject:overlay]) {
        return;
    }

    // If @c overlay is already in the overlay view, then this call will take care of cleaning up
    // @c self.overlays by way of @c noteOverlayRemoved:.
    [overlay removeFromSuperview];
}

#pragma mark - Level Storage

static char kLevelKey;

- (UIWindowLevel)windowLevelForOverlay:(__unused UIView *)overlay {
    NSNumber *levelObject = objc_getAssociatedObject(self, &kLevelKey);
    return [levelObject floatValue];
}

- (void)setLevel:(UIWindowLevel)level forOverlay:(UIView *)overlay {
    NSNumber *levelObject = @(level);
    objc_setAssociatedObject(overlay, &kLevelKey, levelObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)removeLevelForOverlay:(UIView *)overlay {
    objc_setAssociatedObject(overlay, &kLevelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

