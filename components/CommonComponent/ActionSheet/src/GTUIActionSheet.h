//
//  GTUIActionSheet.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import <UIKit/UIKit.h>
#import "GTUIActionSheetController.h"

@interface GTUIActionSheet : NSObject

+ (GTUIActionSheet *)shareManager;

/** 继续队列显示 */

+ (void)continueQueueDisplay;

/** 获取Alert窗口 */

+ (nonnull UIWindow *)getAlertWindow;

/** 设置主窗口 */

+ (void)configMainWindow:(UIWindow * _Nonnull)window;

/** 清空队列 */

+ (void)clearQueue;

@end

@interface GTUIActionSheetConfigModel: NSObject

- (instancetype)initWithActionSheetType:(GTUIActionSheetType)type;

@property (nonatomic, assign, readonly) GTUIActionSheetType type;

@property (nonatomic , assign ) CGFloat modelCornerRadius;
@property (nonatomic , assign ) CGFloat modelShadowOpacity;
@property (nonatomic , assign ) CGFloat modelShadowRadius;
@property (nonatomic , assign ) CGFloat modelOpenAnimationDuration;
@property (nonatomic , assign ) CGFloat modelCloseAnimationDuration;
@property (nonatomic , assign ) CGFloat modelBackgroundStyleColorAlpha;
@property (nonatomic , assign ) CGFloat modelWindowLevel;
@property (nonatomic , assign ) NSInteger modelQueuePriority;

@property (nonatomic , assign ) UIColor *modelShadowColor;
@property (nonatomic , strong ) UIColor *modelHeaderColor;
@property (nonatomic , strong ) UIColor *modelBackgroundColor;

@property (nonatomic , assign ) CGSize modelShadowOffset;
@property (nonatomic , assign ) UIEdgeInsets modelHeaderInsets;

@property (nonatomic , assign ) UIStatusBarStyle modelStatusBarStyle;
@property (nonatomic , assign ) UIBlurEffectStyle modelBackgroundBlurEffectStyle;
@property (nonatomic , assign ) UIInterfaceOrientationMask modelSupportedInterfaceOrientations;

@property (nonatomic , strong ) UIColor *modelActionSheetBackgroundColor;
@property (nonatomic , strong ) UIColor *modelActionSheetCancelActionSpaceColor;
@property (nonatomic , assign ) CGFloat modelActionSheetCancelActionSpaceWidth;
@property (nonatomic , assign ) CGFloat modelActionSheetBottomMargin;

@end
