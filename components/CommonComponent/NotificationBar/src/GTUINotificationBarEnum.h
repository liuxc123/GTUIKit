//
//  GTUINotificationBarEnum.h
//  Pods
//
//  Created by liuxc on 2018/12/1.
//

typedef NS_ENUM(NSInteger, GTUINotificationBarType) {
    GTUINotificationBarTypeMessage = 0,
    GTUINotificationBarTypeWarning,
    GTUINotificationBarTypeError,
    GTUINotificationBarTypeSuccess
};

typedef NS_ENUM(NSInteger, GTUINotificationBarPosition) {
    GTUINotificationBarPositionTop = 0,
    GTUINotificationBarPositionNavBarOverlay,
    GTUINotificationBarPositionBottom
};


/** GTUINotificationBar 展示时间枚举 */
typedef NS_ENUM(NSInteger,GTUINotificationBarDuration) {
    GTUINotificationBarDurationAutomatic = 0,
    GTUINotificationBarDurationForever,
    
};


/**  GTUINotificationBar 展示层级 */
typedef NS_ENUM(NSInteger,GTUINotificationBarPresentationStyle) {
    GTUINotificationBarPresentationStyleAutomatic = 0,
    GTUINotificationBarPresentationStyleNormalLevel,
    GTUINotificationBarPresentationStyleStatusBarLevel,
    GTUINotificationBarPresentationStyleCustom
};


/**  GTUINotificationBar 背景模式 */
typedef NS_ENUM(NSInteger,GTUINotificationBarDimMode) {
    GTUINotificationBarPresentationStyleNone = 0,
    GTUINotificationBarPresentationStyleGray,
    GTUINotificationBarPresentationStyleColor,
    GTUINotificationBarPresentationStyleBlur
};


/**  GTUINotificationBar 背景模式 */
typedef NS_ENUM(NSInteger,GTUINotificationBarLayout) {
    GTUINotificationBarPresentationStyleDefault = 0,
    GTUINotificationBarPresentationStyleCard,
    GTUINotificationBarPresentationStyleTab,
    GTUINotificationBarPresentationStyleStatusLine
};


/**  GTUINotificationBar Icon样式 */
typedef NS_ENUM(NSInteger,GTUINotificationBarIconStyle) {
    GTUINotificationBarPresentationStyleRegular = 0,
    GTUINotificationBarPresentationStyleLight,
    GTUINotificationBarPresentationStyleSubtle
};


/**  GTUINotificationBar 提示样式 */
typedef NS_ENUM(NSInteger,GTUINotificationBarTheme) {
    GTUINotificationBarPresentationStyleInfo = 0,
    GTUINotificationBarPresentationStyleSuccess,
    GTUINotificationBarPresentationStyleWarning,
    GTUINotificationBarPresentationStyleError
};
