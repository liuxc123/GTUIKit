//
//  GTUINavigationBar.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import "GTUINavigationBar.h"

#import <GTFInternationalization/GTFInternationalization.h>
#import <objc/runtime.h>

#import <GTFTextAccessibility/GTFTextAccessibility.h>
#import "GTButtonBar.h"
#import "GTMath.h"
#import "GTTypography.h"

static const NSUInteger kTitleFontSize = 17;
static const CGFloat kNavigationBarDefaultHeight = 44;
static const CGFloat kNavigationBarMinHeight = 24;
static const UIEdgeInsets kTextInsets = {0, 16, 0, 16};

// KVO contexts
static char *const kKVOContextGTUINavigationBar = "kKVOContextGTUINavigationBar";

static NSArray<NSString *> *GTUINavigationBarNavigationItemKVOPaths(void) {
    static dispatch_once_t onceToken;
    static NSArray<NSString *> *forwardingKeyPaths = nil;
    dispatch_once(&onceToken, ^{
        NSMutableArray<NSString *> *keyPaths = [NSMutableArray array];

        Protocol *headerProtocol = @protocol(GTUINavigationItemObservables);
        unsigned int count = 0;
        objc_property_t *propertyList = protocol_copyPropertyList(headerProtocol, &count);
        if (propertyList) {
            for (unsigned int ix = 0; ix < count; ++ix) {
                [keyPaths addObject:[NSString stringWithFormat:@"%s", property_getName(propertyList[ix])]];
            }
            free(propertyList);
        }

        // Ensure that the plural bar button item key paths are listened to last, otherwise the
        // non-plural variant will cause the extra bar button items to be lost. Fun!
        NSArray<NSString *> *orderedKeyPaths = @[
                                                 NSStringFromSelector(@selector(leftBarButtonItems)),
                                                 NSStringFromSelector(@selector(rightBarButtonItems))
                                                 ];
        [keyPaths removeObjectsInArray:orderedKeyPaths];
        [keyPaths addObjectsFromArray:orderedKeyPaths];

        forwardingKeyPaths = keyPaths;
    });
    return forwardingKeyPaths;
}

@implementation GTUINavigationBarTextColorAccessibilityMutator

- (nonnull instancetype)init {
    self = [super init];
    return self;
}

- (void)mutate:(GTUINavigationBar *)navBar {
    // Determine what is the appropriate background color
    UIColor *backgroundColor = navBar.backgroundColor;
    if (!backgroundColor) {
        return;
    }

    // Update title label color based on navigationBar backgroundColor
    NSMutableDictionary *textAttr =
    [NSMutableDictionary dictionaryWithDictionary:[navBar titleTextAttributes]];
    UIColor *textColor =
    [GTFTextAccessibility textColorOnBackgroundColor:backgroundColor
                                     targetTextAlpha:1.0
                                                font:[textAttr objectForKey:NSFontAttributeName]];
    [textAttr setObject:textColor forKey:NSForegroundColorAttributeName];
    [navBar setTitleTextAttributes:textAttr];

    // Update button's tint color based on navigationBar backgroundColor
    navBar.tintColor = textColor;
}

@end

/**
 Indiana Jones style placeholder view for UINavigationBar. Ownership of UIBarButtonItem.customView
 and UINavigationItem.titleView are normally transferred to UINavigationController but we plan to
 steal them away. In order to avoid crashing during KVO updates, we steal the view away and
 replace it with a sandbag view.
 */
@interface GTUINavigationBarSandbagView : UIView
@end

@implementation GTUINavigationBarSandbagView
@end

@interface GTUINavigationBar (PrivateAPIs) <GTUIButtonBarDelegate>

/// titleLabel is hidden if there is a titleView. When not hidden, displays self.title.
- (UILabel *)titleLabel;
- (GTUIButtonBar *)leadingButtonBar;
- (GTUIButtonBar *)trailingButtonBar;

@end

@implementation GTUINavigationBar{
    id _observedNavigationItemLock;
    UINavigationItem *_observedNavigationItem;

    UILabel *_titleLabel;

    GTUIButtonBar *_leadingButtonBar;
    GTUIButtonBar *_trailingButtonBar;

    __weak UIViewController *_watchingViewController;
}

