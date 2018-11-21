//
//  GTUITextInputCommonFundament.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputCommonFundament.h"

#import "GTUIMultilineTextField.h"
#import "GTUIMultilineTextInputDelegate.h"
#import "GTUITextField.h"
#import "GTUITextFieldPositioningDelegate.h"
#import "GTUITextInput.h"
#import "GTUITextInputArt.h"
#import "GTUITextInputBorderView.h"
#import "GTUITextInputCommonFundament.h"
#import "GTUITextInputUnderlineView.h"

#import "GTAnimationTiming.h"
#import "GTMath.h"
#import "GTTypography.h"
#import "GTPalettes.h"

static NSString *const GTUITextInputUnderlineKVOKeyColor = @"color";
static NSString *const GTUITextInputUnderlineKVOKeyLineHeight = @"lineHeight";

const CGFloat GTUITextInputBorderRadius = 4.f;
static const CGFloat GTUITextInputClearButtonImageSquareWidthHeight = 24.f;
static const CGFloat GTUITextInputHintTextOpacity = 0.54f;
static const CGFloat GTUITextInputOverlayViewToEditingRectPadding = 2.f;
const CGFloat GTUITextInputFullPadding = 16.f;
const CGFloat GTUITextInputHalfPadding = 8.f;

UIColor *_Nonnull GTUITextInputCursorColor() {
    return [GTUIPalette bluePalette].accent700;
}

static inline UIColor *GTUITextInputDefaultPlaceholderTextColor() {
    return [UIColor colorWithWhite:0 alpha:GTUITextInputHintTextOpacity];
}

static inline UIColor *GTUITextInputTextColor() {
    return [UIColor colorWithWhite:0 alpha:[GTUITypography body1FontOpacity]];
}

static inline UIColor *GTUITextInputUnderlineColor() {
    return [UIColor lightGrayColor];
}

@interface GTUITextInputCommonFundament () {
    BOOL _gtui_adjustsFontForContentSizeCategory;
}

@property(nonatomic, assign) BOOL isRegisteredForKVO;

@property(nonatomic, strong) NSLayoutConstraint *clearButtonCenterY;
@property(nonatomic, strong) NSLayoutConstraint *clearButtonTrailing;
@property(nonatomic, strong) NSLayoutConstraint *clearButtonWidth;
@property(nonatomic, strong) NSLayoutConstraint *leadingUnderlineLeading;
@property(nonatomic, strong) NSLayoutConstraint *trailingUnderlineTrailing;
@property(nonatomic, strong) NSLayoutConstraint *placeholderLeading;
@property(nonatomic, strong) NSLayoutConstraint *placeholderLeadingLeadingViewTrailing;
@property(nonatomic, strong) NSLayoutConstraint *placeholderTop;
@property(nonatomic, strong) NSLayoutConstraint *placeholderTrailing;
@property(nonatomic, strong) NSLayoutConstraint *placeholderTrailingTrailingViewLeading;

@property(nonatomic, weak) UIView<GTUITextInput> *textInput;

@end

@implementation GTUITextInputCommonFundament

// We never use the text property. Instead always read from the text field.

@synthesize attributedText = _do_no_use_attributedText;
@synthesize borderPath = _borderPath;
@synthesize borderView = _borderView;
@synthesize clearButton = _clearButton;
@synthesize clearButtonMode = _clearButtonMode;
@synthesize enabled = _enabled;
@synthesize hidesPlaceholderOnInput = _hidesPlaceholderOnInput;
@synthesize leadingUnderlineLabel = _leadingUnderlineLabel;
@synthesize placeholderLabel = _placeholderLabel;
@synthesize positioningDelegate = _positioningDelegate;
@synthesize textColor = _textColor;
@synthesize trailingUnderlineLabel = _trailingUnderlineLabel;
@synthesize underline = _underline;
@synthesize textInsetsMode = _textInsetsMode;

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (nonnull instancetype)initWithTextInput:(UIView<GTUITextInput> *_Nonnull)textInput {
    self = [super init];
    if (self) {
        _textInput = textInput;

        [self commonGTUITextInputCommonFundamentInit];

        // This is the first call to the .textInput property. On GTUIMultilineTextField, .textView is a
        // failsafe, lazy var. It will create a .textView instance if there wasn't one on the ivar.
        _textInput.font = [UIFont gtui_standardFontForTextStyle:GTUIFontTextStyleBody1];
        // TODO: (#4331) This needs to be converted to the new text scheme.

        // Initialize elements of UI
        [self setupPlaceholderLabel];

        // setupClearButton must come after setupPlaceholderLabel because it will setup constraints that
        // depend on the placeholderLabel
        [self setupClearButton];
        [self setupUnderlineLabels];
        [self setupUnderlineView];

        [self updateTextColor];
        [self gtui_setAdjustsFontForContentSizeCategory:NO];

        [self setupBorder];
        [self subscribeForKVO];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self commonGTUITextInputCommonFundamentInit];

        [self setupBorder];
        [self setupPlaceholderLabel];

        // setupClearButton must come after setupPlaceholderLabel because it will setup constraints that
        // depend on the placeholderLabel
        [self setupClearButton];
        [self setupUnderlineLabels];
        [self setupUnderlineView];

        [self subscribeForKVO];
    }
    return self;
}

