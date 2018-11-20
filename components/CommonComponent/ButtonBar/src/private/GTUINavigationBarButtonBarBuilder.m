//
//  GTUINavigationBarButtonBarBuilder.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import "GTUINavigationBarButtonBarBuilder.h"

#import <objc/runtime.h>
#import <GTFInternationalization/GTFInternationalization.h>

#import "GTButton.h"
#import "GTUIButtonBarButton.h"
#import "GTUIButtonBar+Private.h"

// Additional insets for the left-most or right-most items.
static const CGFloat kEdgeButtonAdditionalMarginPhone = 4.f;
static const CGFloat kEdgeButtonAdditionalMarginPad = 12.f;

// The default GTUIButton's alpha for display state is 0.1f which in the context of bar buttons
// makes it practically invisible. Setting button to a higher opacity is closer to what the
// button should look like when it is disabled.
static const CGFloat kDisabledButtonAlpha = 0.38f;

// Default content inset for buttons.
static const UIEdgeInsets kButtonInset = {0, 12.0f, 0, 12.0f};

// Indiana Jones style placeholder view for UINavigationBar. Ownership of UIBarButtonItem.customView
// and UINavigationItem.titleView are normally transferred to UINavigationController but we plan to
// steal them away. In order to avoid crashing during KVO updates, we steal the view away and
// replace it with a sandbag view.
@interface GTUIButtonBarSandbagView : UIView
@end

@interface UIBarButtonItem (GTUIHeaderInternal)

// Internal version of the standard -customView property. When an item is pushed onto a
// UINavigationController stack, any -customView object is moved over to this property. This
// prevents UINavigationController from adding the customView to its own view hierarchy.
@property(nonatomic, strong, setter=gtui_setCustomView:) UIView *gtui_customView;

@end

@implementation GTUINavigationBarButtonBarBuilder{
    NSMutableDictionary<NSNumber *, UIFont *> *_fonts;
    NSMutableDictionary<NSNumber *, UIColor *> *_titleColors;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _fonts = [NSMutableDictionary dictionary];
        _titleColors = [NSMutableDictionary dictionary];
    }
    return self;
}

- (nullable UIFont *)titleFontForState:(UIControlState)state {
    UIFont *font = _fonts[@(state)];
    if (!font && state != UIControlStateNormal) {
        font = _fonts[@(UIControlStateNormal)];
    }
    return font;
}

- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state {
    _fonts[@(state)] = font;
}

- (UIColor *)titleColorForState:(UIControlState)state {
    UIColor *color = _titleColors[@(state)];
    if (!color && state != UIControlStateNormal) {
        color = _titleColors[@(UIControlStateNormal)];
    }
    return color;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    _titleColors[@(state)] = color;
}

#pragma mark - GTUIBarButtonItemBuilding

