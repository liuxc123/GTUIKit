//
//  GTUIFormRegexValidator.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTUIFormRegexValidator.h"

@implementation GTUIFormRegexValidator

- (instancetype)initWithMsg:(NSString *)msg andRegexString:(NSString *)regex {
    self = [super init];
    if (self) {
        self.msg = msg;
        self.regex = regex;
    }

    return self;
}

- (GTUIFormValidationStatus *)isValid: (GTUIFormRowDescriptor *)row {
    if (row != nil && row.value != nil) {
        // we only validate if there is a value
        // assumption: required validation is already triggered
        // if this field is optional, we only validate if there is a value
        id value = row.value;
        if ([value isKindOfClass:[NSNumber class]]){
            value = [value stringValue];
        }
        if ([value isKindOfClass:[NSString class]] && [value length] > 0) {
            BOOL isValid = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regex] evaluateWithObject:[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            return [GTUIFormValidationStatus formValidationStatusWithMsg:self.msg status:isValid rowDescriptor:row];
        }
    }
    return nil;
};

+ (GTUIFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)msg regex:(NSString *)regex {
    return [[GTUIFormRegexValidator alloc] initWithMsg:msg andRegexString:regex];
}

@end
