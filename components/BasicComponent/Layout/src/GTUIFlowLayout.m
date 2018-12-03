//
//  GTUIFlowLayout.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUIFlowLayout.h"
#import "GTUILayout+Private.h"

@implementation GTUIFlowLayout

#pragma mark -- Public Methods

-(instancetype)initWithFrame:(CGRect)frame orientation:(GTUIOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.gtuiCurrentSizeClass.orientation = orientation;
        self.gtuiCurrentSizeClass.arrangedCount = arrangedCount;
    }
    
    return  self;
}

-(instancetype)initWithOrientation:(GTUIOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    return [self initWithFrame:CGRectZero orientation:orientation arrangedCount:arrangedCount];
}


+(instancetype)flowLayoutWithOrientation:(GTUIOrientation)orientation arrangedCount:(NSInteger)arrangedCount
{
    GTUIFlowLayout *layout = [[[self class] alloc] initWithOrientation:orientation arrangedCount:arrangedCount];
    return layout;
}

-(void)setOrientation:(GTUIOrientation)orientation
{
    GTUIFlowLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.orientation != orientation)
    {
        lsc.orientation = orientation;
        [self setNeedsLayout];
    }
}

-(GTUIOrientation)orientation
{
    return self.gtuiCurrentSizeClass.orientation;
}


-(void)setArrangedCount:(NSInteger)arrangedCount
{
    GTUIFlowLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.arrangedCount != arrangedCount)
    {
        lsc.arrangedCount = arrangedCount;
        [self setNeedsLayout];
    }
}

-(NSInteger)arrangedCount
{
    GTUIFlowLayout *lsc = self.gtuiCurrentSizeClass;
    return lsc.arrangedCount;
}


-(NSInteger)pagedCount
{
    GTUIFlowLayout *lsc = self.gtuiCurrentSizeClass;
    return lsc.pagedCount;
}

-(void)setPagedCount:(NSInteger)pagedCount
{
    GTUIFlowLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.pagedCount != pagedCount)
    {
        lsc.pagedCount = pagedCount;
        [self setNeedsLayout];
    }
}


-(void)setAutoArrange:(BOOL)autoArrange
{
    GTUIFlowLayout *lsc = self.gtuiCurrentSizeClass;
    
    if (lsc.autoArrange != autoArrange)
    {
        lsc.autoArrange = autoArrange;
        [self setNeedsLayout];
    }
}

-(BOOL)autoArrange
{
    return self.gtuiCurrentSizeClass.autoArrange;
}


-(void)setArrangedGravity:(GTUIGravity)arrangedGravity
{
    GTUIFlowLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.arrangedGravity != arrangedGravity)
    {
        lsc.arrangedGravity = arrangedGravity;
        [self setNeedsLayout];
    }
}

-(GTUIGravity)arrangedGravity
{
    return self.gtuiCurrentSizeClass.arrangedGravity;
}


-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace
{
    [self setSubviewsSize:subviewSize minSpace:minSpace maxSpace:maxSpace inSizeClass:GTUISizeClasshAny | GTUISizeClasswAny];
}

-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(GTUISizeClass)sizeClass
{
    GTUIFlowLayoutViewSizeClass *lsc = (GTUIFlowLayoutViewSizeClass*)[self fetchLayoutSizeClass:sizeClass];
    lsc.subviewSize = subviewSize;
    lsc.maxSpace = maxSpace;
    lsc.minSpace = minSpace;
    [self setNeedsLayout];
}


#pragma mark -- Override Methods

