//
//  UIView+GTUIEmptyView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import <UIKit/UIKit.h>

@class GTUIEmptyView;
@class GTUILoadingView;

@interface UIView (GTUIEmptyView)

/**  空页面占位图控件 */
@property (nonatomic, strong) GTUIEmptyView *gt_emptyView;

/**
 Loading占位图控件
 */
@property (nonatomic, strong) GTUILoadingView *gt_loadingView;

/**
 是否正在Loading
 */
@property (nonatomic, assign, readonly) BOOL gt_isLoading;




////////////////////////////////////////////////////////////////////////////////////////////
// 调用下面四个手动显隐的方法，不受DataSource的影响，单独设置显示与隐藏（前提是关闭autoShowEmptyView）//
////////////////////////////////////////////////////////////////////////////////////////////

/** 手动调用显示emptyView  */
- (void)gt_showEmptyView;

/** 手动调用隐藏emptyView  */
- (void)gt_hideEmptyView;


/**
 一般用于开始请求网络时调用，gt_startLoading调用时会暂时隐藏emptyView
 当调用gt_endLoading方法时，gt_endLoading方法内部会根据当前的tableView/collectionView的
 DataSource来自动判断是否显示emptyView
 */
- (void)gt_startLoading;

/**
 在想要刷新emptyView状态时调用
 注意:gt_endLoading 的调用时机，有刷新UI的地方一定要等到刷新UI的方法之后调用，
 因为只有刷新了UI，view的DataSource才会更新，故调用此方法才能正确判断是否有内容。
 */
- (void)gt_endLoading;

@end
