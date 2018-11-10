//
//  GTUICurvedCornerTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUICurvedCornerTreatment.h"

static NSString *const GTUICurvedCornerTreatmentSizeKey = @"GTUICurvedCornerTreatmentSizeKey";

@implementation GTUICurvedCornerTreatment

- (instancetype)init {
    return [self initWithSize:CGSizeZero];
}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super init]) {
        _size = size;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _size = [aDecoder decodeCGSizeForKey:GTUICurvedCornerTreatmentSizeKey];
    }
    return self;
}

- (GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle {
    return [self pathGeneratorForCornerWithAngle:angle andCurve:_size];
}

- (GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle forViewSize:(CGSize)viewSize {
    CGSize normalizedCurve =
    CGSizeMake(_size.width * viewSize.height, _size.height * viewSize.height);
    return [self pathGeneratorForCornerWithAngle:angle andCurve:normalizedCurve];
}

- (GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle andCurve:(CGSize)curve {
    GTUIPathGenerator *path =
    [GTUIPathGenerator pathGeneratorWithStartPoint:CGPointMake(0, curve.height)];
    [path addQuadCurveWithControlPoint:CGPointZero toPoint:CGPointMake(curve.width, 0)];
    return path;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeCGSize:_size forKey:GTUICurvedCornerTreatmentSizeKey];
}

- (id)copyWithZone:(NSZone *)zone {
    GTUICurvedCornerTreatment *copy = [super copyWithZone:zone];
    copy.size = _size;
    return copy;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    } else if (![super isEqual:object]) {
        return NO;
    }
    if (!object || ![[object class] isEqual:[self class]]) {
        return NO;
    }
    GTUICurvedCornerTreatment *otherCurvedCorner = (GTUICurvedCornerTreatment *)object;
    return CGSizeEqualToSize(self.size, otherCurvedCorner.size);
}

@end
