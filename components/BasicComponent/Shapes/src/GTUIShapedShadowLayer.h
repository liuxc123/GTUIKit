//
//  GTUIShapedShadowLayer.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <QuartzCore/QuartzCore.h>

#import "GTShadowLayer.h"

@protocol GTUIShapeGenerating;

/*
 A shaped and Material-shadowed layer.
 */
@interface GTUIShapedShadowLayer : GTUIShadowLayer

/*
 Sets the shaped background color of the layer.

 Use shapedBackgroundColor instead of backgroundColor to ensure the background appears correct with
 or without a valid shape.

 @note If you set shapedBackgroundColor, you should not manually write to backgroundColor or
 fillColor.
 */
@property(nonatomic, strong, nullable) UIColor *shapedBackgroundColor;

/*
 Sets the shaped border color of the layer.

 Use shapedBorderColor instead of borderColor to ensure the border appears correct with or without
 a valid shape.

 @note If you set shapedBorderColor, you should not manually write to borderColor.
 */
@property(nonatomic, strong, nullable) UIColor *shapedBorderColor;

/*
 Sets the shaped border width of the layer.

 Use shapedBorderWidth instead of borderWidth to ensure the border appears correct with or without
 a valid shape.

 @note If you set shapedBorderWidth, you should not manually write to borderWidth.
 */
@property(nonatomic, assign) CGFloat shapedBorderWidth;

/*
 The GTUIShapeGenerating object used to set the shape's path and shadow path.

 The path will be set upon assignment of this property and whenever layoutSublayers is called.
 */
@property(nonatomic, strong, nullable) id<GTUIShapeGenerating> shapeGenerator;

/*
 The created CAShapeLayer representing the generated shape path for the implementing UIView
 from the shapeGenerator.

 This layer is exposed to easily mask subviews of the implementing UIView so they won't spill
 outside the layer to fit the bounds.
 */
@property(nonatomic, strong, nonnull) CAShapeLayer *shapeLayer;

/*
 A sublayer of @c shapeLayer that is responsible for the background color of the shape layer.

 The colorLayer imitates the path of shapeLayer and is added as a sublayer. It is updated when
 shapedBackgroundColor is set on the layer.
 */
@property(nonatomic, strong, nonnull) CAShapeLayer *colorLayer;

@end

