//
//  GTUIFormRowDescriptor.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "../GTUIForm.h"
#import "GTUIFormRowDescriptor.h"
#import "../Controllers/GTUIFormViewController.h"
#import "../Helpers/NSString+GTUIFormAdditions.h"
#import "../Helpers/NSObject+GTUIFormAdditions.h"

CGFloat GTUIFormUnspecifiedCellHeight = -3.0;
CGFloat GTUIFormRowInitialHeight = -2;

@interface GTUIFormDescriptor (_GTUIFormRowDescriptor)

@property (readonly) NSDictionary* allRowsByTag;

-(void)addObserversOfObject:(id)sectionOrRow predicateType:(GTCPredicateType)predicateType;
-(void)removeObserversOfObject:(id)sectionOrRow predicateType:(GTCPredicateType)predicateType;

@end

@interface GTUIFormSectionDescriptor (_GTUIFormRowDescriptor)

-(void)showFormRow:(GTUIFormRowDescriptor*)formRow;
-(void)hideFormRow:(GTUIFormRowDescriptor*)formRow;

@end


@interface GTUIFormRowDescriptor() <NSCopying>

@property GTUIFormBaseCell * cell;
@property (nonatomic) NSMutableArray *validators;

@property BOOL isDirtyDisablePredicateCache;
@property (nonatomic) NSNumber* disablePredicateCache;
@property BOOL isDirtyHidePredicateCache;
@property (nonatomic) NSNumber* hidePredicateCache;

@end

@implementation GTUIFormRowDescriptor

@synthesize action = _action;
@synthesize disabled = _disabled;
@synthesize hidden = _hidden;
@synthesize hidePredicateCache = _hidePredicateCache;
@synthesize disablePredicateCache = _disablePredicateCache;
@synthesize cellConfig = _cellConfig;
@synthesize cellConfigForSelector = _cellConfigForSelector;
@synthesize cellConfigIfDisabled = _cellConfigIfDisabled;
@synthesize cellConfigAtConfigure = _cellConfigAtConfigure;
@synthesize height = _height;


-(instancetype)init
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title must be used" userInfo:nil];
}

