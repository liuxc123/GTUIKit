//
//  GTUITabBarBaseCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarBaseCell.h"

@implementation GTUITabBarBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews
{
    
}

- (void)reloadData:(GTUITabBarBaseCellModel *)cellModel {
    self.cellModel = cellModel;
    
}


@end
