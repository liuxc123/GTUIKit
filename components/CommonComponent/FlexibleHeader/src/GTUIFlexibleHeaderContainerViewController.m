//
//  GTUIFlexibleHeaderContainerViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import "GTUIFlexibleHeaderContainerViewController.h"

#import "GTUIFlexibleHeaderView.h"
#import "GTUIFlexibleHeaderViewController.h"

@implementation GTUIFlexibleHeaderContainerViewController


- (instancetype)initWithContentViewController:(UIViewController *)contentViewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _headerViewController = [[GTUIFlexibleHeaderViewController alloc] init];
        _headerViewController.inferTopSafeAreaInsetFromViewController = YES;
        [self addChildViewController:_headerViewController];

        self.contentViewController = contentViewController;
    }
    return self;
}

- (instancetype)initWithNibName:(__unused NSString *)nibNameOrNil
                         bundle:(__unused NSBundle *)nibBundleOrNil {
    return [self initWithContentViewController:nil];
}

- (instancetype)initWithCoder:(__unused NSCoder *)aDecoder {
    return [self initWithContentViewController:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];

    // Enforce the header's desire to fully cover the width of its parent view.
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.size.width = self.view.bounds.size.width;
    self.headerViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.headerViewController.view];
    [self.headerViewController didMoveToParentViewController:self];

    [self updateTopLayoutGuideBehavior];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (!self.topLayoutGuideAdjustmentEnabled) {
        [self.headerViewController updateTopLayoutGuide];
    }
}

- (BOOL)prefersStatusBarHidden {
    return _headerViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _headerViewController.preferredStatusBarStyle;
}

#pragma mark - Public

- (void)setContentViewController:(UIViewController *)contentViewController {
    if (_contentViewController == contentViewController) {
        return;
    }

    // Teardown of the old controller

    [_contentViewController willMoveToParentViewController:nil];
    if ([_contentViewController isViewLoaded]) {
        [_contentViewController.view removeFromSuperview];
    }
    [_contentViewController removeFromParentViewController];

    // Setup of the new controller

    _contentViewController = contentViewController;

    if (contentViewController != nil) {
        [self addChildViewController:contentViewController];
        if ([self isViewLoaded]) {
            [self.view insertSubview:contentViewController.view
                        belowSubview:self.headerViewController.headerView];
            [contentViewController didMoveToParentViewController:self];
        }
    }

    [self updateTopLayoutGuideBehavior];
}

#pragma mark - Enabling top layout guide adjustment behavior

- (void)updateTopLayoutGuideBehavior {
    if (self.topLayoutGuideAdjustmentEnabled) {
        if ([self isViewLoaded]) {
            self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = YES;
            self.contentViewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                                                | UIViewAutoresizingFlexibleHeight);
            self.contentViewController.view.frame = self.view.bounds;
        }

        // The flexible header view controller, by default, will assume that it is a child view
        // controller of the content view controller and modify its parent view controller's
        // topLayoutGuide. With an App Bar container view controller, however, our flexible header's
        // parent is the app bar container view controller instead. There does not appear to be a way to
        // make two top layout guides constrain to one other
        // (e.g. self.topLayoutGuide == self.contentViewController.topLayoutGuide) so instead we must
        // tell the flexible header controller which view controller it should modify.
        self.headerViewController.topLayoutGuideViewController = self.contentViewController;

    } else {
        self.headerViewController.topLayoutGuideViewController = nil;
    }
}

- (void)setTopLayoutGuideAdjustmentEnabled:(BOOL)topLayoutGuideAdjustmentEnabled {
    if (_topLayoutGuideAdjustmentEnabled == topLayoutGuideAdjustmentEnabled) {
        return;
    }
    _topLayoutGuideAdjustmentEnabled = topLayoutGuideAdjustmentEnabled;

    [self updateTopLayoutGuideBehavior];
}


@end
