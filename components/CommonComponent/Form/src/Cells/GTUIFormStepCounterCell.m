//
//  GTUIFormStepCounterCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormStepCounterCell.h"
#import "GTUIFormRowDescriptor.h"
#import "UIView+GTUIFormAdditions.h"

@interface GTUIFormStepCounterCell ()

@property (nonatomic) UIStepper *stepControl;
@property (nonatomic) UILabel *currentStepValue;

@end

@implementation GTUIFormStepCounterCell


#pragma mark - GTUIFormStepCounterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Add subviews
    [self.contentView addSubview:self.stepControl];
    [self.contentView addSubview:self.currentStepValue];

    // Add constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.stepControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.currentStepValue attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.currentStepValue attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.stepControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[value]-5-[control]-|" options:0 metrics:0 views:@{@"value": self.currentStepValue, @"control":self.stepControl}]];
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.stepControl.value = [self.rowDescriptor.value doubleValue];
    self.currentStepValue.text = self.rowDescriptor.value ? [NSString stringWithFormat:@"%@", self.rowDescriptor.value] : nil;
    [self stepControl].enabled = !self.rowDescriptor.isDisabled;
    [self currentStepValue].font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    CGFloat red, green, blue, alpha;
    [self.tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
    if (self.rowDescriptor.isDisabled)
    {
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.3]];
        [self currentStepValue].textColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.3];
    }
    else{
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:1]];
        [self currentStepValue].textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    }
}


#pragma mark - Events

- (void)valueChanged:(id)sender
{
    UIStepper *stepper = self.stepControl;

    self.rowDescriptor.value = @(stepper.value);
    self.currentStepValue.text = [NSString stringWithFormat:@"%.f", stepper.value];
}


#pragma mark - Properties

- (UIStepper *)stepControl
{
    if (!_stepControl) {
        _stepControl = [UIStepper autolayoutView];
        [_stepControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _stepControl;
}

-(UILabel *)currentStepValue
{
    if (!_currentStepValue) {
        _currentStepValue = [UILabel autolayoutView];
    }
    return _currentStepValue;
}

@end



