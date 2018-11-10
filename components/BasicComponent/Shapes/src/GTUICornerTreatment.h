//
//  GTUICornerTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <UIKit/UIKit.h>

@class GTUIPathGenerator;

/**
 This enum consists of the different types of shape values that can be provided.

 - GTUICornerTreatmentValueTypeAbsolute: If an absolute corner value is provided.
 - GTUICornerTreatmentValueTypePercentage: If a relative corner value is provided.

 See GTUIShapeCorner's @c size property for additional details.
 */
typedef NS_ENUM(NSInteger, GTUICornerTreatmentValueType) {
    GTUICornerTreatmentValueTypeAbsolute,
    GTUICornerTreatmentValueTypePercentage,
};

/**
 GTUICornerTreatment is a factory for creating GTUIPathGenerators that represent
 the path of a corner.
 圆角Shape方案

 GTUICornerTreatments should only generate corners in the top-left quadrant (i.e.
 the top-left corner of a rectangle). GTUIShapeModel will translate the generated
 GTUIPathGenerator to the expected position and rotation.
 */
@interface GTUICornerTreatment : NSObject <NSCopying, NSSecureCoding>

/**
 The value type of our corner treatment.

 When GTUICornerTreatmentValueType is GTUICornerTreatmentValueTypeAbsolute, then the accepted corner
 values are an absolute size.
 When GTUIShapeSizeType is GTUICornerTreatmentValueTypePercentage, values are expected to be in the
 range of 0 to 1 (0% - 100%). These values are percentages based on the height of the surface.
 */
@property(assign, nonatomic) GTUICornerTreatmentValueType valueType;

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Creates an GTUIPathGenerator object for a corner with the provided angle.

 @param angle The internal angle of the corner in radians. Typically M_PI/2.
 */
- (nonnull GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle;

/**
 Creates an GTUIPathGenerator object for a corner with the provided angle.
 Given that the provided valueType is GTUICornerTreatmentValueTypePercentage, we also need
 the size of the view to calculate the corner size percentage relative to the view height.

 @param angle the internal angle of the corner in radius. Typically M_PI/2.
 @param size the size of the view.
 @return returns an GTUIPathGenerator.
 */
- (nonnull GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle
                                                  forViewSize:(CGSize)size;

@end
