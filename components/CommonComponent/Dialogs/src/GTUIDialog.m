//
//  GTUIDialog.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/26.
//

#import "GTUIDialog.h"
#import "GTUIMetrics.h"
#import "GTUIDialogBaseViewController.h"
#import "GTUIDialog+Private.h"


@implementation GTUIDialog

+ (GTUIDialog *)shareManager{
    static GTUIDialog *dialogManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dialogManager = [[GTUIDialog alloc] init];
    });

    return dialogManager;
}

+ (UIWindow *)getAlertWindow{
    return [GTUIDialog shareManager].dialogWindow;
}

+ (UIWindow *)getMainWindow {
    if (![GTUIDialog shareManager].mainWindow) {
        [GTUIDialog shareManager].mainWindow = [UIApplication sharedApplication].keyWindow;
    }
    return [GTUIDialog shareManager].mainWindow;
}

+ (void)configMainWindow:(UIWindow *)window{
    if (window) [GTUIDialog shareManager].mainWindow = window;
}

+ (void)continueQueueDisplay{
    if ([GTUIDialog shareManager].queueArray.count) {
        [(GTUIDialogBaseViewController *)[GTUIDialog shareManager].queueArray.lastObject show];
    }
}

+ (void)clearQueue{
    [[GTUIDialog shareManager].queueArray removeAllObjects];
}

+ (void)closeWithCompletionBlock:(void (^)(void))completionBlock {
    if ([GTUIDialog shareManager].queueArray.count) {

        GTUIDialogBaseViewController *item = [GTUIDialog shareManager].queueArray.lastObject;

        if ([item respondsToSelector:@selector(closeWithCompletionBlock:)]) [item performSelector:@selector(closeWithCompletionBlock:) withObject:completionBlock];
    }
}


#pragma mark LazyLoading

- (NSMutableArray<GTUIDialogConfigModel *> *)queueArray {
    if (!_queueArray) _queueArray = [NSMutableArray array];
    return _queueArray;
}

- (UIWindow *)dialogWindow{

    if (!_dialogWindow) {

        _dialogWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

        _dialogWindow.rootViewController = [[UIViewController alloc] init];

        _dialogWindow.backgroundColor = [UIColor clearColor];

        _dialogWindow.windowLevel = UIWindowLevelAlert;

        _dialogWindow.hidden = YES;
    }

    return _dialogWindow;
}

@end


@implementation GTUIDialogConfigModel

- (void)dealloc{
    _modelActionArray = nil;
    _modelItemArray = nil;
    _modelItemInsetsInfo = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dialogStyle = GTUIDialogStyleNormal;
        switch (_dialogStyle) {
            case GTUIDialogStyleNormal:
                [self configGTUIDialogStyleNormal];
                break;
            case GTUIDialogStyleUIKit:
                [self configGTUIDialogStyleUIKit];
                break;
            case GTUIDialogStyleMaterial:
                [self configGTUIDialogStyleMaterial];
                break;
            default:
                break;
        }
    }
    return self;
}

