//
//  GTUITabBar.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUITabBar.h"

#import "GTUITabBarIndicatorTemplate.h"
#import "GTUITabBarUnderlineIndicatorTemplate.h"
#import "GTInk.h"
#import "GTTypography.h"
#import "private/GTUIItemBar.h"
#import "private/GTUIItemBarAlignment.h"
#import "private/GTUIItemBarStyle.h"

static NSString *const GTUITabBarItemsKey = @"GTUITabBarItemsKey";
static NSString *const GTUITabBarSelectedItemKey = @"GTUITabBarSelectedItemKey";
static NSString *const GTUITabBarDelegateKey = @"GTUITabBarDelegateKey";
static NSString *const GTUITabBarTintColorKey = @"GTUITabBarTintColorKey";
static NSString *const GTUITabBarSelectedItemTintColorKey = @"GTUITabBarSelectedItemTintColorKey";
static NSString *const GTUITabBarUnselectedItemTintColorKey = @"GTUITabBarUnselectedItemTintColorKey";
static NSString *const GTUITabBarInkColorKey = @"GTUITabBarInkColorKey";
static NSString *const GTUITabBarSelectedItemTitleFontKey = @"GTUITabBarSelectedItemTitleFontKey";
static NSString *const GTUITabBarUnselectedItemTitleFontKey = @"GTUITabBarUnselectedItemTitleFontKey";
static NSString *const GTUITabBarBarTintColorKey = @"GTUITabBarBarTintColorKey";
static NSString *const GTUITabBarAlignmentKey = @"GTUITabBarAlignmentKey";
static NSString *const GTUITabBarItemApperanceKey = @"GTUITabBarItemApperanceKey";
static NSString *const GTUITabBarDisplaysUppercaseTitlesKey = @"GTUITabBarDisplaysUppercaseTitlesKey";
static NSString *const GTUITabBarTitleTextTransformKey = @"GTUITabBarTitleTextTransformKey";
static NSString *const GTUITabBarSelectionIndicatorTemplateKey = @"GTUITabBarSelectionIndicatorTemplateKey";

/// Padding between image and title in points, according to the spec.
static const CGFloat kImageTitleSpecPadding = 10;

/// Adjustment added to spec measurements to compensate for internal paddings.
static const CGFloat kImageTitlePaddingAdjustment = -3;

// Heights based on the spec: https://material.io/go/design-tabs

/// Height for image-only tab bars, in points.
static const CGFloat kImageOnlyBarHeight = 48;

/// Height for image-only tab bars, in points.
static const CGFloat kTitleOnlyBarHeight = 48;

/// Height for image-and-title tab bars, in points.
static const CGFloat kTitledImageBarHeight = 72;

/// Height for bottom navigation bars, in points.
static const CGFloat kBottomNavigationBarHeight = 56;

/// Maximum width for individual items in bottom navigation bars, in points.
static const CGFloat kBottomNavigationMaximumItemWidth = 168;

/// Title-image padding for bottom navigation bars, in points.
static const CGFloat kBottomNavigationTitleImagePadding = 3;

/// Height for the bottom divider.
static const CGFloat kBottomNavigationBarDividerHeight = 1;

static GTUIItemBarAlignment GTUIItemBarAlignmentForTabBarAlignment(GTUITabBarAlignment alignment) {
    switch (alignment) {
        case GTUITabBarAlignmentCenter:
            return GTUIItemBarAlignmentCenter;

        case GTUITabBarAlignmentLeading:
            return GTUIItemBarAlignmentLeading;

        case GTUITabBarAlignmentJustified:
            return GTUIItemBarAlignmentJustified;

        case GTUITabBarAlignmentCenterSelected:
            return GTUIItemBarAlignmentCenterSelected;
    }

    NSCAssert(0, @"Invalid alignment value %ld", (long)alignment);
    return GTUIItemBarAlignmentLeading;
}

