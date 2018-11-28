//
//  GTUIActionSheetController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import "GTUIActionSheetController.h"

#import "GTMath.h"
#import "GTTypography.h"
#import "GTUIMetrics.h"
#import "GTBottomSheet.h"
#import "private/GTUIActionSheetHeaderView.h"
#import "private/GTUIActionSheetItemTableViewCell.h"

static NSString *const kReuseIdentifier = @"BaseCell";
static const CGFloat kActionImageAlpha = 0.6f;
static const CGFloat kActionTextAlpha = 0.87f;

@interface GTUIActionSheetAction ()

@property(nonatomic, nullable, copy) GTUIActionSheetHandler completionHandler;

@end

@implementation GTUIActionSheetAction

+ (instancetype)actionWithTitle:(NSString *)title
                          image:(UIImage *)image
                           type:(GTUIActionSheetActionType)type
                        handler:(void (^__nullable)(GTUIActionSheetAction *action))handler {
    return [[GTUIActionSheetAction alloc] initWithTitle:title
                                                 image:image
                                                   type:type
                                               handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                         type:(GTUIActionSheetActionType)type
                      handler:(void (^__nullable)(GTUIActionSheetAction *action))handler {
    self = [super init];
    if (self) {
        _title = [title copy];
        _image = [image copy];
        _type = type;
        _completionHandler = [handler copy];
    }
    return self;
}

- (id)copyWithZone:(__unused NSZone *)zone {
    GTUIActionSheetAction *action = [[self class] actionWithTitle:self.title
                                                           image:self.image
                                                             type:self.type
                                                         handler:self.completionHandler];
    action.accessibilityIdentifier = self.accessibilityIdentifier;
    return action;
}

@end

@interface GTUIActionSheetController () <GTUIBottomSheetPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) GTUIActionSheetHeaderView *header;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *footContainView;
@property(nonatomic, strong) GTUIActionSheetItemView *cancelItemView;
@end

@implementation GTUIActionSheetController {
    NSMutableArray<GTUIActionSheetAction *> *_actions;
    GTUIActionSheetAction *_cancelAction;
}

@synthesize gtui_adjustsFontForContentSizeCategory = _gtui_adjustsFontForContentSizeCategory;

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title message:(NSString *)message customView:(UIView *)customView type:(GTUIActionSheetType)type {
    return [[GTUIActionSheetController alloc] initWithTitle:title message:message customView:customView
                          type:type];
}

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title message:(NSString *)message type:(GTUIActionSheetType)type {
    return [[GTUIActionSheetController alloc] initWithTitle:title message:message customView:nil type:type];
}

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title message:(NSString *)message {
    return [[GTUIActionSheetController alloc] initWithTitle:title message:message];
}

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title {
    return [GTUIActionSheetController actionSheetControllerWithTitle:title message:nil];
}

- (instancetype)init {
    return [GTUIActionSheetController actionSheetControllerWithTitle:nil message:nil];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    return [self initWithTitle:title message:message customView:nil type:GTUIActionSheetTypeNormal];
}


- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                                               message:(nullable NSString *)message
                                            customView:(UIView *)customView
                                                  type:(GTUIActionSheetType)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self configDefaultActionSheetType:type];
        _actionSheetType = type;
        _actions = [[NSMutableArray alloc] init];
        _transitionController = [[GTUIBottomSheetTransitionController alloc] init];
        _transitionController.dismissOnBackgroundTap = YES;
        super.transitioningDelegate = _transitionController;
        super.modalPresentationStyle = UIModalPresentationCustom;
        /**
         "We must call super because we've made the setters on this class unavailable and overridden
         their implementations to throw assertions."
         */
        super.transitioningDelegate = _transitionController;
        super.modalPresentationStyle = UIModalPresentationCustom;

        _scrollView = [[UIScrollView alloc] init];
        _transitionController.trackingScrollView = _scrollView;
        _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                       | UIViewAutoresizingFlexibleHeight);

        _contentView = [[UIView alloc] init];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = self.actionHeight;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = self.actionBackgroundColor;
        [_tableView registerClass:[GTUIActionSheetItemTableViewCell class]
           forCellReuseIdentifier:kReuseIdentifier];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _header = [[GTUIActionSheetHeaderView alloc] initWithFrame:CGRectZero];
        _header.title = [title copy];
        _header.message = [message copy];
        _header.customView = customView;
        _header.titleAlignment = self.titleAlignment;
        _header.messageAlignment = self.messageAlignment;
        _header.backgroundColor = self.headerBackgroundColor;
        _actionImageRenderingMode = UIImageRenderingModeAlwaysTemplate;

        _footContainView = [[UIView alloc] init];
        _footContainView.backgroundColor = self.cancelActionSpaceColor;

        self.contentView.layer.cornerRadius = self.cornerRadius;
        self.contentView.layer.masksToBounds = true;
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configDefaultActionSheetType:(GTUIActionSheetType)type {
    switch (type) {
        case GTUIActionSheetTypeNormal:
            _backgroundColor = [UIColor whiteColor];
            _headerBackgroundColor = [UIColor whiteColor];
            _actionBackgroundColor = [UIColor whiteColor];
            _cancelActionSpaceColor = [UIColor colorWithWhite:0.92 alpha:1.0f];
            _actionTextColor = [UIColor.blackColor colorWithAlphaComponent:kActionTextAlpha];
            _actionTintColor = [UIColor.blackColor colorWithAlphaComponent:kActionImageAlpha];
            _titleAlignment = NSTextAlignmentCenter;
            _messageAlignment = NSTextAlignmentCenter;
            self.titleFont = [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleSubheadline];
            self.messageFont = [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleBody1];
            _actionImageRenderingMode = UIImageRenderingModeAlwaysTemplate;
            _actionSheetMaxWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
            _cancelActionSpaceWidth = 10;
            _actionHeight = 56;
            _cornerRadius = 0;
            _actionSheetBottomMargin = 0;

            break;
        case GTUIActionSheetTypeUIKit:
            _backgroundColor = [UIColor clearColor];
            _headerBackgroundColor = [UIColor whiteColor];
            _actionBackgroundColor = [UIColor whiteColor];
            _cancelActionSpaceColor = [UIColor clearColor];
            _actionTextColor = [UIColor.blackColor colorWithAlphaComponent:kActionTextAlpha];
            _actionTintColor = [UIColor.blackColor colorWithAlphaComponent:kActionImageAlpha];
            _titleAlignment = NSTextAlignmentCenter;
            _messageAlignment = NSTextAlignmentCenter;
            self.titleFont = [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleSubheadline];
            self.messageFont = [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleBody1];
            _actionImageRenderingMode = UIImageRenderingModeAlwaysTemplate;
            _actionSheetMaxWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 40;
            _cancelActionSpaceWidth = 10;
            _actionHeight = 56;
            _cornerRadius = 13;
            _actionSheetBottomMargin = 13;
            break;
        case GTUIActionSheetTypeMaterial:
            _backgroundColor = [UIColor clearColor];
            _headerBackgroundColor = [UIColor whiteColor];
            _actionBackgroundColor = [UIColor whiteColor];
            _cancelActionSpaceColor = [UIColor clearColor];
            _actionTextColor = [UIColor.blackColor colorWithAlphaComponent:kActionTextAlpha];
            _actionTintColor = [UIColor.blackColor colorWithAlphaComponent:kActionImageAlpha];
            _titleAlignment = NSTextAlignmentCenter;
            _messageAlignment = NSTextAlignmentCenter;
            self.titleFont = [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleSubheadline];
            self.messageFont = [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleBody1];
            _actionImageRenderingMode = UIImageRenderingModeAlwaysTemplate;
            _actionSheetMaxWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 40;
            _cancelActionSpaceWidth = 10;
            _actionHeight = 56;
            _cornerRadius = 13;
            _actionSheetBottomMargin = 13;
            break;
        default:
            break;
    }
}

