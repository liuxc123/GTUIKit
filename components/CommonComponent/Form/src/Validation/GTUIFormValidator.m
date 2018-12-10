//
//  GTUIFormValidator.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTUIFormValidationStatus.h"
#import "GTUIFormRegexValidator.h"
#import "GTUIFormValidator.h"

@implementation GTUIFormValidator

- (GTUIFormValidationStatus *)isValid:(GTUIFormRowDescriptor *)row {
    return [GTUIFormValidationStatus formValidationStatusWithMsg:nil status:YES rowDescriptor:row];
}

#pragma mark - Validators

+ (GTUIFormValidator *)emailValidator {
    return [GTUIFormRegexValidator formRegexValidatorWithMsg:NSLocalizedString(@"Invalid email address", nil) regex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

+ (GTUIFormValidator *)emailValidatorLong {
    return [GTUIFormRegexValidator formRegexValidatorWithMsg:NSLocalizedString(@"Invalid email address", nil) regex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,11}"];
}

@end
