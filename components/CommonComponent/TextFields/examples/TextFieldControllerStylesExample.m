//
//  TextFieldControllerStylesExample.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//
#import <UIKit/UIKit.h>

#import "GTTextFields.h"

#import "supplemental/TextFieldControllerStylesExampleSupplemental.h"

@interface TextFieldControllerStylesExample ()

// Be sure to keep your controllers in memory somewhere like a property:
@property(nonatomic, strong) GTUITextInputControllerOutlined *textFieldControllerOutlined;
@property(nonatomic, strong) GTUITextInputControllerFilled *textFieldControllerFilled;
@property(nonatomic, strong) GTUITextInputControllerUnderline *textFieldControllerUnderline;

@property(nonatomic, strong) UIImage *leadingImage;
@property(nonatomic, strong) UIImage *trailingImage;

@end

@implementation TextFieldControllerStylesExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"Text Fields";

    [self setupExampleViews];
    [self setupImages];
    [self setupTextFields];
}

- (void)setupImages {
    self.leadingImage = [[UIImage alloc] init];
    self.trailingImage = [[UIImage alloc] init];
}

- (void)setupTextFields {
    // Default with Character Count and Floating Placeholder Text Fields

    // First the text field is added to the view hierarchy
    GTUITextField *textFieldOutlined = [[GTUITextField alloc] init];
    [self.scrollView addSubview:textFieldOutlined];
    textFieldOutlined.translatesAutoresizingMaskIntoConstraints = NO;

    int characterCountMax = 25;
    textFieldOutlined.delegate = self;
    textFieldOutlined.clearButtonMode = UITextFieldViewModeAlways;

    textFieldOutlined.leadingView = [[UIImageView alloc] initWithImage:self.leadingImage];
    textFieldOutlined.leadingViewMode = UITextFieldViewModeAlways;
    textFieldOutlined.trailingView = [[UIImageView alloc] initWithImage:self.trailingImage];
    textFieldOutlined.trailingViewMode = UITextFieldViewModeAlways;

    // Second the controller is created to manage the text field
    self.textFieldControllerOutlined =
    [[GTUITextInputControllerOutlined alloc] initWithTextInput:textFieldOutlined];
    self.textFieldControllerOutlined.placeholderText =
    @"GTUITextInputControllerOutlined";
    self.textFieldControllerOutlined.characterCountMax = characterCountMax;

    [self.textFieldControllerOutlined gtui_setAdjustsFontForContentSizeCategory:YES];

    GTUITextField *textFieldFilled = [[GTUITextField alloc] init];
    [self.scrollView addSubview:textFieldFilled];
    textFieldFilled.translatesAutoresizingMaskIntoConstraints = NO;

    textFieldFilled.delegate = self;
    textFieldFilled.clearButtonMode = UITextFieldViewModeUnlessEditing;

    textFieldFilled.leadingView = [[UIImageView alloc] initWithImage:self.leadingImage];
    textFieldFilled.leadingViewMode = UITextFieldViewModeAlways;
    textFieldFilled.trailingView = [[UIImageView alloc] initWithImage:self.trailingImage];
    textFieldFilled.trailingViewMode = UITextFieldViewModeAlways;

    self.textFieldControllerFilled =
    [[GTUITextInputControllerFilled alloc] initWithTextInput:textFieldFilled];
    self.textFieldControllerFilled.placeholderText = @"GTUITextInputControllerFilled";
    self.textFieldControllerFilled.characterCountMax = characterCountMax;

    [self.textFieldControllerFilled gtui_setAdjustsFontForContentSizeCategory:YES];

    [NSLayoutConstraint
     activateConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:[charMax]-[floating]"
                          options:NSLayoutFormatAlignAllLeading |
                          NSLayoutFormatAlignAllTrailing
                          metrics:nil
                          views:@{
                                  @"charMax" : textFieldOutlined,
                                  @"floating" : textFieldFilled
                                  }]];
    [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeadingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.scrollView
                                 attribute:NSLayoutAttributeTrailingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;

    // Full Width Text Field
    GTUITextField *textFieldUnderline = [[GTUITextField alloc] init];
    [self.scrollView addSubview:textFieldUnderline];
    textFieldUnderline.translatesAutoresizingMaskIntoConstraints = NO;

    textFieldUnderline.delegate = self;
    textFieldUnderline.clearButtonMode = UITextFieldViewModeUnlessEditing;

    textFieldUnderline.leadingView = [[UIImageView alloc] initWithImage:self.leadingImage];
    textFieldUnderline.leadingViewMode = UITextFieldViewModeAlways;
    textFieldUnderline.trailingView = [[UIImageView alloc] initWithImage:self.trailingImage];
    textFieldUnderline.trailingViewMode = UITextFieldViewModeAlways;

    self.textFieldControllerUnderline =
    [[GTUITextInputControllerUnderline alloc] initWithTextInput:textFieldUnderline];
    self.textFieldControllerUnderline.placeholderText = @"GTUITextInputControllerUnderline";
    self.textFieldControllerUnderline.characterCountMax = characterCountMax;

    [self.textFieldControllerUnderline gtui_setAdjustsFontForContentSizeCategory:YES];

    [NSLayoutConstraint constraintWithItem:textFieldUnderline
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:textFieldFilled
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:1]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:textFieldUnderline
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeadingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;
    [NSLayoutConstraint constraintWithItem:textFieldUnderline
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailingMargin
                                multiplier:1
                                  constant:0]
    .active = YES;

    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView.contentLayoutGuide
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:20]
        .active = YES;
        [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView.contentLayoutGuide
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                      constant:-20]
        .active = YES;
    } else {
        [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:20]
        .active = YES;
        [NSLayoutConstraint constraintWithItem:textFieldOutlined
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.scrollView
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                      constant:-20]
        .active = YES;
    }
}




@end
