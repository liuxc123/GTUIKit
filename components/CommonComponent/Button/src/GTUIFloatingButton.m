//
//  GTUIFloatingButton.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUIFloatingButton.h"

#import "GTUIShadowElevations.h"
#import "private/GTUIButton+Subclassing.h"

#import <GTFInternationalization/GTFInternationalization.h>

static const CGFloat GTUIFloatingButtonDefaultDimension = 56;
static const CGFloat GTUIFloatingButtonMiniDimension = 40;
static const UIEdgeInsets internalLayoutInsets = (UIEdgeInsets){0, 16, 0, 24};

static NSString *const GTUIFloatingButtonShapeKey = @"GTUIFloatingButtonShapeKey";
static NSString *const GTUIFloatingButtonModeKey = @"GTUIFloatingButtonModeKey";
static NSString *const GTUIFloatingButtonMinimumSizeDictionaryKey =
@"GTUIFloatingButtonMinimumSizeDictionaryKey";
static NSString *const GTUIFloatingButtonMaximumSizeDictionaryKey =
@"GTUIFloatingButtonMaximumSizeDictionaryKey";
static NSString *const GTUIFloatingButtonContentEdgeInsetsDictionaryKey =
@"GTUIFloatingButtonContentEdgeInsetsDictionaryKey";
static NSString *const GTUIFloatingButtonHitAreaInsetsDictionaryKey =
@"GTUIFloatingButtonHitAreaInsetsDictionaryKey";

@interface GTUIFloatingButton ()

@property(nonatomic, readonly) NSMutableDictionary<NSNumber *,
NSMutableDictionary<NSNumber *, NSValue *> *> *shapeToModeToMinimumSize;

@property(nonatomic, readonly) NSMutableDictionary<NSNumber *,
NSMutableDictionary<NSNumber *, NSValue *> *> *shapeToModeToMaximumSize;

@property(nonatomic, readonly) NSMutableDictionary<NSNumber *,
NSMutableDictionary<NSNumber *, NSValue *> *> *shapeToModeToContentEdgeInsets;

@property(nonatomic, readonly) NSMutableDictionary<NSNumber *,
NSMutableDictionary<NSNumber *, NSValue *> *> *shapeToModeToHitAreaInsets;

@end

@implementation GTUIFloatingButton {
    GTUIFloatingButtonShape _shape;
}

+ (void)initialize {
    [[GTUIFloatingButton appearance] setElevation:GTUIShadowElevationFABResting
                                        forState:UIControlStateNormal];
    [[GTUIFloatingButton appearance] setElevation:GTUIShadowElevationFABPressed
                                        forState:UIControlStateHighlighted];
}

+ (CGFloat)defaultDimension {
    return GTUIFloatingButtonDefaultDimension;
}

+ (CGFloat)miniDimension {
    return GTUIFloatingButtonMiniDimension;
}

+ (instancetype)floatingButtonWithShape:(GTUIFloatingButtonShape)shape {
    return [[[self class] alloc] initWithFrame:CGRectZero shape:shape];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero shape:GTUIFloatingButtonShapeDefault];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame shape:GTUIFloatingButtonShapeDefault];
}

