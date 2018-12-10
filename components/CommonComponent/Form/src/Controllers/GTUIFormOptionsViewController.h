//
//  GTUIFormOptionsViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//
#import "GTUIFormRowDescriptorViewController.h"
#import "GTUIFormRowDescriptor.h"

@interface GTUIFormOptionsViewController : UITableViewController <GTUIFormRowDescriptorViewController>

- (instancetype)initWithStyle:(UITableViewStyle)style;


- (instancetype)initWithStyle:(UITableViewStyle)style
           titleHeaderSection:(NSString *)titleHeaderSection
           titleFooterSection:(NSString *)titleFooterSection;

@end
