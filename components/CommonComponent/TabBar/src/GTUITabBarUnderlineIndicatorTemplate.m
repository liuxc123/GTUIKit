//
//  GTUITabBarUnderlineIndicatorTemplate.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUITabBarUnderlineIndicatorTemplate.h"

#import "GTUITabBarIndicatorAttributes.h"
#import "GTUITabBarIndicatorContext.h"

/// Height in points of the underline shown under selected items.
static const CGFloat kUnderlineIndicatorHeight = 2.0f;

@implementation GTUITabBarUnderlineIndicatorTemplate

- (GTUITabBarIndicatorAttributes *)indicatorAttributesForContext:(id<GTUITabBarIndicatorContext>)context {
    CGRect bounds = context.bounds;
    GTUITabBarIndicatorAttributes *attributes = [[GTUITabBarIndicatorAttributes alloc] init];
    CGRect underlineFrame = CGRectMake(CGRectGetMinX(bounds),
                                       CGRectGetMaxY(bounds) - kUnderlineIndicatorHeight,
                                       CGRectGetWidth(bounds),
                                       kUnderlineIndicatorHeight);
    attributes.path = [UIBezierPath bezierPathWithRect:underlineFrame];
    return attributes;
}

@end
