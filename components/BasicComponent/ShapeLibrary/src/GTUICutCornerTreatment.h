//
//  GTUICutCornerTreatment.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTShapes.h"

/**
 A cut corner treatment subclassing GTUICornerTreatment.
 This can be used to set corners in GTUIRectangleShapeGenerator.
 一个切角处理，子类化处理。
 这可以用来设置角在GTUIRectangleShapeGenerator。
 */
@interface GTUICutCornerTreatment : GTUICornerTreatment

/**
 The cut of the corner.

 The value of the cut defines by how many UI points starting from the edge of the corner and going
 equal distance on the X axis and the Y axis will the corner be cut.

 As an example if the shape is a square with a size of 100x100, and we have all its corners set
 with GTUICutCornerTreatment and a cut value of 50 then the final result will be a diamond with a
 size of 50x50.
 +--------------+                     /\
 |              |                   /    \ 50
 |              |                 /        \
 |              | 100   --->    /            \
 |              |               \            /
 |              |                 \        /
 |              |                   \    / 50
 +--------------+                     \/
 100

 */
@property(nonatomic, assign) CGFloat cut;

/**
 Initializes an GTUICutCornerTreatment instance with a given cut.
 */
- (nonnull instancetype)initWithCut:(CGFloat)cut NS_DESIGNATED_INITIALIZER;

/**
 Initializes an GTUICutCornerTreatment instance with a cut of zero.
 */
- (nonnull instancetype)init;

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;


@end

