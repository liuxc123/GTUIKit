//
//  GTUITextInputBorderView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputBorderView.h"

static inline NSString *_Nullable GTUINSStringFromCGLineCap(CGLineCap lineCap) {
    NSString *lineCapString;
    switch (lineCap) {
        case kCGLineCapButt:
            lineCapString = kCALineCapButt;
            break;
        case kCGLineCapRound:
            lineCapString = kCALineCapRound;
            break;
        case kCGLineCapSquare:
            lineCapString = kCALineCapSquare;
            break;
    }
    return lineCapString;
}

static inline NSString *_Nullable GTUINSStringFromCGLineJoin(CGLineJoin lineJoin) {
    NSString *lineJoinString;
    switch (lineJoin) {
        case kCGLineJoinBevel:
            lineJoinString = kCALineJoinBevel;
            break;
        case kCGLineJoinMiter:
            lineJoinString = kCALineJoinMiter;
            break;
        case kCGLineJoinRound:
            lineJoinString = kCALineJoinRound;
            break;
    }
    return lineJoinString;
}

@interface GTUITextInputBorderView ()

@property(nonatomic, strong, readonly) CAShapeLayer *borderLayer;

@end

@implementation GTUITextInputBorderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTUITextInputBorderViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonGTUITextInputBorderViewInit];
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable __unused NSZone *)zone {
    GTUITextInputBorderView *copy = [[[self class] alloc] initWithFrame:self.frame];
    copy.borderFillColor = self.borderFillColor;
    copy.borderPath = [self.borderPath copy];
    copy.borderStrokeColor = self.borderStrokeColor;

    return copy;
}

- (void)commonGTUITextInputBorderViewInit {
    _borderFillColor = _borderFillColor ? _borderFillColor : [UIColor clearColor];
    _borderStrokeColor = _borderStrokeColor ? _borderStrokeColor : [UIColor clearColor];

    self.userInteractionEnabled = NO;
    self.opaque = NO;

    self.borderLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.borderLayer.contentsScale = UIScreen.mainScreen.scale;
    self.borderLayer.opaque = NO;
    self.borderLayer.rasterizationScale = self.borderLayer.contentsScale;
    self.borderLayer.shouldRasterize = YES;
    self.borderLayer.zPosition = -1.f;
}

- (void)updateBorder {
    self.borderLayer.fillColor = self.borderFillColor.CGColor;
    self.borderLayer.lineWidth = self.borderPath.lineWidth;
    self.borderLayer.lineCap = GTUINSStringFromCGLineCap(self.borderPath.lineCapStyle);
    self.borderLayer.lineJoin = GTUINSStringFromCGLineJoin(self.borderPath.lineJoinStyle);
    self.borderLayer.miterLimit = self.borderPath.miterLimit;
    self.borderLayer.path = self.borderPath.CGPath;
    self.borderLayer.strokeColor = self.borderStrokeColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateBorder];
}

#pragma mark - Properties

- (void)setBorderFillColor:(UIColor *)borderFillColor {
    if (![_borderFillColor isEqual:borderFillColor]) {
        _borderFillColor = borderFillColor;
        [self updateBorder];
    }
}

- (CAShapeLayer *)borderLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)setBorderPath:(UIBezierPath *)borderPath {
    if (![_borderPath isEqual:borderPath]) {
        _borderPath = borderPath;
        [self updateBorder];
    }
}

- (void)setBorderStrokeColor:(UIColor *)borderStrokeColor {
    if (![_borderStrokeColor isEqual:borderStrokeColor]) {
        _borderStrokeColor = borderStrokeColor;
        [self updateBorder];
    }
}

#pragma mark - UIView Methods

+ (Class)layerClass {
    return [CAShapeLayer class];
}

@end
