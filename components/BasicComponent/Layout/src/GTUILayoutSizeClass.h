//
//  GTUILayoutSizeClass.h
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUILayoutDefine.h"
#import "GTUILayoutPosition.h"
#import "GTUILayoutSize.h"
#import "GTUIGrid.h"

@class GTUIBaseLayout;

NS_ASSUME_NONNULL_BEGIN

/*
 布局的尺寸类型类，这个类的功能用来支持类似于iOS的Size Class机制用来实现各种屏幕下的视图的约束。
 GTUILayoutSizeClass类中定义的各种属性跟视图和布局的各种扩展属性是一致的。
 
 我们所有的视图的默认的约束设置都是基于GTUISizeClasswAny|GTUISizeClasshAny这种SizeClass的。
 
 需要注意的是因为GTUILayoutSizeClass是基于苹果SizeClass实现的，因此如果是iOS7的系统则只能支持GTUISizeClasswAny|GTUISizeClasshAny这种
 SizeClass，以及GTUISizeClassPortrait或者GTUISizeClassLandscape 也就是设置布局默认的约束。而iOS8以上的系统则能支持所有的SizeClass.
 
 */
@interface GTUIViewSizeClass : NSObject <NSCopying>

@property(nonatomic, weak) UIView *view;

//所有视图通用
@property(nonatomic, strong)  GTUILayoutPosition *topPos;
@property(nonatomic, strong)  GTUILayoutPosition *leadingPos;
@property(nonatomic, strong)  GTUILayoutPosition *bottomPos;
@property(nonatomic, strong)  GTUILayoutPosition *trailingPos;
@property(nonatomic, strong)  GTUILayoutPosition *centerXPos;
@property(nonatomic, strong)  GTUILayoutPosition *centerYPos;


@property(nonatomic, strong,readonly)  GTUILayoutPosition *leftPos;
@property(nonatomic, strong,readonly)  GTUILayoutPosition *rightPos;

@property(nonatomic, strong)  GTUILayoutPosition *baselinePos;


@property(nonatomic, assign) CGFloat gtui_top;
@property(nonatomic, assign) CGFloat gtui_leading;
@property(nonatomic, assign) CGFloat gtui_bottom;
@property(nonatomic, assign) CGFloat gtui_trailing;
@property(nonatomic, assign) CGFloat gtui_centerX;
@property(nonatomic, assign) CGFloat gtui_centerY;
@property(nonatomic, assign) CGPoint gtui_center;


@property(nonatomic, assign) CGFloat gtui_left;
@property(nonatomic, assign) CGFloat gtui_right;



@property(nonatomic, assign) CGFloat gtui_margin;
@property(nonatomic, assign) CGFloat gtui_horzMargin;
@property(nonatomic, assign) CGFloat gtui_vertMargin;


@property(nonatomic, strong)  GTUILayoutSize *widthSize;
@property(nonatomic, strong)  GTUILayoutSize *heightSize;

@property(nonatomic, assign) CGFloat gtui_Width;
@property(nonatomic, assign) CGFloat gtui_Height;
@property(nonatomic, assign) CGSize  gtui_Size;


@property(nonatomic, assign) BOOL wrapContentWidth;
@property(nonatomic, assign) BOOL wrapContentHeight;

@property(nonatomic, assign) BOOL wrapContentSize;

@property(nonatomic, assign) BOOL useFrame;
@property(nonatomic, assign) BOOL noLayout;

@property(nonatomic, assign) GTUIVisibility gtui_visibility;
@property(nonatomic, assign) GTUIGravity gtui_alignment;

@property(nonatomic, copy) void (^viewLayoutCompleteBlock)(GTUIBaseLayout* layout, UIView *v);

//线性布局和浮动布局子视图专用
@property(nonatomic, assign) CGFloat weight;

//浮动布局子视图专用
@property(nonatomic,assign,getter=isReverseFloat) BOOL reverseFloat;
@property(nonatomic,assign) BOOL clearFloat;

@end


@interface GTUILayoutViewSizeClass : GTUIViewSizeClass

@property(nonatomic, assign) BOOL zeroPadding;

@property(nonatomic, assign) BOOL reverseLayout;
@property(nonatomic, assign) CGAffineTransform layoutTransform;  //布局变换。

@property(nonatomic, assign) GTUIGravity gravity;

@property(nonatomic, assign) BOOL insetLandscapeFringePadding;

@property(nonatomic, assign) CGFloat topPadding;
@property(nonatomic, assign) CGFloat leadingPadding;
@property(nonatomic, assign) CGFloat bottomPadding;
@property(nonatomic, assign) CGFloat trailingPadding;
@property(nonatomic, assign) UIEdgeInsets padding;


@property(nonatomic, assign) CGFloat leftPadding;
@property(nonatomic, assign) CGFloat rightPadding;



@property(nonatomic, assign) UIRectEdge insetsPaddingFromSafeArea;



@property(nonatomic ,assign) CGFloat subviewVSpace;
@property(nonatomic, assign) CGFloat subviewHSpace;
@property(nonatomic, assign) CGFloat subviewSpace;






@end


@interface GTUISequentLayoutViewSizeClass : GTUILayoutViewSizeClass

@property(nonatomic,assign) GTUIOrientation orientation;



@end




@interface GTUILinearLayoutViewSizeClass : GTUISequentLayoutViewSizeClass

@property(nonatomic, assign) GTUISubviewsShrinkType shrinkType;

@end



@interface GTUITableLayoutViewSizeClass : GTUILinearLayoutViewSizeClass

@end


@interface GTUIFlowLayoutViewSizeClass : GTUISequentLayoutViewSizeClass

@property(nonatomic,assign) GTUIGravity arrangedGravity;
@property(nonatomic,assign) BOOL autoArrange;

@property(nonatomic,assign) NSInteger arrangedCount;
@property(nonatomic, assign) NSInteger pagedCount;

@property(nonatomic, assign) CGFloat subviewSize;
@property(nonatomic, assign) CGFloat minSpace;
@property(nonatomic, assign) CGFloat maxSpace;



@end


@interface GTUIFloatLayoutViewSizeClass : GTUISequentLayoutViewSizeClass

@property(nonatomic, assign) CGFloat subviewSize;
@property(nonatomic, assign) CGFloat minSpace;
@property(nonatomic, assign) CGFloat maxSpace;
@property(nonatomic,assign) BOOL noBoundaryLimit;

@end


@interface GTUIRelativeLayoutViewSizeClass : GTUILayoutViewSizeClass


@end


@interface GTUIFrameLayoutViewSizeClass : GTUILayoutViewSizeClass


@end

@interface GTUIPathLayoutViewSizeClass  : GTUILayoutViewSizeClass


@end


@interface GTUIGridLayoutViewSizeClass : GTUILayoutViewSizeClass<GTUIGrid>

@end


NS_ASSUME_NONNULL_END
