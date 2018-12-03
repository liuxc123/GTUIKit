//
//  GTUILinearLayout.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUILinearLayout.h"
#import "GTUILayout+Private.h"

@implementation GTUILinearLayout

#pragma mark -- Public Methods

-(instancetype)initWithFrame:(CGRect)frame orientation:(GTUIOrientation)orientation
{
    self = [super initWithFrame:frame];
    if (self)
    {
        GTUILinearLayout *lsc = self.gtuiCurrentSizeClass;
        if (orientation == GTUIOrientationVert)
            lsc.wrapContentHeight = YES;
        else
            lsc.wrapContentWidth = YES;
        lsc.orientation = orientation;
    }
    
    return self;
}


-(instancetype)initWithOrientation:(GTUIOrientation)orientation
{
    return [self initWithFrame:CGRectZero orientation:orientation];
}

+(instancetype)linearLayoutWithOrientation:(GTUIOrientation)orientation
{
    return [[[self class] alloc] initWithOrientation:orientation];
}

-(void)setOrientation:(GTUIOrientation)orientation
{
    GTUILinearLayout *lsc = self.gtuiCurrentSizeClass;
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



-(void)setShrinkType:(GTUISubviewsShrinkType)shrinkType
{
    GTUILinearLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.shrinkType != shrinkType)
    {
        lsc.shrinkType = shrinkType;
        [self setNeedsLayout];
    }
}

-(GTUISubviewsShrinkType)shrinkType
{
    return self.gtuiCurrentSizeClass.shrinkType;
}


-(void)equalizeSubviews:(BOOL)centered
{
    [self equalizeSubviews:centered withSpace:CGFLOAT_MAX];
}

-(void)equalizeSubviews:(BOOL)centered inSizeClass:(GTUISizeClass)sizeClass
{
    [self equalizeSubviews:centered withSpace:CGFLOAT_MAX inSizeClass:sizeClass];
}

-(void)equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space
{
    [self equalizeSubviews:centered withSpace:space inSizeClass:GTUISizeClasshAny | GTUISizeClasswAny];
    [self setNeedsLayout];
}

