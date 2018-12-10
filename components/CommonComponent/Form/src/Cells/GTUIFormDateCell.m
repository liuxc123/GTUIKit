//
//  GTUIFormDateCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormDateCell.h"
#import "GTUIForm.h"
#import "GTUIFormRowDescriptor.h"

@interface GTUIFormDateCell()

@property (nonatomic) UIDatePicker *datePicker;

@end


@implementation GTUIFormDateCell
{
    UIColor * _beforeChangeColor;
    NSDateFormatter *_dateFormatter;
}

- (UIView *)inputView
{
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDate] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeTime] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDateTime] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeCountDownTimer]){
        if (self.rowDescriptor.value){
            [self.datePicker setDate:self.rowDescriptor.value animated:[self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeCountDownTimer]];
        }
        [self setModeToDatePicker:self.datePicker];
        return self.datePicker;
    }
    return [super inputView];
}

- (BOOL)canBecomeFirstResponder
{
    return !self.rowDescriptor.isDisabled;
}

-(BOOL)becomeFirstResponder
{
    if (self.isFirstResponder){
        return [super becomeFirstResponder];
    }
    _beforeChangeColor = self.detailTextLabel.textColor;
    BOOL result = [super becomeFirstResponder];
    if (result){
        if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDateInline] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDateTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeCountDownTimerInline])
        {
            NSIndexPath * selectedRowPath = [self.formViewController.form indexPathOfFormRow:self.rowDescriptor];
            NSIndexPath * nextRowPath = [NSIndexPath indexPathForRow:(selectedRowPath.row + 1) inSection:selectedRowPath.section];
            GTUIFormSectionDescriptor * formSection = [self.formViewController.form.formSections objectAtIndex:nextRowPath.section];
            GTUIFormRowDescriptor * datePickerRowDescriptor = [GTUIFormRowDescriptor formRowDescriptorWithTag:nil rowType:GTUIFormRowDescriptorTypeDatePicker];
            GTUIFormDatePickerCell * datePickerCell = (GTUIFormDatePickerCell *)[datePickerRowDescriptor cellForFormController:self.formViewController];
            [self setModeToDatePicker:datePickerCell.datePicker];
            if (self.rowDescriptor.value){
                [datePickerCell.datePicker setDate:self.rowDescriptor.value animated:[self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeCountDownTimerInline]];
            }
            NSAssert([datePickerCell conformsToProtocol:@protocol(GTUIFormInlineRowDescriptorCell)], @"inline cell must conform to GTUIFormInlineRowDescriptorCell");
            UITableViewCell<GTUIFormInlineRowDescriptorCell> * inlineCell = (UITableViewCell<GTUIFormInlineRowDescriptorCell> *)datePickerCell;
            inlineCell.inlineRowDescriptor = self.rowDescriptor;

            [formSection addFormRow:datePickerRowDescriptor afterRow:self.rowDescriptor];
            [self.formViewController ensureRowIsVisible:datePickerRowDescriptor];
        }
    }
    return result;
}

- (BOOL)resignFirstResponder
{
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDateInline] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDateTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeCountDownTimerInline])
    {
        NSIndexPath * selectedRowPath = [self.formViewController.form indexPathOfFormRow:self.rowDescriptor];
        NSIndexPath * nextRowPath = [NSIndexPath indexPathForRow:selectedRowPath.row + 1 inSection:selectedRowPath.section];
        GTUIFormRowDescriptor * nextFormRow = [self.formViewController.form formRowAtIndex:nextRowPath];
        BOOL result = [super resignFirstResponder];
        if ([nextFormRow.rowType isEqualToString:GTUIFormRowDescriptorTypeDatePicker]){
            [self.rowDescriptor.sectionDescriptor removeFormRow:nextFormRow];
        }
        return result;
    }
    return [super resignFirstResponder];
}

#pragma mark - GTUIFormDescriptorCell

-(void)configure
{
    [super configure];
    self.formDatePickerMode = GTUIFormDateDatePickerModeGetFromRowDescriptor;
    _dateFormatter = [[NSDateFormatter alloc] init];
}

-(void)update
{
    [super update];
    self.accessoryType =  UITableViewCellAccessoryNone;
    self.editingAccessoryType =  UITableViewCellAccessoryNone;
    [self.textLabel setText:self.rowDescriptor.title];
    self.selectionStyle = self.rowDescriptor.isDisabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    self.textLabel.text = [NSString stringWithFormat:@"%@%@", self.rowDescriptor.title, self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle ? @"*" : @""];
    self.detailTextLabel.text = [self valueDisplayText];
}