- (instancetype)copyWithZone:(__unused NSZone *)zone {
    GTUITextInputCommonFundament *copy =
    [[GTUITextInputCommonFundament alloc] initWithTextInput:self.textInput];

    copy.borderPath = self.borderPath.copy;
    if ([self.borderView conformsToProtocol:@protocol(NSCopying)]) {
        copy.borderView = self.borderView.copy;
    }
    copy.clearButtonMode = self.clearButtonMode;
    copy.enabled = self.isEnabled;
    copy.hidesPlaceholderOnInput = self.hidesPlaceholderOnInput;
    copy.gtui_adjustsFontForContentSizeCategory = self.gtui_adjustsFontForContentSizeCategory;
    copy.positioningDelegate = self.positioningDelegate;
    copy.text = [self.text copy];
    copy.textColor = self.textColor;
    copy.textInsetsMode = self.textInsetsMode;
    copy.underline.lineHeight = self.underline.lineHeight;
    copy.underline.color = self.underline.color;

    return copy;
}

- (void)dealloc {
    [self unsubscribeFromNotifications];
    [self unsubscribeFromKVO];
}

- (void)commonGTUITextInputCommonFundamentInit {
    _textColor = GTUITextInputTextColor();
    _textInsetsMode = GTUITextInputTextInsetsModeIfContent;
    _clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setupClearButton {
    if (!_clearButton) {
        _clearButton = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    _clearButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_clearButton setContentCompressionResistancePriority:UILayoutPriorityDefaultLow - 1
                                                  forAxis:UILayoutConstraintAxisHorizontal];
    [_clearButton setContentCompressionResistancePriority:UILayoutPriorityDefaultLow - 1
                                                  forAxis:UILayoutConstraintAxisVertical];
    [_clearButton setContentHuggingPriority:UILayoutPriorityDefaultLow + 1
                                    forAxis:UILayoutConstraintAxisHorizontal];
    [_clearButton setContentHuggingPriority:UILayoutPriorityDefaultLow + 1
                                    forAxis:UILayoutConstraintAxisVertical];

    _clearButton.opaque = NO;

    [_textInput addSubview:_clearButton];
    [_textInput sendSubviewToBack:_clearButton];

    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_clearButton
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_clearButton
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1
                                                               constant:0];
    height.priority = UILayoutPriorityDefaultLow;

    self.clearButtonWidth =
    [NSLayoutConstraint constraintWithItem:_clearButton
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:GTUITextInputClearButtonImageSquareWidthHeight];
    self.clearButtonWidth.priority = UILayoutPriorityDefaultLow;

    UIEdgeInsets insets = [self textInsets];
    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat centerYConstant =
    insets.top + (GTUICeil(self.textInput.font.lineHeight * scale) / scale) / 2.f;
    self.clearButtonCenterY = [NSLayoutConstraint constraintWithItem:_clearButton
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_textInput
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:centerYConstant];
    self.clearButtonCenterY.priority = UILayoutPriorityDefaultLow;

    self.placeholderTrailing = [NSLayoutConstraint constraintWithItem:_placeholderLabel
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                               toItem:_clearButton
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1
                                                             constant:GTUITextInputHalfPadding];
    self.placeholderTrailing.priority = UILayoutPriorityDefaultLow;

    self.clearButtonTrailing = [NSLayoutConstraint
                                constraintWithItem:_clearButton
                                attribute:NSLayoutAttributeTrailing
                                relatedBy:NSLayoutRelationEqual
                                toItem:_textInput
                                attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                constant:-1 * (GTUITextInputClearButtonImageBuiltInPadding + insets.right)];
    self.clearButtonTrailing.priority = UILayoutPriorityDefaultLow;

    [NSLayoutConstraint activateConstraints:@[
                                              height, self.clearButtonWidth, self.clearButtonCenterY, self.placeholderLeading,
                                              self.clearButtonTrailing
                                              ]];

    [_clearButton addTarget:self
                     action:@selector(clearButtonDidTouch)
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupPlaceholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_placeholderLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow - 2
                                                       forAxis:UILayoutConstraintAxisHorizontal];
    [_placeholderLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                         forAxis:UILayoutConstraintAxisHorizontal];

    _placeholderLabel.textAlignment = NSTextAlignmentNatural;

    _placeholderLabel.userInteractionEnabled = NO;
    _placeholderLabel.opaque = NO;

    _placeholderLabel.textColor = GTUITextInputDefaultPlaceholderTextColor();
    _placeholderLabel.font = _textInput.font;

    [_textInput addSubview:_placeholderLabel];
    [_textInput sendSubviewToBack:_placeholderLabel];

    [NSLayoutConstraint activateConstraints:[self placeholderDefaultConstaints]];

    _hidesPlaceholderOnInput = YES;
}