- (instancetype)initWithFrame:(CGRect)frame shape:(GTUIFloatingButtonShape)shape {
    self = [super initWithFrame:frame];
    if (self) {
        _shape = shape;
        [self commonGTUIFloatingButtonInit];
        // The superclass sets contentEdgeInsets from defaultContentEdgeInsets before the _shape is set.
        // Set contentEdgeInsets again to ensure the defaults are for the correct shape.
        [self updateShapeAndAllowResize:NO];
    }
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _shape = [aDecoder decodeIntegerForKey:GTUIFloatingButtonShapeKey];
        // Required to migrate any previously-archived FloatingButtons from .largeIcon shape value
        if (@(_shape).integerValue >= 2) {
            _shape = GTUIFloatingButtonShapeDefault;
        }
        // Shape must be set first before the common initialization
        [self commonGTUIFloatingButtonInit];

        if ([aDecoder containsValueForKey:GTUIFloatingButtonModeKey]) {
            _mode = [aDecoder decodeIntegerForKey:GTUIFloatingButtonModeKey];
        }
        if ([aDecoder containsValueForKey:GTUIFloatingButtonMinimumSizeDictionaryKey]) {
            _shapeToModeToMinimumSize =
            [aDecoder decodeObjectOfClass:[NSMutableDictionary class]
                                   forKey:GTUIFloatingButtonMinimumSizeDictionaryKey];
        }
        if ([aDecoder containsValueForKey:GTUIFloatingButtonMaximumSizeDictionaryKey]) {
            _shapeToModeToMaximumSize =
            [aDecoder decodeObjectOfClass:[NSMutableDictionary class]
                                   forKey:GTUIFloatingButtonMaximumSizeDictionaryKey];
        }
        if ([aDecoder containsValueForKey:GTUIFloatingButtonContentEdgeInsetsDictionaryKey]) {
            _shapeToModeToContentEdgeInsets =
            [aDecoder decodeObjectOfClass:[NSMutableDictionary class]
                                   forKey:GTUIFloatingButtonContentEdgeInsetsDictionaryKey];
        }
        if ([aDecoder containsValueForKey:GTUIFloatingButtonHitAreaInsetsDictionaryKey]) {
            _shapeToModeToHitAreaInsets =
            [aDecoder decodeObjectOfClass:[NSMutableDictionary class]
                                   forKey:GTUIFloatingButtonHitAreaInsetsDictionaryKey];
        }

        [self updateShapeAndAllowResize:NO];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:_shape forKey:GTUIFloatingButtonShapeKey];
    [aCoder encodeInteger:self.mode forKey:GTUIFloatingButtonModeKey];
    [aCoder encodeObject:self.shapeToModeToMinimumSize
                  forKey:GTUIFloatingButtonMinimumSizeDictionaryKey];
    [aCoder encodeObject:self.shapeToModeToMaximumSize
                  forKey:GTUIFloatingButtonMaximumSizeDictionaryKey];
    [aCoder encodeObject:self.shapeToModeToContentEdgeInsets
                  forKey:GTUIFloatingButtonContentEdgeInsetsDictionaryKey];
    [aCoder encodeObject:self.shapeToModeToHitAreaInsets
                  forKey:GTUIFloatingButtonHitAreaInsetsDictionaryKey];
}

