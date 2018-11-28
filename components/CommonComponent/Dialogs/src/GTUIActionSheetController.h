//
//  GTUIActionSheetController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/27.
//
#import "GTUIDialog.h"
#import "GTUIDialogBaseViewController.h"
#import "GTBottomSheet.h"

@class GTUIDialogAction;

/**
 GTUIActionSheetController 提示一个ActionSheetController
 */
@interface GTUIActionSheetController : GTUIDialogBaseViewController

/**
 创建一个ActionSheetController

 @param title 标题
 @param message 内容
 @return 返回 GTUIActionSheetController类型对象
 */
+ (nonnull instancetype)actionSheetControllerWithTitle:(nullable NSString *)title
                                         message:(nullable NSString *)message;
/**
 创建一个ActionSheetController

 @param title 标题
 @param message 内容
 @return 返回 GTUIActionSheetController类型对象
 */
+ (nonnull instancetype)actionSheetControllerWithTitle:(nullable NSString *)title
                                         message:(nullable NSString *)message
                                      customView:(nullable UIView *)customView;

/**
 创建一个ActionSheetController

 @param title 标题
 @param message 内容
 @param customView 自定义视图
 @param config 配置模型
 @return 返回 GTUIActionSheetController类型对象
 */
+ (nonnull instancetype)actionSheetControllerWithTitle:(nullable NSString *)title
                                         message:(nullable NSString *)message
                                      customView:(nullable UIView *)customView
                                          config:(GTUIDialogConfigModel *)config;

/** ActionSheet controllers must be created with actionSheetControllerWithTitle:message: */
- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                                 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/** ActionSheet controllers must be created with actionSheetControllerWithTitle:message: */
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_UNAVAILABLE;


/** ActionSheetController所有的Action */
@property(nonatomic, nonnull, readonly) NSArray<GTUIDialogAction *> *actions;

@property(nonatomic, strong, readonly, nonnull) GTUIBottomSheetTransitionController *transitionController;


- (void)setTransitioningDelegate:
(nullable id<UIViewControllerTransitioningDelegate>)transitioningDelegate NS_UNAVAILABLE;

- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle NS_UNAVAILABLE;

@end
