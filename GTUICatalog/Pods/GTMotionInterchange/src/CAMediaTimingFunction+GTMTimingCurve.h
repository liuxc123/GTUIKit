//
//  CAMediaTimingFunction+MDMTimingCurve.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

#import "GTMTimingCurve.h"

// A CAMediaTimingFunction is a timing curve - we simply define its conformity to our protocol here.
@interface CAMediaTimingFunction () <GTMTimingCurve>

@end

@interface CAMediaTimingFunction (MotionInterchangeExtension)

/**
 Returns a instance of the timing function with its control points reversed.
 */
- (nonnull CAMediaTimingFunction *)gtm_reversed;

/**
 Returns the first control point of the timing function.
 */
@property(nonatomic, assign, readonly) CGPoint gtm_point1;

/**
 Returns the second control point of the timing function.
 */
@property(nonatomic, assign, readonly) CGPoint gtm_point2;

@end
