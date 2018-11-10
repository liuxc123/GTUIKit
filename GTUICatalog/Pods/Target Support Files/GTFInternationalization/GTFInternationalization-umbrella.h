#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GTFInternationalization.h"
#import "GTFRTL.h"
#import "NSLocale+GTRTL.h"
#import "NSString+GTBidi.h"
#import "UIImage+GTRTL.h"
#import "UIView+GTRTL.h"

FOUNDATION_EXPORT double GTFInternationalizationVersionNumber;
FOUNDATION_EXPORT const unsigned char GTFInternationalizationVersionString[];

