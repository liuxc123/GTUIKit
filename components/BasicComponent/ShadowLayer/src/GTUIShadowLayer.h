//
//  GTUIShadowLayer.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <Foundation/Foundation.h>
#import "GTUIShadowElevations.h"

@interface GTUIShadowMetrics : NSObject
@property(nonatomic, readonly) CGFloat topShadowRadius;
@property(nonatomic, readonly) CGSize topShadowOffset;
@property(nonatomic, readonly) float topShadowOpacity;
@property(nonatomic, readonly) CGFloat bottomShadowRadius;
@property(nonatomic, readonly) CGSize bottomShadowOffset;
@property(nonatomic, readonly) float bottomShadowOpacity;

/**
 The shadow metrics for manually creating shadows given an elevation.

 @param elevation The shadow's elevation in points.
 @return The shadow metrics.
 */
+ (nonnull GTUIShadowMetrics *)metricsWithElevation:(CGFloat)elevation;
@end

@interface GTUIShadowLayer : CALayer

/**
 The elevation of the layer in points.

 The higher the elevation, the more spread out the shadow is. This is distinct from the layer's
 zPosition which can be used to order overlapping layers, but will have no affect on the size of
 the shadow.

 Negative values act as if zero were specified.

 The default value is 0.
 */
@property(nonatomic, assign) GTUIShadowElevation elevation;

/**
 Whether to apply the "cutout" shadow layer mask.

 If enabled, then a mask is created to ensure the interior, non-shadow part of the layer is visible.

 Default is YES. Not animatable.
 */
@property(nonatomic, getter=isShadowMaskEnabled, assign) BOOL shadowMaskEnabled;

@end

/**
 Subclasses can depend on GTUIShadowLayer implementing CALayerDelegate actionForLayer:forKey: in
 order to implicitly animate 'path' or 'shadowPath' on sublayers.
 */
@interface GTUIShadowLayer (Subclassing) <CALayerDelegate>
@end
