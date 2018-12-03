//
//  GTUIMaker.h
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUILayoutDefine.h"

#if TARGET_OS_IPHONE

/**
 *专门为布局设置的简化操作类，以便在统一的地方进行布局设置,GTUILayout提供了类似masonry的布局设置语法。
 */
@interface GTUIMaker : NSObject

-(GTUIMaker*)top;
-(GTUIMaker*)left;
-(GTUIMaker*)bottom;
-(GTUIMaker*)right;
-(GTUIMaker*)margin;

-(GTUIMaker*)leading;
-(GTUIMaker*)trailing;


-(GTUIMaker*)wrapContentHeight;
-(GTUIMaker*)wrapContentWidth;

-(GTUIMaker*)height;
-(GTUIMaker*)width;
-(GTUIMaker*)useFrame;
-(GTUIMaker*)noLayout;

-(GTUIMaker*)centerX;
-(GTUIMaker*)centerY;
-(GTUIMaker*)center;
-(GTUIMaker*)baseline;

-(GTUIMaker*)visibility;
-(GTUIMaker*)alignment;

-(GTUIMaker*)sizeToFit;


//布局独有
-(GTUIMaker*)topPadding;
-(GTUIMaker*)leftPadding;
-(GTUIMaker*)bottomPadding;
-(GTUIMaker*)rightPadding;
-(GTUIMaker*)leadingPadding;
-(GTUIMaker*)trailingPadding;
-(GTUIMaker*)padding;
-(GTUIMaker*)zeroPadding;
-(GTUIMaker*)reverseLayout;
-(GTUIMaker*)vertSpace;
-(GTUIMaker*)horzSpace;
-(GTUIMaker*)space;



//线性布局和流式布局独有
-(GTUIMaker*)orientation;
-(GTUIMaker*)gravity;

//线性布局独有
-(GTUIMaker*)shrinkType;

//流式布局独有
-(GTUIMaker*)arrangedCount;
-(GTUIMaker*)autoArrange;
-(GTUIMaker*)arrangedGravity;
-(GTUIMaker*)pagedCount;


//线性布局和浮动布局和流式布局子视图独有
-(GTUIMaker*)weight;

//浮动布局子视图独有
-(GTUIMaker*)reverseFloat;
-(GTUIMaker*)clearFloat;


//浮动布局独有。
-(GTUIMaker*)noBoundaryLimit;

//赋值操支持NSNumber,UIView,GTUILayoutPosition,GTUILayoutSize, NSArray[GTUILayoutSize]
-(GTUIMaker* (^)(id val))equalTo;
-(GTUIMaker* (^)(id val))min;
-(GTUIMaker* (^)(id val))max;

-(GTUIMaker* (^)(CGFloat val))offset;
-(GTUIMaker* (^)(CGFloat val))multiply;
-(GTUIMaker* (^)(CGFloat val))add;




@end


@interface UIView(GTUIMakerExt)

//对视图进行统一的布局，方便操作，请参考DEMO1中的使用方法。
-(void)makeLayout:(void(^)(GTUIMaker *make))layoutMaker;

//布局内所有子视图的布局构造，会影响到有所的子视图。
-(void)allSubviewMakeLayout:(void(^)(GTUIMaker *make))layoutMaker;


@end

#endif
