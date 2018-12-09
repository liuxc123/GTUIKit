//
//  GTUITabBarNumberCellModel.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarTitleCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarNumberCellModel : GTUITabBarTitleCellModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIColor *numberBackgroundColor;
@property (nonatomic, strong) UIColor *numberTitleColor;
@property (nonatomic, assign) CGFloat numberLabelWidthIncrement;
@property (nonatomic, assign) CGFloat numberLabelHeight;
@property (nonatomic, strong) UIFont *numberLabelFont;

@end

NS_ASSUME_NONNULL_END