- (void)setupUnderlineLabels {
    if (!_leadingUnderlineLabel) {
        _leadingUnderlineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leadingUnderlineLabel.textColor = GTUITextInputDefaultPlaceholderTextColor();
        _leadingUnderlineLabel.font = _textInput.font;
        _leadingUnderlineLabel.textAlignment = NSTextAlignmentNatural;

        [_leadingUnderlineLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }

    if (!_trailingUnderlineLabel) {
        _trailingUnderlineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _trailingUnderlineLabel.textColor = [UIColor grayColor];
        _trailingUnderlineLabel.font = _textInput.font;
        [_trailingUnderlineLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }

    _leadingUnderlineLabel.opaque = NO;
    [_textInput addSubview:_leadingUnderlineLabel];

    _trailingUnderlineLabel.opaque = NO;
    [_textInput addSubview:_trailingUnderlineLabel];

    _leadingUnderlineLeading = [NSLayoutConstraint constraintWithItem:_leadingUnderlineLabel
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_textInput
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1
                                                             constant:0];
    _leadingUnderlineLeading.priority = UILayoutPriorityDefaultLow;

    _trailingUnderlineTrailing = [NSLayoutConstraint constraintWithItem:_trailingUnderlineLabel
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_textInput
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1
                                                               constant:0];
    _trailingUnderlineTrailing.priority = UILayoutPriorityDefaultLow;

    NSLayoutConstraint *labelSpacing =
    [NSLayoutConstraint constraintWithItem:_leadingUnderlineLabel
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_trailingUnderlineLabel
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:0];
    labelSpacing.priority = UILayoutPriorityDefaultLow;

    [NSLayoutConstraint
     activateConstraints:@[ labelSpacing, _leadingUnderlineLeading, _trailingUnderlineTrailing ]];

    NSLayoutConstraint *leadingBottom = [NSLayoutConstraint constraintWithItem:_leadingUnderlineLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_textInput
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:0];
    leadingBottom.priority = UILayoutPriorityDefaultLow;

    NSLayoutConstraint *trailingBottom =
    [NSLayoutConstraint constraintWithItem:_trailingUnderlineLabel
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_textInput
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0];
    trailingBottom.priority = UILayoutPriorityDefaultLow;

    [NSLayoutConstraint activateConstraints:@[ leadingBottom, trailingBottom ]];

    // When push comes to shove, the leading label is more likely to expand than the trailing.
    [_leadingUnderlineLabel setContentHuggingPriority:UILayoutPriorityDefaultLow - 1
                                              forAxis:UILayoutConstraintAxisHorizontal];

    [_trailingUnderlineLabel
     setContentCompressionResistancePriority:UILayoutPriorityRequired
     forAxis:UILayoutConstraintAxisHorizontal];
    [_trailingUnderlineLabel setContentHuggingPriority:UILayoutPriorityRequired
                                               forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setupUnderlineView {
    if (!_underline) {
        _underline = [[GTUITextInputUnderlineView alloc] initWithFrame:CGRectZero];
    }
    _underline.color = GTUITextInputUnderlineColor();
    _underline.translatesAutoresizingMaskIntoConstraints = NO;

    [self.textInput addSubview:_underline];
    [self.textInput sendSubviewToBack:_underline];
}

#pragma mark - Border implementation

- (void)setupBorder {
    if (!_borderView) {
        _borderView = [[GTUITextInputBorderView alloc] initWithFrame:CGRectZero];
        ;
        [self.textInput addSubview:_borderView];
        [self.textInput sendSubviewToBack:_borderView];
        _borderView.translatesAutoresizingMaskIntoConstraints = NO;

        NSArray<NSLayoutConstraint *> *constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[border]|"
                                                options:0
                                                metrics:nil
                                                  views:@{
                                                          @"border" : _borderView
                                                          }];
        constraints = [constraints
                       arrayByAddingObjectsFromArray:[NSLayoutConstraint
                                                      constraintsWithVisualFormat:@"H:|[border]|"
                                                      options:0
                                                      metrics:nil
                                                      views:@{
                                                              @"border" : _borderView
                                                              }]];
        for (NSLayoutConstraint *constraint in constraints) {
            constraint.priority = UILayoutPriorityDefaultLow;
        }
        [NSLayoutConstraint activateConstraints:constraints];
    }
}

- (void)unsubscribeFromNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

#pragma mark - KVO Subscription

- (void)subscribeForKVO {
    if (!_underline) {
        return;
    }
    [self.underline addObserver:self
                     forKeyPath:GTUITextInputUnderlineKVOKeyColor
                        options:0
                        context:nil];
    [self.underline addObserver:self
                     forKeyPath:GTUITextInputUnderlineKVOKeyLineHeight
                        options:0
                        context:nil];
    _isRegisteredForKVO = YES;
}

- (void)unsubscribeFromKVO {
    if (!_underline || !self.isRegisteredForKVO) {
        return;
    }
    @try {
        [_underline removeObserver:self forKeyPath:GTUITextInputUnderlineKVOKeyColor];
        [_underline removeObserver:self forKeyPath:GTUITextInputUnderlineKVOKeyLineHeight];
    } @catch (__unused NSException *exception) {
        NSLog(@"Tried to unsubscribe from KVO in GTUITextInputCommonFundament but could not.");
    }
    _isRegisteredForKVO = NO;
}

#pragma mark - Mirrored Layout Methods

- (void)layoutSubviewsOfInput {
    [self updatePlaceholderAlpha];
    [self.textInput sendSubviewToBack:_borderView];

    if ([self needsUpdateConstraintsForPlaceholderToTextInsets] ||
        [self needsUpdateConstraintsForPlaceholderToOverlayViewsPosition]) {
        [self.textInput setNeedsUpdateConstraints];
    }

    [self updateTextColor];
    [self updateClearButton];
}

- (void)updateConstraintsOfInput {
    [self updateClearButtonConstraints];
    [self updatePlaceholderPosition];
    [self updateUnderlineLabels];
}

#pragma mark - Clear Button Implementation

- (void)updateClearButton {
    UIImage *image = self.clearButton.currentImage
    ? self.clearButton.currentImage
    : [self drawnClearButtonImage];

    if (![self.clearButton imageForState:UIControlStateNormal]) {
        [self.clearButton setImage:image forState:UIControlStateNormal];
        [self.clearButton setImage:image forState:UIControlStateHighlighted];
        [self.clearButton setImage:image forState:UIControlStateSelected];
    }

    CGFloat clearButtonAlpha = [self clearButtonAlpha];
    self.clearButton.alpha = clearButtonAlpha;

    if (self.clearButtonWidth.constant !=
        GTUITextInputClearButtonImageSquareWidthHeight * clearButtonAlpha) {
        [self.textInput setNeedsUpdateConstraints];
    }

    [self.clearButton.superview bringSubviewToFront:self.clearButton];
}

- (void)updateClearButtonConstraints {
    BOOL shouldInvalidateSize = NO;
    CGFloat widthConstant = GTUITextInputClearButtonImageSquareWidthHeight * [self clearButtonAlpha];
    if (self.clearButtonWidth.constant != widthConstant) {
        self.clearButtonWidth.constant = widthConstant;
        shouldInvalidateSize = YES;
    }

    UIEdgeInsets insets = [self textInsets];

    CGFloat trailingConstant = GTUITextInputClearButtonImageBuiltInPadding - insets.right;
    if (self.clearButtonTrailing.constant != trailingConstant) {
        self.clearButtonTrailing.constant = trailingConstant;
        shouldInvalidateSize = YES;
    }

    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat centerYConstant =
    insets.top + (GTUICeil(self.textInput.font.lineHeight * scale) / scale) / 2.f;
    if (self.clearButtonCenterY.constant != centerYConstant) {
        self.clearButtonCenterY.constant = centerYConstant;
        shouldInvalidateSize = YES;
    }

    if (shouldInvalidateSize) {
        [self.textInput invalidateIntrinsicContentSize];
    }
}

- (CGFloat)clearButtonAlpha {
    CGFloat clearButtonAlpha = 0;
    if (self.text.length > 0) {
        switch (self.clearButtonMode) {
            case UITextFieldViewModeAlways:
                clearButtonAlpha = 1;
                break;
            case UITextFieldViewModeWhileEditing:
                if (self.isEditing) {
                    clearButtonAlpha = 1;
                }
                break;
            case UITextFieldViewModeUnlessEditing:
                if (!self.isEditing) {
                    clearButtonAlpha = 1;
                }
                break;
            default:
                break;
        }
    }

    if (self.trailingView.superview && !GTUICGFloatEqual(self.trailingView.alpha, 0.f)) {
        clearButtonAlpha = 0;
    }

    return clearButtonAlpha;
}

- (UIImage *)drawnClearButtonImage {
    CGSize clearButtonSize = CGSizeMake(GTUITextInputClearButtonImageSquareWidthHeight,
                                        GTUITextInputClearButtonImageSquareWidthHeight);

    CGRect bounds = CGRectMake(0, 0, clearButtonSize.width, clearButtonSize.height);
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0);
    [UIColor.grayColor setFill];

    [GTUIPathForClearButtonImageFrame(bounds) fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return image;
}

- (void)clearButtonDidTouch {
    if ([self.textInput isKindOfClass:[GTUITextField class]]) {
        GTUITextField *textField = (GTUITextField *)self.textInput;
        if ([textField.delegate respondsToSelector:@selector(textFieldShouldClear:)] &&
            ![textField.delegate textFieldShouldClear:textField]) {
            return;
        }
    }

    if ([self.textInput isKindOfClass:[GTUIMultilineTextField class]]) {
        GTUIMultilineTextField *textField = (GTUIMultilineTextField *)self.textInput;
        if ([textField.multilineDelegate
             respondsToSelector:@selector(multilineTextFieldShouldClear:)] &&
            ![textField.multilineDelegate multilineTextFieldShouldClear:textField]) {
            return;
        }
    }

    self.text = nil;
    if (self.textInput.isFirstResponder) {
        if ([self.textInput isKindOfClass:[GTUIMultilineTextField class]]) {
            GTUIMultilineTextField *textField = (GTUIMultilineTextField *)self.textInput;
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification
                                                                object:textField.textView];
        } else if ([self.textInput isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)self.textInput;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:UITextFieldTextDidChangeNotification
             object:self.textInput];
            [textField sendActionsForControlEvents:UIControlEventEditingChanged];
        }
    }
}

#pragma mark - Properties Implementation

- (void)setTextInsetsMode:(GTUITextInputTextInsetsMode)textInsetsMode {
    if (_textInsetsMode != textInsetsMode) {
        _textInsetsMode = textInsetsMode;
        [self.textInput invalidateIntrinsicContentSize];
    }
}

- (NSAttributedString *)attributedPlaceholder {
    id placeholderString = self.placeholderLabel.text;
    if ([placeholderString isKindOfClass:[NSString class]]) {
        // TODO: (larche) Return string attributes also. Tho I feel like that should come from the
        // placeholderLabel itself somehow.
        NSAttributedString *constructedString =
        [[NSAttributedString alloc] initWithString:(NSString *)placeholderString attributes:nil];
        return constructedString;
    } else if ([placeholderString isKindOfClass:[NSAttributedString class]]) {
        return (NSAttributedString *)placeholderString;
    }

    return nil;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderLabel.text = attributedPlaceholder.string;
    // TODO: (larche) Read string attributes also. Tho I feel like that should come from the
    // placeholderLabel itself somehow.

    [self updatePlaceholderAlpha];
    [self.textInput setNeedsUpdateConstraints];
}

- (void)setBorderPath:(UIBezierPath *)borderPath {
    if (_borderPath != borderPath) {
        _borderPath = [UIBezierPath bezierPathWithCGPath:borderPath.CGPath];
    }
}

- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode {
    _clearButtonMode = clearButtonMode;
    [self updateClearButton];
}

- (UIColor *)cursorColor {
    return self.textInput.cursorColor;
}

- (void)setCursorColor:(UIColor *)cursorColor {
    self.textInput.cursorColor = cursorColor;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.underline.enabled = enabled;
}

- (UIFont *)font {
    return self.textInput.font;
}

- (void)setFont:(UIFont *)font {
    [self.textInput setFont:font];
}

- (void)setHidesPlaceholderOnInput:(BOOL)hidesPlaceholderOnInput {
    _hidesPlaceholderOnInput = hidesPlaceholderOnInput;
    [self updatePlaceholderAlpha];
}

- (BOOL)isEditing {
    return self.textInput.isEditing;
}

- (NSString *)placeholder {
    id placeholderString = self.placeholderLabel.text;
    if ([placeholderString isKindOfClass:[NSString class]]) {
        return (NSString *)placeholderString;
    } else if ([placeholderString isKindOfClass:[NSAttributedString class]]) {
        return [(NSAttributedString *)placeholderString string];
    }

    return nil;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholderAlpha];
    [self.textInput setNeedsLayout];
}

