//
//  GTUIShapeCategory.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import "GTUIShapeCategory.h"
#import "GTShapeLibrary.h"

@implementation GTUIShapeCategory

- (instancetype)init {
    return [self initCornersWithFamily:GTUIShapeCornerFamilyRounded andSize:0];
}

- (instancetype)initCornersWithFamily:(GTUIShapeCornerFamily)cornerFamily
                              andSize:(CGFloat)cornerSize {
    if (self = [super init]) {
        GTUICornerTreatment *cornerTreatment;
        switch (cornerFamily) {
            case GTUIShapeCornerFamilyCut:
                cornerTreatment = [GTUICornerTreatment cornerWithCut:cornerSize];
                break;
            case GTUIShapeCornerFamilyRounded:
                cornerTreatment = [GTUICornerTreatment cornerWithRadius:cornerSize];
                break;
        }
        _topLeftCorner = cornerTreatment;
        _topRightCorner = cornerTreatment;
        _bottomLeftCorner = cornerTreatment;
        _bottomRightCorner = cornerTreatment;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (!object || ![[object class] isEqual:[self class]]) {
        return NO;
    }

    GTUIShapeCategory *other = (GTUIShapeCategory *)object;
    return [_topLeftCorner isEqual:other.topLeftCorner] &&
    [_topRightCorner isEqual:other.topRightCorner] &&
    [_bottomLeftCorner isEqual:other.bottomLeftCorner] &&
    [_bottomRightCorner isEqual:other.bottomRightCorner];
}

@end
