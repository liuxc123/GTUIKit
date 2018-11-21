//
//  GTUITextInputUnderlineView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputUnderlineView.h"

#import "GTPalettes.h"

static const CGFloat GTUITextInputUnderlineDefaultHeight = 1.f;

// TODO: (larche): Make disabled color parameterized?
static inline UIColor *GTUITextInputUnderlineColor() {
    return [UIColor lightGrayColor];
}

@interface GTUITextInputUnderlineView ()

@property(nonatomic, strong) CAShapeLayer *disabledUnderline;
@property(nonatomic, strong) CAShapeLayer *underline;

@end

@implementation GTUITextInputUnderlineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTUIUnderlineViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonGTUIUnderlineViewInit];
    }
    return self;
}

- (void)commonGTUIUnderlineViewInit {
    _color = GTUITextInputUnderlineColor();
    _disabledColor = GTUITextInputUnderlineColor();
    _enabled = YES;
    _lineHeight = GTUITextInputUnderlineDefaultHeight;

    [self setContentHuggingPriority:UILayoutPriorityDefaultHigh
                            forAxis:UILayoutConstraintAxisVertical];
    [self setClipsToBounds:NO];
    [self updateUnderline];
}

- (instancetype)copyWithZone:(__unused NSZone *)zone {
    GTUITextInputUnderlineView *copy = [[[self class] alloc] initWithFrame:self.frame];

    copy.color = self.color;
    copy.disabledColor = self.disabledColor;
    copy.enabled = self.enabled;
    copy.lineHeight = self.lineHeight;

    return copy;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateUnderlinePath];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, self.lineHeight);
}

- (void)updateUnderlinePath {
    CGRect bounds = [self bounds];
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat offSet = 1.f / [UIScreen mainScreen].scale;
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(bounds), CGRectGetMidY(bounds) + offSet);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(bounds), CGRectGetMidY(bounds) + offSet);

    if (_underline) {
        _underline.frame = bounds;
        _underline.path = path;
    }

    if (_disabledUnderline) {
        _disabledUnderline.frame = bounds;
        _disabledUnderline.path = path;
    }
    CGPathRelease(path);
}

- (void)updateUnderline {
    if (_enabled) {
        if (!_underline) {
            _underline = [CAShapeLayer layer];
            _underline.contentsScale = [UIScreen mainScreen].scale;
            _underline.frame = CGRectZero;
            _underline.lineWidth = self.lineHeight;
            _underline.strokeColor = _color.CGColor;

            [self.layer addSublayer:_underline];
        }

        _disabledUnderline.opacity = 0.f;
    } else {
        if (!_disabledUnderline) {
            _disabledUnderline = [CAShapeLayer layer];
            _disabledUnderline.contentsScale = [UIScreen mainScreen].scale;
            _disabledUnderline.frame = CGRectZero;
            _disabledUnderline.lineJoin = kCALineJoinMiter;
            _disabledUnderline.lineDashPattern = @[ @1.5, @1.5 ];
            _disabledUnderline.lineWidth = 1.0;
            _disabledUnderline.opaque = NO;
            _disabledUnderline.strokeColor = _disabledColor.CGColor;
            [self.layer addSublayer:_disabledUnderline];
        }

        _disabledUnderline.opacity = 1.f;
    }

    _underline.lineWidth = self.lineHeight;

    [self updateUnderlinePath];
    [self updateColor];
}

- (void)updateColor {
    BOOL showUnderline = self.enabled;
    UIColor *strokeColor = [UIColor clearColor];
    if (showUnderline) {
        strokeColor = _color;
    }

    self.disabledUnderline.strokeColor = self.disabledColor.CGColor;
    self.underline.strokeColor = strokeColor.CGColor;
    self.opaque = showUnderline;
}

#pragma mark - Property implementation

- (void)setColor:(UIColor *)color {
    _color = color;
    [self updateColor];
}

- (void)setEnabled:(BOOL)enabled {
    if (_enabled != enabled) {
        _enabled = enabled;
        [self updateUnderline];
        [self updateColor];
    }
}

- (void)setLineHeight:(CGFloat)lineHeight {
    if (_lineHeight != lineHeight) {
        _lineHeight = lineHeight;
    }
    [self updateUnderline];
}

@end
