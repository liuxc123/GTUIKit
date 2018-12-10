//
//  GTFormValidatorProtocol.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTUIFormRowDescriptor.h"

@class GTUIFormValidationStatus;

@protocol GTUIFormValidatorProtocol <NSObject>

@required

- (GTUIFormValidationStatus *)isValid:(GTUIFormRowDescriptor *)row;

@end
