//
//  GTUITabBarDotView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarTitleView.h"
#import "GTUITabBarDotCell.h"
#import "GTUITabBarDotCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarDotView : GTUITabBarTitleView

@property (nonatomic, assign) GTUITabBarDotRelativePosition relativePosition;   //相对于titleLabel的位置，默认：GTUITabBarDotRelativePosition_TopRight

@property (nonatomic, strong) NSArray <NSNumber *> *dotStates;  //@(布尔值)，控制红点是否显示

@property (nonatomic, assign) CGSize dotSize;   //默认：CGSizeMake(10, 10)

@property (nonatomic, assign) CGFloat dotCornerRadius;  //默认：GTUITabBarViewAutomaticDimension（self.dotSize.height/2）

@property (nonatomic, strong) UIColor *dotColor;    //默认：[UIColor redColor]

@end

NS_ASSUME_NONNULL_END
