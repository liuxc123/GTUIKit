//
//  GTUIFormSelectorCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIForm.h"
#import "NSObject+GTUIFormAdditions.h"
#import "GTUIFormRowDescriptor.h"
#import "GTUIFormSelectorCell.h"
#import "NSArray+GTUIFormAdditions.h"

@interface GTUIFormSelectorCell() <UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate>

@property (nonatomic) UIPickerView * pickerView;

@end

@implementation GTUIFormSelectorCell
{
    UIColor * _beforeChangeColor;
}

- (NSString *)valueDisplayText
{
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelectorPopover]) {
        if (!self.rowDescriptor.value || [self.rowDescriptor.value count] == 0) {
            return self.rowDescriptor.noValueDisplayText;
        }
        if (self.rowDescriptor.valueTransformer) {
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
    return self.rowDescriptor.displayTextValue;
}

- (UIView *)inputView
{
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPickerView]){
        return self.pickerView;
    }
    return [super inputView];
}

- (BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.isDisabled && ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPickerView]));
}

- (BOOL)formDescriptorCellBecomeFirstResponder
{
    return  [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPickerView]){
        return YES;
    }
    return [super canBecomeFirstResponder];
}

#pragma mark - Properties

- (UIPickerView *)pickerView
{
    if (_pickerView) return _pickerView;
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView selectRow:[self selectedIndex] inComponent:0 animated:NO];
    return _pickerView;
}


#pragma mark - GTUIFormDescriptorCell

-(void)configure
{
    [super configure];
}

-(void)update
{
    [super update];
    self.accessoryType = self.rowDescriptor.isDisabled || !([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPush] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelector]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;;
    self.editingAccessoryType = self.accessoryType;
    self.selectionStyle = self.rowDescriptor.isDisabled || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeInfo] ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    self.textLabel.text = [NSString stringWithFormat:@"%@%@", self.rowDescriptor.title, self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle ? @"*" : @""];
    self.detailTextLabel.text = [self valueDisplayText];
}

