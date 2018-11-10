//
//  GTMath.h
//  GTUIatalog
//
//  Created by liuxc on 2018/8/16.
//

#import <math.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

static inline CGFloat GTUISin(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return sin(value);
#else
    return sinf(value);
#endif
}

static inline CGFloat GTUICos(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return cos(value);
#else
    return cosf(value);
#endif
}

static inline CGFloat GTUIAtan2(CGFloat y, CGFloat x) {
#if CGFLOAT_IS_DOUBLE
    return atan2(y, x);
#else
    return atan2f(y, x);
#endif
}

static inline CGFloat GTUICeil(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return ceil(value);
#else
    return ceilf(value);
#endif
}

static inline CGFloat GTUIFabs(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return fabs(value);
#else
    return fabsf(value);
#endif
}

static inline CGFloat GTUIDegreesToRadians(CGFloat degrees) {
#if CGFLOAT_IS_DOUBLE
    return degrees * (CGFloat)M_PI / 180.0;
#else
    return degrees * (CGFloat)M_PI / 180.f;
#endif
}

static inline BOOL GTUICGFloatEqual(CGFloat a, CGFloat b) {
    const CGFloat constantK = 3;
#if CGFLOAT_IS_DOUBLE
    const CGFloat epsilon = DBL_EPSILON;
    const CGFloat min = DBL_MIN;
#else
    const CGFloat epsilon = FLT_EPSILON;
    const CGFloat min = FLT_MIN;
#endif
    return (GTUIFabs(a - b) < constantK * epsilon * GTUIFabs(a + b) || GTUIFabs(a - b) < min);
}

static inline CGFloat GTUIFloor(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return floor(value);
#else
    return floorf(value);
#endif
}

static inline CGFloat GTUIHypot(CGFloat x, CGFloat y) {
#if CGFLOAT_IS_DOUBLE
    return hypot(x, y);
#else
    return hypotf(x, y);
#endif
}

// Checks whether the provided floating point number is exactly zero.
static inline BOOL GTUICGFloatIsExactlyZero(CGFloat value) {
    return (value == 0.f);
}

static inline CGFloat GTUIPow(CGFloat value, CGFloat power) {
#if CGFLOAT_IS_DOUBLE
    return pow(value, power);
#else
    return powf(value, power);
#endif
}

static inline CGFloat GTUIRint(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return rint(value);
#else
    return rintf(value);
#endif
}

static inline CGFloat GTUIRound(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return round(value);
#else
    return roundf(value);
#endif
}

static inline CGFloat GTUISqrt(CGFloat value) {
#if CGFLOAT_IS_DOUBLE
    return sqrt(value);
#else
    return sqrtf(value);
#endif
}

/**
 Expand `rect' to the smallest standardized rect containing it with pixel-aligned origin and size.
 If @c scale is zero, then a scale of 1 will be used instead.

 @param rect the rectangle to align.
 @param scale the scale factor to use for pixel alignment.

 @return the input rectangle aligned to the nearest pixels using the provided scale factor.

 @see CGRectIntegral
 */
static inline CGRect GTUIRectAlignToScale(CGRect rect, CGFloat scale) {
    if (CGRectIsNull(rect)) {
        return CGRectNull;
    }
    if (GTUICGFloatEqual(scale, 0)) {
        scale = 1;
    }

    if (GTUICGFloatEqual(scale, 1)) {
        return CGRectIntegral(rect);
    }

    CGPoint originalMinimumPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint newOrigin = CGPointMake(GTUIFloor(originalMinimumPoint.x * scale) / scale,
                                    GTUIFloor(originalMinimumPoint.y * scale) / scale);
    CGSize adjustWidthHeight =
    CGSizeMake(originalMinimumPoint.x - newOrigin.x, originalMinimumPoint.y - newOrigin.y);
    return CGRectMake(newOrigin.x, newOrigin.y,
                      GTUICeil((CGRectGetWidth(rect) + adjustWidthHeight.width) * scale) / scale,
                      GTUICeil((CGRectGetHeight(rect) + adjustWidthHeight.height) * scale) / scale);
}

static inline CGPoint GTUIPointRoundWithScale(CGPoint point, CGFloat scale) {
    if (GTUICGFloatEqual(scale, 0)) {
        return CGPointZero;
    }

    return CGPointMake(GTUIRound(point.x * scale) / scale, GTUIRound(point.y * scale) / scale);
}

/**
 Expand `size' to the closest larger pixel-aligned value.
 If @c scale is zero, then a CGSizeZero will be returned.

 @param size the size to align.
 @param scale the scale factor to use for pixel alignment.

 @return the size aligned to the closest larger pixel-aligned value using the provided scale factor.
 */
static inline CGSize GTUISizeCeilWithScale(CGSize size, CGFloat scale) {
    if (GTUICGFloatEqual(scale, 0)) {
        return CGSizeZero;
    }

    return CGSizeMake(GTUICeil(size.width * scale) / scale, GTUICeil(size.height * scale) / scale);
}

/**
 Align the centerPoint of a view so that its origin is pixel-aligned to the nearest pixel.
 Returns @c CGRectZero if @c scale is zero or @c bounds is @c CGRectNull.

 @param center the unaligned center of the view.
 @param bounds the bounds of the view.
 @param scale the native scaling factor for pixel alignment.

 @return the center point of the view such that its origin will be pixel-aligned.
 */
static inline CGPoint GTUIRoundCenterWithBoundsAndScale(CGPoint center,
                                                       CGRect bounds,
                                                       CGFloat scale) {
    if (GTUICGFloatEqual(scale, 0) || CGRectIsNull(bounds)) {
        return CGPointZero;
    }

    CGFloat halfWidth = CGRectGetWidth(bounds) / 2;
    CGFloat halfHeight = CGRectGetHeight(bounds) / 2;
    CGPoint origin = CGPointMake(center.x - halfWidth, center.y - halfHeight);
    origin = GTUIPointRoundWithScale(origin, scale);
    return CGPointMake(origin.x + halfWidth, origin.y + halfHeight);
}