- (NSString *)text {
    return self.textInput.text;
}

- (void)setText:(NSString *)text {
    [self.textInput setText:text];
}

- (void)setTextColor:(UIColor *)textColor {
    if (!textColor) {
        textColor = GTUITextInputTextColor();
    }

    if (_textColor != textColor) {
        _textColor = textColor;
        [self updateTextColor];
    }
}

- (void)setTextInput:(UIView<GTUITextInput> *)textInput {
    _textInput = textInput;

    [_textInput setNeedsLayout];
}

- (UIEdgeInsets)textInsets {
    UIEdgeInsets textInsets = UIEdgeInsetsZero;

    textInsets.top = GTUITextInputFullPadding;

    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat leadingOffset = GTUICeil(self.leadingUnderlineLabel.font.lineHeight * scale) / scale;
    CGFloat trailingOffset = GTUICeil(self.trailingUnderlineLabel.font.lineHeight * scale) / scale;

    // The amount of space underneath the underline is variable. It could just be
    // GTUITextInputHalfPadding or the biggest estimated underlineLabel height +
    // GTUITextInputHalfPadding. It's also dependent on the .textInsetsMode.

    // contentConditionalOffset will have the estimated text height for the largest underline label
    // that also has text.
    CGFloat contentConditionalOffset = 0;
    if (self.leadingUnderlineLabel.text.length) {
        contentConditionalOffset = leadingOffset;
    }
    if (self.trailingUnderlineLabel.text.length) {
        contentConditionalOffset = MAX(contentConditionalOffset, trailingOffset);
    }

    CGFloat underlineOffset = GTUITextInputHalfPadding;
    switch (self.textInsetsMode) {
        case GTUITextInputTextInsetsModeAlways:
            underlineOffset += MAX(leadingOffset, trailingOffset);
            break;
        case GTUITextInputTextInsetsModeIfContent:
            underlineOffset += contentConditionalOffset;
            break;
        case GTUITextInputTextInsetsModeNever:
            break;
    }

    // .bottom = underlineOffset + the half padding ABOVE the line but below the text field
    textInsets.bottom = underlineOffset + GTUITextInputHalfPadding;

    if ([self.positioningDelegate respondsToSelector:@selector(textInsets:)]) {
        return [self.positioningDelegate textInsets:textInsets];
    }
    return textInsets;
}

