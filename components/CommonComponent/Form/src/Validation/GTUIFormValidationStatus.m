//
//  GTUIFormValidationStatus.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTUIFormValidationStatus.h"

@implementation GTUIFormValidationStatus

- (instancetype)initWithMsg:(NSString*)msg andStatus:(BOOL)isValid {
    return [self initWithMsg:msg status:isValid rowDescriptor:nil];
}

- (instancetype)initWithMsg:(NSString *)msg status:(BOOL)isValid rowDescriptor:(GTUIFormRowDescriptor *)row {
    self = [super init];
    if (self) {
        self.msg = msg;
        self.isValid = isValid;
        self.rowDescriptor = row;
    }
    return self;
}

+ (GTUIFormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status {
    return [self formValidationStatusWithMsg:msg status:status rowDescriptor:nil];
}

+ (GTUIFormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status rowDescriptor:(GTUIFormRowDescriptor *)row {
    return [[GTUIFormValidationStatus alloc] initWithMsg:msg status:status rowDescriptor:row];
}

@end
