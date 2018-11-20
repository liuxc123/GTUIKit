//
//  GTUIItemBarStyle.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUIItemBarStyle.h"

@implementation GTUIItemBarStyle


- (instancetype)init {
    self = [super init];
    if (self) {
        _titleColor = [UIColor whiteColor];
        _imageTintColor = [UIColor whiteColor];
        _displaysUppercaseTitles = YES;
        _shouldDisplayTitle = YES;
        _shouldDisplaySelectionIndicator = YES;
        _textOnlyNumberOfLines = 1;
    }
    return self;
}

- (instancetype)copyWithZone:(__unused NSZone *)zone {
    GTUIItemBarStyle *newStyle = [[[self class] alloc] init];

    newStyle.defaultHeight = _defaultHeight;
    newStyle.shouldDisplaySelectionIndicator = _shouldDisplaySelectionIndicator;
    newStyle.selectionIndicatorColor = _selectionIndicatorColor;
    newStyle.selectionIndicatorTemplate = _selectionIndicatorTemplate;
    newStyle.maximumItemWidth = _maximumItemWidth;
    newStyle.shouldDisplayTitle = _shouldDisplayTitle;
    newStyle.shouldDisplayImage = _shouldDisplayImage;
    newStyle.shouldDisplayBadge = _shouldDisplayBadge;
    newStyle.shouldGrowOnSelection = _shouldGrowOnSelection;
    newStyle.titleColor = _titleColor;
    newStyle.selectedTitleColor = _selectedTitleColor;
    newStyle.imageTintColor = _imageTintColor;
    newStyle.selectedImageTintColor = _selectedImageTintColor;
    newStyle.selectedTitleFont = _selectedTitleFont;
    newStyle.unselectedTitleFont = _unselectedTitleFont;
    newStyle.inkStyle = _inkStyle;
    newStyle.inkColor = _inkColor;
    newStyle.titleImagePadding = _titleImagePadding;
    newStyle.displaysUppercaseTitles = _displaysUppercaseTitles;
    newStyle.textOnlyNumberOfLines = _textOnlyNumberOfLines;

    return newStyle;
}


@end
