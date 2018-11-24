//
//  GTUIActionSheet.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import "GTUIActionSheet.h"

@interface GTUIActionSheet ()

@property (nonatomic , strong ) UIWindow *mainWindow;

@property (nonatomic , strong ) UIWindow *actionSheetWindow;

@property (nonatomic , strong ) NSMutableArray *queueArray;

@end

@implementation GTUIActionSheet

+ (GTUIActionSheet *)shareManager{
    static GTUIActionSheet *actionSheetManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actionSheetManager = [[GTUIActionSheet alloc] init];
    });

    return actionSheetManager;
}

+ (UIWindow *)getAlertWindow{
    return [GTUIActionSheet shareManager].actionSheetWindow;
}

+ (void)configMainWindow:(UIWindow *)window{
    if (window) [GTUIActionSheet shareManager].mainWindow = window;
}

+ (void)clearQueue{
    [[GTUIActionSheet shareManager].queueArray removeAllObjects];
}

#pragma mark LazyLoading

- (NSMutableArray *)queueArray {
    if (!_queueArray) _queueArray = [NSMutableArray array];
    return _queueArray;
}

- (UIWindow *)actionSheetWindow{

    if (!_actionSheetWindow) {

        _actionSheetWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

        _actionSheetWindow.rootViewController = [[UIViewController alloc] init];

        _actionSheetWindow.backgroundColor = [UIColor clearColor];

        _actionSheetWindow.windowLevel = UIWindowLevelAlert;

        _actionSheetWindow.hidden = YES;
    }

    return _actionSheetWindow;
}

@end

@interface GTUIActionSheetConfigModel ()

@property (nonatomic, assign) GTUIActionSheetType type;

@end

@implementation GTUIActionSheetConfigModel

- (instancetype)initWithActionSheetType:(GTUIActionSheetType)type
{
    self = [super init];
    if (self) {
        _type = type;
        // 初始化默认值
        switch (type) {
            case GTUIActionSheetTypeNormal:
                _modelCornerRadius = 13.0f; //默认圆角半径
                _modelShadowOpacity = 0.3f; //默认阴影不透明度
                _modelShadowRadius = 5.0f; //默认阴影半径
                _modelShadowOffset = CGSizeMake(0.0f, 2.0f); //默认阴影偏移
                _modelHeaderInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距
                _modelOpenAnimationDuration = 0.3f; //默认打开动画时长
                _modelCloseAnimationDuration = 0.2f; //默认关闭动画时长
                _modelBackgroundStyleColorAlpha = 0.45f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.45f
                _modelWindowLevel = UIWindowLevelAlert;
                _modelQueuePriority = 0; //默认队列优先级 (大于0时才会加入队列)

                _modelActionSheetBackgroundColor = [UIColor clearColor]; //默认actionsheet背景颜色
                _modelActionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
                _modelActionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
                _modelActionSheetBottomMargin = 10.0f; //默认actionsheet距离屏幕底部距离

                _modelShadowColor = [UIColor blackColor]; //默认阴影颜色
                _modelHeaderColor = [UIColor whiteColor]; //默认颜色
                _modelBackgroundColor = [UIColor blackColor]; //默认背景半透明颜色
                _modelBackgroundBlurEffectStyle = UIBlurEffectStyleDark; //默认模糊效果类型Dark
                _modelSupportedInterfaceOrientations = UIInterfaceOrientationMaskAll; //默认支持所有方向
                break;

            case GTUIActionSheetTypeUIKit:
                _modelCornerRadius = 13.0f; //默认圆角半径
                _modelShadowOpacity = 0.3f; //默认阴影不透明度
                _modelShadowRadius = 5.0f; //默认阴影半径
                _modelShadowOffset = CGSizeMake(0.0f, 2.0f); //默认阴影偏移
                _modelHeaderInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距
                _modelOpenAnimationDuration = 0.3f; //默认打开动画时长
                _modelCloseAnimationDuration = 0.2f; //默认关闭动画时长
                _modelBackgroundStyleColorAlpha = 0.45f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.45f
                _modelWindowLevel = UIWindowLevelAlert;
                _modelQueuePriority = 0; //默认队列优先级 (大于0时才会加入队列)

                _modelActionSheetBackgroundColor = [UIColor clearColor]; //默认actionsheet背景颜色
                _modelActionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
                _modelActionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
                _modelActionSheetBottomMargin = 10.0f; //默认actionsheet距离屏幕底部距离

                _modelShadowColor = [UIColor blackColor]; //默认阴影颜色
                _modelHeaderColor = [UIColor whiteColor]; //默认颜色
                _modelBackgroundColor = [UIColor blackColor]; //默认背景半透明颜色
                _modelBackgroundBlurEffectStyle = UIBlurEffectStyleDark; //默认模糊效果类型Dark
                _modelSupportedInterfaceOrientations = UIInterfaceOrientationMaskAll; //默认支持所有方向
                break;

            case GTUIActionSheetTypeMaterial:
                _modelCornerRadius = 13.0f; //默认圆角半径
                _modelShadowOpacity = 0.3f; //默认阴影不透明度
                _modelShadowRadius = 5.0f; //默认阴影半径
                _modelShadowOffset = CGSizeMake(0.0f, 2.0f); //默认阴影偏移
                _modelHeaderInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距
                _modelQueuePriority = 0; //默认队列优先级 (大于0时才会加入队列)

                _modelActionSheetBackgroundColor = [UIColor clearColor]; //默认actionsheet背景颜色
                _modelActionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
                _modelActionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
                _modelActionSheetBottomMargin = 10.0f; //默认actionsheet距离屏幕底部距离

                _modelShadowColor = [UIColor blackColor]; //默认阴影颜色
                _modelHeaderColor = [UIColor whiteColor]; //默认颜色
                _modelBackgroundColor = [UIColor blackColor]; //默认背景半透明颜色
                _modelBackgroundBlurEffectStyle = UIBlurEffectStyleDark; //默认模糊效果类型Dark
                _modelSupportedInterfaceOrientations = UIInterfaceOrientationMaskAll; //默认支持所有方向
                break;

            default:
                break;
        }



    }
    return self;
}

@end
