//
//  GTUIToolBarView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//
#import <CoreGraphics/CoreGraphics.h>

#import "GTUIToolBarView.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTNavigationBar.h"
#import "private/GTUIToolBarAttributes.h"
#import "private/GTUIToolBarLayer.h"

static NSString *kGTUIToolBarViewAnimKeyString = @"AnimKey";
static NSString *kGTUIToolBarViewPathString = @"path";
static NSString *kGTUIToolBarViewPositionString = @"position";
static const CGFloat kGTUIToolBarViewFloatingButtonCenterToNavigationBarTopOffset = 0.f;
static const CGFloat kGTUIToolBarViewFloatingButtonElevationPrimary = 6.f;
static const CGFloat kGTUIToolBarViewFloatingButtonElevationSecondary = 4.f;
static const int kGTUIButtonAnimationDuration = 200;

@interface GTUIToolBarCutView : UIView

@end

@implementation GTUIToolBarCutView

// Allows touch events to pass through so GTUIToolBarController can handle touch events.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view == self ? nil : view;
}

@end

@interface GTUIToolBarView () <CAAnimationDelegate>

@property(nonatomic, assign) CGFloat bottomBarHeight;
@property(nonatomic, strong) GTUIToolBarCutView *cutView;
@property(nonatomic, strong) GTUIToolBarLayer *bottomBarLayer;
@property(nonatomic, strong) GTUINavigationBar *navBar;
@property(nonatomic, assign) UIUserInterfaceLayoutDirection layoutDirection;

@end


@implementation GTUIToolBarView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTUIToolBarViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTUIToolBarViewInit];
    }
    return self;
}

- (void)commonGTUIToolBarViewInit {
    self.cutView = [[GTUIToolBarCutView alloc] initWithFrame:self.bounds];
    self.floatingButtonVerticalOffset =
    kGTUIToolBarViewFloatingButtonCenterToNavigationBarTopOffset;
    [self addSubview:self.cutView];

    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                             UIViewAutoresizingFlexibleLeftMargin |
                             UIViewAutoresizingFlexibleRightMargin);
    self.layoutDirection = self.gtf_effectiveUserInterfaceLayoutDirection;

    [self addFloatingButton];
    [self addBottomBarLayer];
    [self addNavBar];
}

- (void)addFloatingButton {
    GTUIFloatingButton *floatingButton = [[GTUIFloatingButton alloc] init];
    [self setFloatingButton:floatingButton];
    [self setFloatingButtonPosition:GTUIToolBarFloatingButtonPositionCenter];
    [self setFloatingButtonElevation:GTUIToolBarFloatingButtonElevationPrimary];
    [self setFloatingButtonHidden:NO];
}

- (void)addNavBar {
    _navBar = [[GTUINavigationBar alloc] initWithFrame:CGRectZero];
    [self addSubview:_navBar];

    _navBar.backgroundColor = [UIColor clearColor];
    _navBar.tintColor = [UIColor blackColor];
    _navBar.leadingBarItemsTintColor = UIColor.blackColor;
    _navBar.trailingBarItemsTintColor = UIColor.blackColor;
}

- (void)addBottomBarLayer {
    if (_bottomBarLayer) {
        [_bottomBarLayer removeFromSuperlayer];
    }
    _bottomBarLayer = [GTUIToolBarLayer layer];
    [_cutView.layer addSublayer:_bottomBarLayer];
}

- (void)renderPathBasedOnFloatingButtonVisibitlityAnimated:(BOOL)animated {
    if (!self.floatingButtonHidden) {
        [self cutBottomAppBarViewAnimated:animated];
    } else {
        [self healBottomAppBarViewAnimated:animated];
    }
}

