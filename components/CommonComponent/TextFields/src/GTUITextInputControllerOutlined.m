//
//  GTUITextInputControllerOutlined.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputControllerOutlined.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTUITextInput.h"
#import "GTUITextInputBorderView.h"
#import "GTUITextInputController.h"
#import "GTUITextInputControllerBase.h"
#import "GTUITextInputControllerFloatingPlaceholder.h"
#import "GTUITextInputUnderlineView.h"
#import "private/GTUITextInputControllerBase+Subclassing.h"

#import "GTMath.h"

#pragma mark - Class Properties

static const CGFloat GTUITextInputOutlinedTextFieldFloatingPlaceholderPadding = 8.f;
static const CGFloat GTUITextInputOutlinedTextFieldFullPadding = 16.f;
static const CGFloat GTUITextInputOutlinedTextFieldNormalPlaceholderPadding = 20.f;
static const CGFloat GTUITextInputOutlinedTextFieldThreeQuartersPadding = 12.f;

static BOOL _floatingEnabledDefault = YES;
static UIRectCorner _roundedCornersDefault = UIRectCornerAllCorners;

@interface GTUITextInputControllerOutlined ()

@property(nonatomic, strong) NSLayoutConstraint *placeholderCenterY;
@property(nonatomic, strong) NSLayoutConstraint *placeholderLeading;

@end

@implementation GTUITextInputControllerOutlined

- (instancetype)initWithTextInput:(UIView<GTUITextInput> *)input {
    NSAssert(![input conformsToProtocol:@protocol(GTUIMultilineTextInput)],
             @"This design is meant for single-line text fields only. For a complementary multi-line "
             @"style, see GTUITextInputControllerOutlinedTextArea.");
    self = [super initWithTextInput:input];
    if (self) {
        input.textInsetsMode = GTUITextInputTextInsetsModeAlways;
    }
    return self;
}

#pragma mark - Properties Implementations

- (BOOL)isFloatingEnabled {
    return _floatingEnabledDefault;
}

- (void)setFloatingEnabled:(__unused BOOL)floatingEnabled {
    // Unused. Floating is always enabled.
    _floatingEnabledDefault = floatingEnabled;
}

- (UIOffset)floatingPlaceholderOffset {
    UIOffset offset = [super floatingPlaceholderOffset];
    CGFloat textVerticalOffset = 0;
    offset.vertical = textVerticalOffset;
    return offset;
}

+ (UIRectCorner)roundedCornersDefault {
    return _roundedCornersDefault;
}

+ (void)setRoundedCornersDefault:(UIRectCorner)roundedCornersDefault {
    _roundedCornersDefault = roundedCornersDefault;
}

#pragma mark - GTUITextInputPositioningDelegate

- (CGRect)leadingViewRectForBounds:(CGRect)bounds defaultRect:(CGRect)defaultRect {
    CGRect leadingViewRect = defaultRect;
    CGFloat xOffset = (self.textInput.gtf_effectiveUserInterfaceLayoutDirection ==
                       UIUserInterfaceLayoutDirectionRightToLeft)
    ? -1 * GTUITextInputOutlinedTextFieldFullPadding
    : GTUITextInputOutlinedTextFieldFullPadding;

    leadingViewRect = CGRectOffset(leadingViewRect, xOffset, 0.f);

    CGRect borderRect = [self borderRect];
    leadingViewRect.origin.y = CGRectGetMinY(borderRect) + CGRectGetHeight(borderRect) / 2.f -
    CGRectGetHeight(leadingViewRect) / 2.f;

    return leadingViewRect;
}

- (CGFloat)leadingViewTrailingPaddingConstant {
    return GTUITextInputOutlinedTextFieldFullPadding;
}

- (CGRect)trailingViewRectForBounds:(CGRect)bounds defaultRect:(CGRect)defaultRect {
    CGRect trailingViewRect = defaultRect;
    CGFloat xOffset = (self.textInput.gtf_effectiveUserInterfaceLayoutDirection ==
                       UIUserInterfaceLayoutDirectionRightToLeft)
    ? GTUITextInputOutlinedTextFieldThreeQuartersPadding
    : -1 * GTUITextInputOutlinedTextFieldThreeQuartersPadding;

    trailingViewRect = CGRectOffset(trailingViewRect, xOffset, 0.f);

    CGRect borderRect = [self borderRect];
    trailingViewRect.origin.y = CGRectGetMinY(borderRect) + CGRectGetHeight(borderRect) / 2.f -
    CGRectGetHeight(trailingViewRect) / 2.f;

    return trailingViewRect;
}

