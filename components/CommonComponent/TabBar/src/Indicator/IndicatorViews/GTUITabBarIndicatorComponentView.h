//
//  GTUITabBarIndicatorComponentView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import <UIKit/UIKit.h>
#import "GTUITabBarIndicatorProtocol.h"
#import "GTUITabBarViewDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarIndicatorComponentView : UIView <GTUITabBarIndicatorProtocol>

@property (nonatomic, assign) GTUITabBarComponentPosition componentPosition;

@property (nonatomic, assign) CGFloat verticalMargin;     //垂直方向边距；默认：0

@property (nonatomic, assign) BOOL scrollEnabled;   //手势滚动、点击切换的时候，是否允许滚动，默认YES

@end

NS_ASSUME_NONNULL_END
