//
//  GTFColorCalculations.h
//  GTFTextAccessibility
//
//  Created by liuxc on 2018/8/20.
//

#import <UIKit/UIKit.h>

#if defined(__cplusplus)
extern "C" {
#endif

/**
 Copies the RGBA components of color, expanding greyscale colors out to RGBA if necessary.

 @param color The color to extract the components from.
 @param rgbaComponents A pointer to four CGFloat values.
 */
void GTFCopyRGBAComponents(CGColorRef color, CGFloat *rgbaComponents);

/**
 Returns the contrast ratio of a foreground color blended on top of a background color.

 @param foregroundColorComponents A pointer to four RGBA CGFloats of the foreground color.
 @param backgroundColorComponents A pointer to four RGBA CGFloats of the background color.
 @return The contrast ratio of the two colors after blending.
 */
CGFloat GTFContrastRatioOfRGBAComponents(const CGFloat *foregroundColorComponents,
                                         const CGFloat *backgroundColorComponents);

/**
 Calculates the relative luminance of a sRGB color from its components (ignores alpha).
 @see http://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef

 @param components A pointer to three RGB CGFloat values of the color.
 @return The relative luminance of the color.
 */
CGFloat GTFRelativeLuminanceOfRGBComponents(const CGFloat *components);

/**
 Calculates the minimum alpha that a foreground color can have such that, when it's blended on top
 of an opaque background color, the resulting contrast ratio is higher than a minimum contrast
 ratio.

 If there is no such acceptable contrast ratio, then -1 is returned. This is the case when even a
 completely opaque foreground color can't produce a high enough contrast ratio. For example, light
 grey on white will have a low contrast ratio for any alpha value assigned to the light grey.

 @param color The foreground color (alpha ignored).
 @param backgroundColor The background color (assumed to be opaque).
 @param minContrastRatio The minimum allowable contrast ratio.
 @return The minimum acceptable alpha of the foreground color, or -1 if no such alpha exists.
 */
CGFloat GTFMinAlphaOfColorOnBackgroundColor(UIColor *color,
                                            UIColor *backgroundColor,
                                            CGFloat minContrastRatio);

#if defined __cplusplus
}  // extern "C"
#endif