- (instancetype)initWithStyle:(GTUIDialogStyle)style
{
    self = [super init];
    if (self) {
        _dialogStyle = style;
        switch (_dialogStyle) {
            case GTUIDialogStyleNormal:
                [self configGTUIDialogStyleNormal];
                break;
            case GTUIDialogStyleUIKit:
                [self configGTUIDialogStyleUIKit];
                break;
            case GTUIDialogStyleMaterial:
                [self configGTUIDialogStyleMaterial];
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)configGTUIDialogStyleNormal {
    /** Dialog默认样式设置 类似微信 */

    //标题
    _titleTextColor = [UIColor blackColor];
    _titleFont = [UIFont boldSystemFontOfSize:18.0f];
    _titleTextAlignment = NSTextAlignmentCenter;


    //内容
    _messageTextColor = [UIColor blackColor];
    _messageFont = [UIFont systemFontOfSize:14.0f];
    _messageTextAlignment = NSTextAlignmentCenter;

    //自定义视图
    _customViewPositionType = GTUICustomViewPositionTypeCenter;

    //textField设置
    _textFieldTextColor = [UIColor blackColor];
    _textFieldFont = [UIFont systemFontOfSize:15.0f];

    //Action设置
    _defaultActionTextColor = [UIColor blackColor];
    _defaultActionFont = [UIFont systemFontOfSize:18];
    _cancelActionTextColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
    _cancelActionFont = [UIFont systemFontOfSize:18];
    _destructiveActionTextColor = [UIColor redColor];
    _destructiveActionFont = [UIFont systemFontOfSize:18];
    _actionBackgroundColor = [UIColor whiteColor];

    _maxWidth = [UIScreen mainScreen].bounds.size.width - 40;   //最大宽度
    _maxHeight = [UIScreen mainScreen].bounds.size.height - GTUIDeviceTopSafeAreaInset() - GTUIDeviceBottomSafeAreaInset(); //最大高度

    //headr设置
    _headerColor = [UIColor whiteColor]; //默认颜色
    _headerInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距

    //内容通用设置
    _backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0f]; //默认背景半透明颜色
    _backgroundStyle = GTUIBackgroundStyleTranslucent;//背景透明度
    _backgroundBlurEffectStyle = UIBlurEffectStyleDark; //背景样式
    _inkColor = [UIColor clearColor]; //默认墨水颜色

    _cornerRadius = 5.0f; //默认圆角半径
    _shadowColor = [UIColor blackColor]; //默认阴影颜色
    _shadowOffset = CGSizeMake(0.0f, 2.0f); //默认阴影偏移
    _shadowOpacity = 0.3f; //默认阴影不透明度
    _shadowRadius = 0.0f; //默认阴影半径


    _dismissOnBackgroundTap = YES;
    _isQueue = NO; //默认不加入队列
    _queuePriority = 0; //默认队列优先级 (大于0时才会加入队列)
    _isContinueQueueDisplay = YES; //默认继续队列显示
    _windowLevel = UIWindowLevelAlert;
    _isShouldAutorotate = NO; //默认支持自动旋转
    _supportedInterfaceOrientations = UIInterfaceOrientationMaskAll; //默认支持所有方向
    _statusBarStyle = UIStatusBarStyleDefault; //默认状态栏样式

    //actionSheet设置
    _actionSheetBackgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0f]; //默认actionsheet背景颜色
    _actionSheetCancelActionSpaceColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0f]; //默认actionsheet取消按钮间隔颜色
    _actionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
    _actionSheetBottomMargin = 13.0f; //默认actionsheet距离屏幕底部距离
    _actionSheetCornerRadius = 0.0f;//默认actionsheet圆角
    _actionSheetMaxWidth = [UIScreen mainScreen].bounds.size.width;   //最大宽度
    _actionSheetMaxHeight = [UIScreen mainScreen].bounds.size.height - GTUIDeviceTopSafeAreaInset(); //最大高度
}


- (void)configGTUIDialogStyleUIKit {
    /** Dialog默认样式设置 类似iOS苹果设计 */

    //标题
    _titleTextColor = [UIColor blackColor];
    _titleFont = [UIFont boldSystemFontOfSize:18.0f];
    _titleTextAlignment = NSTextAlignmentCenter;

    //内容
    _messageTextColor = [UIColor colorWithRed:146/255.0f green:146/255.0f blue:146/255.0f alpha:1.0f];
    _messageFont = [UIFont systemFontOfSize:14.0f];
    _messageTextAlignment = NSTextAlignmentCenter;

    //自定义视图
    _customViewPositionType = GTUICustomViewPositionTypeCenter;

    //textField设置
    _textFieldTextColor = [UIColor blackColor];
    _textFieldFont = [UIFont systemFontOfSize:15.0f];

    //Action设置
    _defaultActionTextColor = [UIColor colorWithRed:67/255.0f green:195/255.0f blue:48/255.0f alpha:1.0f];
    _defaultActionFont = [UIFont systemFontOfSize:18];
    _cancelActionTextColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
    _cancelActionFont = [UIFont systemFontOfSize:18];
    _destructiveActionTextColor = [UIColor redColor];
    _destructiveActionFont = [UIFont systemFontOfSize:18];
    _actionBackgroundColor = [UIColor whiteColor];

    //headr设置
    _headerColor = [UIColor whiteColor]; //默认颜色
    _headerInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距

    //内容通用设置
    _backgroundColor = [UIColor clearColor]; //默认背景半透明颜色
    _backgroundStyle = GTUIBackgroundStyleTranslucent;//背景透明度
    _backgroundBlurEffectStyle = UIBlurEffectStyleDark; //背景样式
    _inkColor = [UIColor clearColor]; //默认墨水颜色

    _maxWidth = [UIScreen mainScreen].bounds.size.width - 40;   //最大宽度
    _maxHeight = [UIScreen mainScreen].bounds.size.height - GTUIDeviceTopSafeAreaInset() - GTUIDeviceBottomSafeAreaInset();    //最大高度

    _cornerRadius = 13.0f; //默认圆角半径
    _shadowColor = [UIColor blackColor]; //默认阴影颜色
    _shadowOffset = CGSizeMake(0.0f, 2.0f); //默认阴影偏移
    _shadowOpacity = 0.3f; //默认阴影不透明度
    _shadowRadius = 5.0f; //默认阴影半径


    _dismissOnBackgroundTap = YES;
    _isQueue = NO; //默认不加入队列
    _queuePriority = 0; //默认队列优先级 (大于0时才会加入队列)
    _isContinueQueueDisplay = YES; //默认继续队列显示
    _windowLevel = UIWindowLevelAlert;
    _isShouldAutorotate = NO; //默认支持自动旋转
    _supportedInterfaceOrientations = UIInterfaceOrientationMaskAll; //默认支持所有方向
    _statusBarStyle = UIStatusBarStyleDefault; //默认状态栏样式

    //actionSheet设置
    _actionSheetBackgroundColor = [UIColor clearColor]; //默认actionsheet背景颜色
    _actionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
    _actionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
    _actionSheetBottomMargin = 13.0f; //默认actionsheet距离屏幕底部距离式
    _actionSheetCornerRadius = 0.0f;//默认actionsheet圆角
    _actionSheetMaxWidth = [UIScreen mainScreen].bounds.size.width - 40;   //最大宽度
    _actionSheetMaxHeight = [UIScreen mainScreen].bounds.size.height - GTUIDeviceTopSafeAreaInset(); //最大高度
}