@synthesize leadingBarButtonItems = _leadingBarButtonItems;
@synthesize trailingBarButtonItems = _trailingBarButtonItems;
@synthesize hidesBackButton = _hidesBackButton;
@synthesize leadingItemsSupplementBackButton = _leadingItemsSupplementBackButton;
@synthesize titleView = _titleView;

- (void)dealloc {
    [self setObservedNavigationItem:nil];
}

- (void)commonGTUINavigationBarInit {
    _uppercasesButtonTitles = NO;
    _observedNavigationItemLock = [[NSObject alloc] init];
    _titleFont = [GTUITypography titleFont];

    _titleViewLayoutBehavior = GTUINavigationBarTitleViewLayoutBehaviorFill;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = _titleFont;
    _titleLabel.accessibilityTraits |= UIAccessibilityTraitHeader;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _leadingButtonBar = [[GTUIButtonBar alloc] init];
    _leadingButtonBar.layoutPosition = GTUIButtonBarLayoutPositionLeading;
    _leadingButtonBar.delegate = self;
    _trailingButtonBar = [[GTUIButtonBar alloc] init];
    _trailingButtonBar.layoutPosition = GTUIButtonBarLayoutPositionTrailing;
    _trailingButtonBar.delegate = self;

    [self addSubview:_titleLabel];
    [self addSubview:_leadingButtonBar];
    [self addSubview:_trailingButtonBar];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTUINavigationBarInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTUINavigationBarInit];
        _leadingButtonBar.backgroundColor = nil;
        _trailingButtonBar.backgroundColor = nil;
    }
    return self;
}

- (void)setUppercasesButtonTitles:(BOOL)uppercasesButtonTitles {
    _uppercasesButtonTitles = uppercasesButtonTitles;

    _leadingButtonBar.uppercasesButtonTitles = uppercasesButtonTitles;
    _trailingButtonBar.uppercasesButtonTitles = uppercasesButtonTitles;
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (self.allowAnyTitleFontSize) {
        _titleFont = titleFont;
    } else {
        _titleFont = [UIFont fontWithDescriptor:titleFont.fontDescriptor size:kTitleFontSize];
    }
    if (!_titleFont) {
        _titleFont = [GTUITypography titleFont];
    }
    _titleLabel.font = _titleFont;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleLabel.textColor = titleTextColor;
}

- (UIColor *)titleTextColor {
    return _titleLabel.textColor;
}

#pragma mark Accessibility

- (NSArray<__kindof UIView *> *)accessibilityElements {
    return @[ _leadingButtonBar, self.titleView ? self.titleView : _titleLabel, _trailingButtonBar ];
}

- (BOOL)isAccessibilityElement {
    return NO;
}

- (NSInteger)accessibilityElementCount {
    return self.accessibilityElements.count;
}

