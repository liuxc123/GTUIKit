//
//  GTUIBorderEdgeTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import "GTUIBorderEdgeTreatment.h"

static NSString *const GTUIBorderEdgeTreatmentBorderWidthKey = @"GTUIBorderEdgeTreatmentBorderWidthKey";
static NSString *const GTUIBorderEdgeTreatmentBorderColorKey = @"GTUIBorderEdgeTreatmentBorderColorKey";

@implementation GTUIBorderEdgeTreatment

- (instancetype)initWithBorderWidth:(CGFloat)width borderColor:(UIColor *)color {
    if (self = [super init]) {
        _shapedBorderWidth = width;
        _shapedBorderColor = color;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _shapedBorderWidth = (CGFloat)[aDecoder decodeDoubleForKey:GTUIBorderEdgeTreatmentBorderWidthKey];
        _shapedBorderColor =
        [aDecoder decodeObjectOfClass:[UIColor class] forKey:GTUIBorderEdgeTreatmentBorderColorKey];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeDouble:_shapedBorderWidth forKey:GTUIBorderEdgeTreatmentBorderWidthKey];
    [aCoder encodeObject:_shapedBorderColor forKey:GTUIBorderEdgeTreatmentBorderColorKey];
}

- (id)copyWithZone:(NSZone *)__unused zone {
    return [[[self class] alloc] initWithBorderWidth:_shapedBorderWidth borderColor:_shapedBorderColor];
}

- (GTUIPathGenerator *)pathGeneratorForEdgeWithLength:(CGFloat)length {
    GTUIPathGenerator *path = [GTUIPathGenerator pathGeneratorWithStartPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(length, 0)];
    return path;
}

@end
