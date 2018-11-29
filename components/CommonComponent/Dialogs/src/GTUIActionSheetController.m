//
//  GTUIActionSheetController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/27.
//

#import "GTUIActionSheetController.h"
#import "GTBottomSheet.h"

#define DEFAULTBORDERWIDTH (1.0f / [[UIScreen mainScreen] scale] + 0.02f)
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

@interface GTUIActionSheetController ()

@property (nonatomic , strong ) UIScrollView *containView;

@property (nonatomic , strong ) UIScrollView *actionSheetView;

@property (nonatomic , strong ) NSMutableArray <id>*actionSheetItemArray;

@property (nonatomic , strong ) NSMutableArray <GTUIDialogActionButton *>*actionSheetActionArray;

@property (nonatomic , strong ) UIView *actionSheetCancelActionSpaceView;

@property (nonatomic , strong ) GTUIDialogActionButton *actionSheetCancelAction;

@end

@implementation GTUIActionSheetController

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title
                                 message:(NSString *)message {
    GTUIActionSheetController *actionSheetController = [[GTUIActionSheetController alloc] initWithTitle:title message:message customView:nil config: nil];
    return actionSheetController;
}

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                              customView:(UIView *)customView {
    GTUIActionSheetController *actionSheetController = [[GTUIActionSheetController alloc] initWithTitle:title message:message customView:customView config: nil];
    return actionSheetController;
}

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                              customView:(UIView *)customView
                                  config:(GTUIDialogConfigModel *)config
{
    GTUIActionSheetController *actionSheetController = [[GTUIActionSheetController alloc] initWithTitle:title message:message customView:customView config: config];
    return actionSheetController;
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
        self.automaticallyAdjustsScrollViewInsets = NO;
        _transitionController = [[GTUIBottomSheetTransitionController alloc] init];

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

        //配置过渡动画
        _transitionController.dismissOnBackgroundTap = self.config.dismissOnBackgroundTap;
        _transitionController.trackingScrollView = self.containView;
    }
    return self;
}


- (NSArray<GTUIDialogAction *> *)actions {
    return self.config.modelActionArray;
}


- (void)dealloc{

    _containView = nil;

    _actionSheetView = nil;

    _actionSheetCancelAction = nil;

    _actionSheetActionArray = nil;
}

- (void)viewDidLoad{

    [super viewDidLoad];

    [self configActionSheet];
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];

    [self updateActionSheetLayout];
}

- (void)viewSafeAreaInsetsDidChange{

    [super viewSafeAreaInsetsDidChange];

    [self updateActionSheetLayout];
}

- (void)updateActionSheetLayout{

    [self updateActionSheetLayoutWithViewWidth:CGRectGetWidth(self.view.bounds) ViewHeight:CGRectGetHeight(self.view.bounds)];
}

