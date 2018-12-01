//
//  GTUIOverlayWindow.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import <UIKit/UIKit.h>


/**
 子类UIWindow允许覆盖所有内容。

 覆盖将是整个屏幕的大小，或者当多任务处理使用所有可用的屏幕空间时，
 并将根据设备的方向进行适当的旋转。为了性能，覆盖的所有者
 当覆盖层不使用时，视图应该将@c隐藏属性设置为YES。
 */
@interface GTUIOverlayWindow : UIWindow


/**
 通知窗口应该显示给定的叠加视图。

 覆盖的所有者必须调用此方法，以确保覆盖实际显示在窗口的主要内容。

 @param overlay The overlay being displayed.
 @param level The UIWindowLevel to display the overlay on.
 */
- (void)activateOverlay:(UIView *)overlay withLevel:(UIWindowLevel)level;



/**
 通知窗口给定的叠加层不再活动。

 覆盖的拥有者应该在调用这个方法之前仍然隐藏他们的覆盖。

 @param overlay The overlay being displayed.
 */
- (void)deactivateOverlay:(UIView *)overlay;


@end
