//
//  GTUIDialogBaseViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/26.
//

#import "GTUIDialogBaseViewController.h"
#import "GTUIDialogItemView.h"
#import "GTUIDialog+Private.h"

@implementation GTUIDialogBaseViewController

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    _config = nil;

    _currentKeyWindow = nil;

}

- (void)viewDidLoad{

    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.extendedLayoutIncludesOpaqueBars = NO;

    self.automaticallyAdjustsScrollViewInsets = NO;

    if (self.config.backgroundStyle == GTUIBackgroundStyleBlur) {

        self.backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];

        self.backgroundVisualEffectView.frame = self.view.frame;

        [self.view addSubview:self.backgroundVisualEffectView];
    }

    self.view.backgroundColor = [self.config.backgroundColor colorWithAlphaComponent:0.0f];

    self.orientationType = CGRectGetHeight(self.view.bounds) > CGRectGetWidth(self.view.bounds) ? GTUIScreenOrientationTypeVertical : GTUIScreenOrientationTypeHorizontal;
}

- (void)viewWillLayoutSubviews{

    [super viewWillLayoutSubviews];

    if (self.backgroundVisualEffectView) self.backgroundVisualEffectView.frame = self.view.frame;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    self.orientationType = size.height > size.width ? GTUIScreenOrientationTypeVertical : GTUIScreenOrientationTypeHorizontal;
}


#pragma mark LazyLoading

- (UIWindow *)currentKeyWindow{

    if (!_currentKeyWindow) _currentKeyWindow = [GTUIDialog getMainWindow];

    if (_currentKeyWindow.windowLevel != UIWindowLevelNormal) {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"windowLevel == %ld AND hidden == 0 " , UIWindowLevelNormal];

        _currentKeyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
    }
    
    return _currentKeyWindow;
}

#pragma mark - 旋转

- (BOOL)shouldAutorotate{

    return self.config.isShouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{

    return self.config.supportedInterfaceOrientations;
}

#pragma mark - 状态栏

- (UIStatusBarStyle)preferredStatusBarStyle {

    return self.config.statusBarStyle;
}



- (void)show {

    //配置队列
    if ([GTUIDialog shareManager].queueArray.count) {

        GTUIDialogBaseViewController *last = [GTUIDialog shareManager].queueArray.lastObject;

        if (!self.config.isQueue && last.config.queuePriority > self.config.queuePriority) {
            return;
        }

        if (!last.config.isQueue && last.config.queuePriority <= self.config.queuePriority) {
            [[GTUIDialog shareManager].queueArray removeObject:last];
        }

        if (![[GTUIDialog shareManager].queueArray containsObject:self]) {

            [[GTUIDialog shareManager].queueArray addObject:self];

            [[GTUIDialog shareManager].queueArray sortUsingComparator:^NSComparisonResult(GTUIDialogBaseViewController *itemA, GTUIDialogBaseViewController *itemB) {

                return itemA.config.queuePriority > itemB.config.queuePriority ? NSOrderedDescending
                : itemA.config.queuePriority == itemB.config.queuePriority ? NSOrderedSame : NSOrderedAscending;
            }];
        }

        if ([GTUIDialog shareManager].queueArray.lastObject == self) {
            [self showController];
        }
    } else {
        //展示
        [self showController];

        [[GTUIDialog shareManager].queueArray addObject:self];
    }

}

- (void)showController {

    __weak typeof(self) weakSelf = self;

    [[GTUIDialog getMainWindow].rootViewController presentViewController:self animated:YES completion:^{

    }];

    self.closeFinishHandler = ^{

        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (!strongSelf) return;

        [[GTUIDialog shareManager].queueArray removeObject:strongSelf];

        if (strongSelf.config.isContinueQueueDisplay) {
            [GTUIDialog continueQueueDisplay];
        }
    };
}






- (void)closeWithCompletionBlock:(void (^)(void))completionBlock{

}

#pragma mark - 添加Item 内容方法

- (void)addTitle:(NSString *)title {

    [self addTitleWithBlock:^(UILabel * _Nonnull label) {
        label.text = title;
    }];
}

- (void)addMessage:(NSString *)message {

    [self addMessageWithBlock:^(UILabel *label) {

        label.text = message;
    }];
}

- (void)addCustomView:(UIView *)view {

    __weak typeof(self) weakSelf = self;

    [self addCustomViewWithBlock:^(GTUIDialogItemCustomView * _Nonnull custom) {

        custom.view = view;

        custom.positionType = weakSelf.config.customViewPositionType;
    }];
}


- (void)addTitleWithBlock:(void(^)(UILabel * _Nonnull label))block {

    [self addItemWithBlock:^(GTUIDialogItem * _Nonnull item) {

        item.type = GTUIItemTypeTitle;

        item.insets = UIEdgeInsetsMake(5, 0, 5, 0);

        item.block = block;
    }];
}

- (void)addMessageWithBlock:(void(^)(UILabel * label))block {

    [self addItemWithBlock:^(GTUIDialogItem * _Nonnull item) {

        item.type = GTUIItemTypeMessage;

        item.insets = UIEdgeInsetsMake(5, 0, 5, 0);

        item.block = block;
    }];
}

- (void)addCustomViewWithBlock:(void(^)(GTUIDialogItemCustomView * _Nonnull custom))block {

    [self addItemWithBlock:^(GTUIDialogItem * _Nonnull item) {

        item.type = GTUIItemTypeCustomView;

        item.insets = UIEdgeInsetsMake(5, 0, 5, 0);

        item.block = block;
    }];
}

- (void)addTextFieldWithBlock:(void (^)(UITextField *))block {

    [self addItemWithBlock:^(GTUIDialogItem * _Nonnull item) {

        item.type = GTUIItemTypeTextField;

        item.insets = UIEdgeInsetsMake(5, 0, 5, 0);

        item.block = block;
    }];
}


- (void)addDefaultActionWithTitle:(NSString *)title block:(void(^)(void))block {

    [self addActionWithblock:^(GTUIDialogAction * _Nonnull action) {

        action.type = GTUIActionTypeDefault;

        action.title = title;

        action.clickBlock = block;
    }];
}

- (void)addCancelActionWithTitle:(NSString *)title block:(void(^)(void))block {

    __weak typeof(self) weakSelf = self;

    [self addActionWithblock:^(GTUIDialogAction * _Nonnull action) {

        action.type = GTUIActionTypeCancel;

        action.title = title;

        action.font = weakSelf.config.cancelActionFont;

        action.clickBlock = block;
    }];
}

- (void)addDestructiveActionWithTitle:(NSString *)title block:(void(^)(void))block {

    __weak typeof(self) weakSelf = self;

    [self addActionWithblock:^(GTUIDialogAction * _Nonnull action) {

        action.type = GTUIActionTypeDestructive;

        action.title = title;

        action.titleColor = weakSelf.config.destructiveActionTextColor;

        action.clickBlock = block;
    }];
}

- (void)addItemWithBlock:(void(^)(GTUIDialogItem * _Nonnull item))block {
    [self.config.modelItemArray addObject:block];
}

- (void)addActionWithblock:(void(^)(GTUIDialogAction * _Nonnull action))block {
    [self.config.modelActionArray addObject:block];
}



@end
