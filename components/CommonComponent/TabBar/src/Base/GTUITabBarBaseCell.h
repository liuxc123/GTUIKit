//
//  GTUITabBarBaseCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import <UIKit/UIKit.h>
#import "GTUITabBarBaseCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarBaseCell : UICollectionViewCell

@property (nonatomic, strong) GTUITabBarBaseCellModel *cellModel;

- (void)initializeViews NS_REQUIRES_SUPER;

- (void)reloadData:(GTUITabBarBaseCellModel *)cellModel NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