@interface GTUITabBar () <GTUIItemBarDelegate>
@end

@implementation GTUITabBar {
    /// Item bar responsible for displaying the actual tab bar content.
    GTUIItemBar *_itemBar;

    UIView *_dividerBar;

    // Flags tracking if properties are unset and using default values.
    BOOL _hasDefaultAlignment;
    BOOL _hasDefaultItemAppearance;

    // For properties which have been set, these store the new fixed values.
    GTUITabBarAlignment _alignmentOverride;
    GTUITabBarItemAppearance _itemAppearanceOverride;

    UIColor *_selectedTitleColor;
    UIColor *_unselectedTitleColor;
}
// Inherit UIView's tintColor logic.
@dynamic tintColor;
@synthesize alignment = _alignment;
@synthesize barPosition = _barPosition;
@synthesize itemAppearance = _itemAppearance;

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonGTUITabBarInit];

        // Use self. when setter needs to be called
        if ([aDecoder containsValueForKey:GTUITabBarItemsKey]) {
            self.items = [aDecoder decodeObjectOfClass:[NSArray class] forKey:GTUITabBarItemsKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarSelectedItemKey]) {
            self.selectedItem = [aDecoder decodeObjectOfClass:[UIBarButtonItem class]
                                                       forKey:GTUITabBarSelectedItemKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarDelegateKey]) {
            self.delegate = [aDecoder decodeObjectForKey:GTUITabBarDelegateKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarTintColorKey]) {
            self.tintColor = [aDecoder decodeObjectOfClass:[UIColor class]
                                                    forKey:GTUITabBarTintColorKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarSelectedItemTintColorKey]) {
            _selectedItemTintColor = [aDecoder decodeObjectOfClass:[UIColor class]
                                                            forKey:GTUITabBarSelectedItemTintColorKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarUnselectedItemTintColorKey]) {
            _unselectedItemTintColor =
            [aDecoder decodeObjectOfClass:[UIColor class] forKey:GTUITabBarUnselectedItemTintColorKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarInkColorKey]) {
            _inkColor = [aDecoder decodeObjectOfClass:[UIColor class] forKey:GTUITabBarInkColorKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarSelectedItemTitleFontKey]) {
            _selectedItemTitleFont = [aDecoder decodeObjectOfClass:[UIFont class]
                                                            forKey:GTUITabBarSelectedItemTitleFontKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarUnselectedItemTitleFontKey]) {
            _unselectedItemTitleFont =
            [aDecoder decodeObjectOfClass:[UIFont class] forKey:GTUITabBarUnselectedItemTitleFontKey];
        }

        if ([aDecoder containsValueForKey:GTUITabBarBarTintColorKey]) {
            self.barTintColor = [aDecoder decodeObjectOfClass:[UIColor class]
                                                       forKey:GTUITabBarBarTintColorKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarAlignmentKey]) {
            self.alignment = [aDecoder decodeIntegerForKey:GTUITabBarAlignmentKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarItemApperanceKey]) {
            self.itemAppearance = [aDecoder decodeIntegerForKey:GTUITabBarItemApperanceKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarDisplaysUppercaseTitlesKey]) {
            self.displaysUppercaseTitles = [aDecoder decodeBoolForKey:GTUITabBarDisplaysUppercaseTitlesKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarTitleTextTransformKey]) {
            _titleTextTransform = [aDecoder decodeIntegerForKey:GTUITabBarTitleTextTransformKey];
        }
        if ([aDecoder containsValueForKey:GTUITabBarSelectionIndicatorTemplateKey]) {
            _selectionIndicatorTemplate =
            [aDecoder decodeObjectOfClass:[NSObject class]
                                   forKey:GTUITabBarSelectionIndicatorTemplateKey];
        }
        [self updateItemBarStyle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonGTUITabBarInit];
    }
    return self;
}

