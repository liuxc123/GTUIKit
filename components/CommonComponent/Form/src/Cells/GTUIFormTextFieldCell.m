//
//  GTUIFormTextFieldCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormTextFieldCell.h"
#import "NSObject+GTUIFormAdditions.h"
#import "UIView+GTUIFormAdditions.h"
#import "GTUIFormRowDescriptor.h"
#import "GTUIForm.h"

NSString *const GTUIFormTextFieldLengthPercentage = @"textFieldLengthPercentage";
NSString *const GTUIFormTextFieldMaxNumberOfCharacters = @"textFieldMaxNumberOfCharacters";

@interface GTUIFormTextFieldCell () <UITextFieldDelegate>

@property NSMutableArray * dynamicCustomConstraints;

@end

@implementation GTUIFormTextFieldCell

@synthesize textField = _textField;
@synthesize textLabel = _textLabel;
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
    if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeText]){
        self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeName]){
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeEmail]){
        self.textField.keyboardType = UIKeyboardTypeEmailAddress;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeNumber]){
        self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeInteger]){
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeDecimal]){
        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypePassword]){
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.textField.secureTextEntry = YES;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypePhone]){
        self.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeURL]){
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.keyboardType = UIKeyboardTypeURL;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeTwitter]){
        self.textField.keyboardType = UIKeyboardTypeTwitter;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeAccount]){
        self.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:GTUIFormRowDescriptorTypeZipCode]){
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        self.textField.keyboardType = UIKeyboardTypeDefault;
    }

    self.textLabel.text = ((self.rowDescriptor.required && self.rowDescriptor.title && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle) ? [NSString stringWithFormat:@"%@*", self.rowDescriptor.title] : self.rowDescriptor.title);

    self.textField.text = self.rowDescriptor.value ? [self.rowDescriptor displayTextValue] : self.rowDescriptor.noValueDisplayText;
    [self.textField setEnabled:!self.rowDescriptor.isDisabled];
    self.textField.textColor = self.rowDescriptor.isDisabled ? [UIColor grayColor] : [UIColor blackColor];
    self.textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
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

#pragma mark - LayoutConstraints

- (NSArray *)layoutConstraints
{
    NSMutableArray * result = [[NSMutableArray alloc] init];
    [self.textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.textLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];

    // Add Constraints
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[_textField]-(margin)-|" options:NSLayoutFormatAlignAllBaseline metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(11.0), @"margin", nil] views:NSDictionaryOfVariableBindings(_textField)]];
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[_textLabel]-(margin)-|" options:NSLayoutFormatAlignAllBaseline metrics:[NSDictionary dictionaryWithObjectsAndKeys:@(11.0), @"margin", nil] views:NSDictionaryOfVariableBindings(_textLabel)]];

    return result;
}

- (void)updateConstraints
{
    if (self.dynamicCustomConstraints){
        [self.contentView removeConstraints:self.dynamicCustomConstraints];
    }
    NSMutableDictionary * views = [[NSMutableDictionary alloc] initWithDictionary: @{@"label": self.textLabel, @"textField": self.textField}];
    if (self.imageView.image){
        views[@"image"] = self.imageView;
        if (self.textLabel.text.length > 0){
            self.dynamicCustomConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-[label]-[textField]-|" options:0 metrics:nil views:views]];
            [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:_textField
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:self.textFieldLengthPercentage ? NSLayoutRelationEqual : NSLayoutRelationGreaterThanOrEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:self.textFieldLengthPercentage ? [self.textFieldLengthPercentage floatValue] : 0.3
                                                                                   constant:0.0]];
        }
        else{
            self.dynamicCustomConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-[textField]-|" options:0 metrics:nil views:views]];
        }
    }
    else{
        if (self.textLabel.text.length > 0){
            self.dynamicCustomConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-[textField]-|" options:0 metrics:nil views:views]];
            [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:_textField
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:self.textFieldLengthPercentage ? NSLayoutRelationEqual : NSLayoutRelationGreaterThanOrEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:self.textFieldLengthPercentage ? [self.textFieldLengthPercentage floatValue] : 0.3
                                                                                   constant:0.0]];
        }
        else{
            self.dynamicCustomConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textField]-|" options:0 metrics:nil views:views]];
        }
    }

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

- (void)textFieldDidChange:(UITextField *)textField{
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
