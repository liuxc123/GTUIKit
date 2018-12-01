//
//  UITabBarItem+GTUIBadge.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import "UITabBarItem+GTUIBadge.h"

#define kActualView     [self getActualBadgeSuperView]

@implementation UITabBarItem (GTUIBadge)

#pragma mark -- public methods

/**
 *  show badge with red dot style and GTUIBadgeAnimTypeNone by default.
 */
- (void)showBadge
{
    [kActualView showBadge];
}

/**
 *  showBadge
 *
 *  @param style GTUIBadgeStyle type
 *  @param value (if 'style' is GTUIBadgeStyleRedDot or GTUIBadgeStyleNew,
 this value will be ignored. In this case, any value will be ok.)
 *   @param aniType GTUIBadgeAnimType
 */
- (void)showBadgeWithStyle:(GTUIBadgeStyle)style
                     value:(NSInteger)value
             animationType:(GTUIBadgeAnimType)aniType
{
    [kActualView showBadgeWithStyle:style value:value animationType:aniType];
}

/**
 *  clear badge
 */
- (void)clearBadge
{
    [kActualView clearBadge];
}

- (void)resumeBadge
{
    [kActualView resumeBadge];
}

#pragma mark -- private method

/**
 *  Because UIBarButtonItem is kind of NSObject, it is not able to directly attach badge.
 This method is used to find actual view (non-nil) inside UIBarButtonItem instance.
 *
 *  @return view
 */
- (UIView *)getActualBadgeSuperView
{
    // 1.get UITabbarButtion
    UIView *bottomView = [self valueForKeyPath:@"_view"];

    // 2.get imageView, to make sure badge front at anytime.
    UIView *actualSuperView = nil;
    if (bottomView) {
        actualSuperView = [self find:bottomView firstSubviewWithClass:NSClassFromString(@"UITabBarSwappableImageView")];
    }

    // badge label will be added onto imageView
    return actualSuperView;
}

- (UIView *)find:(UIView *)view firstSubviewWithClass:(Class)cls
{
    __block UIView *targetView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subview isKindOfClass:cls]) {
            targetView = subview;
            *stop = YES;
        }
    }];
    return targetView;
}

#pragma mark -- setter/getter
- (UILabel *)badge
{
    return kActualView.badge;
}

- (void)setBadge:(UILabel *)label
{
    [kActualView setBadge:label];
}

- (UIFont *)badgeFont
{
    return kActualView.badgeFont;
}

- (void)setBadgeFont:(UIFont *)badgeFont
{
    [kActualView setBadgeFont:badgeFont];
}

- (UIColor *)badgeBgColor
{
    return [kActualView badgeBgColor];
}

- (void)setBadgeBgColor:(UIColor *)badgeBgColor
{
    [kActualView setBadgeBgColor:badgeBgColor];
}

- (UIColor *)badgeTextColor
{
    return [kActualView badgeTextColor];
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    [kActualView setBadgeTextColor:badgeTextColor];
}

- (GTUIBadgeAnimType)aniType
{
    return [kActualView aniType];
}

- (void)setAniType:(GTUIBadgeAnimType)aniType
{
    [kActualView setAniType:aniType];
}

- (CGRect)badgeFrame
{
    return [kActualView badgeFrame];
}

- (void)setBadgeFrame:(CGRect)badgeFrame
{
    [kActualView setBadgeFrame:badgeFrame];
}

- (CGPoint)badgeCenterOffset
{
    return [kActualView badgeCenterOffset];
}

- (void)setBadgeCenterOffset:(CGPoint)badgeCenterOffset
{
    [kActualView setBadgeCenterOffset:badgeCenterOffset];
}

- (NSInteger)badgeMaximumBadgeNumber
{
    return [kActualView badgeMaximumBadgeNumber];
}

- (void)setBadgeMaximumBadgeNumber:(NSInteger)badgeMaximumBadgeNumber
{
    [kActualView setBadgeMaximumBadgeNumber:badgeMaximumBadgeNumber];
}

@end