- (void)addAction:(GTUIActionSheetAction *)action {
    if (action.type == GTUIActionSheetActionTypeCancel) {
        _cancelAction = action;
        [self setCancelItemViewAction:_cancelAction];
    } else {
        [_actions addObject:action];
    }
    [self updateTable];
}

- (NSArray<GTUIActionSheetAction *> *)actions {
    return [_actions copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.backgroundColor;
    self.scrollView.frame = self.view.bounds;
    CGFloat x = (CGRectGetWidth(self.view.bounds) - self.actionSheetMaxWidth)/2;
    self.contentView.frame = CGRectMake(x, 0, self.actionSheetMaxWidth, CGRectGetHeight(self.scrollView.bounds));
    self.tableView.frame = self.contentView.bounds;

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.header];
    [self.scrollView addSubview:self.footContainView];
    [self.footContainView addSubview:self.cancelItemView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (self.tableView.contentSize.height > (CGRectGetHeight(self.view.bounds) / 2)) {
        self.gtui_bottomSheetPresentationController.preferredSheetHeight = [self openingSheetHeight];
    } else {
        self.gtui_bottomSheetPresentationController.preferredSheetHeight = 0;
    }
    

    CGFloat x = (CGRectGetWidth(self.view.bounds) - self.actionSheetMaxWidth)/2;
    CGRect bounds = CGRectMake(x, 0, self.actionSheetMaxWidth, CGRectGetHeight(self.view.bounds));
    CGFloat headerHeight = [self.header sizeThatFits:CGRectStandardize(bounds).size].height;
    CGFloat cellHeight = self.actionHeight;
    CGFloat cancelItemHeight = (!_cancelAction) ? 0 : cellHeight;
    CGFloat cancelItemY = (!_cancelAction) ? 0 : self.cancelActionSpaceWidth;
    CGFloat footHeight = cancelItemHeight + cancelItemY;
    CGFloat maxTableHeight = CGRectGetHeight(self.view.bounds) - headerHeight - footHeight - GTUIDeviceTopSafeAreaInset() - GTUIDeviceBottomSafeAreaInset() - self.actionSheetBottomMargin;
    CGFloat tableHeight = MIN(((CGFloat)_actions.count * cellHeight), maxTableHeight);
    self.header.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), headerHeight);
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), tableHeight + headerHeight);
    self.tableView.contentInset = UIEdgeInsetsMake(self.header.frame.size.height, 0, 0, 0);;
    self.contentView.frame = CGRectMake(x, 0, CGRectGetWidth(bounds), headerHeight + tableHeight);
    self.footContainView.frame = CGRectMake(x, CGRectGetMaxY(self.contentView.frame), CGRectGetWidth(bounds), footHeight);
    self.cancelItemView.frame = CGRectMake(0, cancelItemY, CGRectGetWidth(bounds), cancelItemHeight);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), headerHeight + tableHeight + footHeight + self.actionSheetBottomMargin);
}