- (UIView *)buttonBar:(GTUIButtonBar *)buttonBar
          viewForItem:(UIBarButtonItem *)buttonItem
          layoutHints:(GTUIBarButtonItemLayoutHints)layoutHints {
    if (buttonItem == nil) {
        return nil;
    }

    // Transfer custom view ownership if necessary.
    [self transferCustomViewOwnershipForBarButtonItem:buttonItem];

    // Take the real custom view if it exists instead of sandbag view.
    UIView *customView =
    buttonItem.gtui_customView ? buttonItem.gtui_customView : buttonItem.customView;
    if (customView) {
        return customView;
    }

    // NOTE: This assertion does not occur in release builds because it is accessing a private api.
#if DEBUG
    NSAssert(![[buttonItem valueForKey:@"isSystemItem"] boolValue],
             @"Instances of %@ must not be initialized with %@ when working with %@."
             @" This is because we cannot extract the system item type from the item.",
             NSStringFromClass([buttonItem class]),
             NSStringFromSelector(@selector(initWithBarButtonSystemItem:target:action:)),
             NSStringFromClass([GTUIButtonBar class]));
#endif

    GTUIButtonBarButton *button = [[GTUIButtonBarButton alloc] init];
    [button setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    button.disabledAlpha = kDisabledButtonAlpha;
    if (buttonBar.inkColor) {
        button.inkColor = buttonBar.inkColor;
    }

    button.exclusiveTouch = YES;

    [GTUINavigationBarButtonBarBuilder configureButton:button fromButtonItem:buttonItem];

    button.uppercaseTitle = buttonBar.uppercasesButtonTitles;
    [button setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
    [button setUnderlyingColorHint:self.buttonUnderlyingColor];
    for (NSNumber *state in _fonts) {
        UIFont *font = _fonts[state];
        [button setTitleFont:font forState:(UIControlState)state.intValue];
    }
    for (NSNumber *state in _titleColors) {
        UIColor *color = _titleColors[state];
        [button setTitleColor:color forState:(UIControlState)state.intValue];
    }

    [self updateButton:button withItem:buttonItem barMetrics:UIBarMetricsDefault];

    // Contrary to intuition, UIKit provides the UIBarButtonItem as the action's first argument when
    // bar buttons are tapped, NOT the button itself. Simply adding the item's target/action to the
    // button does not allow us to pass the expected argument to the target.
    //
    // GTUIButtonBar provides didTapButton:event: to which we can pass button events
    // so that the correct argument is ultimately passed along.
    [button addTarget:buttonBar
               action:@selector(didTapButton:event:)
     forControlEvents:UIControlEventTouchUpInside];

    UIEdgeInsets contentInsets = [GTUINavigationBarButtonBarBuilder
                                  contentInsetsForButton:button
                                  layoutPosition:buttonBar.layoutPosition
                                  layoutHints:layoutHints
                                  layoutDirection:[buttonBar gtf_effectiveUserInterfaceLayoutDirection]
                                  userInterfaceIdiom:[self usePadInsetsForButtonBar:buttonBar] ?
                                  UIUserInterfaceIdiomPad : UIUserInterfaceIdiomPhone];

    button.contentEdgeInsets = contentInsets;
    button.enabled = buttonItem.enabled;
    button.accessibilityLabel = buttonItem.accessibilityLabel;
    button.accessibilityHint = buttonItem.accessibilityHint;
    button.accessibilityValue = buttonItem.accessibilityValue;
    button.accessibilityIdentifier = buttonItem.accessibilityIdentifier;

    return button;
}

#pragma mark - Private

// Used to determine whether or not to apply insets relevant for iPad or use smaller iPhone size
// Because only widths are affected, we use horizontal size class
- (BOOL)usePadInsetsForButtonBar:(GTUIButtonBar *)buttonBar {
    const BOOL isPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    if (isPad && buttonBar.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        return YES;
    }
    return NO;
}

+ (UIEdgeInsets)contentInsetsForButton:(GTUIButton *)button
                        layoutPosition:(GTUIButtonBarLayoutPosition)layoutPosition
                           layoutHints:(GTUIBarButtonItemLayoutHints)layoutHints
                       layoutDirection:(UIUserInterfaceLayoutDirection)layoutDirection
                    userInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom {
    UIEdgeInsets contentInsets = kButtonInset;
    if ([button currentImage] || [button currentTitle].length) {
        BOOL isPad = userInterfaceIdiom == UIUserInterfaceIdiomPad;
        CGFloat additionalInset =
        (isPad ? kEdgeButtonAdditionalMarginPad : kEdgeButtonAdditionalMarginPhone);
        BOOL isFirstButton = (layoutHints & GTUIBarButtonItemLayoutHintsIsFirstButton) ==
        GTUIBarButtonItemLayoutHintsIsFirstButton;
        BOOL isLastButton = (layoutHints & GTUIBarButtonItemLayoutHintsIsLastButton) ==
        GTUIBarButtonItemLayoutHintsIsLastButton;
        if (isFirstButton && layoutPosition == GTUIButtonBarLayoutPositionLeading) {
            // Left-most button in LTR, and right-most button in RTL.
            if (layoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) {
                contentInsets.left += additionalInset;
            } else {
                contentInsets.right += additionalInset;
            }
        } else if (isFirstButton && layoutPosition == GTUIButtonBarLayoutPositionTrailing) {
            // Right-most button in LTR, and left-most button in RTL.
            if (layoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) {
                contentInsets.right += additionalInset;
            } else {
                contentInsets.left += additionalInset;
            }
        }
        if (isLastButton && layoutPosition == GTUIButtonBarLayoutPositionTrailing) {
            // Left-most button in LTR, and right-most button in RTL.
            if (layoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) {
                contentInsets.left += additionalInset;
            } else {
                contentInsets.right += additionalInset;
            }
        } else if (isLastButton && layoutPosition == GTUIButtonBarLayoutPositionLeading) {
            // Right-most button in LTR, and left-most button in RTL.
            if (layoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) {
                contentInsets.right += additionalInset;
            } else {
                contentInsets.left += additionalInset;
            }
        }
    } else {
        NSAssert(0, @"No button title or image");
    }

    return contentInsets;
}

+ (void)configureButton:(GTUIButton *)destinationButton
         fromButtonItem:(UIBarButtonItem *)sourceButtonItem {
    if (sourceButtonItem == nil || destinationButton == nil) {
        return;
    }

    if (sourceButtonItem.title != nil) {
        [destinationButton setTitle:sourceButtonItem.title forState:UIControlStateNormal];
    }
    if (sourceButtonItem.image != nil) {
        [destinationButton setImage:sourceButtonItem.image forState:UIControlStateNormal];
    }
    if (sourceButtonItem.tintColor != nil) {
        destinationButton.tintColor = sourceButtonItem.tintColor;
    }

    if (sourceButtonItem.title) {
        destinationButton.inkStyle = GTUIInkStyleBounded;
    } else {
        destinationButton.inkStyle = GTUIInkStyleUnbounded;
    }

    destinationButton.tag = sourceButtonItem.tag;
}

- (void)updateButton:(UIButton *)button
            withItem:(UIBarButtonItem *)item
          barMetrics:(UIBarMetrics)barMetrics {
    [self updateButton:button withItem:item forState:UIControlStateNormal barMetrics:barMetrics];
    [self updateButton:button withItem:item forState:UIControlStateHighlighted barMetrics:barMetrics];
    [self updateButton:button withItem:item forState:UIControlStateDisabled barMetrics:barMetrics];
}

- (void)updateButton:(UIButton *)button
            withItem:(UIBarButtonItem *)item
            forState:(UIControlState)state
          barMetrics:(UIBarMetrics)barMetrics {
    NSString *title = item.title ? item.title : @"";
    if ([UIButton instancesRespondToSelector:@selector(setAttributedTitle:forState:)]) {
        NSMutableDictionary<NSString *, id> *attributes = [NSMutableDictionary dictionary];

        // UIBarButtonItem's appearance proxy values don't appear to come "for free" like they do with
        // typical UIView instances, so we're attempting to recreate the behavior here.
        NSArray *appearanceProxies = @[ [item.class appearance] ];
        for (UIBarButtonItem *appearance in appearanceProxies) {
            [attributes addEntriesFromDictionary:[appearance titleTextAttributesForState:state]];
        }
        [attributes addEntriesFromDictionary:[item titleTextAttributesForState:state]];
        if ([attributes count] > 0) {
            [button
             setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:attributes]
             forState:state];
        }
    } else {
        [button setTitle:title forState:state];
    }

    UIImage *backgroundImage = [item backgroundImageForState:state barMetrics:barMetrics];
    if (backgroundImage) {
        [button setBackgroundImage:backgroundImage forState:state];
    }
}

- (void)transferCustomViewOwnershipForBarButtonItem:(UIBarButtonItem *)barButtonItem {
    UIView *customView = barButtonItem.customView;
    if (customView && ![customView isKindOfClass:[GTUIButtonBarSandbagView class]]) {
        // Transfer ownership of any UIBarButtonItem.customView to the internal property
        // so that UINavigationController won't steal the view from us.
        barButtonItem.gtui_customView = customView;
        barButtonItem.customView = [[GTUIButtonBarSandbagView alloc] init];
    }
}

@end

@implementation GTUIButtonBarSandbagView
@end

@implementation UIBarButtonItem (GTUIHeaderInternal)

@dynamic gtui_customView;

- (UIView *)gtui_customView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)gtui_setCustomView:(UIView *)customView {
    objc_setAssociatedObject(self, @selector(gtui_customView), customView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