-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(GTUISizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self gtuiGetLayoutSubviews];
    
    GTUIFlowLayout *lsc = self.gtuiCurrentSizeClass;
    
    GTUIOrientation orientation = lsc.orientation;
    GTUIGravity gravity = lsc.gravity;
    GTUIGravity arrangedGravity = lsc.arrangedGravity;
    
    for (UIView *sbv in sbs)
    {
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        if (!isEstimate)
        {
            sbvgtuiFrame.frame = sbv.bounds;
            [self gtuiCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvgtuiFrame:sbvgtuiFrame];
        }
        
        if ([sbv isKindOfClass:[GTUIBaseLayout class]])
        {
            
            if (sbvsc.wrapContentWidth)
            {
                if (lsc.pagedCount > 0 || sbvsc.widthSizeInner.dimeVal != nil ||
                    (orientation == GTUIOrientationHorz && (arrangedGravity & GTUIGravityVertMask) == GTUIGravityHorzFill) ||
                    (orientation == GTUIOrientationVert && ((gravity & GTUIGravityVertMask) == GTUIGravityHorzFill || sbvsc.weight != 0)))
                {
                    sbvsc.wrapContentWidth = NO;
                }
            }
            
            if (sbvsc.wrapContentHeight)
            {
                if (lsc.pagedCount > 0 || sbvsc.heightSizeInner.dimeVal != nil ||
                    (orientation == GTUIOrientationVert && (arrangedGravity & GTUIGravityHorzMask) == GTUIGravityVertFill) ||
                    (orientation == GTUIOrientationHorz && ((gravity & GTUIGravityHorzMask) == GTUIGravityVertFill || sbvsc.weight != 0)))
                {
                    sbvsc.wrapContentHeight = NO;
                }
            }
            
            
            BOOL isSbvWrap = sbvsc.wrapContentHeight || sbvsc.wrapContentWidth;
            
            if (pHasSubLayout != nil && isSbvWrap)
                *pHasSubLayout = YES;
            
            if (isEstimate && isSbvWrap)
            {
                [(GTUIBaseLayout*)sbv sizeThatFits:sbvgtuiFrame.frame.size inSizeClass:sizeClass];
                if (sbvgtuiFrame.multiple)
                {
                    sbvgtuiFrame.sizeClass = [sbv gtuiBestSizeClass:sizeClass]; //因为sizeThatFits执行后会还原，所以这里要重新设置
                }
            }
        }
    }
    
    
    
    if (orientation == GTUIOrientationVert)
    {
        if (lsc.arrangedCount == 0)
            selfSize = [self gtuiLayoutSubviewsForVertContent:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
        else
            selfSize = [self gtuiLayoutSubviewsForVert:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
    }
    else
    {
        if (lsc.arrangedCount == 0)
            selfSize = [self gtuiLayoutSubviewsForHorzContent:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
        else
            selfSize = [self gtuiLayoutSubviewsForHorz:selfSize sbs:sbs isEstimate:isEstimate lsc:lsc];
    }
    
    //调整布局视图自己的尺寸。
    [self gtuiAdjustLayoutSelfSize:&selfSize lsc:lsc];
    //对所有子视图进行布局变换
    [self gtuiAdjustSubviewsLayoutTransform:sbs lsc:lsc selfWidth:selfSize.width selfHeight:selfSize.height];
    //对所有子视图进行RTL设置
    [self gtuiAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];
    
    return [self gtuiAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
}

-(id)createSizeClassInstance
{
    return [GTUIFlowLayoutViewSizeClass new];
}

#pragma mark -- Private Methods


- (void)gtuiCalcVertLayoutSinglelineWeight:(CGSize)selfSize totalFloatWidth:(CGFloat)totalFloatWidth totalWeight:(CGFloat)totalWeight sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        if (sbvsc.weight != 0)
        {
            CGFloat tempWidth = _gtuiCGFloatRound((totalFloatWidth * sbvsc.weight / totalWeight));
            if (sbvsc.widthSizeInner != nil)
                tempWidth = [sbvsc.widthSizeInner measureWith:tempWidth];
            
            totalFloatWidth -= tempWidth;
            totalWeight -= sbvsc.weight;
            
            sbvgtuiFrame.width =  [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:tempWidth sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
            sbvgtuiFrame.trailing = sbvgtuiFrame.leading + sbvgtuiFrame.width;
        }
    }
}

- (void)gtuiCalcHorzLayoutSinglelineWeight:(CGSize)selfSize totalFloatHeight:(CGFloat)totalFloatHeight totalWeight:(CGFloat)totalWeight sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count
{
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        if (sbvsc.weight != 0)
        {
            CGFloat tempHeight = _gtuiCGFloatRound((totalFloatHeight * sbvsc.weight / totalWeight));
            if (sbvsc.heightSizeInner != nil)
                tempHeight = [sbvsc.heightSizeInner measureWith:tempHeight];
            
            totalFloatHeight -= tempHeight;
            totalWeight -= sbvsc.weight;
            
            sbvgtuiFrame.height =  [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:tempHeight sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
            sbvgtuiFrame.bottom = sbvgtuiFrame.top + sbvgtuiFrame.height;
            
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                sbvgtuiFrame.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: sbvgtuiFrame.height ] sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
            
        }
    }
}



- (void)gtuiCalcVertLayoutSinglelineAlignment:(CGSize)selfSize rowMaxHeight:(CGFloat)rowMaxHeight rowMaxWidth:(CGFloat)rowMaxWidth horzGravity:(GTUIGravity)horzGravity vertAlignment:(GTUIGravity)vertAlignment sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count vertSpace:(CGFloat)vertSpace horzSpace:(CGFloat)horzSpace isEstimate:(BOOL)isEstimate lsc:(GTUIFlowLayout*)lsc
{
    
    CGFloat paddingLeading = lsc.gtuiLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    
    CGFloat addXPos = 0; //多出来的空隙区域，用于停靠处理。
    CGFloat addXFill = 0;  //多出来的平均区域，用于拉伸间距或者尺寸
    BOOL averageArrange = (horzGravity == GTUIGravityHorzFill);
    
    if (!averageArrange || lsc.arrangedCount == 0)
    {
        switch (horzGravity) {
            case GTUIGravityHorzCenter:
            {
                addXPos = (selfSize.width - paddingHorz - rowMaxWidth) / 2;
            }
                break;
            case GTUIGravityHorzTrailing:
            {
                addXPos = selfSize.width - paddingHorz - rowMaxWidth; //因为具有不考虑左边距，而原来的位置增加了左边距，因此
            }
                break;
            case GTUIGravityHorzBetween:
            {
                //总宽度减去最大的宽度。再除以数量表示每个应该扩展的空间。最后一行无效(如果最后一行的数量和其他行的数量一样除外)。
                if ((startIndex != sbs.count || count == lsc.arrangedCount) && count > 1)
                {
                    addXFill = (selfSize.width - paddingHorz - rowMaxWidth) / (count - 1);
                }
            }
                break;
            default:
                break;
        }
        
        //处理内容拉伸的情况。这里是只有内容约束布局才支持尺寸拉伸。
        if (lsc.arrangedCount == 0 && averageArrange)
        {
            //不是最后一行。。
            if (startIndex != sbs.count)
            {
                addXFill = (selfSize.width - paddingHorz - rowMaxWidth) / count;
            }
            
        }
    }
    
    
    //将整行的位置进行调整。
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        if (!isEstimate && self.intelligentBorderline != nil)
        {
            if ([sbv isKindOfClass:[GTUIBaseLayout class]])
            {
                GTUIBaseLayout *sbvl = (GTUIBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderline)
                {
                    sbvl.leadingBorderline = nil;
                    sbvl.topBorderline = nil;
                    sbvl.trailingBorderline = nil;
                    sbvl.bottomBorderline = nil;
                    
                    //如果不是最后一行就画下面，
                    if (startIndex != sbs.count)
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }
                    
                    //如果不是最后一列就画右边,
                    if (j < startIndex - 1)
                    {
                        sbvl.trailingBorderline = self.intelligentBorderline;
                    }
                    
                    //如果最后一行的最后一个没有满列数时
                    if (j == sbs.count - 1 && lsc.arrangedCount != count )
                    {
                        sbvl.trailingBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有垂直间距则不是第一行就画上
                    if (vertSpace != 0 && startIndex - count != 0)
                    {
                        sbvl.topBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有水平间距则不是第一列就画左
                    if (horzSpace != 0 && j != startIndex - count)
                    {
                        sbvl.leadingBorderline = self.intelligentBorderline;
                    }
                    
                }
            }
        }
        
        GTUIGravity sbvVertAlignment = sbvsc.gtui_alignment & GTUIGravityHorzMask;
        if (sbvVertAlignment == GTUIGravityNone)
            sbvVertAlignment = vertAlignment;
        if (vertAlignment == GTUIGravityVertBetween)
            sbvVertAlignment = GTUIGravityVertBetween;
        
        if ((sbvVertAlignment != GTUIGravityNone && sbvVertAlignment != GTUIGravityVertTop) || _gtuiCGFloatNotEqual(addXPos, 0)  ||  _gtuiCGFloatNotEqual(addXFill, 0))
        {
            
            sbvgtuiFrame.leading += addXPos;
            
            //内容约束布局并且是拉伸尺寸。。
            if (lsc.arrangedCount == 0 && averageArrange)
            {
                //只拉伸宽度不拉伸间距
                sbvgtuiFrame.width += addXFill;
                
                if (j != startIndex - count)
                {
                    sbvgtuiFrame.leading += addXFill * (j - (startIndex - count));
                    
                }
            }
            else
            {
                //其他的只拉伸间距
                sbvgtuiFrame.leading += addXFill * (j - (startIndex - count));
            }
            
            
            switch (sbvVertAlignment) {
                case GTUIGravityVertCenter:
                {
                    sbvgtuiFrame.top += (rowMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal - sbvgtuiFrame.height) / 2;
                    
                }
                    break;
                case GTUIGravityVertBottom:
                {
                    sbvgtuiFrame.top += rowMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal - sbvgtuiFrame.height;
                }
                    break;
                case GTUIGravityVertFill:
                {
                    sbvgtuiFrame.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rowMaxHeight - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                default:
                    break;
            }
        }
    }
    
}

- (void)gtuiCalcHorzLayoutSinglelineAlignment:(CGSize)selfSize colMaxWidth:(CGFloat)colMaxWidth colMaxHeight:(CGFloat)colMaxHeight vertGravity:(GTUIGravity)vertGravity  horzAlignment:(GTUIGravity)horzAlignment sbs:(NSArray *)sbs startIndex:(NSInteger)startIndex count:(NSInteger)count vertSpace:(CGFloat)vertSpace horzSpace:(CGFloat)horzSpace isEstimate:(BOOL)isEstimate lsc:(GTUIFlowLayout*)lsc
{
    
    CGFloat paddingTop = lsc.gtuiLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtuiLayoutBottomPadding;
    CGFloat paddingVert = paddingTop + paddingBottom;
    
    CGFloat addYPos = 0;
    CGFloat addYFill = 0;
    
    BOOL averageArrange = (vertGravity == GTUIGravityVertFill);
    
    if (!averageArrange || lsc.arrangedCount == 0)
    {
        switch (vertGravity) {
            case GTUIGravityVertCenter:
            {
                addYPos = (selfSize.height - paddingVert - colMaxHeight) / 2;
            }
                break;
            case GTUIGravityVertBottom:
            {
                addYPos = selfSize.height - paddingVert - colMaxHeight;
            }
                break;
            case GTUIGravityVertBetween:
            {
                //总高度减去最大的高度。再除以数量表示每个应该扩展的空间。最后一行无效(如果数量和单行的数量相等除外)。
                if ((startIndex != sbs.count || count == lsc.arrangedCount) && count > 1)
                {
                    addYFill = (selfSize.height - paddingVert - colMaxHeight) / (count - 1);
                }
                
            }
            default:
                break;
        }
        
        //处理内容拉伸的情况。
        if (lsc.arrangedCount == 0 && averageArrange)
        {
            if (startIndex != sbs.count)
            {
                addYFill = (selfSize.height  - paddingVert - colMaxHeight) / count;
            }
            
        }
        
    }
    
    
    
    
    //将整行的位置进行调整。
    for (NSInteger j = startIndex - count; j < startIndex; j++)
    {
        UIView *sbv = sbs[j];
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        
        if (!isEstimate && self.intelligentBorderline != nil)
        {
            if ([sbv isKindOfClass:[GTUIBaseLayout class]])
            {
                GTUIBaseLayout *sbvl = (GTUIBaseLayout*)sbv;
                if (!sbvl.notUseIntelligentBorderline)
                {
                    sbvl.leadingBorderline = nil;
                    sbvl.topBorderline = nil;
                    sbvl.trailingBorderline = nil;
                    sbvl.bottomBorderline = nil;
                    
                    
                    //如果不是最后一行就画下面，
                    if (j < startIndex - 1)
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }
                    
                    //如果不是最后一列就画右边,
                    if (startIndex != sbs.count )
                    {
                        sbvl.trailingBorderline = self.intelligentBorderline;
                        
                    }
                    
                    //如果最后一行的最后一个没有满列数时
                    if (j == sbs.count - 1 && lsc.arrangedCount != count )
                    {
                        sbvl.bottomBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有垂直间距则不是第一行就画上
                    if (vertSpace != 0 && j != startIndex - count)
                    {
                        sbvl.topBorderline = self.intelligentBorderline;
                    }
                    
                    //如果有水平间距则不是第一列就画左
                    if (horzSpace != 0 && startIndex - count != 0  )
                    {
                        sbvl.leadingBorderline = self.intelligentBorderline;
                        
                    }
                    
                    
                    
                }
            }
        }
        
        
        GTUIGravity sbvHorzAlignment = [self gtuiConvertLeftRightGravityToLeadingTrailing:sbvsc.gtui_alignment & GTUIGravityVertMask];
        if (sbvHorzAlignment == GTUIGravityNone)
            sbvHorzAlignment = horzAlignment;
        if (horzAlignment == GTUIGravityHorzBetween)
            sbvHorzAlignment = GTUIGravityHorzBetween;
        
        if ((sbvHorzAlignment != GTUIGravityNone && sbvHorzAlignment != GTUIGravityHorzLeading) || _gtuiCGFloatNotEqual(addYPos, 0) || _gtuiCGFloatNotEqual(addYFill, 0) )
        {
            sbvgtuiFrame.top += addYPos;
            
            if (lsc.arrangedCount == 0 && averageArrange)
            {
                //只拉伸宽度不拉伸间距
                sbvgtuiFrame.height += addYFill;
                
                if (j != startIndex - count)
                {
                    sbvgtuiFrame.top += addYFill * (j - (startIndex - count));
                    
                }
            }
            else
            {
                //只拉伸间距
                sbvgtuiFrame.top += addYFill * (j - (startIndex - count));
            }
            
            switch (sbvHorzAlignment) {
                case GTUIGravityHorzCenter:
                {
                    sbvgtuiFrame.leading += (colMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal - sbvgtuiFrame.width) / 2;
                    
                }
                    break;
                case GTUIGravityHorzTrailing:
                {
                    sbvgtuiFrame.leading += colMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal - sbvgtuiFrame.width;
                }
                    break;
                case GTUIGravityHorzFill:
                {
                    sbvgtuiFrame.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:colMaxWidth - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
                }
                    break;
                default:
                    break;
            }
        }
    }
}


-(CGFloat)gtuiCalcSinglelineSize:(NSArray*)sbs space:(CGFloat)space
{
    CGFloat size = 0;
    for (UIView *sbv in sbs)
    {
        size += sbv.gtuiFrame.trailing;
        if (sbv != sbs.lastObject)
            size += space;
    }
    
    return size;
}

-(NSArray*)gtuiGetAutoArrangeSubviews:(NSMutableArray*)sbs selfSize:(CGFloat)selfSize space:(CGFloat)space
{
    
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:sbs.count];
    
    NSMutableArray *bestSinglelineArray = [NSMutableArray arrayWithCapacity:sbs.count /2];
    
    while (sbs.count) {
        
        [self gtuiCalcAutoArrangeSinglelineSubviews:sbs
                                            index:0
                                        calcArray:@[]
                                         selfSize:selfSize
                                            space:space
                              bestSinglelineArray:bestSinglelineArray];
        
        [retArray addObjectsFromArray:bestSinglelineArray];
        
        [bestSinglelineArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            [sbs removeObject:obj];
        }];
        
        [bestSinglelineArray removeAllObjects];
    }
    
    return retArray;
}

