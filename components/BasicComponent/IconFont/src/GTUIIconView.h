//
//  GTUIIconView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/9.
//

#import <UIKit/UIKit.h>

#define kICONFONT_FONTNAME (@"iconfont")

@interface  GTUIIconView : UIImageView

@property (nonatomic, strong) UIColor *color;       // 矢量图颜色（默认蓝色）
@property (nonatomic, strong) NSString *name;       // 矢量图名称
@property (nonatomic, strong) NSString *fontName;   // 矢量图字库名称
@property (nonatomic, assign) UIEdgeInsets imageInsets;   // 矢量图与图片内间距

/**
 初始化方法
 @param frame 视图 frame
 @param name  iconfont 图片名称
 @return GTUIIconView实例
 */
- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name;

/**
 初始化方法
 （如果该种 iconfont 字体已经加载过，则不需要传入 fontPath 也可以渲染）
 @param frame    视图 frame
 @param name     iconfont 图片名称
 @param fontName iconfont 字体名称
 @return GTUIIconView 实例
 */
- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name fontName:(NSString *)fontName;

/**
 初始化方法
 （如果该种 iconfont 字体已经加载过，则不需要传入 fontPath 也可以渲染）
 @param frame    视图 frame
 @param name     iconfont 图片名称
 @param fontName iconfont 字体名称
 @param color    color 字体颜色
 @return GTUIIconView 实例
 */
- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name fontName:(NSString *)fontName color:(UIColor *)color;

/**
 获取 iconView 的 size
 @return 如果是 iconfont，返回的是 iconfont 的 size，如果是普通的 imageview 返回的是 image 的 size
 */
- (CGSize)iconViewSize;

@end


@interface UIImage (GTUIIconFont)

/**
 注册 iconfont（只需要调用一次）
 @param fontName iconfont 字体名称
 @param fontPath iconfont 路径（如 @"GTUIKit.bundle/iconfont/auiconfont"）
 */
+ (void)registerIconFont:(NSString *)fontName fontPath:(NSString *)fontPath;


+ (void)registerIconFont:(NSString *)fontName fontPathURL:(NSURL *)fontPathURL;

/**
 获取一个正方形矢量图（长和宽相等）
 @param name  名称
 @param width 大小
 @param color 图像颜色，传 nil，默认为蚂蚁蓝
 @return 正方形矢量图
 */
+ (UIImage *)iconWithName:(NSString *)name
                    width:(CGFloat)width
                    color:(UIColor *)color;
/**
 获取一个正方形矢量图（长和宽相等）
 @param name        名称
 @param fontName    矢量字体名称
 @param width       大小
 @param color       图像颜色，传 nil，默认为蚂蚁蓝
 @return 正方形矢量图
 */
+ (UIImage *)iconWithName:(NSString *)name
                 fontName:(NSString *)fontName
                    width:(CGFloat)width
                    color:(UIColor *)color;

/**
 获取一个正方形矢量图（长和宽相等）
 @param name        名称
 @param fontName    矢量字体名称
 @param imageInsets 矢量字体与图片边框之间间距
 @param width       大小
 @param color       图像颜色，传 nil，默认为蚂蚁蓝
 @return 正方形矢量图
 */
+ (UIImage *)iconWithName:(NSString *)name
                 fontName:(NSString *)fontName
              imageInsets:(UIEdgeInsets)imageInsets
                    width:(CGFloat)width
                    color:(UIColor *)color;


@end
