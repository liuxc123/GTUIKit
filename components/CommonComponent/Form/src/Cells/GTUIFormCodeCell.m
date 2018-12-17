//
//  GTUIFormCodeCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/17.
//

#import "GTUIFormCodeCell.h"
#import "NSObject+GTUIFormAdditions.h"
#import "UIView+GTUIFormAdditions.h"
#import "GTUIFormRowDescriptor.h"
#import "GTUIForm.h"

NSString *const GTUIFormCodeTextFieldLengthPercentage = @"textFieldLengthPercentage";
NSString *const GTUIFormCodeTextFieldMaxNumberOfCharacters = @"textFieldMaxNumberOfCharacters";

@interface GTUIFormCodeCell () <UITextFieldDelegate>

@property NSMutableArray * dynamicCustomConstraints;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation GTUIFormCodeCell

@synthesize textField = _textField;
@synthesize textLabel = _textLabel;
@synthesize codeButton = _codeButton;
@synthesize returnKeyType = _returnKeyType;
@synthesize nextReturnKeyType = _nextReturnKeyType;

#pragma mark - KVO

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self.textLabel && [keyPath isEqualToString:@"text"]) ||  (object == self.imageView && [keyPath isEqualToString:@"image"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self.contentView setNeedsUpdateConstraints];
        }
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _returnKeyType = UIReturnKeyDefault;
        _nextReturnKeyType = UIReturnKeyNext;
        _textFieldMaxNumberOfCharacters = [NSNumber numberWithInteger:6];
        _codeButtonNormalTitle = @"获取验证码";
        _codeButtonCountDownTitle = @"秒后重发";
        _countDownTime = [NSNumber numberWithInteger:60];
    }
    return self;
}

- (void)dealloc
{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
    [self.imageView removeObserver:self forKeyPath:@"image"];
}

#pragma mark - GTUIFormDescriptorCell

- (void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.codeButton];
    [self.contentView addConstraints:[self layoutConstraints]];
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)update
{
    [super update];
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeCountDownCode]){
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    self.textLabel.text = ((self.rowDescriptor.required && self.rowDescriptor.title && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle) ? [NSString stringWithFormat:@"%@*", self.rowDescriptor.title] : self.rowDescriptor.title);

    self.textField.text = self.rowDescriptor.value ? [self.rowDescriptor displayTextValue] : self.rowDescriptor.noValueDisplayText;
    [self.textField setEnabled:!self.rowDescriptor.isDisabled];
    self.textField.textColor = self.rowDescriptor.isDisabled ? [UIColor grayColor] : [UIColor blackColor];
    self.textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    self.lineView.backgroundColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
    
    [self.codeButton setTitle:self.codeButtonNormalTitle forState: UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor colorWithRed:255/255.0 green:138/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(codeButtonClick) forControlEvents:UIControlEventTouchUpInside];
}


- (BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.isDisabled);
}

- (BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

- (void)highlight
{
    [super highlight];
    self.textLabel.textColor = self.tintColor;
}

- (void)unhighlight
{
    [super unhighlight];
    [self.formViewController updateFormRow:self.rowDescriptor];
}

#pragma mark - actions
- (void)codeButtonClick {
    if (self.rowDescriptor.action.formBlock){
        self.rowDescriptor.action.formBlock(self.rowDescriptor);
    }
}

- (void)startCountDownWithTimeOut:(NSInteger)timeout {
    __block NSInteger timeOut = timeout; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:self.codeButtonNormalTitle forState:UIControlStateNormal];
                self.codeButton.enabled = YES;
            });
        }else{
            NSInteger seconds = timeOut % 60 == 0 ? timeOut : timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:[NSString stringWithFormat:@"%@%@",strTime,self.codeButtonCountDownTitle] forState:UIControlStateNormal];
                self.codeButton.enabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark - Properties

-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    _textLabel = [UILabel autolayoutView];
    return _textLabel;
}

-(UITextField *)textField
{
    if (_textField) return _textField;
    _textField = [UITextField autolayoutView];
    return _textField;
}

- (UIView *)lineView
{
    if (_lineView) return _lineView;
    _lineView = [UIView autolayoutView];
    return _lineView;
}

- (UIButton *)codeButton
{
    if (_codeButton) return _codeButton;
    _codeButton = [UIButton autolayoutView];
    return _codeButton;
}

#pragma mark - LayoutConstraints

