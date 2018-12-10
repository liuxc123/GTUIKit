//
//  GTUIFormSectionDescriptor.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "../GTUIForm.h"
#import "GTUIFormSectionDescriptor.h"
#import "../Helpers/NSPredicate+GTUIFormAdditions.h"
#import "../Helpers/NSString+GTUIFormAdditions.h"
#import "../Helpers/UIView+GTUIFormAdditions.h"

@interface GTUIFormDescriptor (_GTUIFormSectionDescriptor)

@property (readonly) NSDictionary* allRowsByTag;

-(void)addRowToTagCollection:(GTUIFormRowDescriptor*)rowDescriptor;
-(void)removeRowFromTagCollection:(GTUIFormRowDescriptor*) rowDescriptor;
-(void)showFormSection:(GTUIFormSectionDescriptor*)formSection;
-(void)hideFormSection:(GTUIFormSectionDescriptor*)formSection;

-(void)addObserversOfObject:(id)sectionOrRow predicateType:(GTCPredicateType)predicateType;
-(void)removeObserversOfObject:(id)sectionOrRow predicateType:(GTCPredicateType)predicateType;

@end

@interface GTUIFormSectionDescriptor()

@property NSMutableArray * formRows;
@property NSMutableArray * allRows;
@property BOOL isDirtyHidePredicateCache;
@property (nonatomic) NSNumber* hidePredicateCache;

@end

@implementation GTUIFormSectionDescriptor

@synthesize hidden = _hidden;
@synthesize hidePredicateCache = _hidePredicateCache;

-(instancetype)init
{
    self = [super init];
    if (self){
        _formRows = [NSMutableArray array];
        _allRows = [NSMutableArray array];
        _sectionInsertMode = GTUIFormSectionInsertModeLastRow;
        _sectionOptions = GTUIFormSectionOptionNone;
        _title = nil;
        _footerTitle = nil;
        _hidden = @NO;
        _hidePredicateCache = @NO;
        _isDirtyHidePredicateCache = YES;
        _headerHeight = UITableViewAutomaticDimension;
        _footerHeight = UITableViewAutomaticDimension;
        _cellTitleEqualWidth = YES;
        _cellTitleMaxWidth = 0;
        [self addObserver:self forKeyPath:@"formRows" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:0];
    }
    return self;
}



-(instancetype)initWithTitle:(NSString *)title sectionOptions:(GTUIFormSectionOptions)sectionOptions sectionInsertMode:(GTUIFormSectionInsertMode)sectionInsertMode{
    self = [self init];
    if (self){
        _sectionInsertMode = sectionInsertMode;
        _sectionOptions = sectionOptions;
        _title = title;
        _headerHeight = UITableViewAutomaticDimension;
        _footerHeight = UITableViewAutomaticDimension;
        if ([self canInsertUsingButton]){
            _multivaluedAddButton = [GTUIFormRowDescriptor formRowDescriptorWithTag:nil rowType:GTUIFormRowDescriptorTypeButton title:@"Add Item"];
            [_multivaluedAddButton.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
            _multivaluedAddButton.action.formSelector = NSSelectorFromString(@"multivaluedInsertButtonTapped:");
            [self insertObject:_multivaluedAddButton inFormRowsAtIndex:0];
            [self insertObject:_multivaluedAddButton inAllRowsAtIndex:0];
        }
    }
    return self;
}

+(instancetype)formSection
{
    return [[self class] formSectionWithTitle:nil];
}

+(instancetype)formSectionWithTitle:(NSString *)title
{
    return [[self class] formSectionWithTitle:title sectionOptions:GTUIFormSectionOptionNone];
}

+(instancetype)formSectionWithTitle:(NSString *)title sectionOptions:(GTUIFormSectionOptions)sectionOptions
{
    return [[self class] formSectionWithTitle:title sectionOptions:sectionOptions sectionInsertMode:GTUIFormSectionInsertModeLastRow];
}

+(instancetype)formSectionWithTitle:(NSString *)title sectionOptions:(GTUIFormSectionOptions)sectionOptions sectionInsertMode:(GTUIFormSectionInsertMode)sectionInsertMode
{
    return [[[self class] alloc] initWithTitle:title sectionOptions:sectionOptions sectionInsertMode:sectionInsertMode];
}

- (void)setHeaderHeight:(CGFloat)headerHeight {
    _headerHeight = headerHeight;

    if (headerHeight == 0) {
        _headerHeight = 0.1;
    }
}

- (void)setFooterHeight:(CGFloat)footerHeight {
    _footerHeight = footerHeight;

    if (footerHeight == 0) {
        _footerHeight = 0.1;
    }
}

- (CGFloat)cellTitleMaxWidth
{
    CGFloat maxTitleWidth = 0;
    for (GTUIFormRowDescriptor *rowDescriptor in self.allRows) {
        CGFloat rowWidth = [rowDescriptor.title gtc_sizeWithFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] maxWidth:[UIScreen mainScreen].bounds.size.width maxHeight:CGFLOAT_MAX].width;
        maxTitleWidth = MAX(maxTitleWidth, rowWidth);
    }
    return maxTitleWidth;
}

