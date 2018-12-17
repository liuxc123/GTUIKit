//
//  GTUIFormViewController.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTUIFormViewController.h"
#import "../GTUIForm.h"
#import "../Helpers/NSObject+GTUIFormAdditions.h"
#import "../Helpers/UIView+GTUIFormAdditions.h"
#import "../Helpers/NSString+GTUIFormAdditions.h"

@interface GTUIFormRowDescriptor(_GTUIFormViewController)

@property (readonly) NSArray * observers;
-(BOOL)evaluateIsDisabled;
-(BOOL)evaluateIsHidden;

@end

@interface GTUIFormSectionDescriptor(_GTUIFormViewController)

-(BOOL)evaluateIsHidden;

@end

@interface GTUIFormDescriptor (_GTUIFormViewController)

@property NSMutableDictionary* rowObservers;

@end


@interface GTUIFormViewController()
{
    NSNumber *_oldBottomTableContentInset;
    CGRect _keyboardFrame;
}
@property UITableViewStyle tableViewStyle;
@property (nonatomic) GTUIFormRowNavigationAccessoryView * navigationAccessoryView;

@end

@implementation GTUIFormViewController

@synthesize form = _form;

#pragma mark - Initialization

-(instancetype)initWithForm:(GTUIFormDescriptor *)form
{
    return [self initWithForm:form style:UITableViewStyleGrouped];
}