- (NSArray *)layoutConstraints
{
    NSMutableArray * result = [[NSMutableArray alloc] init];
    [self.textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.textLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [self.codeButton setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.codeButton setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];

    // Add Constraints
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[_textField]-(margin)-|" options:NSLayoutFormatAlignAllBaseline metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(11.0), @"margin", nil] views:NSDictionaryOfVariableBindings(_textField)]];
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[_textLabel]-(margin)-|" options:NSLayoutFormatAlignAllBaseline metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(11.0), @"margin", nil] views:NSDictionaryOfVariableBindings(_textLabel)]];
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[_codeButton]-(margin)-|" options:NSLayoutFormatAlignAllBaseline metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(11.0), @"margin", nil] views:NSDictionaryOfVariableBindings(_codeButton)]];
    [result addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[_lineView]-(margin)-|" options:NSLayoutFormatAlignAllBaseline metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(20), @"margin", nil] views:NSDictionaryOfVariableBindings(_lineView)]];

    return result;
}


- (void)updateConstraints
    {
    if (self.dynamicCustomConstraints){
        [self.contentView removeConstraints:self.dynamicCustomConstraints];
    }
        NSMutableDictionary * views = [[NSMutableDictionary alloc] initWithDictionary: @{@"label": self.textLabel, @"textField": self.textField,@"line": self.lineView, @"button": self.codeButton}];
    if (self.imageView.image){
        views[@"image"] = self.imageView;
        if (self.textLabel.text.length > 0){
            self.dynamicCustomConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-[label]-[textField]-[line]-[button]-|" options:0 metrics:nil views:views]];
            [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:_textField
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:self.textFieldLengthPercentage ? NSLayoutRelationEqual : NSLayoutRelationGreaterThanOrEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:self.textFieldLengthPercentage ? [self.textFieldLengthPercentage floatValue] : 0.3
                                                                                   constant:0.0]];
        }
        else{
            self.dynamicCustomConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-[textField]-[line]-[button]-|" options:0 metrics:nil views:views]];
        }
    }
    else{
        if (self.textLabel.text.length > 0){
            self.dynamicCustomConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-[textField]-[line]-[button]-|" options:0 metrics:nil views:views]];
            [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:_textField
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:self.textFieldLengthPercentage ? NSLayoutRelationEqual : NSLayoutRelationGreaterThanOrEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:self.textFieldLengthPercentage ? [self.textFieldLengthPercentage floatValue] : 0.3
                                                                                   constant:0.0]];
        }
        else{
            self.dynamicCustomConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textField]-[line]-[button]-|" options:0 metrics:nil views:views]];
        }
    }

    // lineView width
    [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:NULL attribute:NSLayoutAttributeWidth multiplier:1.0 constant:1.0]];

    // code button
    [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:_codeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:NULL attribute:NSLayoutAttributeWidth multiplier:1.0 constant:1.0]];

    [self.contentView addConstraints:self.dynamicCustomConstraints];
    [super updateConstraints];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return [self.formViewController textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.formViewController textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldEndEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textFieldMaxNumberOfCharacters) {
        // Check maximum length requirement
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length > self.textFieldMaxNumberOfCharacters.integerValue) {
            return NO;
        }
    }

    // Otherwise, leave response to view controller
    return [self.formViewController textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.formViewController beginEditing:self.rowDescriptor];
    [self.formViewController textFieldDidBeginEditing:textField];
    // set the input to the raw value if we have a formatter and it shouldn't be used during input
    if (self.rowDescriptor.valueFormatter) {
        self.textField.text = [self.rowDescriptor editTextValue];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // process text change before we stick a formatted value in the UITextField
    [self textFieldDidChange:textField];

    // losing input, replace the text field with the formatted value
    if (self.rowDescriptor.valueFormatter) {
        self.textField.text = [self.rowDescriptor.value displayText];
    }

    [self.formViewController endEditing:self.rowDescriptor];
    [self.formViewController textFieldDidEndEditing:textField];
}

#pragma mark - Helper

- (void)textFieldDidChange:(UITextField *)textField {
    if([self.textField.text length] > 0) {
        BOOL didUseFormatter = NO;

        if (self.rowDescriptor.valueFormatter && self.rowDescriptor.useValueFormatterDuringInput)
        {
            // use generic getObjectValue:forString:errorDescription and stringForObjectValue
            NSString *errorDescription = nil;
            NSString *objectValue = nil;

            if ([ self.rowDescriptor.valueFormatter getObjectValue:&objectValue forString:textField.text errorDescription:&errorDescription]) {
                NSString *formattedValue = [self.rowDescriptor.valueFormatter stringForObjectValue:objectValue];

                self.rowDescriptor.value = objectValue;
                textField.text = formattedValue;
                didUseFormatter = YES;
            }
        }

        // only do this conversion if we didn't use the formatter
        if (!didUseFormatter)
        {
            if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeNumber] || [self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDecimal]){
                self.rowDescriptor.value =  [NSDecimalNumber decimalNumberWithString:self.textField.text locale:NSLocale.currentLocale];
            } else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeInteger]){
                self.rowDescriptor.value = @([self.textField.text integerValue]);
            } else {
                self.rowDescriptor.value = self.textField.text;
            }
        }
    } else {
        self.rowDescriptor.value = nil;
    }
}

-(void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    _returnKeyType = returnKeyType;
    self.textField.returnKeyType = returnKeyType;
}

-(UIReturnKeyType)returnKeyType
{
    return _returnKeyType;
}


@end
