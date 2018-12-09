//
//  GTUITabBarIndicatorCellModel.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//
#import <UIKit/UIKit.h>
#import "GTUITabBarBaseCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarIndicatorCellModel : GTUITabBarBaseCellModel

@property (nonatomic, assign) BOOL sepratorLineShowEnabled;

@property (nonatomic, strong) UIColor *separatorLineColor;

@property (nonatomic, assign) CGSize separatorLineSize;

@property (nonatomic, assign) CGRect backgroundViewMaskFrame;

@property (nonatomic, assign) BOOL cellBackgroundColorGradientEnabled;

@property (nonatomic, strong) UIColor *cellBackgroundUnselectedColor;

@property (nonatomic, strong) UIColor *cellBackgroundSelectedColor;

@end

NS_ASSUME_NONNULL_END
