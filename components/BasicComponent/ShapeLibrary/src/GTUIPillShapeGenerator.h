//
//  GTUIPillShapeGenerator.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <Foundation/Foundation.h>

#import "GTShapes.h"

/**
 A pill shape generator. Rounds the corners such that the shorter sides of the generated shape are
 entirely rounded.
 药丸形状发生器。圆角，使生成的形状的较短的边完全是圆形的。
 */
@interface GTUIPillShapeGenerator : NSObject <GTUIShapeGenerating>
@end
