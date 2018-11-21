//
//  GTUIPalettes.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUIPalettes.h"
#import "private/GTUIPaletteExpansions.h"
#import "private/GTUIPaletteNames.h"

const GTUIPaletteTint GTUIPaletteTint50Name = GTUI_PALETTE_TINT_50_INTERNAL_NAME;
const GTUIPaletteTint GTUIPaletteTint100Name = GTUI_PALETTE_TINT_100_INTERNAL_NAME;
const GTUIPaletteTint GTUIPaletteTint200Name = GTUI_PALETTE_TINT_200_INTERNAL_NAME;
const GTUIPaletteTint GTUIPaletteTint300Name = GTUI_PALETTE_TINT_300_INTERNAL_NAME;
const GTUIPaletteTint GTUIPaletteTint400Name = GTUI_PALETTE_TINT_400_INTERNAL_NAME;
const GTUIPaletteTint GTUIPaletteTint500Name = GTUI_PALETTE_TINT_500_INTERNAL_NAME;
const GTUIPaletteTint GTUIPaletteTint600Name = GTUI_PALETTE_TINT_600_INTERNAL_NAME;
const GTUIPaletteTint GTUIPaletteTint700Name = GTUI_PALETTE_TINT_700_INTERNAL_NAME;
const GTUIPaletteTint GTUIPaletteTint800Name = GTUI_PALETTE_TINT_800_INTERNAL_NAME;
const GTUIPaletteTint GTUIPaletteTint900Name = GTUI_PALETTE_TINT_900_INTERNAL_NAME;

const GTUIPaletteAccent GTUIPaletteAccent100Name = GTUI_PALETTE_ACCENT_100_INTERNAL_NAME;
const GTUIPaletteAccent GTUIPaletteAccent200Name = GTUI_PALETTE_ACCENT_200_INTERNAL_NAME;
const GTUIPaletteAccent GTUIPaletteAccent400Name = GTUI_PALETTE_ACCENT_400_INTERNAL_NAME;
const GTUIPaletteAccent GTUIPaletteAccent700Name = GTUI_PALETTE_ACCENT_700_INTERNAL_NAME;

// Creates a UIColor from a 24-bit RGB color encoded as an integer.
static inline UIColor *ColorFromRGB(uint32_t rgbValue) {
    return [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255
                           green:((CGFloat)((rgbValue & 0x00FF00) >> 8)) / 255
                            blue:((CGFloat)((rgbValue & 0x0000FF) >> 0)) / 255
                           alpha:1];
}

@interface GTUIPalette () {
    NSDictionary<GTUIPaletteTint, UIColor *> *_tints;
    NSDictionary<GTUIPaletteAccent, UIColor *> *_accents;
}

@end

@implementation GTUIPalette