-(void)equalizeSubviews:(BOOL)centered withSpace:(CGFloat)space inSizeClass:(GTUISizeClass)sizeClass
{
    self.gtuiFrame.sizeClass = [self fetchLayoutSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
        sbv.gtuiFrame.sizeClass = [sbv fetchLayoutSizeClass:sizeClass];
    
    if (self.orientation == GTUIOrientationVert)
    {
        [self gtuiEqualizeSubviewsForVert:centered withSpace:space];
    }
    else
    {
        [self gtuiEqualizeSubviewsForHorz:centered withSpace:space];
    }
    
    self.gtuiFrame.sizeClass = self.gtuiDefaultSizeClass;
    for (UIView *sbv in self.subviews)
        sbv.gtuiFrame.sizeClass = sbv.gtuiDefaultSizeClass;
    
}

-(void)equalizeSubviewsSpace:(BOOL)centered
{
    [self equalizeSubviewsSpace:centered inSizeClass:GTUISizeClasshAny | GTUISizeClasswAny];
    [self setNeedsLayout];
    
}

-(void)equalizeSubviewsSpace:(BOOL)centered inSizeClass:(GTUISizeClass)sizeClass
{
    
    self.gtuiFrame.sizeClass = [self fetchLayoutSizeClass:sizeClass];
    for (UIView *sbv in self.subviews)
        sbv.gtuiFrame.sizeClass = [sbv fetchLayoutSizeClass:sizeClass];
    
    if (self.orientation == GTUIOrientationVert)
    {
        [self gtuiEqualizeSubviewsSpaceForVert:centered];
    }
    else
    {
        [self gtuiEqualizeSubviewsSpaceForHorz:centered];
    }
    
    self.gtuiFrame.sizeClass = self.gtuiDefaultSizeClass;
    for (UIView *sbv in self.subviews)
        sbv.gtuiFrame.sizeClass = sbv.gtuiDefaultSizeClass;
    
}


#pragma mark -- Override Methods

- (void)willMoveToSuperview:(UIView*)newSuperview
{
    //减少约束冲突的提示。。
    GTUILinearLayout *lsc = self.gtuiCurrentSizeClass;
    
    if (lsc.orientation == GTUIOrientationVert)
    {
        if (lsc.heightSizeInner.dimeVal != nil && lsc.wrapContentHeight)
        {
            lsc.wrapContentHeight = NO;
        }
        
    }
    else
    {
        if (lsc.widthSizeInner.dimeVal != nil && lsc.wrapContentWidth)
        {
            lsc.wrapContentWidth = NO;
        }
        
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
    if (subview == self.baselineBaseView)
    {
        self.baselineBaseView = nil;
    }
}




-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(GTUISizeClass)sizeClass sbs:(NSMutableArray *)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self gtuiGetLayoutSubviews];
    
    
    GTUILinearLayout *lsc = self.gtuiCurrentSizeClass;
    
    GTUIGravity vertGravity = lsc.gravity & GTUIGravityHorzMask;
    GTUIGravity horzGravity = lsc.gravity & GTUIGravityVertMask;
    GTUIOrientation oreintation = lsc.orientation;
    
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
            [self gtuiAdjustSubviewWrapContent:sbv sbvsc:sbvsc orientation:oreintation gravity:(oreintation == GTUIOrientationVert)? horzGravity : vertGravity];
            
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
    
    if (oreintation == GTUIOrientationVert)
    {
        if (vertGravity != GTUIGravityNone)
            selfSize = [self gtuiLayoutSubviewsForVertGravity:selfSize sbs:sbs lsc:lsc];
        else
            selfSize = [self gtuiLayoutSubviewsForVert:selfSize sbs:sbs lsc:lsc];
    }
    else
    {
        if (horzGravity != GTUIGravityNone)
            selfSize = [self gtuiLayoutSubviewsForHorzGravity:selfSize sbs:sbs lsc:lsc];
        else
            selfSize = [self gtuiLayoutSubviewsForHorz:selfSize sbs:sbs lsc:lsc];
    }
    
    //绘制智能线。
    if (!isEstimate)
    {
        [self gtuiSetLayoutIntelligentBorderline:sbs lsc:lsc];
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
    return [GTUILinearLayoutViewSizeClass new];
}


#pragma mark -- Private Methods

//调整子视图的wrapContent设置
- (void)gtuiAdjustSubviewWrapContent:(UIView*)sbv sbvsc:(UIView*)sbvsc orientation:(GTUIOrientation)orientation  gravity:(GTUIGravity)gravity
{
    if (orientation == GTUIOrientationVert)
    {
        if (sbvsc.wrapContentWidth)
        {
            //只要同时设置了左右边距或者设置了宽度或者设置了子视图宽度填充则应该把wrapContentWidth置为NO
            if ((sbvsc.widthSizeInner.dimeVal != nil) ||
                (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil) ||
                (gravity == GTUIGravityHorzFill)
                )
            {
                sbvsc.wrapContentWidth = NO;
            }
        }
        
        if (sbvsc.wrapContentHeight)
        {
            //只要同时设置了高度或者比重属性则应该把wrapContentHeight置为NO
            if ((sbvsc.heightSizeInner.dimeVal != nil) ||
                (sbvsc.weight != 0))
            {
                sbvsc.wrapContentHeight = NO;
            }
        }
        
    }
    else
    {
        
        if (sbvsc.wrapContentHeight)
        {
            //只要同时设置了高度或者上下边距或者父视图的填充属性则应该把wrapContentHeight置为NO
            if ((sbvsc.heightSizeInner.dimeVal != nil) ||
                (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil) ||
                (gravity == GTUIGravityVertFill)
                )
            {
                sbvsc.wrapContentHeight = NO;
            }
        }
        
        if (sbvsc.wrapContentWidth)
        {
            //只要同时设置了宽度或者比重属性则应该把wrapContentWidth置为NO
            if (sbvsc.widthSizeInner.dimeVal != nil || sbvsc.weight != 0)
            {
                sbvsc.wrapContentWidth = NO;
            }
        }
    }
}

//设置智能边界线
-(void)gtuiSetLayoutIntelligentBorderline:(NSArray*)sbs lsc:(GTUILinearLayout*)lsc
{
    if (self.intelligentBorderline == nil)
        return;
    
    BOOL isVert = (lsc.orientation == GTUIOrientationVert);
    CGFloat subviewSpace = (lsc.orientation == GTUIOrientationVert) ? lsc.subviewVSpace : lsc.subviewHSpace;
    for (int i = 0; i < sbs.count; i++)
    {
        UIView *sbv = sbs[i];
        if (![sbv isKindOfClass:[GTUIBaseLayout class]])
            continue;
        
        GTUIBaseLayout *sbvl = (GTUIBaseLayout*)sbv;
        if (sbvl.notUseIntelligentBorderline)
            continue;
        
        if (isVert)
        {
            sbvl.topBorderline = nil;
            sbvl.bottomBorderline = nil;
        }
        else
        {
            sbvl.leadingBorderline = nil;
            sbvl.trailingBorderline = nil;
        }
        
        UIView *prevSiblingView = nil;
        UIView *nextSiblingView = nil;
        
        if (i != 0)
        {
            prevSiblingView = sbs[i - 1];
        }
        
        if (i + 1 != sbs.count)
        {
            nextSiblingView = sbs[i + 1];
        }
        
        if (prevSiblingView != nil)
        {
            BOOL ok = YES;
            if ([prevSiblingView isKindOfClass:[GTUIBaseLayout class]] && subviewSpace == 0)
            {
                GTUIBaseLayout *prevSiblingLayout = (GTUIBaseLayout*)prevSiblingView;
                if (prevSiblingLayout.notUseIntelligentBorderline)
                    ok = NO;
            }
            
            if (ok)
            {
                if (isVert)
                    sbvl.topBorderline = self.intelligentBorderline;
                else
                    sbvl.leadingBorderline = self.intelligentBorderline;
            }
        }
        
        if (nextSiblingView != nil && (![nextSiblingView isKindOfClass:[GTUIBaseLayout class]] || subviewSpace != 0))
        {
            if (isVert)
                sbvl.bottomBorderline = self.intelligentBorderline;
            else
                sbvl.trailingBorderline = self.intelligentBorderline;
        }
    }
}

//计算得到最大的包裹宽度
- (CGSize)gtuiCalcMaxWrapWidth:(NSArray *)sbs selfSize:(CGSize)selfSize paddingHorz:(CGFloat)paddingHorz lsc:(GTUILinearLayout*)lsc
{
    CGFloat maxWrapWidth = 0;
    if (lsc.wrapContentWidth)
    {
        for (UIView *sbv in sbs)
        {
            GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
            UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
            
            //只有宽度不依赖于父视图并且没有设置左右边距则参与最大包裹宽度计算。
            GTUILayoutSize *relaSize = sbvsc.widthSizeInner.dimeRelaVal;
            if (relaSize.view != self && (sbvsc.leadingPosInner.posVal == nil || sbvsc.trailingPosInner.posVal == nil))
            {
                
                CGFloat subviewWidth = sbvgtuiFrame.width;
                if (sbvsc.widthSizeInner.dimeNumVal != nil)
                {
                    subviewWidth = sbvsc.widthSizeInner.measure;
                }
                sbvgtuiFrame.width = subviewWidth;
                
                //头部 + 中间偏移 + 宽度 + 尾部。 这里要进行计算的原因是有可能左边距或者右边距设置的是相对边距，因此这里要推导出布局视图的宽度。
                maxWrapWidth = [self gtuiCalcSelfSize:maxWrapWidth
                                        subviewSize:subviewWidth
                                            headPos:sbvsc.leadingPosInner
                                          centerPos:sbvsc.centerXPosInner
                                            tailPos:sbvsc.trailingPosInner];
                
                
            }
        }
        
        selfSize.width = maxWrapWidth + paddingHorz;
    }
    
    return selfSize;
}

-(CGSize)gtuiLayoutSubviewsForVert:(CGSize)selfSize sbs:(NSArray*)sbs lsc:(GTUILinearLayout*)lsc
{
    CGFloat subviewSpace = lsc.subviewVSpace;
    CGFloat paddingTop = lsc.gtuiLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtuiLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtuiLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;
    GTUIGravity horzGravity = [self gtuiConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTUIGravityVertMask];
    
    CGFloat fixedHeight = 0;   //计算固定部分的高度
    CGFloat totalWeight = 0;    //剩余部分的总比重
    CGFloat addSpace = 0;      //用于压缩时的间距压缩增量。
    
    selfSize = [self gtuiCalcMaxWrapWidth:sbs selfSize:selfSize paddingHorz:paddingHorz lsc:lsc];   //调整自身的宽度
    
    NSMutableArray *fixedSizeSbs = [NSMutableArray new];
    CGFloat fixedSizeHeight = 0;
    NSInteger fixedSpaceCount = 0;  //固定间距的子视图数量。
    CGFloat  fixedSpaceHeight = 0;  //固定间距的子视图的宽度。
    CGFloat pos = paddingTop;
    for (UIView *sbv in sbs)
    {
        
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        CGRect rect = sbvgtuiFrame.frame;
        
        [self gtuiCalcLeadingTrailingRect:horzGravity
                               selfSize:selfSize
                                 rect_p:&rect
                                    sbv:sbv
                        paddingTrailing:paddingTrailing
                         paddingLeading:paddingLeading
                                  sbvsc:sbvsc
                                    lsc:lsc];
        
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]] && sbvsc.weight == 0)
        {//特殊处理高度等于wrap的情况。
            
            rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        }
        else if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
        {//特殊处理高度等于宽度的情况
            
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
        }
        else if (sbvsc.heightSizeInner.dimeRelaVal != nil  && sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner)
        {//高度依赖父视图高度
            rect.size.height = [sbvsc.heightSizeInner measureWith:selfSize.height - paddingVert];
        }
        else if (sbvsc.heightSizeInner.dimeNumVal != nil)
        { //计算出相对高度和上下位置。
            rect.size.height = sbvsc.heightSizeInner.measure;
        }
        else;
        
        rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //计算固定高度尺寸和浮动高度尺寸部分
        
        if (sbvsc.topPosInner.isRelativePos)
        {
            totalWeight += sbvsc.topPosInner.posNumVal.doubleValue;
            
            fixedHeight += sbvsc.topPosInner.offsetVal;
        }
        else
        {
            fixedHeight += sbvsc.topPosInner.absVal;
            
            if (sbvsc.topPosInner.absVal != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += sbvsc.topPosInner.absVal;
            }
            
        }
        
        pos += sbvsc.topPosInner.absVal;
        rect.origin.y = pos;
        
        
        if (sbvsc.weight > 0.0)
        {
            totalWeight += sbvsc.weight;
        }
        else
        {
            fixedHeight += rect.size.height;
            
            //如果最小高度不为自身并且高度不是包裹的则可以进行缩小。
            if (sbvsc.heightSizeInner.lBoundValInner.dimeSelfVal == nil)
            {
                fixedSizeHeight += rect.size.height;
                [fixedSizeSbs addObject:sbv];
            }
        }
        
        pos += rect.size.height;
        
        if (sbvsc.bottomPosInner.isRelativePos)
        {
            totalWeight += sbvsc.bottomPosInner.posNumVal.doubleValue;
            fixedHeight += sbvsc.bottomPosInner.offsetVal;
        }
        else
        {
            fixedHeight += sbvsc.bottomPosInner.absVal;
            
            if (sbvsc.bottomPosInner.absVal != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += sbvsc.bottomPosInner.absVal;
            }
            
        }
        
        pos += sbvsc.bottomPosInner.absVal;
        
        if (sbv != sbs.lastObject)
        {
            fixedHeight += subviewSpace;
            
            pos += subviewSpace;
            
            if (subviewSpace != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceHeight += subviewSpace;
            }
        }
        
        sbvgtuiFrame.frame = rect;
    }
    
    //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
    if (lsc.wrapContentHeight && totalWeight != 0)
    {
        CGFloat tempSelfHeight = paddingVert;
        if (sbs.count > 1)
            tempSelfHeight += (sbs.count - 1) * subviewSpace;
        
        selfSize.height = [self gtuiValidMeasure:lsc.heightSizeInner sbv:self calcSize:tempSelfHeight sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
        
    }
    
    //这里需要特殊处理当子视图的尺寸高度大于布局视图的高度的情况。
    
    BOOL isWeightShrinkSpace = NO;   //是否按比重缩小间距。
    CGFloat weightShrinkSpaceTotalHeight = 0;
    CGFloat floatingHeight = selfSize.height - fixedHeight - paddingVert;  //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
    //取出shrinkType中的模式和内容类型：
    GTUISubviewsShrinkType sstMode = lsc.shrinkType & 0x0F; //压缩的模式
    GTUISubviewsShrinkType sstContent = lsc.shrinkType & 0xF0; //压缩内容
    if (_gtuiCGFloatLessOrEqual(floatingHeight, 0))
    {
        if (sstMode != GTUISubviewsShrinkNone)
        {
            if (sstContent == GTUISubviewsShrinkSize)
            {//压缩尺寸
                if (fixedSizeSbs.count > 0 && totalWeight != 0 && floatingHeight < 0 && selfSize.height > 0)
                {
                    if (sstMode == GTUISubviewsShrinkAverage)
                    {//均分。
                        CGFloat averageHeight = floatingHeight / fixedSizeSbs.count;
                        
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.gtuiFrame.height += averageHeight;
                        }
                    }
                    else if (_gtuiCGFloatNotEqual(fixedSizeHeight, 0))
                    {//按比例分配。
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.gtuiFrame.height += floatingHeight * (fsbv.gtuiFrame.height / fixedSizeHeight);
                        }
                        
                    }
                }
            }
            else if (sstContent == GTUISubviewsShrinkSpace)
            {//压缩间距
                if (fixedSpaceCount > 0 && floatingHeight < 0 && selfSize.height > 0 && fixedSpaceHeight > 0)
                {
                    if (sstMode == GTUISubviewsShrinkAverage)
                    {
                        addSpace = floatingHeight / fixedSpaceCount;
                    }
                    else if (sstMode == GTUISubviewsShrinkWeight)
                    {
                        isWeightShrinkSpace = YES;
                        weightShrinkSpaceTotalHeight = floatingHeight;
                    }
                }
                
            }
            else
            {
                ;
            }
            
        }
        
        
        floatingHeight = 0;
    }
    
    //如果有浮动尺寸或者有压缩模式
    if (totalWeight != 0 || (sstMode != GTUISubviewsShrinkNone && _gtuiCGFloatLessOrEqual(floatingHeight, 0)))
    {
        pos = paddingTop;
        for (UIView *sbv in sbs) {
            
            GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
            UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
            
            
            CGFloat topSpace = sbvsc.topPosInner.posNumVal.doubleValue;
            CGFloat bottomSpace = sbvsc.bottomPosInner.posNumVal.doubleValue;
            CGFloat weight = sbvsc.weight;
            CGRect rect =  sbvgtuiFrame.frame;
            
            //分别处理相对顶部间距和绝对顶部间距
            if ([self gtuiIsRelativePos:topSpace])
            {
                CGFloat topSpaceWeight = topSpace;
                topSpace = _gtuiCGFloatRound((topSpaceWeight / totalWeight) * floatingHeight);
                floatingHeight -= topSpace;
                totalWeight -= topSpaceWeight;
                if (_gtuiCGFloatLessOrEqual(topSpace, 0))
                    topSpace = 0;
            }
            else
            {
                if (topSpace + sbvsc.topPosInner.offsetVal != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalHeight * (topSpace + sbvsc.topPosInner.offsetVal) / fixedSpaceHeight;
                    }
                }
                
            }
            
            pos += [self gtuiValidMargin:sbvsc.topPosInner sbv:sbv calcPos:topSpace + sbvsc.topPosInner.offsetVal selfLayoutSize:selfSize];
            rect.origin.y = pos;
            
            //分别处理相对高度和绝对高度
            if (weight > 0)
            {
                CGFloat h = _gtuiCGFloatRound((weight / totalWeight) * floatingHeight);
                floatingHeight -= h;
                totalWeight -= weight;
                if (_gtuiCGFloatLessOrEqual(h, 0))
                    h = 0;
                
                rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:h sbvSize:rect.size selfLayoutSize:selfSize];
            }
            
            pos += rect.size.height;
            
            //分别处理相对底部间距和绝对底部间距
            if ([self gtuiIsRelativePos:bottomSpace])
            {
                CGFloat bottomSpaceWeight = bottomSpace;
                bottomSpace = _gtuiCGFloatRound((bottomSpaceWeight / totalWeight) * floatingHeight);
                floatingHeight -= bottomSpace;
                totalWeight -= bottomSpaceWeight;
                if ( _gtuiCGFloatLessOrEqual(bottomSpace, 0))
                    bottomSpace = 0;
                
            }
            else
            {
                if (bottomSpace + sbvsc.bottomPosInner.offsetVal != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalHeight * (bottomSpace + sbvsc.bottomPosInner.offsetVal) / fixedSpaceHeight;
                    }
                }
                
            }
            
            pos += [self gtuiValidMargin:sbvsc.bottomPosInner sbv:sbv calcPos:bottomSpace + sbvsc.bottomPosInner.offsetVal selfLayoutSize:selfSize];
            
            //添加共有的子视图间距
            if (sbv != sbs.lastObject)
            {
                pos += subviewSpace;
                
                if (subviewSpace != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalHeight * subviewSpace / fixedSpaceHeight;
                    }
                }
                
            }
            
            sbvgtuiFrame.frame = rect;
        }
        
    }
    
    pos += paddingBottom;
    
    if (lsc.wrapContentHeight)
    {
        selfSize.height = pos;
    }
    
    return selfSize;
}

