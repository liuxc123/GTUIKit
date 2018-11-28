//
//  GTUIDialogItemView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/26.
//

#import "GTUIDialogItemView.h"

#define DEFAULTBORDERWIDTH (1.0f / [[UIScreen mainScreen] scale] + 0.02f)

@implementation GTUIDialogItem

- (void)update{

    if (self.updateBlock) self.updateBlock(self);
}

@end

@implementation GTUIDialogItemView

+ (GTUIDialogItemView *)view {
    return [[GTUIDialogItemView alloc] init];
}

@end

@implementation GTUIDialogItemLabel


+ (GTUIDialogItemLabel *)label{

    return [[GTUIDialogItemLabel alloc] init];
}

- (void)setText:(NSString *)text{

    [super setText:text];

    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setAttributedText:(NSAttributedString *)attributedText{

    [super setAttributedText:attributedText];

    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setFont:(UIFont *)font{

    [super setFont:font];

    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setNumberOfLines:(NSInteger)numberOfLines{

    [super setNumberOfLines:numberOfLines];

    if (self.textChangedBlock) self.textChangedBlock();
}

@end


@implementation GTUIDialogItemTextField

+ (GTUIDialogItemTextField *)textField{

    return [[GTUIDialogItemTextField alloc] init];
}

@end


@interface GTUIDialogActionButton ()

@property (nonatomic , strong ) UIColor *borderColor;

@property (nonatomic , assign ) CGFloat borderWidth;

@property (nonatomic , strong ) CALayer *topLayer;

@property (nonatomic , strong ) CALayer *bottomLayer;

@property (nonatomic , strong ) CALayer *leftLayer;

@property (nonatomic , strong ) CALayer *rightLayer;

@end

@implementation GTUIDialogActionButton

+ (GTUIDialogActionButton *)button{

    return [GTUIDialogActionButton buttonWithType:UIButtonTypeCustom];;
}

- (void)setAction:(GTUIDialogAction *)action{

    _action = action;

    self.clipsToBounds = YES;

    if (action.title) [self setTitle:action.title forState:UIControlStateNormal];

    if (action.highlight) [self setTitle:action.highlight forState:UIControlStateHighlighted];

    if (action.attributedTitle) [self setAttributedTitle:action.attributedTitle forState:UIControlStateNormal];

    if (action.attributedHighlight) [self setAttributedTitle:action.attributedHighlight forState:UIControlStateHighlighted];

    if (action.font) [self setTitleFont:action.font forState:UIControlStateNormal];

    if (action.font) [self setTitleFont:action.font forState:UIControlStateHighlighted];

    if (action.titleColor) [self setTitleColor:action.titleColor forState:UIControlStateNormal];

    if (action.highlightColor) [self setTitleColor:action.highlightColor forState:UIControlStateHighlighted];

    if (action.backgroundColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundColor] forState:UIControlStateNormal];

    if (action.backgroundHighlightColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundHighlightColor] forState:UIControlStateHighlighted];

    if (action.backgroundImage) [self setBackgroundImage:action.backgroundImage forState:UIControlStateNormal];

    if (action.backgroundHighlightImage) [self setBackgroundImage:action.backgroundHighlightImage forState:UIControlStateHighlighted];

    if (action.borderColor) [self setBorderColor:action.borderColor];

    if (action.borderWidth > 0) [self setBorderWidth:action.borderWidth < DEFAULTBORDERWIDTH ? DEFAULTBORDERWIDTH : action.borderWidth]; else [self setBorderWidth:0.0f];

    if (action.image) [self setImage:action.image forState:UIControlStateNormal];

    if (action.highlightImage) [self setImage:action.highlightImage forState:UIControlStateHighlighted];

    if (action.height) [self setActionHeight:action.height];

    if (action.cornerRadius) [self.layer setCornerRadius:action.cornerRadius];

    [self setImageEdgeInsets:action.imageEdgeInsets];

    [self setTitleEdgeInsets:action.titleEdgeInsets];

    if (action.borderPosition & GTUIActionBorderPositionTop &&
        action.borderPosition & GTUIActionBorderPositionBottom &&
        action.borderPosition & GTUIActionBorderPositionLeft &&
        action.borderPosition & GTUIActionBorderPositionRight) {

        self.layer.borderWidth = action.borderWidth;

        self.layer.borderColor = action.borderColor.CGColor;

        [self removeTopBorder];

        [self removeBottomBorder];

        [self removeLeftBorder];

        [self removeRightBorder];

    } else {

        self.layer.borderWidth = 0.0f;

        self.layer.borderColor = [UIColor clearColor].CGColor;

        if (action.borderPosition & GTUIActionBorderPositionTop) [self addTopBorder]; else [self removeTopBorder];

        if (action.borderPosition & GTUIActionBorderPositionBottom) [self addBottomBorder]; else [self removeBottomBorder];

        if (action.borderPosition & GTUIActionBorderPositionLeft) [self addLeftBorder]; else [self removeLeftBorder];

        if (action.borderPosition & GTUIActionBorderPositionRight) [self addRightBorder]; else [self removeRightBorder];
    }

    __weak typeof(self) weakSelf = self;

    action.updateBlock = ^(GTUIDialogAction *act) {

        if (weakSelf) weakSelf.action = act;
    };

}

- (CGFloat)actionHeight{

    return self.frame.size.height;
}

- (void)setActionHeight:(CGFloat)height{

    BOOL isChange = [self actionHeight] == height ? NO : YES;

    CGRect buttonFrame = self.frame;

    buttonFrame.size.height = height;

    self.frame = buttonFrame;

    if (isChange) {

        if (self.heightChangedBlock) self.heightChangedBlock();
    }

}

- (void)layoutSubviews{

    [super layoutSubviews];

    if (_topLayer) _topLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.borderWidth);

    if (_bottomLayer) _bottomLayer.frame = CGRectMake(0, self.frame.size.height - self.borderWidth, self.frame.size.width, self.borderWidth);

    if (_leftLayer) _leftLayer.frame = CGRectMake(0, 0, self.borderWidth, self.frame.size.height);

    if (_rightLayer) _rightLayer.frame = CGRectMake(self.frame.size.width - self.borderWidth, 0, self.borderWidth, self.frame.size.height);
}

