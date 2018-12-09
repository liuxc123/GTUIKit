//
//  GTUITabBarTitleImageCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarTitleImageCell.h"
#import "GTUITabBarTitleImageCellModel.h"

@implementation GTUITabBarTitleImageCell

- (void)initializeViews {
    [super initializeViews];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    GTUITabBarTitleImageCellModel *myCellModel = (GTUITabBarTitleImageCellModel *)self.cellModel;
    self.titleLabel.hidden = NO;
    self.imageView.hidden = NO;
    CGSize imageSize = myCellModel.imageSize;
    self.imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    switch (myCellModel.imageType) {
            
        case GTUITabBarTitleImageTypeTopImage:
        {
            CGFloat contentHeight = imageSize.height + myCellModel.titleImageSpacing + self.titleLabel.bounds.size.height;
            self.imageView.center = CGPointMake(self.contentView.center.x, (self.contentView.bounds.size.height - contentHeight)/2 + imageSize.height/2);
            self.titleLabel.center = CGPointMake(self.contentView.center.x, CGRectGetMaxY(self.imageView.frame) + myCellModel.titleImageSpacing + self.titleLabel.bounds.size.height/2);
        }
            break;
            
        case GTUITabBarTitleImageTypeLeftImage:
        {
            CGFloat contentWidth = imageSize.width + myCellModel.titleImageSpacing + self.titleLabel.bounds.size.width;
            self.imageView.center = CGPointMake((self.contentView.bounds.size.width - contentWidth)/2 + imageSize.width/2, self.contentView.center.y);
            self.titleLabel.center = CGPointMake(CGRectGetMaxX(self.imageView.frame) + myCellModel.titleImageSpacing + self.titleLabel.bounds.size.width/2, self.contentView.center.y);
        }
            break;
            
        case GTUITabBarTitleImageTypeBottomImage:
        {
            CGFloat contentHeight = imageSize.height + myCellModel.titleImageSpacing + self.titleLabel.bounds.size.height;
            self.titleLabel.center = CGPointMake(self.contentView.center.x, (self.contentView.bounds.size.height - contentHeight)/2 + self.titleLabel.bounds.size.height/2);
            self.imageView.center = CGPointMake(self.contentView.center.x, CGRectGetMaxY(self.titleLabel.frame) + myCellModel.titleImageSpacing + imageSize.height/2);
        }
            break;
            
        case GTUITabBarTitleImageTypeRightImage:
        {
            CGFloat contentWidth = imageSize.width + myCellModel.titleImageSpacing + self.titleLabel.bounds.size.width;
            self.titleLabel.center = CGPointMake((self.contentView.bounds.size.width - contentWidth)/2 + self.titleLabel.bounds.size.width/2, self.contentView.center.y);
            self.imageView.center = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + myCellModel.titleImageSpacing + imageSize.width/2, self.contentView.center.y);
        }
            break;
            
        case GTUITabBarTitleImageTypeOnlyImage:
        {
            self.titleLabel.hidden = YES;
            self.imageView.center = self.contentView.center;
        }
            break;
            
        case GTUITabBarTitleImageTypeOnlyTitle:
        {
            self.imageView.hidden = YES;
            self.titleLabel.center = self.contentView.center;
        }
            break;
            
        default:
            break;
    }
}

- (void)reloadData:(GTUITabBarBaseCellModel *)cellModel {
    [super reloadData:cellModel];
    
    GTUITabBarTitleImageCellModel *myCellModel = (GTUITabBarTitleImageCellModel *)cellModel;
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
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
