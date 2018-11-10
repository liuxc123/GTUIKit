//
//  NSLocale+GTRTL.h
//  Pods-GTFInternationalization_Example
//
//  Created by liuxc on 2018/8/20.
//

#import <Foundation/Foundation.h>

@interface NSLocale (GTRTL)

/**
 Is the direction of the current locale's default language Left-To-Right?

 @return YES if the language is LTR, NO if the language is any other direction.
 */
+ (BOOL)gtf_isDefaultLanguageLTR;

/**
 Is the direction of the current locale's default language Right-To-Left?

 @return YES if the language is RTL, NO if the language is any other direction.
 */
+ (BOOL)gtf_isDefaultLanguageRTL;

@end
