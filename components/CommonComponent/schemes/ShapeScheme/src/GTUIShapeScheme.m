//
//  GTUIShapeScheme.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import "GTUIShapeScheme.h"

@implementation GTUIShapeScheme

- (instancetype)init {
    return [self initWithDefaults:GTUIShapeSchemeDefaults201809];
}

- (instancetype)initWithDefaults:(GTUIShapeSchemeDefaults)defaults {
    self = [super init];
    if (self) {
        switch (defaults) {
            case GTUIShapeSchemeDefaults201809:
                _smallComponentShape =
                [[GTUIShapeCategory alloc] initCornersWithFamily:GTUIShapeCornerFamilyRounded
                                                        andSize:4.f];
                _mediumComponentShape =
                [[GTUIShapeCategory alloc] initCornersWithFamily:GTUIShapeCornerFamilyRounded
                                                        andSize:4.f];
                _largeComponentShape =
                [[GTUIShapeCategory alloc] initCornersWithFamily:GTUIShapeCornerFamilyRounded
                                                        andSize:0.f];
                break;
        }
    }
    return self;
}

@end
