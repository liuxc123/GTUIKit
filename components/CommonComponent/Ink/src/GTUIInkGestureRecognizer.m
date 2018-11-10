//
//  GTUIInkGestureRecognizer.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUIInkGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

static const CGFloat kInkGestureDefaultDragCancelDistance = 20;

@implementation GTUIInkGestureRecognizer{
    CGPoint _touchStartLocation;
    CGPoint _touchCurrentLocation;
    BOOL _cancelOnDragOut;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        _cancelOnDragOut = YES;
        _dragCancelDistance = kInkGestureDefaultDragCancelDistance;
        _targetBounds = CGRectNull;
        self.cancelsTouchesInView = NO;
        self.delaysTouchesEnded = NO;
    }
    return self;
}

- (CGPoint)touchStartLocationInView:(UIView *)view {
    return [view convertPoint:_touchStartLocation fromView:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([touches count] == 1) {
        self.state = UIGestureRecognizerStateBegan;
        _touchStartLocation = [[touches anyObject] locationInView:nil];
        _touchCurrentLocation = _touchStartLocation;
    } else {
        self.state = UIGestureRecognizerStateCancelled;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) {
        return;
    }

    _touchCurrentLocation = [[touches anyObject] locationInView:nil];

    // Cancel the gesture if it is too far away.
    if (_cancelOnDragOut && ![self isTouchWithinTargetBounds]) {
        self.state = UIGestureRecognizerStateCancelled;
    } else {
        self.state = UIGestureRecognizerStateChanged;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
}

- (BOOL)isTouchWithinTargetBounds {
    CGRect targetBounds = [self effectiveTargetBounds];
    CGRect boundsInWindowCoord = [self.view convertRect:targetBounds toView:nil];
    boundsInWindowCoord =
    CGRectInset(boundsInWindowCoord, -_dragCancelDistance, -_dragCancelDistance);
    return CGRectContainsPoint(boundsInWindowCoord, _touchCurrentLocation);
}

#pragma mark - Private methods

- (CGRect)effectiveTargetBounds {
    return CGRectEqualToRect(_targetBounds, CGRectNull) ? self.view.bounds : _targetBounds;
}


@end
