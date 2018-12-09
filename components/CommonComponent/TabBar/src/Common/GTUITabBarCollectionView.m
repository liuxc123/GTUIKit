//
//  GTUITabBarCollectionView.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarCollectionView.h"

@implementation GTUITabBarCollectionView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView<GTUITabBarIndicatorProtocol> *view in self.indicators) {
        [self sendSubviewToBack:view];
    }
}

@end
