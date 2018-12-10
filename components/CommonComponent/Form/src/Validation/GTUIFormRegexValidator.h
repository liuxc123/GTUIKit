//
//  GTUIFormRegexValidator.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTUIFormValidatorProtocol.h"
#import "GTUIFormValidationStatus.h"
#import "GTUIFormValidator.h"

@interface GTUIFormRegexValidator : GTUIFormValidator

@property NSString *msg;
@property NSString *regex;

- (instancetype)initWithMsg:(NSString*)msg andRegexString:(NSString*)regex;
+ (GTUIFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)msg regex:(NSString *)regex;

@end
