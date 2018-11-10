//
//  GTUIBorderEdgeTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTShapes.h"


/**
 An edge treatment that adds a custom border to the edge.
 自定义border
 */
@interface GTUIBorderEdgeTreatment : GTUIEdgeTreatment


@property(nonatomic, strong, nullable) UIColor *shapedBorderColor;

@property(nonatomic, assign) CGFloat shapedBorderWidth;


- (nonnull instancetype)initWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color
NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end
