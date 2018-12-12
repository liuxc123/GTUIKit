//
//  GTUIPageListContainerView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/12.
//

#import <UIKit/UIKit.h>

@class GTUIPageMainTableView;
@class GTUIPageListContainerView;
@class GTUIPageListContainerCollectionView;

@protocol GTUIPageListContainerCollectionViewGestureDelegate <NSObject>
- (BOOL)pagerListContainerCollectionViewGestureRecognizerShouldBegin:(GTUIPageListContainerCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
@end

@interface GTUIPageListContainerCollectionView: UICollectionView<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isNestEnabled;
@property (nonatomic, weak) id<GTUIPageListContainerCollectionViewGestureDelegate> gestureDelegate;
@end

@protocol GTUIPageListContainerViewDelegate <NSObject>

- (NSInteger)numberOfRowsInListContainerView:(GTUIPageListContainerView *)listContainerView;

- (UIView *)listContainerView:(GTUIPageListContainerView *)listContainerView listViewInRow:(NSInteger)row;

- (void)listContainerView:(GTUIPageListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row;

@end


@interface GTUIPageListContainerView : UIView

@property (nonatomic, strong, readonly) GTUIPageListContainerCollectionView *collectionView;
@property (nonatomic, weak) id<GTUIPageListContainerViewDelegate> delegate;
@property (nonatomic, weak) GTUIPageMainTableView *mainTableView;

- (instancetype)initWithDelegate:(id<GTUIPageListContainerViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)reloadData;

@end
