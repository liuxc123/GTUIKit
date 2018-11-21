//
//  GTUITextInputControllerFilled.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputControllerFilled.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTUIMultilineTextField.h"
#import "GTUITextInput.h"
#import "GTUITextInputBorderView.h"
#import "GTUITextInputController.h"
#import "GTUITextInputControllerBase.h"
#import "GTUITextInputControllerFloatingPlaceholder.h"
#import "private/GTUITextInputArt.h"
#import "private/GTUITextInputControllerBase+Subclassing.h"

#import "GTMath.h"

/**
 Note: Right now this is a subclass of GTUITextInputControllerBase since they share a vast
 majority of code. If the designs diverge further, this would make a good candidate for its own
 class.
 */

#pragma mark - Constants

static const CGFloat GTUITextInputControllerFilledClearButtonPaddingAddition = -2.f;
static const CGFloat GTUITextInputControllerFilledDefaultUnderlineActiveHeight = 2;
static const CGFloat GTUITextInputControllerFilledDefaultUnderlineNormalHeight = 1;
static const CGFloat GTUITextInputControllerFilledFullPadding = 16.f;

// The guidelines have 8 points of padding but since the fonts on iOS are slightly smaller, we need
// to add points to keep the versions at the same height.
static const CGFloat GTUITextInputControllerFilledHalfPadding = 8.f;
static const CGFloat GTUITextInputControllerFilledHalfPaddingAddition = 1.f;
static const CGFloat GTUITextInputControllerFilledNormalPlaceholderPadding = 20.f;
static const CGFloat GTUITextInputControllerFilledThreeQuartersPadding = 12.f;

static inline UIColor *GTUITextInputControllerFilledDefaultBorderFillColorDefault() {
    return [UIColor colorWithWhite:0 alpha:.06f];
}

#pragma mark - Class Properties

static UIColor *_borderFillColorDefault;

static UIRectCorner _roundedCornersDefault = UIRectCornerAllCorners;

static CGFloat _underlineHeightActiveDefault =
GTUITextInputControllerFilledDefaultUnderlineActiveHeight;
static CGFloat _underlineHeightNormalDefault =
GTUITextInputControllerFilledDefaultUnderlineNormalHeight;

@interface GTUITextInputControllerFilled ()

@property(nonatomic, strong) NSLayoutConstraint *clearButtonBottom;
@property(nonatomic, strong) NSLayoutConstraint *placeholderTop;
@property(nonatomic, strong) NSLayoutConstraint *underlineBottom;

@end

@implementation GTUITextInputControllerFilled

#pragma mark - Properties Implementations

+ (UIColor *)borderFillColorDefault {
    if (!_borderFillColorDefault) {
        _borderFillColorDefault = GTUITextInputControllerFilledDefaultBorderFillColorDefault();
    }
    return _borderFillColorDefault;
}

+ (UIRectCorner)roundedCornersDefault {
    return _roundedCornersDefault;
}

+ (void)setRoundedCornersDefault:(UIRectCorner)roundedCornersDefault {
    _roundedCornersDefault = roundedCornersDefault;
}

+ (CGFloat)underlineHeightActiveDefault {
    return _underlineHeightActiveDefault;
}

+ (void)setUnderlineHeightActiveDefault:(CGFloat)underlineHeightActiveDefault {
    _underlineHeightActiveDefault = underlineHeightActiveDefault;
}

+ (CGFloat)underlineHeightNormalDefault {
    return _underlineHeightNormalDefault;
}

+ (void)setUnderlineHeightNormalDefault:(CGFloat)underlineHeightNormalDefault {
    _underlineHeightNormalDefault = underlineHeightNormalDefault;
}

#pragma mark - GTUITextInputPositioningDelegate

- (CGRect)leadingViewRectForBounds:(CGRect)bounds defaultRect:(CGRect)defaultRect {
    CGRect leadingViewRect = defaultRect;
    CGFloat xOffset = (self.textInput.gtf_effectiveUserInterfaceLayoutDirection ==
                       UIUserInterfaceLayoutDirectionRightToLeft)
    ? -1 * GTUITextInputControllerFilledFullPadding
    : GTUITextInputControllerFilledFullPadding;

    leadingViewRect = CGRectOffset(leadingViewRect, xOffset, 0.f);

    leadingViewRect.origin.y = CGRectGetHeight(self.textInput.borderPath.bounds) / 2.f -
    CGRectGetHeight(leadingViewRect) / 2.f;

    return leadingViewRect;
}

