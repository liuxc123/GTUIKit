//
//  GTUIFormPickerCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIForm.h"
#import "GTUIFormBaseCell.h"

@interface GTUIFormPickerCell : GTUIFormBaseCell <GTUIFormInlineRowDescriptorCell>

@property (nonatomic) UIPickerView * pickerView;

@end
