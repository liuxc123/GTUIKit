//
//  GTUITabBarTextTransform.h
//  Pods
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>

/** Appearance for content within tab bar items. */
typedef NS_ENUM(NSInteger, GTUITabBarTextTransform) {
    /** The default text transform is applied based on the bar's position. */
    GTUITabBarTextTransformAutomatic = 0,

    /** Text on tabs is displayed verbatim with no transform. */
    GTUITabBarTextTransformNone = 1,

    /** Text on tabs is uppercased for display. */
    GTUITabBarTextTransformUppercase = 2,
};
