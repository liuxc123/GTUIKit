//
//  GTUITriangleEdgeTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTShapes.h"

typedef enum : NSUInteger {
    GTUITriangleEdgeStyleHandle,
    GTUITriangleEdgeStyleCut,
} GTUITriangleEdgeStyle;

/**
 An edge treatment that adds a triangle-shaped cut or handle to the edge.
 在边缘上增加三角形切口或手柄的边缘处理。
 */
@interface GTUITriangleEdgeTreatment : GTUIEdgeTreatment

/**
 The size of the triangle shape.
 */
@property(nonatomic, assign) CGFloat size;

/**
 The style of the triangle shape.
 */
@property(nonatomic, assign) GTUITriangleEdgeStyle style;

/**
 Initializes an GTUITriangleEdgeTreatment with a given size and style.
 */
- (nonnull instancetype)initWithSize:(CGFloat)size style:(GTUITriangleEdgeStyle)style
NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end

