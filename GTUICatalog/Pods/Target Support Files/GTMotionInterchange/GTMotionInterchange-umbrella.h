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

#import "CAMediaTimingFunction+GTMTimingCurve.h"
#import "GTMAnimationTraits.h"
#import "GTMMotionCurve.h"
#import "GTMMotionRepetition.h"
#import "GTMMotionTiming.h"
#import "GTMotionInterchange.h"
#import "GTMRepetition.h"
#import "GTMRepetitionOverTime.h"
#import "GTMRepetitionTraits.h"
#import "GTMSpringTimingCurve.h"
#import "GTMSpringTimingCurveGenerator.h"
#import "GTMSubclassingRestricted.h"
#import "GTMTimingCurve.h"

FOUNDATION_EXPORT double GTMotionInterchangeVersionNumber;
FOUNDATION_EXPORT const unsigned char GTMotionInterchangeVersionString[];

