//
//  GTUIAlertControllerView+Private.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//
#import "GTUIAlertControllerView.h"
#import "GTUIAlertControllerView+Private.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTButton.h"
#import "GTMath.h"
#import "GTTypography.h"

// https://material.io/go/design-dialogs#dialogs-specs
static const GTUIFontTextStyle kTitleTextStyle = GTUIFontTextStyleTitle;
static const GTUIFontTextStyle kMessageTextStyle = GTUIFontTextStyleBody1;
static const GTUIFontTextStyle kButtonTextStyle = GTUIFontTextStyleButton;

static const UIEdgeInsets GTUIDialogContentInsets = {24.0, 24.0, 24.0, 24.0};
static const CGFloat GTUIDialogContentVerticalPadding = 20.0;
static const CGFloat GTUIDialogTitleIconVerticalPadding = 12.0;

static const UIEdgeInsets GTUIDialogActionsInsets = {8.0, 8.0, 8.0, 8.0};
static const CGFloat GTUIDialogActionsHorizontalPadding = 0;
static const CGFloat GTUIDialogActionsVerticalPadding = 0;
static const CGFloat GTUIDialogActionButtonHeight = 48.0;
static const CGFloat GTUIDialogActionButtonMinimumWidth = 48.0;
static const CGFloat GTUIDialogActionMinTouchTarget = 48.f;

static const CGFloat GTUIDialogMessageOpacity = 0.54f;

@interface GTUIAlertControllerView ()

@property(nonatomic, nonnull, strong) UIScrollView *contentScrollView;
@property(nonatomic, nonnull, strong) UIScrollView *actionsScrollView;

@property(nonatomic, getter=isVerticalActionsLayout) BOOL verticalActionsLayout;

@end

@implementation GTUIAlertControllerView{
    BOOL _gtui_adjustsFontForContentSizeCategory;
}

@dynamic titleAlignment;
@dynamic messageAlignment;
@dynamic titleIcon;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = NO;
        self.clipsToBounds = YES;

        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.contentScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentScrollView];

        self.actionsScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.actionsScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.actionsScrollView];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentNatural;
        if (self.gtui_adjustsFontForContentSizeCategory) {
            self.titleLabel.font = [UIFont gtui_preferredFontForTextStyle:GTUIFontTextStyleTitle];
        } else {
            self.titleLabel.font = [GTUITypography titleFont];
        }
        self.titleLabel.accessibilityTraits |= UIAccessibilityTraitHeader;
        [self.contentScrollView addSubview:self.titleLabel];

        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textAlignment = NSTextAlignmentNatural;
        if (self.gtui_adjustsFontForContentSizeCategory) {
            self.messageLabel.font = [UIFont gtui_preferredFontForTextStyle:GTUIFontTextStyleBody1];
        } else {
            self.messageLabel.font = [GTUITypography body1Font];
        }
        self.messageLabel.textColor = [UIColor colorWithWhite:0.0f alpha:GTUIDialogMessageOpacity];
        [self.contentScrollView addSubview:self.messageLabel];

        [self setNeedsLayout];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;

    [self setNeedsLayout];
}

- (void)addActionButton:(nonnull GTUIButton *)button {
    if (button.superview == nil) {
        button.gtui_adjustsFontForContentSizeCategory = self.gtui_adjustsFontForContentSizeCategory;
        [self.actionsScrollView addSubview:button];
        if (_buttonColor) {
            // We only set if _buttonColor since settingTitleColor to nil doesn't
            // reset the title to the default
            [button setTitleColor:_buttonColor forState:UIControlStateNormal];
        }
        [button setTitleFont:_buttonFont forState:UIControlStateNormal];
        button.inkColor = self.buttonInkColor;
        // TODO(#1726): Determine default text color values for Normal and Disabled
        CGRect buttonRect = button.bounds;
        buttonRect.size.height = MAX(buttonRect.size.height, GTUIDialogActionButtonHeight);
        buttonRect.size.width = MAX(buttonRect.size.width, GTUIDialogActionButtonMinimumWidth);
        button.frame = buttonRect;
    }
}

