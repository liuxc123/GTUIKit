//
//  GTUIUniversalRefresh.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/13.
//

#import <MJRefresh/MJRefresh.h>

static NSArray *refreshingHeaderImageArray;
static NSArray *refreshingfooterImageArray;

/**
 默认的下拉刷新控件
 */
@interface MJRefreshNormalHeader (GTUIUniversalRefresh)

@end


/**
 带动态图的下拉刷新控件
 */
@interface MJRefreshGifHeader (GTUIUniversalRefresh)

@end

/**
 默认的上拉刷新控件,下拉刷新控件自适应在页面内容下面
 */
@interface MJRefreshBackNormalFooter (GTUIUniversalRefresh)

@end

/**
 带动态图的上拉加载控件,下拉刷新控件自适应在页面内容下面
 */
@interface MJRefreshBackGifFooter (GTUIUniversalRefresh)

@end

/**
 默认的上拉动画刷新控件,下拉刷新控件一直在屏幕底部
 */
@interface MJRefreshAutoNormalFooter (GTUIUniversalRefresh)

@end

/**
 默认的上拉刷新控件,下拉刷新控件一直在屏幕底部
 */
@interface MJRefreshAutoGifFooter (GTUIUniversalRefresh)

@end

