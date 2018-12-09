//
//  GTUITabBarIndicatorBallView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorComponentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarIndicatorBallView : GTUITabBarIndicatorComponentView

@property (nonatomic, assign) CGSize ballViewSize;  //默认：CGSizeMake(15, 15)

@property (nonatomic, assign) CGFloat ballScrollOffsetX;    //小红点的偏移量 默认：20

@property (nonatomic, strong) UIColor *ballViewColor;   //默认为[UIColor redColor]

@end

NS_ASSUME_NONNULL_END
