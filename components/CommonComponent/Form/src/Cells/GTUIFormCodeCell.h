//
//  GTUIFormCodeCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/17.
//

#import "GTUIFormBaseCell.h"
#import <UIKit/UIKit.h>

extern NSString *const GTUIFormCodeTextFieldLengthPercentage;
extern NSString *const GTUIFormCodeTextFieldMaxNumberOfCharacters;

@interface GTUIFormCodeCell : GTUIFormBaseCell <GTUIFormReturnKeyProtocol>

@property (nonatomic, readonly) UILabel * textLabel;
@property (nonatomic, readonly) UITextField * textField;
@property (nonatomic, readonly) UIButton * codeButton;

@property (nonatomic) NSNumber *textFieldLengthPercentage;
@property (nonatomic) NSNumber *textFieldMaxNumberOfCharacters;
@property (nonatomic) NSNumber *countDownTime;
@property (nonatomic, retain) NSString *codeButtonNormalTitle;
@property (nonatomic, retain) NSString *codeButtonCountDownTitle;

/**
 倒计时按钮

 @param timeout 倒计时时间（单位：秒）
 */
- (void)startCountDownWithTimeOut:(NSInteger)timeout;

@end