-(void)formDescriptorCellDidSelectedWithFormController:(GTUIFormViewController *)controller
{
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPush] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPopover]){
        UIViewController * controllerToPresent = nil;
        if (self.rowDescriptor.action.formSegueIdentifier){
            [controller performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdentifier sender:self.rowDescriptor];
        }
        else if (self.rowDescriptor.action.formSegueClass){
            UIViewController * controllerToPresent = [self controllerToPresent];
            NSAssert(controllerToPresent, @"either rowDescriptor.action.viewControllerClass or rowDescriptor.action.viewControllerStoryboardId or rowDescriptor.action.viewControllerNibName must be assigned");
            NSAssert([controllerToPresent conformsToProtocol:@protocol(GTUIFormRowDescriptorViewController)], @"selector view controller must conform to GTUIFormRowDescriptorViewController protocol");
            UIStoryboardSegue * segue = [[self.rowDescriptor.action.formSegueClass alloc] initWithIdentifier:self.rowDescriptor.tag source:controller destination:controllerToPresent];
            [controller prepareForSegue:segue sender:self.rowDescriptor];
            [segue perform];
        }
        else if ((controllerToPresent = [self controllerToPresent])){
            NSAssert([controllerToPresent conformsToProtocol:@protocol(GTUIFormRowDescriptorViewController)], @"rowDescriptor.action.viewControllerClass must conform to GTUIFormRowDescriptorViewController protocol");
            UIViewController<GTUIFormRowDescriptorViewController> *selectorViewController = (UIViewController<GTUIFormRowDescriptorViewController> *)controllerToPresent;
            selectorViewController.rowDescriptor = self.rowDescriptor;
            selectorViewController.title = self.rowDescriptor.selectorTitle;

            if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPopover]) {
                UIViewController *popoverController = self.formViewController.presentedViewController;
                if (popoverController && popoverController.modalPresentationStyle == UIModalPresentationPopover) {
                    [self.formViewController dismissViewControllerAnimated:NO completion:nil];
                }
                selectorViewController.modalPresentationStyle = UIModalPresentationPopover;

                selectorViewController.popoverPresentationController.delegate = self;
                if (self.detailTextLabel.window){
                    selectorViewController.popoverPresentationController.sourceRect = CGRectMake(0, 0, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
                    selectorViewController.popoverPresentationController.sourceView = self.detailTextLabel;
                    selectorViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
                } else {
                    selectorViewController.popoverPresentationController.sourceRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                    selectorViewController.popoverPresentationController.sourceView = self;
                    selectorViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
                }

                [self.formViewController presentViewController:selectorViewController
                                                      animated:YES
                                                    completion:nil];
                [controller.tableView deselectRowAtIndexPath:[controller.tableView indexPathForCell:self]
                                                    animated:YES];
            }
            else {
                [controller.navigationController pushViewController:selectorViewController animated:YES];
            }
        }
        else if (self.rowDescriptor.selectorOptions){
            GTUIFormOptionsViewController * optionsViewController = [[GTUIFormOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped titleHeaderSection:nil titleFooterSection:nil];
            optionsViewController.rowDescriptor = self.rowDescriptor;
            optionsViewController.title = self.rowDescriptor.selectorTitle;

            if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPopover]) {
                optionsViewController.modalPresentationStyle = UIModalPresentationPopover;

                optionsViewController.popoverPresentationController.delegate = self;
                if (self.detailTextLabel.window){
                    optionsViewController.popoverPresentationController.sourceRect = CGRectMake(0, 0, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
                    optionsViewController.popoverPresentationController.sourceView = self.detailTextLabel;
                    optionsViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
                } else {
                    optionsViewController.popoverPresentationController.sourceRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                    optionsViewController.popoverPresentationController.sourceView = self;
                    optionsViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
                }

                [self.formViewController presentViewController:optionsViewController
                                                      animated:YES
                                                    completion:nil];
                [controller.tableView deselectRowAtIndexPath:[controller.tableView indexPathForCell:self]
                                                    animated:YES];
            } else {
                [controller.navigationController pushViewController:optionsViewController animated:YES];
            }
        }
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelectorPopover])
    {
        NSAssert(self.rowDescriptor.selectorOptions, @"selectorOptions property shopuld not be nil");
        UIViewController * controllerToPresent = nil;
        GTUIFormOptionsViewController * optionsViewController = nil;
        if ((controllerToPresent = [self controllerToPresent])){
            optionsViewController = (GTUIFormOptionsViewController *)controllerToPresent;
        } else {
            optionsViewController = [[GTUIFormOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped titleHeaderSection:nil titleFooterSection:nil];
        }
        optionsViewController.rowDescriptor = self.rowDescriptor;
        optionsViewController.title = self.rowDescriptor.selectorTitle;

        if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelectorPopover]) {
            optionsViewController.modalPresentationStyle = UIModalPresentationPopover;

            optionsViewController.popoverPresentationController.delegate = self;
            if (self.detailTextLabel.window){
                optionsViewController.popoverPresentationController.sourceRect = CGRectMake(0, 0, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
                optionsViewController.popoverPresentationController.sourceView = self.detailTextLabel;
                optionsViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            } else {
                optionsViewController.popoverPresentationController.sourceRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                optionsViewController.popoverPresentationController.sourceView = self;
                optionsViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            }

            [self.formViewController presentViewController:optionsViewController
                                                  animated:YES
                                                completion:nil];
            [controller.tableView deselectRowAtIndexPath:[controller.tableView indexPathForCell:self] animated:YES];
        } else {
            [controller.navigationController pushViewController:optionsViewController animated:YES];
        }
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorActionSheet]){
        GTUIFormViewController * formViewController = self.formViewController;
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        alertController.popoverPresentationController.sourceView = formViewController.tableView;
        UIView* v = (self.detailTextLabel ?: self.textLabel) ?: self.contentView;
        alertController.popoverPresentationController.sourceRect = [formViewController.tableView convertRect:v.frame fromView:self];
        __weak __typeof(self)weakSelf = self;
        for (id option in self.rowDescriptor.selectorOptions) {
            NSString *optionTitle = [option displayText];
            if (self.rowDescriptor.valueTransformer){
                NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
                NSString * transformedValue = [valueTransformer transformedValue:[option valueData]];
                if (transformedValue) {
                    optionTitle = transformedValue;
                }
            }
            [alertController addAction:[UIAlertAction actionWithTitle:optionTitle
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [weakSelf.rowDescriptor setValue:option];
                                                                  [formViewController.tableView reloadData];
                                                              }]];
        }
        [formViewController presentViewController:alertController animated:YES completion:nil];
        [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorAlertView]){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        __weak __typeof(self)weakSelf = self;
        for (id option in self.rowDescriptor.selectorOptions) {
            [alertController addAction:[UIAlertAction actionWithTitle:[option displayText]
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [weakSelf.rowDescriptor setValue:option];
                                                                  [weakSelf.formViewController.tableView reloadData];
                                                              }]];
        }
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        [controller presentViewController:alertController animated:YES completion:nil];
        [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPickerView]){
        [controller.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)highlight
{
    [super highlight];
    _beforeChangeColor = self.detailTextLabel.textColor;
    self.detailTextLabel.textColor = self.tintColor;
}

-(void)unhighlight
{
    [super unhighlight];
    self.detailTextLabel.textColor = _beforeChangeColor;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
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
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPickerView]){
        self.rowDescriptor.value = [self.rowDescriptor.selectorOptions objectAtIndex:row];
        self.detailTextLabel.text = [self valueDisplayText];
        [self setNeedsLayout];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.rowDescriptor.selectorOptions.count;
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    [self.formViewController.tableView reloadData];
}

#pragma mark - Helpers

-(NSInteger)selectedIndex
{
    if (self.rowDescriptor.value){
        for (id option in self.rowDescriptor.selectorOptions){
            if ([[option valueData] isEqual:[self.rowDescriptor.value valueData]]){
                return [self.rowDescriptor.selectorOptions indexOfObject:option];
            }
        }
    }
    return -1;
}

-(UIViewController *)controllerToPresent
{
    if (self.rowDescriptor.action.viewControllerClass){
        return [[self.rowDescriptor.action.viewControllerClass alloc] init];
    }
    else if ([self.rowDescriptor.action.viewControllerStoryboardId length] != 0){
        UIStoryboard * storyboard =  [self storyboardToPresent];
        NSAssert(storyboard != nil, @"You must provide a storyboard when rowDescriptor.action.viewControllerStoryboardId is used");
        return [storyboard instantiateViewControllerWithIdentifier:self.rowDescriptor.action.viewControllerStoryboardId];
    }
    else if ([self.rowDescriptor.action.viewControllerNibName length] != 0){
        Class viewControllerClass = NSClassFromString(self.rowDescriptor.action.viewControllerNibName);
        NSAssert(viewControllerClass, @"class owner of self.rowDescriptor.action.viewControllerNibName must be equal to %@", self.rowDescriptor.action.viewControllerNibName);
        return [[viewControllerClass alloc] initWithNibName:self.rowDescriptor.action.viewControllerNibName bundle:nil];
    }
    return nil;
}

-(UIStoryboard *)storyboardToPresent
{
    if ([self.formViewController respondsToSelector:@selector(storyboardForRow:)]){
        return [self.formViewController storyboardForRow:self.rowDescriptor];
    }
    if (self.formViewController.storyboard){
        return self.formViewController.storyboard;
    }
    return nil;
}


@end
