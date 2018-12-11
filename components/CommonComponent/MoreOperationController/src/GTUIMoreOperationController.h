//
//  GTUIMoreOperationController.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/11.
//

#import <UIKit/UIKit.h>
#import "GTButton.h"

/// 操作面板上item的类型，GTUIMoreOperationItemTypeImportant类型的item会放到第一行的scrollView，GTUIMoreOperationItemTypeNormal类型的item会放到第二行的scrollView。
typedef NS_ENUM(NSInteger, GTUIMoreOperationItemType) {
    GTUIMoreOperationItemTypeImportant, // 将item放在第一行显示
    GTUIMoreOperationItemTypeNormal     // 将item放在第二行显示
};

@class GTUIMoreOperationController;
@class GTUIMoreOperationItemView;

/// 更多操作面板的delegate。
@protocol GTUIMoreOperationDelegate <NSObject>

@optional
/// 即将显示操作面板
- (void)willPresentMoreOperationController:(GTUIMoreOperationController *)moreOperationController;
/// 已经显示操作面板
- (void)didPresentMoreOperationController:(GTUIMoreOperationController *)moreOperationController;
/// 即将降下操作面板，cancelled参数是用来区分是否触发了maskView或者cancelButton按钮降下面板还是手动调用hide方法来降下面板。
- (void)willDismissMoreOperationController:(GTUIMoreOperationController *)moreOperationController cancelled:(BOOL)cancelled;
/// 已经降下操作面板，cancelled参数是用来区分是否触发了maskView或者cancelButton按钮降下面板还是手动调用hide方法来降下面板。
- (void)didDismissMoreOperationController:(GTUIMoreOperationController *)moreOperationController cancelled:(BOOL)cancelled;
/// 点击了操作面板上的一个item，可以通过参数拿到当前item的index和type
- (void)moreOperationController:(GTUIMoreOperationController *)moreOperationController didSelectItemAtIndex:(NSInteger)buttonIndex type:(GTUIMoreOperationItemType)type;
/// 点击了操作面板上的一个item，可以通过参数拿到当前item的tag
- (void)moreOperationController:(GTUIMoreOperationController *)moreOperationController didSelectItemAtTag:(NSInteger)tag;

@end

@interface GTUIMoreOperationItemView : GTUIButton

@property (nonatomic, assign, readonly) GTUIMoreOperationItemType itemType;

@end

@interface GTUIMoreOperationController : UIViewController

@property(nonatomic, strong) UIColor *contentBackgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *contentSeparatorColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *cancelButtonBackgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *cancelButtonTitleColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *cancelButtonSeparatorColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *itemBackgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *itemTitleColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIFont  *itemTitleFont UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIFont  *cancelButtonFont UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign) CGFloat contentEdgeMargin UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign) CGFloat contentMaximumWidth UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign) CGFloat contentCornerRadius UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign) CGFloat itemTitleMarginTop UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign) UIEdgeInsets topScrollViewInsets UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign) UIEdgeInsets bottomScrollViewInsets UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign) CGFloat cancelButtonHeight UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign) CGFloat cancelButtonMarginTop UI_APPEARANCE_SELECTOR;

/// 代理
@property(nonatomic, weak) id<GTUIMoreOperationDelegate> delegate;

/// 获取当前所有的item
@property(nonatomic, copy, readonly) NSArray *items;

/// 获取取消按钮
@property(nonatomic, strong, readonly) GTUIButton *cancelButton;

/// 更多操作面板是否正在显示
@property(nonatomic, assign, getter=isShowing, readonly) BOOL showing;
@property(nonatomic, assign, getter=isAnimating, readonly) BOOL animating;

/// 下面几个`addItem`方法，是用来往面板里面增加item的
- (NSInteger)addItemWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle image:(UIImage *)image selectedImage:(UIImage *)selectedImage type:(GTUIMoreOperationItemType)itemType tag:(NSInteger)tag;
- (NSInteger)addItemWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle image:(UIImage *)image selectedImage:(UIImage *)selectedImage type:(GTUIMoreOperationItemType)itemType;
- (NSInteger)addItemWithTitle:(NSString *)title image:(UIImage *)image type:(GTUIMoreOperationItemType)itemType tag:(NSInteger)tag;
- (NSInteger)addItemWithTitle:(NSString *)title image:(UIImage *)image type:(GTUIMoreOperationItemType)itemType;

/// 初始化一个item，并通过下面的`insertItem`来将item插入到面板的某个位置
- (GTUIMoreOperationItemView *)createItemWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle image:(UIImage *)image selectedImage:(UIImage *)selectedImage type:(GTUIMoreOperationItemType)itemType tag:(NSInteger)tag;

/// 将通过上面初始化的一个item插入到某个位置
- (BOOL)insertItem:(GTUIMoreOperationItemView *)itemView toIndex:(NSInteger)index;

/// 获取某种类型上的item
- (GTUIMoreOperationItemView *)itemAtIndex:(NSInteger)index type:(GTUIMoreOperationItemType)type;

/// 获取某个tag的item
- (GTUIMoreOperationItemView *)itemAtTag:(NSInteger)tag;

/// 下面两个`setItemHidden`方法可以隐藏某一个item
- (void)setItemHidden:(BOOL)hidden index:(NSInteger)index type:(GTUIMoreOperationItemType)type;
/// 同上
- (void)setItemHidden:(BOOL)hidden tag:(NSInteger)tag;

@end

@interface GTUIMoreOperationController (UIAppearance)

+ (instancetype)appearance;

@end
