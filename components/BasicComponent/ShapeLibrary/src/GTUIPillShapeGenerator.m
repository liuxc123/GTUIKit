//
//  GTUIPillShapeGenerator.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <CoreGraphics/CoreGraphics.h>

#import "GTUIPillShapeGenerator.h"

#import "GTMath.h"
#import "GTUIRoundedCornerTreatment.h"

@implementation GTUIPillShapeGenerator {
    GTUIRectangleShapeGenerator *_rectangleGenerator;
    GTUIRoundedCornerTreatment *_cornerShape;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)__unused aDecoder {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)__unused zone {
    return [[[self class] alloc] init];
}

- (void)commonInit {
    _cornerShape = [[GTUIRoundedCornerTreatment alloc] init];
    _rectangleGenerator = [[GTUIRectangleShapeGenerator alloc] init];
    [_rectangleGenerator setCorners:_cornerShape];
}

- (void)encodeWithCoder:(NSCoder *)__unused aCoder {
    // no-op, we have no params
}

- (CGPathRef)pathForSize:(CGSize)size {
    CGFloat radius = 0.5f * MIN(GTUIFabs(size.width), GTUIFabs(size.height));
    if (radius > 0) {
        [_rectangleGenerator setCorners:[[GTUIRoundedCornerTreatment alloc] initWithRadius:radius]];
    }
    return [_rectangleGenerator pathForSize:size];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
