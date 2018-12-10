//
//  GTUIFormCheckCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormCheckCell.h"

@implementation GTUIFormCheckCell

#pragma mark - GTUIFormDescriptorCell

- (void)configure
{
    [super configure];
    self.accessoryType = UITableViewCellAccessoryCheckmark;
    self.editingAccessoryType = self.accessoryType;
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.accessoryType = [self.rowDescriptor.value boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    self.editingAccessoryType =  self.accessoryType;
    CGFloat red, green, blue, alpha;
    [self.tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (self.rowDescriptor.isDisabled){
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.3]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else{
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:1]];
    }
}

- (void)formDescriptorCellDidSelectedWithFormController:(GTUIFormViewController *)controller
{
    self.rowDescriptor.value = [NSNumber numberWithBool:![self.rowDescriptor.value boolValue]];
    [self.formViewController updateFormRow:self.rowDescriptor];
    [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
}


@end