-(CGSize)gtuiLayoutSubviewsForHorz:(CGSize)selfSize sbs:(NSArray*)sbs lsc:(GTUILinearLayout*)lsc
{
    
    CGFloat subviewSpace = lsc.subviewHSpace;
    CGFloat paddingTop = lsc.gtuiLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtuiLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtuiLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;
    GTUIGravity vertGravity = lsc.gravity & GTUIGravityHorzMask;
    
    CGFloat fixedWidth = 0;   //计算固定部分的高度
    CGFloat floatingWidth = 0; //浮动的高度。
    CGFloat totalWeight = 0;
    
    CGFloat maxSubviewHeight = 0;
    CGFloat addSpace = 0;   //用于压缩时的间距压缩增量。
    
    //计算出固定的子视图宽度的总和以及宽度比例总和
    
    NSMutableArray *fixedSizeSbs = [NSMutableArray new];
    NSMutableArray *flexedSizeSbs = [NSMutableArray new];
    CGFloat fixedSizeWidth = 0;   //固定尺寸的宽度
    NSInteger fixedSpaceCount = 0;  //固定间距的子视图数量。
    CGFloat  fixedSpaceWidth = 0;  //固定间距的子视图的宽度。
    for (UIView *sbv in sbs)
    {
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        if (sbvsc.leadingPosInner.isRelativePos)
        {
            totalWeight += sbvsc.leadingPosInner.posNumVal.doubleValue;
            fixedWidth += sbvsc.leadingPosInner.offsetVal;
        }
        else
        {
            fixedWidth += sbvsc.leadingPosInner.absVal;
            if (sbvsc.leadingPosInner.absVal != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += sbvsc.leadingPosInner.absVal;
            }
        }
        
        if (sbvsc.trailingPosInner.isRelativePos)
        {
            totalWeight += sbvsc.trailingPosInner.posNumVal.doubleValue;
            fixedWidth += sbvsc.trailingPosInner.offsetVal;
        }
        else
        {
            fixedWidth += sbvsc.trailingPosInner.absVal;
            if (sbvsc.trailingPosInner.absVal != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += sbvsc.trailingPosInner.absVal;
            }
            
        }
        
        if (sbvsc.weight > 0.0)
        {
            totalWeight += sbvsc.weight;
        }
        else
        {
            CGFloat vWidth = sbvgtuiFrame.width;
            if (sbvsc.widthSizeInner.dimeNumVal != nil)
                vWidth = sbvsc.widthSizeInner.measure;
            
            if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == lsc.widthSizeInner)
                vWidth = [sbvsc.widthSizeInner measureWith:selfSize.width - paddingHorz];
            
            vWidth = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:vWidth sbvSize:sbvgtuiFrame.frame.size selfLayoutSize:selfSize];
            sbvgtuiFrame.width = vWidth;
            fixedWidth += vWidth;
            
            //如果最小宽度不为自身并且宽度不是包裹的则可以进行缩小。
            if (sbvsc.widthSizeInner.lBoundValInner.dimeSelfVal == nil)
            {
                fixedSizeWidth += vWidth;
                [fixedSizeSbs addObject:sbv];
            }
            
            if (sbvsc.widthSizeInner.dimeSelfVal != nil)
            {
                [flexedSizeSbs addObject:sbv];
            }
        }
        
        if (sbv != sbs.lastObject)
        {
            fixedWidth += subviewSpace;
            if (subviewSpace != 0)
            {
                fixedSpaceCount += 1;
                fixedSpaceWidth += subviewSpace;
            }
        }
    }
    
    //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
    if (lsc.wrapContentWidth && totalWeight != 0)
    {
        CGFloat tempSelfWidth = paddingHorz;
        if (sbs.count > 1)
            tempSelfWidth += (sbs.count - 1) * subviewSpace;
        
        selfSize.width = [self gtuiValidMeasure:lsc.widthSizeInner sbv:self calcSize:tempSelfWidth sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
        
    }
    
    //剩余的可浮动的宽度，那些weight不为0的从这个高度来进行分发
    BOOL isWeightShrinkSpace = NO;   //是否按比重缩小间距。。。
    CGFloat weightShrinkSpaceTotalWidth = 0;
    floatingWidth = selfSize.width - fixedWidth - paddingHorz;
    if (_gtuiCGFloatLessOrEqual(floatingWidth, 0))
    {
        //取出shrinkType中的模式和内容类型：
        GTUISubviewsShrinkType sstMode = lsc.shrinkType & 0x0F;    //压缩的模式
        GTUISubviewsShrinkType sstContent = lsc.shrinkType & 0xF0; //压缩内容
        //如果压缩方式为自动，但是浮动宽度子视图数量不为2则压缩类型无效。
        if (sstMode == GTUISubviewsShrinkAuto && flexedSizeSbs.count != 2)
            sstMode = GTUISubviewsShrinkNone;
        
        if (sstMode != GTUISubviewsShrinkNone)
        {
            if (sstContent == GTUISubviewsShrinkSize)
            {
                if (fixedSizeSbs.count > 0 && totalWeight != 0 && floatingWidth < 0 && selfSize.width > 0)
                {
                    //均分。
                    if (sstMode == GTUISubviewsShrinkAverage)
                    {
                        CGFloat averageWidth = floatingWidth / fixedSizeSbs.count;
                        
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.gtuiFrame.width += averageWidth;
                            
                        }
                    }
                    else if (sstMode == GTUISubviewsShrinkAuto)
                    {
                        
                        UIView *leadingView = flexedSizeSbs[0];
                        UIView *trailingView = flexedSizeSbs[1];
                        
                        CGFloat leadingWidth = leadingView.gtuiFrame.width;
                        CGFloat trailingWidth = trailingView.gtuiFrame.width;
                        
                        //如果2个都超过一半则总是一半显示。
                        //如果1个超过了一半则 如果两个没有超过总宽度则正常显示，如果超过了总宽度则超过一半的视图的宽度等于总宽度减去未超过一半的视图的宽度。
                        //如果没有一个超过一半。则正常显示
                        CGFloat layoutWidth = floatingWidth + leadingWidth + trailingWidth;
                        CGFloat halfLayoutWidth = layoutWidth / 2;
                        
                        if (_gtuiCGFloatGreat(leadingWidth, halfLayoutWidth) && _gtuiCGFloatGreat(trailingWidth,halfLayoutWidth))
                        {
                            leadingView.gtuiFrame.width = halfLayoutWidth;
                            trailingView.gtuiFrame.width = halfLayoutWidth;
                        }
                        else if ((_gtuiCGFloatGreat(leadingWidth, halfLayoutWidth) || _gtuiCGFloatGreat(trailingWidth, halfLayoutWidth)) && (_gtuiCGFloatGreat(leadingWidth + trailingWidth, layoutWidth)))
                        {
                            
                            if (_gtuiCGFloatGreat(leadingWidth, halfLayoutWidth))
                            {
                                trailingView.gtuiFrame.width = trailingWidth;
                                leadingView.gtuiFrame.width = layoutWidth - trailingWidth;
                            }
                            else
                            {
                                leadingView.gtuiFrame.width = leadingWidth;
                                trailingView.gtuiFrame.width = layoutWidth - leadingWidth;
                            }
                            
                        }
                        else ;
                        
                        
                    }
                    else if (_gtuiCGFloatNotEqual(fixedSizeWidth, 0))
                    {//按比例分配。
                        for (UIView *fsbv in fixedSizeSbs)
                        {
                            fsbv.gtuiFrame.width += floatingWidth * (fsbv.gtuiFrame.width / fixedSizeWidth);
                        }
                        
                    }
                }
            }
            else if (sstContent == GTUISubviewsShrinkSpace)
            {
                if (fixedSpaceCount > 0 && floatingWidth < 0 && selfSize.width > 0 && fixedSpaceWidth > 0)
                {
                    if (sstMode == GTUISubviewsShrinkAverage)
                    {
                        addSpace = floatingWidth / fixedSpaceCount;
                    }
                    else if (sstMode == GTUISubviewsShrinkWeight)
                    {
                        isWeightShrinkSpace = YES;
                        weightShrinkSpaceTotalWidth = floatingWidth;
                    }
                }
                
            }
            else
            {
                ;
            }
            
        }
        
        
        
        floatingWidth = 0;
    }
    
    CGFloat baselinePos = CGFLOAT_MAX;  //保存基线的值。
    //调整所有子视图的宽度和高度。
    CGFloat pos = paddingLeading;
    for (UIView *sbv in sbs) {
        
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        CGFloat leadingSpace = sbvsc.leadingPosInner.posNumVal.doubleValue;
        CGFloat trailingSpace = sbvsc.trailingPosInner.posNumVal.doubleValue;
        CGFloat weight = sbvsc.weight;
        
        CGRect rect =  sbvgtuiFrame.frame;
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner)
            rect.size.height= [sbvsc.heightSizeInner measureWith:selfSize.height - paddingVert];
        
        
        //计算出先对左边边距和绝对左边边距
        if ([self gtuiIsRelativePos:leadingSpace])
        {
            CGFloat leadingSpaceWeight = leadingSpace;
            leadingSpace = _gtuiCGFloatRound((leadingSpaceWeight / totalWeight) * floatingWidth);
            floatingWidth -= leadingSpace;
            totalWeight -= leadingSpaceWeight;
            if (_gtuiCGFloatLessOrEqual(leadingSpace, 0))
                leadingSpace = 0;
            
        }
        else
        {
            if (leadingSpace + sbvsc.leadingPosInner.offsetVal != 0)
            {
                pos += addSpace;
                
                if (isWeightShrinkSpace)
                {
                    pos += weightShrinkSpaceTotalWidth * (leadingSpace + sbvsc.leadingPosInner.offsetVal) / fixedSpaceWidth;
                }
            }
            
        }
        
        pos += [self gtuiValidMargin:sbvsc.leadingPosInner sbv:sbv calcPos:leadingSpace + sbvsc.leadingPosInner.offsetVal selfLayoutSize:selfSize];
        
        rect.origin.x = pos;
        
        
        if (weight > 0)
        {
            CGFloat w = _gtuiCGFloatRound((weight / totalWeight) * floatingWidth);
            floatingWidth -= w;
            totalWeight -= weight;
            
            if (_gtuiCGFloatLessOrEqual(w, 0))
                w = 0;
            
            rect.size.width = w;
            
        }
        rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        pos += rect.size.width;
        
        //计算相对的右边边距和绝对的右边边距
        if ([self gtuiIsRelativePos:trailingSpace])
        {
            CGFloat trailingSpaceWeight = trailingSpace;
            trailingSpace = _gtuiCGFloatRound((trailingSpaceWeight / totalWeight) * floatingWidth);
            floatingWidth -= trailingSpace;
            totalWeight -= trailingSpaceWeight;
            if (_gtuiCGFloatLessOrEqual(trailingSpace, 0))
                trailingSpace = 0;
        }
        else
        {
            if (trailingSpace + sbvsc.trailingPosInner.offsetVal != 0)
            {
                pos += addSpace;
                
                if (isWeightShrinkSpace)
                {
                    pos += weightShrinkSpaceTotalWidth * (trailingSpace + sbvsc.trailingPosInner.offsetVal) / fixedSpaceWidth;
                }
            }
        }
        
        pos += [self gtuiValidMargin:sbvsc.trailingPosInner sbv:sbv calcPos:trailingSpace + sbvsc.trailingPosInner.offsetVal selfLayoutSize:selfSize];
        
        
        if (sbv != sbs.lastObject)
        {
            pos += subviewSpace;
            
            if (subviewSpace != 0)
            {
                pos += addSpace;
                
                if (isWeightShrinkSpace)
                {
                    pos += weightShrinkSpaceTotalWidth * subviewSpace / fixedSpaceWidth;
                }
            }
        }
        
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width ];
        
        
        //如果高度是浮动的则需要调整高度。
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]] && sbvsc.heightSizeInner.dimeRelaVal.view != self)
        {
            rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        }
        
        rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        
        //计算最高的高度。
        if (lsc.wrapContentHeight)
        {
            if (sbvsc.heightSizeInner.dimeRelaVal.view != self && (sbvsc.topPosInner.posVal == nil || sbvsc.bottomPosInner.posVal == nil))
            {
                maxSubviewHeight = [self gtuiCalcSelfSize:maxSubviewHeight subviewSize:rect.size.height headPos:sbvsc.topPosInner centerPos:sbvsc.centerYPosInner tailPos:sbvsc.bottomPosInner];
            }
        }
        else
        {
            [self gtuiCalcSubviewTopBottomRect:vertGravity
                                    selfSize:selfSize
                                      rect_p:&rect
                                         sbv:sbv
                               paddingBottom:paddingBottom
                                  paddingTop:paddingTop
                                 baselinePos:baselinePos
                                       sbvsc:sbvsc
                                         lsc:lsc];
            
            
            //如果垂直方向的对齐方式是基线对齐，那么就以第一个具有基线的视图作为标准位置。
            if (vertGravity == GTUIGravityVertBaseline && baselinePos == CGFLOAT_MAX && self.baselineBaseView == sbv)
            {
                UIFont *sbvFont = [sbv valueForKey:@"font"];
                //这里要求baselineBaseView必须要具有font属性。
                //得到基线位置。
                baselinePos = rect.origin.y + (rect.size.height - sbvFont.lineHeight) / 2.0 + sbvFont.ascender;
                
            }
            
            
        }
        
        sbvgtuiFrame.frame = rect;
    }
    
    pos +=  paddingTrailing;
    
    if (lsc.wrapContentWidth)
    {
        selfSize.width = pos;
    }
    
    //调整所有子视图的高度。
    if (lsc.wrapContentHeight)
    {
        selfSize.height = maxSubviewHeight + paddingVert;
        baselinePos = CGFLOAT_MAX;
        
        for (UIView *sbv in sbs)
        {
            GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
            UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
            
            CGRect rect = sbvgtuiFrame.frame;
            
            [self gtuiCalcSubviewTopBottomRect:vertGravity
                                    selfSize:selfSize
                                      rect_p:&rect
                                         sbv:sbv
                               paddingBottom:paddingBottom
                                  paddingTop:paddingTop
                                 baselinePos:baselinePos
                                       sbvsc:sbvsc
                                         lsc:lsc];
            
            sbvgtuiFrame.frame = rect;
            
            //如果垂直方向的对齐方式是基线对齐，那么就以第一个具有基线的视图作为标准位置。
            if (vertGravity == GTUIGravityVertBaseline && baselinePos == CGFLOAT_MAX && self.baselineBaseView == sbv)
            {
                UIFont *sbvFont = [sbv valueForKey:@"font"];
                //这里要求baselineBaseView必须要具有font属性。
                //得到基线位置。
                baselinePos = rect.origin.y + (rect.size.height - sbvFont.lineHeight) / 2.0 + sbvFont.ascender;
                
            }
            
            
        }
        
    }
    
    
    return selfSize;
}



