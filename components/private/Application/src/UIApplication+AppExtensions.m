//
//  UIApplication+AppExtensions.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "UIApplication+AppExtensions.h"

@implementation UIApplication (AppExtensions)

+ (UIApplication *)gtui_safeSharedApplication {
    static UIApplication *application;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![self gtui_isAppExtension]) {
            // We can't call sharedApplication directly or else this won't build for app extensions.
            application = [[UIApplication class] performSelector:@selector(sharedApplication)];
        }
    });
    return application;
}

+ (BOOL)gtui_isAppExtension {
    static BOOL isAppExtension;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isAppExtension =
        [[[NSBundle mainBundle] executablePath] rangeOfString:@".appex/"].location != NSNotFound;
    });
    return isAppExtension;
}

@end