-(void)gtuiCalcAutoArrangeSinglelineSubviews:(NSMutableArray*)sbs
                                     index:(NSInteger)index
                                 calcArray:(NSArray*)calcArray
                                  selfSize:(CGFloat)selfSize
                                     space:(CGFloat)space
                       bestSinglelineArray:(NSMutableArray*)bestSinglelineArray
{
    if (index >= sbs.count)
    {
        CGFloat s1 = [self gtuiCalcSinglelineSize:calcArray space:space];
        CGFloat s2 = [self gtuiCalcSinglelineSize:bestSinglelineArray space:space];
        if (_gtuiCGFloatLess(fabs(selfSize - s1), fabs(selfSize - s2)) && _gtuiCGFloatLessOrEqual(s1, selfSize) )
        {
            [bestSinglelineArray setArray:calcArray];
        }
        
        return;
    }
    
    
    for (NSInteger i = index; i < sbs.count; i++) {
        
        
        NSMutableArray *calcArray2 = [NSMutableArray arrayWithArray:calcArray];
        [calcArray2 addObject:sbs[i]];
        
        CGFloat s1 = [self gtuiCalcSinglelineSize:calcArray2 space:space];
        if (_gtuiCGFloatLessOrEqual(s1, selfSize))
        {
            CGFloat s2 = [self gtuiCalcSinglelineSize:bestSinglelineArray space:space];
            if (_gtuiCGFloatLess(fabs(selfSize - s1), fabs(selfSize - s2)))
            {
                [bestSinglelineArray setArray:calcArray2];
            }
            
            if (_gtuiCGFloatEqual(s1, selfSize))
                break;
            
            [self gtuiCalcAutoArrangeSinglelineSubviews:sbs
                                                index:i + 1
                                            calcArray:calcArray2
                                             selfSize:selfSize
                                                space:space
                                  bestSinglelineArray:bestSinglelineArray];
            
        }
        else
            break;
        
    }
    
}


