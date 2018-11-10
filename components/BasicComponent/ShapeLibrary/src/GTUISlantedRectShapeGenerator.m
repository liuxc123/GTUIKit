//
//  GTUISlantedRectShapeGenerator.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUISlantedRectShapeGenerator.h"

static NSString *const GTUISlantedRectShapeGeneratorSlantKey =
@"GTUISlantedRectShapeGeneratorSlantKey";

@implementation GTUISlantedRectShapeGenerator {
    GTUIRectangleShapeGenerator *_rectangleGenerator;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonGTUISlantedRectShapeGeneratorInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self commonGTUISlantedRectShapeGeneratorInit];

        _slant = (CGFloat)[aDecoder decodeDoubleForKey:GTUISlantedRectShapeGeneratorSlantKey];
    }
    return self;
}

- (void)commonGTUISlantedRectShapeGeneratorInit {
    _rectangleGenerator = [[GTUIRectangleShapeGenerator alloc] init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:_slant forKey:GTUISlantedRectShapeGeneratorSlantKey];
}

- (id)copyWithZone:(NSZone *)__unused zone {
    GTUISlantedRectShapeGenerator *copy = [[[self class] alloc] init];
    copy.slant = self.slant;
    return copy;
}

- (void)setSlant:(CGFloat)slant {
    _slant = slant;

    _rectangleGenerator.topLeftCornerOffset     = CGPointMake( slant, 0);
    _rectangleGenerator.topRightCornerOffset    = CGPointMake( slant, 0);
    _rectangleGenerator.bottomLeftCornerOffset  = CGPointMake(-slant, 0);
    _rectangleGenerator.bottomRightCornerOffset = CGPointMake(-slant, 0);
}

- (CGPathRef)pathForSize:(CGSize)size {
    return [_rectangleGenerator pathForSize:size];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