- (void)updateActionSheetLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight {

    CGFloat actionSheetViewMaxWidth = self.config.actionSheetMaxWidth;

    CGFloat actionSheetViewMaxHeight = self.config.actionSheetMaxHeight;

    [UIView setAnimationsEnabled:NO];

    __block CGFloat actionSheetViewHeight = 0.0f;

    [self.actionSheetItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {

        if (idx == 0) actionSheetViewHeight += self.config.headerInsets.top;

        if ([item isKindOfClass:UIView.class]) {

            GTUIDialogItemView *view = (GTUIDialogItemView *)item;

            CGRect viewFrame = view.frame;

            viewFrame.origin.x = self.config.headerInsets.left + view.item.insets.left + VIEWSAFEAREAINSETS(view).left;

            viewFrame.origin.y = actionSheetViewHeight + view.item.insets.top;

            viewFrame.size.width = actionSheetViewMaxWidth - viewFrame.origin.x - self.config.headerInsets.right - view.item.insets.right - VIEWSAFEAREAINSETS(view).left - VIEWSAFEAREAINSETS(view).right;

            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;

            view.frame = viewFrame;

            actionSheetViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;

        } else if ([item isKindOfClass:GTUIDialogItemCustomView.class]) {

            GTUIDialogItemCustomView *custom = (GTUIDialogItemCustomView *)item;

            CGRect viewFrame = custom.view.frame;

            if (custom.isAutoWidth) {

                custom.positionType = self.config.customViewPositionType;

                viewFrame.size.width = actionSheetViewMaxWidth - self.config.headerInsets.left - custom.item.insets.left - self.config.headerInsets.right - custom.item.insets.right;
            }

            switch (custom.positionType) {

                case GTUICustomViewPositionTypeCenter:

                    viewFrame.origin.x = (actionSheetViewMaxWidth - viewFrame.size.width) * 0.5f;

                    break;

                case GTUICustomViewPositionTypeLeft:

                    viewFrame.origin.x = self.config.headerInsets.left + custom.item.insets.left;

                    break;

                case GTUICustomViewPositionTypeRight:

                    viewFrame.origin.x = actionSheetViewMaxWidth - self.config.headerInsets.right - custom.item.insets.right - viewFrame.size.width;

                    break;

                default:
                    break;
            }

            viewFrame.origin.y = actionSheetViewHeight + custom.item.insets.top;

            custom.view.frame = viewFrame;

            actionSheetViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }

        if (item == self.actionSheetItemArray.lastObject) actionSheetViewHeight += self.config.headerInsets.bottom;
    }];

    for (GTUIDialogActionButton *button in self.actionSheetActionArray) {

        CGRect buttonFrame = button.frame;

        buttonFrame.origin.x = button.action.insets.left;

        buttonFrame.origin.y = actionSheetViewHeight + button.action.insets.top;

        buttonFrame.size.width = actionSheetViewMaxWidth - button.action.insets.left - button.action.insets.right;

        button.frame = buttonFrame;

        actionSheetViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }

    self.actionSheetView.contentSize = CGSizeMake(actionSheetViewMaxWidth, actionSheetViewHeight);

    [UIView setAnimationsEnabled:YES];

    CGFloat cancelActionTotalHeight = self.actionSheetCancelAction ? self.actionSheetCancelAction.action.height + self.config.actionSheetCancelActionSpaceWidth : 0.0f;

    CGFloat bottomMargin = self.config.actionSheetBottomMargin;
    if (@available(iOS 11.0, *)) bottomMargin = VIEWSAFEAREAINSETS(self.view).bottom;

    CGRect actionSheetViewFrame = self.actionSheetView.frame;

    actionSheetViewFrame.size.width = actionSheetViewMaxWidth;

    actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight - cancelActionTotalHeight - bottomMargin ? actionSheetViewMaxHeight - cancelActionTotalHeight - bottomMargin: actionSheetViewHeight;

    actionSheetViewFrame.origin.x = (viewWidth - actionSheetViewMaxWidth) * 0.5f;

    self.actionSheetView.frame = actionSheetViewFrame;

    if (self.actionSheetCancelAction) {

        CGRect spaceFrame = self.actionSheetCancelActionSpaceView.frame;

        spaceFrame.origin.x = actionSheetViewFrame.origin.x;

        spaceFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height;

        spaceFrame.size.width = actionSheetViewMaxWidth;

        spaceFrame.size.height = self.config.actionSheetCancelActionSpaceWidth;

        self.actionSheetCancelActionSpaceView.frame = spaceFrame;

        CGRect buttonFrame = self.actionSheetCancelAction.frame;

        buttonFrame.origin.x = actionSheetViewFrame.origin.x;

        buttonFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height + spaceFrame.size.height;

        buttonFrame.size.width = actionSheetViewMaxWidth;

        self.actionSheetCancelAction.frame = buttonFrame;
    }

    CGRect containerFrame = self.containView.frame;

    containerFrame.size.width = viewWidth;

    containerFrame.size.height = actionSheetViewFrame.size.height + cancelActionTotalHeight;

    containerFrame.origin.x = 0;

    self.containView.frame = containerFrame;

    self.containView.contentSize = CGSizeMake(viewWidth, containerFrame.size.height);

    self.preferredContentSize = self.containView.frame.size;

    self.gtui_bottomSheetPresentationController.preferredSheetHeight = CGRectGetHeight(containerFrame);

}