- (id)accessibilityElementAtIndex:(NSInteger)index {
    return self.accessibilityElements[index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element {
    return [self.accessibilityElements indexOfObject:element];
}

#pragma mark - GTUIButtonBarDelegate

- (void)buttonBarDidInvalidateIntrinsicContentSize:(GTUIButtonBar *)buttonBar {
    [self setNeedsLayout];
}

#pragma mark UIView Overrides

- (void)layoutSubviews {
    [super layoutSubviews];

    // For pre iOS 11 devices, it's safe to assume that the Safe Area insets' left and right
    // values are zero. DO NOT use this to get the top or bottom Safe Area insets.
    UIEdgeInsets RTLFriendlySafeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        RTLFriendlySafeAreaInsets =
        GTFInsetsMakeWithLayoutDirection(self.safeAreaInsets.top,
                                         self.safeAreaInsets.left,
                                         self.safeAreaInsets.bottom,
                                         self.safeAreaInsets.right,
                                         self.gtf_effectiveUserInterfaceLayoutDirection);
    }

    CGSize leadingButtonBarSize = [_leadingButtonBar sizeThatFits:self.bounds.size];
    CGRect leadingButtonBarFrame = CGRectMake(RTLFriendlySafeAreaInsets.left,
                                              CGRectGetMinY(self.bounds),
                                              leadingButtonBarSize.width,
                                              leadingButtonBarSize.height);
    CGSize trailingButtonBarSize = [_trailingButtonBar sizeThatFits:self.bounds.size];
    CGFloat xOrigin =
    CGRectGetWidth(self.bounds) - RTLFriendlySafeAreaInsets.right - trailingButtonBarSize.width;
    CGRect trailingButtonBarFrame = CGRectMake(xOrigin,
                                               CGRectGetMinY(self.bounds),
                                               trailingButtonBarSize.width,
                                               trailingButtonBarSize.height);
    if (self.gtf_effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        leadingButtonBarFrame = GTFRectFlippedHorizontally(leadingButtonBarFrame,
                                                           CGRectGetWidth(self.bounds));
        trailingButtonBarFrame = GTFRectFlippedHorizontally(trailingButtonBarFrame,
                                                            CGRectGetWidth(self.bounds));
    }
    _leadingButtonBar.frame = leadingButtonBarFrame;
    _trailingButtonBar.frame = trailingButtonBarFrame;

    UIEdgeInsets textInsets = kTextInsets;

    // textFrame is used to determine layout of both TitleLabel and TitleView
    CGRect textFrame = UIEdgeInsetsInsetRect(self.bounds, textInsets);
    textFrame.origin.x += _leadingButtonBar.frame.size.width;
    textFrame.size.width -= _leadingButtonBar.frame.size.width + _trailingButtonBar.frame.size.width;
    if (@available(iOS 11.0, *)) {
        textFrame.origin.x += self.safeAreaInsets.left;
        textFrame.size.width -= self.safeAreaInsets.left + self.safeAreaInsets.right;
    }

    // Layout TitleLabel
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = _titleLabel.lineBreakMode;

    NSDictionary<NSString *, id> *attributes =
    @{NSFontAttributeName : _titleLabel.font, NSParagraphStyleAttributeName : paraStyle};

    CGSize titleSize = [_titleLabel.text boundingRectWithSize:textFrame.size
                                                      options:NSStringDrawingTruncatesLastVisibleLine
                                                   attributes:attributes
                                                      context:NULL]
    .size;
    titleSize.width = GTUICeil(titleSize.width);
    titleSize.height = GTUICeil(titleSize.height);
    CGRect titleFrame = CGRectMake(textFrame.origin.x, 0, titleSize.width, titleSize.height);
    if (self.gtf_effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        titleFrame = GTFRectFlippedHorizontally(titleFrame, CGRectGetWidth(self.bounds));
    }
    UIControlContentVerticalAlignment titleVerticalAlignment = UIControlContentVerticalAlignmentTop;
    CGRect alignedFrame = [self gtui_frameAlignedVertically:titleFrame
                                              withinBounds:textFrame
                                                 alignment:titleVerticalAlignment];
    alignedFrame = [self gtui_frameAlignedHorizontally:alignedFrame alignment:self.titleAlignment];
    _titleLabel.frame = GTUIRectAlignToScale(alignedFrame, self.window.screen.scale);

    // Layout TitleView
    if (self.gtf_effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        textFrame = GTFRectFlippedHorizontally(textFrame, CGRectGetWidth(self.bounds));
    }

    CGRect titleViewFrame = textFrame;
    switch (self.titleViewLayoutBehavior) {
        case GTUINavigationBarTitleViewLayoutBehaviorFill:
            // Do nothing. The default textFrame calculation will fill the available space.
            break;

        case GTUINavigationBarTitleViewLayoutBehaviorCenter: {
            CGFloat availableWidth = UIEdgeInsetsInsetRect(self.bounds, textInsets).size.width;
            availableWidth -= MAX(_leadingButtonBar.frame.size.width,
                                  _trailingButtonBar.frame.size.width) * 2;
            if (@available(iOS 11.0, *)) {
                availableWidth -= self.safeAreaInsets.left + self.safeAreaInsets.right;
            }
            titleViewFrame.size.width = availableWidth;
            titleViewFrame = [self gtui_frameAlignedHorizontally:titleViewFrame
                                                      alignment:GTUINavigationBarTitleAlignmentCenter];
            break;
        }
    }
    // No insets for the titleView, and a height that is the same as the button bars. Clients
    // can vertically center their titleView subviews to align them with buttons.
    titleViewFrame.origin.y = 0;
    CGFloat maxHeight = kNavigationBarDefaultHeight;
    CGFloat minHeight = kNavigationBarMinHeight;
    titleViewFrame.size.height = MIN(MAX(self.bounds.size.height, minHeight), maxHeight);
    self.titleView.frame = titleViewFrame;

    // Button and title label alignment

    CGFloat titleTextRectHeight =
    [_titleLabel textRectForBounds:_titleLabel.bounds limitedToNumberOfLines:0].size.height;

    if (_titleLabel.hidden || titleTextRectHeight <= 0) {
        _leadingButtonBar.buttonTitleBaseline = 0;
        _trailingButtonBar.buttonTitleBaseline = 0;
    } else {
        // Assumes that the title is center-aligned vertically.
        CGFloat titleTextOriginY = (_titleLabel.frame.size.height - titleTextRectHeight) / 2;
        CGFloat titleTextHeight = titleTextOriginY + titleTextRectHeight + _titleLabel.font.descender;
        CGFloat titleBaseline = _titleLabel.frame.origin.y + titleTextHeight;
        _leadingButtonBar.buttonTitleBaseline = titleBaseline;
        _trailingButtonBar.buttonTitleBaseline = titleBaseline;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat maxHeight = kNavigationBarDefaultHeight;
    CGFloat height = MIN(MAX(size.height, kNavigationBarMinHeight), maxHeight);
    return CGSizeMake(size.width, height);
}

- (CGSize)intrinsicContentSize {
    CGFloat height = kNavigationBarDefaultHeight;
    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

- (GTUINavigationBarTitleAlignment)titleAlignment {
    return [GTUINavigationBar titleAlignmentFromTextAlignment:_titleLabel.textAlignment];
}

- (void)setTitleAlignment:(GTUINavigationBarTitleAlignment)titleAlignment {
    _titleLabel.textAlignment = [GTUINavigationBar textAlignmentFromTitleAlignment:titleAlignment];
    [self setNeedsLayout];
}

#pragma mark Private

+ (NSTextAlignment)textAlignmentFromTitleAlignment:(GTUINavigationBarTitleAlignment)titleAlignment {
    switch (titleAlignment) {
        case GTUINavigationBarTitleAlignmentCenter:
            return NSTextAlignmentCenter;
            break;
        default:
            NSAssert(NO, @"titleAlignment not understood: %li", (long)titleAlignment);
            // Intentional fall through logic
        case GTUINavigationBarTitleAlignmentLeading:
            return NSTextAlignmentNatural;
            break;
    }
}

+ (GTUINavigationBarTitleAlignment)titleAlignmentFromTextAlignment:(NSTextAlignment)textAlignment {
    switch (textAlignment) {
        default:
            NSAssert(NO, @"textAlignment not supported: %li", (long)textAlignment);
            // Intentional fall through logic
        case NSTextAlignmentNatural:
        case NSTextAlignmentLeft:
            return GTUINavigationBarTitleAlignmentLeading;
            break;
        case NSTextAlignmentCenter:
            return GTUINavigationBarTitleAlignmentCenter;
            break;
    }
}

- (UILabel *)titleLabel {
    return _titleLabel;
}

- (GTUIButtonBar *)leadingButtonBar {
    return _leadingButtonBar;
}

- (GTUIButtonBar *)trailingButtonBar {
    return _trailingButtonBar;
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == kKVOContextGTUINavigationBar) {
        void (^mainThreadWork)(void) = ^{
            @synchronized(self->_observedNavigationItemLock) {
                if (object != self->_observedNavigationItem) {
                    return;
                }

                [self setValue:[object valueForKey:keyPath] forKey:keyPath];
            }
        };

        // Ensure that UIKit modifications occur on the main thread.
        if ([NSThread isMainThread]) {
            mainThreadWork();
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:mainThreadWork];
        }

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Layout

- (CGRect)gtui_frameAlignedVertically:(CGRect)frame
                        withinBounds:(CGRect)bounds
                           alignment:(UIControlContentVerticalAlignment)alignment {
    switch (alignment) {
        case UIControlContentVerticalAlignmentBottom:
            return CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(bounds) - CGRectGetHeight(frame),
                              CGRectGetWidth(frame),
                              CGRectGetHeight(frame));

        case UIControlContentVerticalAlignmentCenter: {
            CGFloat centeredY = GTUIFloor((CGRectGetHeight(bounds) - CGRectGetHeight(frame)) / 2) + CGRectGetMinY(bounds);
            return CGRectMake(CGRectGetMinX(frame), centeredY, CGRectGetWidth(frame), CGRectGetHeight(frame));
        }

        case UIControlContentVerticalAlignmentTop: {
            // The title frame is vertically centered with the back button but will stick to the top of
            // the header regardless of the header's height.
            CGFloat maxHeight = kNavigationBarDefaultHeight;
            CGFloat height = MIN(CGRectGetHeight(bounds), maxHeight);
            CGFloat navigationBarCenteredY = GTUIFloor((height - CGRectGetHeight(frame)) / 2);
            navigationBarCenteredY = MAX(0, navigationBarCenteredY);
            return CGRectMake(CGRectGetMinX(frame), navigationBarCenteredY, CGRectGetWidth(frame),
                              CGRectGetHeight(frame));
        }

        case UIControlContentVerticalAlignmentFill: {
            return bounds;
        }
    }
}

- (CGRect)gtui_frameAlignedHorizontally:(CGRect)frame
                             alignment:(GTUINavigationBarTitleAlignment)alignment {
    switch (alignment) {
            // Center align title
        case GTUINavigationBarTitleAlignmentCenter: {
            BOOL isRTL = [self gtf_effectiveUserInterfaceLayoutDirection] ==
            UIUserInterfaceLayoutDirectionRightToLeft;

            GTUIButtonBar *leftButtonBar = self.leadingButtonBar;
            GTUIButtonBar *rightButtonBar = self.trailingButtonBar;
            UIEdgeInsets textInsets = kTextInsets;
            CGFloat titleLeftInset = textInsets.left;
            CGFloat titleRightInset = textInsets.right;

            if (isRTL) {
                leftButtonBar = self.trailingButtonBar;
                rightButtonBar = self.leadingButtonBar;
                titleLeftInset = textInsets.right;
                titleRightInset = textInsets.left;
            }

            // Determine how much space is available to the left/right of the navigation bar's midpoint
            CGFloat midX = CGRectGetMidX(self.bounds);
            CGFloat leftMidSpaceX = midX - CGRectGetMaxX(leftButtonBar.frame) - titleLeftInset;
            CGFloat rightMidSpaceX = CGRectGetMinX(rightButtonBar.frame) - midX - titleRightInset;
            CGFloat halfFrameWidth = CGRectGetWidth(frame) / 2;

            // Place the title in the exact center if we have enough left/right space
            if (leftMidSpaceX >= halfFrameWidth && rightMidSpaceX >= halfFrameWidth) {
                CGFloat xOrigin = CGRectGetMaxX(self.bounds) / 2 - CGRectGetWidth(frame) / 2;
                return CGRectMake(xOrigin, CGRectGetMinY(frame), CGRectGetWidth(frame),
                                  CGRectGetHeight(frame));
            }

            // Place the title as close to the center, shifting it slightly in to the side with more space
            if (leftMidSpaceX >= halfFrameWidth) {
                CGFloat frameMaxX = CGRectGetMinX(rightButtonBar.frame) - titleRightInset;
                return CGRectMake(frameMaxX - CGRectGetWidth(frame), CGRectGetMinY(frame),
                                  CGRectGetWidth(frame),
                                  CGRectGetHeight(frame));
            }
            if (rightMidSpaceX >= halfFrameWidth) {
                CGFloat frameOriginX = CGRectGetMaxX(leftButtonBar.frame) + titleLeftInset;
                return CGRectMake(frameOriginX, CGRectGetMinY(frame), CGRectGetWidth(frame),
                                  CGRectGetHeight(frame));
            }
        }
            // Intentional fall through
        case GTUINavigationBarTitleAlignmentLeading:
            return frame;
    }
}

- (NSArray<UIBarButtonItem *> *)gtui_buttonItemsForLeadingBar {
    if (!self.leadingItemsSupplementBackButton && self.leadingBarButtonItems.count > 0) {
        return self.leadingBarButtonItems;
    }

    NSMutableArray<UIBarButtonItem *> *buttonItems = [NSMutableArray array];
    if (self.backItem && !self.hidesBackButton) {
        [buttonItems addObject:self.backItem];
    }
    [buttonItems addObjectsFromArray:self.leadingBarButtonItems];
    return buttonItems;
}

#pragma mark Colors

- (void)tintColorDidChange {
    [super tintColorDidChange];

    // Tint color should only modify interactive elements
    _leadingButtonBar.tintColor = self.leadingBarItemsTintColor ?: self.tintColor;
    _trailingButtonBar.tintColor = self.trailingBarItemsTintColor ?: self.tintColor;
}

#pragma mark Public

- (void)setTitle:(NSString *)title {
    // |self.titleTextAttributes| can only be set if |title| is set
    if (self.titleTextAttributes && title.length > 0) {
        _titleLabel.attributedText =
        [[NSAttributedString alloc] initWithString:title attributes:_titleTextAttributes];
    } else {
        _titleLabel.text = title;
    }
    [self setNeedsLayout];
}

- (NSString *)title {
    return _titleLabel.text;
}

- (void)setTitleView:(UIView *)titleView {
    if (self.titleView == titleView) {
        return;
    }
    // Ignore sandbag KVO events
    if ([_observedNavigationItem.titleView isKindOfClass:[GTUINavigationBarSandbagView class]]) {
        return;
    }

    // Swap in the sandbag (so that UINavigationController won't steal our view). It's important that
    // we do this before we add titleView as a subview, because starting from iOS 11 the navigation
    // item will call |removeFromSuperview| on the old titleView when we replace it.
    if (titleView) {
        _observedNavigationItem.titleView = [[GTUINavigationBarSandbagView alloc] init];
    } else if (_observedNavigationItem.titleView) {
        _observedNavigationItem.titleView = nil;
    }

    [self.titleView removeFromSuperview];
    _titleView = titleView;

    if (_titleView != nil) {
        [self addSubview:_titleView];
    }

    _titleLabel.hidden = _titleView != nil;

    [self setNeedsLayout];
}

- (void)setTitleTextAttributes:(NSDictionary<NSString *, id> *)titleTextAttributes {
    // If title dictionary is equivalent, no need to make changes
    if ([_titleTextAttributes isEqualToDictionary:titleTextAttributes]) {
        return;
    }

    // Copy attributes dictionary
    _titleTextAttributes = [titleTextAttributes copy];
    if (_titleLabel) {
        // |_titleTextAttributes| can only be set if |self.title| is set
        if (_titleTextAttributes && self.title.length > 0) {
            // Set label text as newly created attributed string with attributes if non-nil
            _titleLabel.attributedText =
            [[NSAttributedString alloc] initWithString:self.title attributes:_titleTextAttributes];
        } else {
            // Otherwise set titleLabel text property
            _titleLabel.text = self.title;
        }
        [self setNeedsLayout];
    }
}

- (void)setButtonsTitleFont:(UIFont *)font forState:(UIControlState)state {
    [_leadingButtonBar setButtonsTitleFont:font forState:state];
    [_trailingButtonBar setButtonsTitleFont:font forState:state];
}

- (UIFont *)buttonsTitleFontForState:(UIControlState)state {
    return [_leadingButtonBar buttonsTitleFontForState:state];
}

- (void)setButtonsTitleColor:(UIColor *)color forState:(UIControlState)state {
    [_leadingButtonBar setButtonsTitleColor:color forState:state];
    [_trailingButtonBar setButtonsTitleColor:color forState:state];
}

- (UIColor *)buttonsTitleColorForState:(UIControlState)state {
    return [_leadingButtonBar buttonsTitleColorForState:state];
}

- (void)setLeadingBarItemsTintColor:(UIColor *)leadingBarItemsTintColor {
    _leadingBarItemsTintColor = leadingBarItemsTintColor;
    self.leadingButtonBar.tintColor = leadingBarItemsTintColor;
}

- (void)setTrailingBarItemsTintColor:(UIColor *)trailingBarItemsTintColor {
    _trailingBarItemsTintColor = trailingBarItemsTintColor;
    self.trailingButtonBar.tintColor = trailingBarItemsTintColor;
}

- (void)setLeadingBarButtonItems:(NSArray<UIBarButtonItem *> *)leadingBarButtonItems {
    _leadingBarButtonItems = [leadingBarButtonItems copy];
    _leadingButtonBar.items = [self gtui_buttonItemsForLeadingBar];
    [self setNeedsLayout];
}

- (void)setTrailingBarButtonItems:(NSArray<UIBarButtonItem *> *)trailingBarButtonItems {
    _trailingBarButtonItems = [trailingBarButtonItems copy];
    _trailingButtonBar.items = _trailingBarButtonItems;
    [self setNeedsLayout];
}

- (void)setLeadingBarButtonItem:(UIBarButtonItem *)leadingBarButtonItem {
    self.leadingBarButtonItems = leadingBarButtonItem ? @[ leadingBarButtonItem ] : nil;
}

- (UIBarButtonItem *)leadingBarButtonItem {
    return [self.leadingBarButtonItems firstObject];
}

- (void)setTrailingBarButtonItem:(UIBarButtonItem *)trailingBarButtonItem {
    self.trailingBarButtonItems = trailingBarButtonItem ? @[ trailingBarButtonItem ] : nil;
}

- (UIBarButtonItem *)trailingBarButtonItem {
    return [self.trailingBarButtonItems firstObject];
}

- (void)setBackBarButtonItem:(UIBarButtonItem *)backBarButtonItem {
    self.backItem = backBarButtonItem;
}

- (UIBarButtonItem *)backBarButtonItem {
    return self.backItem;
}

- (void)setBackItem:(UIBarButtonItem *)backItem {
    if (_backItem == backItem) {
        return;
    }
    _backItem = backItem;
    _leadingButtonBar.items = [self gtui_buttonItemsForLeadingBar];
    [self setNeedsLayout];
}

- (void)setHidesBackButton:(BOOL)hidesBackButton {
    if (_hidesBackButton == hidesBackButton) {
        return;
    }
    _hidesBackButton = hidesBackButton;
    _leadingButtonBar.items = [self gtui_buttonItemsForLeadingBar];
    [self setNeedsLayout];
}

- (void)setLeadingItemsSupplementBackButton:(BOOL)leadingItemsSupplementBackButton {
    if (_leadingItemsSupplementBackButton == leadingItemsSupplementBackButton) {
        return;
    }
    _leadingItemsSupplementBackButton = leadingItemsSupplementBackButton;
    _leadingButtonBar.items = [self gtui_buttonItemsForLeadingBar];
    [self setNeedsLayout];
}

- (void)setInkColor:(UIColor *)inkColor {
    if (_inkColor == inkColor) {
        return;
    }
    _inkColor = inkColor;
    _leadingButtonBar.inkColor = inkColor;
    _trailingButtonBar.inkColor = inkColor;
}

- (void)setObservedNavigationItem:(UINavigationItem *)navigationItem {
    @synchronized(_observedNavigationItemLock) {
        if (navigationItem == _observedNavigationItem) {
            return;
        }

        NSArray<NSString *> *keyPaths = GTUINavigationBarNavigationItemKVOPaths();
        for (NSString *keyPath in keyPaths) {
            [_observedNavigationItem removeObserver:self
                                         forKeyPath:keyPath
                                            context:kKVOContextGTUINavigationBar];
        }

        _observedNavigationItem = navigationItem;

        NSKeyValueObservingOptions options =
        (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial);
        for (NSString *keyPath in keyPaths) {
            [_observedNavigationItem addObserver:self
                                      forKeyPath:keyPath
                                         options:options
                                         context:kKVOContextGTUINavigationBar];
        }
    }
}

- (void)observeNavigationItem:(UINavigationItem *)navigationItem {
    [self setObservedNavigationItem:navigationItem];
}

- (void)unobserveNavigationItem {
    [self setObservedNavigationItem:nil];
}

#pragma mark UINavigationItem interface matching

- (NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    return self.leadingBarButtonItems;
}

- (void)setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    self.leadingBarButtonItems = leftBarButtonItems;
}

- (NSArray<UIBarButtonItem *> *)rightBarButtonItems {
    return self.trailingBarButtonItems;
}

- (void)setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems {
    self.trailingBarButtonItems = rightBarButtonItems;
}

- (UIBarButtonItem *)leftBarButtonItem {
    return self.leadingBarButtonItem;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    self.leadingBarButtonItem = leftBarButtonItem;
}

- (UIBarButtonItem *)rightBarButtonItem {
    return self.trailingBarButtonItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    self.trailingBarButtonItem = rightBarButtonItem;
}

- (BOOL)leftItemsSupplementBackButton {
    return self.leadingItemsSupplementBackButton;
}

- (void)setLeftItemsSupplementBackButton:(BOOL)leftItemsSupplementBackButton {
    self.leadingItemsSupplementBackButton = leftItemsSupplementBackButton;
}



@end
