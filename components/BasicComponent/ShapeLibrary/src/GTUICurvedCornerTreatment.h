//
//  GTUICurvedCornerTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTShapes.h"

/**
 A curved corner treatment. Distinct from GTUIRoundedCornerTreatment in that GTUIurvedCornerTreatment
 also supports asymmetric curved corners.
 一个弯曲的角落处理。不同于角化治疗 也支持非对称弯曲的角落。
 */

@interface GTUICurvedCornerTreatment : GTUICornerTreatment

/**
 The size of the curve.
 */
@property(nonatomic, assign) CGSize size;

/**
 Initializes an GTUICurvedCornerTreatment instance with a given corner size.
 */
- (nonnull instancetype)initWithSize:(CGSize)size NS_DESIGNATED_INITIALIZER;

/**
 Initializes an GTUICurvedCornerTreatment instance with a corner size of zero.
 */
- (nonnull instancetype)init;

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end
