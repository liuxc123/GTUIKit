//
//  GTUITonalPalette.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import "GTUITonalPalette.h"

static NSString *const GTUITonalPaletteColorsKey = @"GTUITonalPaletteColorsKey";
static NSString *const GTUITonalPaletteMainColorIndexKey = @"GTUITonalPaletteMainColorIndexKey";
static NSString *const GTUITonalPaletteLightColorIndexKey = @"GTUITonalPaletteLightColorIndexKey";
static NSString *const GTUITonalPaletteDarkColorIndexKey = @"GTUITonalPaletteDarkColorIndexKey";

@interface GTUITonalPalette ()

@property (nonatomic, copy, nonnull) NSArray<UIColor *> *colors;
@property (nonatomic) NSUInteger mainColorIndex;
@property (nonatomic) NSUInteger lightColorIndex;
@property (nonatomic) NSUInteger darkColorIndex;

@end

@implementation GTUITonalPalette

- (nonnull instancetype)initWithColors:(nonnull NSArray<UIColor *> *)colors
                        mainColorIndex:(NSUInteger)mainColorIndex
                       lightColorIndex:(NSUInteger)lightColorIndex
                        darkColorIndex:(NSUInteger)darkColorIndex {
    self = [super init];
    if (self) {
        _colors = [colors copy];
        if (mainColorIndex > colors.count - 1) {
            NSAssert(NO, @"Main color index is greater than color array size.");
        }
        if (lightColorIndex > colors.count - 1) {
            NSAssert(NO, @"Light color index is greater than color array size.");
        }
        if (darkColorIndex > colors.count - 1) {
            NSAssert(NO, @"Dark color index is greater than color array size.");
        }
        _mainColorIndex = mainColorIndex;
        _lightColorIndex = lightColorIndex;
        _darkColorIndex = darkColorIndex;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        if ([coder containsValueForKey:GTUITonalPaletteColorsKey]) {
            _colors = [coder decodeObjectOfClass:[NSArray class] forKey:GTUITonalPaletteColorsKey];
        }

        if ([coder containsValueForKey:GTUITonalPaletteMainColorIndexKey]) {
            _mainColorIndex = [coder decodeIntegerForKey:GTUITonalPaletteMainColorIndexKey];
        }

        if ([coder containsValueForKey:GTUITonalPaletteLightColorIndexKey]) {
            _lightColorIndex = [coder decodeIntegerForKey:GTUITonalPaletteLightColorIndexKey];
        }

        if ([coder containsValueForKey:GTUITonalPaletteDarkColorIndexKey]) {
            _darkColorIndex = [coder decodeIntegerForKey:GTUITonalPaletteDarkColorIndexKey];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.colors forKey:GTUITonalPaletteColorsKey];
    [aCoder encodeInteger:self.mainColorIndex forKey:GTUITonalPaletteMainColorIndexKey];
    [aCoder encodeInteger:self.lightColorIndex forKey:GTUITonalPaletteLightColorIndexKey];
    [aCoder encodeInteger:self.darkColorIndex forKey:GTUITonalPaletteDarkColorIndexKey];
}

- (UIColor *)mainColor {
    return _colors[_mainColorIndex];
}

- (UIColor *)lightColor {
    return _colors[_lightColorIndex];
}

- (UIColor *)darkColor {
    return _colors[_darkColorIndex];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    GTUITonalPalette *copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        copy.colors = [self colors];
        copy.mainColorIndex = [self mainColorIndex];
        copy.lightColorIndex = [self lightColorIndex];
        copy.darkColorIndex = [self darkColorIndex];
    }
    return copy;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

