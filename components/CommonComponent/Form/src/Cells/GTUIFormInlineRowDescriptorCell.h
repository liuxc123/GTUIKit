//
//  GTUIFormInlineRowDescriptorCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTUIFormDescriptorCell.h"

@protocol GTUIFormInlineRowDescriptorCell <GTUIFormDescriptorCell>

@property (nonatomic, weak) GTUIFormRowDescriptor * inlineRowDescriptor;

@end
