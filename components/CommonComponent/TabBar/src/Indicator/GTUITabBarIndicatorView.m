//
//  GTUITabBarIndicatorView.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorView.h"
#import "GTUITabBarIndicatorBackgroundView.h"
#import "GTUITabBarFactory.h"

@interface GTUITabBarIndicatorView()

@property (nonatomic, strong) CALayer *backgroundEllipseLayer;

@end

@implementation GTUITabBarIndicatorView

- (void)initializeData {
    [super initializeData];
    
    _separatorLineShowEnabled = NO;
    _separatorLineColor = [UIColor lightGrayColor];
    _separatorLineSize = CGSizeMake(1/[UIScreen mainScreen].scale, 20);
    _cellBackgroundColorGradientEnabled = NO;
    _cellBackgroundUnselectedColor = [UIColor whiteColor];
    _cellBackgroundSelectedColor = [UIColor lightGrayColor];
}

- (void)initializeViews {
    [super initializeViews];
}

- (void)setIndicators:(NSArray<UIView<GTUITabBarIndicatorProtocol> *> *)indicators {
    for (UIView *component in self.indicators) {
        //先移除之前的component
        [component removeFromSuperview];
    }
    _indicators = indicators;
    
    for (UIView *component in self.indicators) {
        [self.collectionView addSubview:component];
    }
    
    self.collectionView.indicators = indicators;
}

- (void)refreshState {
    [super refreshState];
    
    CGRect selectedCellFrame = CGRectZero;
    GTUITabBarIndicatorCellModel *selectedCellModel = nil;
    for (int i = 0; i < self.dataSource.count; i++) {
        GTUITabBarIndicatorCellModel *cellModel = (GTUITabBarIndicatorCellModel *)self.dataSource[i];
        cellModel.sepratorLineShowEnabled = self.separatorLineShowEnabled;
        cellModel.separatorLineColor = self.separatorLineColor;
        cellModel.separatorLineSize = self.separatorLineSize;
        cellModel.backgroundViewMaskFrame = CGRectZero;
        cellModel.cellBackgroundColorGradientEnabled = self.cellBackgroundColorGradientEnabled;
        cellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        cellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        if (i == self.dataSource.count - 1) {
            cellModel.sepratorLineShowEnabled = NO;
        }
        if (i == self.selectedIndex) {
            selectedCellModel = cellModel;
            cellModel.selected = YES;
            selectedCellFrame = [self getTargetCellFrame:i];
        }
    }
    
    for (UIView<GTUITabBarIndicatorProtocol> *component in self.indicators) {
        if (self.dataSource.count <= 0) {
            component.hidden = YES;
        }else {
            component.hidden = NO;
            [component refreshState:selectedCellFrame];
            
            if ([component isKindOfClass:[GTUITabBarIndicatorBackgroundView class]]) {
                CGRect maskFrame = component.frame;
                maskFrame.origin.x = maskFrame.origin.x - selectedCellFrame.origin.x;
                selectedCellModel.backgroundViewMaskFrame = maskFrame;
            }
        }
    }
}

- (void)refreshSelectedCellModel:(GTUITabBarBaseCellModel *)selectedCellModel unselectedCellModel:(GTUITabBarBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];
    
    GTUITabBarIndicatorCellModel *myUnselectedCellModel = (GTUITabBarIndicatorCellModel *)unselectedCellModel;
    myUnselectedCellModel.backgroundViewMaskFrame = CGRectZero;
    myUnselectedCellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myUnselectedCellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
    
    GTUITabBarIndicatorCellModel *myselectedCellModel = (GTUITabBarIndicatorCellModel *)selectedCellModel;
    myselectedCellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myselectedCellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
}

- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset {
    [super contentOffsetOfContentScrollViewDidChanged:contentOffset];
    
    CGFloat ratio = contentOffset.x/self.contentScrollView.bounds.size.width;
    if (ratio > self.dataSource.count - 1 || ratio < 0) {
        //超过了边界，不需要处理
        return;
    }
    ratio = MAX(0, MIN(self.dataSource.count - 1, ratio));
    NSInteger baseIndex = floorf(ratio);
    CGFloat remainderRatio = ratio - baseIndex;
    
    CGRect leftCellFrame = [self getTargetCellFrame:baseIndex];
    CGRect rightCellFrame = CGRectZero;
    if (baseIndex + 1 < self.dataSource.count) {
        rightCellFrame = [self getTargetCellFrame:baseIndex+1];
    }
    
    GTUITabBarCellClickedPosition position = GTUITabBarCellClickedPositionLeft;
    if (self.selectedIndex == baseIndex + 1) {
        position = GTUITabBarCellClickedPositionRight;
    }
    
    if (remainderRatio == 0) {
        for (UIView<GTUITabBarIndicatorProtocol> *component in self.indicators) {
            [component contentScrollViewDidScrollWithLeftCellFrame:leftCellFrame rightCellFrame:rightCellFrame selectedPosition:position percent:remainderRatio];
        }
    }else {
        GTUITabBarIndicatorCellModel *leftCellModel = (GTUITabBarIndicatorCellModel *)self.dataSource[baseIndex];
        GTUITabBarIndicatorCellModel *rightCellModel = (GTUITabBarIndicatorCellModel *)self.dataSource[baseIndex + 1];
        [self refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:remainderRatio];
        
        for (UIView<GTUITabBarIndicatorProtocol> *component in self.indicators) {
            [component contentScrollViewDidScrollWithLeftCellFrame:leftCellFrame rightCellFrame:rightCellFrame selectedPosition:position percent:remainderRatio];
            if ([component isKindOfClass:[GTUITabBarIndicatorBackgroundView class]]) {
                CGRect leftMaskFrame = component.frame;
                leftMaskFrame.origin.x = leftMaskFrame.origin.x - leftCellFrame.origin.x;
                leftCellModel.backgroundViewMaskFrame = leftMaskFrame;
                
                CGRect rightMaskFrame = component.frame;
                rightMaskFrame.origin.x = rightMaskFrame.origin.x - rightCellFrame.origin.x;
                rightCellModel.backgroundViewMaskFrame = rightMaskFrame;
            }
        }
        
        GTUITabBarBaseCell *leftCell = (GTUITabBarBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex inSection:0]];
        [leftCell reloadData:leftCellModel];
        GTUITabBarBaseCell *rightCell = (GTUITabBarBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex + 1 inSection:0]];
        [rightCell reloadData:rightCellModel];
    }
}

- (BOOL)selectCellAtIndex:(NSInteger)index isClicked:(BOOL)isClicked {
    //是否点击了相对于选中cell左边的cell
    GTUITabBarCellClickedPosition clickedPosition = GTUITabBarCellClickedPositionLeft;
    if (index > self.selectedIndex) {
        clickedPosition = GTUITabBarCellClickedPositionRight;
    }
    BOOL result = [super selectCellAtIndex:index isClicked:isClicked];
    if (!result) {
        return NO;
    }
    
    CGRect clickedCellFrame = [self getTargetCellFrame:index];
    
    GTUITabBarIndicatorCellModel *selectedCellModel = (GTUITabBarIndicatorCellModel *)self.dataSource[index];
    for (UIView<GTUITabBarIndicatorProtocol> *component in self.indicators) {
        [component selectedCell:clickedCellFrame clickedRelativePosition:clickedPosition isClicked:isClicked];
        if ([component isKindOfClass:[GTUITabBarIndicatorBackgroundView class]]) {
            CGRect maskFrame = component.frame;
            maskFrame.origin.x = maskFrame.origin.x - clickedCellFrame.origin.x;
            selectedCellModel.backgroundViewMaskFrame = maskFrame;
        }
    }
    
    GTUITabBarIndicatorCell *selectedCell = (GTUITabBarIndicatorCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [selectedCell reloadData:selectedCellModel];
    
    return YES;
}


- (void)refreshLeftCellModel:(GTUITabBarBaseCellModel *)leftCellModel rightCellModel:(GTUITabBarBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    if (self.cellBackgroundColorGradientEnabled) {
        //处理cell背景色渐变
        GTUITabBarIndicatorCellModel *leftModel = (GTUITabBarIndicatorCellModel *)leftCellModel;
        GTUITabBarIndicatorCellModel *rightModel = (GTUITabBarIndicatorCellModel *)rightCellModel;
        if (leftModel.selected) {
            leftModel.cellBackgroundSelectedColor = [GTUITabBarFactory interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];
            leftModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        }else {
            leftModel.cellBackgroundUnselectedColor = [GTUITabBarFactory interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];
            leftModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
        if (rightModel.selected) {
            rightModel.cellBackgroundSelectedColor = [GTUITabBarFactory interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];
            rightModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        }else {
            rightModel.cellBackgroundUnselectedColor = [GTUITabBarFactory interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];
            rightModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
    }
    
}

@end
