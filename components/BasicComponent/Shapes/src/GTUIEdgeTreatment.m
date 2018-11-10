//
//  GTUIEdgeTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUIEdgeTreatment.h"

#import "GTUIPathGenerator.h"

@implementation GTUIEdgeTreatment

- (instancetype)init {
    return [super init];
}

- (instancetype)initWithCoder:(NSCoder *)__unused aDecoder {
    if (self = [super init]) {
        // GTUIEdgeTreatment has no params so nothing to decode here.
    }
    return self;
}

- (GTUIPathGenerator *)pathGeneratorForEdgeWithLength:(CGFloat)length {
    GTUIPathGenerator *path = [GTUIPathGenerator pathGeneratorWithStartPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(length, 0)];
    return path;
}

- (void)encodeWithCoder:(NSCoder *)__unused aCoder {
    // GTUIEdgeTreatment has no params, so nothing to encode here.
}

- (id)copyWithZone:(nullable NSZone *)__unused zone {
    return [[[self class] alloc] init];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