- (instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title
{
    self = [super init];
    if (self){
        NSAssert(((![rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPopover] && ![rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelectorPopover]) || (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) && ([rowType isEqualToString:GTUIFormRowDescriptorTypeSelectorPopover] || [rowType isEqualToString:GTUIFormRowDescriptorTypeMultipleSelectorPopover]))), @"You must be running under UIUserInterfaceIdiomPad to use either GTUIFormRowDescriptorTypeSelectorPopover or GTUIFormRowDescriptorTypeMultipleSelectorPopover rows.");
        _tag = tag;
        _disabled = @NO;
        _hidden = @NO;
        _rowType = rowType;
        _title = title;
        _cellStyle = [rowType isEqualToString:GTUIFormRowDescriptorTypeButton] ? UITableViewCellStyleDefault : UITableViewCellStyleValue1;
        _accessoryType = UITableViewCellAccessoryNone;
        _selectionStyle = UITableViewCellSelectionStyleDefault;
        _validators = [NSMutableArray new];
        _cellConfig = [NSMutableDictionary dictionary];
        _cellConfigIfDisabled = [NSMutableDictionary dictionary];
        _cellConfigAtConfigure = [NSMutableDictionary dictionary];
        _isDirtyDisablePredicateCache = YES;
        _disablePredicateCache = nil;
        _isDirtyHidePredicateCache = YES;
        _hidePredicateCache = nil;
        _height = GTUIFormRowInitialHeight;
        [self addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
        [self addObserver:self forKeyPath:@"disablePredicateCache" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
        [self addObserver:self forKeyPath:@"hidePredicateCache" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    }
    return self;
}


+(instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType
{
    return [[self class] formRowDescriptorWithTag:tag rowType:rowType title:nil];
}

+(instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title
{
    return [[[self class] alloc] initWithTag:tag rowType:rowType title:title];
}

-(GTUIFormBaseCell *)cellForFormController:(GTUIFormViewController * __unused)formController
{
    if (!_cell){
        id cellClass = self.cellClass ?: [GTUIFormViewController cellClassesForRowDescriptorTypes][self.rowType];
        NSAssert(cellClass, @"Not defined GTUIFormRowDescriptorType: %@", self.rowType ?: @"");
        if ([cellClass isKindOfClass:[NSString class]]) {
            NSString *cellClassString = cellClass;
            NSString *cellResource = nil;
            NSBundle *bundle = nil;
            if ([cellClassString rangeOfString:@"/"].location != NSNotFound) {
                NSArray *components = [cellClassString componentsSeparatedByString:@"/"];
                cellResource = [components lastObject];
                NSString *folderName = [components firstObject];
                NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:folderName];
                bundle = [NSBundle bundleWithPath:bundlePath];
            } else {
                bundle = [NSBundle bundleForClass:NSClassFromString(cellClass)];
                cellResource = cellClassString;
            }
            NSParameterAssert(bundle != nil);
            NSParameterAssert(cellResource != nil);

            if ([bundle pathForResource:cellResource ofType:@"nib"]){
                _cell = [[bundle loadNibNamed:cellResource owner:nil options:nil] firstObject];
            }
        } else {
            _cell = [[cellClass alloc] initWithStyle:self.cellStyle reuseIdentifier:nil];
        }
        _cell.rowDescriptor = self;
        NSAssert([_cell isKindOfClass:[GTUIFormBaseCell class]], @"UITableViewCell must extend from GTUIFormBaseCell");
        [self configureCellAtCreationTime];
    }
    return _cell;
}

- (void)configureCellAtCreationTime
{
    [self.cellConfigAtConfigure enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, __unused BOOL *stop) {
        [self->_cell setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
    }];
}

-(NSMutableDictionary *)cellConfig
{
    if (_cellConfig) return _cellConfig;
    _cellConfig = [NSMutableDictionary dictionary];
    return _cellConfig;
}

-(NSMutableDictionary *)cellConfigForSelector
{
    if (_cellConfigForSelector) return _cellConfigForSelector;
    _cellConfigForSelector = [NSMutableDictionary dictionary];
    return _cellConfigForSelector;
}


-(NSMutableDictionary *)cellConfigIfDisabled
{
    if (_cellConfigIfDisabled) return _cellConfigIfDisabled;
    _cellConfigIfDisabled = [NSMutableDictionary dictionary];
    return _cellConfigIfDisabled;
}

-(NSMutableDictionary *)cellConfigAtConfigure
{
    if (_cellConfigAtConfigure) return _cellConfigAtConfigure;
    _cellConfigAtConfigure = [NSMutableDictionary dictionary];
    return _cellConfigAtConfigure;
}

-(NSString*)editTextValue
{
    if (self.value) {
        if (self.valueFormatter) {
            if (self.useValueFormatterDuringInput) {
                return [self displayTextValue];
            }else{
                // have formatter, but we don't want to use it during editing
                return [self.value displayText];
            }
        }else{
            // have value, but no formatter, use the value's displayText
            return [self.value displayText];
        }
    }else{
        // placeholder
        return @"";
    }
}

-(NSString*)displayTextValue
{
    if (self.value) {
        if (self.valueFormatter) {
            return [self.valueFormatter stringForObjectValue:self.value];
        }
        else{
            return [self.value displayText];
        }
    }
    else {
        return self.noValueDisplayText;
    }
}

-(NSString *)description
{
    return self.tag;  // [NSString stringWithFormat:@"%@ - %@ (%@)", [super description], self.tag, self.rowType];
}

-(GTUIFormAction *)action
{
    if (!_action){
        _action = [[GTUIFormAction alloc] init];
    }
    return _action;
}

-(void)setAction:(GTUIFormAction *)action
{
    _action = action;
}

-(CGFloat)height
{
    if (_height == GTUIFormRowInitialHeight){
        if ([[self.cell class] respondsToSelector:@selector(formDescriptorCellHeightForRowDescriptor:)]){
            return [[self.cell class] formDescriptorCellHeightForRowDescriptor:self];
        } else {
            _height = GTUIFormUnspecifiedCellHeight;
        }
    }
    return _height;
}

-(void)setHeight:(CGFloat)height {
    _height = height;
}

// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    GTUIFormRowDescriptor * rowDescriptorCopy = [GTUIFormRowDescriptor formRowDescriptorWithTag:nil rowType:[self.rowType copy] title:[self.title copy]];
    rowDescriptorCopy.cellClass = [self.cellClass copy];
    [rowDescriptorCopy.cellConfig addEntriesFromDictionary:self.cellConfig];
    [rowDescriptorCopy.cellConfigAtConfigure addEntriesFromDictionary:self.cellConfigAtConfigure];
    rowDescriptorCopy.valueTransformer = [self.valueTransformer copy];
    rowDescriptorCopy->_hidden = _hidden;
    rowDescriptorCopy->_disabled = _disabled;
    rowDescriptorCopy.required = self.isRequired;
    rowDescriptorCopy.isDirtyDisablePredicateCache = YES;
    rowDescriptorCopy.isDirtyHidePredicateCache = YES;
    rowDescriptorCopy.validators = [self.validators mutableCopy];

    // =====================
    // properties for Button
    // =====================
    rowDescriptorCopy.action = [self.action copy];


    // ===========================
    // property used for Selectors
    // ===========================

    rowDescriptorCopy.noValueDisplayText = [self.noValueDisplayText copy];
    rowDescriptorCopy.selectorTitle = [self.selectorTitle copy];
    rowDescriptorCopy.selectorOptions = [self.selectorOptions copy];
    rowDescriptorCopy.leftRightSelectorLeftOptionSelected = [self.leftRightSelectorLeftOptionSelected copy];

    return rowDescriptorCopy;
}

-(void)dealloc
{
    [self.sectionDescriptor.formDescriptor removeObserversOfObject:self predicateType:GTCPredicateTypeDisabled];
    [self.sectionDescriptor.formDescriptor removeObserversOfObject:self predicateType:GTCPredicateTypeHidden];
    @try {
        [self removeObserver:self forKeyPath:@"value"];
    }
    @catch (NSException * __unused exception) {}
    @try {
        [self removeObserver:self forKeyPath:@"disablePredicateCache"];
    }
    @catch (NSException * __unused exception) {}
    @try {
        [self removeObserver:self forKeyPath:@"hidePredicateCache"];
    }
    @catch (NSException * __unused exception) {}
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.sectionDescriptor) return;
    if (object == self && ([keyPath isEqualToString:@"value"] || [keyPath isEqualToString:@"hidePredicateCache"] || [keyPath isEqualToString:@"disablePredicateCache"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            id newValue = [change objectForKey:NSKeyValueChangeNewKey];
            id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
            if ([keyPath isEqualToString:@"value"]){
                [self.sectionDescriptor.formDescriptor.delegate formRowDescriptorValueHasChanged:object oldValue:oldValue newValue:newValue];
                if (self.onChangeBlock) {
                    self.onChangeBlock(oldValue, newValue, self);
                }
            }
            else{
                [self.sectionDescriptor.formDescriptor.delegate formRowDescriptorPredicateHasChanged:object oldValue:oldValue newValue:newValue predicateType:([keyPath isEqualToString:@"hidePredicateCache"] ? GTCPredicateTypeHidden : GTCPredicateTypeDisabled)];
            }
        }
    }
}

#pragma mark - Disable Predicate functions

-(BOOL)isDisabled
{
    if (self.sectionDescriptor.formDescriptor.isDisabled){
        return YES;
    }
    if (self.isDirtyDisablePredicateCache) {
        [self evaluateIsDisabled];
    }
    return [self.disablePredicateCache boolValue];
}

-(void)setDisabled:(id)disabled
{
    if ([_disabled isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor removeObserversOfObject:self predicateType:GTCPredicateTypeDisabled];
    }
    _disabled = [disabled isKindOfClass:[NSString class]] ? [disabled formPredicate] : disabled;
    if ([_disabled isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor addObserversOfObject:self predicateType:GTCPredicateTypeDisabled];
    }

    [self evaluateIsDisabled];
}

-(BOOL)evaluateIsDisabled
{
    if ([_disabled isKindOfClass:[NSPredicate class]]) {
        if (!self.sectionDescriptor.formDescriptor) {
            self.isDirtyDisablePredicateCache = YES;
        } else {
            @try {
                self.disablePredicateCache = @([_disabled evaluateWithObject:self substitutionVariables:self.sectionDescriptor.formDescriptor.allRowsByTag ?: @{}]);
            }
            @catch (NSException *exception) {
                // predicate syntax error.
                self.isDirtyDisablePredicateCache = YES;
            };
        }
    }
    else{
        self.disablePredicateCache = _disabled;
    }
    if ([self.disablePredicateCache boolValue]){
        [self.cell resignFirstResponder];
    }
    return [self.disablePredicateCache boolValue];
}

-(id)disabled
{
    return _disabled;
}

-(void)setDisablePredicateCache:(NSNumber*)disablePredicateCache
{
    NSParameterAssert(disablePredicateCache);
    self.isDirtyDisablePredicateCache = NO;
    if (!_disablePredicateCache || ![_disablePredicateCache isEqualToNumber:disablePredicateCache]){
        _disablePredicateCache = disablePredicateCache;
    }
}

-(NSNumber*)disablePredicateCache
{
    return _disablePredicateCache;
}

#pragma mark - Hide Predicate functions

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
        if (!self.sectionDescriptor.formDescriptor) {
            self.isDirtyHidePredicateCache = YES;
        } else {
            @try {
                self.hidePredicateCache = @([_hidden evaluateWithObject:self substitutionVariables:self.sectionDescriptor.formDescriptor.allRowsByTag ?: @{}]);
            }
            @catch (NSException *exception) {
                // predicate syntax error or for has not finished loading.
                self.isDirtyHidePredicateCache = YES;
            };
        }
    }
    else{
        self.hidePredicateCache = _hidden;
    }
    if ([self.hidePredicateCache boolValue]){
        [self.cell resignFirstResponder];
        [self.sectionDescriptor hideFormRow:self];
    }
    else{
        [self.sectionDescriptor showFormRow:self];
    }
    return [self.hidePredicateCache boolValue];
}


-(void)setHidden:(id)hidden
{
    if ([_hidden isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor removeObserversOfObject:self predicateType:GTCPredicateTypeHidden];
    }
    _hidden = [hidden isKindOfClass:[NSString class]] ? [hidden formPredicate] : hidden;
    if ([_hidden isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor addObserversOfObject:self predicateType:GTCPredicateTypeHidden];
    }
    [self evaluateIsHidden]; // check and update if this row should be hidden.
}

-(id)hidden
{
    return _hidden;
}

#pragma mark - validation

- (void)addValidator:(id<GTUIFormValidatorProtocol>)validator
{
    if (validator == nil || ![validator conformsToProtocol:@protocol(GTUIFormValidatorProtocol)])
        return;

    if(![self.validators containsObject:validator]) {
        [self.validators addObject:validator];
    }
}

- (void)removeValidator:(id<GTUIFormValidatorProtocol>)validator
{
    if (validator == nil|| ![validator conformsToProtocol:@protocol(GTUIFormValidatorProtocol)])
        return;

    if ([self.validators containsObject:validator]) {
        [self.validators removeObject:validator];
    }
}

- (BOOL)valueIsEmpty
{
    return self.value == nil || [self.value isKindOfClass:[NSNull class]] || ([self.value respondsToSelector:@selector(length)] && [self.value length]==0) ||
    ([self.value respondsToSelector:@selector(count)] && [self.value count]==0);
}

- (GTUIFormValidationStatus *)doValidation
{
    GTUIFormValidationStatus *valStatus = nil;

    if (self.required) {
        // do required validation here
        if ([self valueIsEmpty]) {
            valStatus = [GTUIFormValidationStatus formValidationStatusWithMsg:@"" status:NO rowDescriptor:self];
            NSString *msg = nil;
            if (self.requireMsg != nil) {
                msg = self.requireMsg;
            } else {
                // default message for required msg
                msg = NSLocalizedString(@"%@ can't be empty", nil);
            }

            if (self.title != nil) {
                valStatus.msg = [NSString stringWithFormat:msg, self.title];
            } else {
                valStatus.msg = [NSString stringWithFormat:msg, self.tag];
            }

            return valStatus;
        }
    }
    // custom validator
    for(id<GTUIFormValidatorProtocol> v in self.validators) {
        if ([v conformsToProtocol:@protocol(GTUIFormValidatorProtocol)]) {
            GTUIFormValidationStatus *vStatus = [v isValid:self];
            // fail validation
            if (vStatus != nil && !vStatus.isValid) {
                return vStatus;
            }
            valStatus = vStatus;
        } else {
            valStatus = nil;
        }
    }
    return valStatus;
}


@end

@implementation GTUIFormLeftRightSelectorOption


+(GTUIFormLeftRightSelectorOption *)formLeftRightSelectorOptionWithLeftValue:(id)leftValue
                                                          httpParameterKey:(NSString *)httpParameterKey
                                                              rightOptions:(NSArray *)rightOptions;
{
    return [[GTUIFormLeftRightSelectorOption alloc] initWithLeftValue:leftValue
                                                   httpParameterKey:httpParameterKey
                                                       rightOptions:rightOptions];
}


-(instancetype)initWithLeftValue:(NSString *)leftValue httpParameterKey:(NSString *)httpParameterKey rightOptions:(NSArray *)rightOptions
{
    self = [super init];
    if (self){
        _selectorTitle = nil;
        _leftValue = leftValue;
        _rightOptions = rightOptions;
        _httpParameterKey = httpParameterKey;
    }
    return self;
}


@end

@implementation GTUIFormAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewControllerPresentationMode = GTUIFormPresentationModeDefault;
    }
    return self;
}

