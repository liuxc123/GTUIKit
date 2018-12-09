//
//  GTUITabBarFactory.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarFactory.h"
#import "UIColor+GTTabBarAdd.h"

@implementation GTUITabBarFactory

+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}

+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat red = [self interpolationFrom:fromColor.gtui_red to:toColor.gtui_red percent:percent];
    CGFloat green = [self interpolationFrom:fromColor.gtui_green to:toColor.gtui_green percent:percent];
    CGFloat blue = [self interpolationFrom:fromColor.gtui_blue to:toColor.gtui_blue percent:percent];
    CGFloat alpha = [self interpolationFrom:fromColor.gtui_alpha to:toColor.gtui_alpha percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