- (CGFloat)openingSheetHeight {
    // If there are too many options to fit on half of the screen then show as many options as
    // possible minus half a cell, to allow for bleeding and signal to the user that the sheet is
    // scrollable content.
    CGFloat maxHeight = CGRectGetHeight(self.view.bounds) / 2;
    CGFloat headerHeight = [self.header sizeThatFits:CGRectStandardize(self.view.bounds).size].height;
    CGFloat cellHeight = self.tableView.contentSize.height / (CGFloat)_actions.count;
    CGFloat cancelItemHeight = (!_cancelAction) ? 0 : cellHeight;
    CGFloat cancelItemY = (!_cancelAction) ? 0 : self.cancelActionSpaceWidth;
    CGFloat footHeight = cancelItemHeight + cancelItemY;
    CGFloat maxTableHeight = maxHeight - headerHeight - footHeight;
    if (GTUIDeviceBottomSafeAreaInset() == 0) {
        maxTableHeight -= self.actionSheetBottomMargin;
    }
    NSInteger amountOfCellsToShow = (NSInteger)(maxTableHeight / cellHeight);
    // There is already a partially shown cell that is showing and more than half is visable
    if (fmod(maxTableHeight, cellHeight) > (cellHeight * 0.5f)) {
        amountOfCellsToShow += 1;
    }
    CGFloat preferredHeight = (((CGFloat)amountOfCellsToShow - 0.5f) * cellHeight) + headerHeight + footHeight;
    // When updating the preferredSheetHeight the presentation controller takes into account the
    // safe area so we have to remove that.
    preferredHeight = preferredHeight - GTUIDeviceBottomSafeAreaInset();
    return GTUICeil(preferredHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.gtui_bottomSheetPresentationController.delegate = self;
#pragma clang diagnostic pop

    self.gtui_bottomSheetPresentationController.dismissOnBackgroundTap =
    self.transitionController.dismissOnBackgroundTap;
    [self.view layoutIfNeeded];
}

- (BOOL)accessibilityPerformEscape {
    if (!self.dismissOnBackgroundTap) {
        return NO;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    return YES;
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];

    [self.presentationController
     preferredContentSizeDidChangeForChildContentContainer:self];
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

#pragma mark - Table view

- (void)updateTable {
    [self.tableView reloadData];
    [self setCancelItemViewAction:_cancelAction];
    [self.view setNeedsLayout];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GTUIActionSheetAction *action = self.actions[indexPath.row];

    [self.presentingViewController dismissViewControllerAnimated:YES completion:^(void){
        if (action.completionHandler) {
            action.completionHandler(action);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GTUIActionSheetItemTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
    GTUIActionSheetAction *action = _actions[indexPath.row];
    cell.itemView.action = action;
    cell.itemView.type = self.actionSheetType;
    cell.itemView.gtui_adjustsFontForContentSizeCategory = self.gtui_adjustsFontForContentSizeCategory;
    cell.itemView.actionFont = self.actionFont;
    cell.itemView.accessibilityIdentifier = action.accessibilityIdentifier;
    cell.itemView.inkColor = self.inkColor;
    cell.itemView.tintColor = self.actionTintColor;
    cell.itemView.imageRenderingMode = self.actionImageRenderingMode;

    [cell setNeedsLayout];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.actionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


- (void)setCancelItemViewAction:(GTUIActionSheetAction *)cancelAction {
    if (self.cancelItemView == nil) {
        self.cancelItemView = [[GTUIActionSheetItemView alloc] initWithType:self.actionSheetType];
        [self.cancelItemView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelItemViewClick)]];
    }
    self.cancelItemView.type = self.actionSheetType;
    self.cancelItemView.gtui_adjustsFontForContentSizeCategory = self.gtui_adjustsFontForContentSizeCategory;
    self.cancelItemView.actionFont = self.actionFont;
    self.cancelItemView.accessibilityIdentifier = cancelAction.accessibilityIdentifier;
    self.cancelItemView.inkColor = self.inkColor;
    self.cancelItemView.tintColor = self.actionTintColor;
    self.cancelItemView.backgroundColor = self.actionBackgroundColor;
    self.cancelItemView.imageRenderingMode = self.actionImageRenderingMode;
    self.cancelItemView.layer.masksToBounds = YES;
    self.cancelItemView.cornerRadius = self.cornerRadius;
    self.cancelItemView.action = cancelAction;
}

- (void)cancelItemViewClick {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^(void){
        if (self->_cancelAction.completionHandler) {
            self->_cancelAction.completionHandler(self->_cancelAction);
        }
    }];
}

- (void)setTitle:(NSString *)title {
    self.header.title = title;
    [self.view setNeedsLayout];
}

- (NSString *)title {
    return self.header.title;
}

- (void)setMessage:(NSString *)message {
    self.header.message = message;
    [self.view setNeedsLayout];
}

- (NSString *)message {
    return self.header.message;
}

- (void)setCustomView:(UIView *)customView {
    self.header.customView = customView;
    [self.view setNeedsLayout];
}

- (UIView *)customView {
    return self.header.customView;
}


- (void)setTitleFont:(UIFont *)titleFont {
    self.header.titleFont = titleFont;
}

- (UIFont *)titleFont {
    return self.header.titleFont;
}

- (void)setMessageFont:(UIFont *)messageFont {
    self.header.messageFont = messageFont;
}

- (UIFont *)messageFont {
    return self.header.messageFont;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.view.backgroundColor = backgroundColor;
    self.tableView.backgroundColor = backgroundColor;
    self.header.backgroundColor = backgroundColor;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    self.header.titleTextColor = titleTextColor;
}

- (UIColor *)titleTextColor {
    return self.header.titleTextColor;
}

- (void)setMessageTextColor:(UIColor *)messageTextColor {
    self.header.messageTextColor = messageTextColor;
}

- (UIColor *)messageTextColor {
    return self.header.messageTextColor;
}

#pragma mark - Dynamic Type

- (void)gtui_setAdjustsFontForContentSizeCategory:(BOOL)adjusts {
    _gtui_adjustsFontForContentSizeCategory = adjusts;
    self.header.gtui_adjustsFontForContentSizeCategory = adjusts;
    [self updateFontsForDynamicType];
    if (_gtui_adjustsFontForContentSizeCategory) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateFontsForDynamicType)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIContentSizeCategoryDidChangeNotification
                                                      object:nil];
    }
    [self.view setNeedsLayout];
}

