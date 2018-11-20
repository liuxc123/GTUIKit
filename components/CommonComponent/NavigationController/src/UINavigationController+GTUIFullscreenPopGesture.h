//
//  UINavigationController+GTUIFullscreenPopGesture.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (GTUIFullscreenPopGesture)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *gtui_fullscreenPopGestureRecognizer;

@property (nonatomic, assign) BOOL gtui_viewControllerBasedNavigationBarAppearanceEnabled;


@end


/// Allows any view controller to disable interactive pop gesture, which might
/// be necessary when the view controller itself handles pan gesture in some
/// cases.
@interface UIViewController (GTUIFullscreenPopGesture)

/// Whether the interactive pop gesture is disabled when contained in a navigation
/// stack.
/// 是否开启手势返回
@property (nonatomic, assign) BOOL gtui_interactivePopDisabled;

/// Max allowed initial distance to left edge when you begin the interactive pop
/// gesture. 0 by default, which means it will ignore this limit.
/// 返回手势的反应区域大小  如果是0  默认是是全屏
@property (nonatomic, assign) CGFloat gtui_interactivePopMaxAllowedInitialDistanceToLeftEdge;

@end
