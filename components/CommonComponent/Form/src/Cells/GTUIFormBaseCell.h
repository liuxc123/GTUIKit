//
//  GTUIFormBaseCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <UIKit/UIKit.h>
#import "GTUIFormDescriptorCell.h"
#import "GTUIFormViewController.h"

@class GTUIFormViewController;
@class GTUIFormRowDescriptor;

@interface GTUIFormBaseCell : UITableViewCell <GTUIFormDescriptorCell>

@property (nonatomic, weak) GTUIFormRowDescriptor * rowDescriptor;

@property (nonatomic, strong) NSIndexPath *indexPath;

-(GTUIFormViewController *)formViewController;

@end

@protocol GTUIFormReturnKeyProtocol

@property UIReturnKeyType returnKeyType;
@property UIReturnKeyType nextReturnKeyType;

@end