- (void)commonGTUIFloatingButtonInit {
    const CGSize miniNormalSize = CGSizeMake(GTUIFloatingButtonMiniDimension,
                                             GTUIFloatingButtonMiniDimension);
    const CGSize defaultNormalSize = CGSizeMake(GTUIFloatingButtonDefaultDimension,
                                                GTUIFloatingButtonDefaultDimension);
    const CGSize defaultExpandedMinimumSize = CGSizeMake(0, 48);
    const CGSize defaultExpandedMaximumSize = CGSizeMake(328, 0);

    // Minimum size values for different shape + mode combinations
    NSMutableDictionary *miniShapeMinimumSizeDictionary =
    [@{ @(GTUIFloatingButtonModeNormal) : [NSValue valueWithCGSize:miniNormalSize]
        } mutableCopy];
    NSMutableDictionary *defaultShapeMinimumSizeDictionary =
    [@{ @(GTUIFloatingButtonModeNormal) : [NSValue valueWithCGSize:defaultNormalSize],
        @(GTUIFloatingButtonModeExpanded) : [NSValue valueWithCGSize:defaultExpandedMinimumSize],
        } mutableCopy];
    _shapeToModeToMinimumSize =
    [@{ @(GTUIFloatingButtonShapeMini) : miniShapeMinimumSizeDictionary,
        @(GTUIFloatingButtonShapeDefault) : defaultShapeMinimumSizeDictionary,
        } mutableCopy];

    // Maximum size values for different shape + mode combinations
    NSMutableDictionary *miniShapeMaximumSizeDictionary =
    [@{ @(GTUIFloatingButtonModeNormal) : [NSValue valueWithCGSize:miniNormalSize]
        } mutableCopy];
    NSMutableDictionary *defaultShapeMaximumSizeDictionary =
    [@{ @(GTUIFloatingButtonModeNormal) : [NSValue valueWithCGSize:defaultNormalSize],
        @(GTUIFloatingButtonModeExpanded) : [NSValue valueWithCGSize:defaultExpandedMaximumSize],
        } mutableCopy];
    _shapeToModeToMaximumSize =
    [@{ @(GTUIFloatingButtonShapeMini) : miniShapeMaximumSizeDictionary,
        @(GTUIFloatingButtonShapeDefault) : defaultShapeMaximumSizeDictionary,
        } mutableCopy];

    // Content edge insets values for different shape + mode combinations
    // .mini shape, .normal mode
    const UIEdgeInsets miniNormalContentInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    NSMutableDictionary *miniShapeContentEdgeInsetsDictionary =
    [@{ @(GTUIFloatingButtonModeNormal) : [NSValue valueWithUIEdgeInsets:miniNormalContentInsets]
        } mutableCopy];
    _shapeToModeToContentEdgeInsets =
    [@{ @(GTUIFloatingButtonShapeMini) : miniShapeContentEdgeInsetsDictionary
        } mutableCopy];

    // Hit area insets values for different shape + mode combinations
    // .mini shape, .normal mode
    const UIEdgeInsets miniNormalHitAreaInset = UIEdgeInsetsMake(-4, -4, -4, -4);
    NSMutableDictionary *miniShapeHitAreaInsetsDictionary =
    [@{ @(GTUIFloatingButtonModeNormal) : [NSValue valueWithUIEdgeInsets:miniNormalHitAreaInset],
        } mutableCopy];
    _shapeToModeToHitAreaInsets =
    [@{ @(GTUIFloatingButtonShapeMini) : miniShapeHitAreaInsetsDictionary,
        } mutableCopy];
}

#pragma mark - UIView

