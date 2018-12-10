//
//  GTUIFormDescriptorDelegate.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTUIFormDescriptor.h"

@class GTUIFormSectionDescriptor;

typedef NS_ENUM(NSUInteger, GTCPredicateType) {
    GTCPredicateTypeDisabled = 0,
    GTCPredicateTypeHidden
};


@protocol GTUIFormDescriptorDelegate <NSObject>

@required

-(void)formSectionHasBeenRemoved:(GTUIFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;
-(void)formSectionHasBeenAdded:(GTUIFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;
-(void)formRowHasBeenAdded:(GTUIFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath;
-(void)formRowHasBeenRemoved:(GTUIFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath;
-(void)formRowDescriptorValueHasChanged:(GTUIFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue;
-(void)formRowDescriptorPredicateHasChanged:(GTUIFormRowDescriptor *)formRow
                                   oldValue:(id)oldValue
                                   newValue:(id)newValue
                              predicateType:(GTCPredicateType)predicateType;

@end
