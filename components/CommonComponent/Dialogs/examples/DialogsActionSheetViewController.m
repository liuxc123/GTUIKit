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

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{


        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        customView.backgroundColor = [UIColor blueColor];

        GTUIDialogConfigModel *configModel = [[GTUIDialogConfigModel alloc] initWithStyle:GTUIDialogStyleNormal];
        GTUIActionSheetController *actionSheet = [GTUIActionSheetController actionSheetControllerWithTitle:nil message:nil customView:customView config:configModel];

//        [actionSheet addDefaultActionWithTitle:@"确定" block:^{
//
//        }];

        [actionSheet addCancelActionWithTitle:@"取消" block:^{

        }];

        [self presentViewController:actionSheet animated:YES completion:nil];

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
