//
//  UIImage+GTRTL.h
//  Pods-GTFInternationalization_Example
//
//  Created by liuxc on 2018/8/20.
//

#import <UIKit/UIKit.h>

/**
 Backporting of iOS 10's [UIImage imageWithHorizontallyFlippedOrientation].
 */

@interface UIImage (GTRTL)

/**
 On iOS 10 and above, calls [UIImage imageWithHorizontallyFlippedOrientation].
 Otherwise manually flips the image and returns the result.

 @return A horizontally mirrored version of this image.
 */
- (nonnull UIImage *)gtf_imageWithHorizontallyFlippedOrientation;

@end