-(CGSize)gtuiLayoutSubviewsForVertGravity:(CGSize)selfSize sbs:(NSArray*)sbs lsc:(GTUILinearLayout*)lsc
{
    
    CGFloat paddingTop = lsc.gtuiLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtuiLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtuiLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;
    CGFloat subviewSpace = lsc.subviewVSpace;
    GTUIGravity vertGravity = lsc.gravity & GTUIGravityHorzMask;
    GTUIGravity horzGravity = [self gtuiConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTUIGravityVertMask];
    
    CGFloat totalHeight = 0;
    if (sbs.count > 1)
        totalHeight += (sbs.count - 1) * subviewSpace;
    
    selfSize = [self gtuiCalcMaxWrapWidth:sbs selfSize:selfSize paddingHorz:paddingHorz lsc:lsc];
    
    CGFloat floatingHeight = selfSize.height - paddingVert - totalHeight;
    if (_gtuiCGFloatLessOrEqual(floatingHeight, 0))
        floatingHeight = 0;
    
    //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
    NSMutableSet *noWrapsbsSet = [NSMutableSet new];
    for (UIView *sbv in sbs)
    {
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        BOOL canAddToNoWrapSbs = YES;
        CGRect rect = sbvgtuiFrame.frame;
        
        [self gtuiCalcLeadingTrailingRect:horzGravity
                               selfSize:selfSize
                                 rect_p:&rect
                                    sbv:sbv
                        paddingTrailing:paddingTrailing
                         paddingLeading:paddingLeading
                                  sbvsc:sbvsc
                                    lsc:lsc];
        
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner)
        {
            rect.size.height = [sbvsc.heightSizeInner measureWith:selfSize.height - paddingVert];
            canAddToNoWrapSbs = NO;
        }
        
        
        //高度等于宽度的情况。
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
        {
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
        }
        
        //如果子视图需要调整高度则调整高度
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]] && sbvsc.weight == 0)
        {
            rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
            canAddToNoWrapSbs = NO;
        }
        
        rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //如果子视图的最小高度就是自身则也不进行扩展。
        if (sbvsc.heightSizeInner.lBoundValInner.dimeSelfVal != nil)
        {
            canAddToNoWrapSbs = NO;
        }
        
        
        totalHeight += [self gtuiValidMargin:sbvsc.topPosInner sbv:sbv calcPos:[sbvsc.topPosInner realPosIn:floatingHeight] selfLayoutSize:selfSize];
        
        totalHeight += rect.size.height;
        
        totalHeight += [self gtuiValidMargin:sbvsc.bottomPosInner sbv:sbv calcPos:[sbvsc.bottomPosInner realPosIn:floatingHeight] selfLayoutSize:selfSize];
        
        sbvgtuiFrame.frame = rect;
        
        //如果子布局视图是wrap属性则不进行扩展。
        if (vertGravity == GTUIGravityVertFill && [sbv isKindOfClass:[GTUIBaseLayout class]])
        {
            if (sbvsc.wrapContentHeight)
            {
                canAddToNoWrapSbs = NO;
            }
        }
        
        if (canAddToNoWrapSbs)
            [noWrapsbsSet addObject:sbv];
        
    }
    
    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;  //位置偏移
    CGFloat between = 0; //间距扩充
    CGFloat fill = 0;    //尺寸扩充
    if (vertGravity == GTUIGravityVertTop)
    {
        pos = paddingTop;
    }
    else if (vertGravity == GTUIGravityVertCenter)
    {
        pos = (selfSize.height - totalHeight - paddingVert)/2.0 + paddingTop;
    }
    else if (vertGravity == GTUIGravityVertWindow_Center)
    {
        if (self.window != nil)
        {
            pos = (CGRectGetHeight(self.window.bounds) - totalHeight)/2.0;
            
            CGPoint pt = CGPointMake(0, pos);
            pos = [self.window convertPoint:pt toView:self].y;
            
            
        }
    }
    else if (vertGravity == GTUIGravityVertBottom)
    {
        pos = selfSize.height - totalHeight - paddingBottom;
    }
    else if (vertGravity == GTUIGravityVertBetween)
    {
        pos = paddingTop;
        
        if (sbs.count > 1)
            between = (selfSize.height - totalHeight - paddingVert) / (sbs.count - 1);
    }
    else if (vertGravity == GTUIGravityVertFill)
    {
        pos = paddingTop;
        if (noWrapsbsSet.count > 0)
            fill = (selfSize.height - totalHeight - paddingVert) / noWrapsbsSet.count;
    }
    else
    {
        pos = paddingTop;
    }
    
    
    
    for (UIView *sbv in sbs)
    {
        
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        pos += [self gtuiValidMargin:sbvsc.topPosInner sbv:sbv calcPos:[sbvsc.topPosInner realPosIn:floatingHeight] selfLayoutSize:selfSize];
        
        sbvgtuiFrame.top = pos;
        
        //加上扩充的宽度。
        if (fill != 0 && [noWrapsbsSet containsObject:sbv])
            sbvgtuiFrame.height += fill;
        
        pos +=  sbvgtuiFrame.height;
        
        
        pos += [self gtuiValidMargin:sbvsc.bottomPosInner sbv:sbv calcPos:[sbvsc.bottomPosInner realPosIn:floatingHeight] selfLayoutSize:selfSize];
        
        if (sbv != sbs.lastObject)
            pos += subviewSpace;
        
        pos += between;  //只有mgvert为between才加这个间距拉伸。
    }
    
    return selfSize;
    
}



