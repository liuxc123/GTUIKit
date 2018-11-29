//
//  GTUIDialog.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/26.
//

#import <UIKit/UIKit.h>

/**
 GTUIDialog类型
 - GTUIDialogTypeAlert: Alert提示框
 - GTUIDialogTypeActionSheet: ActionSheet底部提示框
 */
typedef NS_ENUM(NSUInteger, GTUIDialogType) {
    GTUIDialogTypeAlert,
    GTUIDialogTypeActionSheet
};

/**
 GTUIDialog样式

 - GTUIDialogStyleNormal: 默认样式 类似于微信
 - GTUIDialogStyleUIKit: iOS系统默认样式
 - GTUIDialogStyleMaterial: Material样式
 */
typedef NS_ENUM(NSUInteger, GTUIDialogStyle) {
    /**  GTUIActionSheet样式 默认样式 类似于微信 */
    GTUIDialogStyleNormal,
    /**  GTUIActionSheet样式 默认样式 iOS系统默认样式 */
    GTUIDialogStyleUIKit,
    /**  GTUIActionSheet样式 默认样式 Material样式 */
    GTUIDialogStyleMaterial
};

typedef NS_ENUM(NSInteger, GTUIItemType) {
    /** 标题 */
    GTUIItemTypeTitle,
    /** 内容 */
    GTUIItemTypeMessage,
    /** 输入框 */
    GTUIItemTypeTextField,
    /** 自定义视图 */
    GTUIItemTypeCustomView,
};

typedef NS_ENUM(NSInteger, GTUICustomViewPositionType) {
    /** 居中 */
    GTUICustomViewPositionTypeCenter,
    /** 靠左 */
    GTUICustomViewPositionTypeLeft,
    /** 靠右 */
    GTUICustomViewPositionTypeRight
};

typedef NS_ENUM(NSInteger, GTUIBackgroundStyle) {
    /** 背景样式 模糊 */
    GTUIBackgroundStyleBlur,
    /** 背景样式 半透明 */
    GTUIBackgroundStyleTranslucent,
};

typedef NS_ENUM(NSInteger, GTUIScreenOrientationType) {
    /** 屏幕方向类型 横屏 */
    GTUIScreenOrientationTypeHorizontal,
    /** 屏幕方向类型 竖屏 */
    GTUIScreenOrientationTypeVertical
};

typedef NS_ENUM(NSInteger, GTUIActionType) {
    /** 默认 */
    GTUIActionTypeDefault      = 1 << 0,
    /** 取消 */
    GTUIActionTypeCancel       = 1 << 1,
    /** 销毁 */
    GTUIActionTypeDestructive  = 1 << 2,
};


typedef NS_ENUM(NSInteger, GTUIActionImagePosition) {
    /** Action图片位置 左 */
    GTUIActionImagePositionLeft      = 1 << 0,
    /** Action图片位置 右 */
    GTUIActionImagePositionRight       = 1 << 1,
};


typedef NS_ENUM(NSInteger, GTUIActionLayout) {
    /** Action布局位置 左 */
    GTUIActionLayoutLeft      = 1 << 0,
    /** Action布局位置 中 */
    GTUIActionLayoutCenter       = 1 << 1,
};

typedef NS_ENUM(NSInteger, GTUIActionBorderPosition) {
    /** Action边框位置 上 */
    GTUIActionBorderPositionTop      = 1 << 0,
    /** Action边框位置 下 */
    GTUIActionBorderPositionBottom   = 1 << 1,
    /** Action边框位置 左 */
    GTUIActionBorderPositionLeft     = 1 << 2,
    /** Action边框位置 右 */
    GTUIActionBorderPositionRight    = 1 << 3
};


/** Dialog管理对象 */
@interface GTUIDialog : NSObject

+ (GTUIDialog *)shareManager;

/** 获取Alert窗口 */

+ (nonnull UIWindow *)getAlertWindow;

/** 获取Alert窗口 */

+ (nonnull UIWindow *)getMainWindow;

/** 设置主窗口 */

+ (void)configMainWindow:(UIWindow * _Nonnull)window;

/** 继续队列显示 */

+ (void)continueQueueDisplay;

/** 清空队列 */

+ (void)clearQueue;

@end

@protocol GTUIDialogProtocol <NSObject>

- (void)closeWithCompletionBlock:(void (^)(void))completionBlock;

@end


/**  ✨样式被配置 */
@interface GTUIDialogConfigModel : NSObject

/** 初始化配置 */
- (instancetype)initWithStyle:(GTUIDialogStyle)style;

/** ✨样式类型 */
@property (nonatomic , assign) GTUIDialogStyle dialogStyle;

/** ✨通用设置 */

/** ✨标题设置 */

/** 标题  */
@property (nonatomic, nullable, copy) NSString *title;

/** 标题颜色 */
@property (nonatomic, nullable, copy) UIColor *titleTextColor;

/** 标题字体 */
@property (nonatomic, nullable, copy) UIFont *titleFont;

/** 标题文本对齐方式 */
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;



