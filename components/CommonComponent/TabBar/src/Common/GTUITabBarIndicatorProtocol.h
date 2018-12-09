//
//  GTUITabBarIndicatorProtocol.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTUITabBarViewDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GTUITabBarIndicatorProtocol <NSObject>

- (void)refreshState:(CGRect)selectedCellFrame;

/**
 contentScrollView在进行手势滑动时，处理指示器跟随手势变化UI逻辑；
 
 @param leftCellFrame 正在过渡中的两个cell，相对位置在左边的cell的frame
 @param rightCellFrame 正在过渡中的两个cell，相对位置在右边的cell的frame
 @param selectedPosition 当前处于选中状态的cell的位置
 @param percent 过渡百分比
 */
- (void)contentScrollViewDidScrollWithLeftCellFrame:(CGRect)leftCellFrame rightCellFrame:(CGRect)rightCellFrame selectedPosition:(GTUITabBarCellClickedPosition)selectedPosition percent:(CGFloat)percent;

/**
 点击选中了某一个cell
 
 @param cellFrame cell的frame
 @param clickedRelativePosition 相对于已选中cell，当前点击的cell的相对位置。比如 A、B、C 当前处于选中状态的是B。点击了A是GTUITabBarCellClickedPositionLeft；点击了C是GTUITabBarCellClickedPositionRight;
 @param isClicked YES：点击选中；NO：滚动选中。
 */
- (void)selectedCell:(CGRect)cellFrame clickedRelativePosition:(GTUITabBarCellClickedPosition)clickedRelativePosition isClicked:(BOOL)isClicked;

@end

NS_ASSUME_NONNULL_END