- (CGFloat)leadingViewTrailingPaddingConstant {
    return GTUITextInputControllerFilledFullPadding;
}

- (CGRect)trailingViewRectForBounds:(CGRect)bounds defaultRect:(CGRect)defaultRect {
    CGRect trailingViewRect = defaultRect;
    CGFloat xOffset = (self.textInput.gtf_effectiveUserInterfaceLayoutDirection ==
                       UIUserInterfaceLayoutDirectionRightToLeft)
    ? GTUITextInputControllerFilledThreeQuartersPadding
    : -1 * GTUITextInputControllerFilledThreeQuartersPadding;

    trailingViewRect = CGRectOffset(trailingViewRect, xOffset, 0.f);

    trailingViewRect.origin.y = CGRectGetHeight(self.textInput.borderPath.bounds) / 2.f -
    CGRectGetHeight(trailingViewRect) / 2.f;

    return trailingViewRect;
}

- (CGFloat)trailingViewTrailingPaddingConstant {
    return GTUITextInputControllerFilledThreeQuartersPadding;
}

// clang-format off
/**
 textInsets: is the source of truth for vertical layout. It's used to figure out the proper
 height and also where to place the placeholder / text field.

 NOTE: It's applied before the textRect is flipped for RTL. So all calculations are done here à la
 LTR.

 The vertical layout is, at most complex (floating), this form:
 GTUITextInputControllerFilledHalfPadding +                            // Small padding
 GTUITextInputControllerFilledHalfPaddingAddition                      // Additional point (iOS specific)
 GTUIRint(self.textInput.placeholderLabel.font.lineHeight * scale)     // Placeholder when up
 GTUITextInputControllerFilledHalfPadding +                            // Small padding
 GTUITextInputControllerFilledHalfPaddingAddition                      // Additional point (iOS specific)
 GTUICeil(MAX(self.textInput.font.lineHeight,                        // Text field or placeholder line height
 self.textInput.placeholderLabel.font.lineHeight))
 GTUITextInputControllerFilledHalfPadding +                            // Small padding
 GTUITextInputControllerFilledHalfPaddingAddition                      // Additional point (iOS specific)
 --Underline--                                                        // Underline (height not counted)
 underlineLabelsOffset                                                // Depends on text insets mode. See the super class.
 */
// clang-format on
- (UIEdgeInsets)textInsets:(UIEdgeInsets)defaultInsets {
    UIEdgeInsets textInsets = [super textInsets:defaultInsets];
    if (self.isFloatingEnabled) {
        textInsets.top =
        GTUITextInputControllerFilledHalfPadding + GTUITextInputControllerFilledHalfPaddingAddition +
        GTUIRint(self.textInput.placeholderLabel.font.lineHeight *
                (CGFloat)self.floatingPlaceholderScale.floatValue) +
        GTUITextInputControllerFilledHalfPadding + GTUITextInputControllerFilledHalfPaddingAddition;
    } else {
        textInsets.top = GTUITextInputControllerFilledNormalPlaceholderPadding;
    }

    textInsets.bottom = [self beneathInputPadding] + [self underlineOffset];

    textInsets.left = GTUITextInputControllerFilledFullPadding;
    textInsets.right = GTUITextInputControllerFilledHalfPadding;

    return textInsets;
}

- (void)updateLayout {
    [super updateLayout];

    if (!self.textInput) {
        return;
    }

    CGFloat clearButtonConstant =
    -1 * ([self beneathInputPadding] - GTUITextInputClearButtonImageBuiltInPadding +
          GTUITextInputControllerFilledClearButtonPaddingAddition);
    if (!self.clearButtonBottom) {
        self.clearButtonBottom = [NSLayoutConstraint constraintWithItem:self.textInput.clearButton
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.textInput.underline
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:clearButtonConstant];
        self.clearButtonBottom.active = YES;
    }
    self.clearButtonBottom.constant = clearButtonConstant;
}

#pragma mark - Layout

