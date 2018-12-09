//
//  GTUITabBarIndicatorTriangleView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorComponentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarIndicatorTriangleView : GTUITabBarIndicatorComponentView

@property (nonatomic, assign) CGSize triangleViewSize;  //默认：CGSizeMake(14, 10)

@property (nonatomic, strong) UIColor *triangleViewColor;   //默认：[UIColor redColor]

@end

NS_ASSUME_NONNULL_END
