//
//  GTUIShapeCategory.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import <Foundation/Foundation.h>
#import "GTShapes.h"

/**
 This enum consists of the different types of shape corners.

 - GTUIShapeCornerFamilyRounded: A rounded corner.
 - GTUIShapeCornerFamilyCut: A cut corner.
 */
typedef NS_ENUM(NSInteger, GTUIShapeCornerFamily) {
    GTUIShapeCornerFamilyRounded,
    GTUIShapeCornerFamilyCut,
};

/**
 The GTUIShapeCategory is the class containing the shape value as part of our shape scheme,
 GTUIShapeScheme.

 GTUIShapeCategory is built from 4 corners, that can be set to alter the shape value.
 */
@interface GTUIShapeCategory : NSObject

/**
 This property represents the shape of the top left corner of the shape.
 */
@property(strong, nonatomic) GTUICornerTreatment *topLeftCorner;

/**
 This property represents the shape of the top right corner of the shape.
 */
@property(strong, nonatomic) GTUICornerTreatment *topRightCorner;

/**
 This property represents the shape of the bottom left corner of the shape.
 */
@property(strong, nonatomic) GTUICornerTreatment *bottomLeftCorner;

/**
 This property represents the shape of the bottom right corner of the shape.
 */
@property(strong, nonatomic) GTUICornerTreatment *bottomRightCorner;

/**
 The default init of the class. It sets all 4 corners with a corner family of
 GTUIShapeCornerFamilyRounded and size of 0. This is equivalent to a "sharp" corner, or in terms of
 Apple's API it is the same as setting the cornerRadius to 0.

 @return returns an initialized GTUIShapeCategory instance.
 */
- (instancetype)init;

/**
 This method is a convenience initializer of setting the shape value of all our corners at once
 to the provided cornerFamily and cornerSize.

 The outcome is a symmetrical shape that has the same values for all its corners.

 @param cornerFamily The family of our corner (rounded or angled).
 @param cornerSize The shape value of the corner.
 @return returns an GTUIShapeCategory with the initialized values.
 */
- (instancetype)initCornersWithFamily:(GTUIShapeCornerFamily)cornerFamily
                              andSize:(CGFloat)cornerSize;

@end
