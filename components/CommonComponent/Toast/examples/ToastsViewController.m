//
//  ToastsViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "ToastsViewController.h"
#import "GTToast.h"

@interface ToastsViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) NSArray  *titleArray;

@end

@implementation ToastsViewController

- (NSArray*)titleArray
{
    return @[@"文本信息 加载在Window上",@"view加载文本信息",@"loading加载",@"成功提示",@"失败提示",@"网络失败提示",@"安全扫描提示",@"网络错误，完全无法连接提示", @"警告提示", @"加载进度"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text =self.titleArray[indexPath.row];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [GTUIToast presentToastWithText:@"文本信息"];
            break;
        case 1:
            [GTUIToast presentModelToastWithin:self.view text:@"文本信息"];
            break;
        case 2:
            [GTUIToast presentModelToastWithin:self.view withIcon:GTUIToastIconLoading text:@"加载中"];
            break;
        case 3:
            [GTUIToast presentToastWithin:self.view withIcon:GTUIToastIconSuccess text:nil];
            break;
        case 4:
            [GTUIToast presentToastWithin:self.view withIcon:GTUIToastIconFailure text:nil];
            break;
        case 5:
            [GTUIToast presentToastWithin:self.view withIcon:GTUIToastIconNetFailure text:nil];
            break;
        case 6:
            [GTUIToast presentToastWithin:self.view withIcon:GTUIToastIconSecurityScan text:nil];
            break;
        case 7:
            [GTUIToast presentToastWithin:self.view withIcon:GTUIToastIconNetError text:nil];
            break;
        case 8:
            [GTUIToast presentToastWithin:self.view withIcon:GTUIToastIconAlert text:nil];
            break;
        case 9:


            break;
        default:
            break;
    }
    [self performSelector:@selector(dismiss:) withObject:nil afterDelay:2];
}



-(void)dismiss:(NSTimeInterval)time
{
    [GTUIToast dismissAllToast];
}



+ (NSDictionary *)catalogMetadata {
    return @{
             @"breadcrumbs": @[ @"Toast"],
             @"primaryDemo": @NO,
             @"presentable": @YES,
             };
}

@end
