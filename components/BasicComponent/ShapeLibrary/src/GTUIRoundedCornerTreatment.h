//
//  GTUIRoundedCornerTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTShapes.h"

/**
 A rounded corner treatment.
 圆角处理。
 */
@interface GTUIRoundedCornerTreatment : GTUICornerTreatment

/**
 The radius of the corner.
 */
@property(nonatomic, assign) CGFloat radius;

/**
 Initializes an GTUIRoundedCornerTreatment instance with a given radius.
 */
- (nonnull instancetype)initWithRadius:(CGFloat)radius NS_DESIGNATED_INITIALIZER;

/**
 Initializes an GTUIRoundedCornerTreatment instance with a radius of zero.
 */
- (nonnull instancetype)init;

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end
