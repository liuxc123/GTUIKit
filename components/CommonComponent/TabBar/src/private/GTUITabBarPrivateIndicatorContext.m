//
//  GTUITabBarPrivateIndicatorContext.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUITabBarPrivateIndicatorContext.h"

#import "GTUITabBarPrivateIndicatorContext.h"

@implementation GTUITabBarPrivateIndicatorContext
@synthesize bounds = _bounds;
@synthesize contentFrame = _contentFrame;
@synthesize item = _item;

- (instancetype)initWithItem:(UITabBarItem *)item
                      bounds:(CGRect)bounds
                contentFrame:(CGRect)contentFrame {
    self = [super init];
    if (self) {
        _item = item;
        _bounds = bounds;
        _contentFrame = contentFrame;
    }
    return self;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ item:%@ bounds:%@ frame:%@",
            [super description],
            _item,
            NSStringFromCGRect(_bounds),
            NSStringFromCGRect(_contentFrame)];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }

    GTUITabBarPrivateIndicatorContext *otherContext = object;

    if ((_item != otherContext.item) && ![_item isEqual:otherContext.item]) {
        return NO;
    }

    if (!CGRectEqualToRect(_bounds, otherContext.bounds)) {
        return NO;
    }

    if (!CGRectEqualToRect(_contentFrame, otherContext.contentFrame)) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash {
    return _item.hash;
}

@end

