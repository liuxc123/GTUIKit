//
//  DialogsActionSheetViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/28.
//

#import "DialogsActionSheetViewController.h"
#import "GTDialogs.h"
#import "GTToast.h"

@interface DialogsActionSheetViewController ()

@end

@implementation DialogsActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

       [GTUIToast presentToastWithIn:weakSelf.view text:@"视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图视图"];

//        [GTUIToast presentToastWithin:weakSelf.view withIcon:GTUIToastIconSuccess text:nil];

//        [GTUIToast presentToastWithin:weakSelf.view withIcon:GTUIToastIconAlert text:nil];

        [GTUIToast presentToastWithin:weakSelf.view withIcon:GTUIToastIconLoading text:nil];


        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [GTUIToast dismissAllToastWithView:weakSelf.view];
        });


//        [GTUIToast presentToastWithin:weakSelf.view withIcon:GTUIToastIconSecurityScan text:nil];



//        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        customView.backgroundColor = [UIColor blueColor];
//
//
//        GTUIDialogConfigModel *configModel = [[GTUIDialogConfigModel alloc] initWithStyle:GTUIDialogStyleNormal];
//        GTUIActionSheetController *actionSheet = [GTUIActionSheetController actionSheetControllerWithTitle:nil message:nil customView:nil config:configModel];
//
//        for (int i = 0; i < 20; i++) {
//            [actionSheet addDefaultActionWithTitle:@"确定" block:^{
//
//            }];
//        }
//
//        [actionSheet addDefaultActionWithTitle:@"确定" block:^{
//
//        }];
//
//        [actionSheet addCancelActionWithTitle:@"取消" block:^{
//
//        }];
//
//        [actionSheet addDestructiveActionWithTitle:@"销毁" block:^{
//
//        }];
//
//        [self presentViewController:actionSheet animated:YES completion:nil];

    });


    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"标题" message:@"内容" preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [actionSheet addAction:cancel];
        [self presentViewController:actionSheet animated:YES completion:nil];
    });
*/
}


+ (NSDictionary *)catalogMetadata {
    return @{
             @"breadcrumbs": @[ @"Dialogs", @"ActionSheetController" ],
             @"primaryDemo": @NO,
             @"presentable": @YES,
             };
}

@end
