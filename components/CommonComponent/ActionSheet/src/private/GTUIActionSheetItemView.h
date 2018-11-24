//
//  GTUIActionSheetItemView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import <UIKit/UIKit.h>
#import "GTInk.h"
#import "GTUIActionSheetController.h"
#import "GTUIActionSheet.h"

@interface GTUIActionSheetItemView : UIView

- (instancetype)initWithType:(GTUIActionSheetType)type;

@property (nonatomic, assign) GTUIActionSheetType type;

@property(nonatomic, nonnull) GTUIActionSheetAction *action;

@property(nonatomic, setter=gtui_setAdjustsFontForContentSizeCategory:)
BOOL gtui_adjustsFontForContentSizeCategory;

@property(nonatomic, nonnull, strong) UIFont *actionFont;

@property(nonatomic, strong, nullable) UIColor *actionTextColor;

@property(nonatomic, strong, nullable) UIColor *inkColor;

@property(nonatomic) UIImageRenderingMode imageRenderingMode;




@end
