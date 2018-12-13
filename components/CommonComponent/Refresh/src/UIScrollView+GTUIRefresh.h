//
//  UIScrollView+GTUIRefresh.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/13.
//

#import <UIKit/UIKit.h>


/**
 Header类型

 - GTUIRefreshHeaderTypeNormal: 默认的下拉刷新
 - GTUIRefreshHeaderTypeGIF: 带Gif图片的下拉刷新
 */
typedef NS_ENUM(NSUInteger, GTUIRefreshHeaderType) {
    GTUIRefreshHeaderTypeNormal = 0,
    GTUIRefreshHeaderTypeGIF
};

/**
 Footer类型

 - GTUIRefreshFooterTypeBackNormal: 默认的上拉刷新，下拉刷新控件自适应在页面内容下面
 - GTUIRefreshFooterTypeBackGIF: 带动态图的上拉加载控件，下拉刷新控件自适应在页面内容下面
 - GTUIRefreshFooterTypeAutoNormal: 默认的上拉刷新控件，下拉刷新控件一直在屏幕底部
 - GTUIRefreshFooterTypeAutoGif: 默认的上拉动画刷新控件， 下拉刷新控件一直在屏幕底部
 */
typedef NS_ENUM(NSUInteger, GTUIRefreshFooterType) {
    GTUIRefreshFooterTypeBackNormal = 0,
    GTUIRefreshFooterTypeBackGIF,
    GTUIRefreshFooterTypeAutoNormal,
    GTUIRefreshFooterTypeAutoGIF
};


@interface UIScrollView (GTUIRefresh)


/**
 设置默认的下拉刷新控件，headerType默认为 GTUIRefreshHeaderTypeNormal

 @param headerBlock 下拉刷新回调
 */
- (void)setRefreshWithHeaderBlock:(void (^)(void))headerBlock;


/**
 设置默认的上拉加载控件, footerType默认为 GTUIRefreshFooterTypeBackNormal

 @param footerBlock 上拉刷新回调
 */
- (void)setRefreshWithFooterBlock:(void (^)(void))footerBlock;


/**
 设置下拉刷新控件

 @param headerType header类型
 @param headerBlock 上拉刷新回调
 */
- (void)setRefreshWithHeaderType:(GTUIRefreshHeaderType)headerType headerBlock:(void (^)(void))headerBlock;


/**
 设置上拉加载控件

 @param footerType Footer类型
 @param footerBlock 上拉刷新回调
 */
- (void)setRefreshWithFooterType:(GTUIRefreshFooterType)footerType footerBlock:(void (^)(void))footerBlock;

/**
 设置默认的刷新控件
 headerType默认为 GTUIRefreshHeaderTypeNormal
 footerType默认为 GTUIRefreshFooterTypeBackNormal

 @param headerBlock 下拉刷新回调
 @param footerBlock 上拉刷新回调
 */
- (void)setRefreshWithHeaderBlock:(void (^)(void))headerBlock footerBlock:(void (^)(void))footerBlock;


/**
 设置刷新控件

 @param headerType header类型
 @param headerBlock 下拉刷新回调
 @param footerType footer类型
 @param footerBlock 上拉刷新回调
 */
- (void)setRefreshWithHeaderType:(GTUIRefreshHeaderType)headerType headerBlock:(void (^)(void))headerBlock footerType:(GTUIRefreshFooterType)footerType footerBlock:(void (^)(void))footerBlock;


- (void)headerBeginRefreshing;
- (void)headerEndRefreshing;
- (void)footerEndRefreshing;
- (void)footerNoMoreData;
- (void)endRefreshing:(BOOL)isNoMoreData;

- (void)hideHeaderRefresh;
- (void)hideFooterRefresh;


@end
