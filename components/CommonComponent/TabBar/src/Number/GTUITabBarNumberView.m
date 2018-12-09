//
//  GTUITabBarNumberView.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarNumberView.h"

@implementation GTUITabBarNumberView

- (void)initializeData {
    [super initializeData];
    
    self.cellSpacing = 25;
    _numberTitleColor = [UIColor whiteColor];
    _numberBackgroundColor = [UIColor colorWithRed:241/255.0 green:147/255.0 blue:95/255.0 alpha:1];
    _numberLabelHeight = 14;
    _numberLabelWidthIncrement = 10;
    _numberLabelFont = [UIFont systemFontOfSize:11];
}

- (Class)preferredCellClass {
    return [GTUITabBarNumberCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        GTUITabBarNumberCellModel *cellModel = [[GTUITabBarNumberCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(GTUITabBarBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];
    
    GTUITabBarNumberCellModel *myCellModel = (GTUITabBarNumberCellModel *)cellModel;
    myCellModel.count = [self.counts[index] integerValue];
    myCellModel.numberBackgroundColor = self.numberBackgroundColor;
    myCellModel.numberTitleColor = self.numberTitleColor;
    myCellModel.numberLabelHeight = self.numberLabelHeight;
    myCellModel.numberLabelWidthIncrement = self.numberLabelWidthIncrement;
    myCellModel.numberLabelFont = self.numberLabelFont;
}

@end
