//
//  GTUIShapeGenerating.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <Foundation/Foundation.h>

/**
 A protocol for objects that create closed CGPaths of varying sizes.
 */
@protocol GTUIShapeGenerating <NSCopying, NSSecureCoding>

/**
 Creates a CGPath for the given size.

 @param size The expected size of the generated path.
 @return CGPathRef A closed path of the provided size. If size is empty, may return NULL.
 */
- (nullable CGPathRef)pathForSize:(CGSize)size;

@end
