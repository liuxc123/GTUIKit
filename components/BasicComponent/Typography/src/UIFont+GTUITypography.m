//
//  UIFont+GTUITypography.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import "UIFont+GTUITypography.h"

#import "GTUITypography.h"
#import "UIFontDescriptor+GTUITypography.h"

@implementation UIFont (GTUITypography)


+ (UIFont *)gtui_preferredFontForTextStyle:(GTUIFontTextStyle)style {
    // Due to the way iOS handles missing glyphs in fonts, we do not support using
    // our font loader with Dynamic Type.
    id<GTUITypographyFontLoading> fontLoader = [GTUITypography fontLoader];
    if (![fontLoader isKindOfClass:[GTUISystemFontLoader class]]) {
        NSLog(@"GTUITypography : Custom font loaders are not compatible with Dynamic Type.");
    }

    UIFontDescriptor *fontDescriptor =
    [UIFontDescriptor gtui_preferredFontDescriptorForTextStyle:style];

    // Size is included in the fontDescriptor, so we pass in 0.0 in the parameter.
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:0.0];

    return font;
}

+ (nonnull UIFont *)gtui_standardFontForTextStyle:(GTUIFontTextStyle)style {
    // Caches a font for a specific GTUIFontTextStyle value
    static NSCache<NSValue *, UIFont *> *fontCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // NOTE: We assume the Font Loader will never change, so the cached fonts are never invalidated.
        fontCache = [[NSCache alloc] init];
    });

    // Due to the way iOS handles missing glyphs in fonts, we do not support using our
    // font loader with standardFont.
    id<GTUITypographyFontLoading> fontLoader = [GTUITypography fontLoader];
    if (![fontLoader isKindOfClass:[GTUISystemFontLoader class]]) {
        NSLog(@"GTUITypography : Custom font loaders are not compatible with Dynamic Type.");
    }

    UIFont *font = [fontCache objectForKey:@(style)];
    if (!font) {
        UIFontDescriptor *fontDescriptor =
        [UIFontDescriptor gtui_standardFontDescriptorForTextStyle:style];

        // Size is included in the fontDescriptor, so we pass in 0.0 in the parameter.
        font = [UIFont fontWithDescriptor:fontDescriptor size:0.0];
        [fontCache setObject:font forKey:@(style)];
    }

    return font;
}

- (UIFont *)gtui_fontSizedForFontTextStyle:(GTUIFontTextStyle)style
                          scaledForDynamicType:(BOOL)scaled {
    UIFontDescriptor *fontDescriptor;
    if (scaled) {
        fontDescriptor = [UIFontDescriptor gtui_preferredFontDescriptorForTextStyle:style];
    } else {
        fontDescriptor = [UIFontDescriptor gtui_standardFontDescriptorForTextStyle:style];
    }

    return [self fontWithSize:fontDescriptor.pointSize];
}



@end
