//
//  GTUIPageViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import <UIKit/UIKit.h>
#import "GTTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GTUIPageViewControllerDelegate <NSObject>


@end

@interface GTUIPageViewController : UIViewController

@property (nonatomic, strong) GTUITabBarTitleImageView *tabBarView;

@property (nonatomic, strong) NSMutableArray <UIViewController *> *viewControllers;

@property (nonatomic, strong) GTUITabBarListVCContainerView *listVCContainerView;

@end

NS_ASSUME_NONNULL_END