-(CGSize)gtuiLayoutSubviewsForVertContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(GTUIFlowLayout*)lsc
{
    
    CGFloat paddingTop = lsc.gtuiLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtuiLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtuiLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat rowMaxHeight = 0;  //某一行的最高值。
    CGFloat rowMaxWidth = 0;   //某一行的最宽值
    
    GTUIGravity vertGravity = lsc.gravity & GTUIGravityHorzMask;
    GTUIGravity horzGravity = [self gtuiConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTUIGravityVertMask];
    GTUIGravity vertAlign = lsc.arrangedGravity & GTUIGravityHorzMask;
    
    //支持浮动水平间距。
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
        
        CGFloat minSpace = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).maxSpace;
        
        NSInteger rowCount =  floor((selfSize.width - paddingHorz  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            horzSpace = (selfSize.width - paddingHorz - subviewSize * rowCount)/(rowCount - 1);
            if (_gtuiCGFloatGreat(horzSpace, maxSpace))
            {
                horzSpace = maxSpace;
                
                subviewSize =  (selfSize.width - paddingHorz -  horzSpace * (rowCount - 1)) / rowCount;
                
            }
        }
    }
    
    
    if (lsc.autoArrange)
    {
        //计算出每个子视图的宽度。
        for (UIView* sbv in sbs)
        {
            GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
            UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
            
#ifdef DEBUG
            //约束异常：垂直流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(sbvsc.weight == 0, @"Constraint exception!! vertical flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES",self, sbv);
#endif
            CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
            CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
            CGRect rect = sbvgtuiFrame.frame;
            
            if (sbvsc.widthSizeInner.dimeNumVal != nil)
                rect.size.width = sbvsc.widthSizeInner.measure;
            
            
            [self gtuiSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
            
            rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            //暂时把宽度存放sbv.gtuiFrame.trailing上。因为浮动布局来说这个属性无用。
            sbvgtuiFrame.trailing = leadingSpace + rect.size.width + trailingSpace;
            if (_gtuiCGFloatGreat(sbvgtuiFrame.trailing, selfSize.width - paddingHorz))
                sbvgtuiFrame.trailing = selfSize.width - paddingHorz;
        }
        
        [sbs setArray:[self gtuiGetAutoArrangeSubviews:sbs selfSize:selfSize.width - paddingHorz space:horzSpace]];
        
    }
    
    
    NSMutableIndexSet *arrangeIndexSet = [NSMutableIndexSet new];
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvgtuiFrame.frame;
        
        
        if (subviewSize != 0)
            rect.size.width = subviewSize;
        
        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        
        [self gtuiSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        [self gtuiSetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        
        if (sbvsc.weight != 0)
        {
            //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
            CGFloat floatWidth = selfSize.width - paddingHorz - rowMaxWidth;
            if (_gtuiCGFloatLessOrEqual(floatWidth, 0))
            {
                floatWidth += rowMaxWidth;
                arrangedIndex = 0;
            }
            
            if (arrangedIndex != 0)
                floatWidth -= horzSpace;
            
            rect.size.width = (floatWidth + sbvsc.widthSizeInner.addVal) * sbvsc.weight - leadingSpace - trailingSpace;
            
        }
        
        
        rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width ];
        
        
        //如果高度是浮动的则需要调整高度。
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]])
            rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        
        rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //计算xPos的值加上leadingSpace + rect.size.width + trailingSpace 的值要小于整体的宽度。
        CGFloat place = xPos + leadingSpace + rect.size.width + trailingSpace;
        if (arrangedIndex != 0)
            place += horzSpace;
        place += paddingTrailing;
        
        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
        if (place - selfSize.width > 0.0001)
        {
            xPos = paddingLeading;
            yPos += vertSpace;
            yPos += rowMaxHeight;
            
            
            [arrangeIndexSet addIndex:i - arrangedIndex];
            //计算每行的gravity情况。
            [self gtuiCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
            
            //计算单独的sbv的宽度是否大于整体的宽度。如果大于则缩小宽度。
            if (_gtuiCGFloatGreat(leadingSpace + trailingSpace + rect.size.width, selfSize.width - paddingHorz))
            {
                
                rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:selfSize.width - paddingHorz - leadingSpace - trailingSpace sbvSize:rect.size selfLayoutSize:selfSize];
                
                if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]])
                {
                    rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
                    rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                }
                
            }
            
            rowMaxHeight = 0;
            rowMaxWidth = 0;
            arrangedIndex = 0;
            
        }
        
        if (arrangedIndex != 0)
            xPos += horzSpace;
        
        
        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        xPos += leadingSpace + rect.size.width + trailingSpace;
        
        if (_gtuiCGFloatLess(rowMaxHeight, topSpace + bottomSpace + rect.size.height))
            rowMaxHeight = topSpace + bottomSpace + rect.size.height;
        
        if (_gtuiCGFloatLess(rowMaxWidth, (xPos - paddingLeading)))
            rowMaxWidth = (xPos - paddingLeading);
        
        
        
        sbvgtuiFrame.frame = rect;
        
        arrangedIndex++;
        
        
        
    }
    
    //最后一行
    [arrangeIndexSet addIndex:i - arrangedIndex];
    
    [self gtuiCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
    
    
    if (lsc.wrapContentHeight)
        selfSize.height = yPos + paddingBottom + rowMaxHeight;
    else
    {
        CGFloat addYPos = 0;
        CGFloat between = 0;
        CGFloat fill = 0;
        
        if (vertGravity == GTUIGravityVertCenter)
        {
            addYPos = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / 2;
        }
        else if (vertGravity == GTUIGravityVertBottom)
        {
            addYPos = selfSize.height - paddingBottom - rowMaxHeight - yPos;
        }
        else if (vertGravity == GTUIGravityVertFill)
        {
            if (arrangeIndexSet.count > 0)
                fill = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / arrangeIndexSet.count;
        }
        else if (vertGravity == GTUIGravityVertBetween)
        {
            if (arrangeIndexSet.count > 1)
                between = (selfSize.height - paddingBottom - rowMaxHeight - yPos) / (arrangeIndexSet.count - 1);
        }
        
        if (addYPos != 0 || between != 0 || fill != 0)
        {
            int line = 0;
            NSUInteger lastIndex = 0;
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
                
                sbvgtuiFrame.top += addYPos;
                
                //找到行的最初索引。
                NSUInteger index = [arrangeIndexSet indexLessThanOrEqualToIndex:i];
                if (lastIndex != index)
                {
                    lastIndex = index;
                    line ++;
                }
                
                sbvgtuiFrame.height += fill;
                sbvgtuiFrame.top += fill * line;
                
                sbvgtuiFrame.top += between * line;
                
            }
        }
        
    }
    
    
    return selfSize;
    
}


-(CGSize)gtuiLayoutSubviewsForVert:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(GTUIFlowLayout*)lsc
{
    CGFloat paddingTop = lsc.gtuiLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtuiLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtuiLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;
    
    BOOL autoArrange = lsc.autoArrange;
    NSInteger arrangedCount = lsc.arrangedCount;
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat rowMaxHeight = 0;  //某一行的最高值。
    CGFloat rowMaxWidth = 0;   //某一行的最宽值
    CGFloat maxWidth = paddingLeading;  //全部行的最宽值
    CGFloat maxHeight = paddingTop; //最大的高度
    GTUIGravity vertGravity = lsc.gravity & GTUIGravityHorzMask;
    GTUIGravity horzGravity = [self gtuiConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTUIGravityVertMask];
    GTUIGravity vertAlign = lsc.arrangedGravity & GTUIGravityHorzMask;
    
    
    
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    
    CGFloat subviewSize = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
        CGFloat maxSpace = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).maxSpace;
        CGFloat minSpace = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).minSpace;
        if (arrangedCount > 1)
        {
            horzSpace = (selfSize.width - paddingHorz - subviewSize * arrangedCount)/(arrangedCount - 1);
            if (_gtuiCGFloatGreat(horzSpace, maxSpace) || _gtuiCGFloatLess(horzSpace, minSpace))
            {
                if (_gtuiCGFloatGreat(horzSpace, maxSpace))
                    horzSpace = maxSpace;
                if (_gtuiCGFloatLess(horzSpace, minSpace))
                    horzSpace = minSpace;
                
                subviewSize =  (selfSize.width - paddingHorz -  horzSpace * (arrangedCount - 1)) / arrangedCount;
                
            }
        }
    }
    
#if TARGET_OS_IOS
    //判断父滚动视图是否分页滚动
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] && ((UIScrollView*)self.superview).isPagingEnabled);
#else
    BOOL isPagingScroll = NO;
