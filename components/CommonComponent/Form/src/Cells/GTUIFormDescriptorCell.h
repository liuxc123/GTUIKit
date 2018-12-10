//
//  GTUIFormDescriptorCell.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <UIKit/UIKit.h>

@class GTUIFormRowDescriptor;
@class GTUIFormViewController;

@protocol GTUIFormDescriptorCell <NSObject>

@required

@property (nonatomic, weak) GTUIFormRowDescriptor * rowDescriptor;
-(void)configure;
-(void)update;

@optional

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(GTUIFormRowDescriptor *)rowDescriptor;
-(BOOL)formDescriptorCellCanBecomeFirstResponder;
-(BOOL)formDescriptorCellBecomeFirstResponder;
-(void)formDescriptorCellDidSelectedWithFormController:(GTUIFormViewController *)controller;
-(NSString *)formDescriptorHttpParameterName;


-(void)highlight;
-(void)unhighlight;

@end
