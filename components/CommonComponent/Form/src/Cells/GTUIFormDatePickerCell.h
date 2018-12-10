//
//  GTUIFormDatePickerCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIForm.h"
#import "GTUIFormBaseCell.h"

#import <UIKit/UIKit.h>

@interface GTUIFormDatePickerCell : GTUIFormBaseCell <GTUIFormInlineRowDescriptorCell>

@property (nonatomic, readonly) UIDatePicker * datePicker;

@end
