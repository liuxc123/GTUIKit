//
//  GTUIRelativeLayout.h
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUIBaseLayout.h"

NS_ASSUME_NONNULL_BEGIN

/**
 相对布局是一种里面的子视图通过相互之间的约束和依赖来进行布局和定位的布局视图。
 相对布局里面的子视图的布局位置和添加的顺序无关，而是通过设置子视图的相对依赖关系来进行定位和布局的。
 相对布局提供了和AutoLayout相似的能力。
 */
@interface GTUIRelativeLayout : GTUIBaseLayout

@end

NS_ASSUME_NONNULL_END