#endif
    
    CGFloat pagingItemHeight = 0;
    CGFloat pagingItemWidth = 0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (lsc.pagedCount > 0 && self.superview != nil)
    {
        NSInteger rows = lsc.pagedCount / arrangedCount;  //每页的行数。
        
        //对于垂直流式布局来说，要求要有明确的宽度。因此如果我们启用了分页又设置了宽度包裹时则我们的分页是从左到右的排列。否则分页是从上到下的排列。
        if (lsc.wrapContentWidth)
        {
            isHorzPaging = YES;
            if (isPagingScroll)
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingHorz - (arrangedCount - 1) * horzSpace ) / arrangedCount;
            else
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingLeading - arrangedCount * horzSpace ) / arrangedCount;
            
            pagingItemHeight = (selfSize.height - paddingVert - (rows - 1) * vertSpace) / rows;
        }
        else
        {
            isVertPaging = YES;
            pagingItemWidth = (selfSize.width - paddingHorz - (arrangedCount - 1) * horzSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的高度计算是不一样的。
            if (isPagingScroll)
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingVert - (rows - 1) * vertSpace) / rows;
            else
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingTop - rows * vertSpace) / rows;
            
        }
        
    }
    
    
    BOOL averageArrange = (horzGravity == GTUIGravityHorzFill);
    
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    CGFloat rowTotalWeight = 0;
    CGFloat rowTotalFixedWidth = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        if (arrangedIndex >= arrangedCount)
        {
            arrangedIndex = 0;
            
            if (rowTotalWeight != 0 && !averageArrange)
            {
                [self gtuiCalcVertLayoutSinglelineWeight:selfSize totalFloatWidth:selfSize.width - paddingHorz - rowTotalFixedWidth totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedCount];
            }
            
            rowTotalWeight = 0;
            rowTotalFixedWidth = 0;
            
        }
        
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvgtuiFrame.frame;
        
        
        if (sbvsc.weight != 0)
        {
            
            rowTotalWeight += sbvsc.weight;
        }
        else
        {
            if (subviewSize != 0)
                rect.size.width = subviewSize;
            
            if (pagingItemWidth != 0)
                rect.size.width = pagingItemWidth;
            
            if (sbvsc.widthSizeInner.dimeNumVal != nil && !averageArrange)
                rect.size.width = sbvsc.widthSizeInner.measure;
            
            
            [self gtuiSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
            
            
            rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            rowTotalFixedWidth += rect.size.width;
        }
        
        rowTotalFixedWidth += leadingSpace + trailingSpace;
        
        if (arrangedIndex != (arrangedCount - 1))
            rowTotalFixedWidth += horzSpace;
        
        
        sbvgtuiFrame.frame = rect;
        
        arrangedIndex++;
        
    }
    
    //最后一行。
    if (rowTotalWeight != 0 && !averageArrange)
    {
        if (arrangedIndex < arrangedCount)
            rowTotalFixedWidth -= horzSpace;
        
        [self gtuiCalcVertLayoutSinglelineWeight:selfSize totalFloatWidth:selfSize.width - paddingHorz - rowTotalFixedWidth totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedIndex];
    }
    
    //每列的下一个位置。
    NSMutableArray<NSValue*> *nextPointOfRows = nil;
    if (autoArrange)
    {
        nextPointOfRows = [NSMutableArray arrayWithCapacity:arrangedCount];
        for (NSInteger idx = 0; idx < arrangedCount; idx++)
        {
            [nextPointOfRows addObject:[NSValue valueWithCGPoint:CGPointMake(paddingLeading, paddingTop)]];
        }
    }
    
    CGFloat pageWidth  = 0; //页宽。
    CGFloat averageWidth = (selfSize.width - paddingHorz - (arrangedCount - 1) * horzSpace) / arrangedCount;
    arrangedIndex = 0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        //新的一行
        if (arrangedIndex >=  arrangedCount)
        {
            arrangedIndex = 0;
            yPos += rowMaxHeight;
            yPos += vertSpace;
            
            //分别处理水平分页和垂直分页。
            if (isHorzPaging)
            {
                if (i % lsc.pagedCount == 0)
                {
                    pageWidth += CGRectGetWidth(self.superview.bounds);
                    
                    if (!isPagingScroll)
                        pageWidth -= paddingLeading;
                    
                    yPos = paddingTop;
                }
                
            }
            
            if (isVertPaging)
            {
                //如果是分页滚动则要多添加垂直间距。
                if (i % lsc.pagedCount == 0)
                {
                    
                    if (isPagingScroll)
                    {
                        yPos -= vertSpace;
                        yPos += paddingVert;
                        
                    }
                }
            }
            
            
            xPos = paddingLeading + pageWidth;
            
            
            //计算每行的gravity情况。
            [self gtuiCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedCount vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
            rowMaxHeight = 0;
            rowMaxWidth = 0;
            
        }
        
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvgtuiFrame.frame;
        BOOL isFlexedHeight = sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]] && sbvsc.heightSizeInner.dimeRelaVal.view != self;
        
        if (pagingItemHeight != 0)
            rect.size.height = pagingItemHeight;
        
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        if (averageArrange)
        {
            rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:averageWidth - leadingSpace - trailingSpace sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        
        [self gtuiSetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        //如果高度是浮动的则需要调整高度。
        if (isFlexedHeight)
            rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        
        
        rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //得到最大的行高
        if (_gtuiCGFloatLess(rowMaxHeight, topSpace + bottomSpace + rect.size.height))
            rowMaxHeight = topSpace + bottomSpace + rect.size.height;
        
        
        //自动排列。
        if (autoArrange)
        {
            //查找能存放当前子视图的最小y轴的位置以及索引。
            CGPoint minPt = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
            NSInteger minNextPointIndex = 0;
            for (int idx = 0; idx < arrangedCount; idx++)
            {
                CGPoint pt = nextPointOfRows[idx].CGPointValue;
                if (minPt.y > pt.y)
                {
                    minPt = pt;
                    minNextPointIndex = idx;
                }
            }
            
            //找到的minNextPointIndex中的
            xPos = minPt.x;
            yPos = minPt.y;
            
            minPt.y = minPt.y + topSpace + rect.size.height + bottomSpace + vertSpace;
            nextPointOfRows[minNextPointIndex] = [NSValue valueWithCGPoint:minPt];
            if (minNextPointIndex + 1 <= arrangedCount - 1)
            {
                minPt = nextPointOfRows[minNextPointIndex + 1].CGPointValue;
                minPt.x = xPos + leadingSpace + rect.size.width + trailingSpace + horzSpace;
                nextPointOfRows[minNextPointIndex + 1] = [NSValue valueWithCGPoint:minPt];
            }
            
            if (_gtuiCGFloatLess(maxHeight, yPos + topSpace + rect.size.height + bottomSpace))
                maxHeight = yPos + topSpace + rect.size.height + bottomSpace;
            
        }
        else if (vertAlign == GTUIGravityVertBetween)
        { //当列是紧凑排列时需要特殊处理当前的垂直位置。
            //第0行特殊处理。
            if (i - arrangedCount < 0)
            {
                yPos = paddingTop;
            }
            else
            {
                //取前一行的对应的列的子视图。
                GTUIFrame *gtuiPrevColSbvFrame = ((UIView*)sbs[i - arrangedCount]).gtuiFrame;
                UIView *gtuiPrevColSbvsc = [self gtuiCurrentSizeClassFrom:gtuiPrevColSbvFrame];
                //当前子视图的位置等于前一行对应列的最大y的值 + 前面对应列的底部间距 + 子视图之间的行间距。
                yPos =  CGRectGetMaxY(gtuiPrevColSbvFrame.frame)+ gtuiPrevColSbvsc.bottomPosInner.absVal + vertSpace;
            }
            
            if (_gtuiCGFloatLess(maxHeight, yPos + topSpace + rect.size.height + bottomSpace))
                maxHeight = yPos + topSpace + rect.size.height + bottomSpace;
        }
        else
        {//正常排列。
            //这里的最大其实就是最后一个视图的位置加上最高的子视图的尺寸。
            maxHeight = yPos + rowMaxHeight;
        }
        
        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        xPos += leadingSpace + rect.size.width + trailingSpace;
        
        if (arrangedIndex != (arrangedCount - 1) && !autoArrange)
            xPos += horzSpace;
        
        
        
        if (_gtuiCGFloatLess(rowMaxWidth, (xPos - paddingLeading)))
            rowMaxWidth = (xPos - paddingLeading);
        
        if (_gtuiCGFloatLess(maxWidth, xPos))
            maxWidth = xPos;
        
        
        
        sbvgtuiFrame.frame = rect;
        
        arrangedIndex++;
        
    }
    
    //最后一行
    [self gtuiCalcVertLayoutSinglelineAlignment:selfSize rowMaxHeight:rowMaxHeight rowMaxWidth:rowMaxWidth horzGravity:horzGravity vertAlignment:vertAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
    
    maxHeight += paddingBottom;
    
    if (lsc.wrapContentHeight)
    {
        selfSize.height = maxHeight;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isVertPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_gtuiCGFloatLess(selfSize.height, totalPages * CGRectGetHeight(self.superview.bounds)))
                selfSize.height = totalPages * CGRectGetHeight(self.superview.bounds);
        }
        
    }
    else
    {
        CGFloat addYPos = 0;
        CGFloat between = 0;
        CGFloat fill = 0;
        int arranges = floor((sbs.count + arrangedCount - 1.0) / arrangedCount);
        
        if (vertGravity == GTUIGravityVertCenter)
        {
            addYPos = (selfSize.height - maxHeight) / 2;
        }
        else if (vertGravity == GTUIGravityVertBottom)
        {
            addYPos = selfSize.height - maxHeight;
        }
        else if (vertGravity == GTUIGravityVertFill)
        {
            if (arranges > 0)
                fill = (selfSize.height - maxHeight) / arranges;
        }
        else if (vertGravity == GTUIGravityVertBetween)
        {
            
            if (arranges > 1)
                between = (selfSize.height - maxHeight) / (arranges - 1);
        }
        
        
        if (addYPos != 0 || between != 0 || fill != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
                
                int lines = i / arrangedCount;
                sbvgtuiFrame.height += fill;
                sbvgtuiFrame.top += fill * lines;
                
                sbvgtuiFrame.top += addYPos;
                
                sbvgtuiFrame.top += between * lines;
                
            }
        }
        
    }
    
    if (lsc.wrapContentWidth && !averageArrange)
    {
        selfSize.width = maxWidth + paddingTrailing;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_gtuiCGFloatLess(selfSize.width, totalPages * CGRectGetWidth(self.superview.bounds)))
                selfSize.width = totalPages * CGRectGetWidth(self.superview.bounds);
        }
        
    }
    
    return selfSize;
}





