//
//  GTUITabBarBaseCellModel.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarBaseCellModel.h"

@implementation GTUITabBarBaseCellModel

- (CGFloat)cellWidth {
    if (_cellWidthZoomEnabled) {
        return _cellWidth * _cellWidthZoomScale;
    }
    return _cellWidth;
}

@end
