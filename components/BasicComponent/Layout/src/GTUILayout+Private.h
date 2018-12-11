//
//  GTUILayout+Private.h
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUILayoutMath.h"
#import "GTUILayoutDefine.h"
#import "GTUILayoutPosition+Private.h"
#import "GTUILayoutSize+Private.h"
#import "GTUILayoutSizeClass.h"

NS_ASSUME_NONNULL_BEGIN

//视图在布局中的评估测量值
@interface GTUIFrame : NSObject

@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat leading;
@property(nonatomic, assign) CGFloat bottom;
@property(nonatomic, assign) CGFloat trailing;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, weak) UIView *sizeClass;

@property(nonatomic, assign, readonly) BOOL multiple; //是否设置了多个sizeclass

@property(nonatomic, strong) NSMutableDictionary *sizeClasses;

@property(nonatomic, assign) BOOL hasObserver;

-(void)reset;

@property(nonatomic,assign) CGRect frame;

@end



@interface GTUIBaseLayout()


//派生类重载这个函数进行布局
-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(nullable BOOL*)pHasSubLayout sizeClass:(GTUISizeClass)sizeClass sbs:(nullable NSMutableArray*)sbs;

-(id)createSizeClassInstance;


//判断margin是否是相对margin
-(BOOL)gtuiIsRelativePos:(CGFloat)margin;

-(GTUIGravity)gtuiGetSubviewVertGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc vertGravity:(GTUIGravity)vertGravity;


-(void)gtuiCalcVertGravity:(GTUIGravity)vert
                     sbv:(UIView *)sbv
                   sbvsc:(UIView*)sbvsc
              paddingTop:(CGFloat)paddingTop
           paddingBottom:(CGFloat)paddingBottom
             baselinePos:(CGFloat)baselinePos
                selfSize:(CGSize)selfSize
                   pRect:(CGRect*)pRect;

-(GTUIGravity)gtuiGetSubviewHorzGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc horzGravity:(GTUIGravity)horzGravity;


-(void)gtuiCalcHorzGravity:(GTUIGravity)horz
                     sbv:(UIView *)sbv
                   sbvsc:(UIView*)sbvsc
          paddingLeading:(CGFloat)paddingLeading
         paddingTrailing:(CGFloat)paddingTrailing
                selfSize:(CGSize)selfSize
                   pRect:(CGRect*)pRect;

-(void)gtuiCalcSizeOfWrapContentSubview:(UIView*)sbv sbvsc:(UIView*)sbvsc sbvgtuiFrame:(GTUIFrame*)sbvgtuiFrame;

-(CGFloat)gtuiHeightFromFlexedHeightView:(UIView*)sbv sbvsc:(UIView*)sbvsc inWidth:(CGFloat)width;

-(CGFloat)gtuiValidMeasure:(GTUILayoutSize*)dime sbv:(UIView*)sbv calcSize:(CGFloat)calcSize sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize;

-(CGFloat)gtuiValidMargin:(GTUILayoutPosition*)pos sbv:(UIView*)sbv calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize;

-(BOOL)gtuiIsNoLayoutSubview:(UIView*)sbv;

-(NSMutableArray*)gtuiGetLayoutSubviews;
-(NSMutableArray*)gtuiGetLayoutSubviewsFrom:(NSArray*)sbsFrom;

//设置子视图的相对依赖的尺寸
-(void)gtuiSetSubviewRelativeDimeSize:(GTUILayoutSize*)dime selfSize:(CGSize)selfSize lsc:(GTUIBaseLayout*)lsc pRect:(CGRect*)pRect;

-(CGSize)gtuiAdjustSizeWhenNoSubviews:(CGSize)size sbs:(NSArray*)sbs lsc:(GTUIBaseLayout*)lsc;

- (void)gtuiAdjustLayoutSelfSize:(CGSize *)pSelfSize lsc:(GTUIBaseLayout*)lsc;

-(void)gtuiAdjustSubviewsRTLPos:(NSArray*)sbs selfWidth:(CGFloat)selfWidth;

-(void)gtuiAdjustSubviewsLayoutTransform:(NSArray*)sbs lsc:(GTUIBaseLayout*)lsc selfWidth:(CGFloat)selfWidth selfHeight:(CGFloat)selfHeight;

-(GTUIGravity)gtuiConvertLeftRightGravityToLeadingTrailing:(GTUIGravity)horzGravity;

