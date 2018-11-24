//
//  UIViewController+GTUIDialogs.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import "UIViewController+GTUIDialogs.h"

#import "GTUIDialogPresentationController.h"

@implementation UIViewController (GTUIDialogs)

- (GTUIDialogPresentationController *)gtui_dialogPresentationController {
    id presentationController = self.presentationController;
    if ([presentationController isKindOfClass:[GTUIDialogPresentationController class]]) {
        return (GTUIDialogPresentationController *)presentationController;
    }

    return nil;
}

@end
