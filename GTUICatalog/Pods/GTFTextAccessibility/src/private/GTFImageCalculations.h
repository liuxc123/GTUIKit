//
//  GTFImageCalculations.h
//  GTFTextAccessibility
//
//  Created by liuxc on 2018/8/20.
//

#import <UIKit/UIKit.h>

#if defined(__cplusplus)
extern "C" {
#endif

    /**
     Return the average color of an image in a particular region.

     The region will be intersected with the image's bounds. If the resulting region is empty (or the
     input region was null) then this function returns nil.

     @param image The image to examine.
     @param region The region of the image to average, or CGRectInfinite for the entire image.
     @return The average color, or nil if the region was invalid.
     */
    UIColor *GTFAverageColorOfOpaqueImage(UIImage *image, CGRect region);

#if defined __cplusplus
}  // extern "C"
#endif
