//
//  GTUITabBarItemAppearance.h
//  Pods
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>

/** Appearance for content within tab bar items. */
typedef NS_ENUM(NSInteger, GTUITabBarItemAppearance) {
    /** Tabs are shown as titles. Badges are not supported for this appearance. */
    GTUITabBarItemAppearanceTitles,

    /** Tabs are shown as images. */
    GTUITabBarItemAppearanceImages,

    /** Tabs are shown as images with titles underneath. */
    GTUITabBarItemAppearanceTitledImages,
};

