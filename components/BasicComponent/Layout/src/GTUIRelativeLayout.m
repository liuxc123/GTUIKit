//
//  GTUIRelativeLayout.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUIRelativeLayout.h"
#import "GTUILayout+Private.h"

@implementation GTUIRelativeLayout

#pragma mark -- Override Methods

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(GTUISizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    GTUIRelativeLayout *lsc = self.gtuiCurrentSizeClass;
    
    
    for (UIView *sbv in self.subviews)
    {
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        if (sbvsc.useFrame)
            continue;
        
        if (!isEstimate || (pHasSubLayout != nil && (*pHasSubLayout) == YES))
            [sbvgtuiFrame reset];
        
        
        if ([sbv isKindOfClass:[GTUIBaseLayout class]])
        {
            
            if (sbvsc.wrapContentWidth)
            {
                //只要同时设置了左右边距或者设置了宽度则应该把wrapContentWidth置为NO
                if ((sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil) || sbvsc.widthSizeInner.dimeVal != nil)
                    sbvsc.wrapContentWidth = NO;
            }
            
            if (sbvsc.wrapContentHeight)
            {
                if ((sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil) || sbvsc.heightSizeInner.dimeVal != nil)
                    sbvsc.wrapContentHeight = NO;
            }
            
            if (pHasSubLayout != nil && (sbvsc.wrapContentHeight || sbvsc.wrapContentWidth))
                *pHasSubLayout = YES;
            
            if (isEstimate && (sbvsc.wrapContentWidth || sbvsc.wrapContentHeight))
            {
                [(GTUIBaseLayout*)sbv sizeThatFits:sbvgtuiFrame.frame.size inSizeClass:sizeClass];
                
                sbvgtuiFrame.leading = sbvgtuiFrame.trailing = sbvgtuiFrame.top = sbvgtuiFrame.bottom = CGFLOAT_MAX;
                
                if (sbvgtuiFrame.multiple)
                {
                    sbvgtuiFrame.sizeClass = [sbv gtuiBestSizeClass:sizeClass]; //因为sizeThatFits执行后会还原，所以这里要重新设置
                }
            }
        }
    }
    
    
    BOOL reCalc = NO;
    CGSize maxSize = [self gtuiCalcLayout:&reCalc lsc:lsc selfSize:selfSize];
    
    if (lsc.wrapContentWidth || lsc.wrapContentHeight)
    {
        if (_gtuiCGFloatNotEqual(selfSize.height, maxSize.height)  || _gtuiCGFloatNotEqual(selfSize.width, maxSize.width))
        {
            
            if (lsc.wrapContentWidth)
            {
                selfSize.width = maxSize.width;
            }
            
            if (lsc.wrapContentHeight)
            {
                selfSize.height = maxSize.height;
            }
            
            //如果里面有需要重新计算的就重新计算布局
            if (reCalc)
            {
                for (UIView *sbv in self.subviews)
                {
                    GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
                    //如果是布局视图则不清除尺寸，其他清除。
                    if (isEstimate  && [sbv isKindOfClass:[GTUIBaseLayout class]])
                    {
                        sbvgtuiFrame.leading = sbvgtuiFrame.trailing = sbvgtuiFrame.top = sbvgtuiFrame.bottom = CGFLOAT_MAX;
                    }
                    else
                        [sbvgtuiFrame reset];
                }
                
                [self gtuiCalcLayout:NULL lsc:lsc selfSize:selfSize];
            }
        }
        
    }
    
    
    //调整布局视图自己的尺寸。
    [self gtuiAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    //如果是反向则调整所有子视图的左右位置。
    NSArray *sbs2 = [self gtuiGetLayoutSubviews];
    
    //对所有子视图进行布局变换
    [self gtuiAdjustSubviewsLayoutTransform:sbs2 lsc:lsc selfWidth:selfSize.width selfHeight:selfSize.height];
    //对所有子视图进行RTL设置
    [self gtuiAdjustSubviewsRTLPos:sbs2 selfWidth:selfSize.width];
    
    return [self gtuiAdjustSizeWhenNoSubviews:selfSize sbs:sbs2 lsc:lsc];
    
}

-(id)createSizeClassInstance
{
    return [GTUIRelativeLayoutViewSizeClass new];
}



#pragma mark -- Private Method
-(void)gtuiCalcSubViewLeadingTrailing:(UIView*)sbv
                              sbvsc:(UIView*)sbvsc
                                lsc:(GTUIRelativeLayout*)lsc
                         sbvgtuiFrame:(GTUIFrame*)sbvgtuiFrame
                           selfSize:(CGSize)selfSize
{
    
    
    //确定宽度，如果跟父一样宽则设置宽度和设置左右值，这时候三个参数设置完毕
    //如果和其他视图的宽度一样，则先计算其他视图的宽度并返回其他视图的宽度
    //如果没有指定宽度
    //检测左右设置。
    //如果设置了左右值则计算左右值。然后再计算宽度为两者之间的差
    //如果没有设置则宽度为width
    
    //检测是否有centerX，如果设置了centerX的值为父视图则左右值都设置OK，这时候三个参数完毕
    //如果不是父视图则计算其他视图的centerX的值。并返回位置，根据宽度设置后，三个参数完毕。
    
    //如果没有设置则计算左边的位置。
    
    //如果设置了左边，计算左边的值， 右边的值确定。
    
    //如果设置右边，则计算右边的值，左边的值确定。
    
    //如果都没有设置则，左边为左边距，右边为左边+宽度。
    
    //左右和宽度设置完毕。
    
    
    
    if (sbvgtuiFrame.leading != CGFLOAT_MAX && sbvgtuiFrame.trailing != CGFLOAT_MAX && sbvgtuiFrame.width != CGFLOAT_MAX)
        return;
    
    
    //先检测宽度,如果宽度是父亲的宽度则宽度和左右都确定
    if ([self gtuiCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize])
        return;
    
    
    if (sbvsc.centerXPosInner.posRelaVal != nil)
    {
        UIView *relaView = sbvsc.centerXPosInner.posRelaVal.view;
        
        sbvgtuiFrame.leading = [self gtuiCalcSubView:relaView lsc:lsc gravity:sbvsc.centerXPosInner.posRelaVal.pos selfSize:selfSize] - sbvgtuiFrame.width / 2 +  sbvsc.centerXPosInner.absVal;
        
        if (relaView != nil && relaView != self && [self gtuiIsNoLayoutSubview:relaView])
        {
            sbvgtuiFrame.leading -= sbvsc.centerXPosInner.absVal;
        }
        
        if (sbvgtuiFrame.leading < 0 && relaView == self && lsc.wrapContentWidth)
            sbvgtuiFrame.leading = 0;
        
        sbvgtuiFrame.trailing = sbvgtuiFrame.leading + sbvgtuiFrame.width;
    }
    else if (sbvsc.centerXPosInner.posNumVal != nil)
    {
        sbvgtuiFrame.leading = (selfSize.width - lsc.gtuiLayoutLeadingPadding - lsc.gtuiLayoutTrailingPadding - sbvgtuiFrame.width) / 2 + lsc.gtuiLayoutLeadingPadding + sbvsc.centerXPosInner.absVal;
        
        if (sbvgtuiFrame.leading < 0 && lsc.wrapContentWidth)
            sbvgtuiFrame.leading = 0;
        
        sbvgtuiFrame.trailing = sbvgtuiFrame.leading + sbvgtuiFrame.width;
    }
    else
    {
        //如果左右都设置了则上上面的calcWidth会直接返回不会进入这个流程。
        if (sbvsc.leadingPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.leadingPosInner.posRelaVal.view;
            
            sbvgtuiFrame.leading = [self gtuiCalcSubView:relaView lsc:lsc gravity:sbvsc.leadingPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.leadingPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self gtuiIsNoLayoutSubview:relaView])
            {
                sbvgtuiFrame.leading -= sbvsc.leadingPosInner.absVal;
            }
            
            sbvgtuiFrame.trailing = sbvgtuiFrame.leading + sbvgtuiFrame.width;
        }
        else if (sbvsc.leadingPosInner.posNumVal != nil)
        {
            sbvgtuiFrame.leading = sbvsc.leadingPosInner.absVal + lsc.gtuiLayoutLeadingPadding;
            sbvgtuiFrame.trailing = sbvgtuiFrame.leading + sbvgtuiFrame.width;
        }
        else if (sbvsc.trailingPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.trailingPosInner.posRelaVal.view;
            
            
            sbvgtuiFrame.trailing = [self gtuiCalcSubView:relaView lsc:lsc gravity:sbvsc.trailingPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.trailingPosInner.absVal + sbvsc.leadingPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self gtuiIsNoLayoutSubview:relaView])
            {
                sbvgtuiFrame.trailing += sbvsc.trailingPosInner.absVal;
            }
            
            sbvgtuiFrame.leading = sbvgtuiFrame.trailing - sbvgtuiFrame.width;
            
        }
        else if (sbvsc.trailingPosInner.posNumVal != nil)
        {
            sbvgtuiFrame.trailing = selfSize.width -  lsc.gtuiLayoutTrailingPadding -  sbvsc.trailingPosInner.absVal + sbvsc.leadingPosInner.absVal;
            sbvgtuiFrame.leading = sbvgtuiFrame.trailing - sbvgtuiFrame.width;
        }
        else
        {
            
            sbvgtuiFrame.leading = sbvsc.leadingPosInner.absVal + lsc.gtuiLayoutLeadingPadding;
            sbvgtuiFrame.trailing = sbvgtuiFrame.leading + sbvgtuiFrame.width;
        }
        
    }
    
    //这里要更新左边最小和右边最大约束的情况。
    GTUILayoutPosition *lBoundPos = sbvsc.leadingPosInner.lBoundValInner;
    GTUILayoutPosition *uBoundPos = sbvsc.trailingPosInner.uBoundValInner;
    
    if (lBoundPos.posRelaVal != nil && uBoundPos.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minLeading = [self gtuiCalcSubView:lBoundPos.posRelaVal.view lsc:lsc gravity:lBoundPos.posRelaVal.pos selfSize:selfSize] + lBoundPos.offsetVal;
        
        CGFloat  maxTrailing = [self gtuiCalcSubView:uBoundPos.posRelaVal.view lsc:lsc gravity:uBoundPos.posRelaVal.pos selfSize:selfSize] - uBoundPos.offsetVal;
        
        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        CGFloat intervalWidth = maxTrailing - minLeading;
        if (_gtuiCGFloatLess(intervalWidth, sbvgtuiFrame.width))
        {
            sbvgtuiFrame.width = intervalWidth;
            sbvgtuiFrame.leading = minLeading;
        }
        else
        {
            sbvgtuiFrame.leading = (intervalWidth - sbvgtuiFrame.width) / 2 + minLeading;
        }
        
        sbvgtuiFrame.trailing = sbvgtuiFrame.leading + sbvgtuiFrame.width;
        
        
    }
    else if (lBoundPos.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minLeading = [self gtuiCalcSubView:lBoundPos.posRelaVal.view lsc:lsc gravity:lBoundPos.posRelaVal.pos selfSize:selfSize] + lBoundPos.offsetVal;
        
        
        if (_gtuiCGFloatLess(sbvgtuiFrame.leading, minLeading))
        {
            sbvgtuiFrame.leading = minLeading;
            sbvgtuiFrame.width = sbvgtuiFrame.trailing - sbvgtuiFrame.leading;
        }
    }
    else if (uBoundPos.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxTrailing = [self gtuiCalcSubView:uBoundPos.posRelaVal.view lsc:lsc gravity:uBoundPos.posRelaVal.pos selfSize:selfSize] -  uBoundPos.offsetVal;
        
        if (_gtuiCGFloatGreat(sbvgtuiFrame.trailing, maxTrailing))
        {
            sbvgtuiFrame.trailing = maxTrailing;
            sbvgtuiFrame.width = sbvgtuiFrame.trailing - sbvgtuiFrame.leading;
        }
    }
    
    
}