-(CGSize)gtuiLayoutSubviewsForHorzContent:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(GTUIFlowLayout*)lsc
{
    
    CGFloat paddingTop = lsc.gtuiLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtuiLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtuiLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    CGFloat paddingVert = paddingTop + paddingBottom;
    
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat colMaxWidth = 0;  //某一列的最宽值。
    CGFloat colMaxHeight = 0;   //某一列的最高值
    
    GTUIGravity vertGravity = lsc.gravity & GTUIGravityHorzMask;
    GTUIGravity horzGravity = [self gtuiConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTUIGravityVertMask];
    GTUIGravity horzAlign =  [self gtuiConvertLeftRightGravityToLeadingTrailing:lsc.arrangedGravity & GTUIGravityVertMask];
    
    
    //支持浮动垂直间距。
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
        
        CGFloat minSpace = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).minSpace;
        CGFloat maxSpace = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).maxSpace;
        NSInteger rowCount =  floor((selfSize.height - paddingVert  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            vertSpace = (selfSize.height - paddingVert - subviewSize * rowCount)/(rowCount - 1);
            if (_gtuiCGFloatGreat(vertSpace, maxSpace))
            {
                vertSpace = maxSpace;
                
                subviewSize =  (selfSize.height - paddingVert -  vertSpace * (rowCount - 1)) / rowCount;
                
            }
        }
    }
    
    
    if (lsc.autoArrange)
    {
        //计算出每个子视图的宽度。
        for (UIView* sbv in sbs)
        {
            GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
            UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
            
#ifdef DEBUG
            //约束异常：水平流式布局设置autoArrange为YES时，子视图不能将weight设置为非0.
            NSCAssert(sbvsc.weight == 0, @"Constraint exception!! horizontal flow layout:%@ 's subview:%@ can't set weight when the autoArrange set to YES",self, sbv);
#endif
            
            
            CGFloat topSpace = sbvsc.topPosInner.absVal;
            CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
            CGRect rect = sbvgtuiFrame.frame;
            
            if (sbvsc.widthSizeInner.dimeNumVal != nil)
                rect.size.width = sbvsc.widthSizeInner.measure;
            
            if (subviewSize != 0)
                rect.size.height = subviewSize;
            
            if (sbvsc.heightSizeInner.dimeNumVal != nil)
                rect.size.height = sbvsc.heightSizeInner.measure;
            
            [self gtuiSetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
            
            rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            
            [self gtuiSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
            
            rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
            
            
            //如果高度是浮动的则需要调整高度。
            if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]])
            {
                rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
                
                rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            
            //暂时把宽度存放sbv.gtuiFrame.trailing上。因为浮动布局来说这个属性无用。
            sbvgtuiFrame.trailing = topSpace + rect.size.height + bottomSpace;
            if (_gtuiCGFloatGreat(sbvgtuiFrame.trailing, selfSize.height - paddingVert))
                sbvgtuiFrame.trailing = selfSize.height - paddingVert;
        }
        
        [sbs setArray:[self gtuiGetAutoArrangeSubviews:sbs selfSize:selfSize.height - paddingVert space:vertSpace]];
        
    }
    
    
    
    NSMutableIndexSet *arrangeIndexSet = [NSMutableIndexSet new];
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvgtuiFrame.frame;
        
        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;
        
        if (subviewSize != 0)
            rect.size.height = subviewSize;
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        [self gtuiSetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        [self gtuiSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        
        if (sbvsc.weight != 0)
        {
            //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
            CGFloat floatHeight = selfSize.height - paddingVert - colMaxHeight;
            if (_gtuiCGFloatLessOrEqual(floatHeight, 0))
            {
                floatHeight += colMaxHeight;
                arrangedIndex = 0;
            }
            
            if (arrangedIndex != 0)
                floatHeight -= vertSpace;
            
            rect.size.height = (floatHeight + sbvsc.heightSizeInner.addVal) * sbvsc.weight - topSpace - bottomSpace;
            
        }
        
        
        rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height ];
        
        
        
        rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        //如果高度是浮动的则需要调整高度。
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]])
        {
            rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
            
            rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //计算yPos的值加上topSpace + rect.size.height + bottomSpace的值要小于整体的高度。
        CGFloat place = yPos + topSpace + rect.size.height + bottomSpace;
        if (arrangedIndex != 0)
            place += vertSpace;
        place += paddingBottom;
        
        //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
        if (place - selfSize.height > 0.0001)
        {
            yPos = paddingTop;
            xPos += horzSpace;
            xPos += colMaxWidth;
            
            
            //计算每行的gravity情况。
            [arrangeIndexSet addIndex:i - arrangedIndex];
            [self gtuiCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
            
            //计算单独的sbv的高度是否大于整体的高度。如果大于则缩小高度。
            if (_gtuiCGFloatGreat(topSpace + bottomSpace + rect.size.height, selfSize.height - paddingVert))
            {
                rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:selfSize.height - paddingVert - topSpace - bottomSpace sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            colMaxWidth = 0;
            colMaxHeight = 0;
            arrangedIndex = 0;
            
        }
        
        if (arrangedIndex != 0)
            yPos += vertSpace;
        
        
        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        yPos += topSpace + rect.size.height + bottomSpace;
        
        if (_gtuiCGFloatLess(colMaxWidth, leadingSpace + trailingSpace + rect.size.width))
            colMaxWidth = leadingSpace + trailingSpace + rect.size.width;
        
        if (_gtuiCGFloatLess(colMaxHeight, (yPos - paddingTop)))
            colMaxHeight = (yPos - paddingTop);
        
        
        
        sbvgtuiFrame.frame = rect;
        
        arrangedIndex++;
        
        
        
    }
    
    //最后一行
    [arrangeIndexSet addIndex:i - arrangedIndex];
    [self gtuiCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
    
    
    if (lsc.wrapContentWidth)
        selfSize.width = xPos + paddingTrailing + colMaxWidth;
    else
    {
        CGFloat addXPos = 0;
        CGFloat fill = 0;
        CGFloat between = 0;
        
        if (horzGravity == GTUIGravityHorzCenter)
        {
            addXPos = (selfSize.width - paddingTrailing - colMaxWidth - xPos) / 2;
        }
        else if (horzGravity == GTUIGravityHorzTrailing)
        {
            addXPos = selfSize.width - paddingTrailing - colMaxWidth - xPos;
        }
        else if (horzGravity == GTUIGravityHorzFill)
        {
            if (arrangeIndexSet.count > 0)
                fill = (selfSize.width - paddingTrailing - colMaxWidth - xPos) / arrangeIndexSet.count;
        }
        else if (horzGravity == GTUIGravityHorzBetween)
        {
            if (arrangeIndexSet.count > 1)
                between = (selfSize.width - paddingTrailing - colMaxWidth - xPos) / (arrangeIndexSet.count - 1);
        }
        
        
        if (addXPos != 0 || between != 0 || fill != 0)
        {
            int line = 0;
            NSUInteger lastIndex = 0;
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
                
                sbvgtuiFrame.leading += addXPos;
                
                //找到行的最初索引。
                NSUInteger index = [arrangeIndexSet indexLessThanOrEqualToIndex:i];
                if (lastIndex != index)
                {
                    lastIndex = index;
                    line ++;
                }
                
                sbvgtuiFrame.width += fill;
                sbvgtuiFrame.leading += fill * line;
                
                sbvgtuiFrame.leading += between * line;
                
            }
        }
        
    }
    
    
    return selfSize;
}



-(CGSize)gtuiLayoutSubviewsForHorz:(CGSize)selfSize sbs:(NSMutableArray*)sbs isEstimate:(BOOL)isEstimate lsc:(GTUIFlowLayout*)lsc
{
    CGFloat paddingTop = lsc.gtuiLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtuiLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtuiLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;
    
    BOOL autoArrange = lsc.autoArrange;
    NSInteger arrangedCount = lsc.arrangedCount;
    CGFloat xPos = paddingLeading;
    CGFloat yPos = paddingTop;
    CGFloat colMaxWidth = 0;  //每列的最大宽度
    CGFloat colMaxHeight = 0; //每列的最大高度
    CGFloat maxHeight = paddingTop;
    CGFloat maxWidth = paddingLeading; //最大的宽度。
    
    GTUIGravity vertGravity = lsc.gravity & GTUIGravityHorzMask;
    GTUIGravity horzGravity = [self gtuiConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTUIGravityVertMask];
    GTUIGravity horzAlign =  [self gtuiConvertLeftRightGravityToLeadingTrailing:lsc.arrangedGravity & GTUIGravityVertMask];
    
    
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).subviewSize;
    if (subviewSize != 0)
    {
        
        CGFloat maxSpace = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).maxSpace;
        CGFloat minSpace = ((GTUIFlowLayoutViewSizeClass*)self.gtuiCurrentSizeClass).minSpace;
        if (arrangedCount > 1)
        {
            vertSpace = (selfSize.height - paddingVert - subviewSize * arrangedCount)/(arrangedCount - 1);
            if (_gtuiCGFloatGreat(vertSpace, maxSpace) || _gtuiCGFloatLess(vertSpace, minSpace))
            {
                if (_gtuiCGFloatGreat(vertSpace, maxSpace))
                    vertSpace = maxSpace;
                if (_gtuiCGFloatLess(vertSpace, minSpace))
                    vertSpace = minSpace;
                
                subviewSize =  (selfSize.height - paddingVert -  vertSpace * (arrangedCount - 1)) / arrangedCount;
                
            }
        }
    }
    
    //父滚动视图是否分页滚动。
