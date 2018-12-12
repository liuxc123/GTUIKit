//
//  GTUIPageViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUIPageViewController.h"

@interface GTUIPageViewController () <GTUITabBarViewDelegate>

@end

@implementation GTUIPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.listVCContainerView parentVCDidAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.listVCContainerView parentVCDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.listVCContainerView parentVCWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.listVCContainerView parentVCDidDisappear:animated];
}

//这句代码必须加上
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - GTUITabBarViewDelegate

- (void)tabBarView:(GTUITabBarBaseView *)tabBarView didSelectedItemAtIndex:(NSInteger)index {

}

- (void)tabBarView:(GTUITabBarBaseView *)tabBarView didClickSelectedItemAtIndex:(NSInteger)index
{
    [self.listVCContainerView didClickSelectedItemAtIndex:index];
}

- (void)tabBarView:(GTUITabBarBaseView *)tabBarView didScrollSelectedItemAtIndex:(NSInteger)index {
    [self.listVCContainerView didScrollSelectedItemAtIndex:index];
}

- (void)tabBarView:(GTUITabBarBaseView *)tabBarView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio
{
    [self.listVCContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio];
}


@end
