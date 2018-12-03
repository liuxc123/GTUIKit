//
//  GTUIBorderline.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUIBorderline.h"

@implementation GTUIBorderline

-(instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        _color = [UIColor blackColor];
        _thick = 1;
        _headIndent = 0;
        _tailIndent = 0;
        _dash  = 0;
        _offset = 0;
    }
    
    return self;
}

-(instancetype)initWithColor:(UIColor *)color
{
    self = [self init];
    if (self != nil)
    {
        _color = color;
    }
    
    return self;
}

-(instancetype)initWithColor:(UIColor *)color thick:(CGFloat)thick
{
    self = [self initWithColor:color];
    if (self != nil)
    {
        self.thick = thick;
    }
    
    return self;
}

-(instancetype)initWithColor:(UIColor *)color thick:(CGFloat)thick headIndent:(CGFloat)headIndent tailIndent:(CGFloat)tailIndent
{
    self = [self initWithColor:color thick:thick];
    if (self != nil)
    {
        _headIndent = headIndent;
        _tailIndent = tailIndent;
    }
    
    return self;
    
}

-(instancetype)initWithColor:(UIColor *)color thick:(CGFloat)thick headIndent:(CGFloat)headIndent tailIndent:(CGFloat)tailIndent offset:(CGFloat)offset
{
    self = [self initWithColor:color thick:thick headIndent:headIndent tailIndent:tailIndent];
    if (self != nil)
    {
        _offset = offset;
    }
    
    return self;
}

-(void)setThick:(CGFloat)thick
{
    if (thick < 1)
        thick = 1;
    if (_thick != thick)
    {
        _thick = thick;
    }
}

@end
