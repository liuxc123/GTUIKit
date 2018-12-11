//
//  GTUILayoutPosition.h
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUILayoutDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUILayoutPosition : NSObject <NSCopying>

#if GTUIKIT_DEFINE_AS_PROPERTIES

/**
 特殊的位置。只用在布局视图和非布局父视图之间的位置约束和没有导航条时的布局视图内子视图的padding设置上。
 iOS11以后提出了安全区域的概念，因此对于iOS11以下的版本就需要兼容处理，尤其是在那些没有导航条的情况下。通过将布局视图的边距设置为这个特殊值就可以实现在任何版本中都能完美的实现位置的偏移而且各版本保持统一。比如下面的例子：
 
 @code
 
 //这里设置布局视图的左边和右边以及顶部的边距都是在父视图的安全区域外再缩进10个点的位置。你会注意到这里面定义了一个特殊的位置GTUILayoutPosition.safeAreaMargin。
 //GTUILayoutPosition.safeAreaMargin表示视图的边距不是一个固定的值而是所在的父视图的安全区域。这样布局视图就不会延伸到安全区域以外去了。
 //GTUILayoutPosition.safeAreaMargin是同时支持iOS11和以下的版本的，对于iOS11以下的版本则顶部安全区域是状态栏以下的位置。
 //因此只要你设置边距为GTUILayoutPosition.safeAreaMargin则可以同时兼容所有iOS的版本。。
 layoutView.leadingPos.equalTo(@(GTUILayoutPosition.safeAreaMargin)).offset(10);
 layoutView.trailingPos.equalTo(@(GTUILayoutPosition.safeAreaMargin)).offset(10);
 layoutView.topPos.equalTo(@(GTUILayoutPosition.safeAreaMargin)).offset(10);
 
 //如果你的左右边距都是安全区域，那么可以用下面的方法来简化设置。您可以注释掉这句代码看看效果。
 // layoutView.gtui_Leading = layoutView.gtui_Trailing = GTUILayoutPosition.safeAreaMargin;
 @endcode
 
 @code
 
 //在一个没有导航条的界面中，因为iPhoneX和其他设备的状态栏的高度不一致。所以你可以让布局视图的topPadding设置如下：
 layoutView.topPadding = GTUILayoutPosition.safeAreaMargin + 10;  //顶部内边距是安全区域外加10。那么这个和设置如下的：
 layoutView.topPadding = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 10;
 
 //这两者之间的区别后者是一个设置好的常数，一旦你的设备要支持横竖屏则不管横屏下是否有状态栏都会缩进固定的内边距，而前者则会根据当前是否状态栏而进行动态调整。
 //当然如果你的顶部就是要固定缩进状态栏的高度的话那么你可以直接直接用后者。
 
 
 @endcode
 
 @note
 需要注意的是这个值并不是一个真值，只是一个特殊值，不能用于读取。而且只能用于在GTUILayoutPosition的equalTo方法和布局视图上的padding属性上使用，其他地方使用后果未可知。
 
 */
@property(class, nonatomic, assign,readonly) CGFloat safeAreaMargin;
#else
+(CGFloat)safeAreaMargin;
#endif

#ifdef GTUI_USEPREFIXMETHOD
-(GTUILayoutPosition* (^)(id val))gtui_equalTo;
-(GTUILayoutPosition* (^)(CGFloat val))gtui_offset;
-(GTUILayoutPosition* (^)(CGFloat val))gtui_min;
-(GTUILayoutPosition* (^)(id posVal, CGFloat offset))gtui_lBound;
-(GTUILayoutPosition* (^)(CGFloat val))gtui_max;
-(GTUILayoutPosition* (^)(id posVal, CGFloat offset))gtui_uBound;
-(void)gtui_clear;

#else

/**
 设置布局位置的值。参数val可以接收下面六种类型的值：
 
 1. NSNumber表示位置是一个具体的数值。
 对于框架布局和线性布局中的子视图来说，如果数值是一个大于0而小于1的数值时表示的是相对的间距或者边距。如果是相对边距那么真实的位置 = 布局视图尺寸*相对边距值；如果是相对间距那么真实的位置 = 布局视图剩余尺寸 * 相对间距值 /(所有相对间距值的总和)。
 
 2. GTUILayoutPosition表示位置依赖于另外一个位置。
 
 3. NSArray<GTUILayoutPosition*>表示位置和数组里面的其他位置整体居中。
 
 4. id<UILayoutSupport> 对于iOS7以后视图控制器会根据导航条是否半透明而确定是占据整个屏幕。因此当topPos,bottomPos设置为视图控制器的topLayoutGuide或者bottomLayoutGuide时这样子视图就会偏移出导航条的高度，而如果没有导航条时则不会偏移出导航条的高度。注意的是这个值不能设置在非布局父视图的布局视图中。
 
 5. UIView表示位置依赖指定视图的对应位置。
 
 6. nil表示位置的值被清除。
 */
-(GTUILayoutPosition* (^)(id val))equalTo;


