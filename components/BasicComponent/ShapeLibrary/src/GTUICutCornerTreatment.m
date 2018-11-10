//
//  GTUICutCornerTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUICutCornerTreatment.h"

static NSString *const GTUICutCornerTreatmentCutKey = @"GTUICutCornerTreatmentCutKey";

@implementation GTUICutCornerTreatment

- (instancetype)init {
    return [self initWithCut:0];
}

- (instancetype)initWithCut:(CGFloat)cut {
    if (self = [super init]) {
        _cut = cut;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _cut = (CGFloat)[aDecoder decodeDoubleForKey:GTUICutCornerTreatmentCutKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeDouble:_cut forKey:GTUICutCornerTreatmentCutKey];
}

- (id)copyWithZone:(NSZone *)zone {
    GTUICutCornerTreatment *copy = [super copyWithZone:zone];
    copy.cut = _cut;
    return copy;
}

- (GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle {
    return [self pathGeneratorForCornerWithAngle:angle andCut:_cut];
}

- (GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle forViewSize:(CGSize)viewSize {
    CGFloat normalizedCut = _cut * viewSize.height;
    return [self pathGeneratorForCornerWithAngle:angle andCut:normalizedCut];
}

- (GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle andCut:(CGFloat)cut {
    GTUIPathGenerator *path = [GTUIPathGenerator pathGeneratorWithStartPoint:CGPointMake(0, cut)];
    [path addLineToPoint:CGPointMake(cut, 0)];
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
    GTUICutCornerTreatment *otherCutCorner = (GTUICutCornerTreatment *)object;
    return self.cut == otherCutCorner.cut;
}

@end