- (CGPoint)getFloatingButtonCenterPositionForAppBarWidth:(CGFloat)appBarWidth {
    CGPoint floatingButtonPoint = CGPointZero;
    CGFloat navigationBarTopEdgeYOffset = CGRectGetMinY(self.navBar.frame);
    CGFloat midX = appBarWidth / 2;

    floatingButtonPoint.y =
    MAX(0.0f, navigationBarTopEdgeYOffset - self.floatingButtonVerticalOffset);
    switch (self.floatingButtonPosition) {
        case GTUIToolBarFloatingButtonPositionLeading: {
            if (self.layoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) {
                floatingButtonPoint.x = kGTUIToolBarFloatingButtonPositionX;
            } else {
                floatingButtonPoint.x = appBarWidth - kGTUIToolBarFloatingButtonPositionX;
            }
            break;
        }
        case GTUIToolBarFloatingButtonPositionCenter: {
            floatingButtonPoint.x = midX;
            break;
        }
        case GTUIToolBarFloatingButtonPositionTrailing: {
            if (self.layoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) {
                floatingButtonPoint.x = appBarWidth - kGTUIToolBarFloatingButtonPositionX;
            } else {
                floatingButtonPoint.x = kGTUIToolBarFloatingButtonPositionX;
            }
            break;
        }
        default:
            break;
    }

    return floatingButtonPoint;
}

- (void)cutBottomAppBarViewAnimated:(BOOL)animated {
    CGPathRef pathWithCut = [self.bottomBarLayer pathFromRect:self.bounds
                                               floatingButton:self.floatingButton
                                           navigationBarFrame:self.navBar.frame
                                                    shouldCut:YES];
    if (animated) {
        CABasicAnimation *pathAnimation =
        [CABasicAnimation animationWithKeyPath:kGTUIToolBarViewPathString];
        pathAnimation.duration = kGTUIFloatingButtonExitDuration;
        pathAnimation.fromValue = (id)self.bottomBarLayer.presentationLayer.path;
        pathAnimation.toValue = (__bridge id _Nullable)(pathWithCut);
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.delegate = self;
        [pathAnimation setValue:kGTUIToolBarViewPathString
                         forKey:kGTUIToolBarViewAnimKeyString];
        [self.bottomBarLayer addAnimation:pathAnimation forKey:kGTUIToolBarViewPathString];
    } else {
        self.bottomBarLayer.path = pathWithCut;
    }
}

- (void)healBottomAppBarViewAnimated:(BOOL)animated  {
    CGPathRef pathWithoutCut = [self.bottomBarLayer pathFromRect:self.bounds
                                                  floatingButton:self.floatingButton
                                              navigationBarFrame:self.navBar.frame
                                                       shouldCut:NO];
    if (animated) {
        CABasicAnimation *pathAnimation =
        [CABasicAnimation animationWithKeyPath:kGTUIToolBarViewPathString];
        pathAnimation.duration = kGTUIFloatingButtonEnterDuration;
        pathAnimation.fromValue = (id)self.bottomBarLayer.presentationLayer.path;
        pathAnimation.toValue = (__bridge id _Nullable)(pathWithoutCut);
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.delegate = self;
        [pathAnimation setValue:kGTUIToolBarViewPathString
                         forKey:kGTUIToolBarViewAnimKeyString];
        [self.bottomBarLayer addAnimation:pathAnimation forKey:kGTUIToolBarViewPathString];
    } else {
        self.bottomBarLayer.path = pathWithoutCut;
    }
}

- (void)moveFloatingButtonCenterAnimated:(BOOL)animated {
    CGPoint endPoint =
    [self getFloatingButtonCenterPositionForAppBarWidth:CGRectGetWidth(self.bounds)];
    if (animated) {
        CABasicAnimation *animation =
        [CABasicAnimation animationWithKeyPath:kGTUIToolBarViewPositionString];
        animation.duration = kGTUIFloatingButtonExitDuration;
        animation.fromValue = [NSValue valueWithCGPoint:self.floatingButton.center];
        animation.toValue = [NSValue valueWithCGPoint:endPoint];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.delegate = self;
        [animation setValue:kGTUIToolBarViewPositionString
                     forKey:kGTUIToolBarViewAnimKeyString];
        [self.floatingButton.layer addAnimation:animation forKey:kGTUIToolBarViewPositionString];
    }
    self.floatingButton.center = endPoint;
}