- (UIView *)trailingView {
    return self.textInput.trailingView;
}

- (void)setTrailingView:(UIView *)trailingView {
    self.textInput.trailingView = trailingView;
}

- (UITextFieldViewMode)trailingViewMode {
    return self.textInput.trailingViewMode;
}

- (void)setTrailingViewMode:(UITextFieldViewMode)trailingViewMode {
    self.textInput.trailingViewMode = trailingViewMode;
}

#pragma mark - Layout

- (void)updateTextColor {
    self.textInput.textColor = self.textColor;
}

- (void)updateFontsForDynamicType {
    if (self.gtui_adjustsFontForContentSizeCategory) {
        UIFont *textFont = [UIFont gtui_preferredFontForTextStyle:GTUIFontTextStyleBody1];
        // TODO: (#4331) This needs to be converted to the new text scheme.
        self.textInput.font = textFont;
        self.leadingUnderlineLabel.font = textFont;
        self.trailingUnderlineLabel.font = textFont;
        self.placeholderLabel.font = textFont;
    }
}

- (BOOL)needsUpdateConstraintsForPlaceholderToTextInsets {
    return (self.placeholderTop.constant != _textInput.textInsets.top ||
            self.placeholderLeading.constant != _textInput.textInsets.left ||
            self.placeholderTrailing.constant != -1 * _textInput.textInsets.right);
}

