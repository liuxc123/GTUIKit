//
//  GTUITabBarImageView.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarImageView.h"
#import "GTUITabBarFactory.h"

@implementation GTUITabBarImageView

- (void)dealloc
{
    self.loadImageCallback = nil;
}

- (void)initializeData {
    [super initializeData];
    
    _imageSize = CGSizeMake(20, 20);
    _imageZoomEnabled = NO;
    _imageZoomScale = 1.2;
    _imageCornerRadius = 0;
}

- (Class)preferredCellClass {
    return [GTUITabBarImageCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    NSUInteger count = (self.imageNames.count > 0) ? self.imageNames.count : (self.imageURLs.count > 0 ? self.imageURLs.count : 0);
    for (int i = 0; i < count; i++) {
        GTUITabBarImageCellModel *cellModel = [[GTUITabBarImageCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshSelectedCellModel:(GTUITabBarBaseCellModel *)selectedCellModel unselectedCellModel:(GTUITabBarBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];
    
    GTUITabBarImageCellModel *myUnselectedCellModel = (GTUITabBarImageCellModel *)unselectedCellModel;
    myUnselectedCellModel.imageZoomScale = 1.0;
    
    GTUITabBarImageCellModel *myselectedCellModel = (GTUITabBarImageCellModel *)selectedCellModel;
    myselectedCellModel.imageZoomScale = self.imageZoomScale;
}

- (void)refreshCellModel:(GTUITabBarBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];
    
    GTUITabBarImageCellModel *myCellModel = (GTUITabBarImageCellModel *)cellModel;
    myCellModel.loadImageCallback = self.loadImageCallback;
    myCellModel.imageSize = self.imageSize;
    myCellModel.imageCornerRadius = self.imageCornerRadius;
    if (self.imageNames != nil) {
        myCellModel.imageName = self.imageNames[index];
    }else if (self.imageURLs != nil) {
        myCellModel.imageURL = self.imageURLs[index];
    }
    if (self.selectedImageNames != nil) {
        myCellModel.selectedImageName = self.selectedImageNames[index];
    }else if (self.selectedImageURLs != nil) {
        myCellModel.selectedImageURL = self.selectedImageURLs[index];
    }
    myCellModel.imageZoomEnabled = self.imageZoomEnabled;
    myCellModel.imageZoomScale = 1.0;
    if (index == self.selectedIndex) {
        myCellModel.imageZoomScale = self.imageZoomScale;
    }
}

- (void)refreshLeftCellModel:(GTUITabBarBaseCellModel *)leftCellModel rightCellModel:(GTUITabBarBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];
    
    GTUITabBarImageCellModel *leftModel = (GTUITabBarImageCellModel *)leftCellModel;
    GTUITabBarImageCellModel *rightModel = (GTUITabBarImageCellModel *)rightCellModel;
    
    if (self.imageZoomEnabled) {
        leftModel.imageZoomScale = [GTUITabBarFactory interpolationFrom:self.imageZoomScale to:1.0 percent:ratio];
        rightModel.imageZoomScale = [GTUITabBarFactory interpolationFrom:1.0 to:self.imageZoomScale percent:ratio];
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    return self.imageSize.width;
}


@end
