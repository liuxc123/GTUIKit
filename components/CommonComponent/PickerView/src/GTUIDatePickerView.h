//
//  GTUIDatePickView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "GTUIBasePickerView.h"

typedef enum : NSUInteger {
    // 以下四个为系统自带样式,不能修改文字颜色和背景颜色
    GTUIDatePickerModeTime,           // UIDatePickerModeTime             HH:mm
    GTUIDatePickerModeDate,           // UIDatePickerModeDate             yyyy-MM-dd
    GTUIDatePickerModeDateAndTime,    // UIDatePickerModeDateAndTime      yyyy-MM-dd HH:mm
    GTUIDatePickerModeCountDownTimer, // UIDatePickerModeCountDownTimer   HH:mm

    // 以下是自定义样式,可以修改文本颜色,背景颜色,行高等
    GTUIDatePickerModeYMDHM,      // 年月日时分    yyyy-MM-dd HH:mm
    GTUIDatePickerModeMDHM,       // 月日时分      MM-dd HH:mm
    GTUIDatePickerModeYMD,        // 年月日        yyyy-MM-dd
    GTUIDatePickerModeYM,         // 年月         yyyy-MM
    GTUIDatePickerModeY,          // 年           yyyy
    GTUIDatePickerModeMD,         // 月日          MM-dd
    GTUIDatePickerModeHM          // 时分          HH:mm
} GTUIDatePickerMode;

typedef void(^GTUIDateResultBlock)(NSString *selectValue);
typedef void(^GTUIDateCancelBlock)(void);

@interface GTUIDatePickerView : GTUIBasePickerView

/**
 1.显示时间选择器

 @param title    标题
 @param dateType pickerView显示类型,
 @param defaultSelValue 默认值
 @param resultBlock 确认回调
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                       resultBlock:(GTUIDateResultBlock)resultBlock;
/**
 2.显示时间选择器（支持 设置自动选择、取消选择的回调）

 @param title    标题
 @param dateType pickerView显示类型,
 @param defaultSelValue 默认值
 @param isAutoSelect 是否自动选择
 @param resultBlock 确认回调
 @param cancelBlock 取消回调
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                      isAutoSelect:(BOOL)isAutoSelect
                       resultBlock:(GTUIDateResultBlock)resultBlock
                       cancelBlock:(GTUIDateCancelBlock)cancelBlock;


/**
 3.显示时间选择器（支持 设置自动选择、最大值、最小值、取消选择的回调）

 @param title    标题
 @param dateType pickerView显示类型,
 @param defaultSelValue 默认值
 @param minDate 时间最小值
 @param maxDate 时间最大值
 @param isAutoSelect 是否自动选择
 @param resultBlock 确认回调
 @param cancelBlock 取消回调
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                           minDate:(NSDate *)minDate
                           maxDate:(NSDate *)maxDate
                      isAutoSelect:(BOOL)isAutoSelect
                       resultBlock:(GTUIDateResultBlock)resultBlock
                       cancelBlock:(GTUIDateCancelBlock)cancelBlock;

/**
 4.显示时间选择器（支持 设置自动选择、最大值、最小值、自定义分割线颜色、行高、取消选择的回调）

 @param title    标题
 @param dateType pickerView显示类型,
 @param defaultSelValue 默认值
 @param minDate 时间最小值
 @param maxDate 时间最大值
 @param isAutoSelect 是否自动选择
 @param lineColor 分割线的颜色,默认为灰色
 @param rowHeight 行高
 @param resultBlock 确认回调
 @param cancelBlock 取消回调
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                           minDate:(NSDate *)minDate
                           maxDate:(NSDate *)maxDate
                      isAutoSelect:(BOOL)isAutoSelect
                         lineColor:(UIColor *)lineColor
                         rowHeight:(CGFloat)rowHeight
                       resultBlock:(GTUIDateResultBlock)resultBlock
                       cancelBlock:(GTUIDateCancelBlock)cancelBlock;

/**
 5.显示时间选择器（支持 设置自动选择、最大值、最小值、自定义分割线颜色、行高、按钮的文本颜色、取消选择的回调）

 @param title    标题
 @param dateType pickerView显示类型,
 @param defaultSelValue 默认值
 @param minDate 时间最小值
 @param maxDate 时间最大值
 @param isAutoSelect 是否自动选择
 @param lineColor 分割线的颜色,默认为灰色
 @param rowHeight 行高
 @param leftBtnTitleColor 左边的按钮颜色
 @param rightBtnTitleColor 右边的按钮颜色
 @param resultBlock 确认回调
 @param cancelBlock 取消回调
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                           minDate:(NSDate *)minDate
                           maxDate:(NSDate *)maxDate
                      isAutoSelect:(BOOL)isAutoSelect
                         lineColor:(UIColor *)lineColor
                         rowHeight:(CGFloat)rowHeight
                 leftBtnTitleColor:(UIColor *)leftBtnTitleColor
                rightBtnTitleColor:(UIColor *)rightBtnTitleColor
                       resultBlock:(GTUIDateResultBlock)resultBlock
                       cancelBlock:(GTUIDateCancelBlock)cancelBlock;


/**
 6.显示时间选择器（支持 设置自动选择、最大值、最小值、自定义分割线颜色、选中文本行颜色、行高、按钮的颜色、取消选择的回调）

 @param title    标题
 @param dateType pickerView显示类型,
 @param defaultSelValue 默认值
 @param minDate 时间最小值
 @param maxDate 时间最大值
 @param isAutoSelect 是否自动选择
 @param lineColor 分割线的颜色,默认为灰色
 @param rowHeight 行高
 @param leftBtnTitleColor 左边的按钮颜色
 @param rightBtnTitleColor 右边的按钮颜色
 @param resultBlock 确认回调
 @param cancelBlock 取消回调
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                           minDate:(NSDate *)minDate
                           maxDate:(NSDate *)maxDate
                      isAutoSelect:(BOOL)isAutoSelect
                         lineColor:(UIColor *)lineColor
                         rowHeight:(CGFloat)rowHeight
                 leftBtnTitleColor:(UIColor *)leftBtnTitleColor
                rightBtnTitleColor:(UIColor *)rightBtnTitleColor
               selecteRowTextColor:(UIColor *)selecteRowTextColor
                  selectRowBGColor:(UIColor *)selectRowBGColor
                       resultBlock:(GTUIDateResultBlock)resultBlock
                       cancelBlock:(GTUIDateCancelBlock)cancelBlock;

@end
