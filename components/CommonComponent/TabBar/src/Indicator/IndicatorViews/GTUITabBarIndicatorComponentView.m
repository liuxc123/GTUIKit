//
//  GTUITabBarIndicatorComponentView.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorComponentView.h"

@implementation GTUITabBarIndicatorComponentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _componentPosition = GTUITabBarComponentPositionBottom;
        _scrollEnabled = YES;
        _verticalMargin = 0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSAssert(NO, @"Use initWithFrame");
    }
    return self;
}

#pragma mark - GTUITabBarComponentProtocol

- (void)refreshState:(CGRect)selectedCellFrame {
    
}

- (void)contentScrollViewDidScrollWithLeftCellFrame:(CGRect)leftCellFrame rightCellFrame:(CGRect)rightCellFrame selectedPosition:(GTUITabBarCellClickedPosition)selectedPosition percent:(CGFloat)percent {
    
}

- (void)selectedCell:(CGRect)cellFrame clickedRelativePosition:(GTUITabBarCellClickedPosition)clickedRelativePosition isClicked:(BOOL)isClicked {
    
}

@end