- (void)commonGTUITabBarInit {
    _bottomDividerColor = [UIColor clearColor];
    _selectedItemTintColor = [UIColor whiteColor];
    _unselectedItemTintColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    _selectedTitleColor = _selectedItemTintColor;
    _unselectedTitleColor = _unselectedItemTintColor;
    _inkColor = [UIColor colorWithWhite:1.0f alpha:0.7f];

    self.clipsToBounds = YES;
    _barPosition = UIBarPositionAny;
    _hasDefaultItemAppearance = YES;
    _hasDefaultAlignment = YES;

    // Set default values
    _alignment = [self computedAlignment];
    _titleTextTransform = GTUITabBarTextTransformAutomatic;
    _itemAppearance = [self computedItemAppearance];
    _selectionIndicatorTemplate = [GTUITabBar defaultSelectionIndicatorTemplate];
    _selectedItemTitleFont = [GTUITypography buttonFont];
    _unselectedItemTitleFont = [GTUITypography buttonFont];

    // Create item bar.
    _itemBar = [[GTUIItemBar alloc] initWithFrame:self.bounds];
    _itemBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _itemBar.delegate = self;
    _itemBar.alignment = GTUIItemBarAlignmentForTabBarAlignment(_alignment);
    [self addSubview:_itemBar];

    CGFloat dividerTop = CGRectGetMaxY(self.bounds) - kBottomNavigationBarDividerHeight;
    _dividerBar =
    [[UIView alloc] initWithFrame:CGRectMake(0,
                                             dividerTop,
                                             CGRectGetWidth(self.bounds),
                                             kBottomNavigationBarDividerHeight)];
    _dividerBar.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _dividerBar.backgroundColor = _bottomDividerColor;
    [self addSubview:_dividerBar];

    [self updateItemBarStyle];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize sizeThatFits = [_itemBar sizeThatFits:self.bounds.size];
    _itemBar.frame = CGRectMake(0, 0, sizeThatFits.width, sizeThatFits.height);
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.items forKey:GTUITabBarItemsKey];
    [aCoder encodeObject:self.selectedItem forKey:GTUITabBarSelectedItemKey];
    [aCoder encodeConditionalObject:self.delegate forKey:GTUITabBarDelegateKey];
    [aCoder encodeObject:self.tintColor forKey:GTUITabBarTintColorKey];
    [aCoder encodeObject:_selectedItemTintColor forKey:GTUITabBarSelectedItemTintColorKey];
    [aCoder encodeObject:_unselectedItemTintColor forKey:GTUITabBarUnselectedItemTintColorKey];
    [aCoder encodeObject:_inkColor forKey:GTUITabBarInkColorKey];
    [aCoder encodeObject:_selectedItemTitleFont forKey:GTUITabBarSelectedItemTitleFontKey];
    [aCoder encodeObject:_unselectedItemTitleFont forKey:GTUITabBarUnselectedItemTitleFontKey];
    [aCoder encodeObject:_barTintColor forKey:GTUITabBarBarTintColorKey];
    [aCoder encodeInteger:_alignment forKey:GTUITabBarAlignmentKey];
    [aCoder encodeInteger:_itemAppearance forKey:GTUITabBarItemApperanceKey];
    [aCoder encodeBool:self.displaysUppercaseTitles forKey:GTUITabBarDisplaysUppercaseTitlesKey];
    [aCoder encodeInteger:_titleTextTransform forKey:GTUITabBarTitleTextTransformKey];
    if ([_selectionIndicatorTemplate conformsToProtocol:@protocol(NSCoding)]) {
        [aCoder encodeObject:_selectionIndicatorTemplate
                      forKey:GTUITabBarSelectionIndicatorTemplateKey];
    }
}

#pragma mark - Public

