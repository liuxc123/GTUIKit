//
//  GTUIFormValidationStatus.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>

#import "GTUIFormRowDescriptor.h"

@interface GTUIFormValidationStatus : NSObject

@property NSString *msg;
@property BOOL isValid;
@property (nonatomic, weak) GTUIFormRowDescriptor *rowDescriptor;


//-(instancetype)initWithMsg:(NSString*)msg andStatus:(BOOL)isValid;
-(instancetype)initWithMsg:(NSString*)msg status:(BOOL)isValid rowDescriptor:(GTUIFormRowDescriptor *)row;

//+(GTUIFormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status;
+(GTUIFormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status rowDescriptor:(GTUIFormRowDescriptor *)row;


@end
