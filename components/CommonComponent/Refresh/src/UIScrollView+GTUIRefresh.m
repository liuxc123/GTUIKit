//
//  UIScrollView+GTUIRefresh.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/13.
//

#import "UIScrollView+GTUIRefresh.h"
#import <MJRefresh/MJRefresh.h>
#import "GTUIUniversalRefresh.h"

@implementation UIScrollView (GTUIRefresh)

- (void)setRefreshWithHeaderBlock:(void (^)(void))headerBlock
{
    [self setRefreshWithHeaderType:GTUIRefreshHeaderTypeNormal headerBlock:headerBlock footerType:GTUIRefreshFooterTypeBackNormal footerBlock:nil];
}

- (void)setRefreshWithFooterBlock:(void (^)(void))footerBlock
{
    [self setRefreshWithHeaderType:GTUIRefreshHeaderTypeNormal headerBlock:nil footerType:GTUIRefreshFooterTypeBackNormal footerBlock:footerBlock];
}

- (void)setRefreshWithHeaderType:(GTUIRefreshHeaderType)headerType headerBlock:(void (^)(void))headerBlock
{
    [self setRefreshWithHeaderType:headerType headerBlock:headerBlock footerType:GTUIRefreshFooterTypeBackNormal footerBlock:nil];
}

- (void)setRefreshWithFooterType:(GTUIRefreshFooterType)footerType footerBlock:(void (^)(void))footerBlock
{
    [self setRefreshWithHeaderType:GTUIRefreshHeaderTypeNormal headerBlock:nil footerType:footerType footerBlock:footerBlock];
}

- (void)setRefreshWithHeaderBlock:(void (^)(void))headerBlock footerBlock:(void (^)(void))footerBlock
{
    [self setRefreshWithHeaderType:GTUIRefreshHeaderTypeNormal headerBlock:headerBlock footerType:GTUIRefreshFooterTypeBackNormal footerBlock:footerBlock];
}

- (void)setRefreshWithHeaderType:(GTUIRefreshHeaderType)headerType
                     headerBlock:(void (^)(void))headerBlock
                      footerType:(GTUIRefreshFooterType)footerType
                     footerBlock:(void (^)(void))footerBlock
{
    if (headerBlock) {

        MJRefreshHeader *header;

        if (headerType == GTUIRefreshHeaderTypeNormal) {
            header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                if (headerBlock) {
                    headerBlock();
                }
            }];
        }

        if (headerType == GTUIRefreshHeaderTypeGIF) {
            header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
                if (headerBlock) {
                    headerBlock();
                }
            }];
        }

        self.mj_header = header;
    }
    if (footerBlock) {

        MJRefreshFooter *footer;

        if (footerType == GTUIRefreshFooterTypeBackNormal) {
            footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                footerBlock();
            }];
        }

        if (footerType == GTUIRefreshFooterTypeBackGIF) {
            footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
                footerBlock();
            }];
        }

        if (footerType == GTUIRefreshFooterTypeAutoNormal) {
            footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                footerBlock();
            }];
        }
        if (footerType == GTUIRefreshFooterTypeAutoGIF) {
            footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
                footerBlock();
            }];
        }
        self.mj_footer = footer;
    }

}

- (void)headerBeginRefreshing
{
    [self.mj_header beginRefreshing];
}

- (void)headerEndRefreshing
{
    [self.mj_header endRefreshing];
}

- (void)footerEndRefreshing
{
    [self.mj_footer endRefreshing];
}

- (void)footerNoMoreData
{
    [self.mj_footer setState:MJRefreshStateNoMoreData];
}

- (void)endRefreshing:(BOOL)isNoMoreData
{
    if (self.mj_header) {
        [self.mj_header endRefreshing];
    }
    if (isNoMoreData) {
        [self.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self.mj_footer endRefreshing];
    }
}

- (void)hideFooterRefresh{
    self.mj_footer.hidden = YES;
}


- (void)hideHeaderRefresh{
    self.mj_header.hidden = YES;
}


@end
