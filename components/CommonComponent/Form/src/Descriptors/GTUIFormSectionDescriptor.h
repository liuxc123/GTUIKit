//
//  GTUIFormSectionDescriptor.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTUIFormRowDescriptor.h"

typedef NS_OPTIONS(NSUInteger, GTUIFormSectionOptions) {
    GTUIFormSectionOptionNone        = 0,
    GTUIFormSectionOptionCanInsert   = 1 << 0,
    GTUIFormSectionOptionCanDelete   = 1 << 1,
    GTUIFormSectionOptionCanReorder  = 1 << 2
};

typedef NS_ENUM(NSUInteger, GTUIFormSectionInsertMode) {
    GTUIFormSectionInsertModeLastRow = 0,
    GTUIFormSectionInsertModeButton = 2
};

@class GTUIFormDescriptor;

@interface GTUIFormSectionDescriptor : NSObject

@property (nonatomic, nullable) NSString * title;
@property (nonatomic, nullable) NSString * footerTitle;
@property (readonly, nonnull) NSMutableArray * formRows;
@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat footerHeight;
@property (nonatomic, nullable) UIView *customHeaderView;
@property (nonatomic, nullable) UIView *customFooterView;


@property (nonatomic, assign) BOOL cellTitleEqualWidth;
@property (nonatomic) CGFloat cellTitleMaxWidth;

@property (readonly) GTUIFormSectionInsertMode sectionInsertMode;
@property (readonly) GTUIFormSectionOptions sectionOptions;
@property (nullable) GTUIFormRowDescriptor * multivaluedRowTemplate;
@property (readonly, nullable) GTUIFormRowDescriptor * multivaluedAddButton;
@property (nonatomic, nullable) NSString * multivaluedTag;

@property (weak, null_unspecified) GTUIFormDescriptor * formDescriptor;

@property (nonnull) id hidden;
-(BOOL)isHidden;

+(nonnull instancetype)formSection;
+(nonnull instancetype)formSectionWithTitle:(nullable NSString *)title;
+(nonnull instancetype)formSectionWithTitle:(nullable NSString *)title sectionOptions:(GTUIFormSectionOptions)sectionOptions;
+(nonnull instancetype)formSectionWithTitle:(nullable NSString *)title sectionOptions:(GTUIFormSectionOptions)sectionOptions sectionInsertMode:(GTUIFormSectionInsertMode)sectionInsertMode;

-(BOOL)isMultivaluedSection;
-(void)addFormRow:(nonnull GTUIFormRowDescriptor *)formRow;
-(void)addFormRow:(nonnull GTUIFormRowDescriptor *)formRow afterRow:(nonnull GTUIFormRowDescriptor *)afterRow;
-(void)addFormRow:(nonnull GTUIFormRowDescriptor *)formRow beforeRow:(nonnull GTUIFormRowDescriptor *)beforeRow;
-(void)removeFormRowAtIndex:(NSUInteger)index;
-(void)removeFormRow:(nonnull GTUIFormRowDescriptor *)formRow;
-(void)moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndex toIndexPath:(nonnull NSIndexPath *)destinationIndex;

@end
