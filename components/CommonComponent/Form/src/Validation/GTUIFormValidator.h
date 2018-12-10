//
//  GTUIFormValidator.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTUIFormValidatorProtocol.h"

@interface GTUIFormValidator : NSObject <GTUIFormValidatorProtocol>

+ (GTUIFormValidator *)emailValidator;

+ (GTUIFormValidator *)emailValidatorLong;

@end
