//
//  GTUITabBarCollectionView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import <UIKit/UIKit.h>
#import "GTUITabBarIndicatorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarCollectionView : UICollectionView

@property (nonatomic, strong) NSArray <UIView<GTUITabBarIndicatorProtocol> *> *indicators;

@end

NS_ASSUME_NONNULL_END
