//
//  GTUIActionSheetHeaderView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import "GTUIActionSheetHeaderView.h"

#import "GTMath.h"
#import "GTTypography.h"

static const CGFloat kTitleLabelAlpha = 0.87f;
static const CGFloat kMessageLabelAlpha = 0.6f;
static const CGFloat kMessageOnlyPadding = 23.f;
static const CGFloat kLeadingPadding = 16.f;
static const CGFloat kTopStandardPadding = 16.f;
static const CGFloat kTrailingPadding = 16.f;
static const CGFloat kTitleOnlyPadding = 18.f;
static const CGFloat kMiddlePadding = 8.f;

@interface GTUIActionSheetHeaderView ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *messageLabel;

@end

@implementation GTUIActionSheetHeaderView

@synthesize gtui_adjustsFontForContentSizeCategory = _gtui_adjustsFontForContentSizeCategory;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_titleLabel];
        _titleLabel.font = [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleSubheadline];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _titleLabel.textAlignment = NSTextAlignmentNatural;

        [self addSubview:_messageLabel];
        _messageLabel.font = [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleBody1];
        _messageLabel.numberOfLines = 2;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.textColor = [UIColor.blackColor colorWithAlphaComponent:kMessageLabelAlpha];
        _messageLabel.textAlignment = NSTextAlignmentNatural;

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize size = CGRectInfinite.size;
    size.width = CGRectGetWidth(self.bounds);
    CGRect labelFrame = [self frameWithSafeAreaInsets:self.bounds];
    labelFrame = CGRectStandardize(labelFrame);
    labelFrame.size.width = labelFrame.size.width - kLeadingPadding - kTrailingPadding;
    CGSize titleSize = [self.titleLabel sizeThatFits:labelFrame.size];
    CGSize messageSize = [self.messageLabel sizeThatFits:labelFrame.size];
    CGRect titleFrame = CGRectMake(kLeadingPadding + labelFrame.origin.x, kTopStandardPadding,
                                   labelFrame.size.width, titleSize.height);
    CGRect messageFrame =
    CGRectMake(kLeadingPadding + labelFrame.origin.x, CGRectGetMaxY(titleFrame) + kMiddlePadding,
               labelFrame.size.width, messageSize.height);

    self.titleLabel.frame = titleFrame;
    self.messageLabel.frame = messageFrame;

    if (self.customView) {
        CGRect customViewRect = self.customView.frame;
        customViewRect = CGRectMake((CGRectGetWidth(self.frame) - CGRectGetWidth(customViewRect))/2, CGRectGetMaxY(messageFrame) + kMiddlePadding, CGRectGetWidth(customViewRect), CGRectGetHeight(customViewRect));
        self.customView.frame = customViewRect;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    size.width = size.width - kLeadingPadding - kTrailingPadding;
    CGSize titleSize = [self.titleLabel sizeThatFits:size];
    CGSize messageSize = [self.messageLabel sizeThatFits:size];
    CGFloat contentHeight;
    BOOL messageExist = (self.message) && (![self.message isEqualToString:@""]);
    BOOL titleExist = (self.title) && (![self.title isEqualToString:@""]);
    if (titleExist && messageExist) {
        contentHeight =
        titleSize.height + messageSize.height + (kTopStandardPadding * 2) + kMiddlePadding;
    } else if (messageExist) {
        contentHeight = messageSize.height + (kMessageOnlyPadding * 2);
    } else if (titleExist) {
        contentHeight = titleSize.height + (kTitleOnlyPadding * 2);
    } else {
        contentHeight = 0;
    }
    CGSize contentSize;
    contentSize.width = GTUICeil(size.width);
    contentSize.height = GTUICeil(contentHeight);
    return contentSize;
}

- (CGRect)frameWithSafeAreaInsets:(CGRect)frame {
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = self.safeAreaInsets;
        safeAreaInsets.top = 0.f;
    }
    return UIEdgeInsetsInsetRect(frame, safeAreaInsets);
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    [self setNeedsLayout];
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setMessage:(NSString *)message {
    self.messageLabel.text = message;
    [self updateLabelColors];
    [self setNeedsLayout];
}

- (NSString *)message {
    return self.messageLabel.text;
}

- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    [self setNeedsLayout];
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.titleLabel.font = titleFont;
    [self updateTitleFont];
}

- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (void)setMessageFont:(UIFont *)messageFont {
    self.messageLabel.font = messageFont;
    [self updateMessageFont];
}

- (UIFont *)messageFont {
    return self.messageLabel.font;
}

- (void)updateFonts {
    [self updateTitleFont];
    [self updateMessageFont];
}

- (void)updateTitleFont {
    UIFont *titleFont = self.titleFont ?:
    [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleSubheadline];
    if (self.gtui_adjustsFontForContentSizeCategory) {
        self.titleLabel.font =
        [titleFont gtui_fontSizedForFontTextStyle:GTUIFontTextStyleSubheadline
                                scaledForDynamicType:self.gtui_adjustsFontForContentSizeCategory];
    } else {
        self.titleLabel.font = titleFont;
    }
    [self setNeedsLayout];
}

- (void)updateMessageFont {
    UIFont *messageFont = self.messageFont ?:
    [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleBody1];
    if (self.gtui_adjustsFontForContentSizeCategory) {
        self.messageLabel.font =
        [messageFont gtui_fontSizedForFontTextStyle:GTUIFontTextStyleBody1
                                  scaledForDynamicType:self.gtui_adjustsFontForContentSizeCategory];
    } else {
        self.messageLabel.font = messageFont;
    }

    [self setNeedsLayout];
}

- (void)gtui_setAdjustsFontForContentSizeCategory:(BOOL)adjusts {
    _gtui_adjustsFontForContentSizeCategory = adjusts;
    if (_gtui_adjustsFontForContentSizeCategory) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateFonts)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIContentSizeCategoryDidChangeNotification
                                                      object:nil];
    }
    [self updateFonts];
}

- (UIColor *)defaultTitleTextColor {
    // If message is empty or nil then the title label's alpha value should be lighter, if there is
    // both then the title label's alpha should be darker.
    if (self.message && ![self.message isEqualToString:@""]) {
        return [UIColor.blackColor colorWithAlphaComponent:kTitleLabelAlpha];
    } else {
        return [UIColor.blackColor colorWithAlphaComponent:kMessageLabelAlpha];
    }
}

- (void)updateLabelColors {
    self.titleLabel.textColor = self.titleTextColor ?: [self defaultTitleTextColor];
    self.messageLabel.textColor =
    self.messageTextColor ?: [UIColor.blackColor colorWithAlphaComponent:kMessageLabelAlpha];
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleTextColor = titleTextColor;
    [self updateLabelColors];
}

- (void)setMessageTextColor:(UIColor *)messageTextColor {
    _messageTextColor = messageTextColor;
    [self updateLabelColors];
}

- (NSTextAlignment)titleAlignment {
    return _titleLabel.textAlignment;
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    _titleLabel.textAlignment = titleAlignment;
}

- (NSTextAlignment)messageAlignment {
    return _messageLabel.textAlignment;
}

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment {
    _messageLabel.textAlignment = messageAlignment;
}

@end