-(CGSize)gtuiLayoutSubviewsForHorzGravity:(CGSize)selfSize sbs:(NSArray*)sbs lsc:(GTUILinearLayout*)lsc
{
    CGFloat paddingTop = lsc.gtuiLayoutTopPadding;
    CGFloat paddingBottom = lsc.gtuiLayoutBottomPadding;
    CGFloat paddingLeading = lsc.gtuiLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;
    CGFloat subviewSpace = lsc.subviewHSpace;
    GTUIGravity vertGravity = lsc.gravity & GTUIGravityHorzMask;
    GTUIGravity horzGravity = [self gtuiConvertLeftRightGravityToLeadingTrailing:lsc.gravity & GTUIGravityVertMask];
    
    
    CGFloat totalWidth = 0;
    if (sbs.count > 1)
        totalWidth += (sbs.count - 1) * subviewSpace;
    
    
    CGFloat floatingWidth = 0;
    CGFloat maxSubviewHeight = 0;
    
    floatingWidth = selfSize.width - paddingHorz - totalWidth;
    if (_gtuiCGFloatLessOrEqual(floatingWidth, 0))
        floatingWidth = 0;
    
    //计算出固定的高度
    NSMutableSet *noWrapsbsSet = [NSMutableSet new];
    for (UIView *sbv in sbs)
    {
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        BOOL canAddToNoWrapSbs = YES;
        CGRect rect = sbvgtuiFrame.frame;
        
        if (sbvsc.widthSizeInner.dimeNumVal != nil)
            rect.size.width = sbvsc.widthSizeInner.measure;
        
        if (sbvsc.heightSizeInner.dimeNumVal != nil)
            rect.size.height = sbvsc.heightSizeInner.measure;
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == lsc.widthSizeInner)
        {
            rect.size.width= [sbvsc.widthSizeInner measureWith:selfSize.width - paddingHorz];
            canAddToNoWrapSbs = NO;
        }
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner)
            rect.size.height= [sbvsc.heightSizeInner measureWith:selfSize.height - paddingVert];
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
        
        rect.size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        //如果最小宽度不能被缩小则不加入。
        if (sbvsc.widthSizeInner.lBoundValInner.dimeSelfVal != nil)
        {
            canAddToNoWrapSbs = NO;
        }
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
        
        //如果高度是浮动的则需要调整高度。
        if (sbvsc.wrapContentHeight && ![sbv isKindOfClass:[GTUIBaseLayout class]] && sbvsc.heightSizeInner.dimeRelaVal.view != self)
        {
            rect.size.height = [self gtuiHeightFromFlexedHeightView:sbv sbvsc:sbvsc inWidth:rect.size.width];
        }
        
        rect.size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        //计算以子视图为大小的情况
        if (lsc.wrapContentHeight && sbvsc.heightSizeInner.dimeRelaVal.view != self && (sbvsc.topPosInner.posVal == nil || sbvsc.bottomPosInner.posVal == nil))
        {
            maxSubviewHeight = [self gtuiCalcSelfSize:maxSubviewHeight subviewSize:rect.size.height headPos:sbvsc.topPosInner centerPos:sbvsc.centerYPosInner tailPos:sbvsc.bottomPosInner];
        }
        
        
        totalWidth += [self gtuiValidMargin:sbvsc.leadingPosInner sbv:sbv calcPos:[sbvsc.leadingPosInner realPosIn:floatingWidth] selfLayoutSize:selfSize];
        
        totalWidth += rect.size.width;
        
        
        totalWidth += [self gtuiValidMargin:sbvsc.trailingPosInner sbv:sbv calcPos:[sbvsc.trailingPosInner realPosIn:floatingWidth] selfLayoutSize:selfSize];
        
        
        sbvgtuiFrame.frame = rect;
        
        //如果子视图是包裹属性则也不加入。
        if (horzGravity == GTUIGravityHorzFill && [sbv isKindOfClass:[GTUIBaseLayout class]])
        {
            if (sbvsc.wrapContentWidth)
            {
                canAddToNoWrapSbs = NO;
            }
        }
        
        if (canAddToNoWrapSbs)
            [noWrapsbsSet addObject:sbv];
        
    }
    
    
    //调整自己的高度。
    if (lsc.wrapContentHeight)
    {
        selfSize.height = maxSubviewHeight + paddingVert;
    }
    
    //根据对齐的方位来定位子视图的布局对齐
    CGFloat pos = 0;
    CGFloat between = 0;
    CGFloat fill = 0;
    
    if (horzGravity == GTUIGravityHorzLeading)
    {
        pos = paddingLeading;
    }
    else if (horzGravity == GTUIGravityHorzCenter)
    {
        pos = (selfSize.width - totalWidth - paddingHorz)/2.0;
        pos += paddingLeading;
    }
    else if (horzGravity == GTUIGravityHorzWindowCenter)
    {
        if (self.window != nil)
        {
            pos = (CGRectGetWidth(self.window.bounds) - totalWidth)/2.0;
            
            CGPoint pt = CGPointMake(pos, 0);
            pos = [self.window convertPoint:pt toView:self].x;
            
            //特殊处理窗口水平居中的场景。
            if ([GTUIBaseLayout isRTL])
            {
                pos += (selfSize.width - CGRectGetWidth(self.window.bounds));
            }
            
        }
    }
    else if (horzGravity == GTUIGravityHorzTrailing)
    {
        pos = selfSize.width - totalWidth - paddingTrailing;
    }
    else if (horzGravity == GTUIGravityHorzBetween)
    {
        pos = paddingLeading;
        
        if (sbs.count > 1)
            between = (selfSize.width - totalWidth - paddingHorz) / (sbs.count - 1);
    }
    else if (horzGravity == GTUIGravityHorzFill)
    {
        pos = paddingLeading;
        if (noWrapsbsSet.count > 0)
            fill = (selfSize.width - totalWidth - paddingHorz) / noWrapsbsSet.count;
    }
    else
    {
        pos = paddingLeading;
    }
    
    CGFloat baselinePos = CGFLOAT_MAX;  //保存基线的值。
    for (UIView *sbv in sbs)
    {
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
        
        pos += [self gtuiValidMargin:sbvsc.leadingPosInner sbv:sbv calcPos:[sbvsc.leadingPosInner realPosIn:floatingWidth] selfLayoutSize:selfSize];
        
        
        CGRect rect = sbvgtuiFrame.frame;
        
        rect.origin.x = pos;
        
        [self gtuiCalcSubviewTopBottomRect:vertGravity selfSize:selfSize rect_p:&rect sbv:sbv paddingBottom:paddingBottom paddingTop:paddingTop baselinePos:baselinePos sbvsc:sbvsc lsc:lsc];
        
        if (fill != 0 &&  [noWrapsbsSet containsObject:sbv])
            rect.size.width += fill;
        
        
        pos += rect.size.width;
        
        
        pos += [self gtuiValidMargin:sbvsc.trailingPosInner sbv:sbv calcPos:[sbvsc.trailingPosInner realPosIn:floatingWidth] selfLayoutSize:selfSize];
        
        sbvgtuiFrame.frame = rect;
        
        
        if (sbv != sbs.lastObject)
            pos += subviewSpace;
        
        pos += between;  //只有mghorz为between才加这个间距拉伸。
        
        //如果垂直方向的对齐方式是基线对齐，那么就以第一个具有基线的视图作为标准位置。
        if (vertGravity == GTUIGravityVertBaseline && baselinePos == CGFLOAT_MAX && self.baselineBaseView == sbv)
        {
            UIFont *sbvFont = [sbv valueForKey:@"font"];
            //这里要求baselineBaseView必须要具有font属性。
            //得到基线位置。
            baselinePos = rect.origin.y + (rect.size.height - sbvFont.lineHeight) / 2.0 + sbvFont.ascender;
            
        }
    }
    
    return selfSize;
}



