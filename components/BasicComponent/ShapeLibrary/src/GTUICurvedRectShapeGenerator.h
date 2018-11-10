//
//  GTUICurvedRectShapeGenerator.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "GTShapes.h"

/**
 A curved rectangle shape generator.
 一个弯曲的矩形形状发生器。
 */
@interface GTUICurvedRectShapeGenerator : NSObject <GTUIShapeGenerating>

/**
 The size of the curved corner.
 */
@property(nonatomic, assign) CGSize cornerSize;

/**
 Initializes an GTUICurvedRectShapeGenerator instance with a given cornerSize.
 */
- (instancetype)initWithCornerSize:(CGSize)cornerSize NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end
