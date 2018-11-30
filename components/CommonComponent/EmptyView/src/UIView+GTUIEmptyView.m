//
//  UIView+GTUIEmptyView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "UIView+GTUIEmptyView.h"
#import <objc/runtime.h>
#import "GTUIEmptyView.h"
#import "GTUILoadingView.h"

#pragma mark - UIView

@implementation UIView (GTUIEmptyView)

#pragma mark - runtime replace

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

#pragma mark - Setter/Getter

- (void)setGt_emptyView:(GTUIEmptyView *)gt_emptyView
{
    if (gt_emptyView != self.gt_emptyView) {

        objc_setAssociatedObject(self, @selector(gt_emptyView), gt_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[GTUIEmptyView class]]) {
                [view removeFromSuperview];
            }
        }
        self.gt_emptyView.hidden = YES;
        [self addSubview:self.gt_emptyView];
    }
}

- (GTUIEmptyView *)gt_emptyView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_loadingView:(GTUILoadingView *)gt_loadingView
{
    if (gt_loadingView != self.gt_loadingView) {

        objc_setAssociatedObject(self, @selector(gt_loadingView), gt_loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[GTUILoadingView class]]) {
                [view removeFromSuperview];
            }
        }
        self.gt_loadingView.hidden = YES;
        [self addSubview:self.gt_loadingView];
    }
}

- (GTUILoadingView *)gt_loadingView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_isLoading:(BOOL)gt_isLoading
{
    NSNumber *number = [NSNumber numberWithBool:gt_isLoading];
    objc_setAssociatedObject(self, @selector(gt_isLoading), number, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)gt_isLoading
{
    BOOL obj = ((NSNumber *)objc_getAssociatedObject(self, _cmd)).boolValue;
    return obj ? obj : NO;
}


#pragma mark - Public Method

- (void)gt_showEmptyView{

    [self.gt_emptyView.superview layoutSubviews];

    self.gt_emptyView.hidden = NO;

    //让 emptyBGView 始终保持在最上层
    [self bringSubviewToFront:self.gt_emptyView];
}

- (void)gt_hideEmptyView{
    self.gt_emptyView.hidden = YES;
}

- (void)gt_showLoadingView {
    [self.gt_loadingView.superview layoutSubviews];

    self.gt_loadingView.hidden = NO;

    //让 loadingView 始终保持在最上层
    [self bringSubviewToFront:self.gt_loadingView];
}

- (void)gt_hideLoadingView{
    self.gt_loadingView.hidden = YES;
}


- (void)gt_startLoading{
    self.gt_isLoading = YES;
    self.gt_emptyView.hidden = YES;
    [self gt_showLoadingView];
}
- (void)gt_endLoading{
    self.gt_isLoading = NO;
    [self gt_hideLoadingView];
    self.gt_emptyView.hidden = [self totalDataCount];
}

#pragma mark - Private Method (UITableView、UICollectionView有效)

- (NSInteger)totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;

        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;

        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

- (void)getDataAndSet{
    //没有设置emptyView的，直接返回
    if (!self.gt_emptyView) {
        return;
    }

    if ([self totalDataCount] == 0) {
        [self show];
    }else{
        [self hide];
    }
}

- (void)show{

    //当不自动显隐时，内部自动调用show方法时也不要去显示，要显示的话只有手动去调用 gt_showEmptyView
    if (!self.gt_emptyView.autoShowEmptyView || self.gt_isLoading) {
        [self gt_hideEmptyView];
        [self gt_hideLoadingView];
        return;
    }

    [self gt_showEmptyView];
}
- (void)hide{

    if (!self.gt_emptyView.autoShowEmptyView || self.gt_isLoading) {
        [self gt_hideEmptyView];
        [self gt_hideLoadingView];
        return;
    }

    [self gt_hideEmptyView];
}

@end


#pragma mark - UITableView

@implementation UITableView (GTEmpty)
+ (void)load{

    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(gt_reloadData)];

    ///section
    [self exchangeInstanceMethod1:@selector(insertSections:withRowAnimation:) method2:@selector(gt_insertSections:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(deleteSections:withRowAnimation:) method2:@selector(gt_deleteSections:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(reloadSections:withRowAnimation:) method2:@selector(gt_reloadSections:withRowAnimation:)];

    ///row
    [self exchangeInstanceMethod1:@selector(insertRowsAtIndexPaths:withRowAnimation:) method2:@selector(gt_insertRowsAtIndexPaths:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(deleteRowsAtIndexPaths:withRowAnimation:) method2:@selector(gt_deleteRowsAtIndexPaths:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(reloadRowsAtIndexPaths:withRowAnimation:) method2:@selector(gt_reloadRowsAtIndexPaths:withRowAnimation:)];
}

- (void)gt_reloadData{
    [self gt_reloadData];
    [self getDataAndSet];
}
///section
- (void)gt_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self gt_insertSections:sections withRowAnimation:animation];
    [self getDataAndSet];
}
- (void)gt_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self gt_deleteSections:sections withRowAnimation:animation];
    [self getDataAndSet];
}
- (void)gt_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self gt_reloadSections:sections withRowAnimation:animation];
    [self getDataAndSet];
}

///row
- (void)gt_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self gt_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self getDataAndSet];
}
- (void)gt_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self gt_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self getDataAndSet];
}
- (void)gt_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self gt_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self getDataAndSet];
}
@end

#pragma mark - UICollectionView

@implementation UICollectionView (Empty)

+ (void)load{

    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(gt_reloadData)];

    ///section
    [self exchangeInstanceMethod1:@selector(insertSections:) method2:@selector(gt_insertSections:)];
    [self exchangeInstanceMethod1:@selector(deleteSections:) method2:@selector(gt_deleteSections:)];
    [self exchangeInstanceMethod1:@selector(reloadSections:) method2:@selector(gt_reloadSections:)];

    ///item
    [self exchangeInstanceMethod1:@selector(insertItemsAtIndexPaths:) method2:@selector(gt_insertItemsAtIndexPaths:)];
    [self exchangeInstanceMethod1:@selector(deleteItemsAtIndexPaths:) method2:@selector(gt_deleteItemsAtIndexPaths:)];
    [self exchangeInstanceMethod1:@selector(reloadItemsAtIndexPaths:) method2:@selector(gt_reloadItemsAtIndexPaths:)];

}
- (void)gt_reloadData{
    [self gt_reloadData];
    [self getDataAndSet];
}
///section
- (void)gt_insertSections:(NSIndexSet *)sections{
    [self gt_insertSections:sections];
    [self getDataAndSet];
}
- (void)gt_deleteSections:(NSIndexSet *)sections{
    [self gt_deleteSections:sections];
    [self getDataAndSet];
}
- (void)gt_reloadSections:(NSIndexSet *)sections{
    [self gt_reloadSections:sections];
    [self getDataAndSet];
}

///item
- (void)gt_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self gt_insertItemsAtIndexPaths:indexPaths];
    [self getDataAndSet];
}
- (void)gt_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self gt_deleteItemsAtIndexPaths:indexPaths];
    [self getDataAndSet];
}
- (void)gt_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self gt_reloadItemsAtIndexPaths:indexPaths];
    [self getDataAndSet];
}
@end


