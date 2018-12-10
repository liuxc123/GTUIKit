//
//  GTUIFormSliderCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormSliderCell.h"
#import "UIView+GTUIFormAdditions.h"

@interface GTUIFormSliderCell ()

@property (nonatomic) UISlider * slider;
@property (nonatomic) UILabel * textLabel;
@property NSUInteger steps;

@end

@implementation GTUIFormSliderCell

@synthesize textLabel = _textLabel;

- (void)configure
{
    self.steps = 0;
    [self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.slider];
    [self.contentView addSubview:self.textLabel];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:44]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-|" options:0 metrics:0 views:@{@"textLabel": self.textLabel}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[slider]-|" options:0 metrics:0 views:@{@"slider": self.slider}]];

    [self valueChanged:nil];
}

-(void)update {

    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.slider.value = [self.rowDescriptor.value floatValue];
    self.slider.enabled = !self.rowDescriptor.isDisabled;
    [self valueChanged:nil];
}

-(void)valueChanged:(UISlider*)_slider {
    if(self.steps != 0) {
        self.slider.value = roundf((self.slider.value-self.slider.minimumValue)/(self.slider.maximumValue-self.slider.minimumValue)*self.steps)*(self.slider.maximumValue-self.slider.minimumValue)/self.steps + self.slider.minimumValue;
    }
    self.rowDescriptor.value = @(self.slider.value);
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(GTUIFormRowDescriptor *)rowDescriptor {
    return 88;
}


-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    _textLabel = [UILabel autolayoutView];
    return _textLabel;
}

-(UISlider *)slider
{
    if (_slider) return _slider;
    _slider = [UISlider autolayoutView];
    return _slider;
}

@end

