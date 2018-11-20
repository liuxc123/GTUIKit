//
//  GTUITabBarIndicatorContext.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>

/** Information about the context in which a tab bar indicator will be displayed. */
@protocol GTUITabBarIndicatorContext <NSObject>

/** The tab bar item for the indicated tab. */
@property(nonatomic, readonly, nonnull) UITabBarItem *item;

/**
 The full bounds of the tab's view.

 Any paths should be created relative to this coordinate space.
 */
@property(nonatomic, readonly) CGRect bounds;

/**
 The frame for the tab's primary content in its coordinate space.

 For title-only tabs, this is the frame of the title text.
 For image-only tabs, this is the frame of the primary image.
 For title-and-image tabs, it is the union of the title and primary image's frames.
 */
@property(nonatomic, readonly) CGRect contentFrame;

@end