+ (GTUIPalette *)redPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xFFEBEE),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xFFCDD2),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xEF9A9A),
                                                GTUIPaletteTint300Name : ColorFromRGB(0xE57373),
                                                GTUIPaletteTint400Name : ColorFromRGB(0xEF5350),
                                                GTUIPaletteTint500Name : ColorFromRGB(0xF44336),
                                                GTUIPaletteTint600Name : ColorFromRGB(0xE53935),
                                                GTUIPaletteTint700Name : ColorFromRGB(0xD32F2F),
                                                GTUIPaletteTint800Name : ColorFromRGB(0xC62828),
                                                GTUIPaletteTint900Name : ColorFromRGB(0xB71C1C)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xFF8A80),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0xFF5252),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0xFF1744),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0xD50000)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)pinkPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xFCE4EC),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xF8BBD0),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xF48FB1),
                                                GTUIPaletteTint300Name : ColorFromRGB(0xF06292),
                                                GTUIPaletteTint400Name : ColorFromRGB(0xEC407A),
                                                GTUIPaletteTint500Name : ColorFromRGB(0xE91E63),
                                                GTUIPaletteTint600Name : ColorFromRGB(0xD81B60),
                                                GTUIPaletteTint700Name : ColorFromRGB(0xC2185B),
                                                GTUIPaletteTint800Name : ColorFromRGB(0xAD1457),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x880E4F)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xFF80AB),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0xFF4081),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0xF50057),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0xC51162)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)purplePalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xF3E5F5),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xE1BEE7),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xCE93D8),
                                                GTUIPaletteTint300Name : ColorFromRGB(0xBA68C8),
                                                GTUIPaletteTint400Name : ColorFromRGB(0xAB47BC),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x9C27B0),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x8E24AA),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x7B1FA2),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x6A1B9A),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x4A148C)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xEA80FC),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0xE040FB),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0xD500F9),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0xAA00FF)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)deepPurplePalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xEDE7F6),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xD1C4E9),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xB39DDB),
                                                GTUIPaletteTint300Name : ColorFromRGB(0x9575CD),
                                                GTUIPaletteTint400Name : ColorFromRGB(0x7E57C2),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x673AB7),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x5E35B1),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x512DA8),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x4527A0),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x311B92)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xB388FF),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0x7C4DFF),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0x651FFF),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0x6200EA)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)indigoPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xE8EAF6),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xC5CAE9),
                                                GTUIPaletteTint200Name : ColorFromRGB(0x9FA8DA),
                                                GTUIPaletteTint300Name : ColorFromRGB(0x7986CB),
                                                GTUIPaletteTint400Name : ColorFromRGB(0x5C6BC0),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x3F51B5),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x3949AB),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x303F9F),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x283593),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x1A237E)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0x8C9EFF),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0x536DFE),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0x3D5AFE),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0x304FFE)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)bluePalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xE3F2FD),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xBBDEFB),
                                                GTUIPaletteTint200Name : ColorFromRGB(0x90CAF9),
                                                GTUIPaletteTint300Name : ColorFromRGB(0x64B5F6),
                                                GTUIPaletteTint400Name : ColorFromRGB(0x42A5F5),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x2196F3),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x1E88E5),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x1976D2),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x1565C0),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x0D47A1)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0x82B1FF),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0x448AFF),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0x2979FF),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0x2962FF)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)lightBluePalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xE1F5FE),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xB3E5FC),
                                                GTUIPaletteTint200Name : ColorFromRGB(0x81D4FA),
                                                GTUIPaletteTint300Name : ColorFromRGB(0x4FC3F7),
                                                GTUIPaletteTint400Name : ColorFromRGB(0x29B6F6),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x03A9F4),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x039BE5),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x0288D1),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x0277BD),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x01579B)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0x80D8FF),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0x40C4FF),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0x00B0FF),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0x0091EA)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)cyanPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xE0F7FA),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xB2EBF2),
                                                GTUIPaletteTint200Name : ColorFromRGB(0x80DEEA),
                                                GTUIPaletteTint300Name : ColorFromRGB(0x4DD0E1),
                                                GTUIPaletteTint400Name : ColorFromRGB(0x26C6DA),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x00BCD4),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x00ACC1),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x0097A7),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x00838F),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x006064)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0x84FFFF),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0x18FFFF),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0x00E5FF),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0x00B8D4)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)tealPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xE0F2F1),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xB2DFDB),
                                                GTUIPaletteTint200Name : ColorFromRGB(0x80CBC4),
                                                GTUIPaletteTint300Name : ColorFromRGB(0x4DB6AC),
                                                GTUIPaletteTint400Name : ColorFromRGB(0x26A69A),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x009688),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x00897B),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x00796B),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x00695C),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x004D40)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xA7FFEB),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0x64FFDA),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0x1DE9B6),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0x00BFA5)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)greenPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xE8F5E9),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xC8E6C9),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xA5D6A7),
                                                GTUIPaletteTint300Name : ColorFromRGB(0x81C784),
                                                GTUIPaletteTint400Name : ColorFromRGB(0x66BB6A),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x4CAF50),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x43A047),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x388E3C),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x2E7D32),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x1B5E20)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xB9F6CA),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0x69F0AE),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0x00E676),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0x00C853)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)lightGreenPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xF1F8E9),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xDCEDC8),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xC5E1A5),
                                                GTUIPaletteTint300Name : ColorFromRGB(0xAED581),
                                                GTUIPaletteTint400Name : ColorFromRGB(0x9CCC65),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x8BC34A),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x7CB342),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x689F38),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x558B2F),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x33691E)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xCCFF90),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0xB2FF59),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0x76FF03),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0x64DD17)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)limePalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xF9FBE7),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xF0F4C3),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xE6EE9C),
                                                GTUIPaletteTint300Name : ColorFromRGB(0xDCE775),
                                                GTUIPaletteTint400Name : ColorFromRGB(0xD4E157),
                                                GTUIPaletteTint500Name : ColorFromRGB(0xCDDC39),
                                                GTUIPaletteTint600Name : ColorFromRGB(0xC0CA33),
                                                GTUIPaletteTint700Name : ColorFromRGB(0xAFB42B),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x9E9D24),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x827717)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xF4FF81),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0xEEFF41),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0xC6FF00),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0xAEEA00)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)yellowPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xFFFDE7),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xFFF9C4),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xFFF59D),
                                                GTUIPaletteTint300Name : ColorFromRGB(0xFFF176),
                                                GTUIPaletteTint400Name : ColorFromRGB(0xFFEE58),
                                                GTUIPaletteTint500Name : ColorFromRGB(0xFFEB3B),
                                                GTUIPaletteTint600Name : ColorFromRGB(0xFDD835),
                                                GTUIPaletteTint700Name : ColorFromRGB(0xFBC02D),
                                                GTUIPaletteTint800Name : ColorFromRGB(0xF9A825),
                                                GTUIPaletteTint900Name : ColorFromRGB(0xF57F17)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xFFFF8D),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0xFFFF00),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0xFFEA00),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0xFFD600)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)amberPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xFFF8E1),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xFFECB3),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xFFE082),
                                                GTUIPaletteTint300Name : ColorFromRGB(0xFFD54F),
                                                GTUIPaletteTint400Name : ColorFromRGB(0xFFCA28),
                                                GTUIPaletteTint500Name : ColorFromRGB(0xFFC107),
                                                GTUIPaletteTint600Name : ColorFromRGB(0xFFB300),
                                                GTUIPaletteTint700Name : ColorFromRGB(0xFFA000),
                                                GTUIPaletteTint800Name : ColorFromRGB(0xFF8F00),
                                                GTUIPaletteTint900Name : ColorFromRGB(0xFF6F00)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xFFE57F),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0xFFD740),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0xFFC400),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0xFFAB00)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)orangePalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xFFF3E0),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xFFE0B2),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xFFCC80),
                                                GTUIPaletteTint300Name : ColorFromRGB(0xFFB74D),
                                                GTUIPaletteTint400Name : ColorFromRGB(0xFFA726),
                                                GTUIPaletteTint500Name : ColorFromRGB(0xFF9800),
                                                GTUIPaletteTint600Name : ColorFromRGB(0xFB8C00),
                                                GTUIPaletteTint700Name : ColorFromRGB(0xF57C00),
                                                GTUIPaletteTint800Name : ColorFromRGB(0xEF6C00),
                                                GTUIPaletteTint900Name : ColorFromRGB(0xE65100)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xFFD180),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0xFFAB40),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0xFF9100),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0xFF6D00)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)deepOrangePalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xFBE9E7),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xFFCCBC),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xFFAB91),
                                                GTUIPaletteTint300Name : ColorFromRGB(0xFF8A65),
                                                GTUIPaletteTint400Name : ColorFromRGB(0xFF7043),
                                                GTUIPaletteTint500Name : ColorFromRGB(0xFF5722),
                                                GTUIPaletteTint600Name : ColorFromRGB(0xF4511E),
                                                GTUIPaletteTint700Name : ColorFromRGB(0xE64A19),
                                                GTUIPaletteTint800Name : ColorFromRGB(0xD84315),
                                                GTUIPaletteTint900Name : ColorFromRGB(0xBF360C)
                                                }
                                      accents:@{
                                                GTUIPaletteAccent100Name : ColorFromRGB(0xFF9E80),
                                                GTUIPaletteAccent200Name : ColorFromRGB(0xFF6E40),
                                                GTUIPaletteAccent400Name : ColorFromRGB(0xFF3D00),
                                                GTUIPaletteAccent700Name : ColorFromRGB(0xDD2C00)
                                                }];
    });
    return palette;
}