- (CGSize)sizeThatFits:(__unused CGSize)size {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSizeForModeNormal {
    switch (_shape) {
        case GTUIFloatingButtonShapeDefault:
            return CGSizeMake(GTUIFloatingButtonDefaultDimension, GTUIFloatingButtonDefaultDimension);
        case GTUIFloatingButtonShapeMini:
            return CGSizeMake(GTUIFloatingButtonMiniDimension, GTUIFloatingButtonMiniDimension);
    }
}

- (CGSize)intrinsicContentSizeForModeExpanded {
    const CGSize intrinsicTitleSize =
    [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    const CGSize intrinsicImageSize =
    [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat intrinsicWidth = intrinsicTitleSize.width + intrinsicImageSize.width +
    self.imageTitleSpace + internalLayoutInsets.left + internalLayoutInsets.right +
    self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    CGFloat intrinsicHeight = MAX(intrinsicTitleSize.height, intrinsicImageSize.height) +
    self.contentEdgeInsets.top + self.contentEdgeInsets.bottom + internalLayoutInsets.top +
    internalLayoutInsets.bottom;
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

- (CGSize)intrinsicContentSize {
    CGSize contentSize = CGSizeZero;
    if (self.mode == GTUIFloatingButtonModeNormal) {
        contentSize = [self intrinsicContentSizeForModeNormal];
    } else if (self.mode == GTUIFloatingButtonModeExpanded) {
        contentSize = [self intrinsicContentSizeForModeExpanded];
    }

    if (self.minimumSize.height > 0) {
        contentSize.height = MAX(self.minimumSize.height, contentSize.height);
    }
    if (self.maximumSize.height > 0) {
        contentSize.height = MIN(self.maximumSize.height, contentSize.height);
    }
    if (self.minimumSize.width > 0) {
        contentSize.width = MAX(self.minimumSize.width, contentSize.width);
    }
    if (self.maximumSize.width > 0) {
        contentSize.width = MIN(self.maximumSize.width, contentSize.width);
    }
    return contentSize;
}

/*
 Performs custom layout when the FAB is in .expanded mode. Specifically, the layout algorithm is
 as follows:

 1. Inset the bounds by the value of `contentEdgeInsets` and use this as the layout bounds.
 2. Determine the intrinsic sizes of the imageView and titleLabel.
 3. Compute the space remaining for the titleLabel after accounting for the imageView and built-in
 alignment guidelines (internalLayoutInsets).
 4. Position the imageView along the leading (or trailing) edge of the button, inset by
 internalLayoutInsets.left (flipped for RTL).
 5. Position the titleLabel along the leading edge of its available space.
 6. Apply the imageEdgeInsets and titleEdgeInsets to their respective views.
 */
- (void)layoutSubviews {
    // We have to set cornerRadius before laying out subviews so that the boundingPath is correct.
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    [super layoutSubviews];

    if (self.mode == GTUIFloatingButtonModeNormal) {
        return;
    }

    // Position the imageView and titleView
    //
    // +------------------------------------+
    // |    |  |  |  CEI TOP            |   |
    // |CEI +--+  |+-----+              |CEI|
    // | LT ||SP||Title|              |RGT|
    // |    +--+  |+-----+              |   |
    // |    |  |  |  CEI BOT            |   |
    // +------------------------------------+
    //
    // (A) The same spacing on either side of the label.
    // (SP) The spacing between the image and title
    // (CEI) Content Edge Insets
    //
    // The diagram above assumes an LTR user interface orientation
    // and a .leadingIcon imageLocation for this button.

    BOOL isLeadingIcon = self.imageLocation == GTUIFloatingButtonImageLocationLeading;
    UIEdgeInsets adjustedLayoutInsets =
    isLeadingIcon ? internalLayoutInsets
    : GTFInsetsFlippedHorizontally(internalLayoutInsets);

    const CGRect insetBounds = UIEdgeInsetsInsetRect(UIEdgeInsetsInsetRect(self.bounds,
                                                                           adjustedLayoutInsets),
                                                     self.contentEdgeInsets);

    const CGFloat imageViewWidth = CGRectGetWidth(self.imageView.bounds);
    const CGFloat boundsCenterY = CGRectGetMidY(insetBounds);
    CGFloat titleWidthAvailable = CGRectGetWidth(insetBounds);
    titleWidthAvailable -= imageViewWidth;
    titleWidthAvailable -= self.imageTitleSpace;

    const CGFloat availableHeight = CGRectGetHeight(insetBounds);
    CGSize titleIntrinsicSize =
    [self.titleLabel sizeThatFits:CGSizeMake(titleWidthAvailable, availableHeight)];

    const CGSize titleSize = CGSizeMake(MAX(0, MIN(titleIntrinsicSize.width, titleWidthAvailable)),
                                        MAX(0, MIN(titleIntrinsicSize.height, availableHeight)));

    CGPoint titleCenter;
    CGPoint imageCenter;
    BOOL isLTR =
    self.gtf_effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;

    // If we are LTR with a leading image, the image goes on the left.
    // If we are RTL with a trailing image, the image goes on the left.
    if ((isLTR && isLeadingIcon) || (!isLTR && !isLeadingIcon)) {
        const CGFloat imageCenterX = CGRectGetMinX(insetBounds) + (imageViewWidth / 2);
        const CGFloat titleCenterX = CGRectGetMaxX(insetBounds) - titleWidthAvailable +
        (titleSize.width / 2);
        titleCenter = CGPointMake(titleCenterX, boundsCenterY);
        imageCenter = CGPointMake(imageCenterX, boundsCenterY);
    }
    // If we are LTR with a trailing image, the image goes on the right.
    // If we are RTL with a leading image, the image goes on the right.
    else {
        const CGFloat imageCenterX = CGRectGetMaxX(insetBounds) - (imageViewWidth / 2);
        const CGFloat titleCenterX = CGRectGetMinX(insetBounds) + titleWidthAvailable -
        (titleSize.width / 2);
        imageCenter = CGPointMake(imageCenterX, boundsCenterY);
        titleCenter = CGPointMake(titleCenterX, boundsCenterY);
    }

    self.imageView.center = imageCenter;
    self.imageView.frame = UIEdgeInsetsInsetRect(self.imageView.frame, self.imageEdgeInsets);
    self.titleLabel.center = titleCenter;
    CGRect newBounds = CGRectStandardize(self.titleLabel.bounds);
    self.titleLabel.bounds = (CGRect){newBounds.origin, titleSize};
    self.titleLabel.frame = UIEdgeInsetsInsetRect(self.titleLabel.frame, self.titleEdgeInsets);
}

#pragma mark - Property Setters/Getters

- (void)setMode:(GTUIFloatingButtonMode)mode {
    BOOL needsShapeUpdate = self.mode != mode;
    _mode = mode;
    if (needsShapeUpdate) {
        [self updateShapeAndAllowResize:YES];
    }
}

- (void)setMinimumSize:(CGSize)size
              forShape:(GTUIFloatingButtonShape)shape
                inMode:(GTUIFloatingButtonMode)mode {
    NSMutableDictionary *modeToMinimumSize = self.shapeToModeToMinimumSize[@(shape)];
    if (!modeToMinimumSize) {
        modeToMinimumSize = [@{} mutableCopy];
        self.shapeToModeToMinimumSize[@(shape)] = modeToMinimumSize;
    }
    modeToMinimumSize[@(mode)] = [NSValue valueWithCGSize:size];
    if (shape == _shape && mode == self.mode) {
        [self updateShapeAndAllowResize:YES];
    }
}

- (CGSize)minimumSizeForMode:(GTUIFloatingButtonMode)mode {
    NSMutableDictionary *modeToMinimumSize = self.shapeToModeToMinimumSize[@(_shape)];
    if(!modeToMinimumSize) {
        return CGSizeZero;
    }

    NSValue *sizeValue = modeToMinimumSize[@(mode)];
    if (sizeValue) {
        return [sizeValue CGSizeValue];
    } else {
        return CGSizeZero;
    }
}

- (BOOL)updateMinimumSize {
    CGSize newSize = [self minimumSizeForMode:self.mode];
    if (CGSizeEqualToSize(newSize, self.minimumSize)) {
        return NO;
    }
    super.minimumSize = newSize;
    return YES;
}

- (void)setMaximumSize:(CGSize)size
              forShape:(GTUIFloatingButtonShape)shape
                inMode:(GTUIFloatingButtonMode)mode {
    NSMutableDictionary *modeToMaximumSize = self.shapeToModeToMaximumSize[@(shape)];
    if (!modeToMaximumSize) {
        modeToMaximumSize = [@{} mutableCopy];
        self.shapeToModeToMaximumSize[@(shape)] = modeToMaximumSize;
    }
    modeToMaximumSize[@(mode)] = [NSValue valueWithCGSize:size];
    if (shape == _shape && mode == self.mode) {
        [self updateShapeAndAllowResize:YES];
    }
}

- (CGSize)maximumSizeForMode:(GTUIFloatingButtonMode)mode {
    NSMutableDictionary *modeToMaximumSize = self.shapeToModeToMaximumSize[@(_shape)];
    if (!modeToMaximumSize) {
        return CGSizeZero;
    }

    NSValue *sizeValue = modeToMaximumSize[@(mode)];
    if (sizeValue) {
        return [sizeValue CGSizeValue];
    } else {
        return CGSizeZero;
    }
}

- (BOOL)updateMaximumSize {
    CGSize newSize = [self maximumSizeForMode:self.mode];
    if (CGSizeEqualToSize(newSize, self.maximumSize)) {
        return NO;
    }
    super.maximumSize = newSize;
    return YES;
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                    forShape:(GTUIFloatingButtonShape)shape
                      inMode:(GTUIFloatingButtonMode)mode {
    NSMutableDictionary *modeToContentEdgeInsets = self.shapeToModeToContentEdgeInsets[@(shape)];
    if (!modeToContentEdgeInsets) {
        modeToContentEdgeInsets = [@{} mutableCopy];
        self.shapeToModeToContentEdgeInsets[@(shape)] = modeToContentEdgeInsets;
    }
    modeToContentEdgeInsets[@(mode)] = [NSValue valueWithUIEdgeInsets:contentEdgeInsets];
    if (shape == _shape && mode == self.mode) {
        [self updateShapeAndAllowResize:YES];
    }
}

- (UIEdgeInsets)contentEdgeInsetsForMode:(GTUIFloatingButtonMode)mode {
    NSMutableDictionary *modeToContentEdgeInsets = self.shapeToModeToContentEdgeInsets[@(_shape)];
    if (!modeToContentEdgeInsets) {
        return UIEdgeInsetsZero;
    }

    NSValue *insetsValue = modeToContentEdgeInsets[@(mode)];
    if (insetsValue) {
        return [insetsValue UIEdgeInsetsValue];
    } else {
        return UIEdgeInsetsZero;
    }
}

- (void)updateContentEdgeInsets {
    super.contentEdgeInsets = [self contentEdgeInsetsForMode:self.mode];
}

- (void)setHitAreaInsets:(UIEdgeInsets)insets
                forShape:(GTUIFloatingButtonShape)shape
                  inMode:(GTUIFloatingButtonMode)mode {
    NSMutableDictionary *modeToHitAreaInsets = self.shapeToModeToHitAreaInsets[@(shape)];
    if (!modeToHitAreaInsets) {
        modeToHitAreaInsets = [@{} mutableCopy];
        self.shapeToModeToHitAreaInsets[@(shape)] = modeToHitAreaInsets;
    }
    modeToHitAreaInsets[@(mode)] = [NSValue valueWithUIEdgeInsets:insets];
    if (shape == _shape && mode == self.mode) {
        [self updateShapeAndAllowResize:NO];
    }
}

- (UIEdgeInsets)hitAreaInsetsForMode:(GTUIFloatingButtonMode)mode {
    NSMutableDictionary *modeToHitAreaInsets = self.shapeToModeToHitAreaInsets[@(_shape)];
    if (!modeToHitAreaInsets) {
        return UIEdgeInsetsZero;
    }

    NSValue *insetsValue = modeToHitAreaInsets[@(mode)];
    if (insetsValue) {
        return [insetsValue UIEdgeInsetsValue];
    } else {
        return UIEdgeInsetsZero;
    }
}

- (void)updateHitAreaInsets {
    super.hitAreaInsets = [self hitAreaInsetsForMode:self.mode];
}

- (void)updateShapeAndAllowResize:(BOOL)allowsResize {
    BOOL minimumSizeChanged = [self updateMinimumSize];
    BOOL maximumSizeChanged = [self updateMaximumSize];
    [self updateContentEdgeInsets];
    [self updateHitAreaInsets];

    if (allowsResize && (minimumSizeChanged || maximumSizeChanged)) {
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
}

#pragma mark - Deprecations

+ (instancetype)buttonWithShape:(GTUIFloatingButtonShape)shape {
    return [[self class] floatingButtonWithShape:shape];
}

@end