- (void)gtuiCalcLeadingTrailingRect:(GTUIGravity)horzGravity selfSize:(CGSize)selfSize rect_p:(CGRect *)rect_p sbv:(UIView *)sbv paddingTrailing:(CGFloat)paddingTrailing paddingLeading:(CGFloat)paddingLeading sbvsc:(UIView *)sbvsc lsc:(GTUILinearLayout*)lsc
{
    if (sbvsc.widthSizeInner.dimeNumVal != nil)
        rect_p->size.width = sbvsc.widthSizeInner.measure;
    
    //调整子视图的宽度，如果子视图为matchParent的话
    if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == lsc.widthSizeInner)
        rect_p->size.width = [sbvsc.widthSizeInner measureWith:selfSize.width - paddingLeading - paddingTrailing];
    
    if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
        rect_p->size.width = selfSize.width - paddingLeading - paddingTrailing - sbvsc.leadingPosInner.absVal - sbvsc.trailingPosInner.absVal;
    
    
    rect_p->size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect_p->size.width sbvSize:rect_p->size selfLayoutSize:selfSize];
    
    
    [self gtuiCalcHorzGravity:[self gtuiGetSubviewHorzGravity:sbv sbvsc:sbvsc horzGravity:horzGravity] sbv:sbv sbvsc:sbvsc paddingLeading:paddingLeading paddingTrailing:paddingTrailing selfSize:selfSize pRect:rect_p];
}