-(void)gtuiCalcSubViewTopBottom:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(GTUIRelativeLayout*)lsc sbvgtuiFrame:(GTUIFrame*)sbvgtuiFrame selfSize:(CGSize)selfSize
{
    
    
    if (sbvgtuiFrame.top != CGFLOAT_MAX && sbvgtuiFrame.bottom != CGFLOAT_MAX && sbvgtuiFrame.height != CGFLOAT_MAX)
        return;
    
    
    //先检测高度,如果高度是父亲的高度则高度和上下都确定
    if ([self gtuiCalcHeight:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize])
        return;
    
    if (sbvsc.baselinePosInner.posRelaVal != nil)
    {
        //得到基线的位置。基线的位置等于top + (子视图的高度 - 字体的高度) / 2 + 字体基线以上的高度。
        UIFont *sbvFont = [self gtuiGetSubviewFont:sbv];
        
        if (sbvFont != nil)
        {
            //得到基线的位置。
            UIView *relaView = sbvsc.baselinePosInner.posRelaVal.view;
            sbvgtuiFrame.top = [self gtuiCalcSubView:relaView lsc:lsc gravity:sbvsc.baselinePosInner.posRelaVal.pos selfSize:selfSize] - sbvFont.ascender - (sbvgtuiFrame.height - sbvFont.lineHeight) / 2 + sbvsc.baselinePosInner.absVal;
            
            if (relaView != nil && relaView != self && [self gtuiIsNoLayoutSubview:relaView])
            {
                sbvgtuiFrame.top -= sbvsc.baselinePosInner.absVal;
            }
        }
        else
        {
            sbvgtuiFrame.top =  lsc.topPadding + sbvsc.baselinePosInner.absVal;
        }
        
        sbvgtuiFrame.bottom = sbvgtuiFrame.top + sbvgtuiFrame.height;
        
    }
    else if (sbvsc.baselinePosInner.posNumVal != nil)
    {
        UIFont *sbvFont = [self gtuiGetSubviewFont:sbv];
        
        if (sbvFont != nil)
        {
            //根据基线位置反退顶部位置。
            sbvgtuiFrame.top = lsc.topPadding + sbvsc.baselinePosInner.absVal - sbvFont.ascender - (sbvgtuiFrame.height - sbvFont.lineHeight) / 2;
        }
        else
        {
            sbvgtuiFrame.top = lsc.topPadding + sbvsc.baselinePosInner.absVal;
        }
        
        sbvgtuiFrame.bottom = sbvgtuiFrame.top + sbvgtuiFrame.height;
        
    }
    else if (sbvsc.centerYPosInner.posRelaVal != nil)
    {
        UIView *relaView = sbvsc.centerYPosInner.posRelaVal.view;
        
        sbvgtuiFrame.top = [self gtuiCalcSubView:relaView lsc:lsc gravity:sbvsc.centerYPosInner.posRelaVal.pos selfSize:selfSize] - sbvgtuiFrame.height / 2 + sbvsc.centerYPosInner.absVal;
        
        
        if (relaView != nil && relaView != self && [self gtuiIsNoLayoutSubview:relaView])
        {
            sbvgtuiFrame.top -= sbvsc.centerYPosInner.absVal;
        }
        
        if (sbvgtuiFrame.top < 0 && relaView == self && lsc.wrapContentHeight)
            sbvgtuiFrame.top = 0;
        
        sbvgtuiFrame.bottom = sbvgtuiFrame.top + sbvgtuiFrame.height;
    }
    else if (sbvsc.centerYPosInner.posNumVal != nil)
    {
        sbvgtuiFrame.top = (selfSize.height - lsc.gtuiLayoutTopPadding - lsc.gtuiLayoutBottomPadding -  sbvgtuiFrame.height) / 2 + lsc.gtuiLayoutTopPadding + sbvsc.centerYPosInner.absVal;
        
        if (sbvgtuiFrame.top < 0 && lsc.wrapContentHeight)
            sbvgtuiFrame.top = 0;
        
        sbvgtuiFrame.bottom = sbvgtuiFrame.top + sbvgtuiFrame.height;
    }
    else
    {
        if (sbvsc.topPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.topPosInner.posRelaVal.view;
            
            sbvgtuiFrame.top = [self gtuiCalcSubView:relaView lsc:lsc gravity:sbvsc.topPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self gtuiIsNoLayoutSubview:relaView])
            {
                sbvgtuiFrame.top -= sbvsc.topPosInner.absVal;
            }
            
            sbvgtuiFrame.bottom = sbvgtuiFrame.top + sbvgtuiFrame.height;
        }
        else if (sbvsc.topPosInner.posNumVal != nil)
        {
            sbvgtuiFrame.top = sbvsc.topPosInner.absVal + lsc.gtuiLayoutTopPadding;
            sbvgtuiFrame.bottom = sbvgtuiFrame.top + sbvgtuiFrame.height;
        }
        else if (sbvsc.bottomPosInner.posRelaVal != nil)
        {
            UIView *relaView = sbvsc.bottomPosInner.posRelaVal.view;
            
            sbvgtuiFrame.bottom = [self gtuiCalcSubView:relaView lsc:lsc gravity:sbvsc.bottomPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.absVal + sbvsc.topPosInner.absVal;
            
            if (relaView != nil && relaView != self && [self gtuiIsNoLayoutSubview:relaView])
            {
                sbvgtuiFrame.bottom += sbvsc.bottomPosInner.absVal;
            }
            
            sbvgtuiFrame.top = sbvgtuiFrame.bottom - sbvgtuiFrame.height;
            
        }
        else if (sbvsc.bottomPosInner.posNumVal != nil)
        {
            if (selfSize.height == 0 && lsc.wrapContentHeight)
            {
                sbvgtuiFrame.top = lsc.gtuiLayoutTopPadding;
                sbvgtuiFrame.bottom = sbvgtuiFrame.top + sbvgtuiFrame.height;
            }
            else
            {
                
                sbvgtuiFrame.bottom = selfSize.height -  sbvsc.bottomPosInner.absVal - lsc.gtuiLayoutBottomPadding + sbvsc.topPosInner.absVal;
                sbvgtuiFrame.top = sbvgtuiFrame.bottom - sbvgtuiFrame.height;
            }
        }
        else
        {
            sbvgtuiFrame.top = sbvsc.topPosInner.absVal + lsc.gtuiLayoutTopPadding;
            sbvgtuiFrame.bottom = sbvgtuiFrame.top + sbvgtuiFrame.height;
        }
    }
    
    //这里要更新上边最小和下边最大约束的情况。
    if (sbvsc.topPosInner.lBoundValInner.posRelaVal != nil && sbvsc.bottomPosInner.uBoundValInner.posRelaVal != nil)
    {
        //让宽度缩小并在最小和最大的中间排列。
        CGFloat   minTop = [self gtuiCalcSubView:sbvsc.topPosInner.lBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.topPosInner.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.lBoundValInner.offsetVal;
        
        CGFloat   maxBottom = [self gtuiCalcSubView:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.uBoundValInner.offsetVal;
        
        //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
        if (_gtuiCGFloatLess(maxBottom - minTop, sbvgtuiFrame.height))
        {
            sbvgtuiFrame.height = maxBottom - minTop;
            sbvgtuiFrame.top = minTop;
        }
        else
        {
            sbvgtuiFrame.top = (maxBottom - minTop - sbvgtuiFrame.height) / 2 + minTop;
        }
        
        sbvgtuiFrame.bottom = sbvgtuiFrame.top + sbvgtuiFrame.height;
        
        
    }
    else if (sbvsc.topPosInner.lBoundValInner.posRelaVal != nil)
    {
        //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
        CGFloat   minTop = [self gtuiCalcSubView:sbvsc.topPosInner.lBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.topPosInner.lBoundValInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.lBoundValInner.offsetVal;
        
        if (_gtuiCGFloatLess(sbvgtuiFrame.top, minTop))
        {
            sbvgtuiFrame.top = minTop;
            sbvgtuiFrame.height = sbvgtuiFrame.bottom - sbvgtuiFrame.top;
        }
        
    }
    else if (sbvsc.bottomPosInner.uBoundValInner.posRelaVal != nil)
    {
        //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
        CGFloat   maxBottom = [self gtuiCalcSubView:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.uBoundValInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.uBoundValInner.offsetVal;
        if (_gtuiCGFloatGreat(sbvgtuiFrame.bottom, maxBottom))
        {
            sbvgtuiFrame.bottom = maxBottom;
            sbvgtuiFrame.height = sbvgtuiFrame.bottom - sbvgtuiFrame.top;
        }
        
    }
    
    
}



-(CGFloat)gtuiCalcSubView:(UIView*)sbv lsc:(GTUIRelativeLayout*)lsc gravity:(GTUIGravity)gravity selfSize:(CGSize)selfSize
{
    GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
    UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
    
    switch (gravity) {
        case GTUIGravityHorzLeading:
        {
            if (sbv == self || sbv == nil)
                return lsc.gtuiLayoutLeadingPadding;
            
            
            if (sbvgtuiFrame.leading != CGFLOAT_MAX)
                return sbvgtuiFrame.leading;
            
            [self gtuiCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
            
            return sbvgtuiFrame.leading;
            
        }
            break;
        case GTUIGravityHorzTrailing:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - lsc.gtuiLayoutTrailingPadding;
            
            if (sbvgtuiFrame.trailing != CGFLOAT_MAX)
                return sbvgtuiFrame.trailing;
            
            [self gtuiCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
            
            return sbvgtuiFrame.trailing;
            
        }
            break;
        case GTUIGravityVertTop:
        {
            if (sbv == self || sbv == nil)
                return lsc.gtuiLayoutTopPadding;
            
            
            if (sbvgtuiFrame.top != CGFLOAT_MAX)
                return sbvgtuiFrame.top;
            
            [self gtuiCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
            
            return sbvgtuiFrame.top;
            
        }
            break;
        case GTUIGravityVertBottom:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - lsc.gtuiLayoutBottomPadding;
            
            
            if (sbvgtuiFrame.bottom != CGFLOAT_MAX)
                return sbvgtuiFrame.bottom;
            
            [self gtuiCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
            
            return sbvgtuiFrame.bottom;
        }
            break;
        case GTUIGravityVertBaseline:
        {
            if (sbv == self || sbv == nil)
                return lsc.topPadding;
            
            UIFont *sbvFont = [self gtuiGetSubviewFont:sbv];
            if (sbvFont != nil)
            {
                if (sbvgtuiFrame.top == CGFLOAT_MAX || sbvgtuiFrame.height == CGFLOAT_MAX)
                    [self gtuiCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
                
                //得到基线的位置。
                return sbvgtuiFrame.top + (sbvgtuiFrame.height - sbvFont.lineHeight)/2.0 + sbvFont.ascender;
                
            }
            else
            {
                if (sbvgtuiFrame.top != CGFLOAT_MAX)
                    return sbvgtuiFrame.top;
                
                [self gtuiCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
                
                return sbvgtuiFrame.top;
            }
            
        }
            break;
        case GTUIGravityHorzFill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.width - lsc.gtuiLayoutLeadingPadding - lsc.gtuiLayoutTrailingPadding;
            
            
            if (sbvgtuiFrame.width != CGFLOAT_MAX)
                return sbvgtuiFrame.width;
            
            [self gtuiCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
            
            return sbvgtuiFrame.width;
            
        }
            break;
        case GTUIGravityVertFill:
        {
            if (sbv == self || sbv == nil)
                return selfSize.height - lsc.gtuiLayoutTopPadding - lsc.gtuiLayoutBottomPadding;
            
            
            if (sbvgtuiFrame.height != CGFLOAT_MAX)
                return sbvgtuiFrame.height;
            
            [self gtuiCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
            
            return sbvgtuiFrame.height;
        }
            break;
        case GTUIGravityHorzCenter:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.width - lsc.gtuiLayoutLeadingPadding - lsc.gtuiLayoutTrailingPadding) / 2 + lsc.gtuiLayoutLeadingPadding;
            
            if (sbvgtuiFrame.leading != CGFLOAT_MAX && sbvgtuiFrame.trailing != CGFLOAT_MAX &&  sbvgtuiFrame.width != CGFLOAT_MAX)
                return sbvgtuiFrame.leading + sbvgtuiFrame.width / 2;
            
            [self gtuiCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
            
            return sbvgtuiFrame.leading + sbvgtuiFrame.width / 2;
            
        }
            break;
            
        case GTUIGravityVertCenter:
        {
            if (sbv == self || sbv == nil)
                return (selfSize.height - lsc.gtuiLayoutTopPadding - lsc.gtuiLayoutBottomPadding) / 2 + lsc.gtuiLayoutTopPadding;
            
            if (sbvgtuiFrame.top != CGFLOAT_MAX && sbvgtuiFrame.bottom != CGFLOAT_MAX &&  sbvgtuiFrame.height != CGFLOAT_MAX)
                return sbvgtuiFrame.top + sbvgtuiFrame.height / 2;
            
            [self gtuiCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
            
            return sbvgtuiFrame.top + sbvgtuiFrame.height / 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}


-(BOOL)gtuiCalcWidth:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(GTUIRelativeLayout*)lsc sbvgtuiFrame:(GTUIFrame*)sbvgtuiFrame selfSize:(CGSize)selfSize
{
    
    if (sbvgtuiFrame.width == CGFLOAT_MAX)
    {
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil)
        {
            
            sbvgtuiFrame.width = [sbvsc.widthSizeInner measureWith:[self gtuiCalcSubView:sbvsc.widthSizeInner.dimeRelaVal.view lsc:lsc gravity:sbvsc.widthSizeInner.dimeRelaVal.dime selfSize:selfSize] ];
            
            sbvgtuiFrame.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvgtuiFrame.width sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbvsc.widthSizeInner.dimeNumVal != nil)
        {
            sbvgtuiFrame.width = sbvsc.widthSizeInner.measure;
            sbvgtuiFrame.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvgtuiFrame.width sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self gtuiIsNoLayoutSubview:sbv])
        {
            sbvgtuiFrame.width = 0;
        }
        
        if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
        {
            if (sbvsc.leadingPosInner.posRelaVal != nil)
                sbvgtuiFrame.leading = [self gtuiCalcSubView:sbvsc.leadingPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.leadingPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.leadingPosInner.absVal;
            else
                sbvgtuiFrame.leading = sbvsc.leadingPosInner.absVal + lsc.gtuiLayoutLeadingPadding;
            
            if (sbvsc.trailingPosInner.posRelaVal != nil)
                sbvgtuiFrame.trailing = [self gtuiCalcSubView:sbvsc.trailingPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.trailingPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.trailingPosInner.absVal;
            else
                sbvgtuiFrame.trailing = selfSize.width - sbvsc.trailingPosInner.absVal - lsc.gtuiLayoutTrailingPadding;
            
            sbvgtuiFrame.width = sbvgtuiFrame.trailing - sbvgtuiFrame.leading;
            sbvgtuiFrame.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvgtuiFrame.width sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self gtuiIsNoLayoutSubview:sbv])
            {
                sbvgtuiFrame.width = 0;
                sbvgtuiFrame.trailing = sbvgtuiFrame.leading + sbvgtuiFrame.width;
            }
            
            
            return YES;
            
        }
        
        
        if (sbvgtuiFrame.width == CGFLOAT_MAX)
        {
            sbvgtuiFrame.width = CGRectGetWidth(sbv.bounds);
            sbvgtuiFrame.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvgtuiFrame.width sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
        }
    }
    
    if ((sbvsc.widthSizeInner.lBoundValInner != nil && sbvsc.widthSizeInner.lBoundValInner.dimeNumVal.doubleValue != -CGFLOAT_MAX) ||
        (sbvsc.widthSizeInner.uBoundValInner != nil && sbvsc.widthSizeInner.uBoundValInner.dimeNumVal.doubleValue != CGFLOAT_MAX) )
    {
        sbvgtuiFrame.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvgtuiFrame.width sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
    }
    
    
    return NO;
}


-(BOOL)gtuiCalcHeight:(UIView*)sbv sbvsc:(UIView*)sbvsc lsc:(GTUIRelativeLayout*)lsc sbvgtuiFrame:(GTUIFrame*)sbvgtuiFrame selfSize:(CGSize)selfSize
{
    
    if (sbvgtuiFrame.height == CGFLOAT_MAX)
    {
        if (sbvsc.heightSizeInner.dimeRelaVal != nil)
        {
            
            sbvgtuiFrame.height = [sbvsc.heightSizeInner measureWith:[self gtuiCalcSubView:sbvsc.heightSizeInner.dimeRelaVal.view lsc:lsc gravity:sbvsc.heightSizeInner.dimeRelaVal.dime selfSize:selfSize] ];
            
            sbvgtuiFrame.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvgtuiFrame.height sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else if (sbvsc.heightSizeInner.dimeNumVal != nil)
        {
            sbvgtuiFrame.height = sbvsc.heightSizeInner.measure;
            sbvgtuiFrame.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvgtuiFrame.height sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
            
        }
        else;
        
        if ([self gtuiIsNoLayoutSubview:sbv])
        {
            sbvgtuiFrame.height = 0;
        }
        
        
        if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
        {
            if (sbvsc.topPosInner.posRelaVal != nil)
                sbvgtuiFrame.top = [self gtuiCalcSubView:sbvsc.topPosInner.posRelaVal.view lsc:lsc  gravity:sbvsc.topPosInner.posRelaVal.pos selfSize:selfSize] + sbvsc.topPosInner.absVal;
            else
                sbvgtuiFrame.top = sbvsc.topPosInner.absVal + lsc.gtuiLayoutTopPadding;
            
            if (sbvsc.bottomPosInner.posRelaVal != nil)
                sbvgtuiFrame.bottom = [self gtuiCalcSubView:sbvsc.bottomPosInner.posRelaVal.view lsc:lsc gravity:sbvsc.bottomPosInner.posRelaVal.pos selfSize:selfSize] - sbvsc.bottomPosInner.absVal;
            else
                sbvgtuiFrame.bottom = selfSize.height - sbvsc.bottomPosInner.absVal - lsc.gtuiLayoutBottomPadding;
            
            sbvgtuiFrame.height = sbvgtuiFrame.bottom - sbvgtuiFrame.top;
            sbvgtuiFrame.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvgtuiFrame.height sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
            
            if ([self gtuiIsNoLayoutSubview:sbv])
            {
                sbvgtuiFrame.height = 0;
                sbvgtuiFrame.bottom = sbvgtuiFrame.top + sbvgtuiFrame.height;
            }
            
            
            return YES;
            
        }
        
        
        if (sbvgtuiFrame.height == CGFLOAT_MAX)
        {
            sbvgtuiFrame.height = CGRectGetHeight(sbv.bounds);
            
            if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]] && ![self gtuiIsNoLayoutSubview:sbv])
            {
                if (sbvgtuiFrame.width == CGFLOAT_MAX)
                    [self gtuiCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
                
                sbvgtuiFrame.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:sbvgtuiFrame.width];
            }
            
            sbvgtuiFrame.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvgtuiFrame.height sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
            
            
        }
    }
    
    if ( (sbvsc.heightSizeInner.lBoundValInner != nil && sbvsc.heightSizeInner.lBoundValInner.dimeNumVal.doubleValue != -CGFLOAT_MAX) ||
        (sbvsc.heightSizeInner.uBoundValInner != nil && sbvsc.heightSizeInner.uBoundValInner.dimeNumVal.doubleValue != CGFLOAT_MAX))
    {
        sbvgtuiFrame.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvgtuiFrame.height sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
    }
    
    return NO;
    
}


-(CGSize)gtuiCalcLayout:(BOOL*)pRecalc lsc:(GTUIRelativeLayout*)lsc selfSize:(CGSize)selfSize
{
    if (pRecalc != NULL)
        *pRecalc = NO;
    
    
    //遍历所有子视图，算出所有宽度和高度根据自身内容确定的子视图的尺寸.以及计算出那些有依赖关系的尺寸限制。。。
    for (UIView *sbv in self.subviews)
    {
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        
        [self gtuiCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvgtuiFrame:sbvgtuiFrame];
        
        if (sbvgtuiFrame.width != CGFLOAT_MAX)
        {
            if (sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal != nil && sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view != self)
            {
                [self gtuiCalcWidth:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view
                            sbvsc:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view.gtuiCurrentSizeClass
                              lsc:lsc
                       sbvgtuiFrame:sbvsc.widthSizeInner.uBoundValInner.dimeRelaVal.view.gtuiFrame
                         selfSize:selfSize];
            }
            
            if (sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal != nil && sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view != self)
            {
                [self gtuiCalcWidth:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view
                            sbvsc:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view.gtuiCurrentSizeClass
                              lsc:lsc
                       sbvgtuiFrame:sbvsc.widthSizeInner.lBoundValInner.dimeRelaVal.view.gtuiFrame
                         selfSize:selfSize];
            }
            
            sbvgtuiFrame.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:sbvgtuiFrame.width sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
        }
        
        if (sbvgtuiFrame.height != CGFLOAT_MAX)
        {
            if (sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal != nil && sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view != self)
            {
                [self gtuiCalcHeight:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view
                             sbvsc:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view.gtuiCurrentSizeClass
                               lsc:lsc
                        sbvgtuiFrame:sbvsc.heightSizeInner.uBoundValInner.dimeRelaVal.view.gtuiFrame
                          selfSize:selfSize];
            }
            
            if (sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal != nil && sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view != self)
            {
                [self gtuiCalcHeight:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view
                             sbvsc:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view.gtuiCurrentSizeClass
                               lsc:lsc
                        sbvgtuiFrame:sbvsc.heightSizeInner.lBoundValInner.dimeRelaVal.view.gtuiFrame
                          selfSize:selfSize];
            }
            
            sbvgtuiFrame.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvgtuiFrame.height sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
        }
        
    }
    
    //均分宽度和高度。把这部分提出来是为了实现不管数组是哪个视图指定都可以。
    for (UIView *sbv in self.subviews)
    {
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        if (sbvsc.widthSizeInner.dimeArrVal != nil)
        {
            if (pRecalc != NULL)
                *pRecalc = YES;
            
            NSArray *dimeArray = sbvsc.widthSizeInner.dimeArrVal;
            
            BOOL isViewHidden = [self gtuiIsNoLayoutSubview:sbv];
            CGFloat totalMulti = isViewHidden ? 0 : sbvsc.widthSizeInner.multiVal;
            CGFloat totalAdd =  isViewHidden ? 0 : sbvsc.widthSizeInner.addVal;
            for (GTUILayoutSize *dime in dimeArray)
            {
                
                if (dime.isActive)
                {
                    isViewHidden = [self gtuiIsNoLayoutSubview:dime.view];
                    if (!isViewHidden)
                    {
                        if (dime.dimeVal != nil)
                        {
                            [self gtuiCalcWidth:dime.view
                                        sbvsc:dime.view.gtuiCurrentSizeClass
                                          lsc:lsc
                                   sbvgtuiFrame:dime.view.gtuiFrame
                                     selfSize:selfSize];
                            
                            totalAdd += -1 * dime.view.gtuiFrame.width;
                        }
                        else
                        {
                            totalMulti += dime.multiVal;
                        }
                        
                        totalAdd += dime.addVal;
                        
                    }
                }
                
            }
            
            CGFloat floatingWidth = selfSize.width - lsc.gtuiLayoutLeadingPadding - lsc.gtuiLayoutTrailingPadding + totalAdd;
            if ( _gtuiCGFloatLessOrEqual(floatingWidth, 0))
                floatingWidth = 0;
            
            if (totalMulti != 0)
            {
                CGFloat tempWidth = _gtuiCGFloatRound(floatingWidth * (sbvsc.widthSizeInner.multiVal / totalMulti));
                
                sbvgtuiFrame.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:tempWidth sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self gtuiIsNoLayoutSubview:sbv])
                {
                    sbvgtuiFrame.width = 0;
                }
                else
                {
                    floatingWidth -= tempWidth;
                    totalMulti -= sbvsc.widthSizeInner.multiVal;
                }
                
                for (GTUILayoutSize *dime in dimeArray)
                {
                    if (dime.isActive && ![self gtuiIsNoLayoutSubview:dime.view])
                    {
                        if (dime.dimeVal == nil)
                        {
                            tempWidth = _gtuiCGFloatRound(floatingWidth * (dime.multiVal / totalMulti));
                            floatingWidth -= tempWidth;
                            totalMulti -= dime.multiVal;
                            dime.view.gtuiFrame.width = tempWidth;
                            
                        }
                        
                        dime.view.gtuiFrame.width = [self gtuiValidMeasure:dime.view.widthSize sbv:dime.view calcSize:dime.view.gtuiFrame.width sbvSize:dime.view.gtuiFrame.frame.size selfLayoutSize:selfSize];
                    }
                    else
                    {
                        dime.view.gtuiFrame.width = 0;
                    }
                }
            }
        }
        
        if (sbvsc.heightSizeInner.dimeArrVal != nil)
        {
            if (pRecalc != NULL)
                *pRecalc = YES;
            
            NSArray *dimeArray = sbvsc.heightSizeInner.dimeArrVal;
            
            BOOL isViewHidden = [self gtuiIsNoLayoutSubview:sbv];
            
            CGFloat totalMulti = isViewHidden ? 0 : sbvsc.heightSizeInner.multiVal;
            CGFloat totalAdd = isViewHidden ? 0 : sbvsc.heightSizeInner.addVal;
            for (GTUILayoutSize *dime in dimeArray)
            {
                if (dime.isActive)
                {
                    isViewHidden = [self gtuiIsNoLayoutSubview:dime.view];
                    if (!isViewHidden)
                    {
                        if (dime.dimeVal != nil)
                        {
                            [self gtuiCalcHeight:dime.view
                                         sbvsc:dime.view.gtuiCurrentSizeClass
                                           lsc:lsc
                                    sbvgtuiFrame:dime.view.gtuiFrame
                                      selfSize:selfSize];
                            
                            totalAdd += -1 * dime.view.gtuiFrame.height;
                        }
                        else
                            totalMulti += dime.multiVal;
                        
                        totalAdd += dime.addVal;
                    }
                }
            }
            
            CGFloat floatingHeight = selfSize.height - lsc.gtuiLayoutTopPadding - lsc.gtuiLayoutBottomPadding + totalAdd;
            if (_gtuiCGFloatLessOrEqual(floatingHeight, 0))
                floatingHeight = 0;
            
            if (totalMulti != 0)
            {
                CGFloat tempHeight = _gtuiCGFloatRound(floatingHeight * (sbvsc.heightSizeInner.multiVal / totalMulti));
                sbvgtuiFrame.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:tempHeight sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
                
                if ([self gtuiIsNoLayoutSubview:sbv])
                {
                    sbvgtuiFrame.height = 0;
                }
                else
                {
                    floatingHeight -= tempHeight;
                    totalMulti -= sbvsc.heightSizeInner.multiVal;
                }
                
                for (GTUILayoutSize *dime in dimeArray)
                {
                    if (dime.isActive && ![self gtuiIsNoLayoutSubview:dime.view])
                    {
                        if (dime.dimeVal == nil)
                        {
                            tempHeight = _gtuiCGFloatRound(floatingHeight * (dime.multiVal / totalMulti));
                            floatingHeight -= tempHeight;
                            totalMulti -= dime.multiVal;
                            dime.view.gtuiFrame.height = tempHeight;
                        }
                        
                        dime.view.gtuiFrame.height = [self gtuiValidMeasure:dime.view.heightSize sbv:dime.view calcSize:dime.view.gtuiFrame.height sbvSize:dime.view.gtuiFrame.frame.size selfLayoutSize:selfSize];
                        
                    }
                    else
                    {
                        dime.view.gtuiFrame.height = 0;
                    }
                }
            }
        }
        
        
        //表示视图数组水平居中
        if (sbvsc.centerXPosInner.posArrVal != nil)
        {
            //先算出所有关联视图的宽度。再计算出关联视图的左边和右边的绝对值。
            NSArray *centerArray = sbvsc.centerXPosInner.posArrVal;
            
            CGFloat totalWidth = 0;
            CGFloat totalOffset = 0;
            
            GTUILayoutPosition *nextPos = nil;
            for (NSInteger i = centerArray.count - 1; i >= 0; i--)
            {
                GTUILayoutPosition *pos = centerArray[i];
                if (![self gtuiIsNoLayoutSubview:pos.view])
                {
                    if (totalWidth != 0)
                    {
                        if (nextPos != nil)
                            totalOffset += nextPos.view.centerXPos.absVal;
                    }
                    
                    [self gtuiCalcWidth:pos.view sbvsc:pos.view.gtuiCurrentSizeClass lsc:lsc sbvgtuiFrame:pos.view.gtuiFrame selfSize:selfSize];
                    totalWidth += pos.view.gtuiFrame.width;
                }
                
                nextPos = pos;
            }
            
            if (![self gtuiIsNoLayoutSubview:sbv])
            {
                if (totalWidth != 0)
                {
                    if (nextPos != nil)
                        totalOffset += nextPos.view.centerXPos.absVal;
                }
                
                [self gtuiCalcWidth:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
                totalWidth += sbvgtuiFrame.width;
                totalOffset += sbvsc.centerXPosInner.absVal;
            }
            
            
            //所有宽度算出后，再分别设置
            CGFloat leadingOffset = (selfSize.width - lsc.gtuiLayoutLeadingPadding - lsc.gtuiLayoutTrailingPadding - totalWidth - totalOffset) / 2;
            leadingOffset += lsc.gtuiLayoutLeadingPadding;
            id prev = @(leadingOffset);
            [sbvsc.leadingPos __equalTo:prev];
            prev = sbvsc.trailingPos;
            for (GTUILayoutPosition *pos in centerArray)
            {
                [[pos.view.leadingPos __equalTo:prev] __offset:pos.view.centerXPos.absVal];
                prev = pos.view.trailingPos;
            }
        }
        
        //表示视图数组垂直居中
        if (sbvsc.centerYPosInner.posArrVal != nil)
        {
            NSArray *centerArray = sbvsc.centerYPosInner.posArrVal;
            
            CGFloat totalHeight = 0;
            CGFloat totalOffset = 0;
            
            GTUILayoutPosition *nextPos = nil;
            for (NSInteger i = centerArray.count - 1; i >= 0; i--)
            {
                GTUILayoutPosition *pos = centerArray[i];
                if (![self gtuiIsNoLayoutSubview:pos.view])
                {
                    if (totalHeight != 0)
                    {
                        if (nextPos != nil)
                            totalOffset += nextPos.view.centerYPos.absVal;
                    }
                    
                    [self gtuiCalcHeight:pos.view sbvsc:pos.view.gtuiCurrentSizeClass lsc:lsc sbvgtuiFrame:pos.view.gtuiFrame selfSize:selfSize];
                    totalHeight += pos.view.gtuiFrame.height;
                }
                
                nextPos = pos;
            }
            
            if (![self gtuiIsNoLayoutSubview:sbv])
            {
                if (totalHeight != 0)
                {
                    if (nextPos != nil)
                        totalOffset += nextPos.view.centerYPos.absVal;
                }
                
                [self gtuiCalcHeight:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
                totalHeight += sbvgtuiFrame.height;
                totalOffset += sbvsc.centerYPosInner.absVal;
            }
            
            
            //所有高度算出后，再分别设置
            CGFloat topOffset = (selfSize.height - lsc.gtuiLayoutTopPadding - lsc.gtuiLayoutBottomPadding - totalHeight - totalOffset) / 2;
            topOffset += lsc.gtuiLayoutTopPadding;
            
            id prev = @(topOffset);
            [sbvsc.topPos __equalTo:prev];
            prev = sbvsc.bottomPos;
            for (GTUILayoutPosition *pos in centerArray)
            {
                [[pos.view.topPos __equalTo:prev] __offset:pos.view.centerYPos.absVal];
                prev = pos.view.bottomPos;
            }
            
        }
        
        
    }
    
    //计算最大的宽度和高度
    CGFloat maxWidth = lsc.gtuiLayoutLeadingPadding + lsc.gtuiLayoutTrailingPadding;
    CGFloat maxHeight = lsc.gtuiLayoutTopPadding + lsc.gtuiLayoutBottomPadding;
    
    for (UIView *sbv in self.subviews)
    {
        
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        BOOL sbvWrapContentHeight = sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]];
        
        [self gtuiCalcSubViewLeadingTrailing:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
        
        //特殊处理高度包裹的情况，如果高度包裹时则同时设置顶部和底部将无效。
        if (sbvWrapContentHeight)
        {
            sbvgtuiFrame.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:sbvgtuiFrame.width];
            sbvgtuiFrame.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:sbvgtuiFrame.height sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
        }
        
        [self gtuiCalcSubViewTopBottom:sbv sbvsc:sbvsc lsc:lsc sbvgtuiFrame:sbvgtuiFrame selfSize:selfSize];
        
        if ([self gtuiIsNoLayoutSubview:sbv])
            continue;
        
        
        if (lsc.wrapContentWidth && pRecalc != NULL)
        {
            //当有子视图依赖于父视图的一些设置时，需要重新进行布局(设置了右边或者中间的值，或者宽度依赖父视图)
            if(sbvsc.trailingPosInner.posNumVal != nil ||
               sbvsc.trailingPosInner.posRelaVal.view == self ||
               sbvsc.centerXPosInner.posRelaVal.view == self ||
               sbvsc.centerXPosInner.posNumVal != nil ||
               sbvsc.widthSizeInner.dimeRelaVal.view == self
               )
            {
                *pRecalc = YES;
            }
            
            //宽度最小是任何一个子视图的左右偏移和外加内边距和。
            if (_gtuiCGFloatLess(maxWidth, sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.gtuiLayoutLeadingPadding + lsc.gtuiLayoutTrailingPadding))
            {
                maxWidth = sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.gtuiLayoutLeadingPadding + lsc.gtuiLayoutTrailingPadding;
            }
            
            if (sbvsc.widthSizeInner.dimeRelaVal == nil || sbvsc.widthSizeInner.dimeRelaVal != self.widthSizeInner)
            {
                if (sbvsc.centerXPosInner.posVal != nil)
                {
                    if (_gtuiCGFloatLess(maxWidth, sbvgtuiFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.gtuiLayoutLeadingPadding + lsc.gtuiLayoutTrailingPadding))
                        maxWidth = sbvgtuiFrame.width + sbvsc.leadingPosInner.absVal + sbvsc.trailingPosInner.absVal + lsc.gtuiLayoutLeadingPadding + lsc.gtuiLayoutTrailingPadding;
                }
                else if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
                {
                    if (_gtuiCGFloatLess(maxWidth, fabs(sbvgtuiFrame.trailing) + sbvsc.leadingPosInner.absVal + lsc.gtuiLayoutLeadingPadding))
                    {
                        maxWidth = fabs(sbvgtuiFrame.trailing) + sbvsc.leadingPosInner.absVal + lsc.gtuiLayoutLeadingPadding;
                    }
                    
                }
                else if (sbvsc.trailingPosInner.posVal != nil)
                {
                    if (_gtuiCGFloatLess(maxWidth, fabs(sbvgtuiFrame.leading) + lsc.gtuiLayoutLeadingPadding))
                        maxWidth = fabs(sbvgtuiFrame.leading) + lsc.gtuiLayoutLeadingPadding;
                }
                else
                {
                    if (_gtuiCGFloatLess(maxWidth, fabs(sbvgtuiFrame.trailing) + lsc.gtuiLayoutTrailingPadding))
                        maxWidth = fabs(sbvgtuiFrame.trailing) + lsc.gtuiLayoutTrailingPadding;
                }
                
                
                if (_gtuiCGFloatLess(maxWidth, sbvgtuiFrame.trailing + sbvsc.trailingPosInner.absVal + lsc.gtuiLayoutTrailingPadding))
                    maxWidth = sbvgtuiFrame.trailing + sbvsc.trailingPosInner.absVal + lsc.gtuiLayoutTrailingPadding;
            }
        }
        
        if (lsc.wrapContentHeight && pRecalc != NULL)
        {
            //当有子视图依赖于父视图的一些设置时，需要重新进行布局(设置了下边或者中间的值，或者高度依赖父视图)
            if(sbvsc.bottomPosInner.posNumVal != nil ||
               sbvsc.bottomPosInner.posRelaVal.view == self ||
               sbvsc.centerYPosInner.posRelaVal.view == self ||
               sbvsc.centerYPosInner.posNumVal != nil ||
               sbvsc.heightSizeInner.dimeRelaVal.view == self
               )
            {
                *pRecalc = YES;
            }
            
            if (_gtuiCGFloatLess(maxHeight, sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.gtuiLayoutTopPadding + lsc.gtuiLayoutBottomPadding))
            {
                maxHeight = sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.gtuiLayoutTopPadding + lsc.gtuiLayoutBottomPadding;
            }
            
            
            //这里加入特殊的条件sbvWrapContentHeight，因为有可能有同时设置顶部和底部位置又同时设置wrapContentHeight的情况，这种情况我们也让其加入最大高度计算行列。
            if (sbvsc.heightSizeInner.dimeRelaVal == nil || sbvsc.heightSizeInner.dimeRelaVal != self.heightSizeInner)
            {
                
                if (sbvsc.centerYPosInner.posVal != nil)
                {
                    if (_gtuiCGFloatLess(maxHeight, sbvgtuiFrame.height + sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.gtuiLayoutTopPadding + lsc.gtuiLayoutBottomPadding))
                        maxHeight = sbvgtuiFrame.height + sbvsc.topPosInner.absVal + sbvsc.bottomPosInner.absVal + lsc.gtuiLayoutTopPadding + lsc.gtuiLayoutBottomPadding;
                }
                else if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
                {
                    if (_gtuiCGFloatLess(maxHeight, fabs(sbvgtuiFrame.bottom) + sbvsc.topPosInner.absVal + lsc.gtuiLayoutTopPadding))
                    {
                        maxHeight = fabs(sbvgtuiFrame.bottom) + sbvsc.topPosInner.absVal + lsc.gtuiLayoutTopPadding;
                    }
                }
                else if (sbvsc.bottomPosInner.posVal != nil)
                {
                    if (_gtuiCGFloatLess(maxHeight, fabs(sbvgtuiFrame.top) + lsc.gtuiLayoutTopPadding))
                        maxHeight = fabs(sbvgtuiFrame.top) + lsc.gtuiLayoutTopPadding;
                }
                else
                {
                    if (_gtuiCGFloatLess(maxHeight, fabs(sbvgtuiFrame.bottom) + lsc.gtuiLayoutBottomPadding))
                        maxHeight = fabs(sbvgtuiFrame.bottom) + lsc.gtuiLayoutBottomPadding;
                }
                
                
                if (_gtuiCGFloatLess(maxHeight, sbvgtuiFrame.bottom + sbvsc.bottomPosInner.absVal + lsc.gtuiLayoutBottomPadding))
                    maxHeight = sbvgtuiFrame.bottom + sbvsc.bottomPosInner.absVal + lsc.gtuiLayoutBottomPadding;
                
            }
        }
    }
    
    
    return CGSizeMake(maxWidth, maxHeight);
    
}

@end
