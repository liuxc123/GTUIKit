//
//  GTUIDoubleTitleView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import <UIKit/UIKit.h>

/**
 包含两行的导航栏 titleView
 */
@interface GTUIDoubleTitleView : UIView

/**
 *  创建上下两个标题的 titleView
 *
 *  @param title          主标题
 *  @param detaileTitle   副标题
 *
 *  @return 初始化后的 APTitleView 控件
 */
- (UIView *)initWithTitle:(NSString *)title detailTitle:(NSString *)detaileTitle;
/**
 *  修改主标题的文案。
 *
 *  @param title          主标题文案
 *
 */
- (void)updateTitle:(NSString *)title;
/**
 *  修改主标题的文案。
 *
 *  @param detailTitle          主标题文案
 *
 */
- (void)updateDetailTitle:(NSString *)detailTitle;
/**
 修改主标题的 font
 @param titleFont 主标题 font
 */
- (void)updateTitleFont:(UIFont *)titleFont;
/**
 *  修改主标题的 font
 *
 *  @param detailTitleFont      主标题 font
 *
 */
- (void)updateDetailTitleFont:(UIFont *)detailTitleFont;

@end
