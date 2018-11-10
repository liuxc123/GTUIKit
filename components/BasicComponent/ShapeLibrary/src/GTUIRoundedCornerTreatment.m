//
//  GTUIRoundedCornerTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUIRoundedCornerTreatment.h"

#import "GTMath.h"

static NSString *const GTUIRoundedCornerTreatmentRadiusKey = @"GTUIRoundedCornerTreatmentRadiusKey";

@implementation GTUIRoundedCornerTreatment

- (instancetype)init {
    return [self initWithRadius:0];
}

- (instancetype)initWithRadius:(CGFloat)radius {
    if (self = [super init]) {
        _radius = radius;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _radius = (CGFloat)[aDecoder decodeDoubleForKey:GTUIRoundedCornerTreatmentRadiusKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeDouble:_radius forKey:GTUIRoundedCornerTreatmentRadiusKey];
}

- (id)copyWithZone:(NSZone *)zone {
    GTUIRoundedCornerTreatment *copy = [super copyWithZone:zone];
    copy.radius = _radius;
    return copy;
}

- (GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle {
    return [self pathGeneratorForCornerWithAngle:angle andRadius:_radius];
}

- (GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle forViewSize:(CGSize)viewSize {
    CGFloat normalizedRadius = _radius * viewSize.height;
    return [self pathGeneratorForCornerWithAngle:angle andRadius:normalizedRadius];
}

- (GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle andRadius:(CGFloat)radius {
    GTUIPathGenerator *path = [GTUIPathGenerator pathGeneratorWithStartPoint:CGPointMake(0, radius)];
    [path addArcWithTangentPoint:CGPointZero
                         toPoint:CGPointMake(GTUISin(angle) * radius, GTUICos(angle) * radius)
                          radius:radius];
    return path;
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
    GTUIRoundedCornerTreatment *otherRoundedCorner = (GTUIRoundedCornerTreatment *)object;
    return self.radius == otherRoundedCorner.radius;
}

@end