// In the implementation
- (id)copyWithZone:(NSZone *)zone
{
    GTUIFormAction * actionCopy = [[GTUIFormAction alloc] init];
    actionCopy.viewControllerPresentationMode = self.viewControllerPresentationMode;
    if (self.viewControllerClass){
        actionCopy.viewControllerClass = [self.viewControllerClass copy];
    }
    else if ([self.viewControllerStoryboardId length]  != 0){
        actionCopy.viewControllerStoryboardId = [self.viewControllerStoryboardId copy];
    }
    else if ([self.viewControllerNibName length] != 0){
        actionCopy.viewControllerNibName = [self.viewControllerNibName copy];
    }
    if (self.formBlock){
        actionCopy.formBlock = [self.formBlock copy];
    }
    else if (self.formSelector){
        actionCopy.formSelector = self.formSelector;
    }
    else if (self.formSegueIdentifier){
        actionCopy.formSegueIdentifier = [self.formSegueIdentifier copy];
    }
    else if (self.formSegueClass){
        actionCopy.formSegueClass = [self.formSegueClass copy];
    }
    return actionCopy;
}


-(void)setViewControllerClass:(Class)viewControllerClass
{
    _viewControllerClass = viewControllerClass;
    _viewControllerNibName = nil;
    _viewControllerStoryboardId = nil;
}

