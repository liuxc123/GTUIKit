//
//  DialogsAlertViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import "DialogsAlertViewController.h"
#import "GTDialogs.h"


@interface DialogsAlertViewController ()

@end

@implementation DialogsAlertViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        customView.backgroundColor = [UIColor blueColor];

        GTUIDialogConfigModel *configModel = [[GTUIDialogConfigModel alloc] initWithStyle:GTUIDialogStyleNormal];
        configModel.isQueue = YES;
        configModel.isContinueQueueDisplay = YES;
        configModel.queuePriority = 1;

        GTUIAlertController *alert = [GTUIAlertController alertControllerWithTitle:@"标题" message:@"内容" customView:customView config:configModel];
        [alert addDefaultActionWithTitle:@"确定" block:^{

        }];
        [alert addCancelActionWithTitle:@"取消" block:^{

        }];
        [alert show];

        GTUIDialogConfigModel *configModel1 = [[GTUIDialogConfigModel alloc] initWithStyle:GTUIDialogStyleNormal];
        configModel1.isQueue = YES;
        configModel1.isContinueQueueDisplay = YES;
        configModel.queuePriority = 2;
        GTUIAlertController *alert1 = [GTUIAlertController alertControllerWithTitle:@"标题" message:@"内容" customView:nil config:configModel1];
        [alert1 addDefaultActionWithTitle:@"确定" block:^{

        }];
        [alert1 addCancelActionWithTitle:@"取消" block:^{

        }];
        [alert1 show];

//        [alert addTextFieldWithBlock:^(UITextField *textField) {
//            textField.placeholder = @"占位符";
//        }];
//        for (int i = 0; i < 20; i++) {
//            [alert addDefaultActionWithTitle:@"确定" block:^{
//
//            }];
//        }


//        [alert addDestructiveActionWithTitle:@"销毁" block:^{
//
//        }];
//
//        [alert addDefaultActionWithTitle:@"确定1" block:^{
//
//        }];
//
//        [alert addDefaultActionWithTitle:@"确定1" block:^{
//
//        }];
//        [alert addDefaultActionWithTitle:@"确定1" block:^{
//
//        }];
//        [alert addDefaultActionWithTitle:@"确定1" block:^{
//
//        }];



    });
    


}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)didTapShowAlert {
//
//    NSString *titleString = @"Using Material alert controller?";
//    NSString *messageString = @"Be careful with modal alerts as they can be annoying if over-used.";
//
//    GTUIAlertController *materialAlertController =
//    [GTUIAlertController alertControllerWithTitle:titleString message:messageString];
//    materialAlertController.titleAlignment = NSTextAlignmentCenter;
//    materialAlertController.messageAlignment = NSTextAlignmentCenter;
//    materialAlertController.cornerRadius = 10;
////    [self themeAlertController:materialAlertController];
//
//    GTUIAlertAction *agreeAaction = [GTUIAlertAction actionWithTitle:@"AGREE"
//                                                           handler:^(GTUIAlertAction *action) {
//                                                               NSLog(@"%@", @"AGREE pressed");
//                                                           }];
//    [materialAlertController addAction:agreeAaction];
//
//    GTUIAlertAction *disagreeAaction = [GTUIAlertAction actionWithTitle:@"DISAGREE"
//                                                              handler:^(GTUIAlertAction *action) {
//                                                                  NSLog(@"%@", @"DISAGREE pressed");
//                                                              }];
//    [materialAlertController addAction:disagreeAaction];
//    
////    GTUIAlertAction *disagreeAaction1 = [GTUIAlertAction actionWithTitle:@"DISAGREE"
////                                                                handler:^(GTUIAlertAction *action) {
////                                                                    NSLog(@"%@", @"DISAGREE1 pressed");
////                                                                }];
////    [materialAlertController addAction:disagreeAaction1];
////
////    GTUIAlertAction *disagreeAaction2 = [GTUIAlertAction actionWithTitle:@"DISAGREE"
////                                                                 handler:^(GTUIAlertAction *action) {
////                                                                     NSLog(@"%@", @"DISAGREE2 pressed");
////                                                                 }];
////    [materialAlertController addAction:disagreeAaction2];
//
//    [self presentViewController:materialAlertController animated:YES completion:NULL];
//}
//
+ (NSDictionary *)catalogMetadata {
    return @{
             @"breadcrumbs": @[ @"Dialogs", @"AlertController" ],
             @"primaryDemo": @NO,
             @"presentable": @YES,
             };
}

@end
