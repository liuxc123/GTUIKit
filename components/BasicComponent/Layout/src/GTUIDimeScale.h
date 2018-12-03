//
//  GTUIDimeScale.h
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *一个用于计算位置和尺寸在不同设备屏幕下缩放比例的辅助类，用于实现不同大小设备屏幕之间的位置和尺寸的适配。
 *比如某个视图的宽度在iPhone6下是100，那么在iPhone6+上大概应该是110，而在iPhone5下则大概应该是85。
 */
@interface GTUIDimeScale : NSObject

/**
 *指定UI设计原型图所用的设备尺寸。请在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法的开始处调用这个方法，比如当UI设计人员用iPhone6作为界面的原型尺寸则将size设置为375,667。
 */
+(void)setUITemplateSize:(CGSize)size;

/**
 *返回屏幕尺寸缩放的比例
 */
+(CGFloat)scale:(CGFloat)val;

/**
 *返回屏幕宽度缩放的比例
 */
+(CGFloat)scaleW:(CGFloat)val;

/**
 *返回屏幕高度缩放的比例
 */
+(CGFloat)scaleH:(CGFloat)val;

/**
 *根据屏幕清晰度将带小数的入参返回能转化为有效物理像素的最接近的设备点值。
 *比如当入参为1.3时，那么在1倍屏幕下的有效值就是1,而在2倍屏幕下的有效值就是1.5,而在3倍屏幕下的有效值就是1.3333333了
 */
+(CGFloat)roundNumber:(CGFloat)number;

/**
 *根据屏幕清晰度将带小数的point入参返回能转化为有效物理像素的最接近的设备point点值。
 */
+(CGPoint)roundPoint:(CGPoint)point;


/**
 *根据屏幕清晰度将带小数的size入参返回能转化为有效物理像素的最接近的设备size点值。
 */
+(CGSize)roundSize:(CGSize)size;

/**
 *根据屏幕清晰度将带小数的rect入参返回能转化为有效物理像素的最接近的设备rect点值。
 */
+(CGRect)roundRect:(CGRect)rect;



@end


#define GTUIDIMESCALE(val)   ([GTUIDimeScale scale:val])
#define GTUIDIMESCALEW(val)  ([GTUIDimeScale scaleW:val])
#define GTUIDIMESCALEH(val)  ([GTUIDimeScale scaleH:val])