+ (CGFloat)defaultHeightForBarPosition:(UIBarPosition)position
                        itemAppearance:(GTUITabBarItemAppearance)appearance {
    if ([self isTopTabsForPosition:position]) {
        switch (appearance) {
            case GTUITabBarItemAppearanceTitledImages:
                return kTitledImageBarHeight;

            case GTUITabBarItemAppearanceTitles:
                return kTitleOnlyBarHeight;

            case GTUITabBarItemAppearanceImages:
                return kImageOnlyBarHeight;
        }
    } else {
        // Bottom navigation has a fixed height.
        return kBottomNavigationBarHeight;
    }
}

+ (CGFloat)defaultHeightForItemAppearance:(GTUITabBarItemAppearance)appearance {
    return [self defaultHeightForBarPosition:UIBarPositionAny itemAppearance:appearance];
}

- (void)setTitleColor:(nullable UIColor *)color forState:(GTUITabBarItemState)state {
    switch (state) {
        case GTUITabBarItemStateNormal:
            _unselectedTitleColor = color;
            break;
        case GTUITabBarItemStateSelected:
            _selectedTitleColor = color;
            break;
    }
    [self updateItemBarStyle];
}

- (nullable UIColor *)titleColorForState:(GTUITabBarItemState)state {
    switch (state) {
        case GTUITabBarItemStateNormal:
            return _unselectedTitleColor;
            break;
        case GTUITabBarItemStateSelected:
            return _selectedTitleColor;
            break;
    }
}

- (void)setImageTintColor:(nullable UIColor *)color forState:(GTUITabBarItemState)state {
    switch (state) {
        case GTUITabBarItemStateNormal:
            _unselectedItemTintColor = color;
            break;
        case GTUITabBarItemStateSelected:
            _selectedItemTintColor = color;
            break;
    }
    [self updateItemBarStyle];
}

- (nullable UIColor *)imageTintColorForState:(GTUITabBarItemState)state {
    switch (state) {
        case GTUITabBarItemStateNormal:
            return _unselectedItemTintColor;
            break;
        case GTUITabBarItemStateSelected:
            return _selectedItemTintColor;
            break;
    }
}

- (void)setDelegate:(id<GTUITabBarDelegate>)delegate {
    if (delegate != _delegate) {
        _delegate = delegate;

        // Delegate determines the position - update immediately.
        [self updateItemBarPosition];
    }
}

- (NSArray<UITabBarItem *> *)items {
    return _itemBar.items;
}

- (void)setItems:(NSArray<UITabBarItem *> *)items {
    _itemBar.items = items;
}

