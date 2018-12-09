//
//  GTUITabBarIndicatorBackgroundView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorComponentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarIndicatorBackgroundView : GTUITabBarIndicatorComponentView

@property (nonatomic, assign) CGFloat backgroundViewWidth;     //默认GTUITabBarViewAutomaticDimension（与cellWidth相等）

@property (nonatomic, assign) CGFloat backgroundViewWidthIncrement;    //宽度增量补偿，因为backgroundEllipseLayer一般会比实际内容大一些。默认10

@property (nonatomic, assign) CGFloat backgroundViewHeight;   //默认GTUITabBarViewAutomaticDimension（与cell高度相等）

@property (nonatomic, assign) CGFloat backgroundViewCornerRadius;   //默认GTUITabBarViewAutomaticDimension(即backgroundViewHeight/2)

@property (nonatomic, strong) UIColor *backgroundViewColor;   //默认为[UIColor redColor]

@end

NS_ASSUME_NONNULL_END