+ (void)styleAsTextButton:(nonnull GTUIButton *)button {
    // This preserves default buttons style (as GTUIFlatButton/text) for backward compatibility reasons
    UIColor *themeColor = [UIColor blackColor];
    [button setBackgroundColor:UIColor.clearColor forState:UIControlStateNormal];
    [button setTitleColor:themeColor forState:UIControlStateNormal];
    [button setImageTintColor:themeColor forState:UIControlStateNormal];
    [button setInkColor:[UIColor colorWithWhite:0 alpha:0.06f]];
    [button setElevation:GTUIShadowElevationNone forState:UIControlStateNormal];
    button.disabledAlpha = 1.f;

}

- (void)setTitleFont:(UIFont *)font {
    _titleFont = font;

    [self updateTitleFont];
}

- (void)updateTitleFont {
    UIFont *titleFont = _titleFont ?: [[self class] titleFontDefault];
    if (_gtui_adjustsFontForContentSizeCategory) {
        _titleLabel.font =
        [titleFont gtui_fontSizedForFontTextStyle:kTitleTextStyle
                                scaledForDynamicType:_gtui_adjustsFontForContentSizeCategory];
    } else {
        _titleLabel.font = titleFont;
    }
    [self setNeedsLayout];
}

+ (UIFont *)titleFontDefault {
    if ([GTUITypography.fontLoader isKindOfClass:[GTUISystemFontLoader class]]) {
        return [UIFont gtui_standardFontForTextStyle:kTitleTextStyle];
    }
    return [GTUITypography titleFont];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;

    _titleLabel.textColor = titleColor;
}

- (NSTextAlignment)titleAlignment {
    return self.titleLabel.textAlignment;
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    self.titleLabel.textAlignment = titleAlignment;
}

- (NSTextAlignment)messageAlignment {
    return self.messageLabel.textAlignment;
}

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment {
    self.messageLabel.textAlignment = messageAlignment;
}

- (UIImage *)titleIcon {
    return self.titleIconImageView.image;
}

- (void)setTitleIcon:(UIImage *)titleIcon {
    if (titleIcon == nil) {
        [self.titleIconImageView removeFromSuperview];
        self.titleIconImageView = nil;
    } else if (self.titleIconImageView == nil) {
        self.titleIconImageView = [[UIImageView alloc] initWithImage:titleIcon];
        self.titleIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentScrollView addSubview:self.titleIconImageView];
    } else {
        self.titleIconImageView.image = titleIcon;
    }

    self.titleIconImageView.tintColor = self.titleIconTintColor;
    [self.titleIconImageView sizeToFit];
}

- (void)setTitleIconTintColor:(UIColor *)titleIconTintColor {
    _titleIconTintColor = titleIconTintColor;
    self.titleIconImageView.tintColor = titleIconTintColor;
}

- (NSString *)message {
    return self.messageLabel.text;
}

- (void)setMessage:(NSString *)message {
    self.messageLabel.text = message;

    [self setNeedsLayout];
}

- (void)setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;

    [self updateMessageFont];
}

- (void)updateMessageFont {
    UIFont *messageFont = _messageFont ?: [[self class] messageFontDefault];
    if (_gtui_adjustsFontForContentSizeCategory) {
        _messageLabel.font =
        [messageFont gtui_fontSizedForFontTextStyle:kMessageTextStyle
                                  scaledForDynamicType:_gtui_adjustsFontForContentSizeCategory];
    } else {
        _messageLabel.font = messageFont;
    }
    [self setNeedsLayout];
}

+ (UIFont *)messageFontDefault {
    if ([GTUITypography.fontLoader isKindOfClass:[GTUISystemFontLoader class]]) {
        return [UIFont gtui_standardFontForTextStyle:kMessageTextStyle];
    }
    return [GTUITypography body1Font];
}

- (void)setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;

    _messageLabel.textColor = messageColor;
}

- (void)setButtonFont:(UIFont *)font {
    _buttonFont = font;

    [self updateButtonFont];
}

- (void)updateButtonFont {
    UIFont *finalButtonFont = _buttonFont ?: [[self class] buttonFontDefault];
    if (_gtui_adjustsFontForContentSizeCategory) {
        finalButtonFont =
        [finalButtonFont gtui_fontSizedForFontTextStyle:kTitleTextStyle
                                      scaledForDynamicType:_gtui_adjustsFontForContentSizeCategory];
    }
    for (GTUIButton *button in self.actionManager.buttonsInActionOrder) {
        [button setTitleFont:finalButtonFont forState:UIControlStateNormal];
    }

    [self setNeedsLayout];
}

