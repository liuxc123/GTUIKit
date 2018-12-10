//
//  GTUIFormDatePickerCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormDatePickerCell.h"
#import "UIView+GTUIFormAdditions.h"


@implementation GTUIFormDatePickerCell

@synthesize datePicker = _datePicker;
@synthesize inlineRowDescriptor = _inlineRowDescriptor;

- (BOOL)canResignFirstResponder
{
    return YES;
}

#pragma mark - Properties

- (UIDatePicker *)datePicker
{
    if (_datePicker) return _datePicker;
    _datePicker = [UIDatePicker autolayoutView];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _datePicker;
}

#pragma mark- Target Action

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    if (self.inlineRowDescriptor){
        self.inlineRowDescriptor.value = sender.date;
        [self.formViewController updateFormRow:self.inlineRowDescriptor];
    }
    else{
        [self becomeFirstResponder];
        self.rowDescriptor.value = sender.date;
    }
}

#pragma mark - XLFormDescriptorCell

- (void)configure
{
    [super configure];
    [self.contentView addSubview:self.datePicker];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.datePicker attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[datePicker]-0-|" options:0 metrics:0 views:@{@"datePicker" : self.datePicker}]];
}

- (void)update
{
    [super update];
    [self.datePicker setUserInteractionEnabled:![self.rowDescriptor isDisabled]];
}


+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(GTUIFormRowDescriptor *)rowDescriptor
{
    return 216.0f;
}


@end
