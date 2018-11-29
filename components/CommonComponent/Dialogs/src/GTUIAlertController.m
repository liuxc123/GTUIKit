//
//  GTUIAlertController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//
#import "GTUIAlertController.h"
#import "GTUIDialogAction.h"

#import <GTFInternationalization/GTFInternationalization.h>
#import "GTUIDialogPresentationController.h"
#import "GTUIDialogTransitionController.h"
#import "UIViewController+GTUIDialogs.h"
#import "GTButton.h"
#import "GTTypography.h"
#import "GTUIDialogItemView.h"

#define DEFAULTBORDERWIDTH (1.0f / [[UIScreen mainScreen] scale] + 0.02f)
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

@interface GTUIAlertController ()

@property(nonatomic, strong) GTUIDialogTransitionController *transitionController;

@property (nonatomic , strong ) UIScrollView *alertView;

@property (nonatomic , strong ) NSMutableArray <id>*alertItemArray;

@property (nonatomic , strong ) NSMutableArray <GTUIDialogActionButton *>*alertActionArray;

@end

@implementation GTUIAlertController {
    CGFloat alertViewHeight;
}



+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message {
    GTUIAlertController *alertController = [[GTUIAlertController alloc] initWithTitle:title message:message customView:nil config: nil];
    return alertController;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                              customView:(UIView *)customView {
    GTUIAlertController *alertController = [[GTUIAlertController alloc] initWithTitle:title message:message customView:customView config: nil];
    return alertController;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                              customView:(UIView *)customView
                             config:(GTUIDialogConfigModel *)config
{
    GTUIAlertController *alertController = [[GTUIAlertController alloc] initWithTitle:title message:message customView:customView config: config];
    return alertController;
}

- (instancetype)init {
    return [self initWithTitle:nil message:nil customView:nil config:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                              message:(NSString *)message
                           customView:(UIView *)custom
                          config:(GTUIDialogConfigModel *)config
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _transitionController = [[GTUIDialogTransitionController alloc] init];

        if (config) {
             self.config = config;
        } else {
            self.config = [[GTUIDialogConfigModel alloc] initWithStyle:GTUIDialogStyleNormal];
        }

        if (title) [self addTitle:[title copy]];
        if (message) [self addMessage:[message copy]];
        if (custom) [self addCustomView:custom];

        super.transitioningDelegate = _transitionController;
        super.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}


- (NSArray<GTUIDialogAction *> *)actions {
    return self.config.modelActionArray;
}


#pragma mark - UIViewController

- (void)dealloc{

    _alertView = nil;

    _alertItemArray = nil;

    _alertActionArray = nil;
}

- (void)viewDidLoad {

    [self configAlert];

}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];

    [self updateAlertLayout];

}

- (void)viewSafeAreaInsetsDidChange{

    [super viewSafeAreaInsetsDidChange];

    [self updateAlertLayout];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.preferredContentSize = self.alertView.bounds.size;
    } completion:nil];
}

/* Disable setter. Always use internal transition controller */
- (void)setTransitioningDelegate:
(__unused id<UIViewControllerTransitioningDelegate>)transitioningDelegate {
    NSAssert(NO, @"GTUIAlertController.transitioningDelegate cannot be changed.");
    return;
}

/* Disable setter. Always use custom presentation style */
- (void)setModalPresentationStyle:(__unused UIModalPresentationStyle)modalPresentationStyle {
    NSAssert(NO, @"GTUIAlertController.modalPresentationStyle cannot be changed.");
    return;
}

/** 更新AlertLayout */
- (void)updateAlertLayout{
    [self updateAlertLayoutWithViewWidth:CGRectGetWidth(self.view.frame) ViewHeight:CGRectGetHeight(self.view.frame)];
}

/** 更新AlertLayout */
- (void)updateAlertLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight {

    CGFloat alertViewMaxWidth = self.config.maxWidth;

    CGFloat alertViewMaxHeight = self.config.maxHeight;

    [self updateAlertItemsLayout];

    CGRect alertViewFrame = self.alertView.frame;

    alertViewFrame.size.width = alertViewMaxWidth;

    alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;

    self.alertView.frame = alertViewFrame;

    self.preferredContentSize = alertViewFrame.size;

}

