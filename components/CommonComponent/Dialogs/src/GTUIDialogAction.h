//
//  GTUIDialogAction.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/27.
//

#import <UIKit/UIKit.h>
#import "GTUIDialog.h"

@class GTUIDialogAction;

/**
 GTUIActionHandler is a block that will be invoked when the action is selected.
 */
typedef void (^GTUIActionHandler)(GTUIDialogAction *_Nonnull action);

@interface GTUIDialogAction : NSObject <NSCopying, UIAccessibilityIdentification>


+ (nonnull instancetype)actionWithTitle:(nonnull NSString *)title
                                handler:(__nullable GTUIActionHandler)handler;

+ (nonnull instancetype)actionWithTitle:(nonnull NSString *)title
                             actionType:(GTUIActionType)actionType
                                handler:(__nullable GTUIActionHandler)handler;

+ (nonnull instancetype)actionWithTitle:(nonnull NSString *)title
                                  image:(nonnull UIImage *)image
                             actionType:(GTUIActionType)actionType
                                handler:(__nullable GTUIActionHandler)handler;

/** action类型 */
@property (nonatomic , assign ) GTUIActionType type;

/** action标题 */
@property (nonatomic , strong ) NSString *title;

/** action高亮标题 */
@property (nonatomic , strong ) NSString *highlight;

/** action标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedTitle;

/** action高亮标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedHighlight;

/** action字体 */
@property (nonatomic , strong ) UIFont *font;

/** action标题颜色 */
@property (nonatomic , strong ) UIColor *titleColor;

/** action高亮标题颜色 */
@property (nonatomic , strong ) UIColor *highlightColor;

/** action背景颜色 (与 backgroundImage 相同) */
@property (nonatomic , strong ) UIColor *backgroundColor;

/** action高亮背景颜色 */
@property (nonatomic , strong ) UIColor *backgroundHighlightColor;

/** action背景图片 (与 backgroundColor 相同) */
@property (nonatomic , strong ) UIImage *backgroundImage;

/** action高亮背景图片 */
@property (nonatomic , strong ) UIImage *backgroundHighlightImage;

/** action图片 */
@property (nonatomic , strong ) UIImage *image;

/** action高亮图片 */
@property (nonatomic , strong ) UIImage *highlightImage;

/** action间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** action图片的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets imageEdgeInsets;

/** action标题的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets titleEdgeInsets;

/** action圆角曲率 */
@property (nonatomic , assign ) CGFloat cornerRadius;

/** action高度 */
@property (nonatomic , assign ) CGFloat height;

/** action边框宽度 */
@property (nonatomic , assign ) CGFloat borderWidth;

/** action边框颜色 */
@property (nonatomic , strong ) UIColor *borderColor;

/** action边框位置 */
@property (nonatomic , assign ) GTUIActionBorderPosition borderPosition;

/** 标记Id */
@property(nonatomic, nullable, copy) NSString *accessibilityIdentifier;

/** action点击不关闭 (仅适用于默认类型) */
@property (nonatomic , assign ) BOOL isClickNotClose;

/** action点击事件回调Block */
@property (nonatomic , copy ) void (^clickBlock)(void);

/** action点击事件回调Block */
@property(nonatomic, nullable, copy) GTUIActionHandler completionHandler;

/** 更新Block */
@property (nonatomic , copy ) void (^updateBlock)(GTUIDialogAction *);

/** 更新 */
- (void)update;

@end

