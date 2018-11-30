//
//  GTUIToast+GTUIKit.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/29.
//

#import "GTUIToast.h"

static const NSTimeInterval GTUIToast_Default_Duration     = 2.0f;     // GTUIToast 默认展示时间
static const NSTimeInterval GTUIToast_Strong_Duration      = 1.5f;     // GTUIToast 强提示展示时长
static const NSTimeInterval GTUIToast_Weak_Duration        = 1.0f;     // GTUIToast 弱提示展示时长

typedef void (^GTUIToastCompletionBlock)(void);

/**
 *  添加新的 toastIcon 时，请向后添加，不要在中间插入，否则业务使用会有问题
 */
typedef NS_ENUM(NSUInteger, GTUIToastIcon) {
    GTUIToastIconNone = 0,    // 无图标
    GTUIToastIconSuccess,     // 成功图标
    GTUIToastIconFailure,     // 失败图标
    GTUIToastIconLoading,     // 加载图标
    GTUIToastIconNetFailure,  // 网络失败
    GTUIToastIconSecurityScan,// 安全扫描
    GTUIToastIconNetError,    // 网络错误，完全无法连接
    GTUIToastIconProgress,    // 加载图标，显示加载进度
    GTUIToastIconAlert,       // 警示图标
};

@interface GTUIToast (GTUIKit)


@property (nonatomic, assign) CGFloat xOffset; // 设置相对父视图中心位置 X 轴方向的偏移量
@property (nonatomic, assign) CGFloat yOffset; // 设置相对父视图中心位置 Y 轴方向的偏移量


/**
 模态显示提示，此时屏幕不响应用户操作（显示在 keywindow 上面），
 需调用 dismissToast 方法使 Toast 消失

 @param text 显示文本，默认为 loading 加载
 @return 返回显示的 Toast 对象
 */
+ (GTUIToast *)presentToastWithText:(NSString *)text;


/**
 显示 Toast，需调用 dismissToast 方法使 Toast 消失

 @param superview 父视图
 @param text 显示文本
 @return 返回显示的 Toast 对象
 */
+ (GTUIToast *)presentToastWithIn:(UIView *)superview
                             text:(NSString *)text;



/**
 显示 Toast，需调用 dismissToast 方法使 Toast 消失

 @param superview 父视图
 @param icon 图标类型
 @param text  显示文本
 @return 返回显示的 Toast 对象
 */
+ (GTUIToast *)presentToastWithin:(UIView *)superview
                         withIcon:(GTUIToastIcon)icon
                             text:(NSString *)text;


/**
 显示 Toast

 @param superview superview 父视图
 @param icon  图标类型
 @param text 显示文本
 @param duration 显示时长
 @return 返回显示的 Toast 对象
 */
+ (GTUIToast *)presentToastWithin:(UIView *)superview
                         withIcon:(GTUIToastIcon)icon
                             text:(NSString *)text
                         duration:(NSTimeInterval)duration;



/**
 显示 Toast

 @param superview superview 父视图
 @param icon  图标类型
 @param text 显示文本
 @param duration 显示时长
 @return 返回显示的 Toast 对象
 @param completion Toast 自动消失后的回调
 @return 返回显示的 Toast 对象
 */
+ (GTUIToast *)presentToastWithin:(UIView *)superview
                         withIcon:(GTUIToastIcon)icon
                             text:(NSString *)text
                         duration:(NSTimeInterval)duration
                       completion:(void(^)(void))completion;


/**
 显示 Toast

 @param superview superview 父视图
 @param icon  图标类型
 @param text 显示文本
 @param duration 显示时长
 @param delay 延迟显示时长
 @return 返回显示的 Toast 对象
 @param completion Toast 自动消失后的回调
 @return 返回显示的 Toast 对象
 */
+ (GTUIToast *)presentToastWithin:(UIView *)superview
                         withIcon:(GTUIToastIcon)icon
                             text:(NSString *)text
                         duration:(NSTimeInterval)duration
                            delay:(NSTimeInterval)delay
                       completion:(void(^)(void))completion;



/**
 * 模态 toast，需调用 dismissToast 方法使 Toast 消失
 * 跟普通的 toast 区别是，会添加一个透明的背景层，防止用户屏幕点击

 @param superview superview 父视图
 @param text 显示文本
 @return 返回显示的 Toast 对象
 */
+ (GTUIToast *)presentModelToastWithin:(UIView *)superview
                                  text:(NSString *)text;



/**
 * 显示模态 Toast
 * 跟普通的 toast 区别是，会添加一个透明的背景层，防止用户屏幕点击

 @param superview 要在其中显示 Toast 的视图
 @param icon 图标类型
 @param text 显示文本
 @param duration 显示时长
 @param completion Toast 自动消失后的回调
 @return 返回显示的 Toast 对象
 */
+ (GTUIToast *)presentModelToastWithin:(UIView *)superview
                              withIcon:(GTUIToastIcon)icon
                                  text:(NSString *)text
                              duration:(NSTimeInterval)duration
                            completion:(void(^)(void))completion;


/**
 * 显示模态 Toast
 * 跟普通的 toast 区别是，会添加一个透明的背景层，防止用户屏幕点击

 @param superview 要在其中显示 Toast 的视图
 @param icon 图标类型
 @param text 显示文本
 @param duration 显示时长
 @param delay 延迟显示时长
 @param completion Toast 自动消失后的回调
 @return 返回显示的 Toast 对象
 */
+ (GTUIToast *)presentModelToastWithin:(UIView *)superview
                              withIcon:(GTUIToastIcon)icon
                                  text:(NSString *)text
                              duration:(NSTimeInterval)duration
                                 delay:(NSTimeInterval)delay
                            completion:(void(^)(void))completion;

/*
 * 使 toast 消失
 */
- (void)dismissToast;

/**
 使 View上的所有toast 消失
 */
+ (void)dismissAllToastWithView:(UIView *)view;


/**
  使 所有View上的toast 消失
 */
+ (void)dismissAllToast;

/**
 *  设置进度的前缀文本，如果不设置，默认为“加载数据”
 *  当 toast 类型为 GTUIToastIconProgress 时设置有效，否则忽略
 *
 *  @param prefix 文本
 */
- (void)setProgressPrefix:(NSString*)prefix;


/**
 * 显示当前加载数据的进度百分比
 * 当 toast 类型为 GTToastIconProgress 时设置有效，否则忽略
 *
 * @param value      当前已加载的数据，范围为<0.0，1.0>
 *
 */
- (void)setProgressText:(float)value;


@end
