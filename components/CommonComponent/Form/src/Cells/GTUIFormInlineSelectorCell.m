//
//  GTUIFormInlineSelectorCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIForm.h"
#import "GTUIFormInlineSelectorCell.h"

@interface GTUIFormInlineSelectorCell()

@end

@implementation GTUIFormInlineSelectorCell
{
    UIColor * _beforeChangeColor;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)becomeFirstResponder
{
    if (self.isFirstResponder){
        return [super becomeFirstResponder];
    }
    _beforeChangeColor = self.detailTextLabel.textColor;
    BOOL result = [super becomeFirstResponder];
    if (result){
        GTUIFormRowDescriptor * inlineRowDescriptor = [GTUIFormRowDescriptor formRowDescriptorWithTag:nil rowType:[GTUIFormViewController inlineRowDescriptorTypesForRowDescriptorTypes][self.rowDescriptor.rowType]];
        UITableViewCell<GTUIFormDescriptorCell> * cell = [inlineRowDescriptor cellForFormController:self.formViewController];
        NSAssert([cell conformsToProtocol:@protocol(GTUIFormInlineRowDescriptorCell)], @"inline cell must conform to GTUIFormInlineRowDescriptorCell");
        UITableViewCell<GTUIFormInlineRowDescriptorCell> * inlineCell = (UITableViewCell<GTUIFormInlineRowDescriptorCell> *)cell;
        inlineCell.inlineRowDescriptor = self.rowDescriptor;
        [self.rowDescriptor.sectionDescriptor addFormRow:inlineRowDescriptor afterRow:self.rowDescriptor];
        [self.formViewController ensureRowIsVisible:inlineRowDescriptor];
    }
    return result;
}

-(BOOL)resignFirstResponder
{
    if (![self isFirstResponder]) {
        return [super resignFirstResponder];
    }
    NSIndexPath * selectedRowPath = [self.formViewController.form indexPathOfFormRow:self.rowDescriptor];
    NSIndexPath * nextRowPath = [NSIndexPath indexPathForRow:selectedRowPath.row + 1 inSection:selectedRowPath.section];
    GTUIFormRowDescriptor * nextFormRow = [self.formViewController.form formRowAtIndex:nextRowPath];
    GTUIFormSectionDescriptor * formSection = [self.formViewController.form.formSections objectAtIndex:nextRowPath.section];
    BOOL result = [super resignFirstResponder];
    if (result) {
        [formSection removeFormRow:nextFormRow];
    }
    return result;
}


#pragma mark - GTUIFormDescriptorCell

-(void)configure
{
    [super configure];
}

-(void)update
{
    [super update];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.editingAccessoryType = UITableViewCellAccessoryNone;
    [self.textLabel setText:self.rowDescriptor.title];
    self.selectionStyle = self.rowDescriptor.isDisabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    self.textLabel.text = [NSString stringWithFormat:@"%@%@", self.rowDescriptor.title, self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle ? @"*" : @""];
    self.detailTextLabel.text = [self valueDisplayText];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return !(self.rowDescriptor.isDisabled);
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{

    if ([self isFirstResponder]){
        [self resignFirstResponder];
        return NO;
    }
    return [self becomeFirstResponder];
}

-(void)formDescriptorCellDidSelectedWithFormController:(GTUIFormViewController *)controller
{
    [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
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

#pragma mark - Helpers

-(NSString *)valueDisplayText
{
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelectorPopover]){
        if (!self.rowDescriptor.value || [self.rowDescriptor.value count] == 0){
            return self.rowDescriptor.noValueDisplayText;
        }
        if (self.rowDescriptor.valueTransformer){
            NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
            NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
            NSString * tranformedValue = [valueTransformer transformedValue:self.rowDescriptor.value];
            if (tranformedValue){
                return tranformedValue;
            }
        }
        NSMutableArray * descriptionArray = [NSMutableArray arrayWithCapacity:[self.rowDescriptor.value count]];
        for (id option in self.rowDescriptor.selectorOptions) {
            NSArray * selectedValues = self.rowDescriptor.value;
            if ([selectedValues formIndexForItem:option] != NSNotFound){
                if (self.rowDescriptor.valueTransformer){
                    NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                    NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
                    NSString * tranformedValue = [valueTransformer transformedValue:option];
                    if (tranformedValue){
                        [descriptionArray addObject:tranformedValue];
                    }
                }
                else{
                    [descriptionArray addObject:[option displayText]];
                }
            }
        }
        return [descriptionArray componentsJoinedByString:@", "];
    }
    if (!self.rowDescriptor.value){
        return self.rowDescriptor.noValueDisplayText;
    }
    if (self.rowDescriptor.valueTransformer){
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
        NSString * tranformedValue = [valueTransformer transformedValue:self.rowDescriptor.value];
        if (tranformedValue){
            return tranformedValue;
        }
    }
    return [self.rowDescriptor.value displayText];
}


@end
