//
//  GTUIRectangleShapeGenerator.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//



#import <UIKit/UIKit.h>

#import "GTUIShapeGenerating.h"

@class GTUICornerTreatment;
@class GTUIEdgeTreatment;

/**
 An GTUIShapeGenerating for creating shaped rectanglular CGPaths.
 矩形Shape方案

 By default GTUIRectangleShapeGenerator creates rectanglular CGPaths. Set the corner and edge
 treatments to shape parts of the generated path.
 */
@interface GTUIRectangleShapeGenerator : NSObject <GTUIShapeGenerating>

/**
 The corner treatments to apply to each corner.
 */
@property(nonatomic, strong) GTUICornerTreatment *topLeftCorner;
@property(nonatomic, strong) GTUICornerTreatment *topRightCorner;
@property(nonatomic, strong) GTUICornerTreatment *bottomLeftCorner;
@property(nonatomic, strong) GTUICornerTreatment *bottomRightCorner;

/**
 The offsets to apply to each corner.
 */
@property(nonatomic, assign) CGPoint topLeftCornerOffset;
@property(nonatomic, assign) CGPoint topRightCornerOffset;
@property(nonatomic, assign) CGPoint bottomLeftCornerOffset;
@property(nonatomic, assign) CGPoint bottomRightCornerOffset;

/**
 The edge treatments to apply to each edge.
 */
@property(nonatomic, strong) GTUIEdgeTreatment *topEdge;
@property(nonatomic, strong) GTUIEdgeTreatment *rightEdge;
@property(nonatomic, strong) GTUIEdgeTreatment *bottomEdge;
@property(nonatomic, strong) GTUIEdgeTreatment *leftEdge;

/**
 Convenience to set all corners to the same GTUICornerTreatment instance.
 */
- (void)setCorners:(GTUICornerTreatment *)cornerShape;

/**
 Conveninece to set all edge treatments to the same GTUIEdgeTreatment instance.
 */
- (void)setEdges:(GTUIEdgeTreatment *)edgeShape;

@end