- (BOOL)needsUpdateConstraintsForPlaceholderToOverlayViewsPosition {
    if (![self.textInput isKindOfClass:[GTUITextField class]]) {
        return NO;
    }

    GTUITextField *textField = (GTUITextField *)self.textInput;

    return (textField.leadingView.superview && !self.placeholderLeadingLeadingViewTrailing) ||
    (!textField.leadingView.superview && self.placeholderLeadingLeadingViewTrailing) ||
    (textField.trailingView.superview && !self.placeholderTrailingTrailingViewLeading) ||
    (!textField.trailingView.superview && self.placeholderTrailingTrailingViewLeading);
}

- (void)updatePlaceholderToOverlayViewsPosition {
    if (![self.textInput isKindOfClass:[GTUITextField class]]) {
        return;
    }

    GTUITextField *textField = (GTUITextField *)self.textInput;
    if (textField.leadingView.superview) {
        CGFloat leadingViewTrailingConstant = GTUITextInputOverlayViewToEditingRectPadding;
        if ([self.textInput.positioningDelegate
             respondsToSelector:@selector(leadingViewTrailingPaddingConstant)]) {
            leadingViewTrailingConstant =
            [self.textInput.positioningDelegate leadingViewTrailingPaddingConstant];
        }

        if (!self.placeholderLeadingLeadingViewTrailing) {
            self.placeholderLeadingLeadingViewTrailing =
            [NSLayoutConstraint constraintWithItem:textField.placeholderLabel
                                         attribute:NSLayoutAttributeLeading
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:textField.leadingView
                                         attribute:NSLayoutAttributeTrailing
                                        multiplier:1
                                          constant:leadingViewTrailingConstant];
            self.placeholderLeadingLeadingViewTrailing.priority = UILayoutPriorityDefaultLow + 1;
            self.placeholderLeadingLeadingViewTrailing.active = YES;
        }
        self.placeholderLeadingLeadingViewTrailing.constant = leadingViewTrailingConstant;
    } else if (!textField.leadingView.superview && self.placeholderLeadingLeadingViewTrailing) {
        self.placeholderLeadingLeadingViewTrailing = nil;
    }

    if (textField.trailingView.superview && !self.placeholderTrailingTrailingViewLeading) {
        self.placeholderTrailingTrailingViewLeading =
        [NSLayoutConstraint constraintWithItem:textField.placeholderLabel
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                        toItem:textField.trailingView
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1
                                      constant:GTUITextInputOverlayViewToEditingRectPadding];
        self.placeholderTrailingTrailingViewLeading.priority = UILayoutPriorityDefaultLow + 1;
        self.placeholderTrailingTrailingViewLeading.active = YES;
    } else if (!textField.trailingView.superview && self.placeholderTrailingTrailingViewLeading) {
        self.placeholderTrailingTrailingViewLeading = nil;
    }

    [textField invalidateIntrinsicContentSize];
}

