//
//  UnitTests.m
//  UnitTests
//
//  Created by liuxc on 2018/11/7.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GTShapes.h"

@interface UnitTests : XCTestCase

@end

@implementation UnitTests


- (void)testInit {
    GTUIShapedView *view = [[GTUIShapedView alloc] init];
    XCTAssertNotNil(view);
}




@end
