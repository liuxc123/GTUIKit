//
//  GTUIDialogTransitionController.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import <UIKit/UIKit.h>

/**
 GTUIDialogTransitionController is be used to setup a custom transition and animationed presentation
 and dismissal for material-styled alerts, simple dialogs and confirmation dialogs.

 https://material.io/go/design-dialogs

 This class provides a basic implementation of UIViewControllerAnimatedTransitioning and
 UIViewControllerTransitioningDelegate.

 In order to use a custom modal transition, the UIViewController to be presented must set two
 properties. The UIViewControllers transitioningDelegate should be set to an instance of this class.
 myDialogViewController.modalPresentationStyle = UIModalPresentationCustom;
 myDialogViewController.transitioningDelegate = dialogTransitionController;

 The presenting UIViewController then calls presentViewController:animated:completion:
 [rootViewController presentViewController:myDialogViewController animated:YES completion:...];
 */
@interface GTUIDialogTransitionController : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@end
