//
//  NSLocale+GTRTL.m
//  Pods-GTFInternationalization_Example
//
//  Created by liuxc on 2018/8/20.
//

#import "NSLocale+GTRTL.h"

@implementation NSLocale (GTRTL)

+ (BOOL)gtf_isDefaultLanguageLTR {
    NSString *languageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    NSLocaleLanguageDirection characterDirection =
    [NSLocale characterDirectionForLanguage:languageCode];
    BOOL localeLanguageDirectionIsLTR = (characterDirection == NSLocaleLanguageDirectionLeftToRight);
    return localeLanguageDirectionIsLTR;
}

+ (BOOL)gtf_isDefaultLanguageRTL {
    NSString *languageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    NSLocaleLanguageDirection characterDirection =
    [NSLocale characterDirectionForLanguage:languageCode];
    BOOL localeLanguageDirectionIsRTL = (characterDirection == NSLocaleLanguageDirectionRightToLeft);
    return localeLanguageDirectionIsRTL;
}

@end