- (void)updatePlaceholderAlpha {
    CGFloat opacity = (self.hidesPlaceholderOnInput && self.textInput.text.length > 0) ? 0 : 1;
    self.placeholderLabel.alpha = opacity;
}

- (void)updatePlaceholderPosition {
    self.placeholderTop.constant = _textInput.textInsets.top;
    self.placeholderLeading.constant = _textInput.textInsets.left;
    self.placeholderTrailing.constant = -1 * _textInput.textInsets.right;

    [self updatePlaceholderToOverlayViewsPosition];
    [self.textInput invalidateIntrinsicContentSize];
}

- (NSArray<NSLayoutConstraint *> *)placeholderDefaultConstaints {
    UIEdgeInsets insets = ((GTUITextField *)_textInput).textInsets;

    self.placeholderTop = [NSLayoutConstraint constraintWithItem:_placeholderLabel
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:_textInput
                                                       attribute:NSLayoutAttributeTop
                                                      multiplier:1
                                                        constant:insets.top];
    [self.placeholderTop setPriority:UILayoutPriorityDefaultLow];

    // This can be affected by .leadingView and .trailingView.
    // See updatePlaceholderToOverlayViewsPosition()
    self.placeholderLeading = [NSLayoutConstraint constraintWithItem:_placeholderLabel
                                                           attribute:NSLayoutAttributeLeading
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_textInput
                                                           attribute:NSLayoutAttributeLeading
                                                          multiplier:1
                                                            constant:insets.left];
    [self.placeholderLeading setPriority:UILayoutPriorityDefaultLow];

    NSLayoutConstraint *placeholderTrailing =
    [NSLayoutConstraint constraintWithItem:_placeholderLabel
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                    toItem:_textInput
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:-1 * insets.right];
    placeholderTrailing.priority = UILayoutPriorityDefaultLow;

    return @[ self.placeholderTop, self.placeholderLeading, placeholderTrailing ];
}

