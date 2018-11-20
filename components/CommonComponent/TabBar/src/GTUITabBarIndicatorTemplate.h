//
//  GTUITabBarIndicatorTemplate.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <Foundation/Foundation.h>

@class GTUITabBarIndicatorAttributes;
@protocol GTUITabBarIndicatorContext;

/*
 Template for indicator content which defines how the indicator changes appearance in response to
 changes in its context.

 Template objects are expected to be immutable once set on a tab bar.
 */
@protocol GTUITabBarIndicatorTemplate <NSObject>

/**
 Returns an attributes object that describes how the indicator should appear in a given context.
 */
- (nonnull GTUITabBarIndicatorAttributes *)indicatorAttributesForContext:(nonnull id<GTUITabBarIndicatorContext>)context;

@end
