//
//  PickerViewViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "PickerViewViewController.h"
#import "GTPickerView.h"

@interface PickerViewViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) NSArray  *titleArray;

@end

@implementation PickerViewViewController


- (NSArray*)titleArray
{
    return @[@"GTUIPickerView", @"GTUIDatePickerView", @"GTUIAddressPickerView"];
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
            [GTUIPickerView showStringPickerWithTitle:@"标题" dataSource: @[@"男", @"女", @"未知"] defaultSelValue:@"未知" resultBlock:^(id selectValue, NSInteger index) {
                NSLog(@"%@  index: %li", selectValue, (long)index);
            }];
            break;

        case 1:
            [GTUIDatePickerView showDatePickerWithTitle:@"标题" dateType:GTUIDatePickerModeYMDHM defaultSelValue:nil resultBlock:^(NSString *selectValue) {
                NSLog(@"%@", selectValue);

            }];
            break;

        case 2:
            [GTUIAddressPickerView showAddressPickerWithDefaultSelected:nil resuleBlock:^(GTProvinceModel *province, GTCityModel *city, GTAreaModel *area) {
                NSLog(@"province:%@ city:%@ area:%@", province.name, city.name, area.name);
            }];

            break;
        default:
            break;
    }
}


+ (NSDictionary *)catalogMetadata {
    return @{
             @"breadcrumbs": @[ @"PickerView"],
             @"primaryDemo": @NO,
             @"presentable": @YES,
             };
}

@end