- (void)showBarButtonItemsWithFloatingButtonPosition:(GTUIToolBarFloatingButtonPosition)floatingButtonPosition {
    switch (floatingButtonPosition) {
        case GTUIToolBarFloatingButtonPositionCenter:
            [self.navBar setLeadingBarButtonItems:_leadingBarButtonItems];
            [self.navBar setTrailingBarButtonItems:_trailingBarButtonItems];
            break;
        case GTUIToolBarFloatingButtonPositionLeading:
            [self.navBar setLeadingBarButtonItems:nil];
            [self.navBar setTrailingBarButtonItems:_trailingBarButtonItems];
            break;
        case GTUIToolBarFloatingButtonPositionTrailing:
            [self.navBar setLeadingBarButtonItems:_leadingBarButtonItems];
            [self.navBar setTrailingBarButtonItems:nil];
            break;
        default:
            break;
    }
}

#pragma mark - UIView overrides

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect navBarFrame =
    CGRectMake(0, kGTUIToolBarNavigationViewYOffset, CGRectGetWidth(self.bounds),
               kGTUIToolBarHeight - kGTUIToolBarNavigationViewYOffset);
    self.navBar.frame = navBarFrame;

    self.floatingButton.center =
    [self getFloatingButtonCenterPositionForAppBarWidth:CGRectGetWidth(self.bounds)];
    [self renderPathBasedOnFloatingButtonVisibitlityAnimated:NO];
}

- (UIEdgeInsets)gtui_safeAreaInsets {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {

        // Accommodate insets for iPhone X.
        insets = self.safeAreaInsets;
    }
    return insets;
}

- (CGSize)sizeThatFits:(CGSize)size {
    UIEdgeInsets insets = self.gtui_safeAreaInsets;
    CGFloat heightWithInset = kGTUIToolBarHeight + insets.bottom;
    CGSize insetSize = CGSizeMake(size.width, heightWithInset);
    return insetSize;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    // Make sure the floating button can always be tapped.
    BOOL contains = CGRectContainsPoint(self.floatingButton.frame, point);
    if (contains) {
        return self.floatingButton;
    }
    UIView *view = [super hitTest:point withEvent:event];
    return view;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if (flag) {
        [self renderPathBasedOnFloatingButtonVisibitlityAnimated:NO];
        NSString *animValueForKeyString = [animation valueForKey:kGTUIToolBarViewAnimKeyString];
        if ([animValueForKeyString isEqualToString:kGTUIToolBarViewPathString]) {
            [self.bottomBarLayer removeAnimationForKey:kGTUIToolBarViewPathString];
        } else if ([animValueForKeyString isEqualToString:kGTUIToolBarViewPositionString]) {
            [self.floatingButton.layer removeAnimationForKey:kGTUIToolBarViewPositionString];
        }
    }
}

#pragma mark - Setters

- (void)setFloatingButton:(GTUIFloatingButton *)floatingButton {
    if (_floatingButton == floatingButton) {
        return;
    }
    [_floatingButton removeFromSuperview];
    _floatingButton = floatingButton;
    _floatingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_floatingButton sizeToFit];
}

- (void)setFloatingButtonElevation:(GTUIToolBarFloatingButtonElevation)floatingButtonElevation {
    [self setFloatingButtonElevation:floatingButtonElevation animated:NO];
}

- (void)setFloatingButtonElevation:(GTUIToolBarFloatingButtonElevation)floatingButtonElevation
                          animated:(BOOL)animated {
    if (_floatingButton.superview == self && _floatingButtonElevation == floatingButtonElevation) {
        return;
    }
    _floatingButtonElevation = floatingButtonElevation;

    CGFloat elevation = kGTUIToolBarViewFloatingButtonElevationPrimary;
    NSInteger subViewIndex = 1;
    if (floatingButtonElevation == GTUIToolBarFloatingButtonElevationSecondary) {
        elevation = kGTUIToolBarViewFloatingButtonElevationSecondary;
        subViewIndex = 0;
    }
    if (animated) {
        [_floatingButton setElevation:1 forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kGTUIButtonAnimationDuration * NSEC_PER_MSEC),
                       dispatch_get_main_queue(), ^{
                           [self insertSubview:self.floatingButton atIndex:subViewIndex];
                           [self.floatingButton setElevation:elevation forState:UIControlStateNormal];
                       });
    } else {
        [self insertSubview:_floatingButton atIndex:subViewIndex];
        [_floatingButton setElevation:elevation forState:UIControlStateNormal];
    }
}

