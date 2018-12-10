//
//  GTUIFormPickerCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormPickerCell.h"
#import "UIView+GTUIFormAdditions.h"

@interface GTUIFormPickerCell() <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation GTUIFormPickerCell


@synthesize pickerView = _pickerView;
@synthesize inlineRowDescriptor = _inlineRowDescriptor;

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.isDisabled && (self.inlineRowDescriptor == nil));
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self becomeFirstResponder];
}


-(BOOL)canResignFirstResponder
{
    return YES;
}

-(BOOL)canBecomeFirstResponder
{
    return [self formDescriptorCellCanBecomeFirstResponder];
}

#pragma mark - Properties

-(UIPickerView *)pickerView
{
    if (_pickerView) return _pickerView;
    _pickerView = [UIPickerView autolayoutView];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    return _pickerView;
}

#pragma mark - GTUIFormDescriptorCell

-(void)configure
{
    [super configure];
    [self.contentView addSubview:self.pickerView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pickerView]-0-|" options:0 metrics:0 views:@{@"pickerView" : self.pickerView}]];
}

-(void)update
{
    [super update];
    BOOL isDisable = self.rowDescriptor.isDisabled;
    self.userInteractionEnabled = !isDisable;
    self.contentView.alpha = isDisable ? 0.5 : 1.0;
    [self.pickerView selectRow:[self selectedIndex] inComponent:0 animated:NO];
    [self.pickerView reloadAllComponents];

}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(GTUIFormRowDescriptor *)rowDescriptor
{
    return 216.0f;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.inlineRowDescriptor){
        if (self.inlineRowDescriptor.valueTransformer){
            NSAssert([self.inlineRowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
            NSValueTransformer * valueTransformer = [self.inlineRowDescriptor.valueTransformer new];
            NSString * tranformedValue = [valueTransformer transformedValue:[[self.inlineRowDescriptor.selectorOptions objectAtIndex:row] valueData]];
            if (tranformedValue){
                return tranformedValue;
            }
        }
        return [[self.inlineRowDescriptor.selectorOptions objectAtIndex:row] displayText];
    }

    if (self.rowDescriptor.valueTransformer){
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
        NSString * tranformedValue = [valueTransformer transformedValue:[[self.rowDescriptor.selectorOptions objectAtIndex:row] valueData]];
        if (tranformedValue){
            return tranformedValue;
        }
    }
    return [[self.rowDescriptor.selectorOptions objectAtIndex:row] displayText];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.inlineRowDescriptor){
        self.inlineRowDescriptor.value = [self.inlineRowDescriptor.selectorOptions objectAtIndex:row];
        [self.formViewController updateFormRow:self.inlineRowDescriptor];
    }
    else{
        [self becomeFirstResponder];
        self.rowDescriptor.value = [self.rowDescriptor.selectorOptions objectAtIndex:row];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.inlineRowDescriptor){
        return self.inlineRowDescriptor.selectorOptions.count;
    }
    return self.rowDescriptor.selectorOptions.count;
}

#pragma mark - helpers

-(NSInteger)selectedIndex
{
    GTUIFormRowDescriptor * formRow = self.inlineRowDescriptor ?: self.rowDescriptor;
    if (formRow.value){
        for (id option in formRow.selectorOptions){
            if ([[option valueData] isEqual:[formRow.value valueData]]){
                return [formRow.selectorOptions indexOfObject:option];
            }
        }
    }
    return -1;
}

@end
