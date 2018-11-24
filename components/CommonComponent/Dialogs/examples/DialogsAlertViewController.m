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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self didTapShowAlert];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapShowAlert {

    NSString *titleString = @"Using Material alert controller?";
    NSString *messageString = @"Be careful with modal alerts as they can be annoying if over-used.";

    GTUIAlertController *materialAlertController =
    [GTUIAlertController alertControllerWithTitle:titleString message:messageString];
    materialAlertController.titleAlignment = NSTextAlignmentCenter;
    materialAlertController.messageAlignment = NSTextAlignmentCenter;
    materialAlertController.cornerRadius = 10;
//    [self themeAlertController:materialAlertController];

    GTUIAlertAction *agreeAaction = [GTUIAlertAction actionWithTitle:@"AGREE"
                                                           handler:^(GTUIAlertAction *action) {
                                                               NSLog(@"%@", @"AGREE pressed");
                                                           }];
    [materialAlertController addAction:agreeAaction];

    GTUIAlertAction *disagreeAaction = [GTUIAlertAction actionWithTitle:@"DISAGREE"
                                                              handler:^(GTUIAlertAction *action) {
                                                                  NSLog(@"%@", @"DISAGREE pressed");
                                                              }];
    [materialAlertController addAction:disagreeAaction];
    
//    GTUIAlertAction *disagreeAaction1 = [GTUIAlertAction actionWithTitle:@"DISAGREE"
//                                                                handler:^(GTUIAlertAction *action) {
//                                                                    NSLog(@"%@", @"DISAGREE1 pressed");
//                                                                }];
//    [materialAlertController addAction:disagreeAaction1];
//
//    GTUIAlertAction *disagreeAaction2 = [GTUIAlertAction actionWithTitle:@"DISAGREE"
//                                                                 handler:^(GTUIAlertAction *action) {
//                                                                     NSLog(@"%@", @"DISAGREE2 pressed");
//                                                                 }];
//    [materialAlertController addAction:disagreeAaction2];

    [self presentViewController:materialAlertController animated:YES completion:NULL];
}

+ (NSDictionary *)catalogMetadata {
    return @{
             @"breadcrumbs": @[ @"Dialogs", @"AlertController" ],
             @"primaryDemo": @NO,
             @"presentable": @YES,
             };
}

@end
