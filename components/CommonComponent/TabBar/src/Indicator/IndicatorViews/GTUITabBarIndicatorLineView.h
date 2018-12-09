//
//  GTUITabBarIndicatorLineView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorComponentView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GTUITabBarIndicatorLineStyle) {
    GTUITabBarIndicatorLineStyleNormal = 0,
    GTUITabBarIndicatorLineStyleJD,
    GTUITabBarIndicatorLineStyleIQIYI,
};

@interface GTUITabBarIndicatorLineView : GTUITabBarIndicatorComponentView

@property (nonatomic, assign) GTUITabBarIndicatorLineStyle lineStyle;

/**
 line滚动时x的偏移量，默认为10；
 lineStyle为GTUITabBarLineStyle_IQIYI有用；
 */
@property (nonatomic, assign) CGFloat lineScrollOffsetX;

@property (nonatomic, assign) CGFloat indicatorLineViewHeight;  //默认：3

@property (nonatomic, assign) CGFloat indicatorLineWidth;    //默认GTUITabBarViewAutomaticDimension（与cellWidth相等）

@property (nonatomic, assign) CGFloat indicatorLineViewCornerRadius;    //默认GTUITabBarViewAutomaticDimension （等于self.indicatorLineViewHeight/2）

@property (nonatomic, strong) UIColor *indicatorLineViewColor;   //默认为[UIColor redColor]

@end

NS_ASSUME_NONNULL_END
