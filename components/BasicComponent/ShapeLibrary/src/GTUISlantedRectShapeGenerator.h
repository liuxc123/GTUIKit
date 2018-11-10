//
//  GTUISlantedRectShapeGenerator.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#import "GTShapes.h"

/**
 A slanted rectangle shape generator.

 Creates rectangles with the vertical edges at a slant.

 一个倾斜的矩形形状发生器。

 创建具有倾斜的垂直边缘的矩形。
 */
@interface GTUISlantedRectShapeGenerator : NSObject <GTUIShapeGenerating>

/**
 The horizontal offset of the corners.
 */
@property(nonatomic, assign) CGFloat slant;

@end