- (void)updateUnderlineLabels {
    UIEdgeInsets textInsets = self.textInsets;

    self.leadingUnderlineLeading.constant = textInsets.left;
    self.trailingUnderlineTrailing.constant = -1 * textInsets.right;
}

#pragma mark - Text Input Events

- (void)didBeginEditing {
    [self updateClearButton];
    [self.textInput invalidateIntrinsicContentSize];
}

- (void)didChange {
    [self updateClearButton];
    [self updatePlaceholderAlpha];
    [self updatePlaceholderPosition];
}

- (void)didEndEditing {
    [self updateClearButton];
}

- (void)didSetFont {
    UIFont *font = self.textInput.font;
    self.placeholderLabel.font = font;

    [self updatePlaceholderPosition];
}

- (void)didSetText {
    [self didChange];
    [self.textInput setNeedsLayout];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(__unused NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(__unused void *)context {
    // Listening to outside setting of underline properties.
    if (object != self.underline) {
        return;
    }

    if ([keyPath isEqualToString:GTUITextInputUnderlineKVOKeyColor]) {
        if (!self.underline.color) {
            self.underline.color = GTUITextInputUnderlineColor();
        }
    } else if ([keyPath isEqualToString:GTUITextInputUnderlineKVOKeyLineHeight]) {
        [self.textInput setNeedsUpdateConstraints];
    } else {
        return;
    }
}

#pragma mark - Accessibility

- (BOOL)gtui_adjustsFontForContentSizeCategory {
    return _gtui_adjustsFontForContentSizeCategory;
}

- (void)gtui_setAdjustsFontForContentSizeCategory:(BOOL)adjusts {
    _gtui_adjustsFontForContentSizeCategory = adjusts;

    if (adjusts) {
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

- (void)contentSizeCategoryDidChange:(__unused NSNotification *)notification {
    [self updateFontsForDynamicType];
}

@end
