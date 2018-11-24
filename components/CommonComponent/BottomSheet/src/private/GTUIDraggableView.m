//
//  GTUIDraggableView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import "GTUIDraggableView.h"

static void CancelGestureRecognizer(UIGestureRecognizer *gesture) {
    if (gesture.enabled) {
        // Setting enabled to NO while a gesture recognizer is currently recognizing a gesture will
        // transition it to a cancelled state.
        gesture.enabled = NO;
        gesture.enabled = YES;
    }
}

@interface GTUIDraggableView ()<UIGestureRecognizerDelegate>
@property(nonatomic) UIPanGestureRecognizer *dragRecognizer;
@property(nonatomic, strong) UIScrollView *scrollView;
@end

@implementation GTUIDraggableView

- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = scrollView;
        _dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(didPan:)];
        _dragRecognizer.maximumNumberOfTouches = 1;
        _dragRecognizer.delegate = self;
        [self addGestureRecognizer:_dragRecognizer];

        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - Gesture handling

- (void)didPan:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer translationInView:self.superview];

    // Ensure that dragging the sheet past the maximum height results in an exponential decay on the
    // translation. This gives the same effect as when you overscroll a scrollview.
    CGFloat newHeight = CGRectGetMaxY(self.superview.bounds) - CGRectGetMinY(self.frame);
    if (newHeight > [self.delegate maximumHeightForDraggableView:self]) {
        point.y -= point.y / 1.2;
    }

    self.center = CGPointMake(self.center.x, self.center.y + point.y);
    [recognizer setTranslation:CGPointZero inView:self.superview];

    CGPoint velocity = [recognizer velocityInView:self.superview];
    velocity.x = 0;

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.delegate draggableViewBeganDragging:self];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate draggableView:self draggingEndedWithVelocity:velocity];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer {
    // When opening the control center while a GTUIBottomSheet is displayed recognizer happens to be
    // an object of _UISystemGestureGateGestureRecognizer which doesn't have velocityInView: and it
    // crashes the app.
    if (recognizer != self.dragRecognizer) {
        return NO;
    }

    CGPoint velocity = [recognizer velocityInView:self.superview];
    velocity.x = 0;

    if ([self.delegate draggableView:self shouldBeginDraggingWithVelocity:velocity]) {
        // If dragging the pane, don't allow the content to scroll at the same time.
        CancelGestureRecognizer(self.scrollView.panGestureRecognizer);
        return YES;
    } else {
        return NO;
    }
}

// Allow the drag recogniser to recognize alongside the embedded scrollview's pan gesture.
- (BOOL)gestureRecognizer:(__unused UIGestureRecognizer *)recognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    if (otherGestureRecognizer == self.scrollView.panGestureRecognizer) {
        return YES;
    }
    return NO;
}

@end
