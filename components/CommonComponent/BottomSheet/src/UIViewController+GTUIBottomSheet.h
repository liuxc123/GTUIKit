//
//  UIViewController+GTUIBottomSheet.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import <UIKit/UIKit.h>

@class GTUIBottomSheetPresentationController;

/**
 Material Dialog UIViewController Category
 */
@interface UIViewController (GTUIBottomSheet)

/**
 The Material bottom sheet presentation controller that is managing the current view controller.

 @return nil if the view controller is not managed by a Material bottom sheet presentation
 controller.
 */
@property(nonatomic, nullable, readonly)
GTUIBottomSheetPresentationController *gtui_bottomSheetPresentationController;

@end
