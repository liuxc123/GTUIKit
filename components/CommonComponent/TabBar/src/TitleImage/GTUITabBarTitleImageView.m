//
//  GTUITabBarTitleImageView.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarTitleImageView.h"
#import "GTUITabBarFactory.h"

@implementation GTUITabBarTitleImageView


- (void)dealloc
{
    self.loadImageCallback = nil;
}

- (void)initializeData {
    [super initializeData];
    
    _imageSize = CGSizeMake(20, 20);
    _titleImageSpacing = 5;
    _imageZoomEnabled = NO;
    _imageZoomScale = 1.2;
}

- (Class)preferredCellClass {
    return [GTUITabBarTitleImageCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        GTUITabBarTitleImageCellModel *cellModel = [[GTUITabBarTitleImageCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    if (self.imageTypes == nil || self.imageTypes.count == 0) {
        NSMutableArray *types = [NSMutableArray array];
        for (int i = 0; i < self.titles.count; i++) {
            [types addObject:@(GTUITabBarTitleImageTypeLeftImage)];
        }
        self.imageTypes = types;
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(GTUITabBarBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];
    
    GTUITabBarTitleImageCellModel *myCellModel = (GTUITabBarTitleImageCellModel *)cellModel;
    myCellModel.loadImageCallback = self.loadImageCallback;
    myCellModel.imageType = [self.imageTypes[index] integerValue];
    myCellModel.imageSize = self.imageSize;
    myCellModel.titleImageSpacing = self.titleImageSpacing;
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

- (void)refreshSelectedCellModel:(GTUITabBarBaseCellModel *)selectedCellModel unselectedCellModel:(GTUITabBarBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];
    
    GTUITabBarTitleImageCellModel *myUnselectedCellModel = (GTUITabBarTitleImageCellModel *)unselectedCellModel;
    myUnselectedCellModel.imageZoomScale = 1.0;
    
    GTUITabBarTitleImageCellModel *myselectedCellModel = (GTUITabBarTitleImageCellModel *)selectedCellModel;
    myselectedCellModel.imageZoomScale = self.imageZoomScale;
}

- (void)refreshLeftCellModel:(GTUITabBarBaseCellModel *)leftCellModel rightCellModel:(GTUITabBarBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];
    
    GTUITabBarTitleImageCellModel *leftModel = (GTUITabBarTitleImageCellModel *)leftCellModel;
    GTUITabBarTitleImageCellModel *rightModel = (GTUITabBarTitleImageCellModel *)rightCellModel;
    
    if (self.imageZoomEnabled) {
        leftModel.imageZoomScale = [GTUITabBarFactory interpolationFrom:self.imageZoomScale to:1.0 percent:ratio];
        rightModel.imageZoomScale = [GTUITabBarFactory interpolationFrom:1.0 to:self.imageZoomScale percent:ratio];
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    CGFloat titleWidth = [super preferredCellWidthAtIndex:index];
    GTUITabBarTitleImageType type = [self.imageTypes[index] integerValue];
    CGFloat cellWidth = 0;
    switch (type) {
        case GTUITabBarTitleImageTypeOnlyTitle:
            cellWidth = titleWidth;
            break;
        case GTUITabBarTitleImageTypeOnlyImage:
            cellWidth = self.imageSize.width;
            break;
        case GTUITabBarTitleImageTypeLeftImage:
        case GTUITabBarTitleImageTypeRightImage:
            cellWidth = titleWidth + self.titleImageSpacing + self.imageSize.width;
            break;
        case GTUITabBarTitleImageTypeTopImage:
        case GTUITabBarTitleImageTypeBottomImage:
            cellWidth = MAX(titleWidth, self.imageSize.width);
            break;
    }
    return cellWidth;
}

@end
