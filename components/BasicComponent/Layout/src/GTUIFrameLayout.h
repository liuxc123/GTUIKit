//
//  GTUIFrameLayout.h
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUIBaseLayout.h"

NS_ASSUME_NONNULL_BEGIN

/**
 框架布局是一种里面的子视图停靠在父视图特定方位并且可以重叠的布局视图。框架布局里面的子视图的布局位置和添加的顺序无关，框架布局中的所有子视图的约束依赖都只是针对于和父布局视图的。框架布局是一种特殊的相对布局，因此如果某些布局里面的子视图只依赖于父视图的边界时则可以用框架布局来代替，从而加快布局的速度。
 */
@interface GTUIFrameLayout : GTUIBaseLayout

@end

NS_ASSUME_NONNULL_END