- (void)updateAlertItemsLayout {

    [UIView setAnimationsEnabled:NO];

    alertViewHeight = 0.0f;

    CGFloat alertViewMaxWidth = self.config.maxWidth;

    [self.alertItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {

        if (idx == 0) self->alertViewHeight += self.config.headerInsets.top;

        if ([item isKindOfClass:UIView.class]) {

            GTUIDialogItemView *view = (GTUIDialogItemView *)item;

            CGRect viewFrame = view.frame;

            viewFrame.origin.x = self.config.headerInsets.left + view.item.insets.left + VIEWSAFEAREAINSETS(view).left;

            viewFrame.origin.y = self->alertViewHeight + view.item.insets.top;

            viewFrame.size.width = alertViewMaxWidth - viewFrame.origin.x - self.config.headerInsets.right - view.item.insets.right - VIEWSAFEAREAINSETS(view).left - VIEWSAFEAREAINSETS(view).right;

            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;

            view.frame = viewFrame;

            self->alertViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;

        } else if ([item isKindOfClass:GTUIDialogItemCustomView.class]) {

            GTUIDialogItemCustomView *custom = (GTUIDialogItemCustomView *)item;

            CGRect viewFrame = custom.view.frame;

            if (custom.isAutoWidth) {

                custom.positionType = GTUICustomViewPositionTypeCenter;

                viewFrame.size.width = alertViewMaxWidth - self.config.headerInsets.left - custom.item.insets.left - self.config.headerInsets.right - custom.item.insets.right;
            }

            switch (custom.positionType) {

                case GTUICustomViewPositionTypeCenter:

                    viewFrame.origin.x = (alertViewMaxWidth - viewFrame.size.width) * 0.5f;

                    break;

                case GTUICustomViewPositionTypeLeft:

                    viewFrame.origin.x = self.config.headerInsets.left + custom.item.insets.left;

                    break;

                case GTUICustomViewPositionTypeRight:

                    viewFrame.origin.x = alertViewMaxWidth - self.config.headerInsets.right - custom.item.insets.right - viewFrame.size.width;

                    break;

                default:
                    break;
            }

            viewFrame.origin.y = self->alertViewHeight + custom.item.insets.top;

            custom.view.frame = viewFrame;

            self->alertViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }

        if (item == self.alertItemArray.lastObject) self->alertViewHeight += self.config.headerInsets.bottom;
    }];

    for (GTUIDialogActionButton *button in self.alertActionArray) {

        CGRect buttonFrame = button.frame;

        buttonFrame.origin.x = button.action.insets.left;

        buttonFrame.origin.y = alertViewHeight + button.action.insets.top;

        buttonFrame.size.width = alertViewMaxWidth - button.action.insets.left - button.action.insets.right;

        button.frame = buttonFrame;

        alertViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }

    if (self.alertActionArray.count == 2) {

        GTUIDialogActionButton *buttonA = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.firstObject : self.alertActionArray.lastObject;

        GTUIDialogActionButton *buttonB = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.lastObject : self.alertActionArray.firstObject;

        UIEdgeInsets buttonAInsets = buttonA.action.insets;

        UIEdgeInsets buttonBInsets = buttonB.action.insets;

        CGFloat buttonAHeight = CGRectGetHeight(buttonA.frame) + buttonAInsets.top + buttonAInsets.bottom;

        CGFloat buttonBHeight = CGRectGetHeight(buttonB.frame) + buttonBInsets.top + buttonBInsets.bottom;

        //CGFloat maxHeight = buttonAHeight > buttonBHeight ? buttonAHeight : buttonBHeight;

        CGFloat minHeight = buttonAHeight < buttonBHeight ? buttonAHeight : buttonBHeight;

        CGFloat minY = (buttonA.frame.origin.y - buttonAInsets.top) > (buttonB.frame.origin.y - buttonBInsets.top) ? (buttonB.frame.origin.y - buttonBInsets.top) : (buttonA.frame.origin.y - buttonAInsets.top);

        buttonA.frame = CGRectMake(buttonAInsets.left, minY + buttonAInsets.top, (alertViewMaxWidth / 2) - buttonAInsets.left - buttonAInsets.right, buttonA.frame.size.height);

        buttonB.frame = CGRectMake((alertViewMaxWidth / 2) + buttonBInsets.left, minY + buttonBInsets.top, (alertViewMaxWidth / 2) - buttonBInsets.left - buttonBInsets.right, buttonB.frame.size.height);

        alertViewHeight -= minHeight;
    }

    self.alertView.contentSize = CGSizeMake(alertViewMaxWidth, alertViewHeight);


    [UIView setAnimationsEnabled:YES];
}

