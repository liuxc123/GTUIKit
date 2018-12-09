//
//  GTUITabBarNumberView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarTitleView.h"
#import "GTUITabBarNumberCell.h"
#import "GTUITabBarNumberCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarNumberView : GTUITabBarTitleView

/**
 需要与titles的count对应
 */
@property (nonatomic, strong) NSArray <NSNumber *> *counts;

/**
 numberLabel的font，默认：[UIFont systemFontOfSize:11]
 */
@property (nonatomic, strong) UIFont *numberLabelFont;

/**
 数字的背景色，默认：[UIColor colorWithRed:241/255.0 green:147/255.0 blue:95/255.0 alpha:1]
 */
@property (nonatomic, strong) UIColor *numberBackgroundColor;

/**
 数字的title颜色，默认：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *numberTitleColor;

/**
 numberLabel的宽度补偿，label真实的宽度是文字内容的宽度加上补偿的宽度，默认：10
 */
@property (nonatomic, assign) CGFloat numberLabelWidthIncrement;

/**
 numberLabel的高度，默认：14
 */
@property (nonatomic, assign) CGFloat numberLabelHeight;

@end

NS_ASSUME_NONNULL_END