- (void)setFloatingButtonPosition:(GTUIToolBarFloatingButtonPosition)floatingButtonPosition {
    [self setFloatingButtonPosition:floatingButtonPosition animated:NO];
}

- (void)setFloatingButtonPosition:(GTUIToolBarFloatingButtonPosition)floatingButtonPosition
                         animated:(BOOL)animated {
    if (_floatingButtonPosition == floatingButtonPosition) {
        return;
    }
    _floatingButtonPosition = floatingButtonPosition;
    [self moveFloatingButtonCenterAnimated:animated];
    [self renderPathBasedOnFloatingButtonVisibitlityAnimated:animated];
    [self showBarButtonItemsWithFloatingButtonPosition:floatingButtonPosition];
}

- (void)setFloatingButtonHidden:(BOOL)floatingButtonHidden {
    [self setFloatingButtonHidden:floatingButtonHidden animated:NO];
}

- (void)setFloatingButtonHidden:(BOOL)floatingButtonHidden animated:(BOOL)animated {
    if (_floatingButtonHidden == floatingButtonHidden) {
        return;
    }
    _floatingButtonHidden = floatingButtonHidden;
    if (floatingButtonHidden) {
        [self healBottomAppBarViewAnimated:animated];
        [_floatingButton collapse:animated completion:^{
            self.floatingButton.hidden = YES;
        }];
    } else {
        _floatingButton.hidden = NO;
        [self cutBottomAppBarViewAnimated:animated];
        [_floatingButton expand:animated completion:nil];
    }
}

- (void)setLeadingBarButtonItems:(NSArray<UIBarButtonItem *> *)leadingBarButtonItems {
    _leadingBarButtonItems = [leadingBarButtonItems copy];
    [self showBarButtonItemsWithFloatingButtonPosition:self.floatingButtonPosition];
}

- (void)setTrailingBarButtonItems:(NSArray<UIBarButtonItem *> *)trailingBarButtonItems {
    _trailingBarButtonItems = [trailingBarButtonItems copy];
    [self showBarButtonItemsWithFloatingButtonPosition:self.floatingButtonPosition];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    _bottomBarLayer.fillColor = barTintColor.CGColor;
}

- (UIColor *)barTintColor {
    return [UIColor colorWithCGColor:_bottomBarLayer.fillColor];
}

- (void)setLeadingBarItemsTintColor:(UIColor *)leadingBarItemsTintColor {
    NSParameterAssert(leadingBarItemsTintColor);
    if (!leadingBarItemsTintColor) {
        leadingBarItemsTintColor = UIColor.blackColor;
    }
    self.navBar.leadingBarItemsTintColor = leadingBarItemsTintColor;
}

- (UIColor *)leadingBarItemsTintColor {
    return self.navBar.leadingBarItemsTintColor;
}

- (void)setTrailingBarItemsTintColor:(UIColor *)trailingBarItemsTintColor {
    NSParameterAssert(trailingBarItemsTintColor);
    if (!trailingBarItemsTintColor) {
        trailingBarItemsTintColor = UIColor.blackColor;
    }
    self.navBar.trailingBarItemsTintColor = trailingBarItemsTintColor;
}

- (UIColor *)trailingBarItemsTintColor {
    return self.navBar.trailingBarItemsTintColor;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _bottomBarLayer.shadowColor = shadowColor.CGColor;
}

- (UIColor *)shadowColor {
    return [UIColor colorWithCGColor:_bottomBarLayer.shadowColor];
}


@end