- (UITabBarItem *)selectedItem {
    return _itemBar.selectedItem;
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem {
    _itemBar.selectedItem = selectedItem;
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem animated:(BOOL)animated {
    [_itemBar setSelectedItem:selectedItem animated:animated];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    if (_barTintColor != barTintColor && ![_barTintColor isEqual:barTintColor]) {
        _barTintColor = barTintColor;

        // Update background color.
        self.backgroundColor = barTintColor;
    }
}

- (void)setInkColor:(UIColor *)inkColor {
    if (_inkColor != inkColor && ![_inkColor isEqual:inkColor]) {
        _inkColor = inkColor;

        [self updateItemBarStyle];
    }
}

- (void)setUnselectedItemTitleFont:(UIFont *)unselectedItemTitleFont {
    if ((unselectedItemTitleFont != _unselectedItemTitleFont) &&
        ![unselectedItemTitleFont isEqual:_unselectedItemTitleFont]) {
        _unselectedItemTitleFont = unselectedItemTitleFont;
        [self updateItemBarStyle];
    }
}

- (void)setSelectedItemTitleFont:(UIFont *)selectedItemTitleFont {
    if ((selectedItemTitleFont != _selectedItemTitleFont) &&
        ![selectedItemTitleFont isEqual:_selectedItemTitleFont]) {
        _selectedItemTitleFont = selectedItemTitleFont;
        [self updateItemBarStyle];
    }
}

- (void)setAlignment:(GTUITabBarAlignment)alignment {
    [self setAlignment:alignment animated:NO];
}

- (void)setAlignment:(GTUITabBarAlignment)alignment animated:(BOOL)animated {
    _hasDefaultAlignment = NO;
    _alignmentOverride = alignment;
    [self internalSetAlignment:[self computedAlignment] animated:animated];
}

- (void)setItemAppearance:(GTUITabBarItemAppearance)itemAppearance {
    _hasDefaultItemAppearance = NO;
    _itemAppearanceOverride = itemAppearance;
    [self internalSetItemAppearance:[self computedItemAppearance]];
}

- (void)setSelectedItemTintColor:(UIColor *)selectedItemTintColor {
    if (_selectedItemTintColor != selectedItemTintColor &&
        ![_selectedItemTintColor isEqual:selectedItemTintColor]) {
        _selectedItemTintColor = selectedItemTintColor;
        _selectedTitleColor = selectedItemTintColor;

        [self updateItemBarStyle];
    }
}

- (void)setUnselectedItemTintColor:(UIColor *)unselectedItemTintColor {
    if (_unselectedItemTintColor != unselectedItemTintColor &&
        ![_unselectedItemTintColor isEqual:unselectedItemTintColor]) {
        _unselectedItemTintColor = unselectedItemTintColor;
        _unselectedTitleColor = unselectedItemTintColor;

        [self updateItemBarStyle];
    }
}

- (BOOL)displaysUppercaseTitles {
    switch (self.titleTextTransform) {
        case GTUITabBarTextTransformAutomatic:
            return [GTUITabBar displaysUppercaseTitlesByDefaultForPosition:_barPosition];

        case GTUITabBarTextTransformNone:
            return NO;

        case GTUITabBarTextTransformUppercase:
            return YES;
    }
}

- (void)setDisplaysUppercaseTitles:(BOOL)displaysUppercaseTitles {
    self.titleTextTransform =
    displaysUppercaseTitles ? GTUITabBarTextTransformUppercase : GTUITabBarTextTransformNone;
}

- (void)setTitleTextTransform:(GTUITabBarTextTransform)titleTextTransform {
    if (titleTextTransform != _titleTextTransform) {
        _titleTextTransform = titleTextTransform;
        [self updateItemBarStyle];
    }
}

- (void)setSelectionIndicatorTemplate:(id<GTUITabBarIndicatorTemplate>)selectionIndicatorTemplate {
    id<GTUITabBarIndicatorTemplate> template = selectionIndicatorTemplate;
    if (!template) {
        template = [GTUITabBar defaultSelectionIndicatorTemplate];
    }
    _selectionIndicatorTemplate = template;
    [self updateItemBarStyle];
}

- (void)setBottomDividerColor:(UIColor *)bottomDividerColor {
    if (_bottomDividerColor != bottomDividerColor) {
        _bottomDividerColor = bottomDividerColor;
        _dividerBar.backgroundColor = _bottomDividerColor;
    }
}

#pragma mark - GTUIAccessibility

- (id)accessibilityElementForItem:(UITabBarItem *)item {
    return [_itemBar accessibilityElementForItem:item];
}

#pragma mark - GTUIItemBarDelegate

- (void)itemBar:(__unused GTUIItemBar *)itemBar didSelectItem:(UITabBarItem *)item {
    id<GTUITabBarDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
        [delegate tabBar:self didSelectItem:item];
    }
}

- (BOOL)itemBar:(__unused GTUIItemBar *)itemBar shouldSelectItem:(UITabBarItem *)item {
    id<GTUITabBarDelegate> delegate = self.delegate;
    BOOL shouldSelect = YES;
    if ([delegate respondsToSelector:@selector(tabBar:shouldSelectItem:)]) {
        shouldSelect = [delegate tabBar:self shouldSelectItem:item];
    }
    if (shouldSelect && [delegate respondsToSelector:@selector(tabBar:willSelectItem:)]) {
        [delegate tabBar:self willSelectItem:item];
    }
    return shouldSelect;
}

#pragma mark - UIView

- (void)tintColorDidChange {
    [super tintColorDidChange];

    [self updateItemBarStyle];
}

- (CGSize)intrinsicContentSize {
    return _itemBar.intrinsicContentSize;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [_itemBar sizeThatFits:size];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];

    // Ensure the bar position is up to date before moving to a window.
    [self updateItemBarPosition];
}

