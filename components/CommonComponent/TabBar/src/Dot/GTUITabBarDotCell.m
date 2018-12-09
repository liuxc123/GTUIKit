//
//  GTUITabBarDotCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarDotCell.h"
#import "GTUITabBarDotCellModel.h"

@interface GTUITabBarDotCell ()
@property (nonatomic, strong) CALayer *dotLayer;
@end

@implementation GTUITabBarDotCell

- (void)initializeViews {
    [super initializeViews];
    
    _dotLayer = [CALayer layer];
    [self.contentView.layer addSublayer:self.dotLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    GTUITabBarDotCellModel *myCellModel = (GTUITabBarDotCellModel *)self.cellModel;
    self.dotLayer.bounds = CGRectMake(0, 0, myCellModel.dotSize.width, myCellModel.dotSize.height);
    switch (myCellModel.relativePosition) {
        case GTUITabBarDotRelativePositionTopLeft:
        {
            self.dotLayer.position = CGPointMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame));
        }
            break;
        case GTUITabBarDotRelativePositionTopRight:
        {
            self.dotLayer.position = CGPointMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame));
        }
            break;
        case GTUITabBarDotRelativePositionBottomLeft:
        {
            self.dotLayer.position = CGPointMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame));
        }
            break;
        case GTUITabBarDotRelativePositionBottomRight:
        {
            self.dotLayer.position = CGPointMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame));
        }
            break;
            
        default:
            break;
    }
    self.dotLayer.position = CGPointMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame));
    
    [CATransaction commit];
}

- (void)reloadData:(GTUITabBarBaseCellModel *)cellModel {
    [super reloadData:cellModel];
    
    GTUITabBarDotCellModel *myCellModel = (GTUITabBarDotCellModel *)cellModel;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.dotLayer.hidden = !myCellModel.dotHidden;
    self.dotLayer.backgroundColor = myCellModel.dotColor.CGColor;
    self.dotLayer.cornerRadius = myCellModel.dotCornerRadius;
    [CATransaction commit];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