#if TARGET_OS_IOS
    //判断父滚动视图是否分页滚动
    BOOL isPagingScroll = (self.superview != nil &&
                           [self.superview isKindOfClass:[UIScrollView class]] && ((UIScrollView*)self.superview).isPagingEnabled);
#else
    BOOL isPagingScroll = NO;
#endif
    
    CGFloat pagingItemHeight = 0;
    CGFloat pagingItemWidth = 0;
    BOOL isVertPaging = NO;
    BOOL isHorzPaging = NO;
    if (lsc.pagedCount > 0 && self.superview != nil)
    {
        NSInteger cols = lsc.pagedCount / arrangedCount;  //每页的列数。
        
        //对于水平流式布局来说，要求要有明确的高度。因此如果我们启用了分页又设置了高度包裹时则我们的分页是从上到下的排列。否则分页是从左到右的排列。
        if (lsc.wrapContentHeight)
        {
            isVertPaging = YES;
            if (isPagingScroll)
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingVert - (arrangedCount - 1) * vertSpace ) / arrangedCount;
            else
                pagingItemHeight = (CGRectGetHeight(self.superview.bounds) - paddingTop - arrangedCount * vertSpace ) / arrangedCount;
            
            pagingItemWidth = (selfSize.width - paddingHorz - (cols - 1) * horzSpace) / cols;
        }
        else
        {
            isHorzPaging = YES;
            pagingItemHeight = (selfSize.height - paddingVert - (arrangedCount - 1) * vertSpace) / arrangedCount;
            //分页滚动时和非分页滚动时的宽度计算是不一样的。
            if (isPagingScroll)
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingHorz - (cols - 1) * horzSpace) / cols;
            else
                pagingItemWidth = (CGRectGetWidth(self.superview.bounds) - paddingLeading - cols * horzSpace) / cols;
            
        }
        
    }
    
    BOOL averageArrange = (vertGravity == GTUIGravityVertFill);
    
    NSInteger arrangedIndex = 0;
    NSInteger i = 0;
    CGFloat rowTotalWeight = 0;
    CGFloat rowTotalFixedHeight = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        if (arrangedIndex >= arrangedCount)
        {
            arrangedIndex = 0;
            
            if (rowTotalWeight != 0 && !averageArrange)
            {
                [self gtuiCalcHorzLayoutSinglelineWeight:selfSize totalFloatHeight:selfSize.height - paddingVert - rowTotalFixedHeight totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedCount];
            }
            
            rowTotalWeight = 0;
            rowTotalFixedHeight = 0;
            
        }
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGRect rect = sbvgtuiFrame.frame;
        
        
        if (pagingItemWidth != 0)
            rect.size.width = pagingItemWidth;
        
        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;
        
        //当子视图的尺寸是相对依赖于其他尺寸的值。
        [self gtuiSetSubviewRelativeDimeSize:sbvsc.widthSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
        
        
        rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        if (sbvsc.weight != 0)
        {
            
            rowTotalWeight += sbvsc.weight;
        }
        else
        {
            
            BOOL isFlexedHeight = sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]] && sbvsc.heightSizeInner.dimeRelaVal.view != self;
            
            if (subviewSize != 0)
                rect.size.height = subviewSize;
            
            if (pagingItemHeight != 0)
                rect.size.height = pagingItemHeight;
            
            if (sbvsc.heightSizeInner.dimeNumVal != nil && !averageArrange)
                rect.size.height = sbvsc.heightSizeInner.measure;
            
            //当子视图的尺寸是相对依赖于其他尺寸的值。
            [self gtuiSetSubviewRelativeDimeSize:sbvsc.heightSizeInner selfSize:selfSize lsc:lsc pRect:&rect];
            
            
            //如果高度是浮动的则需要调整高度。
            if (isFlexedHeight)
                rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
            
            rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
            
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: rect.size.height ] sbvSize:rect.size selfLayoutSize:selfSize];
            
            rowTotalFixedHeight += rect.size.height;
        }
        
        rowTotalFixedHeight += topSpace + bottomSpace;
        
        
        if (arrangedIndex != (arrangedCount - 1))
            rowTotalFixedHeight += vertSpace;
        
        
        sbvgtuiFrame.frame = rect;
        
        arrangedIndex++;
        
    }
    
    //最后一行。
    if (rowTotalWeight != 0 && !averageArrange)
    {
        if (arrangedIndex < arrangedCount)
            rowTotalFixedHeight -= vertSpace;
        
        [self gtuiCalcHorzLayoutSinglelineWeight:selfSize totalFloatHeight:selfSize.height - paddingVert - rowTotalFixedHeight totalWeight:rowTotalWeight sbs:sbs startIndex:i count:arrangedIndex];
    }
    
    //每行的下一个位置。
    NSMutableArray<NSValue*> *nextPointOfRows = nil;
    if (autoArrange)
    {
        nextPointOfRows = [NSMutableArray arrayWithCapacity:arrangedCount];
        for (NSInteger idx = 0; idx < arrangedCount; idx++)
        {
            [nextPointOfRows addObject:[NSValue valueWithCGPoint:CGPointMake(paddingLeading, paddingTop)]];
        }
    }
    
    CGFloat pageHeight = 0; //页高
    CGFloat averageHeight = (selfSize.height - paddingVert - (arrangedCount - 1) * vertSpace) / arrangedCount;
    arrangedIndex = 0;
    i = 0;
    for (; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        if (arrangedIndex >=  arrangedCount)
        {
            arrangedIndex = 0;
            xPos += colMaxWidth;
            xPos += horzSpace;
            
            //分别处理水平分页和垂直分页。
            if (isVertPaging)
            {
                if (i % lsc.pagedCount == 0)
                {
                    pageHeight += CGRectGetHeight(self.superview.bounds);
                    
                    if (!isPagingScroll)
                        pageHeight -= paddingTop;
                    
                    xPos = paddingLeading;
                }
                
            }
            
            if (isHorzPaging)
            {
                //如果是分页滚动则要多添加垂直间距。
                if (i % lsc.pagedCount == 0)
                {
                    
                    if (isPagingScroll)
                    {
                        xPos -= horzSpace;
                        xPos += paddingTrailing;
                        xPos += paddingLeading;
                    }
                }
            }
            
            
            yPos = paddingTop + pageHeight;
            
            
            //计算每行的gravity情况。
            [self gtuiCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedCount vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
            
            colMaxWidth = 0;
            colMaxHeight = 0;
        }
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvgtuiFrame.frame;
        
        
        if (averageArrange)
        {
            
            rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:averageHeight - topSpace - bottomSpace sbvSize:rect.size selfLayoutSize:selfSize];
            
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: rect.size.height ] sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        //得到最大的列宽
        if (_gtuiCGFloatLess(colMaxWidth, leadingSpace + trailingSpace + rect.size.width))
            colMaxWidth = leadingSpace + trailingSpace + rect.size.width;
        
        //自动排列。
        if (autoArrange)
        {
            //查找能存放当前子视图的最小x轴的位置以及索引。
            CGPoint minPt = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
            NSInteger minNextPointIndex = 0;
            for (int idx = 0; idx < arrangedCount; idx++)
            {
                CGPoint pt = nextPointOfRows[idx].CGPointValue;
                if (minPt.x > pt.x)
                {
                    minPt = pt;
                    minNextPointIndex = idx;
                }
            }
            
            //找到的minNextPointIndex中的
            xPos = minPt.x;
            yPos = minPt.y;
            
            minPt.x = minPt.x + leadingSpace + rect.size.width + trailingSpace + horzSpace;
            nextPointOfRows[minNextPointIndex] = [NSValue valueWithCGPoint:minPt];
            if (minNextPointIndex + 1 <= arrangedCount - 1)
            {
                minPt = nextPointOfRows[minNextPointIndex + 1].CGPointValue;
                minPt.y = yPos + topSpace + rect.size.height + bottomSpace + vertSpace;
                nextPointOfRows[minNextPointIndex + 1] = [NSValue valueWithCGPoint:minPt];
            }
            
            if (_gtuiCGFloatLess(maxWidth, xPos + leadingSpace + rect.size.width + trailingSpace))
                maxWidth = xPos + leadingSpace + rect.size.width + trailingSpace;
            
        }
        else if (horzAlign == GTUIGravityHorzBetween)
        { //当列是紧凑排列时需要特殊处理当前的水平位置。
            //第0列特殊处理。
            if (i - arrangedCount < 0)
            {
                xPos = paddingLeading;
            }
            else
            {
                //取前一列的对应的行的子视图。
                GTUIFrame *gtuiPrevColSbvFrame = ((UIView*)sbs[i - arrangedCount]).gtuiFrame;
                UIView *gtuiPrevColSbvsc = [self gtuiCurrentSizeClassFrom:gtuiPrevColSbvFrame];
                //当前子视图的位置等于前一列对应行的最大x的值 + 前面对应行的尾部间距 + 子视图之间的列间距。
                xPos =  CGRectGetMaxX(gtuiPrevColSbvFrame.frame)+ gtuiPrevColSbvsc.trailingPosInner.absVal + horzSpace;
            }
            
            if (_gtuiCGFloatLess(maxWidth, xPos + leadingSpace + rect.size.width + trailingSpace))
                maxWidth = xPos + leadingSpace + rect.size.width + trailingSpace;
        }
        else
        {//正常排列。
            //这里的最大其实就是最后一个视图的位置加上最宽的子视图的尺寸。
            maxWidth = xPos + colMaxWidth;
        }
        
        rect.origin.x = xPos + leadingSpace;
        rect.origin.y = yPos + topSpace;
        yPos += topSpace + rect.size.height + bottomSpace;
        
        //不是最后一行以及非自动排列时才添加布局视图设置的行间距。自动排列的情况下上面已经有添加行间距了。
        if (arrangedIndex != (arrangedCount - 1) && !autoArrange)
            yPos += vertSpace;
        
        
        if (_gtuiCGFloatLess(colMaxHeight, (yPos - paddingTop)))
            colMaxHeight = yPos - paddingTop;
        
        if (_gtuiCGFloatLess(maxHeight, yPos))
            maxHeight = yPos;
        
        
        sbvgtuiFrame.frame = rect;
        
        
        arrangedIndex++;
        
    }
    
    //最后一列
    [self gtuiCalcHorzLayoutSinglelineAlignment:selfSize colMaxWidth:colMaxWidth colMaxHeight:colMaxHeight vertGravity:vertGravity horzAlignment:horzAlign sbs:sbs startIndex:i count:arrangedIndex vertSpace:vertSpace horzSpace:horzSpace isEstimate:isEstimate lsc:lsc];
    
    if (lsc.wrapContentHeight && !averageArrange)
    {
        selfSize.height = maxHeight + paddingBottom;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isVertPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_gtuiCGFloatLess(selfSize.height, totalPages * CGRectGetHeight(self.superview.bounds)))
                selfSize.height = totalPages * CGRectGetHeight(self.superview.bounds);
        }
    }
    
    
    maxWidth += paddingTrailing;
    
    if (lsc.wrapContentWidth)
    {
        selfSize.width = maxWidth;
        
        //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
        if (isHorzPaging && isPagingScroll)
        {
            //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
            NSInteger totalPages = floor((sbs.count + lsc.pagedCount - 1.0 ) / lsc.pagedCount);
            if (_gtuiCGFloatLess(selfSize.width, totalPages * CGRectGetWidth(self.superview.bounds)))
                selfSize.width = totalPages * CGRectGetWidth(self.superview.bounds);
        }
        
    }
    else
    {
        
        CGFloat addXPos = 0;
        CGFloat between = 0;
        CGFloat fill = 0;
        int arranges = floor((sbs.count + arrangedCount - 1.0) / arrangedCount); //列数
        
        if (horzGravity == GTUIGravityHorzCenter)
        {
            addXPos = (selfSize.width - maxWidth) / 2;
        }
        else if (horzGravity == GTUIGravityHorzTrailing)
        {
            addXPos = selfSize.width - maxWidth;
        }
        else if (horzGravity == GTUIGravityHorzFill)
        {
            if (arranges > 0)
                fill = (selfSize.width - maxWidth) / arranges;
        }
        else if (horzGravity == GTUIGravityHorzBetween)
        {
            if (arranges > 1)
                between = (selfSize.width - maxWidth) / (arranges - 1);
        }
        
        if (addXPos != 0 || between != 0 || fill != 0)
        {
            for (int i = 0; i < sbs.count; i++)
            {
                UIView *sbv = sbs[i];
                
                GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
                
                int lines = i / arrangedCount;
                sbvgtuiFrame.width += fill;
                sbvgtuiFrame.leading += fill * lines;
                
                sbvgtuiFrame.leading += addXPos;
                
                sbvgtuiFrame.leading += between * lines;
                
            }
        }
    }
    
    
    return selfSize;
    
}

@end
