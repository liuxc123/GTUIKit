//
//  GTFTextAccessibility.m
//  GTFTextAccessibility
//
//  Created by liuxc on 2018/8/20.
//

#import "GTFTextAccessibility.h"

#import "private/GTFColorCalculations.h"
#import "private/GTFImageCalculations.h"
#import "private/NSArray+GTFUtils.h"

static const CGFloat kMinContrastRatioNormalText = 4.5f;
static const CGFloat kMinContrastRatioLargeText = 3.0f;
static const CGFloat kMinContrastRatioNormalTextEnhanced = 7.0f;
static const CGFloat kMinContrastRatioLargeTextEnhanced = 4.5f;

@implementation GTFTextAccessibility

+ (nonnull UIColor *)textColorOnBackgroundColor:(nonnull UIColor *)backgroundColor
                                targetTextAlpha:(CGFloat)targetTextAlpha
                                           font:(nullable UIFont *)font {
    GTFTextAccessibilityOptions options = 0;
    if ([self isLargeForContrastRatios:font]) {
        options |= GTFTextAccessibilityOptionsLargeFont;
    }
    return [self textColorOnBackgroundColor:backgroundColor
                            targetTextAlpha:targetTextAlpha
                                    options:options];
}

+ (nullable UIColor *)textColorOnBackgroundImage:(nonnull UIImage *)backgroundImage
                                        inRegion:(CGRect)region
                                 targetTextAlpha:(CGFloat)targetTextAlpha
                                            font:(nullable UIFont *)font {
    UIColor *backgroundColor = GTFAverageColorOfOpaqueImage(backgroundImage, region);
    if (!backgroundColor) {
        return nil;
    }

    return
    [self textColorOnBackgroundColor:backgroundColor targetTextAlpha:targetTextAlpha font:font];
}

+ (nullable UIColor *)textColorOnBackgroundColor:(nonnull UIColor *)backgroundColor
                                 targetTextAlpha:(CGFloat)targetTextAlpha
                                         options:(GTFTextAccessibilityOptions)options {
    NSArray *colors = @[
                        [UIColor colorWithWhite:1 alpha:targetTextAlpha],
                        [UIColor colorWithWhite:0 alpha:targetTextAlpha]
                        ];
    UIColor *textColor =
    [self textColorFromChoices:colors onBackgroundColor:backgroundColor options:options];
    return textColor;
}

+ (nullable UIColor *)textColorFromChoices:(nonnull NSArray<UIColor *> *)choices
                         onBackgroundColor:(nonnull UIColor *)backgroundColor
                                   options:(GTFTextAccessibilityOptions)options {
    [choices enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSAssert([obj isKindOfClass:[UIColor class]], @"Choices must be UIColors.");
    }];

    // Sort by luminance if requested.
    if ((options & GTFTextAccessibilityOptionsPreferLighter) ||
        (options & GTFTextAccessibilityOptionsPreferDarker)) {
        NSArray *luminances = [choices gtf_arrayByMappingObjects:^id(id object) {
            return @([self luminanceOfColor:object]);
        }];

        BOOL inverse = (options & GTFTextAccessibilityOptionsPreferDarker) ? YES : NO;
        choices = [luminances gtf_sortArray:choices
                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                float first = inverse ? [obj1 floatValue] : [obj2 floatValue];
                                float second = inverse ? [obj2 floatValue] : [obj1 floatValue];

                                if (first < second) {
                                    return NSOrderedAscending;
                                } else if (first > second) {
                                    return NSOrderedDescending;
                                } else {
                                    return NSOrderedSame;
                                }
                            }];
    }

    // Search the array for a color that can be used, adjusting alpha values upwards if requested.
    // The first acceptable color (adjusted or not) is returned.
    BOOL adjustAlphas = (options & GTFTextAccessibilityOptionsPreserveAlpha) ? NO : YES;
    for (UIColor *choice in choices) {
        if ([self textColor:choice passesOnBackgroundColor:backgroundColor options:options]) {
            return choice;
        }

        if (!adjustAlphas) {
            continue;
        }

        CGFloat alpha = CGColorGetAlpha(choice.CGColor);
        CGFloat minAlpha =
        [self minAlphaOfTextColor:choice onBackgroundColor:backgroundColor options:options];
        if (minAlpha > 0) {
            if (alpha > minAlpha) {
                NSAssert(NO,
                         @"Logic error: computed an acceptable minimum alpha (%f) that is *less* than the "
                         @"unacceptable current alpha (%f).",
                         minAlpha, alpha);
                continue;
            }
            return [choice colorWithAlphaComponent:minAlpha];
        }
    }

    return nil;
}

+ (CGFloat)minAlphaOfTextColor:(nonnull UIColor *)textColor
             onBackgroundColor:(nonnull UIColor *)backgroundColor
                       options:(GTFTextAccessibilityOptions)options {
    CGFloat minContrastRatio = [self minContrastRatioForOptions:options];
    return GTFMinAlphaOfColorOnBackgroundColor(textColor, backgroundColor, minContrastRatio);
}

+ (CGFloat)contrastRatioForTextColor:(UIColor *)textColor
                   onBackgroundColor:(UIColor *)backgroundColor {
    CGFloat colorComponents[4];
    CGFloat backgroundColorComponents[4];
    GTFCopyRGBAComponents(textColor.CGColor, colorComponents);
    GTFCopyRGBAComponents(backgroundColor.CGColor, backgroundColorComponents);

    NSAssert(backgroundColorComponents[3] == 1,
             @"Background color %@ must be opaque for a valid contrast ratio calculation.",
             backgroundColor);
    backgroundColorComponents[3] = 1;

    return GTFContrastRatioOfRGBAComponents(colorComponents, backgroundColorComponents);
}

+ (BOOL)textColor:(nonnull UIColor *)textColor
passesOnBackgroundColor:(nonnull UIColor *)backgroundColor
          options:(GTFTextAccessibilityOptions)options {
    CGFloat minContrastRatio = [self minContrastRatioForOptions:options];
    CGFloat ratio = [self contrastRatioForTextColor:textColor onBackgroundColor:backgroundColor];
    return ratio >= minContrastRatio ? YES : NO;
}

+ (BOOL)isLargeForContrastRatios:(nullable UIFont *)font {
    UIFontDescriptor *fontDescriptor = font.fontDescriptor;
    BOOL isBold =
    (fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) == UIFontDescriptorTraitBold;
    return font.pointSize >= 18 || (isBold && font.pointSize >= 14);
}

#pragma mark - Private methods

+ (CGFloat)luminanceOfColor:(UIColor *)color {
    CGFloat colorComponents[4];
    GTFCopyRGBAComponents(color.CGColor, colorComponents);
    return GTFRelativeLuminanceOfRGBComponents(colorComponents);
}

+ (CGFloat)minContrastRatioForOptions:(GTFTextAccessibilityOptions)options {
    BOOL isLarge =
    (options & GTFTextAccessibilityOptionsLargeFont) == GTFTextAccessibilityOptionsLargeFont;
    BOOL isEnhanced = (options & GTFTextAccessibilityOptionsEnhancedContrast) ==
    GTFTextAccessibilityOptionsEnhancedContrast;

    if (isEnhanced) {
        return isLarge ? kMinContrastRatioLargeTextEnhanced : kMinContrastRatioNormalTextEnhanced;
    } else {
        return isLarge ? kMinContrastRatioLargeText : kMinContrastRatioNormalText;
    }
}

@end
