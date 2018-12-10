//
//  GTUIFormOptionsViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTUIFormOptionsViewController.h"
#import "../GTUIForm.h"
#import "../Helpers/NSObject+GTUIFormAdditions.h"
#import "../Helpers/NSArray+GTUIFormAdditions.h"
#import "../views/GTUIFormRightDetailCell.h"

#define CELL_REUSE_IDENTIFIER  @"OptionCell"

@interface GTUIFormOptionsViewController () <UITableViewDataSource>

@property NSString * titleHeaderSection;
@property NSString * titleFooterSection;

@end

@implementation GTUIFormOptionsViewController

@synthesize titleHeaderSection = _titleHeaderSection;
@synthesize titleFooterSection = _titleFooterSection;
@synthesize rowDescriptor = _rowDescriptor;


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self){
        _titleFooterSection = nil;
        _titleHeaderSection = nil;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style titleHeaderSection:(NSString *)titleHeaderSection titleFooterSection:(NSString *)titleFooterSection
{
    self = [self initWithStyle:style];
    if (self){
        _titleFooterSection = titleFooterSection;
        _titleHeaderSection = titleHeaderSection;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // register option cell
    [self.tableView registerClass:[GTUIFormRightDetailCell class] forCellReuseIdentifier:CELL_REUSE_IDENTIFIER];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self selectorOptions] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTUIFormRightDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    id cellObject =  [[self selectorOptions] objectAtIndex:indexPath.row];

    [self.rowDescriptor.cellConfigForSelector enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, __unused BOOL *stop) {
        [cell setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
    }];

    cell.textLabel.text = [self valueDisplayTextForOption:cellObject];
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelectorPopover]){
        cell.accessoryType = ([self selectedValuesContainsOption:cellObject] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    }
    else{
        if ([[self.rowDescriptor.value valueData] isEqual:[cellObject valueData]]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return self.titleFooterSection;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.titleHeaderSection;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id cellObject =  [[self selectorOptions] objectAtIndex:indexPath.row];
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelectorPopover]){
        if ([self selectedValuesContainsOption:cellObject]){
            self.rowDescriptor.value = [self selectedValuesRemoveOption:cellObject];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else{
            self.rowDescriptor.value = [self selectedValuesAddOption:cellObject];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else{
        if ([[self.rowDescriptor.value valueData] isEqual:[cellObject valueData]]){
            if (!self.rowDescriptor.required){
                self.rowDescriptor.value = nil;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else{
            if (self.rowDescriptor.value){
                NSInteger index = [[self selectorOptions] formIndexForItem:self.rowDescriptor.value];
                if (index != NSNotFound){
                    NSIndexPath * oldSelectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    UITableViewCell *oldSelectedCell = [tableView cellForRowAtIndexPath:oldSelectedIndexPath];
                    oldSelectedCell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            self.rowDescriptor.value = cellObject;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if (self.modalPresentationStyle == UIModalPresentationPopover){
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        }
        else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helper

-(NSMutableArray *)selectedValues
{
    if (self.rowDescriptor.value == nil){
        return [NSMutableArray array];
    }
    NSAssert([self.rowDescriptor.value isKindOfClass:[NSArray class]], @"GTUIFormRowDescriptor value must be NSMutableArray");
    return [NSMutableArray arrayWithArray:self.rowDescriptor.value];
}

-(BOOL)selectedValuesContainsOption:(id)option
{
    return ([self.selectedValues formIndexForItem:option] != NSNotFound);
}

-(NSMutableArray *)selectedValuesRemoveOption:(id)option
{
    for (id selectedValueItem in self.selectedValues) {
        if ([[selectedValueItem valueData] isEqual:[option valueData]]){
            NSMutableArray * result = self.selectedValues;
            [result removeObject:selectedValueItem];
            return result;
        }
    }
    return self.selectedValues;
}

-(NSMutableArray *)selectedValuesAddOption:(id)option
{
    NSAssert([self.selectedValues formIndexForItem:option] == NSNotFound, @"GTUIFormRowDescriptor value must not contain the option");
    NSMutableArray * result = self.selectedValues;
    [result addObject:option];
    return result;
}



-(NSString *)valueDisplayTextForOption:(id)option
{
    if (self.rowDescriptor.valueTransformer){
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
        NSString * transformedValue = [valueTransformer transformedValue:option];
        if (transformedValue){
            return transformedValue;
        }
    }
    return [option displayText];
}

#pragma mark - Helpers

-(NSArray *)selectorOptions
{
    if (self.rowDescriptor.rowType == GTUIFormRowDescriptorTypeSelectorLeftRight){
        GTUIFormLeftRightSelectorOption * option = [self leftOptionForOption:self.rowDescriptor.leftRightSelectorLeftOptionSelected];
        return option.rightOptions;
    }
    else{
        return self.rowDescriptor.selectorOptions;
    }
}

-(GTUIFormLeftRightSelectorOption *)leftOptionForOption:(id)option
{
    return [[self.rowDescriptor.selectorOptions filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary * __unused bindings) {
        GTUIFormLeftRightSelectorOption * evaluatedLeftOption = (GTUIFormLeftRightSelectorOption *)evaluatedObject;
        return [evaluatedLeftOption.leftValue isEqual:option];
    }]] firstObject];
}


@end