- (void)configGTUIDialogStyleMaterial {

    /** Dialog默认样式设置 类似Material */

    //标题
    _titleTextColor = [UIColor blackColor];
    _titleFont = [UIFont boldSystemFontOfSize:18.0f];
    _titleTextAlignment = NSTextAlignmentCenter;


    //内容
    _messageTextColor = [UIColor blackColor];
    _messageFont = [UIFont systemFontOfSize:14.0f];
    _messageTextAlignment = NSTextAlignmentCenter;

    //自定义视图
    _customViewPositionType = GTUICustomViewPositionTypeCenter;

    //textField设置
    _textFieldTextColor = [UIColor blackColor];
    _textFieldFont = [UIFont systemFontOfSize:15.0f];

    //Action设置
    _defaultActionTextColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
    _defaultActionFont = [UIFont systemFontOfSize:18];
    _cancelActionTextColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
    _cancelActionFont = [UIFont systemFontOfSize:18];
    _destructiveActionTextColor = [UIColor redColor];
    _destructiveActionFont = [UIFont systemFontOfSize:18];
    _actionBackgroundColor = [UIColor whiteColor];

    //headr设置
    _headerColor = [UIColor whiteColor]; //默认颜色
    _headerInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距

    //内容通用设置
    _backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0f]; //默认背景半透明颜色
    _backgroundStyle = GTUIBackgroundStyleTranslucent;//背景透明度
    _backgroundBlurEffectStyle = UIBlurEffectStyleDark; //背景样式
    _inkColor = [UIColor clearColor]; //默认墨水颜色

    _maxWidth = [UIScreen mainScreen].bounds.size.width - 40;   //最大宽度
    _maxHeight = [UIScreen mainScreen].bounds.size.height - GTUIDeviceTopSafeAreaInset() - GTUIDeviceBottomSafeAreaInset();    //最大高度

    _cornerRadius = 5.0f; //默认圆角半径
    _shadowColor = [UIColor blackColor]; //默认阴影颜色
    _shadowOffset = CGSizeMake(0.0f, 2.0f); //默认阴影偏移
    _shadowOpacity = 0.3f; //默认阴影不透明度
    _shadowRadius = 5.0f; //默认阴影半径


    _dismissOnBackgroundTap = YES;
    _isQueue = NO; //默认不加入队列
    _queuePriority = 0; //默认队列优先级 (大于0时才会加入队列)
    _isContinueQueueDisplay = YES; //默认继续队列显示
    _windowLevel = UIWindowLevelAlert;
    _isShouldAutorotate = NO; //默认支持自动旋转
    _supportedInterfaceOrientations = UIInterfaceOrientationMaskAll; //默认支持所有方向
    _statusBarStyle = UIStatusBarStyleDefault; //默认状态栏样式

    //actionSheet设置
    _actionSheetBackgroundColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f]; //默认actionsheet背景颜色
    _actionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
    _actionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
    _actionSheetBottomMargin = 13.0f; //默认actionsheet距离屏幕底部距离
    _actionSheetCornerRadius = 0.0f;//默认actionsheet圆角
    _actionSheetMaxWidth = [UIScreen mainScreen].bounds.size.width;   //最大宽度
    _actionSheetMaxHeight = [UIScreen mainScreen].bounds.size.height - GTUIDeviceTopSafeAreaInset(); //最大高度
}

#pragma mark LazyLoading

- (NSMutableArray *)modelActionArray{

    if (!_modelActionArray) _modelActionArray = [NSMutableArray array];

    return _modelActionArray;
}

- (NSMutableArray *)modelItemArray{

    if (!_modelItemArray) _modelItemArray = [NSMutableArray array];

    return _modelItemArray;
}

- (NSMutableDictionary *)modelItemInsetsInfo{

    if (!_modelItemInsetsInfo) _modelItemInsetsInfo = [NSMutableDictionary dictionary];

    return _modelItemInsetsInfo;
}

@end

