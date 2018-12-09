//
//  GTUITabBarTitleView.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarTitleView.h"
#import "GTUITabBarFactory.h"

@implementation GTUITabBarTitleView

- (void)initializeData
{
    [super initializeData];
    
    _titleLabelZoomEnabled = NO;
    _titleLabelZoomScale = 1.2;
    _titleColor = [UIColor blackColor];
    _titleSelectedColor = [UIColor redColor];
    _titleFont = [UIFont systemFontOfSize:15];
    _titleColorGradientEnabled = NO;
    _titleLabelMaskEnabled = NO;
    _titleLabelZoomScrollGradientEnabled = YES;
    _titleLabelStrokeWidthEnabled = NO;
    _titleLabelSelectedStrokeWidth = -3;
}

- (UIFont *)titleSelectedFont {
    if (_titleSelectedFont != nil) {
        return _titleSelectedFont;
    }
    return self.titleFont;
}

#pragma mark - Override

- (Class)preferredCellClass {
    return [GTUITabBarTitleCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        GTUITabBarTitleCellModel *cellModel = [[GTUITabBarTitleCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshSelectedCellModel:(GTUITabBarBaseCellModel *)selectedCellModel unselectedCellModel:(GTUITabBarBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];
    
    GTUITabBarTitleCellModel *myUnselectedCellModel = (GTUITabBarTitleCellModel *)unselectedCellModel;
    myUnselectedCellModel.titleColor = self.titleColor;
    myUnselectedCellModel.titleSelectedColor = self.titleSelectedColor;
    myUnselectedCellModel.titleLabelZoomScale = 1.0;
    myUnselectedCellModel.titleLabelSelectedStrokeWidth = 0;
    
    GTUITabBarTitleCellModel *myselectedCellModel = (GTUITabBarTitleCellModel *)selectedCellModel;
    myselectedCellModel.titleColor = self.titleColor;
    myselectedCellModel.titleSelectedColor = self.titleSelectedColor;
    myselectedCellModel.titleLabelZoomScale = self.titleLabelZoomScale;
    myselectedCellModel.titleLabelSelectedStrokeWidth = self.titleLabelSelectedStrokeWidth;
}

- (void)refreshLeftCellModel:(GTUITabBarBaseCellModel *)leftCellModel rightCellModel:(GTUITabBarBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];
    
    GTUITabBarTitleCellModel *leftModel = (GTUITabBarTitleCellModel *)leftCellModel;
    GTUITabBarTitleCellModel *rightModel = (GTUITabBarTitleCellModel *)rightCellModel;
    
    if (self.titleLabelZoomEnabled && self.titleLabelZoomScrollGradientEnabled) {
        leftModel.titleLabelZoomScale = [GTUITabBarFactory interpolationFrom:self.titleLabelZoomScale to:1.0 percent:ratio];
        rightModel.titleLabelZoomScale = [GTUITabBarFactory interpolationFrom:1.0 to:self.titleLabelZoomScale percent:ratio];
    }
    
    if (self.titleLabelStrokeWidthEnabled) {
        leftModel.titleLabelSelectedStrokeWidth = [GTUITabBarFactory interpolationFrom:self.titleLabelSelectedStrokeWidth to:0 percent:ratio];
        rightModel.titleLabelSelectedStrokeWidth = [GTUITabBarFactory interpolationFrom:0 to:self.titleLabelSelectedStrokeWidth percent:ratio];
    }
    
    if (self.titleColorGradientEnabled) {
        //处理颜色渐变
        if (leftModel.selected) {
            leftModel.titleSelectedColor = [GTUITabBarFactory interpolationColorFrom:self.titleSelectedColor to:self.titleColor percent:ratio];
            leftModel.titleColor = self.titleColor;
        }else {
            leftModel.titleColor = [GTUITabBarFactory interpolationColorFrom:self.titleSelectedColor to:self.titleColor percent:ratio];
            leftModel.titleSelectedColor = self.titleSelectedColor;
        }
        if (rightModel.selected) {
            rightModel.titleSelectedColor = [GTUITabBarFactory interpolationColorFrom:self.titleColor to:self.titleSelectedColor percent:ratio];
            rightModel.titleColor = self.titleColor;
        }else {
            rightModel.titleColor = [GTUITabBarFactory interpolationColorFrom:self.titleColor to:self.titleSelectedColor percent:ratio];
            rightModel.titleSelectedColor = self.titleSelectedColor;
        }
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (self.cellWidth == GTUITabBarViewAutomaticDimension) {
        return ceilf([self.titles[index] boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleFont} context:nil].size.width);
    }else {
        return self.cellWidth;
    }
}

- (void)refreshCellModel:(GTUITabBarBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];
    
    GTUITabBarTitleCellModel *model = (GTUITabBarTitleCellModel *)cellModel;
    model.titleFont = self.titleFont;
    model.titleSelectedFont = self.titleSelectedFont;
    model.titleColor = self.titleColor;
    model.titleSelectedColor = self.titleSelectedColor;
    model.title = self.titles[index];
    model.titleLabelMaskEnabled = self.titleLabelMaskEnabled;
    model.titleLabelZoomEnabled = self.titleLabelZoomEnabled;
    model.titleLabelZoomScale = 1.0;
    model.titleLabelStrokeWidthEnabled = self.titleLabelStrokeWidthEnabled;
    model.titleLabelSelectedStrokeWidth = 0;
    if (index == self.selectedIndex) {
        model.titleLabelZoomScale = self.titleLabelZoomScale;
        model.titleLabelSelectedStrokeWidth = self.titleLabelSelectedStrokeWidth;
    }
}


@end