-(BOOL)isMultivaluedSection
{
    return (self.sectionOptions != GTUIFormSectionOptionNone);
}

-(void)addFormRow:(GTUIFormRowDescriptor *)formRow
{
    NSUInteger index;

    if ([self canInsertUsingButton]) {
        index = ([self.formRows count] > 0) ? [self.formRows count] - 1 : 0;
    } else {
        index = [self.allRows count];
    }

    [self insertObject:formRow inAllRowsAtIndex:index];
}

-(void)addFormRow:(GTUIFormRowDescriptor *)formRow afterRow:(GTUIFormRowDescriptor *)afterRow
{
    NSUInteger allRowIndex = [self.allRows indexOfObject:afterRow];
    if (allRowIndex != NSNotFound) {
        [self insertObject:formRow inAllRowsAtIndex:allRowIndex+1];
    }
    else { //case when afterRow does not exist. Just insert at the end.
        [self addFormRow:formRow];
        return;
    }
}

-(void)addFormRow:(GTUIFormRowDescriptor *)formRow beforeRow:(GTUIFormRowDescriptor *)beforeRow
{

    NSUInteger allRowIndex = [self.allRows indexOfObject:beforeRow];
    if (allRowIndex != NSNotFound) {
        [self insertObject:formRow inAllRowsAtIndex:allRowIndex];
    }
    else { //case when afterRow does not exist. Just insert at the end.
        [self addFormRow:formRow];
        return;
    }
}

-(void)removeFormRowAtIndex:(NSUInteger)index
{
    if (self.formRows.count > index){
        GTUIFormRowDescriptor *formRow = [self.formRows objectAtIndex:index];
        NSUInteger allRowIndex = [self.allRows indexOfObject:formRow];
        [self removeObjectFromFormRowsAtIndex:index];
        [self removeObjectFromAllRowsAtIndex:allRowIndex];
    }
}

-(void)removeFormRow:(GTUIFormRowDescriptor *)formRow
{
    NSUInteger index = NSNotFound;
    if ((index = [self.formRows indexOfObject:formRow]) != NSNotFound){
        [self removeFormRowAtIndex:index];
    }
    else if ((index = [self.allRows indexOfObject:formRow]) != NSNotFound){
        if (self.allRows.count > index){
            [self removeObjectFromAllRowsAtIndex:index];
        }
    };
}

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndex toIndexPath:(NSIndexPath *)destinationIndex
{
    if ((sourceIndex.row < self.formRows.count) && (destinationIndex.row < self.formRows.count) && (sourceIndex.row != destinationIndex.row)){
        GTUIFormRowDescriptor * row = [self objectInFormRowsAtIndex:sourceIndex.row];
        GTUIFormRowDescriptor * destRow = [self objectInFormRowsAtIndex:destinationIndex.row];
        [self.formRows removeObjectAtIndex:sourceIndex.row];
        [self.formRows insertObject:row atIndex:destinationIndex.row];

        [self.allRows removeObjectAtIndex:[self.allRows indexOfObject:row]];
        [self.allRows insertObject:row atIndex:[self.allRows indexOfObject:destRow]];
    }
}

-(void)dealloc
{
    [self.formDescriptor removeObserversOfObject:self predicateType:GTCPredicateTypeHidden];
    @try {
        [self removeObserver:self forKeyPath:@"formRows"];
    }
    @catch (NSException * __unused exception) {}
}

#pragma mark - Show/hide rows

-(void)showFormRow:(GTUIFormRowDescriptor*)formRow{

    NSUInteger formIndex = [self.formRows indexOfObject:formRow];
    if (formIndex != NSNotFound) {
        return;
    }
    NSUInteger index = [self.allRows indexOfObject:formRow];
    if (index != NSNotFound){
        while (formIndex == NSNotFound && index > 0) {
            GTUIFormRowDescriptor* previous = [self.allRows objectAtIndex:--index];
            formIndex = [self.formRows indexOfObject:previous];
        }
        if (formIndex == NSNotFound){ // index == 0 => insert at the beginning
            [self insertObject:formRow inFormRowsAtIndex:0];
        }
        else {
            [self insertObject:formRow inFormRowsAtIndex:formIndex+1];
        }

    }
}

-(void)hideFormRow:(GTUIFormRowDescriptor*)formRow{
    NSUInteger index = [self.formRows indexOfObject:formRow];
    if (index != NSNotFound){
        [self removeObjectFromFormRowsAtIndex:index];
    }
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.formDescriptor.delegate) return;
    if ([keyPath isEqualToString:@"formRows"]){
        if ([self.formDescriptor.formSections containsObject:self]){
            if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)]){
                NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
                GTUIFormRowDescriptor * formRow = [((GTUIFormSectionDescriptor *)object).formRows objectAtIndex:indexSet.firstIndex];
                NSUInteger sectionIndex = [self.formDescriptor.formSections indexOfObject:object];
                [self.formDescriptor.delegate formRowHasBeenAdded:formRow atIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
            }
            else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)]){
                NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
                GTUIFormRowDescriptor * removedRow = [[change objectForKey:NSKeyValueChangeOldKey] objectAtIndex:0];
                NSUInteger sectionIndex = [self.formDescriptor.formSections indexOfObject:object];
                [self.formDescriptor.delegate formRowHasBeenRemoved:removedRow atIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
            }
        }
    }
}