- (void)updatePlaceholder {
    [super updatePlaceholder];

    if (!self.placeholderTop) {
        self.placeholderTop = [NSLayoutConstraint
                               constraintWithItem:self.textInput.placeholderLabel
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.textInput
                               attribute:NSLayoutAttributeTop
                               multiplier:1
                               constant:GTUITextInputControllerFilledNormalPlaceholderPadding];
        self.placeholderTop.priority = UILayoutPriorityDefaultHigh;
        self.placeholderTop.active = YES;
    }

    UIEdgeInsets textInsets = [self textInsets:UIEdgeInsetsZero];
    CGFloat underlineBottomConstant =
    textInsets.top + [self estimatedTextHeight] + [self beneathInputPadding];
    // When floating placeholders are turned off, the underline will drift up unless this is set. Even
    // tho it is redundant when floating is on, we just keep it on always for simplicity.
    // Note: This is an issue only on single-line text fields.
    if (!self.underlineBottom) {
        if ([self.textInput isKindOfClass:[GTUIMultilineTextField class]]) {
            self.underlineBottom =
            [NSLayoutConstraint constraintWithItem:self.textInput.underline
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:((GTUIMultilineTextField *)self.textInput).textView
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1
                                          constant:[self beneathInputPadding]];
            self.underlineBottom.active = YES;

        } else {
            self.underlineBottom = [NSLayoutConstraint constraintWithItem:self.textInput.underline
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.textInput
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:underlineBottomConstant];
            self.underlineBottom.active = YES;
        }
    }
    if ([self.textInput isKindOfClass:[GTUIMultilineTextField class]]) {
        self.underlineBottom.constant = [self beneathInputPadding];
    } else {
        self.underlineBottom.constant = underlineBottomConstant;
    }
}

// The measurement from bottom to underline bottom. Only used in non-floating case.
- (CGFloat)underlineOffset {
    // The amount of space underneath the underline may depend on whether there is content in the
    // underline labels.

    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat leadingOffset =
    GTUICeil(self.textInput.leadingUnderlineLabel.font.lineHeight * scale) / scale;
    CGFloat trailingOffset =
    GTUICeil(self.textInput.trailingUnderlineLabel.font.lineHeight * scale) / scale;

    CGFloat underlineOffset = 0;
    switch (self.textInput.textInsetsMode) {
        case GTUITextInputTextInsetsModeAlways:
            underlineOffset +=
            MAX(leadingOffset, trailingOffset) + GTUITextInputControllerFilledHalfPadding;
            break;
        case GTUITextInputTextInsetsModeIfContent: {
            // contentConditionalOffset will have the estimated text height for the largest underline
            // label that also has text.
            CGFloat contentConditionalOffset = 0;
            if (self.textInput.leadingUnderlineLabel.text.length) {
                contentConditionalOffset = leadingOffset;
            }
            if (self.textInput.trailingUnderlineLabel.text.length) {
                contentConditionalOffset = MAX(contentConditionalOffset, trailingOffset);
            }

            if (!GTUICGFloatEqual(contentConditionalOffset, 0)) {
                underlineOffset += contentConditionalOffset + GTUITextInputControllerFilledHalfPadding;
            }
        } break;
        case GTUITextInputTextInsetsModeNever:
            break;
    }
    return underlineOffset;
}

- (CGFloat)estimatedTextHeight {
    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat estimatedTextHeight = GTUICeil(self.textInput.font.lineHeight * scale) / scale;

    return estimatedTextHeight;
}

- (UIOffset)floatingPlaceholderOffset {
    UIOffset offset = [super floatingPlaceholderOffset];

    if ([self.textInput conformsToProtocol:@protocol(GTUILeadingViewTextInput)]) {
        UIView<GTUILeadingViewTextInput> *input = (UIView<GTUILeadingViewTextInput> *)self.textInput;
        if (input.leadingView.superview) {
            offset.horizontal -=
            CGRectGetWidth(input.leadingView.frame) + [self leadingViewTrailingPaddingConstant];
        }
    }
    return offset;
}

// The space ABOVE the underline but under the text input area.
- (CGFloat)beneathInputPadding {
    if (self.isFloatingEnabled) {
        return GTUITextInputControllerFilledHalfPadding +
        GTUITextInputControllerFilledHalfPaddingAddition;
    } else {
        return GTUITextInputControllerFilledNormalPlaceholderPadding;
    }
}

@end
