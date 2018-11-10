//
//  GTUIShapedShadowLayer.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUIShapedShadowLayer.h"

#import "GTUIShapeGenerating.h"

@implementation GTUIShapedShadowLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonGTUIShapedShadowLayerInit];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTUIShapedShadowLayerInit];
    }
    return self;
}

- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self && [self isKindOfClass:[GTUIShapedShadowLayer class]]) {
        GTUIShapedShadowLayer *otherLayer = (GTUIShapedShadowLayer *)layer;

        _shapeGenerator = [otherLayer.shapeGenerator copyWithZone:NULL];
        // We don't need to copy fillColor because that gets copied by [super initWithLayer:].

        // [CALayer initWithLayer:] copies all sublayers, so we have to manually fetch our CAShapeLayer.
        CALayer *sublayer = [[self sublayers] firstObject];
        if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
            _colorLayer = (CAShapeLayer *)sublayer;
        }
    }
    return self;
}

- (void)commonGTUIShapedShadowLayerInit {
    self.backgroundColor = [UIColor clearColor].CGColor;
    _colorLayer = [CAShapeLayer layer];
    _colorLayer.delegate = self;
    _shapeLayer = [CAShapeLayer layer];
    [self addSublayer:_colorLayer];
}

- (void)layoutSublayers {
    // We have to set the path before calling [super layoutSublayers] because we need the shadowPath
    // to be correctly set before GTUIShadowLayer performs layoutSublayers.
    CGRect standardizedBounds = CGRectStandardize(self.bounds);
    self.path = [self.shapeGenerator pathForSize:standardizedBounds.size];

    [super layoutSublayers];

    CGRect bounds = self.bounds;
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    _colorLayer.position = center;
    _colorLayer.bounds = bounds;
}

- (void)setShapeGenerator:(id<GTUIShapeGenerating>)shapeGenerator {
    _shapeGenerator = shapeGenerator;

    CGRect standardizedBounds = CGRectStandardize(self.bounds);
    self.path = [self.shapeGenerator pathForSize:standardizedBounds.size];
}

- (void)setPath:(CGPathRef)path {
    self.shadowPath = path;
    _colorLayer.path = path;
    _shapeLayer.path = path;

    if (CGPathIsEmpty(path)) {
        self.backgroundColor = self.shapedBackgroundColor.CGColor;
        self.borderColor = self.shapedBorderColor.CGColor;
        self.borderWidth = self.shapedBorderWidth;

        _colorLayer.fillColor = nil;
        _colorLayer.strokeColor = nil;
        _colorLayer.lineWidth = 0;
    } else {
        self.backgroundColor = nil;
        self.borderColor = nil;
        self.borderWidth = 0;

        _colorLayer.fillColor = self.shapedBackgroundColor.CGColor;
        _colorLayer.strokeColor = self.shapedBorderColor.CGColor;
        _colorLayer.lineWidth = self.shapedBorderWidth;
    }
}

- (CGPathRef)path {
    return _colorLayer.path;
}

- (void)setShapedBackgroundColor:(UIColor *)shapedBackgroundColor {
    _shapedBackgroundColor = shapedBackgroundColor;

    if (CGPathIsEmpty(self.path)) {
        self.backgroundColor = _shapedBackgroundColor.CGColor;
        _colorLayer.fillColor = nil;
    } else {
        self.backgroundColor = nil;
        _colorLayer.fillColor = _shapedBackgroundColor.CGColor;
    }
}

- (void)setShapedBorderColor:(UIColor *)shapedBorderColor {
    _shapedBorderColor = shapedBorderColor;

    if (CGPathIsEmpty(self.path)) {
        self.borderColor = _shapedBorderColor.CGColor;
        _colorLayer.strokeColor = nil;
    } else {
        self.borderColor = nil;
        _colorLayer.strokeColor = _shapedBorderColor.CGColor;
    }
}

- (void)setShapedBorderWidth:(CGFloat)shapedBorderWidth {
    _shapedBorderWidth = shapedBorderWidth;

    if (CGPathIsEmpty(self.path)) {
        self.borderWidth = _shapedBorderWidth;
        _colorLayer.lineWidth = 0;
    } else {
        self.borderWidth = 0;
        _colorLayer.lineWidth = _shapedBorderWidth;
    }
}

@end