- (void)configActionSheet {

    __weak typeof(self) weakSelf = self;

    [self.view addSubview: self.containView];

    [self.containView addSubview: self.actionSheetView];

    self.view.backgroundColor = self.config.backgroundColor;

    self.containView.backgroundColor = self.config.actionSheetBackgroundColor;

    self.actionSheetView.layer.shadowOffset = self.config.shadowOffset;

    self.actionSheetView.layer.shadowRadius = self.config.shadowRadius;

    self.actionSheetView.layer.shadowOpacity = self.config.shadowOpacity;

    self.actionSheetView.layer.shadowColor = self.config.shadowColor.CGColor;

    self.actionSheetView.layer.cornerRadius = self.config.cornerRadius;

    self.gtui_bottomSheetPresentationController.closeFinishHandler = ^{
        if (weakSelf.closeFinishHandler) weakSelf.closeFinishHandler();
    };

    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

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

                [self.actionSheetView addSubview:label];

                [self.actionSheetItemArray addObject:label];

                label.textAlignment = self.config.titleTextAlignment;

                label.font = self.config.titleFont;

                label.textColor = self.config.titleTextColor;

                label.numberOfLines = 0;

                if (block) block(label);

                label.item = item;

                label.textChangedBlock = ^{

                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;

            case GTUIItemTypeMessage:
            {
                void(^block)(UILabel *label) = item.block;

                GTUIDialogItemLabel *label = [GTUIDialogItemLabel label];

                [self.actionSheetView addSubview:label];

                [self.actionSheetItemArray addObject:label];

                label.textAlignment = self.config.messageTextAlignment;

                label.font = self.config.messageFont;

                label.textColor = self.config.messageTextColor;

                label.numberOfLines = 0;

                if (block) block(label);

                label.item = item;

                label.textChangedBlock = ^{

                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;

            case GTUIItemTypeCustomView:
            {
                void(^block)(GTUIDialogItemCustomView *) = item.block;

                GTUIDialogItemCustomView *custom = [[GTUIDialogItemCustomView alloc] init];

                block(custom);

                [self.actionSheetView addSubview:custom.view];

                [self.actionSheetItemArray addObject:custom];

                custom.item = item;

                custom.sizeChangedBlock = ^{

                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
            default:
                break;
        }

    }];

    for (id item in self.config.modelActionArray) {

        void (^block)(GTUIDialogAction *action) = item;

        GTUIDialogAction *action = [[GTUIDialogAction alloc] init];

        if (block) block(action);

        if (!action.font) action.font = self.config.defaultActionFont;

        if (!action.title) action.title = @"按钮";

        if (!action.titleColor) action.titleColor = self.config.defaultActionTextColor;

        if (!action.backgroundColor) action.backgroundColor = self.config.actionBackgroundColor;

        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];

        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.86 alpha:1.0f];

        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;

        if (!action.height) action.height = 57.0f;

        GTUIDialogActionButton *button = [GTUIDialogActionButton buttonWithType:UIButtonTypeCustom];

        switch (action.type) {

            case GTUIActionTypeCancel:
            {
                [button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];

                button.layer.cornerRadius = self.config.cornerRadius;

                button.backgroundColor = action.backgroundColor;

                [self.containView addSubview:button];

                self.actionSheetCancelAction = button;

                self.actionSheetCancelActionSpaceView = [[UIView alloc] init];

                self.actionSheetCancelActionSpaceView.backgroundColor = self.config.actionSheetCancelActionSpaceColor;

                [self.containView addSubview:self.actionSheetCancelActionSpaceView];
            }
                break;

            default:
            {
                if (!action.borderPosition) action.borderPosition = GTUIActionBorderPositionTop;

                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

                [self.actionSheetView addSubview:button];

                [self.actionSheetActionArray addObject:button];
            }
                break;
        }

        button.action = action;

        button.heightChangedBlock = ^{

            if (weakSelf) [weakSelf updateActionSheetLayout];
        };
    }

    // 更新布局

    [self updateActionSheetLayout];
}

