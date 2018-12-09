//
//  GTUITabBarImageCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarImageCell.h"
#import "GTUITabBarImageCellModel.h"

@implementation GTUITabBarImageCell

- (void)initializeViews {
    [super initializeViews];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    GTUITabBarImageCellModel *myCellModel = (GTUITabBarImageCellModel *)self.cellModel;
    self.imageView.bounds = CGRectMake(0, 0, myCellModel.imageSize.width, myCellModel.imageSize.height);
    self.imageView.center = self.contentView.center;
    self.imageView.layer.cornerRadius = myCellModel.imageCornerRadius;
}

- (void)reloadData:(GTUITabBarBaseCellModel *)cellModel {
    [super reloadData:cellModel];
    
    GTUITabBarImageCellModel *myCellModel = (GTUITabBarImageCellModel *)cellModel;
    if (myCellModel.imageName != nil) {
        self.imageView.image = [UIImage imageNamed:myCellModel.imageName];
    }else if (myCellModel.imageURL != nil) {
        if (myCellModel.loadImageCallback != nil) {
            myCellModel.loadImageCallback(self.imageView, myCellModel.imageURL);
        }
    }
    if (myCellModel.selected) {
        if (myCellModel.selectedImageName != nil) {
            self.imageView.image = [UIImage imageNamed:myCellModel.selectedImageName];
        }else if (myCellModel.selectedImageURL != nil) {
            if (myCellModel.loadImageCallback != nil) {
                myCellModel.loadImageCallback(self.imageView, myCellModel.selectedImageURL);
            }
        }
    }
    
    if (myCellModel.imageZoomEnabled) {
        self.imageView.transform = CGAffineTransformMakeScale(myCellModel.imageZoomScale, myCellModel.imageZoomScale);
    }else {
        self.imageView.transform = CGAffineTransformIdentity;
    }
}


@end
