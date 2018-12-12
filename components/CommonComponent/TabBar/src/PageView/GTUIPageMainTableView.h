//
//  GTUIPageMainTableView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/12.
//

#import <UIKit/UIKit.h>

@protocol GTUIPageMainTableViewGestureDelegate <NSObject>

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

@interface GTUIPageMainTableView : UITableView

@property (nonatomic, weak) id<GTUIPageMainTableViewGestureDelegate> gestureDelegate;

@end
