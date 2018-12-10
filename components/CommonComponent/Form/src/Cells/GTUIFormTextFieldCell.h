//
//  GTUIFormTextFieldCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormBaseCell.h"
#import <UIKit/UIKit.h>

extern NSString *const GTUIFormTextFieldLengthPercentage;
extern NSString *const GTUIFormTextFieldMaxNumberOfCharacters;

@interface GTUIFormTextFieldCell : GTUIFormBaseCell <GTUIFormReturnKeyProtocol>

@property (nonatomic, readonly) UILabel * textLabel;
@property (nonatomic, readonly) UITextField * textField;

@property (nonatomic) NSNumber *textFieldLengthPercentage;
@property (nonatomic) NSNumber *textFieldMaxNumberOfCharacters;

@end
