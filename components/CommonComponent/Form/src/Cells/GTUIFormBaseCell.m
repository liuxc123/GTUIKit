//
//  GTUIFormBaseCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTUIFormBaseCell.h"

@implementation GTUIFormBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configure];
}

- (void)configure
{

}

- (void)update
{
    self.accessoryType = self.rowDescriptor.accessoryType;
    self.selectionStyle = self.rowDescriptor.selectionStyle;
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textLabel.textColor  = self.rowDescriptor.isDisabled ? [UIColor grayColor] : [UIColor blackColor];
}


- (void)highlight
{

}

- (void)unhighlight
{

}


- (GTUIFormViewController *)formViewController
{
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[GTUIFormViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}


#pragma mark - Navigation Between Fields

-(UIView *)inputAccessoryView
{
    UIView * inputAccessoryView = [self.formViewController inputAccessoryViewForRowDescriptor:self.rowDescriptor];
    if (inputAccessoryView){
        return inputAccessoryView;
    }
    return [super inputAccessoryView];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return NO;
}


#pragma mark -

-(BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    if (result){
        [self.formViewController beginEditing:self.rowDescriptor];
    }
    return result;
}

-(BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    if (result){
        [self.formViewController endEditing:self.rowDescriptor];
    }
    return result;
}

@end
