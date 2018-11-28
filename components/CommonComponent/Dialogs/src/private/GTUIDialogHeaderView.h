//
//  GTUIDialogHeaderView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/26.
//

#import <UIKit/UIKit.h>
#import "GTUIDialog.h"

@interface GTUIDialogHeaderView : UIView

- (nonnull instancetype)initWithFrame:(CGRect)frame;

/** Header must be created with initWithFrame */
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_UNAVAILABLE;

/** 配置信息 */
@property(nonatomic, copy, nullable) GTUIDialogConfigModel *configModel;

@property (nonatomic, nullable, copy) NSString *title;

@property (nonatomic, nullable, copy) NSString *message;

@property (nonatomic, nullable, strong) UIView *customView;

@property(nonatomic, setter=gtui_setAdjustsFontForContentSizeCategory:)
BOOL gtui_adjustsFontForContentSizeCategory;

@property (nonatomic, strong, nonnull) UIFont *titleFont;

@property (nonatomic, strong, nonnull) UIFont *messageFont;

@property(nonatomic, strong, nullable) UIColor *titleTextColor;

@property(nonatomic, strong, nullable) UIColor *messageTextColor;

@property(nonatomic, assign) GTUICustomViewPositionType customViewPositionType;

@end
