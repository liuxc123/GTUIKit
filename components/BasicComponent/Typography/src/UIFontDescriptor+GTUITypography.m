//
//  UIFontDescriptor+GTUITypography.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import "UIFontDescriptor+GTUITypography.h"

#import "GTApplication.h"

#import "private/GTUIFontTraits.h"

@implementation UIFontDescriptor (GTUITypography)

+ (nonnull UIFontDescriptor *)gtui_fontDescriptorForTextStyle:(GTUIFontTextStyle)style
                                                        sizeCategory:(NSString *)sizeCategory {
    // TODO(#1179): We should include our leading and tracking metrics when creating this descriptor.
    GTUIFontTraits *materialTraits =
    [GTUIFontTraits traitsForTextStyle:style sizeCategory:sizeCategory];

    // Store the system font family name to ensure that we load the system font.
    // If we do not explicitly include this UIFontDescriptorFamilyAttribute in the
    // FontDescriptor the OS will default to Helvetica. On iOS 9+, the Font Family
    // changes from San Francisco to San Francisco Display at point size 20.
    static NSString *smallSystemFontFamilyName;
    static NSString *largeSystemFontFamilyName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIFont *smallSystemFont;
        UIFont *largeSystemFont;
        if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
            smallSystemFont = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
            largeSystemFont = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
#pragma clang diagnostic pop
        } else {
            // TODO: Remove this fallback once we are 8.2+
            smallSystemFont = [UIFont systemFontOfSize:12];
            largeSystemFont = [UIFont systemFontOfSize:20];
        }
        smallSystemFontFamilyName = [smallSystemFont.familyName copy];
        largeSystemFontFamilyName = [largeSystemFont.familyName copy];
    });

    NSDictionary *traits = @{ UIFontWeightTrait : @(materialTraits.weight) };
    NSString *fontFamily =
    materialTraits.pointSize < 19.5 ? smallSystemFontFamilyName : largeSystemFontFamilyName;
    NSDictionary *attributes = @{
                                 UIFontDescriptorSizeAttribute : @(materialTraits.pointSize),
                                 UIFontDescriptorTraitsAttribute : traits,
                                 UIFontDescriptorFamilyAttribute : fontFamily
                                 };

    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes:attributes];

    return fontDescriptor;
}

+ (nonnull UIFontDescriptor *)gtui_preferredFontDescriptorForTextStyle:
(GTUIFontTextStyle)style {
    // iOS' default UIContentSizeCategory is Large.
    NSString *sizeCategory = UIContentSizeCategoryLarge;

    // If we are within an application, query the preferredContentSizeCategory.
    if ([UIApplication gtui_safeSharedApplication]) {
        sizeCategory = [UIApplication gtui_safeSharedApplication].preferredContentSizeCategory;
    } else if (@available(iOS 10.0, *)) {
        sizeCategory = UIScreen.mainScreen.traitCollection.preferredContentSizeCategory;
    }

    return [UIFontDescriptor gtui_fontDescriptorForTextStyle:style sizeCategory:sizeCategory];
}

+ (nonnull UIFontDescriptor *)gtui_standardFontDescriptorForTextStyle:
(GTUIFontTextStyle)style {
    // iOS' default UIContentSizeCategory is Large.
    // Since we don't want to scale with Dynamic Type create the font descriptor based on that.
    NSString *sizeCategory = UIContentSizeCategoryLarge;

    return [UIFontDescriptor gtui_fontDescriptorForTextStyle:style sizeCategory:sizeCategory];
}
@end
