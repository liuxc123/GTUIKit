//
//  GTUITabBarListVCContainerView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 使用方法参照demo工程的LoadDataViewController文件
 */
@interface GTUITabBarListVCContainerView : UIView

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray <UIViewController *> *listVCArray;
//这个defaultSelectedIndex仅仅用于触发对应index的数据加载，如果要让tabBarView和listView都处于对应的index。还应该添加后面这段代码：self.tabBarView.defaultSelectedIndex = n
@property (nonatomic, assign) NSInteger defaultSelectedIndex;

- (void)reloadData;

- (void)scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio;

- (void)didClickSelectedItemAtIndex:(NSInteger)index;

- (void)didScrollSelectedItemAtIndex:(NSInteger)index;

- (void)parentVCWillAppear:(BOOL)animated;

- (void)parentVCDidAppear:(BOOL)animated;

- (void)parentVCWillDisappear:(BOOL)animated;

- (void)parentVCDidDisappear:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