- (void)gtuiCalcSubviewTopBottomRect:(GTUIGravity)vertGravity selfSize:(CGSize)selfSize rect_p:(CGRect *)rect_p sbv:(UIView *)sbv paddingBottom:(CGFloat)paddingBottom paddingTop:(CGFloat)paddingTop baselinePos:(CGFloat)baselinePos sbvsc:(UIView *)sbvsc lsc:(GTUILinearLayout*)lsc
{
    //计算高度
    if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == lsc.heightSizeInner)
    {
        rect_p->size.height = [sbvsc.heightSizeInner measureWith:selfSize.height - paddingTop - paddingBottom];
    }
    
    
    if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
        rect_p->size.height = selfSize.height - paddingTop - paddingBottom - sbvsc.topPosInner.absVal - sbvsc.bottomPosInner.absVal;
    
    
    rect_p->size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect_p->size.height sbvSize:rect_p->size selfLayoutSize:selfSize];
    
    [self gtuiCalcVertGravity:[self gtuiGetSubviewVertGravity:sbv sbvsc:sbvsc vertGravity:vertGravity] sbv:sbv sbvsc:sbvsc paddingTop:paddingTop paddingBottom:paddingBottom  baselinePos:baselinePos selfSize:selfSize pRect:rect_p];
}