/**
 设置布局位置值的偏移量。 所谓偏移量是指布局位置在设置了某种值后增加或减少的偏移值。
 这里偏移值的正负值所表示的意义是根据位置的不同而不同的：
 
 1.如果是leftPos和centerXPos那么正数表示往右偏移，负数表示往左偏移。
 
 2.如果是topPos和centerYPos那么正数表示往下偏移，负数表示往上偏移。
 
 3.如果是rightPos那么正数表示往左偏移，负数表示往右偏移。
 
 4.如果是bottomPos那么正数表示往上偏移，负数表示往下偏移。
 
 @code
 示例代码：
 1.比如：A.leftPos.equalTo(@10).offset(5)表示A视图的左边边距等于10再往右偏移5,也就是最终的左边边距是15。
 2.比如：A.rightPos.equalTo(B.rightPos).offset(5)表示A视图的右边位置等于B视图的右边位置再往左偏移5。
 @endcode
 */
-(GTUILayoutPosition* (^)(CGFloat val))offset;


/**
 *设置位置的最小边界数值，min方法是lBound方法的简化版本。比如：A.min(10) <==>  A.lBound(@10, 0)
 */
-(GTUILayoutPosition* (^)(CGFloat val))min;

/**
 *设置布局位置的最小边界值。 如果位置对象没有设置最小边界值，那么最小边界默认就是无穷小-CGFLOAT_MAX。lBound方法除了能设置为NSNumber外，还可以设置为GTUILayoutPosition值，并且还可以指定最小位置的偏移量值。只有在相对布局中的子视图的位置对象才能设置最小边界值为GTUILayoutPosition类型的值，其他类型布局中的子视图只支持NSNumber类型的最小边界值。
 
 posVal: 指定位置边界值。可设置的类型有NSNumber和GTUILayoutPosition类型，前者表示最小位置不能小于某个常量值，而后者表示最小位置不能小于另外一个位置对象所表示的位置值。
 
 offsetVal: 指定位置边界值的偏移量。
 
 1.比如某个视图A的左边位置最小不能小于30则设置为：
 @code
 A.leftPositon.lBound(30,0); 或者A.leftPos.lBound(20,10);
 @endcode
 
 2.对于相对布局中的子视图来说可以通过lBound值来实现那些尺寸不确定但是最小边界不能低于某个关联的视图的位置的场景，比如说视图B的位置和宽度固定，而A视图的右边位置固定，但是A视图的宽度不确定，且A的最左边不能小于B视图的右边边界加20，那么A就可以设置为：
 @code
 A.leftPos.lBound(B.rightPos, 20); //这时A是不必要指定明确的宽度的。
 @endcode
 */
-(GTUILayoutPosition* (^)(id posVal, CGFloat offsetVal))lBound;


/**
 *设置位置的最大边界数值，max方法是uBound方法的简化版本。比如：A.max(10) <==>  A.uBound(@10, 0)
 */
-(GTUILayoutPosition* (^)(CGFloat val))max;

/**
 设置布局位置的最大边界值。 如果位置对象没有设置最大边界值，那么最大边界默认就是无穷大CGFLOAT_MAX。uBound方法除了能设置为NSNumber外，还可以设置为GTUILayoutPosition值，并且还可以指定最大位置的偏移量值。只有在相对布局中的子视图的位置对象才能设置最大边界值为GTUILayoutPosition类型的值，其他类型布局中的子视图只支持NSNumber类型的最大边界值。
 
 1.比如某个视图A的左边位置最大不能超过30则设置为：
 @code
 A.leftPos.uBound(30,0); 或者A.leftPos.uBound(30,10);
 @endcode
 2.对于相对布局中的子视图来说可以通过uBound值来实现那些尺寸不确定但是最大边界不能超过某个关联的视图的位置的场景，比如说视图B的位置和宽度固定，而A视图的左边位置固定，但是A视图的宽度不确定，且A的最右边不能超过B视图的左边边界减20，那么A就可以设置为：
 @code
 A.reftPos.uBound(B.leftPos, -20); //这时A是不必要指定明确的宽度的。
 @endcode
 
 3.对于相对布局中的子视图来说可以同时通过lBound,uBound方法的设置来实现某个子视图总是在对应的两个其他的子视图中央显示且尺寸不能超过其他两个子视图边界的场景。比如说视图B要放置在A和C之间水平居中显示且不能超过A和C的边界。那么就可以设置为：
 @code
 B.leftPos.lBound(A.rightPos,0); B.rightPos.uBound(C.leftPos,0); //这时B不用指定宽度，而且总是在A和C的水平中间显示。
 @endcode
 
 posVal 指定位置边界值。可设置的类型有NSNumber和GTUILayoutPosition类型，前者表示最大位置不能大于某个常量值，而后者表示最大位置不能大于另外一个位置对象所表示的位置值。
 
 offsetVal 指定位置边界值的偏移量。
 */
-(GTUILayoutPosition* (^)(id posVal, CGFloat offsetVal))uBound;


/**
 *清除所有设置的约束值，这样位置对象将不会再生效了。
 */
-(void)clear;

#endif

/**
 *设置布局位置是否是活动的,默认是YES表示活动的，如果设置为NO则表示这个布局位置对象设置的约束值将不会起作用。
 *active设置为YES和clear的相同点是位置对象设置的约束值都不会生效了，区别是前者不会清除所有设置的约束，而后者则会清除所有设置的约束。
 */
@property(nonatomic, assign, getter=isActive) BOOL active;


//通过如下属性获取上面方法设置的值。
@property(nonatomic, strong, readonly) id posVal;
@property(nonatomic, assign, readonly) CGFloat offsetVal;
@property(nonatomic, assign, readonly) CGFloat minVal;
@property(nonatomic, assign, readonly) CGFloat maxVal;

@end

NS_ASSUME_NONNULL_END
