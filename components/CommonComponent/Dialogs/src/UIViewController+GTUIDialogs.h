//
//  UIViewController+GTUIDialogs.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import <UIKit/UIKit.h>

@class GTUIDialogPresentationController;

@interface UIViewController (GTUIDialogs)

/**
 The dialog presentation controller that is managing the current view controller.

 @return nil if the view controller is not managed by a Material dialog presentaiton controller.
 */
@property(nonatomic, nullable, readonly) GTUIDialogPresentationController *gtui_dialogPresentationController;

@end
