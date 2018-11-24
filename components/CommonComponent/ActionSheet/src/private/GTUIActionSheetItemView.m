//
//  GTUIActionSheetItemView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import "GTUIActionSheetItemView.h"

#import "GTTypography.h"

static const CGFloat kLabelAlpha = 0.87f;
static const CGFloat kImageLeadingPadding = 16.f;
static const CGFloat kImageTopPadding = 16.f;
static const CGFloat kImageHeightAndWidth = 24.f;
static const CGFloat kTitleLeadingPadding = 72.f;
static const CGFloat kTitleTrailingPadding = 16.f;
static const CGFloat kActionItemTitleVerticalPadding = 18.f;

@interface GTUIActionSheetItemView ()
@property(nonatomic, strong) UILabel *actionLabel;
@property(nonatomic, strong) UIImageView *actionImageView;
@property(nonatomic, strong) UIButton *actionButton;
@property(nonatomic, strong) GTUIInkTouchController *inkTouchController;
@property(nonatomic, strong) UIView *contentView;
@end

@implementation GTUIActionSheetItemView{
    GTUIActionSheetAction *_itemAction;
    NSLayoutConstraint *_contentLeadingConstraint;
    NSLayoutConstraint *_contentTralingConstraint;
    NSLayoutConstraint *_contentCenterXConstraint;
    NSLayoutConstraint *_titleLabelLeadingConstraint;
    NSLayoutConstraint *_imageViewWidthConstraint;
    NSLayoutConstraint *_imageViewHeightConstraint;

}

@synthesize gtui_adjustsFontForContentSizeCategory = _gtui_adjustsFontForContentSizeCategory;

- (instancetype)initWithType:(GTUIActionSheetType)type
{
    self = [super init];
    if (self) {
        _type = type;
        [self commonGTUIActionSheetItemViewInit];
        [self commonLayout];
    }
    return self;
}

- (void)commonGTUIActionSheetItemViewInit {
    self.accessibilityTraits = UIAccessibilityTraitButton;

    [self addSubview:self.contentView];
    [self.contentView addSubview:self.actionLabel];
    [self.contentView addSubview:self.actionImageView];
    [self.inkTouchController addInkView];

}

- (void)commonLayout {

    //contentView
    _contentLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];

    _contentLeadingConstraint.active = YES;

    _contentTralingConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0];

    _contentTralingConstraint.active = YES;


    [NSLayoutConstraint constraintWithItem:self.contentView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0]
    .active = YES;

    [NSLayoutConstraint constraintWithItem:self.contentView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0]
    .active = YES;


   _contentCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0];
    _contentCenterXConstraint.active = NO;


    //actionImageView

    [NSLayoutConstraint constraintWithItem:self.actionImageView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:self.actionImageView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:0]
    .active = YES;
    _imageViewWidthConstraint =[NSLayoutConstraint constraintWithItem:self.actionImageView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                constant:kImageHeightAndWidth];
    _imageViewWidthConstraint.active = YES;
    _imageViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.actionImageView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                constant:kImageHeightAndWidth];
    _imageViewHeightConstraint.active = YES;


    // actionLabel
    [NSLayoutConstraint constraintWithItem:self.actionLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0]
    .active = YES;

    [NSLayoutConstraint constraintWithItem:self.actionLabel
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0]
    .active = YES;

    _titleLabelLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.actionLabel
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.actionImageView
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                constant:10];
    _titleLabelLeadingConstraint.active = YES;

    [NSLayoutConstraint constraintWithItem:self.actionLabel
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0]
    .active = YES;



}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!_itemAction.image) {
        _imageViewWidthConstraint.constant = 0;
        _imageViewHeightConstraint.constant = 0;
        _titleLabelLeadingConstraint.constant = 0;
    } else {
        _imageViewWidthConstraint.constant = kImageHeightAndWidth;
        _imageViewHeightConstraint.constant = kImageHeightAndWidth;
        _titleLabelLeadingConstraint.constant = 10;
    }
    self.actionImageView.image = [_itemAction.image imageWithRenderingMode:self.imageRenderingMode];
}



#pragma mark - set/get

- (void)setAction:(GTUIActionSheetAction *)action {
    _itemAction = [action copy];
    self.actionLabel.text = _itemAction.title;
    self.actionImageView.image = _itemAction.image;
    [self setNeedsLayout];
}

- (GTUIActionSheetAction *)action {
    return _itemAction;
}

- (void)setType:(GTUIActionSheetType)type {
    _type = type;
    switch (self.type) {
        case GTUIActionSheetTypeNormal:
        case GTUIActionSheetTypeUIKit:
            _contentLeadingConstraint.active = NO;
            _contentTralingConstraint.active = NO;
            _contentCenterXConstraint.active = YES;

            break;
        case GTUIActionSheetTypeMaterial:
            _contentLeadingConstraint.active = YES;
            _contentTralingConstraint.active = YES;
            _contentCenterXConstraint.active = NO;
            break;
        default:
            break;
    }
    [self setNeedsLayout];
}

- (void)setActionFont:(UIFont *)actionFont {
    _actionFont = actionFont;
    [self updateTitleFont];
}

- (void)updateTitleFont {
    UIFont *titleFont = _actionFont ?:
    [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleSubheadline];
    if (self.gtui_adjustsFontForContentSizeCategory) {
        self.actionLabel.font =
        [titleFont gtui_fontSizedForFontTextStyle:GTUIFontTextStyleSubheadline
                             scaledForDynamicType:self.gtui_adjustsFontForContentSizeCategory];
    } else {
        self.actionLabel.font = titleFont;
    }
    [self setNeedsLayout];
}

- (void)gtui_setAdjustsFontForContentSizeCategory:(BOOL)adjusts {
    _gtui_adjustsFontForContentSizeCategory = adjusts;
    [self updateTitleFont];
}

- (void)setActionTextColor:(UIColor *)actionTextColor {
    _actionTextColor = actionTextColor;
    _actionLabel.textColor =
    actionTextColor ?: [UIColor.blackColor colorWithAlphaComponent:kLabelAlpha];
}

- (void)setInkColor:(UIColor *)inkColor {
    _inkColor = inkColor;
    // If no ink color then reset to the default ink color
    self.inkTouchController.defaultInkView.inkColor =
    inkColor ?: [[UIColor alloc] initWithWhite:0 alpha:0.14f];
}

- (void)setImageRenderingMode:(UIImageRenderingMode)imageRenderingMode {
    _imageRenderingMode = imageRenderingMode;
    [self setNeedsLayout];
}

#pragma mark - LazyLoad

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}

- (UILabel *)actionLabel {
    if (!_actionLabel) {
        _actionLabel = [[UILabel alloc] init];
        _actionLabel.numberOfLines = 0;
        _actionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_actionLabel sizeToFit];
        _actionLabel.font = [UIFont gtui_preferredFontForTextStyle:GTUIFontTextStyleSubheadline];
        _actionLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _actionLabel.textColor = [UIColor.blackColor colorWithAlphaComponent:kLabelAlpha];
    }
    return _actionLabel;
}

- (UIImageView *)actionImageView {
    if (!_actionImageView) {
        _actionImageView = [[UIImageView alloc] init];
        _actionImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _actionImageView;
}

- (GTUIInkTouchController *)inkTouchController {
    if (!_inkTouchController) {
        _inkTouchController = [[GTUIInkTouchController alloc] initWithView:self];
    }
    return _inkTouchController;
}

@end
