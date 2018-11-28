//
//  GTUIAlertController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import <UIKit/UIKit.h>
#import "GTUIDialog.h"
#import "GTUIDialogBaseViewController.h"

@class GTUIDialogAction;

/**
 GTUIAlertController 提示一个AlertController
 */
@interface GTUIAlertController : GTUIDialogBaseViewController

/**
 创建一个AlerController

 @param title 标题
 @param message 内容
 @return 返回 GTUIAlertController类型对象
 */
+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title
                                         message:(nullable NSString *)message;
/**
 创建一个AlerController

 @param title 标题
 @param message 内容
 @return 返回 GTUIAlertController类型对象
 */
+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title
                                         message:(nullable NSString *)message
                                      customView:(nullable UIView *)customView;

/**
  创建一个AlerController

 @param title 标题
 @param message 内容
 @param customView 自定义视图
 @param config 配置模型
 @return 返回 GTUIAlertController类型对象
 */
+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title
                                         message:(nullable NSString *)message
                                      customView:(nullable UIView *)customView
                                          config:(GTUIDialogConfigModel *)config;

/** Alert controllers must be created with alertControllerWithTitle:message: */
- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                                 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/** Alert controllers must be created with alertControllerWithTitle:message: */
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_UNAVAILABLE;


/** UIAlertController所有的Action */
@property(nonatomic, nonnull, readonly) NSArray<GTUIDialogAction *> *actions;

@end

