//
//  UIView+GTUIBadge.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import <UIKit/UIKit.h>
#import "GTUIBadgeProtocol.h"

@interface UIView (GTUIBadge) <GTUIBadgeProtocol>


/**
 *  显示角标 默认原点类型 GTUIBadgeStyleRedDot
 */
- (void)showBadge;

/**
 *  显示角标
 *
 *  @param style 角标显示类型
 *  @param value  (if 'style' is GTUIBadgeStyleRedDot or GTUIBadgeStyleNew,
 this value will be ignored. In this case, any value will be ok.)
 *   @param aniType GTUIBadgeAnimType
 */
- (void)showBadgeWithStyle:(GTUIBadgeStyle)style
                     value:(NSInteger)value
             animationType:(GTUIBadgeAnimType)aniType;

/*
 GTUIBadgeStyle default is GTUIBadgeStyleNumber
 默认是 GTUIBadgeStyleNumber 类型
 */
- (void)showNumberBadgeWithValue:(NSInteger)value
                   animationType:(GTUIBadgeAnimType)aniType;

// GTUIBadgeStyle default is GTUIBadgeStyleNumber ;
// GTUIBadgeAnimType defualt is  GTUIBadgeAnimTypeNone
- (void)showNumberBadgeWithValue:(NSInteger)value;

/**
 *  clear badge(hide badge)
 */
- (void)clearBadge;

/**
 *  make bage(if existing) not hiden
 */
- (void)resumeBadge;

@end