-(void)setViewControllerNibName:(NSString *)viewControllerNibName
{
    _viewControllerClass = nil;
    _viewControllerNibName = viewControllerNibName;
    _viewControllerStoryboardId = nil;
}

-(void)setViewControllerStoryboardId:(NSString *)viewControllerStoryboardId
{
    _viewControllerClass = nil;
    _viewControllerNibName = nil;
    _viewControllerStoryboardId = viewControllerStoryboardId;
}


-(void)setFormSelector:(SEL)formSelector
{
    _formBlock = nil;
    _formSegueClass = nil;
    _formSegueIdentifier = nil;
    _formSelector = formSelector;
}


-(void)setFormBlock:(void (^)(GTUIFormRowDescriptor *))formBlock
{
    _formSegueClass = nil;
    _formSegueIdentifier = nil;
    _formSelector = nil;
    _formBlock = formBlock;
}

-(void)setFormSegueClass:(Class)formSegueClass
{
    _formSelector = nil;
    _formBlock = nil;
    _formSegueIdentifier = nil;
    _formSegueClass = formSegueClass;
}

-(void)setFormSegueIdentifier:(NSString *)formSegueIdentifier
{
    _formSelector = nil;
    _formBlock = nil;
    _formSegueClass = nil;
    _formSegueIdentifier = formSegueIdentifier;
}

-(NSString *)formSegueIdenfifier
{
    return self.formSegueIdentifier;
}


@end