/** ✨内容设置 */

/** 内容  */
@property (nonatomic, nullable, copy) NSString *message;

/** 内容颜色 */
@property (nonatomic, nullable, copy) UIColor *messageTextColor;

/** 内容字体 */
@property (nonatomic, nullable, copy) UIFont *messageFont;

/** 内容文本对齐方式 */
@property (nonatomic, assign) NSTextAlignment messageTextAlignment;


/** ✨自定义视图设置 */

/** 自定义视图位置  */
@property (nonatomic, assign) GTUICustomViewPositionType customViewPositionType;

/** ✨TextField输入框设置 */

@property (nonatomic, nullable, copy) NSString *textFieldPlaceHolder;

@property (nonatomic, nullable, copy) UIColor *textFieldTextColor;

@property (nonatomic, nullable, copy) UIFont *textFieldFont;


/** ✨Action 按钮设置 */

@property (nonatomic, nullable, copy) UIColor *defaultActionTextColor;

@property (nonatomic, nullable, copy) UIFont *defaultActionFont;

@property (nonatomic, nullable, copy) UIColor *cancelActionTextColor;

@property (nonatomic, nullable, copy) UIFont *cancelActionFont;

@property (nonatomic, nullable, copy) UIColor *destructiveActionTextColor;

@property (nonatomic, nullable, copy) UIFont *destructiveActionFont;

/** 设置 action 背景颜色 */
@property (nonatomic, nullable, copy) UIColor *actionBackgroundColor;


/** ✨Header设置 */

/** 设置 颜色 */
@property (nonatomic , copy) UIColor *headerColor;

/** 设置 头部内的间距 */
@property (nonatomic , assign) UIEdgeInsets headerInsets;


/** ✨内容设置 */

/** 设置 背景颜色 */
@property (nonatomic , copy) UIColor *backgroundColor;

/** 设置 透明度 */
@property (nonatomic, assign) GTUIBackgroundStyle backgroundStyle;

/** 模糊效果 */
@property (nonatomic, assign) UIBlurEffectStyle backgroundBlurEffectStyle;

/** 设置 墨水颜色 */
@property (nonatomic , copy) UIColor *inkColor;

/** 设置 最大宽度  */
@property (nonatomic, assign) CGFloat maxWidth;

/** 设置 最大高度 */
@property (nonatomic, assign) CGFloat maxHeight;

/** 设置 圆角半径 */
@property (nonatomic, assign) CGFloat cornerRadius;

/** 设置 开启动画时长 */
@property (nonatomic, assign) CGFloat animationDuration;

/** 设置 阴影颜色 */
@property (nonatomic , copy) UIColor *shadowColor;

/** 设置 阴影偏移 */
@property (nonatomic , assign) CGSize shadowOffset;

/** 设置 阴影不透明度 */
@property (nonatomic , assign) CGFloat shadowOpacity;

/** 设置 阴影半径 */
@property (nonatomic , assign) CGFloat shadowRadius;

/** 设置 点击背景消失 */
@property (nonatomic , assign) BOOL dismissOnBackgroundTap;

/** 设置 是否加入到队列 */
@property (nonatomic , assign) BOOL isQueue;

/** 设置 优先级 */
@property (nonatomic , assign) NSInteger queuePriority;

/** 设置 是否继续队列显示 */
@property (nonatomic , assign) BOOL isContinueQueueDisplay;

/** 设置 window等级 */
@property (nonatomic , assign) CGFloat windowLevel;

/** 设置 是否支持自动旋转 */
@property (nonatomic , assign) BOOL isShouldAutorotate;

/** 设置 是否支持显示方向 */
@property (nonatomic , assign) BOOL supportedInterfaceOrientations;

/** 设置 状态栏样式 */
@property (nonatomic , assign) UIStatusBarStyle statusBarStyle;



/** ✨actionSheet 专用设置 */

/** 设置 ActionSheet的背景视图颜色 */
@property (nonatomic , copy) UIColor *actionSheetBackgroundColor;

/** 设置 取消动作的间隔宽度 */
@property (nonatomic , assign) CGFloat actionSheetCancelActionSpaceWidth;

/** 设置 取消动作的间隔颜色 */
@property (nonatomic , copy) UIColor *actionSheetCancelActionSpaceColor;

/** 设置 ActionSheet距离屏幕底部的间距 */
@property (nonatomic , assign) CGFloat actionSheetBottomMargin;

/** 设置 ActionSheet最大宽度 */
@property (nonatomic , assign) CGFloat actionSheetMaxWidth;

/** 设置 ActionSheet最大高度 */
@property (nonatomic , assign) CGFloat actionSheetMaxHeight;

/** 设置 ActionSheet圆角 */
@property (nonatomic , assign) CGFloat actionSheetCornerRadius;


/** 配置 Action信息 */
@property (nonatomic , strong ) NSMutableArray *modelActionArray;
@property (nonatomic , strong ) NSMutableArray *modelItemArray;
@property (nonatomic , strong ) NSMutableDictionary *modelItemInsetsInfo;

@end
