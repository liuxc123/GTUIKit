//
//  GTUITriangleEdgeTreatment.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUITriangleEdgeTreatment.h"

static NSString *const GTUITriangleEdgeTreatmentSizeKey = @"GTUITriangleEdgeTreatmentSizeKey";
static NSString *const GTUITriangleEdgeTreatmentStyleKey = @"GTUITriangleEdgeTreatmentStyleKey";

@implementation GTUITriangleEdgeTreatment

- (instancetype)initWithSize:(CGFloat)size style:(GTUITriangleEdgeStyle)style {
    if (self = [super init]) {
        _size = size;
        _style = style;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _size = (CGFloat)[aDecoder decodeDoubleForKey:GTUITriangleEdgeTreatmentSizeKey];
        _style = [aDecoder decodeIntegerForKey:GTUITriangleEdgeTreatmentStyleKey];
    }
    return self;
}

- (GTUIPathGenerator *)pathGeneratorForEdgeWithLength:(CGFloat)length {
    BOOL isCut = (self.style == GTUITriangleEdgeStyleCut);
    GTUIPathGenerator *path = [GTUIPathGenerator pathGeneratorWithStartPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(length/2 - _size, 0)];
    [path addLineToPoint:CGPointMake(length/2, isCut ? _size : -_size)];
    [path addLineToPoint:CGPointMake(length/2 + _size, 0)];
    [path addLineToPoint:CGPointMake(length, 0)];
    return path;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeDouble:_size forKey:GTUITriangleEdgeTreatmentSizeKey];
    [aCoder encodeInteger:_style forKey:GTUITriangleEdgeTreatmentStyleKey];
}

- (id)copyWithZone:(NSZone *)__unused zone {
    return [[[self class] alloc] initWithSize:_size style:_style];
}

@end
