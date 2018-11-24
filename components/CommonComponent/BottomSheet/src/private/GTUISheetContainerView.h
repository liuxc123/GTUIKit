//
//  GTUISheetContainerView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import <UIKit/UIKit.h>
#import "GTUISheetState.h"

@protocol GTUISheetContainerViewDelegate;

@interface GTUISheetContainerView : UIView

@property(nonatomic, weak, nullable) id<GTUISheetContainerViewDelegate> delegate;
@property(nonatomic, readonly) GTUISheetState sheetState;
@property(nonatomic) CGFloat preferredSheetHeight;

- (nonnull instancetype)initWithFrame:(CGRect)frame
                          contentView:(nonnull UIView *)contentView
                           scrollView:(nullable UIScrollView *)scrollView NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(nullable NSCoder *)aDecoder NS_UNAVAILABLE;

@end

@protocol GTUISheetContainerViewDelegate <NSObject>

- (void)sheetContainerViewDidHide:(nonnull GTUISheetContainerView *)containerView;
- (void)sheetContainerViewWillChangeState:(nonnull GTUISheetContainerView *)containerView
                               sheetState:(GTUISheetState)sheetState;

@end