-(void)formDescriptorCellDidSelectedWithFormController:(GTUIFormViewController *)controller
{
    [self.formViewController.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return [self canBecomeFirstResponder];
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    if ([self isFirstResponder]){
        return [self resignFirstResponder];
    }
    return [self becomeFirstResponder];

}

-(void)highlight
{
    [super highlight];
    self.detailTextLabel.textColor = self.tintColor;
}

-(void)unhighlight
{
    [super unhighlight];
    self.detailTextLabel.textColor = _beforeChangeColor;
}

#pragma mark - helpers

-(NSString *)valueDisplayText
{
    return self.rowDescriptor.value ? [self formattedDate:self.rowDescriptor.value] : self.rowDescriptor.noValueDisplayText;
}


- (NSString *)formattedDate:(NSDate *)date
{
    if (self.rowDescriptor.valueTransformer){
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
        NSString * tranformedValue = [valueTransformer transformedValue:self.rowDescriptor.value];
        if (tranformedValue){
            return tranformedValue;
        }
    }
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDate] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDateInline]){
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
        return [_dateFormatter stringFromDate:date];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeTime] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeTimeInline]){
        _dateFormatter.dateStyle = NSDateFormatterNoStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
        return [_dateFormatter stringFromDate:date];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeCountDownTimer] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeCountDownTimerInline]){
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDateComponents *time = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
        return [NSString stringWithFormat:@"%ld%@ %ldmin", (long)[time hour], (long)[time hour] == 1 ? @"hour" : @"hours", (long)[time minute]];
    }
    _dateFormatter.dateStyle = NSDateFormatterShortStyle;
    _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    return [_dateFormatter stringFromDate:date];
}

-(void)setModeToDatePicker:(UIDatePicker *)datePicker
{
    if ((([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDateInline] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDate]) && self.formDatePickerMode == GTUIFormDateDatePickerModeGetFromRowDescriptor) || self.formDatePickerMode == GTUIFormDateDatePickerModeDate){
        datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if ((([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeTime]) && self.formDatePickerMode == GTUIFormDateDatePickerModeGetFromRowDescriptor) || self.formDatePickerMode == GTUIFormDateDatePickerModeTime){
        datePicker.datePickerMode = UIDatePickerModeTime;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeCountDownTimer] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeCountDownTimerInline]){
        datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        datePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    else{
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }

    if (self.minuteInterval)
        datePicker.minuteInterval = self.minuteInterval;

    if (self.minimumDate)
        datePicker.minimumDate = self.minimumDate;

    if (self.maximumDate)
        datePicker.maximumDate = self.maximumDate;

    if (self.locale) {
        datePicker.locale = self.locale;
    }
}

#pragma mark - Properties

-(UIDatePicker *)datePicker
{
    if (_datePicker) return _datePicker;
    _datePicker = [[UIDatePicker alloc] init];
    [self setModeToDatePicker:_datePicker];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _datePicker;
}

-(void)setLocale:(NSLocale *)locale
{
    _locale = locale;
    _dateFormatter.locale = locale;
}

#pragma mark - Target Action

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    self.rowDescriptor.value = sender.date;
    [self.formViewController updateFormRow:self.rowDescriptor];
}

-(void)setFormDatePickerMode:(GTUIFormDateDatePickerMode)formDatePickerMode
{
    _formDatePickerMode = formDatePickerMode;
    if ([self isFirstResponder]){
        if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDateInline] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDateTimeInline] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeCountDownTimerInline])
        {
            NSIndexPath * selectedRowPath = [self.formViewController.form indexPathOfFormRow:self.rowDescriptor];
            NSIndexPath * nextRowPath = [NSIndexPath indexPathForRow:selectedRowPath.row + 1 inSection:selectedRowPath.section];
            GTUIFormRowDescriptor * nextFormRow = [self.formViewController.form formRowAtIndex:nextRowPath];
            if ([nextFormRow.rowType isEqualToString:GTUIFormRowDescriptorTypeDatePicker]){
                GTUIFormDatePickerCell * datePickerCell = (GTUIFormDatePickerCell *)[nextFormRow cellForFormController:self.formViewController];
                [self setModeToDatePicker:datePickerCell.datePicker];
            }
        }
    }
}


@end
