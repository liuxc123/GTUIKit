//
//  GTUIFlexibleHeaderMinMaxHeight.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import "GTUIFlexibleHeaderMinMaxHeight.h"

#import "GTUIFlexibleHeaderTopSafeArea.h"

// The default maximum height for the header. Does not include the status bar height.
static const CGFloat kFlexibleHeaderDefaultHeight = 44;

@interface GTUIFlexibleHeaderMinMaxHeight ()

@property(nonatomic, strong) GTUIFlexibleHeaderTopSafeArea *topSafeArea;

@property(nonatomic) BOOL hasExplicitlySetMinHeight;
@property(nonatomic) BOOL hasExplicitlySetMaxHeight;

@end

@implementation GTUIFlexibleHeaderMinMaxHeight

- (instancetype)initWithTopSafeArea:(GTUIFlexibleHeaderTopSafeArea *)topSafeArea {
    self = [super init];
    if (self) {
        self.topSafeArea = topSafeArea;

        const CGFloat topSafeAreaInset = [self.topSafeArea topSafeAreaInset];

        _minMaxHeightIncludesSafeArea = YES;
        _minimumHeight = kFlexibleHeaderDefaultHeight + topSafeAreaInset;
        _maximumHeight = _minimumHeight;
    }
    return self;
}

#pragma mark - Public

- (void)setMinimumHeight:(CGFloat)minimumHeight {
    _hasExplicitlySetMinHeight = YES;
    if (_minimumHeight == minimumHeight) {
        return;
    }

    _minimumHeight = minimumHeight;

    if (_minimumHeight > self.maximumHeight) {
        [self setMaximumHeight:_minimumHeight];
    } else {
        [self.delegate flexibleHeaderMinMaxHeightDidChange:self];
    }
}

- (void)setMaximumHeight:(CGFloat)maximumHeight {
    _hasExplicitlySetMaxHeight = YES;
    if (_maximumHeight == maximumHeight) {
        return;
    }

    _maximumHeight = maximumHeight;

    [self.delegate flexibleHeaderMaximumHeightDidChange:self];

    if (self.maximumHeight < _minimumHeight) {
        [self setMinimumHeight:self.maximumHeight];
    } else {
        [self.delegate flexibleHeaderMinMaxHeightDidChange:self];
    }
}

- (void)setMinMaxHeightIncludesSafeArea:(BOOL)minMaxHeightIncludesSafeArea {
    if (_minMaxHeightIncludesSafeArea == minMaxHeightIncludesSafeArea) {
        return;
    }
    _minMaxHeightIncludesSafeArea = minMaxHeightIncludesSafeArea;

    // Update default values accordingly.
    if (!_hasExplicitlySetMinHeight) {
        if (_minMaxHeightIncludesSafeArea) {
            _minimumHeight = kFlexibleHeaderDefaultHeight + [self.topSafeArea topSafeAreaInset];
        } else {
            _minimumHeight = kFlexibleHeaderDefaultHeight;
        }
    }
    if (!_hasExplicitlySetMaxHeight) {
        if (_minMaxHeightIncludesSafeArea) {
            self.maximumHeight = kFlexibleHeaderDefaultHeight + [self.topSafeArea topSafeAreaInset];
        } else {
            self.maximumHeight = kFlexibleHeaderDefaultHeight;
        }
    }
}

- (void)recalculateMinMaxHeight {
    // If the min or max height have been explicitly set, don't adjust anything if the values
    // already include a Safe Area inset.
    BOOL hasSetMinOrMaxHeight = self.hasExplicitlySetMinHeight || self.hasExplicitlySetMaxHeight;
    if (!hasSetMinOrMaxHeight && self.minMaxHeightIncludesSafeArea) {
        // If we're using the defaults we need to update them to account for the new Safe Area inset.
        self.minimumHeight = kFlexibleHeaderDefaultHeight + self.topSafeArea.topSafeAreaInset;
        self.maximumHeight = self.minimumHeight;
    }
}

- (CGFloat)minimumHeightWithTopSafeArea {
    if (self.minMaxHeightIncludesSafeArea) {
        return self.minimumHeight;
    } else {
        return self.minimumHeight + [self.topSafeArea topSafeAreaInset];
    }
}

- (CGFloat)maximumHeightWithTopSafeArea {
    if (_minMaxHeightIncludesSafeArea) {
        return self.maximumHeight;
    } else {
        return self.maximumHeight + [self.topSafeArea topSafeAreaInset];
    }
}

- (CGFloat)maximumHeightWithoutTopSafeArea {
    if (_minMaxHeightIncludesSafeArea) {
        return self.maximumHeight - [self.topSafeArea topSafeAreaInset];
    } else {
        return self.maximumHeight;
    };
}


@end
