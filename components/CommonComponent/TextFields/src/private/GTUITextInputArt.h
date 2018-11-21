//
//  GTUITextInputArt.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

#import "GTMath.h"

static const CGFloat GTUITextInputClearButtonImageBuiltInPadding = 2.0f;

#pragma mark - Drawing

static inline UIBezierPath *GTUIPathForClearButtonImageFrame(CGRect frame) {
    // GENERATED CODE

    CGRect innerBounds = CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 2,
                                    GTUIFloor((frame.size.width - 2) * 0.90909f + 0.5f),
                                    GTUIFloor((frame.size.height - 2) * 0.90909f + 0.5f));

    UIBezierPath *ic_clear_path = [UIBezierPath bezierPath];
    [ic_clear_path
     moveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50000f * innerBounds.size.width,
                             CGRectGetMinY(innerBounds) + 0.00000f * innerBounds.size.height)];
    [ic_clear_path
     addCurveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 1.00000f * innerBounds.size.width,
                                 CGRectGetMinY(innerBounds) + 0.50000f * innerBounds.size.height)
     controlPoint1:CGPointMake(CGRectGetMinX(innerBounds) + 0.77600f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.00000f * innerBounds.size.height)
     controlPoint2:CGPointMake(CGRectGetMinX(innerBounds) + 1.00000f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.22400f * innerBounds.size.height)];
    [ic_clear_path
     addCurveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50000f * innerBounds.size.width,
                                 CGRectGetMinY(innerBounds) + 1.00000f * innerBounds.size.height)
     controlPoint1:CGPointMake(CGRectGetMinX(innerBounds) + 1.00000f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.77600f * innerBounds.size.height)
     controlPoint2:CGPointMake(CGRectGetMinX(innerBounds) + 0.77600f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 1.00000f * innerBounds.size.height)];
    [ic_clear_path
     addCurveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.00000f * innerBounds.size.width,
                                 CGRectGetMinY(innerBounds) + 0.50000f * innerBounds.size.height)
     controlPoint1:CGPointMake(CGRectGetMinX(innerBounds) + 0.22400f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 1.00000f * innerBounds.size.height)
     controlPoint2:CGPointMake(CGRectGetMinX(innerBounds) + 0.00000f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.77600f * innerBounds.size.height)];
    [ic_clear_path
     addCurveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50000f * innerBounds.size.width,
                                 CGRectGetMinY(innerBounds) + 0.00000f * innerBounds.size.height)
     controlPoint1:CGPointMake(CGRectGetMinX(innerBounds) + 0.00000f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.22400f * innerBounds.size.height)
     controlPoint2:CGPointMake(CGRectGetMinX(innerBounds) + 0.22400f * innerBounds.size.width,
                               CGRectGetMinY(innerBounds) + 0.00000f * innerBounds.size.height)];
    [ic_clear_path closePath];
    [ic_clear_path
     moveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.73417f * innerBounds.size.width,
                             CGRectGetMinY(innerBounds) + 0.31467f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.68700f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.26750f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50083f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.45367f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.31467f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.26750f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.26750f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.31467f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.45367f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.50083f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.26750f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.68700f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.31467f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.73417f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50083f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.54800f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.68700f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.73417f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.73417f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.68700f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.54800f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.50083f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.73417f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.31467f * innerBounds.size.height)];
    [ic_clear_path closePath];

    return ic_clear_path;
}

static inline UIBezierPath *GTUIPathForClearButtonLegacyImageFrame(CGRect frame) {
    // GENERATED CODE

    CGRect innerBounds = CGRectMake(CGRectGetMinX(frame) + 10, CGRectGetMinY(frame) + 10,
                                    GTUIFloor((frame.size.width - 10) * 0.73684f + 0.5f),
                                    GTUIFloor((frame.size.height - 10) * 0.73684f + 0.5f));

    UIBezierPath *ic_clear_path = [UIBezierPath bezierPath];
    [ic_clear_path
     moveToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 1.00000f * innerBounds.size.width,
                             CGRectGetMinY(innerBounds) + 0.10107f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.89893f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.00000f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50000f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.39893f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.10107f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.00000f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.00000f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.10107f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.39893f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.50000f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.00000f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.89893f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.10107f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 1.00000f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.50000f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.60107f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.89893f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 1.00000f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 1.00000f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.89893f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 0.60107f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.50000f * innerBounds.size.height)];
    [ic_clear_path
     addLineToPoint:CGPointMake(CGRectGetMinX(innerBounds) + 1.00000f * innerBounds.size.width,
                                CGRectGetMinY(innerBounds) + 0.10107f * innerBounds.size.height)];
    [ic_clear_path closePath];

    return ic_clear_path;
}