- (void)updateTableFonts {
    UIFont *finalActionsFont = _actionFont ?:
    [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleSubheadline];
    if (self.gtui_adjustsFontForContentSizeCategory) {
        finalActionsFont =
        [finalActionsFont gtui_fontSizedForFontTextStyle:GTUIFontTextStyleSubheadline
                                       scaledForDynamicType:self.gtui_adjustsFontForContentSizeCategory];
    }
    _actionFont = finalActionsFont;
    [self updateTable];
}

- (void)updateFontsForDynamicType {
    [self updateTableFonts];
    [self.view setNeedsLayout];
}

#pragma mark - Table customization

- (void)setActionFont:(UIFont *)actionFont {
    _actionFont = actionFont;
    [self updateTable];
}

- (void)setActionAlignment:(NSTextAlignment)actionAlignment {
    _actionAlignment = actionAlignment;
    [self updateTable];
}

- (void)setActionTextColor:(UIColor *)actionTextColor {
    _actionTextColor = actionTextColor;
    [self updateTable];
}

- (void)setActionTintColor:(UIColor *)actionTintColor {
    _actionTintColor = actionTintColor;
    [self updateTable];
}

- (void)setActionImageRenderingMode:(UIImageRenderingMode)actionImageRenderingMode {
    _actionImageRenderingMode = actionImageRenderingMode;
    [self updateTable];
}

- (void)setInkColor:(UIColor *)inkColor {
    _inkColor = inkColor;
    [self updateTable];
}

- (void)setActionCornerRadius:(CGFloat)actionCornerRadius {
    _actionCornerRadius = actionCornerRadius;
    [self updateTable];
}

- (void)setActionHeight:(CGFloat)actionHeight {
    _actionHeight = actionHeight;
    [self updateTable];
}

#pragma mark - ActionSheet 属性配置

- (void)setCancelActionSpaceWidth:(CGFloat)cancelActionSpaceWidth {
    _cancelActionSpaceWidth = cancelActionSpaceWidth;
    [self.view setNeedsLayout];
}

- (void)setActionSheetBottomMargin:(CGFloat)actionSheetBottomMargin {
    _actionSheetBottomMargin = actionSheetBottomMargin;
    [self.view setNeedsLayout];
}

- (void)setActionSheetMaxWidth:(CGFloat)actionSheetMaxWidth {
    _actionSheetMaxWidth = actionSheetMaxWidth;
    [self.view setNeedsLayout];
}


#pragma mark - 旋转

- (BOOL)shouldAutorotate{

    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - 状态栏

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleDefault;
}

@end

