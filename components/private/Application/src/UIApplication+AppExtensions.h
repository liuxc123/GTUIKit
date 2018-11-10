//
//  UIApplication+AppExtensions.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import <UIKit/UIKit.h>

@interface UIApplication (AppExtensions)

/**
 返回 sharedApplication if it is available otherwise returns nil.

 @return This is a wrapper around sharedApplication which is safe to compile and use in app extensions.
 */
+ (UIApplication *)gtui_safeSharedApplication;



/**
 @return Returns YES if called inside an application extension otherwise returns NO.
 */
+ (BOOL)gtui_isAppExtension;

@end
