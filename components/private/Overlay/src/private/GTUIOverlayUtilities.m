//
//  GTUIOverlayUtilities.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import "GTUIOverlayUtilities.h"

CGRect GTUIOverlayConvertRectToView(CGRect screenRect, UIView *target) {
    if (target != nil && !CGRectIsNull(screenRect)) {
        UIScreen *screen = [UIScreen mainScreen];
        return [target convertRect:screenRect fromCoordinateSpace:screen.coordinateSpace];
    }
    return CGRectNull;
}