#pragma mark - Private

+ (GTUIItemBarStyle *)defaultStyleForPosition:(UIBarPosition)position
                              itemAppearance:(GTUITabBarItemAppearance)appearance {
    GTUIItemBarStyle *style = [[GTUIItemBarStyle alloc] init];

    // Set base style using position.
    if ([self isTopTabsForPosition:position]) {
        // Top tabs
        style.shouldDisplaySelectionIndicator = YES;
        style.shouldGrowOnSelection = NO;
        style.inkStyle = GTUIInkStyleBounded;
        style.titleImagePadding = (kImageTitleSpecPadding + kImageTitlePaddingAdjustment);
        style.textOnlyNumberOfLines = 2;
    } else {
        // Bottom navigation
        style.shouldDisplaySelectionIndicator = NO;
        style.shouldGrowOnSelection = YES;
        style.maximumItemWidth = kBottomNavigationMaximumItemWidth;
        style.inkStyle = GTUIInkStyleUnbounded;
        style.titleImagePadding = kBottomNavigationTitleImagePadding;
        style.textOnlyNumberOfLines = 1;
    }

    // Update appearance-dependent style properties.
    BOOL displayImage = NO;
    BOOL displayTitle = NO;
    switch (appearance) {
        case GTUITabBarItemAppearanceImages:
            displayImage = YES;
            break;

        case GTUITabBarItemAppearanceTitles:
            displayTitle = YES;
            break;

        case GTUITabBarItemAppearanceTitledImages:
            displayImage = YES;
            displayTitle = YES;
            break;

        default:
            NSAssert(0, @"Invalid appearance value %ld", (long)appearance);
            displayTitle = YES;
            break;
    }
    style.shouldDisplayImage = displayImage;
    style.shouldDisplayTitle = displayTitle;

    // Update default height
    CGFloat defaultHeight = [self defaultHeightForBarPosition:position itemAppearance:appearance];
    if (defaultHeight == 0) {
        NSAssert(0, @"Missing default height for %ld", (long)appearance);
        defaultHeight = kTitleOnlyBarHeight;
    }
    style.defaultHeight = defaultHeight;

    // Only show badge with images.
    style.shouldDisplayBadge = displayImage;

    return style;
}

+ (BOOL)isTopTabsForPosition:(UIBarPosition)position {
    switch (position) {
        case UIBarPositionAny:
        case UIBarPositionTop:
            return YES;

        case UIBarPositionBottom:
            return NO;

        case UIBarPositionTopAttached:
            NSAssert(NO, @"GTUITabBar does not support UIBarPositionTopAttached");
            return NO;
    }
}

+ (BOOL)displaysUppercaseTitlesByDefaultForPosition:(UIBarPosition)position {
    switch (position) {
        case UIBarPositionAny:
        case UIBarPositionTop:
            return YES;

        case UIBarPositionBottom:
            return NO;

        case UIBarPositionTopAttached:
            NSAssert(NO, @"GTUITabBar does not support UIBarPositionTopAttached");
            return YES;
    }
}

+ (GTUITabBarAlignment)defaultAlignmentForPosition:(UIBarPosition)position {
    switch (position) {
        case UIBarPositionAny:
        case UIBarPositionTop:
            return GTUITabBarAlignmentLeading;

        case UIBarPositionBottom:
            return GTUITabBarAlignmentJustified;

        case UIBarPositionTopAttached:
            NSAssert(NO, @"GTUITabBar does not support UIBarPositionTopAttached");
            return GTUITabBarAlignmentLeading;
    }
}

