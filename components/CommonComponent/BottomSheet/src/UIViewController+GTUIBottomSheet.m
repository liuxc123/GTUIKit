//
//  UIViewController+GTUIBottomSheet.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import "UIViewController+GTUIBottomSheet.h"

#import "GTUIBottomSheetPresentationController.h"

@implementation UIViewController (GTUIBottomSheet)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (GTUIBottomSheetPresentationController *)gtui_bottomSheetPresentationController {
    id presentationController = self.presentationController;
    if ([presentationController isKindOfClass:[GTUIBottomSheetPresentationController class]]) {
        return (GTUIBottomSheetPresentationController *)presentationController;
    }
#pragma clang diagnostic pop

    return nil;
}

@end
