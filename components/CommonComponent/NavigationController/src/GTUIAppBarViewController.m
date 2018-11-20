//
//  GTUIAppBarViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUIAppBarViewController.h"

#import "GTUIAppBarContainerViewController.h"

#import <GTFInternationalization/GTFInternationalization.h>
#import <GTFTextAccessibility/GTFTextAccessibility.h>
#import "GTApplication.h"
#import "GTFlexibleHeader.h"
#import "GTShadowLayer.h"
#import "GTUIMetrics.h"
#import "GTIconFont.h"
static NSString *const kBarStackKey = @"barStack";


@implementation GTUIAppBarViewController {
    NSLayoutConstraint *_verticalConstraint;
    NSLayoutConstraint *_topSafeAreaConstraint;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self GTUIAppBarViewController_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self GTUIAppBarViewController_commonInit];
    }
    return self;
}

- (void)GTUIAppBarViewController_commonInit {
    // Shadow layer
    GTUIFlexibleHeaderShadowIntensityChangeBlock intensityBlock =
    ^(CALayer *_Nonnull shadowLayer, CGFloat intensity) {
        CGFloat elevation = GTUIShadowElevationAppBar * intensity;
        [(GTUIShadowLayer *)shadowLayer setElevation:elevation];
    };
    [self.headerView setShadowLayer:[GTUIShadowLayer layer] intensityDidChangeBlock:intensityBlock];

    [self.headerView forwardTouchEventsForView:self.headerStackView];
    [self.headerView forwardTouchEventsForView:self.navigationBar];

    self.headerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerStackView.topBar = self.navigationBar;
}

- (GTUIHeaderStackView *)headerStackView {
    // Removed call to loadView here as we should never be calling it manually.
    // It previously replaced loadViewIfNeeded call that is only iOS 9.0+ to
    // make backwards compatible.
    // Underlying issue is you need view loaded before accessing. Below change will accomplish that
    // by calling for view.bounds initializing the stack view
    if (!_headerStackView) {
        _headerStackView = [[GTUIHeaderStackView alloc] initWithFrame:CGRectZero];
    }
    return _headerStackView;
}

- (GTUINavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[GTUINavigationBar alloc] init];
    }
    return _navigationBar;
}

- (UIBarButtonItem *)backButtonItem {
    UIViewController *parent = self.parentViewController;
    UINavigationController *navigationController = parent.navigationController;

    NSArray<UIViewController *> *viewControllerStack = navigationController.viewControllers;

    // This will be zero if there is no navigation controller, so a view controller which is not
    // inside a navigation controller will be treated the same as a view controller at the root of a
    // navigation controller
    NSUInteger index = [viewControllerStack indexOfObject:parent];

    UIViewController *iterator = parent;

    // In complex cases it might actually be a parent of @c fhvParent which is on the nav stack.
    while (index == NSNotFound && iterator && ![iterator isEqual:navigationController]) {
        iterator = iterator.parentViewController;
        index = [viewControllerStack indexOfObject:iterator];
    }

    if (index == NSNotFound) {
        NSCAssert(NO, @"View controller not present in its own navigation controller.");
        // This is not something which should ever happen, but just in case.
        return nil;
    }
    if (index == 0) {
        // The view controller is at the root of a navigation stack (or not in one).
        return nil;
    }
    UIViewController *previousViewControler = navigationController.viewControllers[index - 1];
    if ([previousViewControler isKindOfClass:[GTUIAppBarContainerViewController class]]) {
        // Special case: if the previous view controller is a container controller, use its content
        // view controller.
        GTUIAppBarContainerViewController *chvc =
        (GTUIAppBarContainerViewController *)previousViewControler;
        previousViewControler = chvc.contentViewController;
    }
    UIBarButtonItem *backBarButtonItem = previousViewControler.navigationItem.backBarButtonItem;
    if (!backBarButtonItem) {
        UIImage *backButtonImage = [UIImage imageNamed:@"ic_arrow_back_ios" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        backButtonImage = [backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (self.navigationBar.gtf_effectiveUserInterfaceLayoutDirection ==
            UIUserInterfaceLayoutDirectionRightToLeft) {
            backButtonImage = [backButtonImage gtf_imageWithHorizontallyFlippedOrientation];
        }
        backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(didTapBackButton:)];
    }
    backBarButtonItem.accessibilityIdentifier = @"back_bar_button";
    backBarButtonItem.accessibilityLabel = @"back";
    return backBarButtonItem;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headerStackView];

    // Bar stack expands vertically, but has a margin above it for the status bar.
    NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint
                                                            constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[%@]|", kBarStackKey]
                                                            options:0
                                                            metrics:nil
                                                            views:@{kBarStackKey : self.headerStackView}];
    [self.view addConstraints:horizontalConstraints];

    CGFloat topMargin = GTUIDeviceTopSafeAreaInset();
    _verticalConstraint = [NSLayoutConstraint constraintWithItem:self.headerStackView
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.view
                                                       attribute:NSLayoutAttributeTop
                                                      multiplier:1
                                                        constant:topMargin];
    _verticalConstraint.active = !self.inferTopSafeAreaInsetFromViewController;

    _topSafeAreaConstraint =
    [NSLayoutConstraint constraintWithItem:self.headerView.topSafeAreaGuide
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.headerStackView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0];
    _topSafeAreaConstraint.active = self.inferTopSafeAreaInsetFromViewController;

    [NSLayoutConstraint constraintWithItem:self.headerStackView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0].active = YES;
}

