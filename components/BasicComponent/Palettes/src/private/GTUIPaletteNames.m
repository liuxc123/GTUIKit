//
//  GTUIPaletteNames.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUIPaletteNames.h"

BOOL GTUIPaletteIsTintOrAccentName(NSString* _Nonnull name) {
    return [name isEqualToString:GTUI_PALETTE_TINT_50_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_TINT_100_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_TINT_200_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_TINT_300_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_TINT_400_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_TINT_500_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_TINT_600_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_TINT_700_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_TINT_800_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_TINT_900_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_ACCENT_100_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_ACCENT_200_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_ACCENT_400_INTERNAL_NAME] ||
    [name isEqualToString:GTUI_PALETTE_ACCENT_700_INTERNAL_NAME];
}
