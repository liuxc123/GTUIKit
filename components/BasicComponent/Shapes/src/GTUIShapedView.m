//
//  GTUIShapedView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUIShapedView.h"

#import "GTUIShapedShadowLayer.h"

@interface GTUIShapedView ()
@property(nonatomic, readonly, strong) GTUIShapedShadowLayer *layer;
@property(nonatomic, readonly) CGSize pathSize;
@end

@implementation GTUIShapedView

@dynamic layer;

+ (Class)layerClass {
    return [GTUIShapedShadowLayer class];
}

- (nullable instancetype)initWithCoder:(nullable NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (nonnull instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame shapeGenerator:nil];
}

- (nonnull instancetype)initWithFrame:(CGRect)frame
                       shapeGenerator:(nullable id<GTUIShapeGenerating>)shapeGenerator {
    if (self = [super initWithFrame:frame]) {
        self.layer.shapeGenerator = shapeGenerator;
    }
    return self;
}

- (void)setElevation:(CGFloat)elevation {
    self.layer.elevation = elevation;
}

- (CGFloat)elevation {
    return self.layer.elevation;
}

- (void)setShapeGenerator:(id<GTUIShapeGenerating>)shapeGenerator {
    self.layer.shapeGenerator = shapeGenerator;
}

- (id<GTUIShapeGenerating>)shapeGenerator {
    return self.layer.shapeGenerator;
}

// GTUIShapedView captures backgroundColor assigments so that they can be set to the
// GTUIShapedShadowLayer fillColor. If we don't do this the background of the layer will obscure any
// shapes drawn by the shape layer.
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    // We intentionally capture this and don't send it to super so that the UIView backgroundColor is
    // fixed to [UIColor clearColor].
    self.layer.shapedBackgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
    return self.layer.shapedBackgroundColor;
}

@end

