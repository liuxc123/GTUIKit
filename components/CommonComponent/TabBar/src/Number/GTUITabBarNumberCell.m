//
//  GTUITabBarNumberCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarNumberCell.h"
#import "GTUITabBarNumberCellModel.h"

@implementation GTUITabBarNumberCell

- (void)initializeViews {
    [super initializeViews];
    
    self.numberLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label;
    });
    [self.contentView addSubview:self.numberLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.numberLabel sizeToFit];
    GTUITabBarNumberCellModel *myCellModel = (GTUITabBarNumberCellModel *)self.cellModel;
    self.numberLabel.bounds = CGRectMake(0, 0, self.numberLabel.bounds.size.width + myCellModel.numberLabelWidthIncrement, myCellModel.numberLabelHeight);
    self.numberLabel.layer.cornerRadius = myCellModel.numberLabelHeight/2.0;
    self.numberLabel.center = CGPointMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame));
}

- (void)reloadData:(GTUITabBarBaseCellModel *)cellModel {
    [super reloadData:cellModel];
    
    GTUITabBarNumberCellModel *myCellModel = (GTUITabBarNumberCellModel *)cellModel;
    self.numberLabel.hidden = myCellModel.count == 0;
    self.numberLabel.backgroundColor = myCellModel.numberBackgroundColor;
    self.numberLabel.font = myCellModel.numberLabelFont;
    self.numberLabel.textColor = myCellModel.numberTitleColor;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)myCellModel.count];
    if (myCellModel.count >= 1000) {
        self.numberLabel.text = @"999+";
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
