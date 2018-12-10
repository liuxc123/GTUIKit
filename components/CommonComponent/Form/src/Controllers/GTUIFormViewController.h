//
//  GTUIFormViewController.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <UIKit/UIKit.h>
#import "GTUIFormOptionsViewController.h"
#import "GTUIFormDescriptor.h"
#import "GTUIFormSectionDescriptor.h"
#import "GTUIFormDescriptorDelegate.h"
#import "GTUIFormRowNavigationAccessoryView.h"
#import "GTUIFormBaseCell.h"

@class GTUIFormViewController;
@class GTUIFormRowDescriptor;
@class GTUIFormSectionDescriptor;
@class GTUIFormDescriptor;
@class GTUIFormBaseCell;

typedef NS_ENUM(NSUInteger, GTUIFormRowNavigationDirection) {
    GTUIFormRowNavigationDirectionPrevious = 0,
    GTUIFormRowNavigationDirectionNext
};

@protocol GTUIFormViewControllerDelegate <NSObject>

@optional

-(void)didSelectFormRow:(GTUIFormRowDescriptor *)formRow;
-(void)deselectFormRow:(GTUIFormRowDescriptor *)formRow;
-(void)reloadFormRow:(GTUIFormRowDescriptor *)formRow;
-(GTUIFormBaseCell *)updateFormRow:(GTUIFormRowDescriptor *)formRow;

-(NSDictionary *)formValues;
-(NSDictionary *)httpParameters;

-(GTUIFormRowDescriptor *)formRowFormMultivaluedFormSection:(GTUIFormSectionDescriptor *)formSection;
-(void)multivaluedInsertButtonTapped:(GTUIFormRowDescriptor *)formRow;
-(UIStoryboard *)storyboardForRow:(GTUIFormRowDescriptor *)formRow;

-(NSArray *)formValidationErrors;
-(void)showFormValidationError:(NSError *)error;
-(void)showFormValidationError:(NSError *)error withTitle:(NSString*)title;

-(UITableViewRowAnimation)insertRowAnimationForRow:(GTUIFormRowDescriptor *)formRow;
-(UITableViewRowAnimation)deleteRowAnimationForRow:(GTUIFormRowDescriptor *)formRow;
-(UITableViewRowAnimation)insertRowAnimationForSection:(GTUIFormSectionDescriptor *)formSection;
-(UITableViewRowAnimation)deleteRowAnimationForSection:(GTUIFormSectionDescriptor *)formSection;

// InputAccessoryView
-(UIView *)inputAccessoryViewForRowDescriptor:(GTUIFormRowDescriptor *)rowDescriptor;
-(GTUIFormRowDescriptor *)nextRowDescriptorForRow:(GTUIFormRowDescriptor*)currentRow withDirection:(GTUIFormRowNavigationDirection)direction;

// highlight/unhighlight
-(void)beginEditing:(GTUIFormRowDescriptor *)rowDescriptor;
-(void)endEditing:(GTUIFormRowDescriptor *)rowDescriptor;

-(void)ensureRowIsVisible:(GTUIFormRowDescriptor *)inlineRowDescriptor;

@end

@interface GTUIFormViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GTUIFormDescriptorDelegate, UITextFieldDelegate, UITextViewDelegate, GTUIFormViewControllerDelegate>

@property GTUIFormDescriptor * form;
@property IBOutlet UITableView * tableView;

-(instancetype)initWithForm:(GTUIFormDescriptor *)form;
-(instancetype)initWithForm:(GTUIFormDescriptor *)form style:(UITableViewStyle)style;
-(instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;
+(NSMutableDictionary *)cellClassesForRowDescriptorTypes;
+(NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes;

-(void)performFormSelector:(SEL)selector withObject:(id)sender;

@end
