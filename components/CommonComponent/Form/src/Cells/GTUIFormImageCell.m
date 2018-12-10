//
//  GTUIFormImageCell.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormImageCell.h"
#import "GTUIFormRowDescriptor.h"
#import "UIView+GTUIFormAdditions.h"

@interface GTUIFormImageCell() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *imagePickerController;
    UIAlertController *alertController;
}

@end

@implementation GTUIFormImageCell

#pragma mark - GTUIFormDescriptorCell
+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(GTUIFormRowDescriptor *)rowDescriptor
{
    return 40;
}

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.editingAccessoryView = self.accessoryView;
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.imageView.image = self.rowDescriptor.value;
}

- (void)chooseImage:(UIImage *)image
{
    self.imageView.image = image;
    self.rowDescriptor.value = image;
}

- (UIImageView *)imageView
{
    return (UIImageView *)self.accessoryView;
}

- (void)formDescriptorCellDidSelectedWithFormController:(GTUIFormViewController *)controller
{
    alertController = [UIAlertController alertControllerWithTitle: self.rowDescriptor.title
                                                          message: nil
                                                   preferredStyle: UIAlertControllerStyleActionSheet];

    [alertController addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Choose From Library", nil)
                                                        style: UIAlertActionStyleDefault
                                                      handler: ^(UIAlertAction * _Nonnull action) {
                                                          [self openImage:UIImagePickerControllerSourceTypePhotoLibrary];
                                                      }]];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertController addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Take Photo", nil)
                                                            style: UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction * _Nonnull action) {
                                                              [self openImage:UIImagePickerControllerSourceTypeCamera];
                                                          }]];
    }

    [alertController addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Cancel", nil)
                                                        style: UIAlertActionStyleCancel
                                                      handler: nil]];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.modalPresentationStyle = UIModalPresentationPopover;
        alertController.popoverPresentationController.sourceView = self.contentView;
        alertController.popoverPresentationController.sourceRect = self.contentView.bounds;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.formViewController presentViewController:self->alertController animated: true completion: nil];
    });
}

- (void)openImage:(UIImagePickerControllerSourceType)source
{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = source;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        imagePickerController.modalPresentationStyle = UIModalPresentationPopover;
        imagePickerController.popoverPresentationController.sourceRect = self.contentView.frame;
        imagePickerController.popoverPresentationController.sourceView = self.formViewController.view;
        imagePickerController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }

    [self.formViewController presentViewController: imagePickerController
                                          animated: YES
                                        completion: nil];
}

#pragma mark -  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    if (editedImage) {
        [self chooseImage:editedImage];
    } else {
        [self chooseImage:originalImage];
    }

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (self.formViewController.presentedViewController && self.formViewController.presentedViewController.modalPresentationStyle == UIModalPresentationPopover) {
            [self.formViewController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self.formViewController dismissViewControllerAnimated: YES completion: nil];
    }
}


@end
