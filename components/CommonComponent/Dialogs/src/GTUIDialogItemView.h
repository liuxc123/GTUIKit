//
//  GTUIDialogItemView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/26.
//

#import <UIKit/UIKit.h>
#import "GTUIDialog.h"
#import "GTButton.h"
#import "GTUIDialogAction.h"

/** 视图数据 */
@interface GTUIDialogItem : NSObject

/** item类型 */
@property (nonatomic , assign ) GTUIItemType type;

/** item间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** item设置视图Block */
@property (nonatomic , copy ) void (^block)(id view);

/** item更新视图Block*/
@property (nonatomic , copy ) void (^updateBlock)(GTUIDialogItem *);

- (void)update;

@end

/** 视图容器 */
@interface GTUIDialogItemView : UIView

@property (nonatomic , strong) GTUIDialogItem *item;

+ (GTUIDialogItemView *)view;

@end

/** Label视图 */
@interface GTUIDialogItemLabel : UILabel

@property (nonatomic , strong ) GTUIDialogItem *item;

@property (nonatomic , copy ) void (^textChangedBlock)(void);

+ (GTUIDialogItemLabel *)label;

@end

@interface GTUIDialogItemTextField : UITextField

@property (nonatomic , strong ) GTUIDialogItem *item;

+ (GTUIDialogItemTextField *)textField;

@end


@interface GTUIDialogActionButton : GTUIButton

@property (nonatomic , strong ) GTUIDialogAction *action;

@property (nonatomic , copy ) void (^heightChangedBlock)(void);

+ (GTUIDialogAction *)button;

@end

@interface GTUIDialogItemCustomView : NSObject

/** 自定义视图对象 */
@property (nonatomic , strong, nonnull ) UIView *view;

/** 自定义视图位置类型 (默认为居中) */
@property (nonatomic , assign ) GTUICustomViewPositionType positionType;

/** 是否自动适应宽度 */
@property (nonatomic , assign ) BOOL isAutoWidth;

@property (nonatomic , strong ) GTUIDialogItem *item;

@property (nonatomic , assign ) CGSize size;

@property (nonatomic , copy ) void (^sizeChangedBlock)(void);

@end