- (void)setInferTopSafeAreaInsetFromViewController:(BOOL)inferTopSafeAreaInsetFromViewController {
    [super setInferTopSafeAreaInsetFromViewController:inferTopSafeAreaInsetFromViewController];

    if (inferTopSafeAreaInsetFromViewController) {
        self.topLayoutGuideAdjustmentEnabled = YES;
    }

    _verticalConstraint.active = !self.inferTopSafeAreaInsetFromViewController;
    _topSafeAreaConstraint.active = self.inferTopSafeAreaInsetFromViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIBarButtonItem *backBarButtonItem = [self backButtonItem];
    if (backBarButtonItem && !self.navigationBar.backItem) {
        self.navigationBar.backItem = backBarButtonItem;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (@available(iOS 11.0, *)) {
        // We only update the top inset on iOS 11 because previously we were not adjusting the header
        // height to make it smaller when the status bar is hidden.
        _verticalConstraint.constant = GTUIDeviceTopSafeAreaInset();
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];

    [self.navigationBar observeNavigationItem:parent.navigationItem];

    CGRect frame = self.view.frame;
    frame.size.width = CGRectGetWidth(parent.view.bounds);
    self.view.frame = frame;
}

- (BOOL)accessibilityPerformEscape {
    [self dismissSelf];
    return YES;
}

#pragma mark User actions

- (void)didTapBackButton:(__unused id)sender {
    [self dismissSelf];
}

- (void)dismissSelf {
    UIViewController *pvc = self.parentViewController;
    if (pvc.navigationController && pvc.navigationController.viewControllers.count > 1) {
        [pvc.navigationController popViewControllerAnimated:YES];
    } else {
        [pvc dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

#pragma mark - To be deprecated

@implementation GTUIAppBar

- (instancetype)init {
    self = [super init];
    if (self) {
        _appBarViewController = [[GTUIAppBarViewController alloc] init];
    }
    return self;
}

- (GTUIFlexibleHeaderViewController *)headerViewController {
    return self.appBarViewController;
}

- (GTUIHeaderStackView *)headerStackView {
    return self.appBarViewController.headerStackView;
}

- (GTUINavigationBar *)navigationBar {
    return self.appBarViewController.navigationBar;
}

- (void)addSubviewsToParent {
    GTUIAppBarViewController *abvc = self.appBarViewController;
    NSAssert(abvc.parentViewController,
             @"appBarViewController does not have a parentViewController. "
             @"Use [self addChildViewController:appBar.appBarViewController]. "
             @"This warning only appears in DEBUG builds");
    if (abvc.view.superview == abvc.parentViewController.view) {
        return;
    }

    // Enforce the header's desire to fully cover the width of its parent view.
    CGRect frame = abvc.view.frame;
    frame.origin.x = 0;
    frame.size.width = abvc.parentViewController.view.bounds.size.width;
    abvc.view.frame = frame;

    [abvc.parentViewController.view addSubview:abvc.view];
    [abvc didMoveToParentViewController:abvc.parentViewController];
}

- (void)setInferTopSafeAreaInsetFromViewController:(BOOL)inferTopSafeAreaInsetFromViewController {
    self.appBarViewController.inferTopSafeAreaInsetFromViewController =
    inferTopSafeAreaInsetFromViewController;
}

- (BOOL)inferTopSafeAreaInsetFromViewController {
    return self.appBarViewController.inferTopSafeAreaInsetFromViewController;
}

@end

