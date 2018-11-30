//
//  GTUILoadingView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "GTUILoadingBaseView.h"

@interface GTUILoadingView : GTUILoadingBaseView

/** 内容物上每个子控件之间的间距 default is 20.f  */
@property (nonatomic, assign) CGFloat  subViewMargin;

/** 内容物-垂直方向偏移 (此属性与contentViewY 互斥，只有一个会有效)  */
@property (nonatomic, assign) CGFloat  contentViewOffset;

/** 内容物-Y坐标 (此属性与contentViewOffset 互斥，只有一个会有效) */
@property (nonatomic, assign) CGFloat  contentViewY;

#pragma mark - image 相关属性配置

/** 图片可设置固定大小 (default=图片实际大小)  */
@property (nonatomic, assign) CGSize   imageSize;


#pragma mark - titleLabel 相关属性配置

/** 标题字体, 大小default is 16.f */
@property (nonatomic, strong) UIFont   *titleLabFont;

/**  标题文字颜色 */
@property (nonatomic, strong) UIColor  *titleLabTextColor;

@end