/** 配置视图 */
- (void)configAlert {

    __weak typeof(self) weakSelf = self;

    [self.view addSubview: self.alertView];

    self.view.layer.shadowOffset = self.config.shadowOffset;

    self.view.layer.shadowRadius = self.config.shadowRadius;

    self.view.layer.shadowOpacity = self.config.shadowOpacity;

    self.view.layer.shadowColor = self.config.shadowColor.CGColor;

    self.alertView.layer.cornerRadius = self.config.cornerRadius;

    self.alertView.layer.masksToBounds = YES;

    self.gtui_dialogPresentationController.dialogCornerRadius = self.config.cornerRadius;

    self.gtui_dialogPresentationController.closeFinishHandler = ^{
        if (weakSelf.closeFinishHandler) weakSelf.closeFinishHandler();
    };

    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        void (^itemBlock)(GTUIDialogItem *) = obj;

        GTUIDialogItem *item = [[GTUIDialogItem alloc] init];

        if (itemBlock) itemBlock(item);

        NSValue *insetValue = [self.config.modelItemInsetsInfo objectForKey:@(idx)];

        if (insetValue) item.insets = insetValue.UIEdgeInsetsValue;

        switch (item.type) {
            case GTUIItemTypeTitle:
            {
                void(^block)(UILabel *label) = item.block;

                GTUIDialogItemLabel *label = [GTUIDialogItemLabel label];

                [self.alertView addSubview:label];

                [self.alertItemArray addObject:label];

                label.textAlignment = self.config.titleTextAlignment;

                label.font = self.config.titleFont;

                label.textColor = self.config.titleTextColor;

                label.numberOfLines = 0;

                if (block) block(label);

                label.item = item;

                label.textChangedBlock = ^{

                    if (weakSelf) [weakSelf updateAlertLayout];
                };

            }
                break;

            case GTUIItemTypeMessage:
            {
                void(^block)(UILabel *label) = item.block;

                GTUIDialogItemLabel *label = [GTUIDialogItemLabel label];

                [self.alertView addSubview:label];

                [self.alertItemArray addObject:label];

                label.textAlignment = self.config.messageTextAlignment;

                label.font = self.config.messageFont;

                label.textColor = self.config.messageTextColor;

                label.numberOfLines = 0;

                if (block) block(label);

                label.item = item;

                label.textChangedBlock = ^{

                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;

            case GTUIItemTypeCustomView:
            {
                void(^block)(GTUIDialogItemCustomView *) = item.block;

                GTUIDialogItemCustomView *custom = [[GTUIDialogItemCustomView alloc] init];

                block(custom);

                [self.alertView addSubview:custom.view];

                [self.alertItemArray addObject:custom];

                custom.item = item;

                custom.sizeChangedBlock = ^{

                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;

            case GTUIItemTypeTextField:
            {
                GTUIDialogItemTextField *textField = [GTUIDialogItemTextField textField];

                textField.frame = CGRectMake(0, 0, 0, 40.0f);

                [self.alertView addSubview:textField];

                [self.alertItemArray addObject:textField];

                textField.borderStyle = UITextBorderStyleRoundedRect;

                void(^block)(UITextField *textField) = item.block;

                if (block) block(textField);

                textField.item = item;
            }
                break;

            default:
                break;
        }

    }];

    [self.config.modelActionArray enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL * _Nonnull stop) {

        void (^block)(GTUIDialogAction *action) = item;

        GTUIDialogAction *action = [[GTUIDialogAction alloc] init];

        if (block) block(action);

        if (!action.font) action.font = self.config.defaultActionFont;

        if (!action.title) action.title = @"按钮";

        if (!action.titleColor) action.titleColor = self.config.defaultActionTextColor;

        if (!action.backgroundColor) action.backgroundColor = self.config.actionBackgroundColor;

        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];

        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.84 alpha:1.0f];

        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;

        if (!action.borderPosition) action.borderPosition = (self.config.modelActionArray.count == 2 && idx == 0) ? GTUIActionBorderPositionTop | GTUIActionBorderPositionRight : GTUIActionBorderPositionTop;

        if (!action.height) action.height = 45.0f;

        GTUIDialogActionButton *button = [GTUIDialogActionButton buttonWithType: UIButtonTypeCustom];

        button.action = action;

        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [self.alertView addSubview:button];

        [self.alertActionArray addObject:button];

        button.heightChangedBlock = ^{

            if (weakSelf) [weakSelf updateAlertLayout];
        };

        // 更新布局
        [self updateAlertLayout];

    }];

}


- (void)buttonAction:(UIButton *)sender{

    BOOL isClose = NO;

    void (^clickBlock)(void) = nil;

    for (GTUIDialogActionButton *button in self.alertActionArray) {

        if (button == sender) {

            switch (button.action.type) {

                case GTUIActionTypeDefault:

                    isClose = button.action.isClickNotClose ? NO : YES;

                    break;

                case GTUIActionTypeCancel:

                    isClose = YES;

                    break;

                case GTUIActionTypeDestructive:

                    isClose = YES;

                    break;

                default:
                    break;
            }

            if (isClose) {

                __weak typeof(self) weakSelf = self;

                [self.presentingViewController dismissViewControllerAnimated:YES completion:^(void){
                    //关闭回调
                    if (weakSelf.closeFinishHandler)  weakSelf.closeFinishHandler();

                    if (clickBlock) clickBlock();
                }];

            } else {

                if (clickBlock) clickBlock();
            }
            break;
        }
    }

}


#pragma mark Tool

- (UIView *)findFirstResponder:(UIView *)view{

    if (view.isFirstResponder) return view;

    for (UIView *subView in view.subviews) {

        UIView *firstResponder = [self findFirstResponder:subView];

        if (firstResponder) return firstResponder;
    }

    return nil;
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    return (touch.view == self.alertView) ? YES : NO;
}

#pragma mark LazyLoading

- (UIScrollView *)alertView{

    if (!_alertView) {

        _alertView = [[UIScrollView alloc] init];

        _alertView.backgroundColor = self.config.headerColor;

        _alertView.directionalLockEnabled = YES;

        _alertView.bounces = NO;

    }

    return _alertView;
}

- (NSMutableArray *)alertItemArray{

    if (!_alertItemArray) _alertItemArray = [NSMutableArray array];

    return _alertItemArray;
}

- (NSMutableArray <GTUIDialogActionButton *>*)alertActionArray{

    if (!_alertActionArray) _alertActionArray = [NSMutableArray array];

    return _alertActionArray;
}


@end
