//
//  GTUIAlertController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import "GTUIAlertController.h"

#import <GTFInternationalization/GTFInternationalization.h>

#import "GTUIAlertControllerView.h"
#import "GTUIDialogPresentationController.h"
#import "GTUIDialogTransitionController.h"
#import "GTButton.h"
#import "GTTypography.h"
#import "UIViewController+GTUIDialogs.h"
#import "private/GTUIAlertActionManager.h"
#import "private/GTUIAlertControllerView+Private.h"

@interface GTUIAlertAction ()

@property(nonatomic, nullable, copy) GTUIActionHandler completionHandler;

@end

@implementation GTUIAlertAction

+ (instancetype)actionWithTitle:(nonnull NSString *)title
                        handler:(void (^__nullable)(GTUIAlertAction *action))handler {
    return [[GTUIAlertAction alloc] initWithTitle:title emphasis:GTUIActionEmphasisLow handler:handler];
}

+ (instancetype)actionWithTitle:(nonnull NSString *)title
                       emphasis:(GTUIActionEmphasis)emphasis
                        handler:(void (^__nullable)(GTUIAlertAction *action))handler {
    return [[GTUIAlertAction alloc] initWithTitle:title emphasis:emphasis handler:handler];
}

- (instancetype)initWithTitle:(nonnull NSString *)title
                     emphasis:(GTUIActionEmphasis)emphasis
                      handler:(void (^__nullable)(GTUIAlertAction *action))handler {
    self = [super init];
    if (self) {
        _title = [title copy];
        _emphasis = emphasis;
        _completionHandler = [handler copy];
    }
    return self;
}

- (id)copyWithZone:(__unused NSZone *)zone {
    GTUIAlertAction *action = [[self class] actionWithTitle:self.title
                                                  emphasis:self.emphasis
                                                   handler:self.completionHandler];
    action.accessibilityIdentifier = self.accessibilityIdentifier;

    return action;
}

@end

@interface GTUIAlertController ()

@property(nonatomic, nullable, weak) GTUIAlertControllerView *alertView;
@property(nonatomic, strong) GTUIDialogTransitionController *transitionController;
@property(nonatomic, nonnull, strong) GTUIAlertActionManager *actionManager;

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message;

@end

@implementation GTUIAlertController{

    // This is because title is overlapping with view controller title, However Apple alertController
    // redefines title as well.
    NSString *_alertTitle;

    CGSize _previousLayoutSize;

    BOOL _gtui_adjustsFontForContentSizeCategory;
}


+ (instancetype)alertControllerWithTitle:(nullable NSString *)alertTitle
                                 message:(nullable NSString *)message {
    GTUIAlertController *alertController =
    [[GTUIAlertController alloc] initWithTitle:alertTitle message:message];

    return alertController;
}

- (instancetype)init {
    return [self initWithTitle:nil message:nil];
}

- (nonnull instancetype)initWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _transitionController = [[GTUIDialogTransitionController alloc] init];

        _alertTitle = [title copy];
        _message = [message copy];
        _titleAlignment = NSTextAlignmentNatural;
        _messageAlignment = NSTextAlignmentNatural;
        _actionManager = [[GTUIAlertActionManager alloc] init];

        super.transitioningDelegate = _transitionController;
        super.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
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

- (void)setTitle:(NSString *)title {
    _alertTitle = [title copy];
    if (self.alertView) {
        self.alertView.titleLabel.text = title;
        self.preferredContentSize =
        [self.alertView calculatePreferredContentSizeForBounds:CGRectInfinite.size];

    }
}

- (NSString *)title {
    return _alertTitle;
}

- (void)setMessage:(NSString *)message {
    _message = [message copy];
    if (self.alertView) {
        self.alertView.messageLabel.text = message;
        self.preferredContentSize =
        [self.alertView calculatePreferredContentSizeForBounds:CGRectInfinite.size];
    }
}

- (NSArray<GTUIAlertAction *> *)actions {
    return self.actionManager.actions;
}

- (void)addAction:(GTUIAlertAction *)action {
    [self.actionManager addAction:action];
    [self addButtonToAlertViewForAction:action];
}

- (nullable GTUIButton *)buttonForAction:(nonnull GTUIAlertAction *)action {
    GTUIButton *button = [self.actionManager buttonForAction:action];
    if (!button && [self.actionManager hasAction:action]) {
        button = [self.actionManager createButtonForAction:action
                                                    target:self
                                                  selector:@selector(actionButtonPressed:)];
        [GTUIAlertControllerView styleAsTextButton:button];
    }
    return button;
}

