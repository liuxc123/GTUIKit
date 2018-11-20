//
//  GTUITabBarIndicatorAttributes.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <Foundation/Foundation.h>

/** Defines how a tab bar indicator should appear in a specific context. */
@interface GTUITabBarIndicatorAttributes : NSObject

/** If non-nil, a path that should be filled with the indicator tint color. */
@property(nonatomic, nullable) UIBezierPath *path;

@end
