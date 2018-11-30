//
//  GTUILoadingBaseView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import <UIKit/UIKit.h>

@interface GTUILoadingBaseView : UIView

/** 内容物背景视图 */
@property (nonatomic,strong,readonly) UIView *contentView;

/** 属性传递 (这些属性只用来传递，修改无效) */
@property (nonatomic, copy) NSString *imageStr;
@property (nonatomic, copy) NSArray<NSString *> *imageStrArray;
@property (nonatomic, copy) NSData *gifImageData;
@property (nonatomic, copy) NSString *titleStr;

/** 属性传递 (这些属性只用来传递，修改无效) */
@property (nonatomic,strong,readonly)   UIView *customView;

/** 初始化配置 */
- (void)prepare;

/** 重置Subviews */
- (void)setupSubviews;



/**
 构造方法1 - 创建loadingView

 @param imageStr      loading图片名称
 @param titleStr      占位描述
 @return 返回一个图片的loadingView
 */
+ (instancetype)loadingViewWithImageStr:(NSString *)imageStr
                               titleStr:(NSString *)titleStr;

/**
 构造方法2 - 创建loadingView

 @param imageStrArray 图片数组（多张png）加载动图
 @param titleStr      占位描述
 @return 返回一个一组图片动画的的loadingView
 */
+ (instancetype)loadingViewWithImageStrArray:(NSArray<NSString *> *)imageStrArray
                                    titleStr:(NSString *)titleStr;

/**
 构造方法3 - 创建一个自定义的loadingView

 @param customView 自定义view
 @return 返回一个自定义内容的loadingView
 */
+ (instancetype)loadingViewWithCustomView:(UIView *)customView;

/**
 构造方法4 - 创建一个自定义的loadingView

 @param customView 自定义view
 @param titleStr      占位描述
 @return 返回一个自定义内容的loadingView
 */
+ (instancetype)loadingViewWithCustomView:(UIView *)customView titleStr:(NSString *)titleStr;

@end
