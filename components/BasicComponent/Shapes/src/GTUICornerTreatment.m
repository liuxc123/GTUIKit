//
//  GTUICornerTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUICornerTreatment.h"

#import "GTUIPathGenerator.h"

@implementation GTUICornerTreatment


- (instancetype)init {
    _valueType = GTUICornerTreatmentValueTypeAbsolute;
    return [super init];
}

- (instancetype)initWithCoder:(NSCoder *)__unused aDecoder {
    if (self = [super init]) {
        // GTUICornerTreatment has no params so nothing to decode here.
    }
    return self;
}

- (GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)__unused angle {
    return [GTUIPathGenerator pathGeneratorWithStartPoint:CGPointZero];
}

- (GTUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)__unused angle
                                          forViewSize:(CGSize)__unused viewSize {
    return [GTUIPathGenerator pathGeneratorWithStartPoint:CGPointZero];
}

- (void)encodeWithCoder:(NSCoder *)__unused aCoder {
    // GTUICornerTreatment has no params, so nothing to encode here.
}

- (id)copyWithZone:(nullable NSZone *)__unused zone {
    GTUICornerTreatment *copy = [[[self class] alloc] init];
    copy.valueType = _valueType;
    return copy;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if (!object || ![[object class] isEqual:[self class]]) {
        return NO;
    }
    GTUICornerTreatment *otherCorner = (GTUICornerTreatment *)object;
    return self.valueType == otherCorner.valueType;
}


@end