- (CGFloat)trailingViewTrailingPaddingConstant {
    return GTUITextInputOutlinedTextFieldThreeQuartersPadding;
}

// clang-format off
/**
 textInsets: is the source of truth for vertical layout. It's used to figure out the proper
 height and also where to place the placeholder / text field.

 NOTE: It's applied before the textRect is flipped for RTL. So all calculations are done here à la
 LTR.

 This one is a little different because the placeholder crosses the top bordered area when floating.

 The vertical layout is, at most complex, this form:

 placeholderEstimatedHeight                                           // Height of placeholder
 GTUITextInputOutlinedTextFieldFullPadding                             // Padding
 GTUICeil(MAX(self.textInput.font.lineHeight,                          // Text field or placeholder
 self.textInput.placeholderLabel.font.lineHeight))
 GTUITextInputControllerBaseDefaultPadding                             // Padding to bottom of border rect
 underlineLabelsOffset                                                // From super class.
 */
// clang-format on
- (UIEdgeInsets)textInsets:(UIEdgeInsets)defaultInsets {
    UIEdgeInsets textInsets = [super textInsets:defaultInsets];
    CGFloat textVerticalOffset = self.textInput.placeholderLabel.font.lineHeight * .5f;

    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat placeholderEstimatedHeight =
    GTUICeil(self.textInput.placeholderLabel.font.lineHeight * scale) / scale;
    textInsets.top = [self borderHeight] - GTUITextInputOutlinedTextFieldFullPadding -
    placeholderEstimatedHeight + textVerticalOffset;

    textInsets.left = GTUITextInputOutlinedTextFieldFullPadding;
    textInsets.right = GTUITextInputOutlinedTextFieldFullPadding;

    return textInsets;
}

#pragma mark - GTUITextInputControllerBase overrides

- (void)updateLayout {
    [super updateLayout];

    self.textInput.clipsToBounds = NO;
}

-(void)updateUnderline {
    self.textInput.underline.hidden = YES;
}

- (void)updateBorder {
    [super updateBorder];

    UIBezierPath *path;
    if ([self isPlaceholderUp]) {
        CGFloat placeholderWidth =
        [self.textInput.placeholderLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]
        .width * (CGFloat)self.floatingPlaceholderScale.floatValue;

        placeholderWidth += GTUITextInputOutlinedTextFieldFloatingPlaceholderPadding;

        path =
        [self roundedPathFromRect:[self borderRect]
                    withTextSpace:placeholderWidth
                    leadingOffset:GTUITextInputOutlinedTextFieldFullPadding -
         GTUITextInputOutlinedTextFieldFloatingPlaceholderPadding / 2.0f];
    } else {
        CGSize cornerRadius = CGSizeMake(GTUITextInputControllerBaseDefaultBorderRadius,
                                         GTUITextInputControllerBaseDefaultBorderRadius);
        path = [UIBezierPath bezierPathWithRoundedRect:[self borderRect]
                                     byRoundingCorners:self.roundedCorners
                                           cornerRadii:cornerRadius];
    }
    self.textInput.borderPath = path;

    UIColor *borderColor = self.textInput.isEditing ? self.activeColor : self.normalColor;
    if (!self.textInput.isEnabled) {
        borderColor = self.disabledColor;
    }
    self.textInput.borderView.borderStrokeColor =
    (self.isDisplayingCharacterCountError || self.isDisplayingErrorText) ? self.errorColor
    : borderColor;
    self.textInput.borderView.borderPath.lineWidth = self.textInput.isEditing ? 2 : 1;

    [self.textInput.borderView setNeedsLayout];

    [self updatePlaceholder];
}

- (CGRect)borderRect {
    CGRect pathRect = self.textInput.bounds;
    pathRect.origin.y = pathRect.origin.y + self.textInput.placeholderLabel.font.lineHeight * .5f;
    pathRect.size.height = [self borderHeight];
    return pathRect;
}

