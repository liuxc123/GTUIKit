//
//  UIBarButtonItem+GTUIBadge.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import "UIBarButtonItem+GTUIBadge.h"
#import <objc/runtime.h>

#define kActualView     [self getActualBadgeSuperView]

@implementation UIBarButtonItem (GTUIBadge)


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
 *   @param aniType
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
    return [self valueForKeyPath:@"_view"];//use KVC to hack actual view
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
