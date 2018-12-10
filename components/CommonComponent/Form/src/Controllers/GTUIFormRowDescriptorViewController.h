//
//  GTUIFormRowDescriptorViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/23.
//

#import <Foundation/Foundation.h>

@class GTUIFormRowDescriptor;

@protocol GTUIFormRowDescriptorViewController <NSObject>

@required
@property (nonatomic) GTUIFormRowDescriptor * rowDescriptor;

@end