- (void)addButtonToAlertViewForAction:(GTUIAlertAction *)action {
    if (self.alertView) {
        GTUIButton *button = [self buttonForAction:action];
        [self.alertView addActionButton:button];
        self.preferredContentSize =
        [self.alertView calculatePreferredContentSizeForBounds:CGRectInfinite.size];
        [self.alertView setNeedsLayout];
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    if (self.alertView) {
        self.alertView.titleFont = titleFont;
    }
}

- (void)setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;
    if (self.alertView) {
        self.alertView.messageFont = messageFont;
    }
}

// b/117717380: Will be deprecated
- (void)setButtonFont:(UIFont *)buttonFont {
    _buttonFont = buttonFont;
    if (self.alertView) {
        self.alertView.buttonFont = buttonFont;
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    if (self.alertView) {
        self.alertView.titleColor = titleColor;
    }
}

- (void)setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;
    if (self.alertView) {
        self.alertView.messageColor = messageColor;
    }
}

// b/117717380: Will be deprecated
- (void)setButtonTitleColor:(UIColor *)buttonColor {
    _buttonTitleColor = buttonColor;
    if (self.alertView) {
        self.alertView.buttonColor = buttonColor;
    }
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    _titleAlignment = titleAlignment;
    if (self.alertView) {
        self.alertView.titleAlignment = titleAlignment;
    }
}

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment {
    _messageAlignment = messageAlignment;
    if (self.alertView) {
        self.alertView.messageAlignment = messageAlignment;
    }
}

- (void)setTitleIcon:(UIImage *)titleIcon {
    _titleIcon = titleIcon;
    if (self.alertView) {
        self.alertView.titleIcon = titleIcon;
    }
}

- (void)setTitleIconTintColor:(UIColor *)titleIconTintColor {
    _titleIconTintColor = titleIconTintColor;
    if (self.alertView) {
        self.alertView.titleIconTintColor = titleIconTintColor;
    }
}

- (void)setScrimColor:(UIColor *)scrimColor {
    _scrimColor = scrimColor;
    self.gtui_dialogPresentationController.scrimColor = scrimColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    if (self.alertView) {
        self.alertView.cornerRadius = cornerRadius;
    }
    self.gtui_dialogPresentationController.dialogCornerRadius = cornerRadius;
}

- (void)setElevation:(GTUIShadowElevation)elevation {
    _elevation = elevation;
    self.gtui_dialogPresentationController.dialogElevation = elevation;
}

- (void)gtui_setAdjustsFontForContentSizeCategory:(BOOL)adjusts {
    _gtui_adjustsFontForContentSizeCategory = adjusts;

    if (self.alertView) {
        self.alertView.gtui_adjustsFontForContentSizeCategory = adjusts;
        [self updateFontsForDynamicType];
    }
    if (_gtui_adjustsFontForContentSizeCategory) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contentSizeCategoryDidChange:)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIContentSizeCategoryDidChangeNotification
                                                      object:nil];
    }
}

// Handles UIContentSizeCategoryDidChangeNotifications
- (void)contentSizeCategoryDidChange:(__unused NSNotification *)notification {
    [self updateFontsForDynamicType];
}

// Update the fonts used based on gtui_preferredFontForMaterialTextStyle and recalculate the
// preferred content size.
- (void)updateFontsForDynamicType {
    if (self.alertView) {
        [self.alertView updateFonts];

        // Our presentation controller reacts to changes to preferredContentSize to determine our
        // frame at the presented controller.
        self.preferredContentSize =
        [self.alertView calculatePreferredContentSizeForBounds:CGRectInfinite.size];
    }
}

- (void)actionButtonPressed:(id)button {
    GTUIAlertAction *action = [self.actionManager actionForButton:button];

    // We call our action.completionHandler after we dismiss the existing alert in case the handler
    // also presents a view controller. Otherwise we get a warning about presenting on a controller
    // which is already presenting.
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^(void){
        if (action.completionHandler) {
            action.completionHandler(action);
        }
    }];
}

#pragma mark - UIViewController

