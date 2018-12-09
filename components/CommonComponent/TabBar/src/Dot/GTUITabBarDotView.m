//
//  GTUITabBarDotView.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarDotView.h"

@implementation GTUITabBarDotView

- (void)initializeData {
    [super initializeData];
    
    _relativePosition = GTUITabBarDotRelativePositionTopRight;
    _dotSize = CGSizeMake(10, 10);
    _dotCornerRadius = GTUITabBarViewAutomaticDimension;
    _dotColor = [UIColor redColor];
}

- (Class)preferredCellClass {
    return [GTUITabBarDotCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        GTUITabBarDotCellModel *cellModel = [[GTUITabBarDotCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(GTUITabBarBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];
    
    GTUITabBarDotCellModel *myCellModel = (GTUITabBarDotCellModel *)cellModel;
    myCellModel.dotHidden = [self.dotStates[index] boolValue];
    myCellModel.relativePosition = self.relativePosition;
    myCellModel.dotSize = self.dotSize;
    myCellModel.dotColor = self.dotColor;
    if (self.dotCornerRadius == GTUITabBarViewAutomaticDimension) {
        myCellModel.dotCornerRadius = self.dotSize.height/2;
    }else {
        myCellModel.dotCornerRadius = self.dotCornerRadius;
    }
}

@end