#pragma mark - KVC

-(NSUInteger)countOfFormRows
{
    return self.formRows.count;
}

- (id)objectInFormRowsAtIndex:(NSUInteger)index
{
    return [self.formRows objectAtIndex:index];
}

- (NSArray *)formRowsAtIndexes:(NSIndexSet *)indexes
{
    return [self.formRows objectsAtIndexes:indexes];
}

- (void)insertObject:(GTUIFormRowDescriptor *)formRow inFormRowsAtIndex:(NSUInteger)index
{
    formRow.sectionDescriptor = self;
    [self.formRows insertObject:formRow atIndex:index];
}

- (void)removeObjectFromFormRowsAtIndex:(NSUInteger)index
{
    [self.formRows removeObjectAtIndex:index];
}

#pragma mark - KVC ALL

-(NSUInteger)countOfAllRows
{
    return self.allRows.count;
}

- (id)objectInAllRowsAtIndex:(NSUInteger)index
{
    return [self.allRows objectAtIndex:index];
}

- (NSArray *)allRowsAtIndexes:(NSIndexSet *)indexes
{
    return [self.allRows objectsAtIndexes:indexes];
}

- (void)insertObject:(GTUIFormRowDescriptor *)row inAllRowsAtIndex:(NSUInteger)index
{
    row.sectionDescriptor = self;
    [self.formDescriptor addRowToTagCollection:row];
    [self.allRows insertObject:row atIndex:index];
    row.disabled = row.disabled;
    row.hidden = row.hidden;
}

- (void)removeObjectFromAllRowsAtIndex:(NSUInteger)index
{
    GTUIFormRowDescriptor * row = [self.allRows objectAtIndex:index];
    [self.formDescriptor removeRowFromTagCollection:row];
    [self.formDescriptor removeObserversOfObject:row predicateType:GTCPredicateTypeDisabled];
    [self.formDescriptor removeObserversOfObject:row predicateType:GTCPredicateTypeHidden];
    [self.allRows removeObjectAtIndex:index];
}

#pragma mark - Helpers

-(BOOL)canInsertUsingButton
{
    return (self.sectionInsertMode == GTUIFormSectionInsertModeButton && self.sectionOptions & GTUIFormSectionOptionCanInsert);
}

#pragma mark - Predicates


-(NSNumber *)hidePredicateCache
{
    return _hidePredicateCache;
}

-(void)setHidePredicateCache:(NSNumber *)hidePredicateCache
{
    NSParameterAssert(hidePredicateCache);
    self.isDirtyHidePredicateCache = NO;
    if (!_hidePredicateCache || ![_hidePredicateCache isEqualToNumber:hidePredicateCache]){
        _hidePredicateCache = hidePredicateCache;
    }
}

-(BOOL)isHidden
{
    if (self.isDirtyHidePredicateCache) {
        return [self evaluateIsHidden];
    }
    return [self.hidePredicateCache boolValue];
}

-(BOOL)evaluateIsHidden
{
    if ([_hidden isKindOfClass:[NSPredicate class]]) {
        if (!self.formDescriptor) {
            self.isDirtyHidePredicateCache = YES;
        } else {
            @try {
                self.hidePredicateCache = @([_hidden evaluateWithObject:self substitutionVariables:self.formDescriptor.allRowsByTag ?: @{}]);
            }
            @catch (NSException *exception) {
                // predicate syntax error.
                self.isDirtyHidePredicateCache = YES;
            };
        }
    }
    else{
        self.hidePredicateCache = _hidden;
    }
    if ([self.hidePredicateCache boolValue]){
        if ([self.formDescriptor.delegate isKindOfClass:[GTUIFormViewController class]]){
            GTUIFormBaseCell* firtResponder = (GTUIFormBaseCell*) [((GTUIFormViewController*)self.formDescriptor.delegate).tableView findFirstResponder];
            if ([firtResponder isKindOfClass:[GTUIFormBaseCell class]] && firtResponder.rowDescriptor.sectionDescriptor == self){
                [firtResponder resignFirstResponder];
            }
        }
        [self.formDescriptor hideFormSection:self];
    }
    else{
        [self.formDescriptor showFormSection:self];
    }
    return [self.hidePredicateCache boolValue];
}


-(id)hidden
{
    return _hidden;
}

-(void)setHidden:(id)hidden
{
    if ([_hidden isKindOfClass:[NSPredicate class]]){
        [self.formDescriptor removeObserversOfObject:self predicateType:GTCPredicateTypeHidden];
    }
    _hidden = [hidden isKindOfClass:[NSString class]] ? [hidden formPredicate] : hidden;
    if ([_hidden isKindOfClass:[NSPredicate class]]){
        [self.formDescriptor addObserversOfObject:self predicateType:GTCPredicateTypeHidden];
    }
    [self evaluateIsHidden]; // check and update if this row should be hidden.
}

@end
