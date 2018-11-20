//
//  GTUITabBarIndicatorView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUITabBarIndicatorView.h"

#import "GTUITabBarIndicatorAttributes.h"

/** Content view that displays a filled path and supports animation between states. */
@interface GTUITabBarIndicatorShapeView: UIView

/** The path to display. It will be filled using the view's tintColor. */
@property(nonatomic, nullable) UIBezierPath *path;

@end

@implementation GTUITabBarIndicatorView{
    /// View responsible for drawing the indicator's path.
    GTUITabBarIndicatorShapeView *_shapeView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTUITabBarIndicatorViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTUITabBarIndicatorViewInit];
    }
    return self;
}

#pragma mark - Public

- (void)applySelectionIndicatorAttributes:(GTUITabBarIndicatorAttributes *)attributes {
    _shapeView.path = attributes.path;
}

#pragma mark - Private

- (void)commonGTUITabBarIndicatorViewInit {
    // Fill the indicator with the shape.
    _shapeView = [[GTUITabBarIndicatorShapeView alloc] initWithFrame:self.bounds];
    _shapeView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_shapeView];
}

@end

#pragma mark -

@implementation GTUITabBarIndicatorShapeView

- (UIBezierPath *)path {
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    CGPathRef cgPath = shapeLayer.path;
    return cgPath ? [UIBezierPath bezierPathWithCGPath:cgPath] : nil;
}

- (void)setPath:(UIBezierPath *)path {
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.path = path.CGPath;
}

#pragma mark - CALayerDelegate

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    id<CAAction> action = [super actionForLayer:layer forKey:event];
    // Support implicit animation of paths.
    if ((!action || action == [NSNull null]) && (layer == self.layer) && [event isEqual:@"path"]) {
        return [CABasicAnimation animationWithKeyPath:event];
    }
    return action;
}

#pragma mark - UIView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];

    // Update layer fill color
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.fillColor = self.tintColor.CGColor;
}

@end
