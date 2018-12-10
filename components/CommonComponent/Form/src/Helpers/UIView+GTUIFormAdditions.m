//
//  UIView+GTUIFormAdditions.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "UIView+GTUIFormAdditions.h"

@implementation UIView (GTUIFormAdditions)

+ (id)autolayoutView {
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (NSLayoutConstraint *)layoutConstraintSameHeightOf:(UIView *)view {
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
}

- (UIView *)findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

- (UITableViewCell<GTUIFormDescriptorCell> *)formDescriptorCell {
    if ([self isKindOfClass:[UITableViewCell class]]) {
        if ([self conformsToProtocol:@protocol(GTUIFormDescriptorCell)]) {
            return (UITableViewCell<GTUIFormDescriptorCell> *)self;
        }
        return nil;
    }
    if (self.superview) {
        UITableViewCell<GTUIFormDescriptorCell> * tableViewCell = [self.superview formDescriptorCell];
        if (tableViewCell != nil) {
            return tableViewCell;
        }
    }
    return nil;
}

@end
