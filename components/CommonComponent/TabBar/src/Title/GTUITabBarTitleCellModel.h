//
//  GTUITabBarTitleCellModel.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorCellModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarTitleCellModel : GTUITabBarIndicatorCellModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIColor *titleSelectedColor;

@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIFont *titleSelectedFont;

@property (nonatomic, assign) BOOL titleLabelMaskEnabled;

@property (nonatomic, strong) CALayer *backgroundEllipseLayer;

@property (nonatomic, assign) BOOL titleLabelZoomEnabled;

@property (nonatomic, assign) CGFloat titleLabelZoomScale;

@property (nonatomic, assign) CGFloat titleLabelStrokeWidthEnabled;

@property (nonatomic, assign) CGFloat titleLabelSelectedStrokeWidth;

@end

NS_ASSUME_NONNULL_END
