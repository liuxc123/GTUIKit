//
//  GTUITabBarIndicatorAttributes.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUITabBarIndicatorAttributes.h"

@implementation GTUITabBarIndicatorAttributes

#pragma mark - NSCopying

- (instancetype)copyWithZone:(__unused NSZone *)zone {
    GTUITabBarIndicatorAttributes *attributes = [[[self class] alloc] init];
    attributes.path = _path;
    return attributes;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ path:%@", [super description], _path];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }

    GTUITabBarIndicatorAttributes *otherAttributes = object;

    if ((_path != otherAttributes.path) && ![_path isEqual:otherAttributes.path]) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash {
    return _path.hash;
}


@end
