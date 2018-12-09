//
//  GTUITabBarIndicatorImageView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorComponentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarIndicatorImageView : GTUITabBarIndicatorComponentView

@property (nonatomic, strong, readonly) UIImageView *indicatorImageView;

@property (nonatomic, assign) BOOL indicatorImageViewRollEnabled;      //默认NO

@property (nonatomic, assign) CGSize indicatorImageViewSize;    //默认：CGSizeMake(30, 20)

@end

NS_ASSUME_NONNULL_END