+ (GTUIPalette *)brownPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xEFEBE9),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xD7CCC8),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xBCAAA4),
                                                GTUIPaletteTint300Name : ColorFromRGB(0xA1887F),
                                                GTUIPaletteTint400Name : ColorFromRGB(0x8D6E63),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x795548),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x6D4C41),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x5D4037),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x4E342E),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x3E2723)
                                                }
                                      accents:nil];
    });
    return palette;
}

+ (GTUIPalette *)greyPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xFAFAFA),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xF5F5F5),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xEEEEEE),
                                                GTUIPaletteTint300Name : ColorFromRGB(0xE0E0E0),
                                                GTUIPaletteTint400Name : ColorFromRGB(0xBDBDBD),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x9E9E9E),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x757575),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x616161),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x424242),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x212121)
                                                }
                                      accents:nil];
    });
    return palette;
}

+ (GTUIPalette *)blueGreyPalette {
    static GTUIPalette *palette;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palette = [[self alloc] initWithTints:@{
                                                GTUIPaletteTint50Name : ColorFromRGB(0xECEFF1),
                                                GTUIPaletteTint100Name : ColorFromRGB(0xCFD8DC),
                                                GTUIPaletteTint200Name : ColorFromRGB(0xB0BEC5),
                                                GTUIPaletteTint300Name : ColorFromRGB(0x90A4AE),
                                                GTUIPaletteTint400Name : ColorFromRGB(0x78909C),
                                                GTUIPaletteTint500Name : ColorFromRGB(0x607D8B),
                                                GTUIPaletteTint600Name : ColorFromRGB(0x546E7A),
                                                GTUIPaletteTint700Name : ColorFromRGB(0x455A64),
                                                GTUIPaletteTint800Name : ColorFromRGB(0x37474F),
                                                GTUIPaletteTint900Name : ColorFromRGB(0x263238)
                                                }
                                      accents:nil];
    });
    return palette;
}

