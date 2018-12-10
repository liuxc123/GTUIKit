//
//  GTUIFormDescriptor.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTUIFormRowDescriptor.h"
#import "GTUIFormSectionDescriptor.h"
#import "GTUIFormDescriptorDelegate.h"

extern NSString * __nonnull const GTUIFormErrorDomain;
extern NSString * __nonnull const GTCValidationStatusErrorKey;

typedef NS_ENUM(NSInteger, GTUIFormErrorCode)
{
    GTUIFormErrorCodeGen = -999,
    GTUIFormErrorCodeRequired = -1000
};

typedef NS_OPTIONS(NSUInteger, GTUIFormRowNavigationOptions) {
    GTUIFormRowNavigationOptionNone                               = 0,
    GTUIFormRowNavigationOptionEnabled                            = 1 << 0,
    GTUIFormRowNavigationOptionStopDisableRow                     = 1 << 1,
    GTUIFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow  = 1 << 2,
    GTUIFormRowNavigationOptionStopInlineRow                      = 1 << 3,
};

@class GTUIFormSectionDescriptor;

@interface GTUIFormDescriptor : NSObject

@property (readonly, nonatomic, nonnull) NSMutableArray * formSections;
@property (readonly, nullable) NSString * title;
@property (nonatomic) BOOL endEditingTableViewOnScroll;
@property (nonatomic) BOOL assignFirstResponderOnShow;
@property (nonatomic) BOOL addAsteriskToRequiredRowsTitle;
@property (getter=isDisabled) BOOL disabled;
@property (nonatomic) GTUIFormRowNavigationOptions rowNavigationOptions;

@property (weak, nullable) id<GTUIFormDescriptorDelegate> delegate;

+(nonnull instancetype)formDescriptor;
+(nonnull instancetype)formDescriptorWithTitle:(nullable NSString *)title;

-(void)addFormSection:(nonnull GTUIFormSectionDescriptor *)formSection;
-(void)addFormSection:(nonnull GTUIFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;
-(void)addFormSection:(nonnull GTUIFormSectionDescriptor *)formSection afterSection:(nonnull GTUIFormSectionDescriptor *)afterSection;
-(void)addFormRow:(nonnull GTUIFormRowDescriptor *)formRow beforeRow:(nonnull GTUIFormRowDescriptor *)afterRow;
-(void)addFormRow:(nonnull GTUIFormRowDescriptor *)formRow beforeRowTag:(nonnull NSString *)afterRowTag;
-(void)addFormRow:(nonnull GTUIFormRowDescriptor *)formRow afterRow:(nonnull GTUIFormRowDescriptor *)afterRow;
-(void)addFormRow:(nonnull GTUIFormRowDescriptor *)formRow afterRowTag:(nonnull NSString *)afterRowTag;
-(void)removeFormSectionAtIndex:(NSUInteger)index;
-(void)removeFormSection:(nonnull GTUIFormSectionDescriptor *)formSection;
-(void)removeFormRow:(nonnull GTUIFormRowDescriptor *)formRow;
-(void)removeFormRowWithTag:(nonnull NSString *)tag;

-(nullable GTUIFormRowDescriptor *)formRowWithTag:(nonnull NSString *)tag;
-(nullable GTUIFormRowDescriptor *)formRowAtIndex:(nonnull NSIndexPath *)indexPath;
-(nullable GTUIFormRowDescriptor *)formRowWithHash:(NSUInteger)hash;
-(nullable GTUIFormSectionDescriptor *)formSectionAtIndex:(NSUInteger)index;

-(nullable NSIndexPath *)indexPathOfFormRow:(nonnull GTUIFormRowDescriptor *)formRow;

-(nonnull NSDictionary *)formValues;
-(nonnull NSDictionary *)httpParameters:(nonnull GTUIFormViewController *)formViewController;

-(nonnull NSArray *)localValidationErrors:(nonnull GTUIFormViewController *)formViewController;
-(void)setFirstResponder:(nonnull GTUIFormViewController *)formViewController;

-(nullable GTUIFormRowDescriptor *)nextRowDescriptorForRow:(nonnull GTUIFormRowDescriptor *)currentRow;
-(nullable GTUIFormRowDescriptor *)previousRowDescriptorForRow:(nonnull GTUIFormRowDescriptor *)currentRow;

-(void)forceEvaluate;

@end