- (void)addTopBorder{

    [self.layer addSublayer:self.topLayer];
}

- (void)addBottomBorder{

    [self.layer addSublayer:self.bottomLayer];
}

- (void)addLeftBorder{

    [self.layer addSublayer:self.leftLayer];
}

- (void)addRightBorder{

    [self.layer addSublayer:self.rightLayer];
}

- (void)removeTopBorder{

    if (_topLayer) [_topLayer removeFromSuperlayer]; _topLayer = nil;
}

- (void)removeBottomBorder{

    if (_bottomLayer) [_bottomLayer removeFromSuperlayer]; _bottomLayer = nil;
}

- (void)removeLeftBorder{

    if (_leftLayer) [_leftLayer removeFromSuperlayer]; _leftLayer = nil;
}

- (void)removeRightBorder{

    if (_rightLayer) [_rightLayer removeFromSuperlayer]; _rightLayer = nil;
}

- (CALayer *)createLayer{

    CALayer *layer = [CALayer layer];

    layer.backgroundColor = self.borderColor.CGColor;

    return layer;
}

- (CALayer *)topLayer{

    if (!_topLayer) _topLayer = [self createLayer];

    return _topLayer;
}

- (CALayer *)bottomLayer{

    if (!_bottomLayer) _bottomLayer = [self createLayer];

    return _bottomLayer;
}

- (CALayer *)leftLayer{

    if (!_leftLayer) _leftLayer = [self createLayer];

    return _leftLayer;
}

- (CALayer *)rightLayer{

    if (!_rightLayer) _rightLayer = [self createLayer];

    return _rightLayer;
}

- (UIImage *)getImageWithColor:(UIColor *)color {

    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);

    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

@end

@interface GTUIDialogItemCustomView ()


@end

@implementation GTUIDialogItemCustomView


- (void)dealloc{

    if (_view) [_view removeObserver:self forKeyPath:@"frame"];
}

- (void)setSizeChangedBlock:(void (^)(void))sizeChangedBlock{

    _sizeChangedBlock = sizeChangedBlock;

    if (_view) {

        [_view layoutSubviews];

        _size = _view.frame.size;

        [_view addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    UIView *view = (UIView *)object;

    if (self.isAutoWidth) {
        self.size = CGSizeMake(view.frame.size.width, self.size.height);
    }

    if (!CGSizeEqualToSize(self.size, view.frame.size)) {

        self.size = view.frame.size;

        if (self.sizeChangedBlock) self.sizeChangedBlock();
    }

}

@end


