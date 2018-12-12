//
//  GTUIPageView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/12.
//

#import <UIKit/UIKit.h>
#import "GTUIPageListContainerView.h"
#import "GTUIPageMainTableView.h"

@class GTUIPageView;

/**
 该协议主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
 */
@protocol GTUIPageViewListViewDelegate <NSObject>

/**
 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。

 @return UIView
 */
- (UIView *)listView;

/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView

 @return listView内部持有的UIScrollView或UITableView或UICollectionView
 */
- (UIScrollView *)listScrollView;


/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback

 @param callback `scrollViewDidScroll`回调时调用的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback;

@optional

/**
 将要重置listScrollView的contentOffset
 */
- (void)listScrollViewWillResetContentOffset;

@end

@protocol GTUIPageViewDelegate <NSObject>


/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数

 @param pagerView pagerView description
 @return return tableHeaderView的高度
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(GTUIPageView *)pagerView;


/**
 返回tableHeaderView

 @param pagerView pagerView description
 @return tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(GTUIPageView *)pagerView;


/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数

 @param pagerView pagerView description
 @return 悬浮HeaderView的高度
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(GTUIPageView *)pagerView;


/**
 返回悬浮HeaderView。我用的是自己封装的GTUITabBarView，你也可以选择其他的三方库或者自己写

 @param pagerView pagerView description
 @return 悬浮HeaderView
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(GTUIPageView *)pagerView;

/**
 返回listViews，只要遵循GTUIPageViewListViewDelegate即可，无论你返回的是UIView还是UIViewController都可以。

 @param pagerView pagerView description
 @return listViews
 */
- (NSArray <id<GTUIPageViewListViewDelegate>> *)listViewsInPagerView:(GTUIPageView *)pagerView;

@optional

/**
 mainTableView的滚动回调，用于实现头图跟随缩放

 @param scrollView mainTableView
 */
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView;

@end


@interface GTUIPageView : UIView

@property (nonatomic, weak) id<GTUIPageViewDelegate> delegate;

@property (nonatomic, strong, readonly) GTUIPageMainTableView *mainTableView;

@property (nonatomic, strong, readonly) GTUIPageListContainerView *listContainerView;

- (instancetype)initWithDelegate:(id<GTUIPageViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) UIScrollView *currentScrollingListView;

@property (nonatomic, strong, readonly) id<GTUIPageViewListViewDelegate> currentListView;

@property (nonatomic, assign) BOOL isListHorizontalScrollEnabled;     //是否允许列表左右滑动。默认：YES

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)initializeViews NS_REQUIRES_SUPER;

- (void)reloadData;

#pragma mark - Subclass

- (void)preferredProcessListViewDidScroll:(UIScrollView *)scrollView;

- (void)preferredProcessMainTableViewDidScroll:(UIScrollView *)scrollView;

@end
