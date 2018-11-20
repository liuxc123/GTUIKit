//
//  GTUITooBarLayer.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>

#import "GTUIToolBarView.h"

@interface GTUIToolBarLayer : CAShapeLayer

- (CGPathRef)pathFromRect:(CGRect)rect
           floatingButton:(GTUIFloatingButton *)floatingButton
       navigationBarFrame:(CGRect)navigationBarFrame
                shouldCut:(BOOL)shouldCut;

@end