+ (GTUITabBarItemAppearance)defaultItemAppearanceForPosition:(UIBarPosition)position {
    switch (position) {
        case UIBarPositionAny:
        case UIBarPositionTop:
            return GTUITabBarItemAppearanceTitles;

        case UIBarPositionBottom:
            return GTUITabBarItemAppearanceTitledImages;

        case UIBarPositionTopAttached:
            NSAssert(NO, @"GTUITabBar does not support UIBarPositionTopAttached");
            return YES;
    }
}

+ (id<GTUITabBarIndicatorTemplate>)defaultSelectionIndicatorTemplate {
    return [[GTUITabBarUnderlineIndicatorTemplate alloc] init];
}

- (GTUITabBarAlignment)computedAlignment {
    if (_hasDefaultAlignment) {
        return [[self class] defaultAlignmentForPosition:_barPosition];
    } else {
        return _alignmentOverride;
    }
}

- (GTUITabBarItemAppearance)computedItemAppearance {
    if (_hasDefaultItemAppearance) {
        return [[self class] defaultItemAppearanceForPosition:_barPosition];
    } else {
        return _itemAppearanceOverride;
    }
}

- (void)internalSetAlignment:(GTUITabBarAlignment)alignment animated:(BOOL)animated {
    if (_alignment != alignment) {
        _alignment = alignment;
        [_itemBar setAlignment:GTUIItemBarAlignmentForTabBarAlignment(_alignment) animated:animated];
    }
}

- (void)internalSetItemAppearance:(GTUITabBarItemAppearance)itemAppearance {
    if (_itemAppearance != itemAppearance) {
        _itemAppearance = itemAppearance;
        [self updateItemBarStyle];
    }
}

- (void)updateItemBarPosition {
    UIBarPosition newPosition = UIBarPositionAny;
    id<GTUITabBarDelegate> delegate = _delegate;
    if (delegate && [delegate respondsToSelector:@selector(positionForBar:)]) {
        newPosition = [delegate positionForBar:self];
    }

    if (_barPosition != newPosition) {
        _barPosition = newPosition;
        [self updatePositionDerivedDefaultValues];
        [self updateItemBarStyle];
    }
}

- (void)updatePositionDerivedDefaultValues {
    [self internalSetAlignment:[self computedAlignment] animated:NO];
    [self internalSetItemAppearance:[self computedItemAppearance]];
}

/// Update the item bar's style property, which depends on the bar position and item appearance.
- (void)updateItemBarStyle {
    GTUIItemBarStyle *style;

    style = [[self class] defaultStyleForPosition:_barPosition itemAppearance:_itemAppearance];

    if ([GTUITabBar isTopTabsForPosition:_barPosition]) {
        // Top tabs: Use provided fonts.
        style.selectedTitleFont = self.selectedItemTitleFont;
        style.unselectedTitleFont = self.unselectedItemTitleFont;
    } else {
        // Bottom navigation: Ignore provided fonts.
        style.selectedTitleFont = [[GTUITypography fontLoader] regularFontOfSize:12];
        style.unselectedTitleFont = [[GTUITypography fontLoader] regularFontOfSize:12];
    }

    style.selectionIndicatorTemplate = self.selectionIndicatorTemplate;
    style.selectionIndicatorColor = self.tintColor;
    style.inkColor = _inkColor;
    style.displaysUppercaseTitles = self.displaysUppercaseTitles;

    style.selectedTitleColor = _selectedTitleColor ?: self.tintColor;
    style.titleColor = _unselectedTitleColor;
    style.selectedImageTintColor = _selectedItemTintColor ?: self.tintColor;
    style.imageTintColor = _unselectedItemTintColor;

    [_itemBar applyStyle:style];

    // Layout depends on -[GTUIItemBar sizeThatFits], which depends on the style.
    [self setNeedsLayout];
}

@end

