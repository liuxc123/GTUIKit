//
//  GTUIForm.h
//  GTUIatalog
//
//  Created by liuxc on 2018/12/10.
//

#import <Foundation/Foundation.h>
#import "GTUIMetrics.h"

//Descriptors
#import "GTUIFormDescriptor.h"
#import "GTUIFormRowDescriptor.h"
#import "GTUIFormSectionDescriptor.h"

// Categories
#import "NSArray+GTUIFormAdditions.h"
#import "NSExpression+GTUIFormAdditions.h"
#import "NSObject+GTUIFormAdditions.h"
#import "NSPredicate+GTUIFormAdditions.h"
#import "NSString+GTUIFormAdditions.h"
#import "UIView+GTUIFormAdditions.h"
#import "UIView+GTUIFrame.h"

//helpers
#import "GTUIFormOptionsObject.h"

//Controllers
#import "GTUIFormOptionsViewController.h"
#import "GTUIFormViewController.h"

//Protocols
#import "GTUIFormDescriptorCell.h"
#import "GTUIFormInlineRowDescriptorCell.h"
#import "GTUIFormRowDescriptorViewController.h"

//Cells
#import "GTUIFormBaseCell.h"
#import "GTUIFormButtonCell.h"
#import "GTUIFormCheckCell.h"
#import "GTUIFormDateCell.h"
#import "GTUIFormDatePickerCell.h"
#import "GTUIFormInlineSelectorCell.h"
#import "GTUIFormLeftRightSelectorCell.h"
#import "GTUIFormPickerCell.h"
#import "GTUIFormRightDetailCell.h"
#import "GTUIFormRightImageButton.h"
#import "GTUIFormSegmentedCell.h"
#import "GTUIFormSelectorCell.h"
#import "GTUIFormSliderCell.h"
#import "GTUIFormStepCounterCell.h"
#import "GTUIFormSwitchCell.h"
#import "GTUIFormTextFieldCell.h"
#import "GTUIFormTextViewCell.h"
#import "GTUIFormImageCell.h"
#import "GTUIFormCodeCell.h"


//Validation
#import "GTUIFormRegexValidator.h"


extern NSString *const GTUIFormRowDescriptorTypeAccount;
extern NSString *const GTUIFormRowDescriptorTypeBooleanCheck;
extern NSString *const GTUIFormRowDescriptorTypeBooleanSwitch;
extern NSString *const GTUIFormRowDescriptorTypeButton;
extern NSString *const GTUIFormRowDescriptorTypeCountDownTimer;
extern NSString *const GTUIFormRowDescriptorTypeCountDownTimerInline;
extern NSString *const GTUIFormRowDescriptorTypeDate;
extern NSString *const GTUIFormRowDescriptorTypeDateInline;
extern NSString *const GTUIFormRowDescriptorTypeDatePicker;
extern NSString *const GTUIFormRowDescriptorTypeDateTime;
extern NSString *const GTUIFormRowDescriptorTypeDateTimeInline;
extern NSString *const GTUIFormRowDescriptorTypeDecimal;
extern NSString *const GTUIFormRowDescriptorTypeEmail;
extern NSString *const GTUIFormRowDescriptorTypeImage;
extern NSString *const GTUIFormRowDescriptorTypeInfo;
extern NSString *const GTUIFormRowDescriptorTypeInteger;
extern NSString *const GTUIFormRowDescriptorTypeMultipleSelector;
extern NSString *const GTUIFormRowDescriptorTypeMultipleSelectorPopover;
extern NSString *const GTUIFormRowDescriptorTypeName;
extern NSString *const GTUIFormRowDescriptorTypeNumber;
extern NSString *const GTUIFormRowDescriptorTypePassword;
extern NSString *const GTUIFormRowDescriptorTypePhone;
extern NSString *const GTUIFormRowDescriptorTypePicker;
extern NSString *const GTUIFormRowDescriptorTypeSelectorActionSheet;
extern NSString *const GTUIFormRowDescriptorTypeSelectorAlertView;
extern NSString *const GTUIFormRowDescriptorTypeSelectorLeftRight;
extern NSString *const GTUIFormRowDescriptorTypeSelectorPickerView;
extern NSString *const GTUIFormRowDescriptorTypeSelectorPickerViewInline;
extern NSString *const GTUIFormRowDescriptorTypeSelectorPopover;
extern NSString *const GTUIFormRowDescriptorTypeSelectorPush;
extern NSString *const GTUIFormRowDescriptorTypeSelectorSegmentedControl;
extern NSString *const GTUIFormRowDescriptorTypeSlider;
extern NSString *const GTUIFormRowDescriptorTypeStepCounter;
extern NSString *const GTUIFormRowDescriptorTypeText;
extern NSString *const GTUIFormRowDescriptorTypeTextView;
extern NSString *const GTUIFormRowDescriptorTypeTime;
extern NSString *const GTUIFormRowDescriptorTypeTimeInline;
extern NSString *const GTUIFormRowDescriptorTypeTwitter;
extern NSString *const GTUIFormRowDescriptorTypeURL;
extern NSString *const GTUIFormRowDescriptorTypeZipCode;
extern NSString *const GTUIFormRowDescriptorTypeCountDownCode;



