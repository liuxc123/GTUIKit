//
//  UIView+GTUIFormAdditions.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <UIKit/UIKit.h>
#import "GTUIFormDescriptorCell.h"

@interface UIView (GTUIFormAdditions)

+ (id)autolayoutView;

- (NSLayoutConstraint *)layoutConstraintSameHeightOf:(UIView *)view;

- (UIView *)findFirstResponder;

- (UITableViewCell<GTUIFormDescriptorCell> *)formDescriptorCell;

@end
