//
//  GTUITabBarIndicatorCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorCell.h"
#import "GTUITabBarIndicatorCellModel.h"

@interface GTUITabBarIndicatorCell ()
@property (nonatomic, strong) UIView *separatorLine;
@end

@implementation GTUITabBarIndicatorCell

- (void)initializeViews
{
    [super initializeViews];
    
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.hidden = YES;
    [self.contentView addSubview:self.separatorLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    GTUITabBarIndicatorCellModel *model = (GTUITabBarIndicatorCellModel *)self.cellModel;
    CGFloat lineWidth = model.separatorLineSize.width;
    CGFloat lineHeight = model.separatorLineSize.height;
    
    self.separatorLine.frame = CGRectMake(self.bounds.size.width - lineWidth + self.cellModel.cellSpacing/2, (self.bounds.size.height - lineHeight)/2.0, lineWidth, lineHeight);
}

- (void)reloadData:(GTUITabBarIndicatorCellModel *)cellModel {
    [super reloadData:cellModel];
    
    GTUITabBarIndicatorCellModel *model = (GTUITabBarIndicatorCellModel *)cellModel;
    self.separatorLine.backgroundColor = model.separatorLineColor;
    self.separatorLine.hidden = !model.sepratorLineShowEnabled;
    
    if (model.cellBackgroundColorGradientEnabled) {
        if (model.selected) {
            self.contentView.backgroundColor = model.cellBackgroundSelectedColor;
        }else {
            self.contentView.backgroundColor = model.cellBackgroundUnselectedColor;
        }
    }
}

@end
