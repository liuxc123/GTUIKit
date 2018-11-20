//
//  GTUIEdgeTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <UIKit/UIKit.h>

@class GTUIPathGenerator;

/**
 GTUIEdgeTreatment is a factory for creating GTUIPathGenerators that represent the
 path of a edge.

 GTUIEdgeTreaments only generate in the top quadrant (i.e. the top edge of a
 rectangle). GTUIShapeModel will transform the generated GTUIPathGenerator to the
 expected position and rotation.
 */
@interface GTUIEdgeTreatment : NSObject <NSCopying, NSSecureCoding>

- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

/**
 Generates an GTUIPathGenerator object for an edge with the provided length.

 @param length The length of the edge.
 */
- (nonnull GTUIPathGenerator *)pathGeneratorForEdgeWithLength:(CGFloat)length;

@end
