//
//  GTUIActionSheetController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import "GTUIActionSheetController.h"

#import "GTMath.h"
#import "GTTypography.h"
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
        _tableView.estimatedRowHeight = 56.f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        _backgroundColor = UIColor.clearColor;
        _header.backgroundColor = self.headerBackgroundColor;
        _tableView.backgroundColor = self.backgroundColor;
        _actionTextColor = [UIColor.blackColor colorWithAlphaComponent:kActionTextAlpha];
        _actionTintColor = [UIColor.blackColor colorWithAlphaComponent:kActionImageAlpha];
        _actionImageRenderingMode = UIImageRenderingModeAlwaysTemplate;

        _footContainView = [[UIView alloc] init];

//
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.estimatedRowHeight = 56.f;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerClass:[GTUIActionSheetItemTableViewCell class]
//           forCellReuseIdentifier:kReuseIdentifier];
//
//        if (@available(iOS 11.0, *)) {
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
//
//        _header = [[GTUIActionSheetHeaderView alloc] initWithFrame:CGRectZero];
//        _header.title = [title copy];
//        _header.message = [message copy];
//        _header.backgroundColor = self.headerBackgroundColor;
//        _header.titleAlignment = self.titleAlignment;
//        _header.messageAlignment = self.messageAlignment;
//        _tableView.backgroundColor = self.actionBackgroundColor;
//
//
//        _footContainView = [[UIView alloc] init];
//        _footContainView.backgroundColor = UIColor.greenColor;
//        _cancelItemView.backgroundColor = UIColor.yellowColor;
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configDefaultActionSheetType:(GTUIActionSheetType)type {
    switch (type) {
        case GTUIActionSheetTypeNormal:
            self.backgroundColor = [UIColor blueColor];
            self.headerBackgroundColor = [UIColor whiteColor];
            self.actionBackgroundColor = [UIColor redColor];
            self.titleFont = [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleSubheadline];
            self.messageFont = [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleBody1];
            self.actionImageRenderingMode = UIImageRenderingModeAlwaysTemplate;
            self.actionSheetMaxWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 40;
            self.cancelActionSpaceWidth = 10;
            self.actionSheetBottomMargin = 10;
            self.cornerRadius = 13;
            self.titleAlignment = NSTextAlignmentCenter;
            self.messageAlignment = NSTextAlignmentCenter;

            break;
        case GTUIActionSheetTypeUIKit:
            self.backgroundColor = UIColor.whiteColor;
            break;
        case GTUIActionSheetTypeMaterial:
            self.backgroundColor = UIColor.whiteColor;
            break;

        default:
            break;
    }
}

- (void)addAction:(GTUIActionSheetAction *)action {
    if (action.type == GTUIActionSheetActionTypeCancel) {
        _cancelAction = action;
        self.cancelItemView = [[GTUIActionSheetItemView alloc] initWithType:self.actionSheetType];
        self.cancelItemView.backgroundColor = self.actionBackgroundColor;
        self.cancelItemView.action = _cancelAction;
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
//
//    self.view.backgroundColor = self.backgroundColor;
//    self.scrollView.frame = self.view.bounds;
//    CGFloat x = (CGRectGetWidth(self.view.bounds) - self.actionSheetMaxWidth)/2;
//    self.contentView.frame = CGRectMake(x, 0, self.actionSheetMaxWidth, CGRectGetHeight(self.scrollView.bounds));
//    self.tableView.frame = CGRectMake(0, 0, self.actionSheetMaxWidth, CGRectGetHeight(self.scrollView.bounds));
//
//    self.contentView.backgroundColor = UIColor.yellowColor;
//    self.tableView.backgroundColor = UIColor.redColor;
//
//    [self.view addSubview:self.scrollView];
//    [self.scrollView addSubview:self.contentView];
//
//    [self.contentView addSubview:self.tableView];
//    [self.contentView addSubview:self.header];
//    [self.scrollView addSubview:self.footContainView];
//    [self.footContainView addSubview:self.cancelItemView];

    self.tableView.backgroundColor = UIColor.redColor;
    self.view.backgroundColor = self.backgroundColor;
    self.scrollView.frame = self.view.bounds;
    CGFloat x = (CGRectGetWidth(self.view.bounds) - self.actionSheetMaxWidth)/2;
    self.contentView.frame = CGRectMake(x, 0, self.actionSheetMaxWidth, CGRectGetHeight(self.scrollView.bounds));
    self.tableView.frame = self.contentView.bounds;

//    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.header];

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
    CGFloat cellHeight = self.tableView.contentSize.height / (CGFloat)_actions.count;
    CGFloat cancelItemHeight = (!_cancelAction) ? 0 : cellHeight;
    CGFloat cancelItemY = (!_cancelAction) ? 0 : self.cancelActionSpaceWidth;
    CGFloat footHeight = cancelItemHeight + cancelItemY;
    CGFloat maxTableHeight = CGRectGetHeight(self.view.bounds) - headerHeight - footHeight;
    CGFloat tableHeight = MIN(self.tableView.contentSize.height, maxTableHeight);

    self.header.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), headerHeight);
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), tableHeight + headerHeight);
    self.contentView.frame = CGRectMake(x, 0, CGRectGetWidth(bounds), headerHeight + tableHeight);
    self.footContainView.frame = CGRectMake(x, CGRectGetMaxY(self.contentView.frame), CGRectGetWidth(bounds), footHeight);
    self.cancelItemView.frame = CGRectMake(0, cancelItemY, CGRectGetWidth(bounds), cancelItemHeight);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), headerHeight + tableHeight + footHeight);

    UIEdgeInsets insets = UIEdgeInsetsMake(self.header.frame.size.height, 0, 0, 0);
    self.tableView.contentInset = insets;

//    if (self.tableView.contentSize.height > (CGRectGetHeight(self.view.bounds) / 2)) {
//        self.gtui_bottomSheetPresentationController.preferredSheetHeight = [self openingSheetHeight];
//    } else {
//        self.gtui_bottomSheetPresentationController.preferredSheetHeight = 0;
//    }

//
//    self.tableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0);
//    self.tableView.contentOffset = CGPointMake(0, -headerHeight);
//
//
//    self.header.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), headerHeight);
//    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), tableHeight + headerHeight);
//    self.contentView.frame = CGRectMake(x, 0, CGRectGetWidth(bounds), headerHeight + tableHeight);
//
//    self.footContainView.frame = CGRectMake(x, CGRectGetMaxY(self.contentView.frame), CGRectGetWidth(bounds), footHeight);
//    self.cancelItemView.frame = CGRectMake(0, cancelItemY, CGRectGetWidth(bounds), cancelItemHeight);
//    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), headerHeight + tableHeight + footHeight);
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
    NSInteger amountOfCellsToShow = (NSInteger)(maxTableHeight / cellHeight);
    // There is already a partially shown cell that is showing and more than half is visable
    if (fmod(maxTableHeight, cellHeight) > (cellHeight * 0.5f)) {
        amountOfCellsToShow += 1;
    }
    CGFloat preferredHeight = (((CGFloat)amountOfCellsToShow - 0.5f) * cellHeight) + headerHeight + footHeight;
    // When updating the preferredSheetHeight the presentation controller takes into account the
    // safe area so we have to remove that.
    if (@available(iOS 11.0, *)) {
        preferredHeight = preferredHeight - self.view.safeAreaInsets.bottom;
    }

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
    [self.tableView setNeedsLayout];
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

@end