- (void)buttonAction:(UIButton *)sender{

    BOOL isClose = NO;

    void (^clickBlock)(void) = nil;

    for (GTUIDialogActionButton *button in self.actionSheetActionArray) {

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

            clickBlock = button.action.clickBlock;

            break;
        }

    }

    if (isClose) {

        __weak typeof(self) weakSelf = self;

        [self.presentingViewController dismissViewControllerAnimated:YES completion:^(void){
            //关闭完成
            if (weakSelf.closeFinishHandler)  weakSelf.closeFinishHandler();


            if (clickBlock) clickBlock();

        }];

    } else {

        if (clickBlock) clickBlock();
    }

}

- (void)cancelButtonAction:(UIButton *)sender{

    void (^clickBlock)(void) = self.actionSheetCancelAction.action.clickBlock;

    __weak typeof(self) weakSelf = self;

    [self.presentingViewController dismissViewControllerAnimated:YES completion:^(void){
        //关闭完成
        if (weakSelf.closeFinishHandler)  weakSelf.closeFinishHandler();

        if (clickBlock) clickBlock();

    }];

}


- (UIScrollView *)trackingScrollView {
    return self.transitionController.trackingScrollView;
}

- (void)setTrackingScrollView:(UIScrollView *)trackingScrollView {
    self.transitionController.trackingScrollView = trackingScrollView;
}

- (BOOL)dismissOnBackgroundTap {
    return self.transitionController.dismissOnBackgroundTap;
}

- (void)setDismissOnBackgroundTap:(BOOL)dismissOnBackgroundTap {
    _transitionController.dismissOnBackgroundTap = dismissOnBackgroundTap;
    self.gtui_bottomSheetPresentationController.dismissOnBackgroundTap = dismissOnBackgroundTap;
}

/* Disable setter. Always use internal transition controller */
- (void)setTransitioningDelegate:
(__unused id<UIViewControllerTransitioningDelegate>)transitioningDelegate {
    NSAssert(NO, @"GTUIActionSheetController.transitioningDelegate cannot be changed.");
    return;
}

/* Disable setter. Always use custom presentation style */
- (void)setModalPresentationStyle:(__unused UIModalPresentationStyle)modalPresentationStyle {
    NSAssert(NO, @"GTUIActionSheetController.modalPresentationStyle cannot be changed.");
    return;
}


#pragma mark LazyLoading


- (UIScrollView *)containView{

    if (!_containView) {

        _containView = [[UIScrollView alloc] init];

        _containView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                         | UIViewAutoresizingFlexibleHeight);

        _containView.backgroundColor = self.config.actionBackgroundColor;

        _containView.directionalLockEnabled = YES;

        _containView.bounces = NO;

        _containView.scrollEnabled = NO;

        if (@available(iOS 11.0, *)) {
            _actionSheetView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

    }

    return _containView;
}


- (UIScrollView *)actionSheetView{

    if (!_actionSheetView) {

        _actionSheetView = [[UIScrollView alloc] init];



        _actionSheetView.backgroundColor = self.config.headerColor;

        _actionSheetView.directionalLockEnabled = YES;

        _actionSheetView.bounces = NO;

        if (@available(iOS 11.0, *)) {
            _actionSheetView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }

    return _actionSheetView;
}

- (NSMutableArray <id>*)actionSheetItemArray{

    if (!_actionSheetItemArray) _actionSheetItemArray = [NSMutableArray array];

        return _actionSheetItemArray;
}

- (NSMutableArray <GTUIDialogActionButton *>*)actionSheetActionArray{

    if (!_actionSheetActionArray) _actionSheetActionArray = [NSMutableArray array];

        return _actionSheetActionArray;
}

@end




