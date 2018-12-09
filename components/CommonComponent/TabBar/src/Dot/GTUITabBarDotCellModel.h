//
//  GTUITabBarDotCellModel.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarTitleCellModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GTUITabBarDotRelativePosition) {
    GTUITabBarDotRelativePositionTopLeft = 0,
    GTUITabBarDotRelativePositionTopRight,
    GTUITabBarDotRelativePositionBottomLeft,
    GTUITabBarDotRelativePositionBottomRight,
};

@interface GTUITabBarDotCellModel : GTUITabBarTitleCellModel

@property (nonatomic, assign) BOOL dotHidden;

@property (nonatomic, assign) GTUITabBarDotRelativePosition relativePosition;

@property (nonatomic, assign) CGSize dotSize;

@property (nonatomic, assign) CGFloat dotCornerRadius;

@property (nonatomic, strong) UIColor *dotColor;

@end

NS_ASSUME_NONNULL_END
