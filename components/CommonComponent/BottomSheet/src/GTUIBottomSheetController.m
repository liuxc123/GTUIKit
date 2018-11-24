//
//  GTUIBottomSheetController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import "GTUIBottomSheetController.h"

#import "GTUIBottomSheetPresentationController.h"
#import "GTUIBottomSheetTransitionController.h"
#import "UIViewController+GTUIBottomSheet.h"

@interface GTUIBottomSheetController () <GTUIBottomSheetPresentationControllerDelegate>
@property(nonatomic, readonly, strong) GTUIShapedView *view;
@end

@implementation GTUIBottomSheetController {
    GTUIBottomSheetTransitionController *_transitionController;
    NSMutableDictionary<NSNumber *, id<GTUIShapeGenerating>> *_shapeGenerators;
}

@dynamic view;

- (void)loadView {
    self.view = [[GTUIShapedView alloc] initWithFrame:CGRectZero];
}

- (nonnull instancetype)initWithContentViewController:
(nonnull UIViewController *)contentViewController {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _contentViewController = contentViewController;
        _transitionController = [[GTUIBottomSheetTransitionController alloc] init];
        _transitionController.dismissOnBackgroundTap = YES;
        super.transitioningDelegate = _transitionController;
        super.modalPresentationStyle = UIModalPresentationCustom;
        _shapeGenerators = [NSMutableDictionary dictionary];
        _state = GTUISheetStatePreferred;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contentViewController.view.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.contentViewController];
    [self.view addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.gtui_bottomSheetPresentationController.delegate = self;
#pragma clang diagnostic pop

    self.gtui_bottomSheetPresentationController.dismissOnBackgroundTap =
    _transitionController.dismissOnBackgroundTap;

    [self.contentViewController.view layoutIfNeeded];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.contentViewController.supportedInterfaceOrientations;
}

- (BOOL)accessibilityPerformEscape {
    if (!self.dismissOnBackgroundTap) {
        return NO;
    }
    __weak __typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.delegate bottomSheetControllerDidDismissBottomSheet:weakSelf];
    }];
    return YES;
}

- (CGSize)preferredContentSize {
    return self.contentViewController.preferredContentSize;
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize {
    self.contentViewController.preferredContentSize = preferredContentSize;
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    // Informing the presentation controller of the change in preferred content size needs to be done
    // directly since the GTUIBottomSheetController's preferredContentSize property is backed by
    // contentViewController's preferredContentSize. Therefore |[super setPreferredContentSize:]| is
    // never called, and UIKit never calls |preferredContentSizeDidChangeForChildContentContainer:|
    // on the presentation controller.
    [self.presentationController preferredContentSizeDidChangeForChildContentContainer:self];
}

- (UIScrollView *)trackingScrollView {
    return _transitionController.trackingScrollView;
}

- (void)setTrackingScrollView:(UIScrollView *)trackingScrollView {
    _transitionController.trackingScrollView = trackingScrollView;
}

- (BOOL)dismissOnBackgroundTap {
    return _transitionController.dismissOnBackgroundTap;
}

- (void)setDismissOnBackgroundTap:(BOOL)dismissOnBackgroundTap {
    _transitionController.dismissOnBackgroundTap = dismissOnBackgroundTap;
    self.gtui_bottomSheetPresentationController.dismissOnBackgroundTap = dismissOnBackgroundTap;
}

- (void)bottomSheetWillChangeState:(GTUIBottomSheetPresentationController *)bottomSheet
                        sheetState:(GTUISheetState)sheetState {
    _state = sheetState;
    [self updateShapeGenerator];
}

- (id<GTUIShapeGenerating>)shapeGeneratorForState:(GTUISheetState)state {
    id<GTUIShapeGenerating> shapeGenerator = _shapeGenerators[@(state)];
    if (state != GTUISheetStateClosed && shapeGenerator == nil) {
        shapeGenerator = _shapeGenerators[@(GTUISheetStateClosed)];
    }
    if (shapeGenerator != nil) {
        return shapeGenerator;
    }
    return nil;
}

- (void)setShapeGenerator:(id<GTUIShapeGenerating>)shapeGenerator
                 forState:(GTUISheetState)state {
    _shapeGenerators[@(state)] = shapeGenerator;

    [self updateShapeGenerator];
}

- (void)updateShapeGenerator {
    id<GTUIShapeGenerating> shapeGenerator = [self shapeGeneratorForState:_state];
    if (self.view.shapeGenerator != shapeGenerator) {
        self.view.shapeGenerator = shapeGenerator;
        if (shapeGenerator != nil) {
            self.contentViewController.view.layer.mask =
            ((GTUIShapedShadowLayer *)self.view.layer).shapeLayer;
        } else {
            self.contentViewController.view.layer.mask = nil;
        }
    }
}

/* Disable setter. Always use internal transition controller */
- (void)setTransitioningDelegate:
(__unused id<UIViewControllerTransitioningDelegate>)transitioningDelegate {
    NSAssert(NO, @"GTUIBottomSheetController.transitioningDelegate cannot be changed.");
    return;
}

/* Disable setter. Always use custom presentation style */
- (void)setModalPresentationStyle:(__unused UIModalPresentationStyle)modalPresentationStyle {
    NSAssert(NO, @"GTUIBottomSheetController.modalPresentationStyle cannot be changed.");
    return;
}

- (void)setIsScrimAccessibilityElement:(BOOL)isScrimAccessibilityElement {
    _transitionController.isScrimAccessibilityElement = isScrimAccessibilityElement;
}

- (BOOL)isScrimAccessibilityElement {
    return _transitionController.isScrimAccessibilityElement;
}

- (void)setScrimAccessibilityLabel:(NSString *)scrimAccessibilityLabel {
    _transitionController.scrimAccessibilityLabel = scrimAccessibilityLabel;
}

- (NSString *)scrimAccessibilityLabel {
    return _transitionController.scrimAccessibilityLabel;
}

- (void)setScrimAccessibilityHint:(NSString *)scrimAccessibilityHint {
    _transitionController.scrimAccessibilityHint = scrimAccessibilityHint;
}

- (NSString *)scrimAccessibilityHint {
    return _transitionController.scrimAccessibilityHint;
}

- (void)setScrimAccessibilityTraits:(UIAccessibilityTraits)scrimAccessibilityTraits {
    _transitionController.scrimAccessibilityTraits = scrimAccessibilityTraits;
}

- (UIAccessibilityTraits)scrimAccessibilityTraits {
    return _transitionController.scrimAccessibilityTraits;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)bottomSheetPresentationControllerDidDismissBottomSheet:
(nonnull __unused GTUIBottomSheetPresentationController *)bottomSheet {
#pragma clang diagnostic pop
    [self.delegate bottomSheetControllerDidDismissBottomSheet:self];
}

@end
