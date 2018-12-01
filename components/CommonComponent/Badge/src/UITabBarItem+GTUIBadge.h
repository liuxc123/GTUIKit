//
//  UITabBarItem+GTUIBadge.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import <UIKit/UIKit.h>
#import "UIView+GTUIBadge.h"
#import "GTUIBadgeProtocol.h"

@interface UITabBarItem (GTUIBadge) <GTUIBadgeProtocol>

/**
 *  show badge with red dot style and GTUIBadgeAnimTypeNone by default.
 */
- (void)showBadge;

/**
 *  showBadge
 *
 *  @param style GTUIBadgeStyle type
 *  @param value (if 'style' is GTUIBadgeStyleRedDot or GTUIBadgeStyleNew,
 this value will be ignored. In this case, any value will be ok.)
 *   @param aniType GTUIBadgeAnimType
 */
- (void)showBadgeWithStyle:(GTUIBadgeStyle)style
                     value:(NSInteger)value
             animationType:(GTUIBadgeAnimType)aniType;


/**
 *  clear badge(hide badge)
 */
- (void)clearBadge;

/**
 *  make bage(if existing) not hiden
 */
- (void)resumeBadge;

@end