+ (UIFont *)buttonFontDefault {
    if ([GTUITypography.fontLoader isKindOfClass:[GTUISystemFontLoader class]]) {
        return [UIFont gtui_standardFontForTextStyle:kButtonTextStyle];
    }
    return [GTUITypography titleFont];
}


- (void)setButtonColor:(UIColor *)color {
    _buttonColor = color;

    for (GTUIButton *button in self.actionManager.buttonsInActionOrder) {
        [button setTitleColor:_buttonColor forState:UIControlStateNormal];
    }
}

- (void)setButtonInkColor:(UIColor *)color {
    _buttonInkColor = color;

    for (GTUIButton *button in self.actionManager.buttonsInActionOrder) {
        button.inkColor = color;
    }
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (GTUICGFloatEqual(cornerRadius, self.layer.cornerRadius)) {
        return;
    }
    self.layer.cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

#pragma mark - Internal


- (CGSize)actionButtonsSizeInHorizontalLayout {
    CGSize size = CGSizeZero;
    NSArray<GTUIButton *> *buttons = self.actionManager.buttonsInActionOrder;
    if (0 < [buttons count]) {
        size.height =
        GTUIDialogActionsInsets.top + GTUIDialogActionButtonHeight + GTUIDialogActionsInsets.bottom;
        size.width = GTUIDialogActionsInsets.left + GTUIDialogActionsInsets.right;
        for (UIButton *button in buttons) {
            CGSize buttonSize = [button sizeThatFits:size];
            size.width += buttonSize.width;
            if (button != [buttons lastObject]) {
                size.width += GTUIDialogActionsHorizontalPadding;
            }
        }
    }

    return size;
}

- (CGSize)actionButtonsSizeInVericalLayout {
    CGSize size = CGSizeZero;
    NSArray<GTUIButton *> *buttons = self.actionManager.buttonsInActionOrder;
    if (0 < [buttons count]) {
        size.height = GTUIDialogActionsInsets.top + GTUIDialogActionsInsets.bottom;
        size.width = GTUIDialogActionsInsets.left + GTUIDialogActionsInsets.right;
        for (UIButton *button in buttons) {
            CGSize buttonSize = [button sizeThatFits:size];
            buttonSize.height = MAX(buttonSize.height, GTUIDialogActionButtonHeight);
            size.height += buttonSize.height;
            size.width = MAX(size.width, buttonSize.width);
            if (button != [buttons lastObject]) {
                size.height += GTUIDialogActionsVerticalPadding;
            }
        }
    }
    return size;
}


// @param boundsSize should not include any internal margins or padding
- (CGSize)calculatePreferredContentSizeForBounds:(CGSize)boundsSize {
    // Content & Actions
    CGSize contentSize = [self calculateContentSizeThatFitsWidth:boundsSize.width];
    CGSize actionSize = [self calculateActionsSizeThatFitsWidth:boundsSize.width];

    // Final Sizing
    CGSize totalSize;
    totalSize.width = MAX(contentSize.width, actionSize.width);
    totalSize.height = contentSize.height + actionSize.height;

    return totalSize;
}

// @param boundingWidth should not include any internal margins or padding
- (CGSize)calculateContentSizeThatFitsWidth:(CGFloat)boundingWidth {
    CGSize boundsSize = CGRectInfinite.size;
    boundsSize.width = boundingWidth - GTUIDialogContentInsets.left - GTUIDialogContentInsets.right;

    CGSize titleIconSize = CGSizeZero;
    if (self.titleIconImageView != nil) {
        // TODO(galiak): Have title-icon size respond to dynamic type or device screen size, once this:
        // https://github.com/material-components/material-components-ios/issues/5198 is resolved.
        titleIconSize = self.titleIconImageView.image.size;
    }

    CGSize titleSize = [self.titleLabel sizeThatFits:boundsSize];
    CGSize messageSize = [self.messageLabel sizeThatFits:boundsSize];

    CGFloat contentWidth = MAX(titleSize.width, messageSize.width);
    contentWidth += GTUIDialogContentInsets.left + GTUIDialogContentInsets.right;

    CGFloat contentInternalVerticalPadding = 0.0;
    if ((0.0 < titleSize.height || 0.0 < titleIconSize.height) && 0.0 < messageSize.height) {
        contentInternalVerticalPadding = GTUIDialogContentVerticalPadding;
    }
    CGFloat contentTitleIconVerticalPadding = 0.0f;
    if (0.0 < titleSize.height && 0.0 < titleIconSize.height) {
        contentTitleIconVerticalPadding = GTUIDialogTitleIconVerticalPadding;
    }
    CGFloat contentHeight = titleIconSize.height + contentTitleIconVerticalPadding +
    titleSize.height + contentInternalVerticalPadding + messageSize.height;
    contentHeight += GTUIDialogContentInsets.top + GTUIDialogContentInsets.bottom;

    CGSize contentSize;
    contentSize.width = (CGFloat)ceil(contentWidth);
    contentSize.height = (CGFloat)ceil(contentHeight);

    return contentSize;
}

// @param boundingWidth should not include any internal margins or padding
- (CGSize)calculateActionsSizeThatFitsWidth:(CGFloat)boundingWidth {
    CGSize boundsSize = CGRectInfinite.size;
    boundsSize.width = boundingWidth;

    CGSize horizontalSize = [self actionButtonsSizeInHorizontalLayout];
    CGSize verticalSize = [self actionButtonsSizeInVericalLayout];

    CGSize actionsSize;
    if (boundsSize.width < horizontalSize.width) {
        // Use VerticalLayout
        actionsSize.width = MIN(verticalSize.width, boundsSize.width);
        actionsSize.height = MIN(verticalSize.height, boundsSize.height);
    } else {
        // Use HorizontalLayout
        actionsSize.width = MIN(horizontalSize.width, boundsSize.width);
        actionsSize.height = MIN(horizontalSize.height, boundsSize.height);
    }

    actionsSize.width = (CGFloat)ceil(actionsSize.width);
    actionsSize.height = (CGFloat)ceil(actionsSize.height);

    return actionsSize;
}


- (void)layoutSubviews {
    [super layoutSubviews];

    NSArray<GTUIButton *> *buttons = self.actionManager.buttonsInActionOrder;

    for (GTUIButton *button in buttons) {

        [button sizeToFit];
        CGRect buttonFrame = button.frame;
        buttonFrame.size.width =
        MAX(CGRectGetWidth(buttonFrame), GTUIDialogActionButtonMinimumWidth);
        buttonFrame.size.height =
        MAX(CGRectGetHeight(buttonFrame), GTUIDialogActionButtonHeight);
        button.frame = buttonFrame;
        CGFloat verticalInsets = (CGRectGetHeight(button.frame) - GTUIDialogActionMinTouchTarget) / 2;
        CGFloat horizontalInsets = (CGRectGetWidth(button.frame) - GTUIDialogActionMinTouchTarget) / 2;
        verticalInsets = MIN(0, verticalInsets);
        horizontalInsets = MIN(0, horizontalInsets);
        button.hitAreaInsets = UIEdgeInsetsMake(verticalInsets,
                                                horizontalInsets,
                                                verticalInsets,
                                                horizontalInsets);
    }

    // Used to calculate the height of the scrolling content, so we limit the width.
    CGSize boundsSize = CGRectInfinite.size;
    boundsSize.width = CGRectGetWidth(self.bounds);

    // Content
    CGSize contentSize = [self calculateContentSizeThatFitsWidth:boundsSize.width];

    CGRect contentRect = CGRectZero;
    contentRect.size.width = CGRectGetWidth(self.bounds);
    contentRect.size.height = contentSize.height;

    self.contentScrollView.contentSize = contentRect.size;

    // Place Content in contentScrollView
    boundsSize.width = boundsSize.width - GTUIDialogContentInsets.left - GTUIDialogContentInsets.right;
    CGSize titleSize = [self.titleLabel sizeThatFits:boundsSize];
    titleSize.width = boundsSize.width;

    CGSize titleIconSize = CGSizeZero;
    if (self.titleIconImageView != nil) {
        // TODO(galiak): Have title-icon size respond to dynamic type or device screen size, once this:
        // https://github.com/material-components/material-components-ios/issues/5198 is resolved.
        titleIconSize = self.titleIconImageView.image.size;
    }

    CGSize messageSize = [self.messageLabel sizeThatFits:boundsSize];
    messageSize.width = boundsSize.width;
    boundsSize.width = boundsSize.width + GTUIDialogContentInsets.left + GTUIDialogContentInsets.right;

    CGFloat contentInternalVerticalPadding = 0.0;
    if ((0.0 < titleSize.height || 0.0 < titleIconSize.height) && 0.0 < messageSize.height) {
        contentInternalVerticalPadding = GTUIDialogContentVerticalPadding;
    }
    CGFloat contentTitleIconVerticalPadding = 0.0f;
    if (0.0 < titleSize.height && 0.0 < titleIconSize.height) {
        contentTitleIconVerticalPadding = GTUIDialogTitleIconVerticalPadding;
    }

    CGFloat titleTop =
    GTUIDialogContentInsets.top + contentTitleIconVerticalPadding + titleIconSize.height;
    CGRect titleFrame =
    CGRectMake(GTUIDialogContentInsets.left, titleTop, titleSize.width, titleSize.height);
    CGRect messageFrame = CGRectMake(GTUIDialogContentInsets.left,
                                     CGRectGetMaxY(titleFrame) + contentInternalVerticalPadding,
                                     messageSize.width, messageSize.height);

    self.titleLabel.frame = titleFrame;
    self.messageLabel.frame = messageFrame;

    if (self.titleIconImageView != nil) {
        // match the titleIcon alignment to the title alignment
        CGFloat titleIconPosition = titleFrame.origin.x;
        if (self.titleAlignment == NSTextAlignmentCenter) {
            titleIconPosition = (contentSize.width - titleIconSize.width) / 2.0f;
        } else if (self.titleAlignment == NSTextAlignmentRight ||
                   (self.titleAlignment == NSTextAlignmentNatural &&
                    [self gtf_effectiveUserInterfaceLayoutDirection] ==
                    UIUserInterfaceLayoutDirectionRightToLeft)) {
                       titleIconPosition = CGRectGetMaxX(titleFrame) - titleIconSize.width;
                   }
        CGRect titleIconFrame = CGRectMake(titleIconPosition, GTUIDialogContentInsets.top,
                                           titleIconSize.width, titleIconSize.height);
        self.titleIconImageView.frame = titleIconFrame;
    }

    // Actions
    CGSize actionSize = [self calculateActionsSizeThatFitsWidth:boundsSize.width];
    const CGFloat horizontalActionHeight =
    GTUIDialogActionsInsets.top + GTUIDialogActionButtonHeight + GTUIDialogActionsInsets.bottom;
    if (horizontalActionHeight < actionSize.height) {
        self.verticalActionsLayout = YES;
    } else {
        self.verticalActionsLayout = NO;
    }


    CGRect actionsFrame = CGRectZero;
    actionsFrame.size.width = CGRectGetWidth(self.bounds);
    if (0 < [buttons count]) {
        actionsFrame.size.height = actionSize.height;
    }
    self.actionsScrollView.contentSize = actionsFrame.size;

//    // Place buttons in actionsScrollView
//    if (self.isVerticalActionsLayout) {
//        CGPoint buttonCenter;
//        buttonCenter.x = self.actionsScrollView.contentSize.width * 0.5f;
//        buttonCenter.y = self.actionsScrollView.contentSize.height - GTUIDialogActionsInsets.bottom;
//        for (UIButton *button in buttons) {
//            CGRect buttonRect = button.frame;
//
//            buttonCenter.y -= buttonRect.size.height * 0.5;
//
//            button.center = buttonCenter;
//
//            if (button != [buttons lastObject]) {
//                buttonCenter.y -= buttonRect.size.height * 0.5;
//                buttonCenter.y -= GTUIDialogActionsVerticalPadding;
//            }
//        }
//    } else {
//        CGPoint buttonOrigin = CGPointZero;
//        buttonOrigin.x = self.actionsScrollView.contentSize.width - GTUIDialogActionsInsets.right;
//        buttonOrigin.y = GTUIDialogActionsInsets.top;
//        for (UIButton *button in buttons) {
//            CGRect buttonRect = button.frame;
//
//            buttonOrigin.x -= buttonRect.size.width;
//            buttonRect.origin = buttonOrigin;
//
//            button.frame = buttonRect;
//
//            if (button != [buttons lastObject]) {
//                buttonOrigin.x -= GTUIDialogActionsHorizontalPadding;
//            }
//        }
//        // Handle RTL
//        if (self.gtf_effectiveUserInterfaceLayoutDirection ==
//            UIUserInterfaceLayoutDirectionRightToLeft) {
//            for (UIButton *button in buttons) {
//                CGRect flippedRect =
//                GTFRectFlippedHorizontally(button.frame, CGRectGetWidth(self.bounds));
//                button.frame = flippedRect;
//            }
//        }
//    }

    // Place buttons in actionsScrollView
    if (self.isVerticalActionsLayout) {
        CGPoint buttonCenter;
        buttonCenter.x = self.actionsScrollView.contentSize.width * 0.5f;
        buttonCenter.y = self.actionsScrollView.contentSize.height - GTUIDialogActionsInsets.bottom;
        for (UIButton *button in buttons) {
            CGRect buttonRect = button.frame;
            buttonRect.size.width = self.frame.size.width;
            button.frame = buttonRect;

            buttonCenter.y -= buttonRect.size.height * 0.5;
            button.center = buttonCenter;

            if (button != [buttons lastObject]) {
                buttonCenter.y -= buttonRect.size.height * 0.5;
                buttonCenter.y -= GTUIDialogActionsVerticalPadding;
            }
        }
    } else {
        CGPoint buttonOrigin = CGPointZero;
        buttonOrigin.x = self.actionsScrollView.contentSize.width - GTUIDialogActionsInsets.right;
        buttonOrigin.y = GTUIDialogActionsInsets.top;
        for (UIButton *button in buttons) {
            CGRect buttonRect = button.frame;

            buttonOrigin.x -= buttonRect.size.width;
            buttonRect.origin = buttonOrigin;

            button.frame = buttonRect;

            if (button != [buttons lastObject]) {
                buttonOrigin.x -= GTUIDialogActionsHorizontalPadding;
            }
        }

        // Handle RTL
        if (self.gtf_effectiveUserInterfaceLayoutDirection ==
            UIUserInterfaceLayoutDirectionRightToLeft) {
            for (UIButton *button in buttons) {
                CGRect flippedRect =
                GTFRectFlippedHorizontally(button.frame, CGRectGetWidth(self.bounds));
                button.frame = flippedRect;
            }
        }
    }

    // Place scrollviews
    CGRect contentScrollViewRect = CGRectZero;
    contentScrollViewRect.size = self.contentScrollView.contentSize;

    CGRect actionsScrollViewRect = CGRectZero;
    actionsScrollViewRect.size = self.actionsScrollView.contentSize;

    const CGFloat requestedHeight =
    self.contentScrollView.contentSize.height + self.actionsScrollView.contentSize.height;
    if (requestedHeight <= CGRectGetHeight(self.bounds)) {
        // Simple layout case : both content and actions fit on the screen at once
        self.contentScrollView.frame = contentScrollViewRect;

        actionsScrollViewRect.origin.y =
        CGRectGetHeight(self.bounds) - actionsScrollViewRect.size.height;
        self.actionsScrollView.frame = actionsScrollViewRect;
    } else {
        // Complex layout case : Split the space between the two scrollviews
        if (CGRectGetHeight(contentScrollViewRect) < CGRectGetHeight(self.bounds) * 0.5f) {
            actionsScrollViewRect.size.height =
            CGRectGetHeight(self.bounds) - contentScrollViewRect.size.height;
        } else {
            CGFloat maxActionsHeight = CGRectGetHeight(self.bounds) * 0.5f;
            actionsScrollViewRect.size.height = MIN(maxActionsHeight, actionsScrollViewRect.size.height);
        }
        actionsScrollViewRect.origin.y =
        CGRectGetHeight(self.bounds) - actionsScrollViewRect.size.height;
        self.actionsScrollView.frame = actionsScrollViewRect;

        contentScrollViewRect.size.height =
        CGRectGetHeight(self.bounds) - actionsScrollViewRect.size.height;
        self.contentScrollView.frame = contentScrollViewRect;
    }
}

#pragma mark - Dynamic Type

- (BOOL)gtui_adjustsFontForContentSizeCategory {
    return _gtui_adjustsFontForContentSizeCategory;
}

- (void)gtui_setAdjustsFontForContentSizeCategory:(BOOL)adjusts {
    _gtui_adjustsFontForContentSizeCategory = adjusts;

    for (GTUIButton *button in self.actionManager.buttonsInActionOrder) {
        button.gtui_adjustsFontForContentSizeCategory = adjusts;
    }

    [self updateFonts];
}

// Update the fonts used based on whether Dynamic Type is enabled
- (void)updateFonts {
    [self updateTitleFont];
    [self updateMessageFont];
    [self updateButtonFont];

    [self setNeedsLayout];
}



@end