//为支持iOS11的safeArea而进行的padding的转化
-(CGFloat)gtuiLayoutTopPadding;
-(CGFloat)gtuiLayoutBottomPadding;
-(CGFloat)gtuiLayoutLeftPadding;
-(CGFloat)gtuiLayoutRightPadding;
-(CGFloat)gtuiLayoutLeadingPadding;
-(CGFloat)gtuiLayoutTrailingPadding;

-(void)gtuiAdjustSubviewWrapContentSet:(UIView*)sbv isEstimate:(BOOL)isEstimate sbvgtuiFrame:(GTUIFrame*)sbvgtuiFrame sbvsc:(UIView*)sbvsc selfSize:(CGSize)selfSize sizeClass:(GTUISizeClass)sizeClass pHasSubLayout:(BOOL*)pHasSubLayout;


-(void)gtuiCalcSubViewRect:(UIView*)sbv
                   sbvsc:(UIView*)sbvsc
              sbvgtuiFrame:(GTUIFrame*)sbvgtuiFrame
                     lsc:(GTUIBaseLayout*)lsc
             vertGravity:(GTUIGravity)vertGravity
             horzGravity:(GTUIGravity)horzGravity
              inSelfSize:(CGSize)selfSize
              paddingTop:(CGFloat)paddingTop
          paddingLeading:(CGFloat)paddingLeading
           paddingBottom:(CGFloat)paddingBottom
         paddingTrailing:(CGFloat)paddingTrailing
            pMaxWrapSize:(nullable CGSize*)pMaxWrapSize;

-(UIFont*)gtuiGetSubviewFont:(UIView*)sbv;

-(GTUISizeClass)gtuiGetGlobalSizeClass;

//给父布局视图机会来更改子布局视图的边界线的显示的rect
-(void)gtuiHookSublayout:(GTUIBaseLayout*)sublayout borderlineRect:(CGRect*)pRect;

@end



@interface GTUIViewSizeClass()

@property(nonatomic, strong,readonly)  GTUILayoutPosition *topPosInner;
@property(nonatomic, strong,readonly)  GTUILayoutPosition *leadingPosInner;
@property(nonatomic, strong,readonly)  GTUILayoutPosition *bottomPosInner;
@property(nonatomic, strong,readonly)  GTUILayoutPosition *trailingPosInner;
@property(nonatomic, strong,readonly)  GTUILayoutPosition *centerXPosInner;
@property(nonatomic, strong,readonly)  GTUILayoutPosition *centerYPosInner;
@property(nonatomic, strong,readonly)  GTUILayoutSize *widthSizeInner;
@property(nonatomic, strong,readonly)  GTUILayoutSize *heightSizeInner;

@property(nonatomic, strong,readonly)  GTUILayoutPosition *leftPosInner;
@property(nonatomic, strong,readonly)  GTUILayoutPosition *rightPosInner;

@property(nonatomic, strong,readonly)  GTUILayoutPosition *baselinePosInner;

#if GTUIKIT_DEFINE_AS_PROPERTIES

@property(class, nonatomic, assign) BOOL isRTL;
#else
+(BOOL)isRTL;
+(void)setIsRTL:(BOOL)isRTL;
#endif

@end


@interface UIView(GTUILayoutExtInner)

@property(nonatomic, strong, readonly) GTUIFrame *gtuiFrame;


-(instancetype)gtuiDefaultSizeClass;

-(instancetype)gtuiBestSizeClass:(GTUISizeClass)sizeClass;

-(instancetype)gtuiCurrentSizeClass;

-(instancetype)gtuiCurrentSizeClassInner;


-(instancetype)gtuiCurrentSizeClassFrom:(GTUIFrame*)gtuiFrame;

-(id)createSizeClassInstance;


@property(nonatomic, readonly)  GTUILayoutPosition *topPosInner;
@property(nonatomic, readonly)  GTUILayoutPosition *leadingPosInner;
@property(nonatomic, readonly)  GTUILayoutPosition *bottomPosInner;
@property(nonatomic, readonly)  GTUILayoutPosition *trailingPosInner;
@property(nonatomic, readonly)  GTUILayoutPosition *centerXPosInner;
@property(nonatomic, readonly)  GTUILayoutPosition *centerYPosInner;
@property(nonatomic, readonly)  GTUILayoutSize *widthSizeInner;
@property(nonatomic, readonly)  GTUILayoutSize *heightSizeInner;

@property(nonatomic, readonly)  GTUILayoutPosition *leftPosInner;
@property(nonatomic, readonly)  GTUILayoutPosition *rightPosInner;

@property(nonatomic, readonly)  GTUILayoutPosition *baselinePosInner;


@end

NS_ASSUME_NONNULL_END