+ (instancetype)paletteGeneratedFromColor:(nonnull UIColor *)target500Color {
    NSArray *tintNames = @[
                           GTUIPaletteTint50Name, GTUIPaletteTint100Name, GTUIPaletteTint200Name, GTUIPaletteTint300Name,
                           GTUIPaletteTint400Name, GTUIPaletteTint500Name, GTUIPaletteTint600Name, GTUIPaletteTint700Name,
                           GTUIPaletteTint800Name, GTUIPaletteTint900Name, GTUIPaletteAccent100Name, GTUIPaletteAccent200Name,
                           GTUIPaletteAccent400Name, GTUIPaletteAccent700Name
                           ];

    NSMutableDictionary *tints = [[NSMutableDictionary alloc] init];
    for (GTUIPaletteTint name in tintNames) {
        [tints setObject:GTUIPaletteTintFromTargetColor(target500Color, name) forKey:name];
    }

    NSArray *accentNames = @[
                             GTUIPaletteAccent100Name, GTUIPaletteAccent200Name, GTUIPaletteAccent400Name,
                             GTUIPaletteAccent700Name
                             ];
    NSMutableDictionary *accents = [[NSMutableDictionary alloc] init];
    for (GTUIPaletteAccent name in accentNames) {
        [accents setObject:GTUIPaletteAccentFromTargetColor(target500Color, name) forKey:name];
    }

    return [self paletteWithTints:tints accents:accents];
}

+ (instancetype)paletteWithTints:(NSDictionary<GTUIPaletteTint, UIColor *> *)tints
                         accents:(NSDictionary<GTUIPaletteAccent, UIColor *> *)accents {
    return [[self alloc] initWithTints:tints accents:accents];
}

- (instancetype)initWithTints:(NSDictionary<GTUIPaletteTint, UIColor *> *)tints
                      accents:(NSDictionary<GTUIPaletteAccent, UIColor *> *)accents {
    self = [super init];
    if (self) {
        _accents = accents ? [accents copy] : @{};

        // Check if all the accent colors are present.
        NSDictionary<GTUIPaletteTint, UIColor *> *allTints = tints;
        NSMutableSet<GTUIPaletteAccent> *requiredTintKeys =
        [NSMutableSet setWithSet:[[self class] requiredTintKeys]];
        [requiredTintKeys minusSet:[NSSet setWithArray:[tints allKeys]]];
        if ([requiredTintKeys count] != 0) {
            NSAssert(NO, @"Missing accent colors for the following keys: %@.", requiredTintKeys);
            NSMutableDictionary<GTUIPaletteTint, UIColor *> *replacementTints =
            [NSMutableDictionary dictionaryWithDictionary:_accents];
            for (GTUIPaletteTint tintKey in requiredTintKeys) {
                [replacementTints setObject:[UIColor clearColor] forKey:tintKey];
            }
            allTints = replacementTints;
        }

        _tints = [allTints copy];
    }
    return self;
}

- (UIColor *)tint50 {
    return _tints[GTUIPaletteTint50Name];
}

- (UIColor *)tint100 {
    return _tints[GTUIPaletteTint100Name];
}

- (UIColor *)tint200 {
    return _tints[GTUIPaletteTint200Name];
}

- (UIColor *)tint300 {
    return _tints[GTUIPaletteTint300Name];
}

- (UIColor *)tint400 {
    return _tints[GTUIPaletteTint400Name];
}

- (UIColor *)tint500 {
    return _tints[GTUIPaletteTint500Name];
}

- (UIColor *)tint600 {
    return _tints[GTUIPaletteTint600Name];
}

- (UIColor *)tint700 {
    return _tints[GTUIPaletteTint700Name];
}

- (UIColor *)tint800 {
    return _tints[GTUIPaletteTint800Name];
}

- (UIColor *)tint900 {
    return _tints[GTUIPaletteTint900Name];
}

- (UIColor *)accent100 {
    return _accents[GTUIPaletteAccent100Name];
}

- (UIColor *)accent200 {
    return _accents[GTUIPaletteAccent200Name];
}

- (UIColor *)accent400 {
    return _accents[GTUIPaletteAccent400Name];
}

- (UIColor *)accent700 {
    return _accents[GTUIPaletteAccent700Name];
}

#pragma mark - Private methods

+ (nonnull NSSet<GTUIPaletteTint> *)requiredTintKeys {
    return [NSSet setWithArray:@[
                                 GTUIPaletteTint50Name, GTUIPaletteTint100Name, GTUIPaletteTint200Name, GTUIPaletteTint300Name,
                                 GTUIPaletteTint400Name, GTUIPaletteTint500Name, GTUIPaletteTint600Name, GTUIPaletteTint700Name,
                                 GTUIPaletteTint800Name, GTUIPaletteTint900Name
                                 ]];
}

@end

