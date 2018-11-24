//
//  GTUIActionSheetItemTableViewCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import "GTUIActionSheetItemTableViewCell.h"
#import "GTTypography.h"

static const CGFloat kLabelAlpha = 0.87f;
static const CGFloat kImageLeadingPadding = 16.f;
static const CGFloat kImageTopPadding = 16.f;
static const CGFloat kImageHeightAndWidth = 24.f;
static const CGFloat kTitleLeadingPadding = 72.f;
static const CGFloat kTitleTrailingPadding = 16.f;
static const CGFloat kActionItemTitleVerticalPadding = 18.f;

@interface GTUIActionSheetItemTableViewCell ()

@end

@implementation GTUIActionSheetItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonGTUIActionSheetItemViewInit];
        [self commonLayout];
    }
    return self;
}

- (void)commonGTUIActionSheetItemViewInit {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessibilityTraits = UIAccessibilityTraitButton;

    _itemView = [[GTUIActionSheetItemView alloc] initWithType:GTUIActionSheetTypeNormal];
    [self.contentView addSubview:_itemView];
    _itemView.translatesAutoresizingMaskIntoConstraints = NO;

}

- (void)commonLayout {

    // actionLabel
    [NSLayoutConstraint constraintWithItem:_itemView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0]
    .active = YES;

    [NSLayoutConstraint constraintWithItem:_itemView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0]
    .active = YES;

    [NSLayoutConstraint constraintWithItem:_itemView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0]
    .active = YES;

    [NSLayoutConstraint constraintWithItem:_itemView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0]
    .active = YES;

    [NSLayoutConstraint constraintWithItem:_itemView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:50]
    .active = YES;
}

@end
