//
//  GTUIPickerView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "GTUIBasePickerView.h"

@interface GTUIPickerView : GTUIBasePickerView

typedef void(^GTUIResultBlock)(id selectValue , NSInteger index);

typedef void(^GTUICancelBlock)(void);

/**
 1.显示自定义字符串选择器,支持title,默认选择,选择回调

 @param title 标题
 @param dataSource 数据源
 @param defaultSelValue 默认选中的值
 @param resultBlock 确认返回回调
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                      resultBlock:(GTUIResultBlock)resultBlock;

/**

 2.显示自定义字符串选择器,设置自动选择、默认值、取消选择的回调

 @param title 标题
 @param dataSource 数据源
 @param defaultSelValue 默认选中的值
 @param isAutoSelect 是否自动选择
 @param resultBlock 确认返回回调
 @param cancelBlock 取消返回回调
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                      resultBlock:(GTUIResultBlock)resultBlock
                      cancelBlock:(GTUICancelBlock)cancelBlock;

/**

 3.显示自定义字符串选择器,设置自动选择、默认值、取消选择的回调,分割线颜色,行高

 @param title 标题
 @param dataSource 数据源
 @param defaultSelValue 默认选中的值
 @param isAutoSelect 是否自动选择
 @param rowHeight 行高度
 @param lineColor 分割线颜色
 @param resultBlock 确认返回回调
 @param cancelBlock 取消返回回调
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                        rowHeight:(CGFloat)rowHeight
                        lineColor:(UIColor *)lineColor
                      resultBlock:(GTUIResultBlock)resultBlock
                      cancelBlock:(GTUICancelBlock)cancelBlock;

/**

 4.显示自定义字符串选择器,设置自动选择、默认值、取消选择的回调,分割线颜色,行高,按钮颜色

 @param title 标题
 @param dataSource 数据源
 @param defaultSelValue 默认选中的值
 @param isAutoSelect 是否自动选择
 @param rowHeight 行高度
 @param lineColor 分割线颜色
 @param confirmBtnTitleColor 确认按钮的颜色
 @param cancelBtnTitleColor 取消按钮的文不颜色
 @param resultBlock 确认返回回调
 @param cancelBlock 取消返回回调
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                        rowHeight:(CGFloat)rowHeight
                        lineColor:(UIColor *)lineColor
             confirmBtnTitleColor:(UIColor *)confirmBtnTitleColor
              cancelBtnTitleColor:(UIColor *)cancelBtnTitleColor
                      resultBlock:(GTUIResultBlock)resultBlock
                      cancelBlock:(GTUICancelBlock)cancelBlock;

/**

 5.显示自定义字符串选择器,设置自动选择、默认值、取消选择的回调,分割线颜色,行高,按钮颜色,选中行背景文本颜色,左右按钮文字

 @param title 标题
 @param dataSource 数据源
 @param defaultSelValue 默认选中的值
 @param isAutoSelect 是否自动选择
 @param rowHeight 行高度
 @param lineColor 分割线颜色
 @param confirmBtnTitleColor 确认按钮的颜色
 @param cancelBtnTitleColor 取消按钮的文不颜色
 @param selecteRowTextColor 选中行文本颜色
 @param selectRowBGColor 选中行背景颜色
 @param leftBtnTitle leftBtnTitle
 @param rightBtnTitle rightBtnTitle
 @param resultBlock 确认返回回调
 @param cancelBlock 取消返回回调
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                        rowHeight:(CGFloat)rowHeight
                        lineColor:(UIColor *)lineColor
             confirmBtnTitleColor:(UIColor *)confirmBtnTitleColor
              cancelBtnTitleColor:(UIColor *)cancelBtnTitleColor
              selecteRowTextColor:(UIColor *)selecteRowTextColor
                 selectRowBGColor:(UIColor *)selectRowBGColor
                     leftBtnTitle:(NSString *)leftBtnTitle
                    rightBtnTitle:(NSString *)rightBtnTitle
                      resultBlock:(GTUIResultBlock)resultBlock
                      cancelBlock:(GTUICancelBlock)cancelBlock;

@end
