//
//  UIColor+GTTabBarAdd.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "UIColor+GTTabBarAdd.h"

@implementation UIColor (GTTabBarAdd)

- (CGFloat)gtui_red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)gtui_green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)gtui_blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)gtui_alpha {
    return CGColorGetAlpha(self.CGColor);
}

@end
