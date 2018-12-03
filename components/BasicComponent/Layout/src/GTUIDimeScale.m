//
//  GTUIDimeScale.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUIDimeScale.h"


extern CGFloat _gtuiCGFloatRound(CGFloat);
extern CGPoint _gtuiCGPointRound(CGPoint);
extern CGSize _gtuiCGSizeRound(CGSize);
extern CGRect _gtuiCGRectRound(CGRect);


@implementation GTUIDimeScale

CGFloat _rate = 1;
CGFloat _wrate = 1;
CGFloat _hrate = 1;


+(void)setUITemplateSize:(CGSize)size
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    _wrate = screenSize.width / size.width;
    _hrate = screenSize.height / size.height;
    _rate = sqrt((screenSize.width * screenSize.width + screenSize.height * screenSize.height) / (size.width * size.width + size.height * size.height));
}

+(CGFloat)scale:(CGFloat)val
{
    return _gtuiCGFloatRound(val * _rate);
}

+(CGFloat)scaleW:(CGFloat)val
{
    return _gtuiCGFloatRound(val * _wrate);
}

+(CGFloat)scaleH:(CGFloat)val
{
    return _gtuiCGFloatRound(val * _hrate);
}

+(CGFloat)roundNumber:(CGFloat)number
{
    return _gtuiCGFloatRound(number);
}

+(CGPoint)roundPoint:(CGPoint)point
{
    return _gtuiCGPointRound(point);
}

+(CGSize)roundSize:(CGSize)size
{
    return _gtuiCGSizeRound(size);
}

+(CGRect)roundRect:(CGRect)rect
{
    return _gtuiCGRectRound(rect);
}


@end


