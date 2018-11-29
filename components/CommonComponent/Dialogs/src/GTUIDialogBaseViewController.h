//
//  GTUIDialogBaseViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/26.
//

#import <UIKit/UIKit.h>
#import "GTUIDialog.h"
#import "GTUIDialogAction.h"
#import "GTUIDialogItemView.h"

@interface GTUIDialogBaseViewController : UIViewController <GTUIDialogProtocol>

@property (nonatomic , strong ) GTUIDialogConfigModel *config;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@property (nonatomic , strong ) UIVisualEffectView *backgroundVisualEffectView;

@property (nonatomic , assign ) GTUIScreenOrientationType orientationType;

@property (nonatomic , assign ) BOOL isShowing;

@property (nonatomic , assign ) BOOL isClosing;

@property (nonatomic , copy ) void (^openFinishHandler)(void);

@property (nonatomic , copy ) void (^closeFinishHandler)(void);

/** 队列展示 */
- (void)show;

/** 直接展示 */
- (void)showController;


#pragma mark - 添加Item

- (void)addTitle:(NSString *)title;

- (void)addMessage:(NSString *)message;

- (void)addCustomView:(UIView *)view;

- (void)addTitleWithBlock:(void(^)(UILabel * _Nonnull label))block;

- (void)addMessageWithBlock:(void(^)(UILabel * label))block;

- (void)addCustomViewWithBlock:(void(^)(GTUIDialogItemCustomView * _Nonnull custom))block;

- (void)addTextFieldWithBlock:(void (^)(UITextField *))block;

#pragma mark - 添加Action

- (void)addDefaultActionWithTitle:(NSString *)title block:(void(^)(void))block;

- (void)addCancelActionWithTitle:(NSString *)title block:(void(^)(void))block;

- (void)addDestructiveActionWithTitle:(NSString *)title block:(void(^)(void))block;

- (void)addItemWithBlock:(void(^)(GTUIDialogItem * _Nonnull item))block;

- (void)addActionWithblock:(void(^)(GTUIDialogAction * _Nonnull action))block;

@end