- (void)loadView {
    self.view = [[GTUIAlertControllerView alloc] initWithFrame:CGRectZero];
    self.alertView = (GTUIAlertControllerView *)self.view;
    // sharing GTUIActionManager with with the alert view
    self.alertView.actionManager = self.actionManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupAlertView];

    _previousLayoutSize = CGSizeZero;
    CGSize idealSize = [self.alertView calculatePreferredContentSizeForBounds:CGRectInfinite.size];
    self.preferredContentSize = idealSize;

    self.preferredContentSize =
    [self.alertView calculatePreferredContentSizeForBounds:CGRectInfinite.size];

    [self.view setNeedsLayout];
}

- (void)setupAlertView {
    // Explicitly overwrite the view default if true
    if (_gtui_adjustsFontForContentSizeCategory) {
        self.alertView.gtui_adjustsFontForContentSizeCategory = YES;
    }
    self.alertView.titleLabel.text = self.title;
    self.alertView.messageLabel.text = self.message;
    self.alertView.titleFont = self.titleFont;
    self.alertView.messageFont = self.messageFont;
    self.alertView.titleColor = self.titleColor;
    self.alertView.messageColor = self.messageColor;
    if (self.buttonTitleColor) {
        // Avoid reset title color to white when setting it to nil. only set it for an actual UIColor.
        self.alertView.buttonColor = self.buttonTitleColor;  // b/117717380: Will be deprecated
    }
    self.alertView.buttonFont = self.buttonFont;  // b/117717380: Will be deprecated
    if (self.buttonInkColor) {
        // Avoid reset ink color to white when setting it to nil. only set it for an actual UIColor.
        self.alertView.buttonInkColor = self.buttonInkColor;  // b/117717380: Will be deprecated
    }
    self.alertView.titleAlignment = self.titleAlignment;
    self.alertView.messageAlignment = self.messageAlignment;
    self.alertView.titleIcon = self.titleIcon;
    self.alertView.titleIconTintColor = self.titleIconTintColor;
    self.alertView.cornerRadius = self.cornerRadius;

    // Create buttons for the actions (if not already created) and apply default styling
    for (GTUIAlertAction *action in self.actions) {
        [self addButtonToAlertViewForAction:action];
    }
}

- (void)viewDidLayoutSubviews {
    // Recalculate preferredSize, which is based on width available, if the viewSize has changed.
    if (CGRectGetWidth(self.view.bounds) != _previousLayoutSize.width ||
        CGRectGetHeight(self.view.bounds) != _previousLayoutSize.height) {
        CGSize currentPreferredContentSize = self.preferredContentSize;
        CGSize calculatedPreferredContentSize =
        [self.alertView calculatePreferredContentSizeForBounds:CGRectStandardize(self.alertView.bounds).size];

        if (!CGSizeEqualToSize(currentPreferredContentSize, calculatedPreferredContentSize)) {
            // NOTE: Setting the preferredContentSize can lead to a change to self.view.bounds.
            self.preferredContentSize = calculatedPreferredContentSize;
        }

        _previousLayoutSize = CGRectStandardize(self.alertView.bounds).size;
    }
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    // Recalculate preferredSize, which is based on width available, if the viewSize has changed.
    if (CGRectGetWidth(self.view.bounds) != _previousLayoutSize.width ||
        CGRectGetHeight(self.view.bounds) != _previousLayoutSize.height) {
        CGSize currentPreferredContentSize = self.preferredContentSize;
        CGSize contentSize = CGRectStandardize(self.alertView.bounds).size;
        CGSize calculatedPreferredContentSize =
        [self.alertView calculatePreferredContentSizeForBounds:contentSize];

        if (!CGSizeEqualToSize(currentPreferredContentSize, calculatedPreferredContentSize)) {
            // NOTE: Setting the preferredContentSize can lead to a change to self.view.bounds.
            self.preferredContentSize = calculatedPreferredContentSize;
        }

        _previousLayoutSize = CGRectStandardize(self.alertView.bounds).size;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:
     ^(__unused id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
         // Reset preferredContentSize on viewWIllTransition to take advantage of additional width
         self.preferredContentSize =
         [self.alertView calculatePreferredContentSizeForBounds:CGRectInfinite.size];
     }
                                 completion:nil];
}

#pragma mark - UIAccessibilityAction

- (BOOL)accessibilityPerformEscape {
    GTUIDialogPresentationController *dialogPresentationController =
    self.gtui_dialogPresentationController;
    if (dialogPresentationController.dismissOnBackgroundTap) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        return YES;
    }
    return NO;
}


@end
