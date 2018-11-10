//
//  GTFImageCalculations.m
//  GTFTextAccessibility
//
//  Created by liuxc on 2018/8/20.
//

#import "GTFImageCalculations.h"

UIColor *GTFAverageColorOfOpaqueImage(UIImage *image, CGRect region) {
    CGImageRef imageRef = image.CGImage;
    CGImageRef cropped = CGImageCreateWithImageInRect(imageRef, region);

    // Empty/null regions will cause cropped to be nil.
    if (!cropped) {
        return nil;
    }

    UIGraphicsBeginImageContext(CGSizeMake(1, 1));

    uint8_t argb[4];
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context =
    CGBitmapContextCreate(argb,  // data
                          1,     // width
                          1,     // height
                          8,     // Bits per component
                          4,     // Bytes per row
                          colorspace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorspace);
    CGContextSetInterpolationQuality(context, kCGInterpolationMedium);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), cropped);
    CGContextRelease(context);
    CGImageRelease(cropped);

    CGFloat alpha = argb[0] / (CGFloat)255;
    CGFloat scale = alpha > 0 ? 1 / (alpha * 255) : 0;
    UIColor *color =
    [UIColor colorWithRed:scale * argb[1] green:scale * argb[2] blue:scale * argb[3] alpha:alpha];
    UIGraphicsEndImageContext();
    return color;
}

