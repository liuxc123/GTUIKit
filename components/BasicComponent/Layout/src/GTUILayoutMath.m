//
//  GTUILayoutMath.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUILayoutMath.h"
#import <math.h>


BOOL _gtuiCGFloatErrorEqual(CGFloat f1, CGFloat f2, CGFloat error)
{
#if CGFLOAT_IS_DOUBLE == 1
    return fabs(f1 - f2) < error;
#else
    return fabsf(f1 - f2) < error;
#endif
}

BOOL _gtuiCGFloatErrorNotEqual(CGFloat f1, CGFloat f2, CGFloat error)
{
#if CGFLOAT_IS_DOUBLE == 1
    return fabs(f1 - f2) > error;
#else
    return fabsf(f1 - f2) > error;
#endif
}




BOOL _gtuiCGFloatEqual(CGFloat f1, CGFloat f2)
{
#if CGFLOAT_IS_DOUBLE == 1
    return fabs(f1 - f2) < 0.0000001;
#else
    return fabsf(f1 - f2) < 0.0001f;
#endif
}

BOOL _gtuiCGFloatNotEqual(CGFloat f1, CGFloat f2)
{
#if CGFLOAT_IS_DOUBLE == 1
    return fabs(f1 - f2) > 0.0000001;
#else
    return fabsf(f1 - f2) > 0.0001f;
#endif
}

BOOL _gtuiCGFloatLess(CGFloat f1, CGFloat f2)
{
#if CGFLOAT_IS_DOUBLE == 1
    return f2 - f1 > 0.0000001;
#else
    return f2 - f1 > 0.0001f;
#endif
    
}

BOOL _gtuiCGFloatGreat(CGFloat f1, CGFloat f2)
{
#if CGFLOAT_IS_DOUBLE == 1
    return f1 - f2 > 0.0000001;
#else
    return f1 - f2 > 0.0001f;
#endif
}

BOOL _gtuiCGFloatLessOrEqual(CGFloat f1, CGFloat f2)
{
    
#if CGFLOAT_IS_DOUBLE == 1
    return f1 < f2 || fabs(f1 - f2) < 0.0000001;
#else
    return f1 < f2 || fabsf(f1 - f2) < 0.0001f;
#endif
}

BOOL _gtuiCGFloatGreatOrEqual(CGFloat f1, CGFloat f2)
{
#if CGFLOAT_IS_DOUBLE == 1
    return f1 > f2 || fabs(f1 - f2) < 0.0000001;
#else
    return f1 > f2 || fabsf(f1 - f2) < 0.0001f;
#endif
}

BOOL _gtuiCGSizeEqual(CGSize sz1, CGSize sz2)
{
    return _gtuiCGFloatEqual(sz1.width, sz2.width) && _gtuiCGFloatEqual(sz1.height, sz2.height);
}

BOOL _gtuiCGPointEqual(CGPoint pt1, CGPoint pt2)
{
    return _gtuiCGFloatEqual(pt1.x, pt2.x) && _gtuiCGFloatEqual(pt1.y, pt2.y);
}

BOOL _gtuiCGRectEqual(CGRect rect1, CGRect rect2)
{
    return _gtuiCGSizeEqual(rect1.size, rect2.size) && _gtuiCGPointEqual(rect1.origin, rect2.origin);
}


CGFloat _gtuiCGFloatRound(CGFloat f)
{
    if (f == 0 || f == CGFLOAT_MAX || f == -CGFLOAT_MAX)
        return f;
    
    static CGFloat scale = 0;
    if (scale == 0)
        scale = [UIScreen mainScreen].scale;
    
    //因为设备点转化为像素时，如果偏移了半个像素点就有可能会产生虚化的效果，因此这里要将设备点先转化为像素点，然后再添加0.5个偏移取整后再除以倍数则是转化为有效的设备逻辑点。
#if CGFLOAT_IS_DOUBLE == 1
    if (f < 0)
        return ceil(fma(f, scale, -0.5)) / scale;
    else
        return floor(fma(f, scale, 0.5)) / scale;
#else
    if (f < 0)
        return ceilf(fmaf(f, scale, -0.5f)) / scale;
    else
        return floorf(fmaf(f, scale, 0.5f)) / scale;
#endif
}

CGRect _gtuiLayoutCGRectRound(CGRect rect)
{
    CGFloat x1 = rect.origin.x;
    CGFloat y1 = rect.origin.y;
    CGFloat w1 = rect.size.width;
    CGFloat h1 = rect.size.height;
    
    rect.origin.x =  _gtuiCGFloatRound(x1);
    rect.origin.y = _gtuiCGFloatRound(y1);
    
    CGFloat mx = _gtuiCGFloatRound(x1 + w1);
    CGFloat my = _gtuiCGFloatRound(y1 + h1);
    
    rect.size.width = mx - rect.origin.x;
    rect.size.height = my - rect.origin.y;
    
    return rect;
    
}



CGRect _gtuiCGRectRound(CGRect rect)
{
    rect.origin.x =  _gtuiCGFloatRound(rect.origin.x);
    rect.origin.y = _gtuiCGFloatRound(rect.origin.y);
    rect.size.width = _gtuiCGFloatRound(rect.size.width);
    rect.size.height = _gtuiCGFloatRound(rect.size.height);
    
    return rect;
    
}

CGSize _gtuiCGSizeRound(CGSize size)
{
    size.width = _gtuiCGFloatRound(size.width);
    size.height = _gtuiCGFloatRound(size.height);
    return size;
}

CGPoint _gtuiCGPointRound(CGPoint point)
{
    point.x = _gtuiCGFloatRound(point.x);
    point.y = _gtuiCGFloatRound(point.y);
    return point;
}

CGFloat _gtuiCGFloatMax(CGFloat a, CGFloat b)
{
#if CGFLOAT_IS_DOUBLE == 1
    return fmax(a, b);
#else
    return fmaxf(a, b);
#endif
}

CGFloat _gtuiCGFloatMin(CGFloat a, CGFloat b)
{
#if CGFLOAT_IS_DOUBLE == 1
    return fmin(a, b);
#else
    return fminf(a, b);
#endif
    
}

extern CGFloat _gtuiCGFloatFma(CGFloat a, CGFloat b, CGFloat c)
{
#if CGFLOAT_IS_DOUBLE == 1
    return fma(a, b, c);
#else
    return fmaf(a, b, c);
#endif
}

