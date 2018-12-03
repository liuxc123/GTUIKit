//
//  GTUIFrameLayout.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUIFrameLayout.h"
#import "GTUILayout+Private.h"

@implementation GTUIFrameLayout

#pragma mark -- Override Methods


-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(GTUISizeClass)sizeClass sbs:(NSMutableArray *)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self gtuiGetLayoutSubviews];
    
    GTUIFrameLayout *lsc = self.gtuiCurrentSizeClass;
    CGFloat paddingTop = lsc.gtuiLayoutTopPadding;
    CGFloat paddingLeading = lsc.gtuiLayoutLeadingPadding;
    CGFloat paddingBottom = lsc.gtuiLayoutBottomPadding;
    CGFloat paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    
    GTUIGravity horzGravity = [self gtuiConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTUIGravityVertMask];
    GTUIGravity vertGravity = lsc.gravity & GTUIGravityHorzMask;
    
    
    CGSize maxWrapSize = CGSizeMake(paddingLeading + paddingTrailing, paddingTop + paddingBottom);
    CGSize *pMaxWrapSize = &maxWrapSize;
    if (!lsc.wrapContentHeight && !lsc.wrapContentWidth)
        pMaxWrapSize = NULL;
    
    for (UIView *sbv in sbs)
    {
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        
        [self gtuiAdjustSubviewWrapContentSet:sbv isEstimate:isEstimate sbvgtuiFrame:sbvgtuiFrame sbvsc:sbvsc selfSize:selfSize sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
        
        //计算自己的位置和高宽
        [self gtuiCalcSubViewRect:sbv sbvsc:sbvsc sbvgtuiFrame:sbvgtuiFrame lsc:lsc vertGravity:vertGravity horzGravity:horzGravity inSelfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing pMaxWrapSize:pMaxWrapSize];
        
    }
    
    if (lsc.wrapContentWidth)
    {
        selfSize.width = maxWrapSize.width;
    }
    
    if (lsc.wrapContentHeight)
    {
        selfSize.height = maxWrapSize.height;
    }
    
    //调整布局视图自己的尺寸。
    [self gtuiAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    //如果布局视图具有包裹属性这里要调整那些依赖父视图宽度和高度的子视图的位置和尺寸。
    if ((lsc.wrapContentWidth && horzGravity != GTUIGravityHorzFill) || (lsc.wrapContentHeight && vertGravity != GTUIGravityVertFill))
    {
        for (UIView *sbv in sbs)
        {
            GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
            UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
            
            
            //只有子视图的尺寸或者位置依赖父视图的情况下才需要重新计算位置和尺寸。
            if ((sbvsc.trailingPosInner.posVal != nil) ||
                (sbvsc.bottomPosInner.posVal != nil) ||
                (sbvsc.centerXPosInner.posVal != nil) ||
                (sbvsc.centerYPosInner.posVal != nil) ||
                (sbvsc.widthSizeInner.dimeRelaVal.view == self) ||
                (sbvsc.heightSizeInner.dimeRelaVal.view == self)
                )
            {
                [self gtuiCalcSubViewRect:sbv sbvsc:sbvsc sbvgtuiFrame:sbvgtuiFrame lsc:lsc  vertGravity:vertGravity horzGravity:horzGravity inSelfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing pMaxWrapSize:NULL];
            }
            
        }
    }
    
    
    //对所有子视图进行布局变换
    [self gtuiAdjustSubviewsLayoutTransform:sbs lsc:lsc selfWidth:selfSize.width selfHeight:selfSize.height];
    //对所有子视图进行RTL设置
    [self gtuiAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];
    
    return [self gtuiAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
    
}

-(id)createSizeClassInstance
{
    return [GTUIFrameLayoutViewSizeClass new];
}


#pragma mark -- Private Methods


-(void)gtuiCalcSubViewRect:(UIView*)sbv
                   sbvsc:(UIView*)sbvsc
              sbvgtuiFrame:(GTUIFrame*)sbvgtuiFrame
                     lsc:(GTUIFrameLayout*)lsc
             vertGravity:(GTUIGravity)vertGravity
             horzGravity:(GTUIGravity)horzGravity
              inSelfSize:(CGSize)selfSize
              paddingTop:(CGFloat)paddingTop
          paddingLeading:(CGFloat)paddingLeading
           paddingBottom:(CGFloat)paddingBottom
         paddingTrailing:(CGFloat)paddingTrailing
            pMaxWrapSize:(CGSize*)pMaxWrapSize
{
    
    
    CGRect rect = sbvgtuiFrame.frame;
    
    if (sbvsc.widthSizeInner.dimeNumVal != nil)
    {//宽度等于固定的值。
        
        rect.size.width = sbvsc.widthSizeInner.measure;
    }
    else if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal.view != sbv)
    {//宽度等于其他的依赖的视图。
        
        if (sbvsc.widthSizeInner.dimeRelaVal == self.widthSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:selfSize.width - paddingLeading - paddingTrailing];
        else if (sbvsc.widthSizeInner.dimeRelaVal == self.heightSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:selfSize.height - paddingTop - paddingBottom];
        else
            rect.size.width = [sbvsc.widthSizeInner measureWith:sbvsc.widthSizeInner.dimeRelaVal.view.estimatedRect.size.width];
    }
    
    rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
    [self gtuiCalcHorzGravity:[self gtuiGetSubviewHorzGravity:sbv sbvsc:sbvsc horzGravity:horzGravity] sbv:sbv sbvsc:sbvsc paddingLeading:paddingLeading paddingTrailing:paddingTrailing selfSize:selfSize pRect:&rect];
    
    
    
    if (sbvsc.heightSizeInner.dimeNumVal != nil)
    {//高度等于固定的值。
        rect.size.height = sbvsc.heightSizeInner.measure;
    }
    else if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal.view != sbv)
    {//高度等于其他依赖的视图
        if (sbvsc.heightSizeInner.dimeRelaVal == self.heightSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:selfSize.height - paddingTop - paddingBottom];
        else if (sbvsc.heightSizeInner.dimeRelaVal == self.widthSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:selfSize.width - paddingLeading - paddingTrailing];
        else
            rect.size.height = [sbvsc.heightSizeInner measureWith:sbvsc.heightSizeInner.dimeRelaVal.view.estimatedRect.size.height];
    }
    
    if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]])
    {//高度等于内容的高度
        rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
    }
    
    rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
    [self gtuiCalcVertGravity:[self gtuiGetSubviewVertGravity:sbv sbvsc:sbvsc vertGravity:vertGravity] sbv:sbv sbvsc:sbvsc paddingTop:paddingTop paddingBottom:paddingBottom baselinePos:CGFLOAT_MAX selfSize:selfSize pRect:&rect];
    
    
    //特殊处理宽度等于高度
    if (sbvsc.widthSizeInner.dimeRelaVal.view == sbv && sbvsc.widthSizeInner.dimeRelaVal.dime == GTUIGravityVertFill)
    {
        rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
        rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        [self gtuiCalcHorzGravity:[self gtuiGetSubviewHorzGravity:sbv sbvsc:sbvsc horzGravity:horzGravity] sbv:sbv sbvsc:sbvsc paddingLeading:paddingLeading paddingTrailing:paddingTrailing selfSize:selfSize pRect:&rect];
    }
    
    //特殊处理高度等于宽度。
    if (sbvsc.heightSizeInner.dimeRelaVal.view == sbv && sbvsc.heightSizeInner.dimeRelaVal.dime == GTUIGravityHorzFill)
    {
        rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
        
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]])
        {
            rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        }
        
        rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        [self gtuiCalcVertGravity:[self gtuiGetSubviewVertGravity:sbv sbvsc:sbvsc vertGravity:vertGravity] sbv:sbv sbvsc:sbvsc paddingTop:paddingTop paddingBottom:paddingBottom baselinePos:CGFLOAT_MAX selfSize:selfSize pRect:&rect];
        
    }
    
    sbvgtuiFrame.frame = rect;
    
    if (pMaxWrapSize != NULL)
    {
        if (lsc.wrapContentWidth)
        {
            //如果同时设置左右边界则左右边界为最小的宽度
            if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
            {
                if (_gtuiCGFloatLess(pMaxWrapSize->width, sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing))
                    pMaxWrapSize->width = sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing;
            }
            
            //宽度不依赖布局并且没有同时设置左右边距则参与最大宽度计算。
            if ((sbvsc.widthSizeInner.dimeRelaVal.view != self) &&
                (sbvsc.leadingPosInner.posVal == nil || sbvsc.trailingPosInner.posVal == nil))
            {
                
                if (_gtuiCGFloatLess(pMaxWrapSize->width, sbvgtuiFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.centerXPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing))
                    pMaxWrapSize->width = sbvgtuiFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.centerXPosInner.absVal + sbvsc.trailingPosInner.absVal + paddingLeading + paddingTrailing;
                
                if (_gtuiCGFloatLess(pMaxWrapSize->width,sbvgtuiFrame.trailing + sbvsc.trailingPosInner.absVal + paddingTrailing))
                    pMaxWrapSize->width = sbvgtuiFrame.trailing + sbvsc.trailingPosInner.absVal + paddingTrailing;
                
            }
        }
        
        if (lsc.wrapContentHeight)
        {
            //如果同时设置上下边界则上下边界为最小的高度
            if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
            {
                if (_gtuiCGFloatLess(pMaxWrapSize->height, sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom))
                    pMaxWrapSize->height = sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom;
            }
            
            //高度不依赖布局并且没有同时设置上下边距则参与最大高度计算。
            if ((sbvsc.heightSizeInner.dimeRelaVal.view != self) &&
                (sbvsc.topPosInner.posVal == nil || sbvsc.bottomPosInner.posVal == nil))
            {
                if (_gtuiCGFloatLess(pMaxWrapSize->height, sbvgtuiFrame.height + sbvsc.topPosInner.absVal + sbvsc.centerYPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom))
                    pMaxWrapSize->height = sbvgtuiFrame.height + sbvsc.topPosInner.absVal + sbvsc.centerYPosInner.absVal + sbvsc.bottomPosInner.absVal + paddingTop + paddingBottom;
                
                if (_gtuiCGFloatLess(pMaxWrapSize->height, sbvgtuiFrame.bottom + sbvsc.bottomPosInner.absVal + paddingBottom))
                    pMaxWrapSize->height = sbvgtuiFrame.bottom + sbvsc.bottomPosInner.absVal + paddingBottom;
            }
        }
    }
    
    
}


@end