-(CGFloat)gtuiCalcSelfSize:(CGFloat)selfSize subviewSize:(CGFloat)subviewSize headPos:(GTUILayoutPosition*)headPos centerPos:(GTUILayoutPosition*)centerPos tailPos:(GTUILayoutPosition*)tailPos
{
    CGFloat totalWeight = 0;
    CGFloat tempSize = subviewSize;
    CGFloat hm = headPos.posNumVal.doubleValue;
    CGFloat cm = centerPos.posNumVal.doubleValue;
    CGFloat tm = tailPos.posNumVal.doubleValue;
    
    //这里是求父视图的最大尺寸,因此如果使用了相对边距的话，最大最小要参与计算。
    if (![self gtuiIsRelativePos:hm])
        tempSize += hm;
    else
        totalWeight += hm;
    
    tempSize += headPos.offsetVal;
    
    
    if (![self gtuiIsRelativePos:cm])
        tempSize += cm;
    else
        totalWeight += cm;
    
    tempSize += centerPos.offsetVal;
    
    
    if (![self gtuiIsRelativePos:tm])
        tempSize += tm;
    else
        totalWeight += tm;
    
    tempSize += tailPos.offsetVal;
    
    //如果3个比重之和小于等于1则表示按比重分配宽度。
    if (_gtuiCGFloatLessOrEqual(1, totalWeight))
        tempSize = 0;
    else
        tempSize /=(1 - totalWeight);
    
    
    CGFloat leadingMargin = [self gtuiValidMargin:headPos sbv:headPos.view calcPos:[headPos realPosIn:tempSize] selfLayoutSize:CGSizeZero];
    
    CGFloat centerMargin = [self gtuiValidMargin:centerPos sbv:centerPos.view calcPos:[centerPos realPosIn:tempSize] selfLayoutSize:CGSizeZero];
    
    CGFloat trailingMargin = [self gtuiValidMargin:tailPos sbv:tailPos.view calcPos:[tailPos realPosIn:tempSize] selfLayoutSize:CGSizeZero];
    
    tempSize = subviewSize + leadingMargin + centerMargin + trailingMargin;
    if (_gtuiCGFloatGreat(tempSize,selfSize))
    {
        selfSize = tempSize;
    }
    
    return selfSize;
    
}

-(void)gtuiEqualizeSubviewsForVert:(BOOL)centered withSpace:(CGFloat)margin
{
    
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    
    CGFloat scale;
    CGFloat scale2;
    NSArray *sbs = [self gtuiGetLayoutSubviews];
    if (margin == CGFLOAT_MAX)
    {
        CGFloat fragments = centered ? sbs.count * 2 + 1 : sbs.count * 2 - 1;
        scale = 1 / fragments;
        scale2 = scale;
        
    }
    else
    {
        scale = 1.0;
        scale2 = margin;
    }
    
    
    for (UIView *sbv in sbs)
    {
        UIView *sbvsc = sbv.gtuiCurrentSizeClass;
        
        [sbvsc.bottomPos __equalTo:@0];
        [sbvsc.topPos __equalTo:@(scale2)];
        sbvsc.weight = scale;
        
        if (sbv == sbs.firstObject && !centered)
            [sbvsc.topPos __equalTo:@0];
        
        if (sbv == sbs.lastObject && centered)
            [sbvsc.bottomPos __equalTo:@(scale2)];
    }
    
}

-(void)gtuiEqualizeSubviewsForHorz:(BOOL)centered withSpace:(CGFloat)space
{
    
    
    NSArray *sbs = [self gtuiGetLayoutSubviews];
    //如果居中和不居中则拆分出来的片段是不一样的。
    CGFloat scale;
    CGFloat scale2;
    
    if (space == CGFLOAT_MAX)
    {
        CGFloat fragments = centered ? sbs.count * 2 + 1 : sbs.count * 2 - 1;
        scale = 1 / fragments;
        scale2 = scale;
        
    }
    else
    {
        scale = 1.0;
        scale2 = space;
    }
    
    for (UIView *sbv in sbs)
    {
        UIView *sbvsc = sbv.gtuiCurrentSizeClass;
        
        [sbvsc.trailingPos __equalTo:@0];
        [sbvsc.leadingPos __equalTo:@(scale2)];
        sbvsc.weight = scale;
        
        if (sbv == sbs.firstObject && !centered)
            [sbvsc.leadingPos __equalTo:@0];
        
        if (sbv == sbs.lastObject && centered)
            [sbvsc.trailingPos __equalTo:@(scale2)];
    }
    
}


-(void)gtuiEqualizeSubviewsSpaceForVert:(BOOL)centered
{
    
    
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    NSArray *sbs = [self gtuiGetLayoutSubviews];
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (UIView *sbv in sbs)
    {
        UIView *sbvsc = sbv.gtuiCurrentSizeClass;
        
        [sbvsc.topPos __equalTo:@(scale)];
        
        if (sbv == sbs.firstObject && !centered)
            [sbvsc.topPos __equalTo:@0];
        
        if (sbv == sbs.lastObject)
            [sbvsc.bottomPos __equalTo: centered? @(scale) : @0];
    }
    
    
}

-(void)gtuiEqualizeSubviewsSpaceForHorz:(BOOL)centered
{
    
    //如果居中和不居中则拆分出来的片段是不一样的。
    NSArray *sbs = [self gtuiGetLayoutSubviews];
    CGFloat fragments = centered ? sbs.count + 1 : sbs.count - 1;
    CGFloat scale = 1 / fragments;
    
    for (UIView *sbv in sbs)
    {
        UIView *sbvsc = sbv.gtuiCurrentSizeClass;
        
        [sbvsc.leadingPos __equalTo:@(scale)];
        
        if (sbv == sbs.firstObject && !centered)
            [sbvsc.leadingPos __equalTo:@0];
        
        if (sbv == sbs.lastObject)
            [sbvsc.trailingPos __equalTo:centered? @(scale) : @0];
    }
}





@end
