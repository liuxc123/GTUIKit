//
//  GTUINetErrorView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//
//  定制的异常页面

#import "GTUIEmptyView.h"

typedef NS_ENUM(NSUInteger, GTUINetErrorType) {
    GTUINetErrorTypeLimit,          // 限流
    GTUINetErrorTypeAlert,          // 系统繁忙（系统错误）、警示
    GTUINetErrorTypeNetworkError,   // 网络不给力
    GTUINetErrorTypeEmpty,          // 内容为空
    GTUINetErrorTypeNotFound,       // 404 找不到（与 AUNetErrorTypeAlert 图片相同）
    GTUINetErrorTypeUserLogout      // 用户已注销
};


typedef NS_ENUM(NSUInteger, GTUINetErrorStyle) {
    GTUINetErrorStyleMiniimalist    //简单版
};

@interface GTUINetErrorView : GTUIEmptyView


/**
 初始化异常视图 （target 和 action 为空时，刷新按钮不显示）

 @param style 异常的风格，插画版 or 极简版，必选
 @param type 异常类型，必选
 @return 返回 GTUINetErrorView对象
 */
+ (instancetype)netErrorViewWithStyle:(GTUINetErrorStyle)style
                                 type:(GTUINetErrorType)type;


/**
 初始化异常视图 （target 和 action 为空时，刷新按钮不显示）

 @param style 异常的风格，插画版 or 极简版，必选
 @param type 异常类型，必选
 @param target 刷新事件处理对象
 @param action 刷新事件处理方法
 @return 返回 GTUINetErrorView对象
 */
+ (instancetype)netErrorViewWithStyle:(GTUINetErrorStyle)style
                                 type:(GTUINetErrorType)type
                               target:(id)target
                               action:(SEL)action;

@end