- (UIBezierPath *)roundedPathFromRect:(CGRect)f
                        withTextSpace:(CGFloat)textSpace
                        leadingOffset:(CGFloat)offset {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat radius = GTUITextInputControllerBaseDefaultBorderRadius;
    CGFloat yOffset = f.origin.y;
    CGFloat xOffset = f.origin.x;

    // Draw the path
    [path moveToPoint:CGPointMake(radius + xOffset, yOffset)];
    if (self.textInput.gtf_effectiveUserInterfaceLayoutDirection ==
        UIUserInterfaceLayoutDirectionLeftToRight) {
        [path addLineToPoint:CGPointMake(offset + xOffset, yOffset)];
        [path moveToPoint:CGPointMake(textSpace + offset + xOffset, yOffset)];
        [path addLineToPoint:CGPointMake(f.size.width - radius + xOffset, yOffset)];
    } else {
        [path addLineToPoint:CGPointMake(xOffset + (f.size.width - (offset + textSpace)), yOffset)];
        [path moveToPoint:CGPointMake(xOffset + (f.size.width - offset), yOffset)];
        [path addLineToPoint:CGPointMake(xOffset + (f.size.width - radius), yOffset)];
    }

    [path addArcWithCenter:CGPointMake(f.size.width - radius + xOffset, radius + yOffset)
                    radius:radius
                startAngle:- (CGFloat)(M_PI / 2)
                  endAngle:0
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(f.size.width + xOffset, f.size.height - radius + yOffset)];
    [path addArcWithCenter:CGPointMake(f.size.width - radius + xOffset, f.size.height - radius + yOffset)
                    radius:radius
                startAngle:0
                  endAngle:- (CGFloat)((M_PI * 3) / 2)
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(radius + xOffset, f.size.height + yOffset)];
    [path addArcWithCenter:CGPointMake(radius + xOffset, f.size.height - radius + yOffset)
                    radius:radius
                startAngle:- (CGFloat)((M_PI * 3) / 2)
                  endAngle:- (CGFloat)M_PI
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(xOffset, radius + yOffset)];
    [path addArcWithCenter:CGPointMake(radius + xOffset, radius + yOffset)
                    radius:radius
                startAngle:- (CGFloat)M_PI
                  endAngle:- (CGFloat)(M_PI / 2)
                 clockwise:YES];

    return path;
}

- (void)updatePlaceholder {
    [super updatePlaceholder];

    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat placeholderEstimatedHeight =
    GTUICeil(self.textInput.placeholderLabel.font.lineHeight * scale) / scale;
    CGFloat placeholderConstant =
    ([self borderHeight] / 2.f) - (placeholderEstimatedHeight / 2.f)
    + self.textInput.placeholderLabel.font.lineHeight * .5f;
    if (!self.placeholderCenterY) {
        self.placeholderCenterY = [NSLayoutConstraint constraintWithItem:self.textInput.placeholderLabel
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.textInput
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:placeholderConstant];
        self.placeholderCenterY.priority = UILayoutPriorityDefaultHigh;
        self.placeholderCenterY.active = YES;

        [self.textInput.placeholderLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh + 1
                                                           forAxis:UILayoutConstraintAxisVertical];
    }
    self.placeholderCenterY.constant = placeholderConstant;

    CGFloat placeholderLeadingConstant = GTUITextInputOutlinedTextFieldFullPadding;

    if ([self.textInput conformsToProtocol:@protocol(GTUILeadingViewTextInput)]) {
        UIView<GTUILeadingViewTextInput> *leadingViewInput =
        (UIView<GTUILeadingViewTextInput> *)self.textInput;
        if (leadingViewInput.leadingView.superview) {
            placeholderLeadingConstant += CGRectGetWidth(leadingViewInput.leadingView.frame) +
            [self leadingViewTrailingPaddingConstant];
        }
    }

    if (!self.placeholderLeading) {
        self.placeholderLeading = [NSLayoutConstraint constraintWithItem:self.textInput.placeholderLabel
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.textInput
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1
                                                                constant:placeholderLeadingConstant];
        self.placeholderLeading.priority = UILayoutPriorityDefaultHigh;
        self.placeholderLeading.active = YES;
    }
    self.placeholderLeading.constant = placeholderLeadingConstant;
}

- (CGFloat)borderHeight {
    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat placeholderEstimatedHeight =
    GTUICeil(self.textInput.placeholderLabel.font.lineHeight * scale) / scale;
    return GTUITextInputOutlinedTextFieldNormalPlaceholderPadding + placeholderEstimatedHeight +
    GTUITextInputOutlinedTextFieldNormalPlaceholderPadding;
}

@end