-(instancetype)initWithForm:(GTUIFormDescriptor *)form style:(UITableViewStyle)style
{
    self = [self initWithNibName:nil bundle:nil];
    if (self){
        _tableViewStyle = style;
        _form = form;
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        _form = nil;
        _tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _form = nil;
        _tableViewStyle = UITableViewStyleGrouped;
    }

    return self;
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.tableView){
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                      style:self.tableViewStyle];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if([self.tableView respondsToSelector:@selector(cellLayoutMarginsFollowReadableWidth)]){
            if (@available(iOS 9.0, *)) {
                self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
            }
        }
    }
    if (!self.tableView.superview){
        [self.view addSubview:self.tableView];
    }
    if (!self.tableView.delegate){
        self.tableView.delegate = self;
    }
    if (!self.tableView.dataSource){
        self.tableView.dataSource = self;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
    }
    if (self.form.title){
        self.title = self.form.title;
    }
    [self.tableView setEditing:YES animated:NO];
    self.tableView.allowsSelectionDuringEditing = YES;
    self.form.delegate = self;
    _oldBottomTableContentInset = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected){
        // Trigger a cell refresh
        GTUIFormRowDescriptor * rowDescriptor = [self.form formRowAtIndex:selected];
        [self updateFormRow:rowDescriptor];
        [self.tableView selectRowAtIndexPath:selected animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.tableView deselectRowAtIndexPath:selected animated:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.form.assignFirstResponderOnShow) {
        self.form.assignFirstResponderOnShow = NO;
        [self.form setFirstResponder:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - CellClasses

+(NSMutableDictionary *)cellClassesForRowDescriptorTypes
{
    static NSMutableDictionary * _cellClassesForRowDescriptorTypes;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellClassesForRowDescriptorTypes = [@{
                                               GTUIFormRowDescriptorTypeText:[GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypeName: [GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypePhone:[GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypeURL:[GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypeEmail: [GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypeTwitter: [GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypeAccount: [GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypePassword: [GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypeNumber: [GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypeInteger: [GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypeDecimal: [GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypeZipCode: [GTUIFormTextFieldCell class],
                                               GTUIFormRowDescriptorTypeSelectorPush: [GTUIFormSelectorCell class],
                                               GTUIFormRowDescriptorTypeSelectorPopover: [GTUIFormSelectorCell class],
                                               GTUIFormRowDescriptorTypeSelectorActionSheet: [GTUIFormSelectorCell class],
                                               GTUIFormRowDescriptorTypeSelectorAlertView: [GTUIFormSelectorCell class],
                                               GTUIFormRowDescriptorTypeSelectorPickerView: [GTUIFormSelectorCell class],
                                               GTUIFormRowDescriptorTypeSelectorPickerViewInline: [GTUIFormInlineSelectorCell class],
                                               GTUIFormRowDescriptorTypeSelectorSegmentedControl: [GTUIFormSegmentedCell class],
                                               GTUIFormRowDescriptorTypeMultipleSelector: [GTUIFormSelectorCell class],
                                               GTUIFormRowDescriptorTypeMultipleSelectorPopover: [GTUIFormSelectorCell class],
                                               GTUIFormRowDescriptorTypeImage: [GTUIFormImageCell class],
                                               GTUIFormRowDescriptorTypeTextView: [GTUIFormTextViewCell class],
                                               GTUIFormRowDescriptorTypeButton: [GTUIFormButtonCell class],
                                               GTUIFormRowDescriptorTypeInfo: [GTUIFormSelectorCell class],
                                               GTUIFormRowDescriptorTypeBooleanSwitch : [GTUIFormSwitchCell class],
                                               GTUIFormRowDescriptorTypeBooleanCheck : [GTUIFormCheckCell class],
                                               GTUIFormRowDescriptorTypeDate: [GTUIFormDateCell class],
                                               GTUIFormRowDescriptorTypeTime: [GTUIFormDateCell class],
                                               GTUIFormRowDescriptorTypeDateTime : [GTUIFormDateCell class],
                                               GTUIFormRowDescriptorTypeCountDownTimer : [GTUIFormDateCell class],
                                               GTUIFormRowDescriptorTypeDateInline: [GTUIFormDateCell class],
                                               GTUIFormRowDescriptorTypeTimeInline: [GTUIFormDateCell class],
                                               GTUIFormRowDescriptorTypeDateTimeInline: [GTUIFormDateCell class],
                                               GTUIFormRowDescriptorTypeCountDownTimerInline : [GTUIFormDateCell class],
                                               GTUIFormRowDescriptorTypeDatePicker : [GTUIFormDatePickerCell class],
                                               GTUIFormRowDescriptorTypePicker : [GTUIFormPickerCell class],
                                               GTUIFormRowDescriptorTypeSlider : [GTUIFormSliderCell class],
                                               GTUIFormRowDescriptorTypeSelectorLeftRight : [GTUIFormLeftRightSelectorCell class],
                                               GTUIFormRowDescriptorTypeStepCounter: [GTUIFormStepCounterCell class],
                                               GTUIFormRowDescriptorTypeCountDownCode: [GTUIFormCodeCell class]
                                               } mutableCopy];
    });
    return _cellClassesForRowDescriptorTypes;
}

#pragma mark - inlineRowDescriptorTypes

+(NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes
{
    static NSMutableDictionary * _inlineRowDescriptorTypesForRowDescriptorTypes;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inlineRowDescriptorTypesForRowDescriptorTypes = [
                                                          @{GTUIFormRowDescriptorTypeSelectorPickerViewInline: GTUIFormRowDescriptorTypePicker,
                                                            GTUIFormRowDescriptorTypeDateInline: GTUIFormRowDescriptorTypeDatePicker,
                                                            GTUIFormRowDescriptorTypeDateTimeInline: GTUIFormRowDescriptorTypeDatePicker,
                                                            GTUIFormRowDescriptorTypeTimeInline: GTUIFormRowDescriptorTypeDatePicker,
                                                            GTUIFormRowDescriptorTypeCountDownTimerInline: GTUIFormRowDescriptorTypeDatePicker
                                                            } mutableCopy];
    });
    return _inlineRowDescriptorTypesForRowDescriptorTypes;
}

#pragma mark - GTUIFormDescriptorDelegate

-(void)formRowHasBeenAdded:(GTUIFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:[self insertRowAnimationForRow:formRow]];
    [self.tableView endUpdates];
}

-(void)formRowHasBeenRemoved:(GTUIFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:[self deleteRowAnimationForRow:formRow]];
    [self.tableView endUpdates];
}

-(void)formSectionHasBeenRemoved:(GTUIFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:[self deleteRowAnimationForSection:formSection]];
    [self.tableView endUpdates];
}

-(void)formSectionHasBeenAdded:(GTUIFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:[self insertRowAnimationForSection:formSection]];
    [self.tableView endUpdates];
}

-(void)formRowDescriptorValueHasChanged:(GTUIFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    [self updateAfterDependentRowChanged:formRow];
}

-(void)formRowDescriptorPredicateHasChanged:(GTUIFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue predicateType:(GTCPredicateType)predicateType
{
    if (oldValue != newValue) {
        [self updateAfterDependentRowChanged:formRow];
    }
}

-(void)updateAfterDependentRowChanged:(GTUIFormRowDescriptor *)formRow
{
    NSMutableArray* revaluateHidden   = self.form.rowObservers[[formRow.tag formKeyForPredicateType:GTCPredicateTypeHidden]];
    NSMutableArray* revaluateDisabled = self.form.rowObservers[[formRow.tag formKeyForPredicateType:GTCPredicateTypeDisabled]];
    for (id object in revaluateDisabled) {
        if ([object isKindOfClass:[NSString class]]) {
            GTUIFormRowDescriptor* row = [self.form formRowWithTag:object];
            if (row){
                [row evaluateIsDisabled];
                [self updateFormRow:row];
            }
        }
    }
    for (id object in revaluateHidden) {
        if ([object isKindOfClass:[NSString class]]) {
            GTUIFormRowDescriptor* row = [self.form formRowWithTag:object];
            if (row){
                [row evaluateIsHidden];
            }
        }
        else if ([object isKindOfClass:[GTUIFormSectionDescriptor class]]) {
            GTUIFormSectionDescriptor* section = (GTUIFormSectionDescriptor*) object;
            [section evaluateIsHidden];
        }
    }
}

#pragma mark - GTUIFormViewControllerDelegate

-(NSDictionary *)formValues
{
    return [self.form formValues];
}

-(NSDictionary *)httpParameters
{
    return [self.form httpParameters:self];
}


-(void)didSelectFormRow:(GTUIFormRowDescriptor *)formRow
{
    if ([[formRow cellForFormController:self] respondsToSelector:@selector(formDescriptorCellDidSelectedWithFormController:)]){
        [[formRow cellForFormController:self] formDescriptorCellDidSelectedWithFormController:self];
    }
}

-(UITableViewRowAnimation)insertRowAnimationForRow:(GTUIFormRowDescriptor *)formRow
{
    if (formRow.sectionDescriptor.sectionOptions & GTUIFormSectionOptionCanInsert){
        if (formRow.sectionDescriptor.sectionInsertMode == GTUIFormSectionInsertModeButton){
            return UITableViewRowAnimationAutomatic;
        }
        else if (formRow.sectionDescriptor.sectionInsertMode == GTUIFormSectionInsertModeLastRow){
            return YES;
        }
    }
    return UITableViewRowAnimationFade;
}

-(UITableViewRowAnimation)deleteRowAnimationForRow:(GTUIFormRowDescriptor *)formRow
{
    return UITableViewRowAnimationFade;
}

-(UITableViewRowAnimation)insertRowAnimationForSection:(GTUIFormSectionDescriptor *)formSection
{
    return UITableViewRowAnimationAutomatic;
}

-(UITableViewRowAnimation)deleteRowAnimationForSection:(GTUIFormSectionDescriptor *)formSection
{
    return UITableViewRowAnimationAutomatic;
}

-(UIView *)inputAccessoryViewForRowDescriptor:(GTUIFormRowDescriptor *)rowDescriptor
{
    if ((self.form.rowNavigationOptions & GTUIFormRowNavigationOptionEnabled) != GTUIFormRowNavigationOptionEnabled){
        return nil;
    }
    if ([[[[self class] inlineRowDescriptorTypesForRowDescriptorTypes] allKeys] containsObject:rowDescriptor.rowType]) {
        return nil;
    }
    UITableViewCell<GTUIFormDescriptorCell> * cell = (UITableViewCell<GTUIFormDescriptorCell> *)[rowDescriptor cellForFormController:self];
    if (![cell formDescriptorCellCanBecomeFirstResponder]){
        return nil;
    }
    GTUIFormRowDescriptor * previousRow = [self nextRowDescriptorForRow:rowDescriptor
                                                        withDirection:GTUIFormRowNavigationDirectionPrevious];
    GTUIFormRowDescriptor * nextRow     = [self nextRowDescriptorForRow:rowDescriptor
                                                        withDirection:GTUIFormRowNavigationDirectionNext];
    [self.navigationAccessoryView.previousButton setEnabled:(previousRow != nil)];
    [self.navigationAccessoryView.nextButton setEnabled:(nextRow != nil)];
    return self.navigationAccessoryView;
}

-(void)beginEditing:(GTUIFormRowDescriptor *)rowDescriptor
{
    [[rowDescriptor cellForFormController:self] highlight];
}

-(void)endEditing:(GTUIFormRowDescriptor *)rowDescriptor
{
    [[rowDescriptor cellForFormController:self] unhighlight];
}

-(GTUIFormRowDescriptor *)formRowFormMultivaluedFormSection:(GTUIFormSectionDescriptor *)formSection
{
    if (formSection.multivaluedRowTemplate){
        return [formSection.multivaluedRowTemplate copy];
    }
    GTUIFormRowDescriptor * formRowDescriptor = [[formSection.formRows objectAtIndex:0] copy];
    formRowDescriptor.tag = nil;
    return formRowDescriptor;
}

-(void)multivaluedInsertButtonTapped:(GTUIFormRowDescriptor *)formRow
{
    [self deselectFormRow:formRow];
    GTUIFormSectionDescriptor * multivaluedFormSection = formRow.sectionDescriptor;
    GTUIFormRowDescriptor * formRowDescriptor = [self formRowFormMultivaluedFormSection:multivaluedFormSection];
    [multivaluedFormSection addFormRow:formRowDescriptor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.editing = !self.tableView.editing;
        self.tableView.editing = !self.tableView.editing;
    });
    UITableViewCell<GTUIFormDescriptorCell> * cell = (UITableViewCell<GTUIFormDescriptorCell> *)[formRowDescriptor cellForFormController:self];
    if ([cell formDescriptorCellCanBecomeFirstResponder]){
        [cell formDescriptorCellBecomeFirstResponder];
    }
}

-(void)ensureRowIsVisible:(GTUIFormRowDescriptor *)inlineRowDescriptor
{
    GTUIFormBaseCell * inlineCell = [inlineRowDescriptor cellForFormController:self];
    NSIndexPath * indexOfOutOfWindowCell = [self.form indexPathOfFormRow:inlineRowDescriptor];
    if(!inlineCell.window || (self.tableView.contentOffset.y + self.tableView.frame.size.height <= inlineCell.frame.origin.y + inlineCell.frame.size.height)){
        [self.tableView scrollToRowAtIndexPath:indexOfOutOfWindowCell atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Methods

-(NSArray *)formValidationErrors
{
    return [self.form localValidationErrors:self];
}

-(void)showFormValidationError:(NSError *)error
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GTUIFormViewController_ValidationErrorTitle", nil)
                                                                              message:error.localizedDescription
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showFormValidationError:(NSError *)error withTitle:(NSString*)title
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, nil)
                                                                              message:error.localizedDescription
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)performFormSelector:(SEL)selector withObject:(id)sender
{
    UIResponder * responder = [self targetForAction:selector withSender:sender];;
    if (responder) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
        [responder performSelector:selector withObject:sender];
#pragma GCC diagnostic pop
    }
}

+ (UIView *)createHeaderOrFooterViewWithTitle:(NSString *)title {
    if ([title isEqualToString:@""] || title == nil) {
        return nil;
    }
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor grayColor];
    label.text = title;
    label.numberOfLines = 0;
    label.frame = (CGRect){{15.0f, 8}, [title gtc_sizeWithFont:label.font maxWidth:[UIScreen mainScreen].bounds.size.width - 30 maxHeight:CGFLOAT_MAX]};
    [view addSubview:label];
    view.frame = CGRectMake(0, 0, 0, CGRectGetHeight(label.frame));
    return view;
}

#pragma mark - Private

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    UIView * firstResponderView = [self.tableView findFirstResponder];
    UITableViewCell<GTUIFormDescriptorCell> * cell = [firstResponderView formDescriptorCell];
    if (cell){
        NSDictionary *keyboardInfo = [notification userInfo];
        _keyboardFrame = [self.tableView.window convertRect:[keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] toView:self.tableView.superview];
        CGFloat newBottomInset = self.tableView.frame.origin.y + self.tableView.frame.size.height - _keyboardFrame.origin.y;
        UIEdgeInsets tableContentInset = self.tableView.contentInset;
        UIEdgeInsets tableScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
        _oldBottomTableContentInset = _oldBottomTableContentInset ?: @(tableContentInset.bottom);
        if (newBottomInset > [_oldBottomTableContentInset floatValue]){
            tableContentInset.bottom = newBottomInset;
            tableScrollIndicatorInsets.bottom = tableContentInset.bottom;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
            [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
            self.tableView.contentInset = tableContentInset;
            self.tableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
            NSIndexPath *selectedRow = [self.tableView indexPathForCell:cell];
            [self.tableView scrollToRowAtIndexPath:selectedRow atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [UIView commitAnimations];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIView * firstResponderView = [self.tableView findFirstResponder];
    UITableViewCell<GTUIFormDescriptorCell> * cell = [firstResponderView formDescriptorCell];
    if (cell){
        _keyboardFrame = CGRectZero;
        NSDictionary *keyboardInfo = [notification userInfo];
        UIEdgeInsets tableContentInset = self.tableView.contentInset;
        UIEdgeInsets tableScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
        tableContentInset.bottom = [_oldBottomTableContentInset floatValue];
        tableScrollIndicatorInsets.bottom = tableContentInset.bottom;
        _oldBottomTableContentInset = nil;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
        self.tableView.contentInset = tableContentInset;
        self.tableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
        [UIView commitAnimations];
    }
}

#pragma mark - Helpers

-(void)deselectFormRow:(GTUIFormRowDescriptor *)formRow
{
    NSIndexPath * indexPath = [self.form indexPathOfFormRow:formRow];
    if (indexPath){
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)reloadFormRow:(GTUIFormRowDescriptor *)formRow
{
    NSIndexPath * indexPath = [self.form indexPathOfFormRow:formRow];
    if (indexPath){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(GTUIFormBaseCell *)updateFormRow:(GTUIFormRowDescriptor *)formRow
{
    GTUIFormBaseCell * cell = [formRow cellForFormController:self];
    [self configureCell:cell];
    [cell setNeedsUpdateConstraints];
    [cell setNeedsLayout];
    return cell;
}

-(void)configureCell:(GTUIFormBaseCell*) cell
{
    [cell update];
    [cell.rowDescriptor.cellConfig enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL * __unused stop) {
        [cell setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
    }];
    if (cell.rowDescriptor.isDisabled){
        [cell.rowDescriptor.cellConfigIfDisabled enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL * __unused stop) {
            [cell setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
        }];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.form.formSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= self.form.formSections.count){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"" userInfo:nil];
    }
    return [[[self.form.formSections objectAtIndex:section] formRows] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTUIFormRowDescriptor * rowDescriptor = [self.form formRowAtIndex:indexPath];
    [self updateFormRow:rowDescriptor];
    return [rowDescriptor cellForFormController:self];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTUIFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
    if (rowDescriptor.isDisabled || !rowDescriptor.sectionDescriptor.isMultivaluedSection){
        return NO;
    }
    GTUIFormBaseCell * baseCell = [rowDescriptor cellForFormController:self];
    if ([baseCell conformsToProtocol:@protocol(GTUIFormInlineRowDescriptorCell)] && ((id<GTUIFormInlineRowDescriptorCell>)baseCell).inlineRowDescriptor){
        return NO;
    }
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    GTUIFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
    GTUIFormSectionDescriptor * section = rowDescriptor.sectionDescriptor;
    if (section.sectionOptions & GTUIFormSectionOptionCanReorder && section.formRows.count > 1) {
        if (section.sectionInsertMode == GTUIFormSectionInsertModeButton && section.sectionOptions & GTUIFormSectionOptionCanInsert){
            if (section.formRows.count <= 2 || rowDescriptor == section.multivaluedAddButton){
                return NO;
            }
        }
        GTUIFormBaseCell * baseCell = [rowDescriptor cellForFormController:self];
        return !([baseCell conformsToProtocol:@protocol(GTUIFormInlineRowDescriptorCell)] && ((id<GTUIFormInlineRowDescriptorCell>)baseCell).inlineRowDescriptor);
    }
    return NO;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    GTUIFormRowDescriptor * row = [self.form formRowAtIndex:sourceIndexPath];
    GTUIFormSectionDescriptor * section = row.sectionDescriptor;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    [section performSelector:NSSelectorFromString(@"moveRowAtIndexPath:toIndexPath:") withObject:sourceIndexPath withObject:destinationIndexPath];
#pragma GCC diagnostic pop
    // update the accessory view
    [self inputAccessoryViewForRowDescriptor:row];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.editing = !self.tableView.editing;
        self.tableView.editing = !self.tableView.editing;
    });

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        GTUIFormRowDescriptor * multivaluedFormRow = [self.form formRowAtIndex:indexPath];
        // end editing
        UIView * firstResponder = [[multivaluedFormRow cellForFormController:self] findFirstResponder];
        if (firstResponder){
            [self.tableView endEditing:YES];
        }
        [multivaluedFormRow.sectionDescriptor removeFormRowAtIndex:indexPath.row];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.editing = !self.tableView.editing;
            self.tableView.editing = !self.tableView.editing;
        });
        if (firstResponder){
            UITableViewCell<GTUIFormDescriptorCell> * firstResponderCell = [firstResponder formDescriptorCell];
            GTUIFormRowDescriptor * rowDescriptor = firstResponderCell.rowDescriptor;
            [self inputAccessoryViewForRowDescriptor:rowDescriptor];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert){

        GTUIFormSectionDescriptor * multivaluedFormSection = [self.form formSectionAtIndex:indexPath.section];
        if (multivaluedFormSection.sectionInsertMode == GTUIFormSectionInsertModeButton && multivaluedFormSection.sectionOptions & GTUIFormSectionOptionCanInsert){
            [self multivaluedInsertButtonTapped:multivaluedFormSection.multivaluedAddButton];
        }
        else{
            GTUIFormRowDescriptor * formRowDescriptor = [self formRowFormMultivaluedFormSection:multivaluedFormSection];
            [multivaluedFormSection addFormRow:formRowDescriptor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tableView.editing = !self.tableView.editing;
                self.tableView.editing = !self.tableView.editing;
            });
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            UITableViewCell<GTUIFormDescriptorCell> * cell = (UITableViewCell<GTUIFormDescriptorCell> *)[formRowDescriptor cellForFormController:self];
            if ([cell formDescriptorCellCanBecomeFirstResponder]){
                [cell formDescriptorCellBecomeFirstResponder];
            }
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [[self.form.formSections objectAtIndex:section] headerHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [[self.form.formSections objectAtIndex:section] footerHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GTUIFormSectionDescriptor *sectionDescriptor = (GTUIFormSectionDescriptor *)[self.form.formSections objectAtIndex:section];
    if (sectionDescriptor.customHeaderView) {
        return sectionDescriptor.customHeaderView;
    }
    NSString *title = [sectionDescriptor title];
    return [GTUIFormViewController createHeaderOrFooterViewWithTitle:title];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GTUIFormSectionDescriptor *sectionDescriptor = (GTUIFormSectionDescriptor *)[self.form.formSections objectAtIndex:section];
    if (sectionDescriptor.customFooterView) {
        return sectionDescriptor.customFooterView;
    }
    NSString *title = [sectionDescriptor footerTitle];
    return [GTUIFormViewController createHeaderOrFooterViewWithTitle:title];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTUIFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
    [rowDescriptor cellForFormController:self];
    CGFloat height = rowDescriptor.height;
    if (height != GTUIFormUnspecifiedCellHeight){
        return height;
    }
    return self.tableView.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTUIFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
    [rowDescriptor cellForFormController:self];
    CGFloat height = rowDescriptor.height;
    if (height != GTUIFormUnspecifiedCellHeight){
        return height;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        return self.tableView.estimatedRowHeight;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTUIFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
    if (row.isDisabled) {
        return;
    }
    UITableViewCell<GTUIFormDescriptorCell> * cell = (UITableViewCell<GTUIFormDescriptorCell> *)[row cellForFormController:self];
    if (!([cell formDescriptorCellCanBecomeFirstResponder] && [cell formDescriptorCellBecomeFirstResponder])){
        [self.tableView endEditing:YES];
    }
    [self didSelectFormRow:row];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTUIFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
    GTUIFormSectionDescriptor * section = row.sectionDescriptor;
    if (section.sectionOptions & GTUIFormSectionOptionCanInsert){
        if (section.formRows.count == indexPath.row + 2){
            if ([[GTUIFormViewController inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:row.rowType]){
                UITableViewCell<GTUIFormDescriptorCell> * cell = [row cellForFormController:self];
                UIView * firstResponder = [cell findFirstResponder];
                if (firstResponder){
                    return UITableViewCellEditingStyleInsert;
                }
            }
        }
        else if (section.formRows.count == (indexPath.row + 1)){
            return UITableViewCellEditingStyleInsert;
        }
    }
    if (section.sectionOptions & GTUIFormSectionOptionCanDelete){
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return sourceIndexPath;
    }
    GTUIFormSectionDescriptor * sectionDescriptor = [self.form formSectionAtIndex:sourceIndexPath.section];
    GTUIFormRowDescriptor * proposedDestination = [sectionDescriptor.formRows objectAtIndex:proposedDestinationIndexPath.row];
    GTUIFormBaseCell * proposedDestinationCell = [proposedDestination cellForFormController:self];
    if (([proposedDestinationCell conformsToProtocol:@protocol(GTUIFormInlineRowDescriptorCell)] && ((id<GTUIFormInlineRowDescriptorCell>)proposedDestinationCell).inlineRowDescriptor) || ([[GTUIFormViewController inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:proposedDestinationCell.rowDescriptor.rowType] && [[proposedDestinationCell findFirstResponder] formDescriptorCell] == proposedDestinationCell)) {
        if (sourceIndexPath.row < proposedDestinationIndexPath.row){
            return [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row + 1 inSection:sourceIndexPath.section];
        }
        else{
            return [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row - 1 inSection:sourceIndexPath.section];
        }
    }

    if ((sectionDescriptor.sectionInsertMode == GTUIFormSectionInsertModeButton && sectionDescriptor.sectionOptions & GTUIFormSectionOptionCanInsert)){
        if (proposedDestinationIndexPath.row == sectionDescriptor.formRows.count - 1){
            return [NSIndexPath indexPathForRow:(sectionDescriptor.formRows.count - 2) inSection:sourceIndexPath.section];
        }
    }
    return proposedDestinationIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle editingStyle = [self tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleNone){
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // end editing if inline cell is first responder
    UITableViewCell<GTUIFormDescriptorCell> * cell = [[self.tableView findFirstResponder] formDescriptorCell];
    if ([[self.form indexPathOfFormRow:cell.rowDescriptor] isEqual:indexPath]){
        if ([[GTUIFormViewController inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:cell.rowDescriptor.rowType]){
            [self.tableView endEditing:YES];
        }
    }
}

#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // called when 'return' key pressed. return NO to ignore.
    UITableViewCell<GTUIFormDescriptorCell> * cell = [textField formDescriptorCell];
    GTUIFormRowDescriptor * currentRow = cell.rowDescriptor;
    GTUIFormRowDescriptor * nextRow = [self nextRowDescriptorForRow:currentRow
                                                    withDirection:GTUIFormRowNavigationDirectionNext];
    if (nextRow){
        UITableViewCell<GTUIFormDescriptorCell> * nextCell = (UITableViewCell<GTUIFormDescriptorCell> *)[nextRow cellForFormController:self];
        if ([nextCell formDescriptorCellCanBecomeFirstResponder]){
            [nextCell formDescriptorCellBecomeFirstResponder];
            return YES;
        }
    }
    [self.tableView endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITableViewCell<GTUIFormDescriptorCell>* cell = textField.formDescriptorCell;
    GTUIFormRowDescriptor * nextRow     = [self nextRowDescriptorForRow:textField.formDescriptorCell.rowDescriptor
                                                        withDirection:GTUIFormRowNavigationDirectionNext];


    if ([cell conformsToProtocol:@protocol(GTUIFormReturnKeyProtocol)]) {
        textField.returnKeyType = nextRow ? ((id<GTUIFormReturnKeyProtocol>)cell).nextReturnKeyType : ((id<GTUIFormReturnKeyProtocol>)cell).returnKeyType;
    }
    else {
        textField.returnKeyType = nextRow ? UIReturnKeyNext : UIReturnKeyDefault;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //dismiss keyboard
    if (NO == self.form.endEditingTableViewOnScroll) {
        return;
    }

    UIView * firstResponder = [self.tableView findFirstResponder];
    if ([firstResponder conformsToProtocol:@protocol(GTUIFormDescriptorCell)]){
        id<GTUIFormDescriptorCell> cell = (id<GTUIFormDescriptorCell>)firstResponder;
        if ([[GTUIFormViewController inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:cell.rowDescriptor.rowType]){
            return;
        }
    }
    [self.tableView endEditing:YES];
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[GTUIFormRowDescriptor class]]){
        UIViewController * destinationViewController = segue.destinationViewController;
        GTUIFormRowDescriptor * rowDescriptor = (GTUIFormRowDescriptor *)sender;
        if (rowDescriptor.rowType == GTUIFormRowDescriptorTypeSelectorPush || rowDescriptor.rowType == GTUIFormRowDescriptorTypeSelectorPopover){
            NSAssert([destinationViewController conformsToProtocol:@protocol(GTUIFormRowDescriptorViewController)], @"Segue destinationViewController must conform to GTUIFormRowDescriptorViewController protocol");
            UIViewController<GTUIFormRowDescriptorViewController> * rowDescriptorViewController = (UIViewController<GTUIFormRowDescriptorViewController> *)destinationViewController;
            rowDescriptorViewController.rowDescriptor = rowDescriptor;
        }
        else if ([destinationViewController conformsToProtocol:@protocol(GTUIFormRowDescriptorViewController)]){
            UIViewController<GTUIFormRowDescriptorViewController> * rowDescriptorViewController = (UIViewController<GTUIFormRowDescriptorViewController> *)destinationViewController;
            rowDescriptorViewController.rowDescriptor = rowDescriptor;
        }
    }
}

#pragma mark - Navigation Between Fields


-(void)rowNavigationAction:(UIBarButtonItem *)sender
{
    [self navigateToDirection:(sender == self.navigationAccessoryView.nextButton ? GTUIFormRowNavigationDirectionNext : GTUIFormRowNavigationDirectionPrevious)];
}

-(void)rowNavigationDone:(UIBarButtonItem *)sender
{
    [self.tableView endEditing:YES];
}

-(void)navigateToDirection:(GTUIFormRowNavigationDirection)direction
{
    UIView * firstResponder = [self.tableView findFirstResponder];
    UITableViewCell<GTUIFormDescriptorCell> * currentCell = [firstResponder formDescriptorCell];
    NSIndexPath * currentIndexPath = [self.tableView indexPathForCell:currentCell];
    GTUIFormRowDescriptor * currentRow = [self.form formRowAtIndex:currentIndexPath];
    GTUIFormRowDescriptor * nextRow = [self nextRowDescriptorForRow:currentRow withDirection:direction];
    if (nextRow) {
        UITableViewCell<GTUIFormDescriptorCell> * cell = (UITableViewCell<GTUIFormDescriptorCell> *)[nextRow cellForFormController:self];
        if ([cell formDescriptorCellCanBecomeFirstResponder]){
            NSIndexPath * indexPath = [self.form indexPathOfFormRow:nextRow];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [cell formDescriptorCellBecomeFirstResponder];
        }
    }
}

-(GTUIFormRowDescriptor *)nextRowDescriptorForRow:(GTUIFormRowDescriptor*)currentRow withDirection:(GTUIFormRowNavigationDirection)direction
{
    if (!currentRow || (self.form.rowNavigationOptions & GTUIFormRowNavigationOptionEnabled) != GTUIFormRowNavigationOptionEnabled) {
        return nil;
    }
    GTUIFormRowDescriptor * nextRow = (direction == GTUIFormRowNavigationDirectionNext) ? [self.form nextRowDescriptorForRow:currentRow] : [self.form previousRowDescriptorForRow:currentRow];
    if (!nextRow) {
        return nil;
    }
    if ([[nextRow cellForFormController:self] conformsToProtocol:@protocol(GTUIFormInlineRowDescriptorCell)]) {
        id<GTUIFormInlineRowDescriptorCell> inlineCell = (id<GTUIFormInlineRowDescriptorCell>)[nextRow cellForFormController:self];
        if (inlineCell.inlineRowDescriptor){
            return [self nextRowDescriptorForRow:nextRow withDirection:direction];
        }
    }
    GTUIFormRowNavigationOptions rowNavigationOptions = self.form.rowNavigationOptions;
    if (nextRow.isDisabled && ((rowNavigationOptions & GTUIFormRowNavigationOptionStopDisableRow) == GTUIFormRowNavigationOptionStopDisableRow)){
        return nil;
    }
    if (!nextRow.isDisabled && ((rowNavigationOptions & GTUIFormRowNavigationOptionStopInlineRow) == GTUIFormRowNavigationOptionStopInlineRow) && [[[GTUIFormViewController inlineRowDescriptorTypesForRowDescriptorTypes] allKeys] containsObject:nextRow.rowType]){
        return nil;
    }
    UITableViewCell<GTUIFormDescriptorCell> * cell = (UITableViewCell<GTUIFormDescriptorCell> *)[nextRow cellForFormController:self];
    if (!nextRow.isDisabled && ((rowNavigationOptions & GTUIFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow) != GTUIFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow) && (![cell formDescriptorCellCanBecomeFirstResponder])){
        return nil;
    }
    if (!nextRow.isDisabled && [cell formDescriptorCellCanBecomeFirstResponder]){
        return nextRow;
    }
    return [self nextRowDescriptorForRow:nextRow withDirection:direction];
}

#pragma mark - properties

-(void)setForm:(GTUIFormDescriptor *)form
{
    _form.delegate = nil;
    [self.tableView endEditing:YES];
    _form = form;
    _form.delegate = self;
    [_form forceEvaluate];
    if ([self isViewLoaded]){
        [self.tableView reloadData];
    }
}

-(GTUIFormDescriptor *)form
{
    return _form;
}

-(GTUIFormRowNavigationAccessoryView *)navigationAccessoryView
{
    if (_navigationAccessoryView) return _navigationAccessoryView;
    _navigationAccessoryView = [GTUIFormRowNavigationAccessoryView new];
    _navigationAccessoryView.previousButton.target = self;
    _navigationAccessoryView.previousButton.action = @selector(rowNavigationAction:);
    _navigationAccessoryView.nextButton.target = self;
    _navigationAccessoryView.nextButton.action = @selector(rowNavigationAction:);
    _navigationAccessoryView.doneButton.target = self;
    _navigationAccessoryView.doneButton.action = @selector(rowNavigationDone:);
    _navigationAccessoryView.tintColor = self.view.tintColor;
    return _navigationAccessoryView;
}

@end

