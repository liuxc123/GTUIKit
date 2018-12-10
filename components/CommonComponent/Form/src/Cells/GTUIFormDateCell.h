//
//  GTUIFormDateCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormBaseCell.h"

typedef NS_ENUM(NSUInteger, GTUIFormDateDatePickerMode) {
    GTUIFormDateDatePickerModeGetFromRowDescriptor,
    GTUIFormDateDatePickerModeDate,
    GTUIFormDateDatePickerModeDateTime,
    GTUIFormDateDatePickerModeTime
};

@interface GTUIFormDateCell : GTUIFormBaseCell

@property (nonatomic) GTUIFormDateDatePickerMode formDatePickerMode;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;
@property (nonatomic) NSInteger minuteInterval;
@property (nonatomic) NSLocale *locale;

@end
