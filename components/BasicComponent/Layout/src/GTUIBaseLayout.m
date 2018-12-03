//
//  GTUIBaseLayout.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUIBaseLayout.h"
#import "GTUILayout+Private.h"
#import "GTUILayoutDelegate.h"
#import <objc/runtime.h>


const char * const ASSOCIATEDOBJECT_KEY_gtuiLAYOUT_FRAME = "ASSOCIATEDOBJECT_KEY_gtuiLAYOUT_FRAME";

void* _gtuiObserverContextA = (void*)20175281;
void* _gtuiObserverContextB = (void*)20175282;
void* _gtuiObserverContextC = (void*)20175283;


@implementation UIView(GTUILayout)

-(GTUILayoutPosition*)topPos
{
    return self.gtuiCurrentSizeClass.topPos;
}

-(GTUILayoutPosition*)leadingPos
{
    return self.gtuiCurrentSizeClass.leadingPos;
}



-(GTUILayoutPosition*)bottomPos
{
    return self.gtuiCurrentSizeClass.bottomPos;
}


-(GTUILayoutPosition*)trailingPos
{
    return self.gtuiCurrentSizeClass.trailingPos;
}



-(GTUILayoutPosition*)centerXPos
{
    return self.gtuiCurrentSizeClass.centerXPos;
}


-(GTUILayoutPosition*)centerYPos
{
    return  self.gtuiCurrentSizeClass.centerYPos;
}


-(GTUILayoutPosition*)leftPos
{
    return self.gtuiCurrentSizeClass.leftPos;
}

-(GTUILayoutPosition*)rightPos
{
    return self.gtuiCurrentSizeClass.rightPos;
}

-(GTUILayoutPosition*)baselinePos
{
    return self.gtuiCurrentSizeClass.baselinePos;
}



-(CGFloat)gtui_top
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_top;
}

-(void)setGtui_top:(CGFloat)gtui_top
{
    self.gtuiCurrentSizeClass.gtui_top = gtui_top;
}

-(CGFloat)gtui_leading
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_leading;
}

-(void)setGtui_leading:(CGFloat)gtui_leading
{
    self.gtuiCurrentSizeClass.gtui_leading = gtui_leading;
}


-(CGFloat)gtui_bottom
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_bottom;
}

-(void)setGtui_bottom:(CGFloat)gtui_bottom
{
    self.gtuiCurrentSizeClass.gtui_bottom = gtui_bottom;
}



-(CGFloat)gtui_trailing
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_trailing;
}

-(void)setGtui_trailing:(CGFloat)gtui_trailing
{
    self.gtuiCurrentSizeClass.gtui_trailing = gtui_trailing;
}


-(CGFloat)gtui_centerX
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_centerX;
}

-(void)setGtui_centerX:(CGFloat)gtui_centerX
{
    self.gtuiCurrentSizeClass.gtui_centerX = gtui_centerX;
}

-(CGFloat)gtui_centerY
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_centerY;
}

-(void)setGtui_centerY:(CGFloat)gtui_centerY
{
    self.gtuiCurrentSizeClass.gtui_centerY = gtui_centerY;
}


-(CGPoint)gtui_center
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_center;
}

-(void)setGtui_center:(CGPoint)gtui_center
{
    self.gtuiCurrentSizeClass.gtui_center = gtui_center;
}


-(CGFloat)gtui_left
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_left;
}

-(void)setGtui_left:(CGFloat)gtui_left
{
    self.gtuiCurrentSizeClass.gtui_left = gtui_left;
}

-(CGFloat)gtui_right
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_right;
}

-(void)setGtui_right:(CGFloat)gtui_right
{
    self.gtuiCurrentSizeClass.gtui_right = gtui_right;
}



-(CGFloat)gtui_margin
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_margin;
}

-(void)setGtui_margin:(CGFloat)gtui_margin
{
    self.gtuiCurrentSizeClass.gtui_margin = gtui_margin;
}

-(CGFloat)gtui_horzMargin
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_horzMargin;
}

-(void)setGtui_horzMargin:(CGFloat)gtui_horzMargin
{
    self.gtuiCurrentSizeClass.gtui_horzMargin = gtui_horzMargin;
}


-(CGFloat)gtui_vertMargin
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_vertMargin;
}

-(void)setGtui_vertMargin:(CGFloat)gtui_vertMargin
{
    self.gtuiCurrentSizeClass.gtui_vertMargin = gtui_vertMargin;
}


-(GTUILayoutSize*)widthSize
{
    return self.gtuiCurrentSizeClass.widthSize;
}



-(GTUILayoutSize*)heightSize
{
    return self.gtuiCurrentSizeClass.heightSize;
}


-(CGFloat)gtui_width
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_width;
}


-(void)setGtui_width:(CGFloat)gtui_width
{
    self.gtuiCurrentSizeClass.gtui_width = gtui_width;
}

-(CGFloat)gtui_height
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    return self.gtuiCurrentSizeClass.gtui_height;
}

-(void)setGtui_height:(CGFloat)gtui_height
{
    self.gtuiCurrentSizeClass.gtui_height = gtui_height;
}

-(CGSize)gtui_size
{
#if DEBUG
    NSLog(@"%s 一般只用于设置，而不能用于获取！！", sel_getName(_cmd));
#endif
    
    return self.gtuiCurrentSizeClass.gtui_size;
}

-(void)setGtui_size:(CGSize)gtui_size
{
    self.gtuiCurrentSizeClass.gtui_size = gtui_size;
}


-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    UIView *sc = self.gtuiCurrentSizeClass;
    if (sc.wrapContentHeight != wrapContentHeight)
    {
        sc.wrapContentHeight = wrapContentHeight;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(BOOL)wrapContentHeight
{
    //特殊处理，减少不必要的对象创建
    return self.gtuiCurrentSizeClassInner.wrapContentHeight;
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    UIView *sc = self.gtuiCurrentSizeClass;
    if (sc.wrapContentWidth != wrapContentWidth)
    {
        sc.wrapContentWidth = wrapContentWidth;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
    
}

-(BOOL)wrapContentWidth
{
    //特殊处理，减少不必要的对象创建
    return self.gtuiCurrentSizeClassInner.wrapContentWidth;
}


-(BOOL)wrapContentSize
{
    return self.gtuiCurrentSizeClassInner.wrapContentSize;
}

-(void)setWrapContentSize:(BOOL)wrapContentSize
{
    UIView *sc = self.gtuiCurrentSizeClass;
    if (sc.wrapContentSize != wrapContentSize)
    {
        sc.wrapContentSize = wrapContentSize;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(CGFloat)weight
{
    return self.gtuiCurrentSizeClass.weight;
}

-(void)setWeight:(CGFloat)weight
{
    UIView *sc = self.gtuiCurrentSizeClass;
    if (sc.weight != weight)
    {
        sc.weight = weight;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}



-(BOOL)useFrame
{
    return self.gtuiCurrentSizeClass.useFrame;
}

-(void)setUseFrame:(BOOL)useFrame
{
    UIView *sc = self.gtuiCurrentSizeClass;
    if (sc.useFrame != useFrame)
    {
        sc.useFrame = useFrame;
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }
    
}

-(BOOL)noLayout
{
    return self.gtuiCurrentSizeClass.noLayout;
}

-(void)setNoLayout:(BOOL)noLayout
{
    UIView *sc = self.gtuiCurrentSizeClass;
    if (sc.noLayout != noLayout)
    {
        sc.noLayout = noLayout;
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }
    
}

-(GTUIVisibility)gtui_visibility
{
    return self.gtuiCurrentSizeClass.gtui_visibility;
}

-(void)setGtui_visibility:(GTUIVisibility)gtui_visibility
{
    UIView *sc = self.gtuiCurrentSizeClass;
    if (sc.gtui_visibility != gtui_visibility)
    {
        sc.gtui_visibility = gtui_visibility;
        if (gtui_visibility == GTUIVisibilityVisible)
            self.hidden = NO;
        else
            self.hidden = YES;
        
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }
    
}

-(GTUIGravity)gtui_alignment
{
    return self.gtuiCurrentSizeClass.gtui_alignment;
}

-(void)setGtui_alignment:(GTUIGravity)gtui_alignment
{
    UIView *sc = self.gtuiCurrentSizeClass;
    if (sc.gtui_alignment != gtui_alignment)
    {
        sc.gtui_alignment = gtui_alignment;
        if (self.superview != nil)
            [ self.superview setNeedsLayout];
    }
    
}


-(void (^)(GTUIBaseLayout*, UIView*))viewLayoutCompleteBlock
{
    return self.gtuiCurrentSizeClass.viewLayoutCompleteBlock;
}

-(void)setViewLayoutCompleteBlock:(void (^)(GTUIBaseLayout *, UIView *))viewLayoutCompleteBlock
{
    self.gtuiCurrentSizeClass.viewLayoutCompleteBlock = viewLayoutCompleteBlock;
}





-(CGRect)estimatedRect
{
    CGRect rect = self.gtuiFrame.frame;
    if (rect.size.width == CGFLOAT_MAX || rect.size.height == CGFLOAT_MAX)
        return self.frame;
    return rect;
}



-(void)resetGTUILayoutSetting
{
    [self resetGTUILayoutSettingInSizeClass:GTUISizeClasswAny | GTUISizeClasshAny];
}

-(void)resetGTUILayoutSettingInSizeClass:(GTUISizeClass)sizeClass
{
    [self.gtuiFrame.sizeClasses removeObjectForKey:@(sizeClass)];
}






-(instancetype)fetchLayoutSizeClass:(GTUISizeClass)sizeClass
{
    return [self fetchLayoutSizeClass:sizeClass copyFrom:0xFF];
}

-(instancetype)fetchLayoutSizeClass:(GTUISizeClass)sizeClass copyFrom:(GTUISizeClass)srcSizeClass
{
    GTUIFrame *gtuiFrame = self.gtuiFrame;
    if (gtuiFrame.sizeClasses == nil)
        gtuiFrame.sizeClasses = [NSMutableDictionary new];
    
    GTUIViewSizeClass *GTUILayoutSizeClass = (GTUIViewSizeClass*)[gtuiFrame.sizeClasses objectForKey:@(sizeClass)];
    if (GTUILayoutSizeClass == nil)
    {
        GTUIViewSizeClass *srcLayoutSizeClass = (GTUIViewSizeClass*)[gtuiFrame.sizeClasses objectForKey:@(srcSizeClass)];
        if (srcLayoutSizeClass == nil)
            GTUILayoutSizeClass = [self createSizeClassInstance];
        else
            GTUILayoutSizeClass = [srcLayoutSizeClass copy];
        GTUILayoutSizeClass.view = self;
        [gtuiFrame.sizeClasses setObject:GTUILayoutSizeClass forKey:@(sizeClass)];
    }
    
    return (UIView*)GTUILayoutSizeClass;
    
}



@end


@implementation UIView(GTUILayoutExtInner)


-(instancetype)gtuiDefaultSizeClass
{
    return [self fetchLayoutSizeClass:GTUISizeClasswAny | GTUISizeClasshAny];
}


-(instancetype)gtuiCurrentSizeClass
{
    GTUIFrame *gtuiFrame = self.gtuiFrame;  //减少多次访问，增加性能。
    if (gtuiFrame.sizeClass == nil)
        gtuiFrame.sizeClass = [self gtuiDefaultSizeClass];
    
    return gtuiFrame.sizeClass;
}

-(instancetype)gtuiCurrentSizeClassInner
{
    //如果没有则不会建立，为了优化减少不必要的建立。
    GTUIFrame *obj = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_gtuiLAYOUT_FRAME);
    return obj.sizeClass;
}

-(instancetype)gtuiCurrentSizeClassFrom:(GTUIFrame*)gtuiFrame
{
    if (gtuiFrame.sizeClass == nil)
        gtuiFrame.sizeClass = [self gtuiDefaultSizeClass];
    
    return gtuiFrame.sizeClass;
}




-(instancetype)gtuiBestSizeClass:(GTUISizeClass)sizeClass
{
    
    GTUISizeClass wsc = sizeClass & 0x03;
    GTUISizeClass hsc = sizeClass & 0x0C;
    GTUISizeClass ori = sizeClass & 0xC0;
    
    GTUIFrame *gtuiFrame = self.gtuiFrame;
    
    if (gtuiFrame.sizeClasses == nil)
        gtuiFrame.sizeClasses = [NSMutableDictionary new];
    
    
    GTUISizeClass searchSizeClass;
    GTUIViewSizeClass *gtuiClass = nil;
    if (gtuiFrame.multiple)
    {
        //first search the most exact SizeClass
        searchSizeClass = wsc | hsc | ori;
        gtuiClass = (GTUIViewSizeClass*)[gtuiFrame.sizeClasses objectForKey:@(searchSizeClass)];
        if (gtuiClass != nil)
            return (UIView*)gtuiClass;
        
        
        searchSizeClass = wsc | hsc;
        if (searchSizeClass != sizeClass)
        {
            GTUIViewSizeClass *gtuiClass = (GTUIViewSizeClass*)[gtuiFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtuiClass != nil)
                return (UIView*)gtuiClass;
        }
        
        
        searchSizeClass = GTUISizeClasswAny | hsc | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            gtuiClass = (GTUIViewSizeClass*)[gtuiFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtuiClass != nil)
                return (UIView*)gtuiClass;
            
        }
        
        searchSizeClass = GTUISizeClasswAny | hsc;
        if (searchSizeClass != sizeClass)
        {
            gtuiClass = (GTUIViewSizeClass*)[gtuiFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtuiClass != nil)
                return (UIView*)gtuiClass;
        }
        
        searchSizeClass = wsc | GTUISizeClasshAny | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            gtuiClass = (GTUIViewSizeClass*)[gtuiFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtuiClass != nil)
                return (UIView*)gtuiClass;
        }
        
        searchSizeClass = wsc | GTUISizeClasshAny;
        if (searchSizeClass != sizeClass)
        {
            gtuiClass = (GTUIViewSizeClass*)[gtuiFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtuiClass != nil)
                return (UIView*)gtuiClass;
        }
        
        searchSizeClass = GTUISizeClasswAny | GTUISizeClasshAny | ori;
        if (ori != 0 && searchSizeClass != sizeClass)
        {
            gtuiClass = (GTUIViewSizeClass*)[gtuiFrame.sizeClasses objectForKey:@(searchSizeClass)];
            if (gtuiClass != nil)
                return (UIView*)gtuiClass;
        }
        
    }
    
    searchSizeClass = GTUISizeClasswAny | GTUISizeClasshAny;
    gtuiClass = (GTUIViewSizeClass*)[gtuiFrame.sizeClasses objectForKey:@(searchSizeClass)];
    if (gtuiClass == nil)
    {
        gtuiClass = [self createSizeClassInstance];
        gtuiClass.view = self;
        [gtuiFrame.sizeClasses setObject:gtuiClass forKey:@(searchSizeClass)];
    }
    
    return (UIView*)gtuiClass;
    
    
}


-(GTUIFrame*)gtuiFrame
{
    
    GTUIFrame *obj = objc_getAssociatedObject(self, ASSOCIATEDOBJECT_KEY_gtuiLAYOUT_FRAME);
    if (obj == nil)
    {
        obj = [GTUIFrame new];
        objc_setAssociatedObject(self, ASSOCIATEDOBJECT_KEY_gtuiLAYOUT_FRAME, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    return obj;
}

-(id)createSizeClassInstance
{
    return [GTUIViewSizeClass new];
}


-(GTUILayoutPosition*)topPosInner
{
    return self.gtuiCurrentSizeClass.topPosInner;
}

-(GTUILayoutPosition*)leadingPosInner
{
    return self.gtuiCurrentSizeClass.leadingPosInner;
}

-(GTUILayoutPosition*)bottomPosInner
{
    return self.gtuiCurrentSizeClass.bottomPosInner;
}

-(GTUILayoutPosition*)trailingPosInner
{
    return self.gtuiCurrentSizeClass.trailingPosInner;
}



-(GTUILayoutPosition*)centerXPosInner
{
    return self.gtuiCurrentSizeClass.centerXPosInner;
}


-(GTUILayoutPosition*)centerYPosInner
{
    return self.gtuiCurrentSizeClass.centerYPosInner;
}


-(GTUILayoutPosition*)leftPosInner
{
    return self.gtuiCurrentSizeClass.leftPosInner;
}

-(GTUILayoutPosition*)rightPosInner
{
    return self.gtuiCurrentSizeClass.rightPosInner;
}


-(GTUILayoutPosition*)baselinePosInner
{
    return self.gtuiCurrentSizeClass.baselinePosInner;
}


-(GTUILayoutSize*)widthSizeInner
{
    return self.gtuiCurrentSizeClass.widthSizeInner;
}


-(GTUILayoutSize*)heightSizeInner
{
    return self.gtuiCurrentSizeClass.heightSizeInner;
}

@end



@implementation GTUIBaseLayout
{
    GTUILayoutTouchEventDelegate *_touchEventDelegate;
    
    GTUIBorderlineLayerDelegate *_borderlineLayerDelegate;
    
    BOOL _isAddSuperviewKVO;
    
    int _lastScreenOrientation; //为0为初始状态，为1为竖屏，为2为横屏。内部使用。
    
    BOOL _useCacheRects;
}


-(void)dealloc
{
    //如果您在使用时出现了KVO的异常崩溃，原因是您将这个视图被多次加入为子视图，请检查您的代码，是否这个视图被多次加入！！
    _endLayoutBlock = nil;
    _beginLayoutBlock = nil;
    _rotationToDeviceOrientationBlock = nil;
}

#pragma  mark -- Public Methods


+(BOOL)isRTL
{
    return [GTUIViewSizeClass isRTL];
}

+(void)setIsRTL:(BOOL)isRTL
{
    [GTUIViewSizeClass setIsRTL:isRTL];
}



-(CGFloat)topPadding
{
    return self.gtuiCurrentSizeClass.topPadding;
}

-(void)setTopPadding:(CGFloat)topPadding
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.topPadding != topPadding)
    {
        lsc.topPadding = topPadding;
        [self setNeedsLayout];
    }
}

-(CGFloat)leadingPadding
{
    return self.gtuiCurrentSizeClass.leadingPadding;
}

-(void)setLeadingPadding:(CGFloat)leadingPadding
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.leadingPadding != leadingPadding)
    {
        lsc.leadingPadding = leadingPadding;
        [self setNeedsLayout];
    }
}


-(CGFloat)bottomPadding
{
    return self.gtuiCurrentSizeClass.bottomPadding;
}

-(void)setBottomPadding:(CGFloat)bottomPadding
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.bottomPadding != bottomPadding)
    {
        lsc.bottomPadding = bottomPadding;
        [self setNeedsLayout];
    }
}


-(CGFloat)trailingPadding
{
    return self.gtuiCurrentSizeClass.trailingPadding;
}

-(void)setTrailingPadding:(CGFloat)trailingPadding
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.trailingPadding != trailingPadding)
    {
        lsc.trailingPadding = trailingPadding;
        [self setNeedsLayout];
    }
}


-(UIEdgeInsets)padding
{
    return self.gtuiCurrentSizeClass.padding;
}

-(void)setPadding:(UIEdgeInsets)padding
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (!UIEdgeInsetsEqualToEdgeInsets(lsc.padding, padding))
    {
        lsc.padding = padding;
        [self setNeedsLayout];
    }
}


-(CGFloat)leftPadding
{
    return self.gtuiCurrentSizeClass.leftPadding;
}

-(void)setLeftPadding:(CGFloat)leftPadding
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.leftPadding != leftPadding)
    {
        lsc.leftPadding = leftPadding;
        [self setNeedsLayout];
    }
}


-(CGFloat)rightPadding
{
    return self.gtuiCurrentSizeClass.rightPadding;
}

-(void)setRightPadding:(CGFloat)rightPadding
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.rightPadding != rightPadding)
    {
        lsc.rightPadding = rightPadding;
        [self setNeedsLayout];
    }
}

-(BOOL)zeroPadding
{
    return self.gtuiCurrentSizeClass.zeroPadding;
}

-(void)setZeroPadding:(BOOL)zeroPadding
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.zeroPadding != zeroPadding)
    {
        lsc.zeroPadding = zeroPadding;
        [self setNeedsLayout];
    }
}

-(UIRectEdge)insetsPaddingFromSafeArea
{
    return self.gtuiCurrentSizeClass.insetsPaddingFromSafeArea;
}

-(void)setInsetsPaddingFromSafeArea:(UIRectEdge)insetsPaddingFromSafeArea
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.insetsPaddingFromSafeArea != insetsPaddingFromSafeArea)
    {
        lsc.insetsPaddingFromSafeArea = insetsPaddingFromSafeArea;
        [self setNeedsLayout];
    }
}

-(BOOL)insetLandscapeFringePadding
{
    return self.gtuiCurrentSizeClass.insetLandscapeFringePadding;
}

-(void)setInsetLandscapeFringePadding:(BOOL)insetLandscapeFringePadding
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.insetLandscapeFringePadding != insetLandscapeFringePadding)
    {
        lsc.insetLandscapeFringePadding = insetLandscapeFringePadding;
        [self setNeedsLayout];
    }
}

-(void)setSubviewHSpace:(CGFloat)subviewHSpace
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    
    if (lsc.subviewHSpace != subviewHSpace)
    {
        lsc.subviewHSpace = subviewHSpace;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewHSpace
{
    return self.gtuiCurrentSizeClass.subviewHSpace;
}

-(void)setSubviewVSpace:(CGFloat)subviewVSpace
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.subviewVSpace != subviewVSpace)
    {
        lsc.subviewVSpace = subviewVSpace;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewVSpace
{
    return self.gtuiCurrentSizeClass.subviewVSpace;
}

-(void)setSubviewSpace:(CGFloat)subviewSpace
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    
    if (lsc.subviewSpace != subviewSpace)
    {
        lsc.subviewSpace = subviewSpace;
        [self setNeedsLayout];
    }
}

-(CGFloat)subviewSpace
{
    return self.gtuiCurrentSizeClass.subviewSpace;
}

-(void)setGravity:(GTUIGravity)gravity
{
    
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.gravity != gravity)
    {
        lsc.gravity = gravity;
        [self setNeedsLayout];
    }
}

-(GTUIGravity)gravity
{
    return self.gtuiCurrentSizeClass.gravity;
}



-(void)setReverseLayout:(BOOL)reverseLayout
{
    
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.reverseLayout != reverseLayout)
    {
        lsc.reverseLayout = reverseLayout;
        [self setNeedsLayout];
    }
}

-(BOOL)reverseLayout
{
    return self.gtuiCurrentSizeClass.reverseLayout;
}



-(CGAffineTransform)layoutTransform
{
    return self.gtuiCurrentSizeClass.layoutTransform;
}

-(void)setLayoutTransform:(CGAffineTransform)layoutTransform
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (!CGAffineTransformEqualToTransform(lsc.layoutTransform, layoutTransform))
    {
        lsc.layoutTransform = layoutTransform;
        [self setNeedsLayout];
    }
}

-(void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


-(void)layoutAnimationWithDuration:(NSTimeInterval)duration
{
    self.beginLayoutBlock = ^{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
    };
    
    self.endLayoutBlock = ^{
        
        [UIView commitAnimations];
    };
}

-(GTUIBorderline*)topBorderline
{
    return _borderlineLayerDelegate.topBorderline;
}

-(void)setTopBorderline:(GTUIBorderline *)topBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    
    _borderlineLayerDelegate.topBorderline = topBorderline;
}

-(GTUIBorderline*)leadingBorderline
{
    return _borderlineLayerDelegate.leadingBorderline;
}

-(void)setLeadingBorderline:(GTUIBorderline *)leadingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    
    _borderlineLayerDelegate.leadingBorderline = leadingBorderline;
}

-(GTUIBorderline*)bottomBorderline
{
    return _borderlineLayerDelegate.bottomBorderline;
}

-(void)setBottomBorderline:(GTUIBorderline *)bottomBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    
    _borderlineLayerDelegate.bottomBorderline = bottomBorderline;
}


-(GTUIBorderline*)trailingBorderline
{
    return _borderlineLayerDelegate.trailingBorderline;
}

-(void)setTrailingBorderline:(GTUIBorderline *)trailingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    
    _borderlineLayerDelegate.trailingBorderline = trailingBorderline;
}



-(GTUIBorderline*)leftBorderline
{
    return _borderlineLayerDelegate.leftBorderline;
}

-(void)setLeftBorderline:(GTUIBorderline *)leftBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    
    _borderlineLayerDelegate.leftBorderline = leftBorderline;
}


-(GTUIBorderline*)rightBorderline
{
    return _borderlineLayerDelegate.rightBorderline;
}

-(void)setRightBorderline:(GTUIBorderline *)rightBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:self.layer];
    }
    
    _borderlineLayerDelegate.rightBorderline = rightBorderline;
}


-(void)setBoundBorderline:(GTUIBorderline *)boundBorderline
{
    self.leadingBorderline = boundBorderline;
    self.trailingBorderline = boundBorderline;
    self.topBorderline = boundBorderline;
    self.bottomBorderline = boundBorderline;
}

-(GTUIBorderline*)boundBorderline
{
    return self.bottomBorderline;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage)
    {
        _backgroundImage = backgroundImage;
        self.layer.contents = (id)_backgroundImage.CGImage;
    }
}



-(CGSize)gtuiEstimateLayoutRect:(CGSize)size inSizeClass:(GTUISizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    GTUIFrame *selfgtuiFrame = self.gtuiFrame;
    
    if (self.gtuiFrame.multiple)
        self.gtuiFrame.sizeClass = [self gtuiBestSizeClass:sizeClass];
    
    for (UIView *sbv in self.subviews)
    {
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        if (sbvgtuiFrame.multiple)
            sbvgtuiFrame.sizeClass = [sbv gtuiBestSizeClass:sizeClass];
    }
    
    BOOL hasSubLayout = NO;
    CGSize selfSize= [self calcLayoutRect:size isEstimate:NO pHasSubLayout:&hasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (hasSubLayout)
    {
        selfgtuiFrame.width = selfSize.width;
        selfgtuiFrame.height = selfSize.height;
        
        selfSize = [self calcLayoutRect:CGSizeZero isEstimate:YES pHasSubLayout:&hasSubLayout sizeClass:sizeClass sbs:sbs];
    }
    
    selfgtuiFrame.width = selfSize.width;
    selfgtuiFrame.height = selfSize.height;
    
    
    
    //计算后还原为默认sizeClass
    for (UIView *sbv in self.subviews)
    {
        GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
        if (sbvgtuiFrame.multiple)
            sbvgtuiFrame.sizeClass = self.gtuiDefaultSizeClass;
    }
    
    if (selfgtuiFrame.multiple)
        selfgtuiFrame.sizeClass = self.gtuiDefaultSizeClass;
    
    if (self.cacheEstimatedRect)
        _useCacheRects = YES;
    
    return CGSizeMake(_gtuiCGFloatRound(selfSize.width), _gtuiCGFloatRound(selfSize.height));
}

-(void)setCacheEstimatedRect:(BOOL)cacheEstimatedRect
{
    _cacheEstimatedRect = cacheEstimatedRect;
    _useCacheRects = NO;
}


-(CGRect)subview:(UIView*)subview estimatedRectInLayoutSize:(CGSize)size
{
    if (subview.superview == self)
        return subview.frame;
    
    NSMutableArray *sbs = [self gtuiGetLayoutSubviews];
    [sbs addObject:subview];
    
    [self gtuiEstimateLayoutRect:size inSizeClass:GTUISizeClasswAny | GTUISizeClasshAny sbs:sbs];
    
    return [subview estimatedRect];
}



-(void)setHighlightedOpacity:(CGFloat)highlightedOpacity
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTUILayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    
    _touchEventDelegate.highlightedOpacity = highlightedOpacity;
}

-(CGFloat)highlightedOpacity
{
    return _touchEventDelegate.highlightedOpacity;
}

-(void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTUILayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    
    _touchEventDelegate.highlightedBackgroundColor = highlightedBackgroundColor;
}

-(UIColor*)highlightedBackgroundColor
{
    return _touchEventDelegate.highlightedBackgroundColor;
}

-(void)setHighlightedBackgroundImage:(UIImage *)highlightedBackgroundImage
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTUILayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    
    _touchEventDelegate.highlightedBackgroundImage = highlightedBackgroundImage;
}

-(UIImage*)highlightedBackgroundImage
{
    return _touchEventDelegate.highlightedBackgroundImage;
}


-(void)setTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTUILayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    
    [_touchEventDelegate setTarget:target action:action];
}


-(void)setTouchDownTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTUILayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    
    [_touchEventDelegate setTouchDownTarget:target action:action];
}

-(void)setTouchCancelTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil)
    {
        _touchEventDelegate = [[GTUILayoutTouchEventDelegate alloc] initWithLayout:self];
    }
    
    [_touchEventDelegate setTouchCancelTarget:target action:action];
    
}





#pragma mark -- Touches Event


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [_touchEventDelegate touchesBegan:touches withEvent:event];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchEventDelegate touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchEventDelegate touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchEventDelegate touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}



#pragma mark -- KVO


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    
    //监控非布局父视图的frame的变化，而改变自身的位置和尺寸
    if (context == _gtuiObserverContextC)
    {
        //只监控父视图的尺寸变换
        CGRect rcOld = [change[NSKeyValueChangeOldKey] CGRectValue];
        CGRect rcNew = [change[NSKeyValueChangeNewKey] CGRectValue];
        if (!_gtuiCGSizeEqual(rcOld.size, rcNew.size))
        {
            [self gtuiUpdateLayoutRectInNoLayoutSuperview:object];
        }
        return;
    }
    
    
    //监控子视图的frame的变化以便重新进行布局
    if (!_isGTUILayouting)
    {
        
        if (context == _gtuiObserverContextA)
        {
            [self setNeedsLayout];
            //这里添加的原因是有可能子视图取消隐藏后不会绘制自身，所以这里要求子视图重新绘制自身
            if ([keyPath isEqualToString:@"hidden"] && ![change[NSKeyValueChangeNewKey] boolValue])
            {
                [(UIView*)object setNeedsDisplay];
            }
            
        }
        else if (context == _gtuiObserverContextB)
        {//针对UILabel特殊处理。。
            
            UIView *sbvsc = object.gtuiCurrentSizeClass;
            
            if (sbvsc.widthSizeInner.dimeSelfVal != nil && sbvsc.heightSizeInner.dimeSelfVal != nil)
            {
                [self setNeedsLayout];
            }
            else if (sbvsc.wrapContentWidth ||
                     sbvsc.wrapContentHeight ||
                     sbvsc.widthSizeInner.dimeSelfVal != nil ||
                     sbvsc.heightSizeInner.dimeSelfVal != nil)
            {
                [object sizeToFit];
            }
        }
    }
}


#pragma mark -- Override Methods



-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.wrapContentHeight != wrapContentHeight)
    {
        lsc.wrapContentHeight = wrapContentHeight;
        [self setNeedsLayout];
    }
}


-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.wrapContentWidth != wrapContentWidth)
    {
        lsc.wrapContentWidth = wrapContentWidth;
        [self setNeedsLayout];
    }
    
}

-(void)setWrapContentSize:(BOOL)wrapContentSize
{
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    if (lsc.wrapContentSize != wrapContentSize)
    {
        lsc.wrapContentSize = wrapContentSize;
        [self setNeedsLayout];
    }
}



-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(GTUISizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize;
    if (isEstimate)
        selfSize = self.gtuiFrame.frame.size;
    else
    {
        selfSize = self.bounds.size;
        if (size.width != 0)
            selfSize.width = size.width;
        if (size.height != 0)
            selfSize.height = size.height;
    }
    
    if (pHasSubLayout != nil)
        *pHasSubLayout = NO;
    
    return selfSize;
    
}


-(id)createSizeClassInstance
{
    return [GTUILayoutViewSizeClass new];
}


-(CGSize)sizeThatFits:(CGSize)size
{
    return [self sizeThatFits:size inSizeClass:GTUISizeClasswAny | GTUISizeClasshAny];
}

-(CGSize)sizeThatFits:(CGSize)size inSizeClass:(GTUISizeClass)sizeClass
{
    return [self gtuiEstimateLayoutRect:size inSizeClass:sizeClass sbs:nil];
}


-(void)setHidden:(BOOL)hidden
{
    if (self.isHidden == hidden)
        return;
    
    [super setHidden:hidden];
    if (hidden == NO)
    {
        
        [_borderlineLayerDelegate setNeedsLayoutIn:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) withLayer:self.layer];
        
        if ([self.superview isKindOfClass:[GTUIBaseLayout class]])
        {
            [self setNeedsLayout];
        }
        
    }
    
}



- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];   //只要加入进来后就修改其默认的实现，而改用我们的实现，这里包括隐藏,调整大小，
    
    if ([subview isKindOfClass:[GTUIBaseLayout class]])
    {
        ((GTUIBaseLayout*)subview).cacheEstimatedRect = self.cacheEstimatedRect;
    }
    
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];  //删除后恢复其原来的实现。
    
    [self gtuiRemoveSubviewObserver:subview];
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    if (newWindow == nil)
    {
        //这里处理可能因为触摸事件被强行终止而导致的背景色无法恢复的问题。
        [_touchEventDelegate gtuiResetTouchHighlighted2];
    }
}

- (void)willMoveToSuperview:(UIView*)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    GTUIBaseLayout *lsc = self.gtuiCurrentSizeClass;
    
    //特殊处理如果视图是控制器根视图则取消wrapContentWidth, wrapContentHeight,以及adjustScrollViewContentSizeMode的设置。
    @try {
        
        if (newSuperview != nil)
        {
            UIRectEdge defRectEdge = UIRectEdgeLeft | UIRectEdgeRight;
            id vc = [self valueForKey:@"viewDelegate"];
            if (vc != nil)
            {
                lsc.wrapContentWidth = NO;
                lsc.wrapContentHeight = NO;
                if (lsc.insetsPaddingFromSafeArea == defRectEdge)
                    lsc.insetsPaddingFromSafeArea = ~UIRectEdgeTop;
                self.adjustScrollViewContentSizeMode = GTUIAdjustScrollViewContentSizeModeNo;
            }
            
            //如果布局视图的父视图是滚动视图并且是非UITableView和UICollectionView的话。将默认叠加除顶部外的安全区域。
            if ([newSuperview isKindOfClass:[UIScrollView class]] && ![newSuperview isKindOfClass:[UITableView class]] && ![newSuperview isKindOfClass:[UICollectionView class]])
            {
                if (lsc.insetsPaddingFromSafeArea == defRectEdge)
                    lsc.insetsPaddingFromSafeArea = ~UIRectEdgeTop;
            }
        }
        
    } @catch (NSException *exception) {
        
    }
    
    
#ifdef DEBUG
    
    if (lsc.wrapContentHeight && lsc.heightSizeInner.dimeVal != nil)
    {
        //约束警告：wrapContentHeight和设置的heightSize可能有约束冲突
        NSLog(@"Constraint warning！%@'s wrapContentHeight and heightSize setting may be constraint.",self);
    }
    
    if (lsc.wrapContentWidth && lsc.widthSizeInner.dimeVal != nil)
    {
        //约束警告：wrapContentWidth和设置的widthSize可能有约束冲突
        NSLog(@"Constraint warning！%@'s wrapContentWidth and widthSize setting may be constraint.",self);
    }
    
#endif
    
    
    
    
    //将要添加到父视图时，如果不是GTUILayout派生则则跟需要根据父视图的frame的变化而调整自身的位置和尺寸
    if (newSuperview != nil && ![newSuperview isKindOfClass:[GTUIBaseLayout class]])
    {
        
#ifdef DEBUG
        
        if (lsc.leadingPosInner.posRelaVal != nil)
        {
            //约束冲突：左边距依赖的视图不是父视图
            NSCAssert(lsc.leadingPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@leading pos dependent on:%@is not superview",self, lsc.leadingPosInner.posRelaVal.view);
        }
        
        if (lsc.trailingPosInner.posRelaVal != nil)
        {
            //约束冲突：右边距依赖的视图不是父视图
            NSCAssert(lsc.trailingPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@trailing pos dependent on:%@is not superview",self,lsc.trailingPosInner.posRelaVal.view);
        }
        
        if (lsc.centerXPosInner.posRelaVal != nil)
        {
            //约束冲突：水平中心点依赖的视图不是父视图
            NSCAssert(lsc.centerXPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@horizontal center pos dependent on:%@is not superview",self, lsc.centerXPosInner.posRelaVal.view);
        }
        
        if (lsc.topPosInner.posRelaVal != nil)
        {
            //约束冲突：上边距依赖的视图不是父视图
            NSCAssert(lsc.topPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@top pos dependent on:%@is not superview",self, lsc.topPosInner.posRelaVal.view);
        }
        
        if (lsc.bottomPosInner.posRelaVal != nil)
        {
            //约束冲突：下边距依赖的视图不是父视图
            NSCAssert(lsc.bottomPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! %@bottom pos dependent on:%@is not superview",self, lsc.bottomPosInner.posRelaVal.view);
            
        }
        
        if (lsc.centerYPosInner.posRelaVal != nil)
        {
            //约束冲突：垂直中心点依赖的视图不是父视图
            NSCAssert(lsc.centerYPosInner.posRelaVal.view == newSuperview, @"Constraint exception!! vertical center pos dependent on:%@is not superview",lsc.centerYPosInner.posRelaVal.view);
        }
        
        if (lsc.widthSizeInner.dimeRelaVal != nil)
        {
            //约束冲突：宽度依赖的视图不是父视图
            NSCAssert(lsc.widthSizeInner.dimeRelaVal.view == newSuperview, @"Constraint exception!! %@width dependent on:%@is not superview",self, lsc.widthSizeInner.dimeRelaVal.view);
        }
        
        if (lsc.heightSizeInner.dimeRelaVal != nil)
        {
            //约束冲突：高度依赖的视图不是父视图
            NSCAssert(lsc.heightSizeInner.dimeRelaVal.view == newSuperview, @"Constraint exception!! %@height dependent on:%@is not superview",self,lsc.heightSizeInner.dimeRelaVal.view);
        }
        
#endif
        
        if ([self gtuiUpdateLayoutRectInNoLayoutSuperview:newSuperview])
        {
            //有可能父视图不为空，所以这里先把以前父视图的KVO删除。否则会导致程序崩溃
            
            //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
            //然后在左边将异常断点清除即可
            
            if (_isAddSuperviewKVO && self.superview != nil && ![self.superview isKindOfClass:[GTUIBaseLayout class]])
            {
                @try {
                    [self.superview removeObserver:self forKeyPath:@"frame"];
                    
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                @try {
                    [self.superview removeObserver:self forKeyPath:@"bounds"];
                    
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                
            }
            
            [newSuperview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:_gtuiObserverContextC];
            [newSuperview addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:_gtuiObserverContextC];
            _isAddSuperviewKVO = YES;
        }
    }
    
    
    if (_isAddSuperviewKVO && newSuperview == nil && self.superview != nil && ![self.superview isKindOfClass:[GTUIBaseLayout class]])
    {
        
        //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
        //然后在左边将异常断点清除即可
        
        _isAddSuperviewKVO = NO;
        @try {
            [self.superview removeObserver:self forKeyPath:@"frame"];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        @try {
            [self.superview removeObserver:self forKeyPath:@"bounds"];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
    }
    
    
    if (newSuperview != nil)
    {
        //不支持放在UITableView和UICollectionView下,因为有肯能是tableheaderView或者section下。
        if ([newSuperview isKindOfClass:[UIScrollView class]] && ![newSuperview isKindOfClass:[UITableView class]] && ![newSuperview isKindOfClass:[UICollectionView class]])
        {
            if (self.adjustScrollViewContentSizeMode == GTUIAdjustScrollViewContentSizeModeAuto)
            {
                //这里预先设置一下contentSize主要是为了解决contentOffset在后续计算contentSize的偏移错误的问题。
                [UIView performWithoutAnimation:^{
                    UIScrollView *scrollSuperView = (UIScrollView*)newSuperview;
                    if (CGSizeEqualToSize(scrollSuperView.contentSize, CGSizeZero))
                    {
                        CGSize screenSize = [UIScreen mainScreen].bounds.size;
                        scrollSuperView.contentSize =  CGSizeMake(0, screenSize.height + 0.1);
                    }
                }];
                
                self.adjustScrollViewContentSizeMode = GTUIAdjustScrollViewContentSizeModeYes;
            }
        }
    }
    else
    {
        self.beginLayoutBlock = nil;
        self.endLayoutBlock = nil;
    }
    
    
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if (self.superview != nil && ![self.superview isKindOfClass:[GTUIBaseLayout class]])
        [self gtuiUpdateLayoutRectInNoLayoutSuperview:self.superview];
}

-(void)safeAreaInsetsDidChange
{
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
    
    [super safeAreaInsetsDidChange];
#endif
    
    if (self.superview != nil && ![self.superview isKindOfClass:[GTUIBaseLayout class]] &&
        (self.leadingPosInner.isSafeAreaPos ||
         self.trailingPosInner.isSafeAreaPos ||
         self.topPosInner.isSafeAreaPos ||
         self.bottomPosInner.isSafeAreaPos)
        )
    {
        if (!_isGTUILayouting)
        {
            _isGTUILayouting = YES;
            [self gtuiUpdateLayoutRectInNoLayoutSuperview:self.superview];
            _isGTUILayouting = NO;
        }
    }
}

-(void)layoutSubviews
{
    
    if (!self.autoresizesSubviews)
        return;
    
    if (self.beginLayoutBlock != nil)
        self.beginLayoutBlock();
    self.beginLayoutBlock = nil;
    
    int  currentScreenOrientation = 0;
    
    
    if (!self.isGTUILayouting)
    {
        
        _isGTUILayouting = YES;
        
        if (self.priorAutoresizingMask)
            [super layoutSubviews];
        
        //减少每次调用就计算设备方向以及sizeclass的次数。
        GTUISizeClass sizeClass = [self gtuiGetGlobalSizeClass];
        if ((sizeClass & 0xF0) == GTUISizeClassPortrait)
            currentScreenOrientation = 1;
        else if ((sizeClass & 0xF0) == GTUISizeClassLandscape)
            currentScreenOrientation = 2;
        
        GTUIFrame *selfgtuiFrame = self.gtuiFrame;
        if (self.gtuiFrame.multiple)
            self.gtuiFrame.sizeClass = [self gtuiBestSizeClass:sizeClass];
        for (UIView *sbv in self.subviews)
        {
            GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
            if (sbvgtuiFrame.multiple)
                sbv.gtuiFrame.sizeClass = [sbv gtuiBestSizeClass:sizeClass];
            
            if (!sbvgtuiFrame.hasObserver && sbvgtuiFrame.sizeClass != nil && !sbvgtuiFrame.sizeClass.useFrame)
            {
                [self gtuiAddSubviewObserver:sbv sbvgtuiFrame:sbvgtuiFrame];
            }
        }
        
        GTUIBaseLayout *lsc = (GTUIBaseLayout*)selfgtuiFrame.sizeClass;
        
        
        //计算布局
        CGSize oldSelfSize = self.bounds.size;
        CGSize newSelfSize;
        if (_useCacheRects && selfgtuiFrame.width != CGFLOAT_MAX && selfgtuiFrame.height != CGFLOAT_MAX)
        {
            newSelfSize = CGSizeMake(selfgtuiFrame.width, selfgtuiFrame.height);
        }
        else
        {
            newSelfSize = [self calcLayoutRect:[self gtuiCalcSizeInNoLayoutSuperview:self.superview currentSize:oldSelfSize] isEstimate:NO pHasSubLayout:nil sizeClass:sizeClass sbs:nil];
        }
        newSelfSize = _gtuiCGSizeRound(newSelfSize);
        _useCacheRects = NO;
        
        static CGFloat sSizeError = 0;
        if (sSizeError == 0)
            sSizeError = 1 / [UIScreen mainScreen].scale + 0.0001;  //误差量。
        
        //设置子视图的frame并还原
        for (UIView *sbv in self.subviews)
        {
            CGRect sbvOldBounds = sbv.bounds;
            CGPoint sbvOldCenter = sbv.center;
            
            GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
            UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
            
            if (sbvgtuiFrame.leading != CGFLOAT_MAX && sbvgtuiFrame.top != CGFLOAT_MAX && !sbvsc.noLayout && !sbvsc.useFrame)
            {
                if (sbvgtuiFrame.width < 0)
                {
                    sbvgtuiFrame.width = 0;
                }
                if (sbvgtuiFrame.height < 0)
                {
                    sbvgtuiFrame.height = 0;
                }
                
                //这里的位置需要进行有效像素的舍入处理，否则可能出现文本框模糊，以及视图显示可能多出一条黑线的问题。
                //原因是当frame中的值不能有效的转化为最小可绘制的物理像素时就会出现模糊，虚化，多出黑线，以及layer处理圆角不圆的情况。
                //所以这里要将frame中的点转化为有效的点。
                //这里之所以讲布局子视图的转化方法和一般子视图的转化方法区分开来是因为。我们要保证布局子视图不能出现细微的重叠，因为布局子视图有边界线
                //如果有边界线而又出现细微重叠的话，那么边界线将无法正常显示，因此这里做了一个特殊的处理。
                CGRect rc;
                if ([sbv isKindOfClass:[GTUIBaseLayout class]])
                {
                    rc  = _gtuiLayoutCGRectRound(sbvgtuiFrame.frame);
                    
                    
                    CGRect sbvTempBounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, rc.size.width, rc.size.height);
                    
                    if (_gtuiCGFloatErrorEqual(sbvTempBounds.size.width, sbvOldBounds.size.width, sSizeError))
                        sbvTempBounds.size.width = sbvOldBounds.size.width;
                    
                    if (_gtuiCGFloatErrorEqual(sbvTempBounds.size.height, sbvOldBounds.size.height, sSizeError))
                        sbvTempBounds.size.height = sbvOldBounds.size.height;
                    
                    
                    if (_gtuiCGFloatErrorNotEqual(sbvTempBounds.size.width, sbvOldBounds.size.width, sSizeError)||
                        _gtuiCGFloatErrorNotEqual(sbvTempBounds.size.height, sbvOldBounds.size.height, sSizeError))
                    {
                        sbv.bounds = sbvTempBounds;
                    }
                    
                    CGPoint sbvTempCenter = CGPointMake(rc.origin.x + sbv.layer.anchorPoint.x * sbvTempBounds.size.width, rc.origin.y + sbv.layer.anchorPoint.y * sbvTempBounds.size.height);
                    
                    if (_gtuiCGFloatErrorEqual(sbvTempCenter.x, sbvOldCenter.x, sSizeError))
                        sbvTempCenter.x = sbvOldCenter.x;
                    
                    if (_gtuiCGFloatErrorEqual(sbvTempCenter.y, sbvOldCenter.y, sSizeError))
                        sbvTempCenter.y = sbvOldCenter.y;
                    
                    
                    if (_gtuiCGFloatErrorNotEqual(sbvTempCenter.x, sbvOldCenter.x, sSizeError)||
                        _gtuiCGFloatErrorNotEqual(sbvTempCenter.y, sbvOldCenter.y, sSizeError))
                    {
                        sbv.center = sbvTempCenter;
                    }
                    
                    
                }
                else
                {
                    rc = _gtuiCGRectRound(sbvgtuiFrame.frame);
                    
                    sbv.center = CGPointMake(rc.origin.x + sbv.layer.anchorPoint.x * rc.size.width, rc.origin.y + sbv.layer.anchorPoint.y * rc.size.height);
                    sbv.bounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, rc.size.width, rc.size.height);
                    
                }
                
            }
            
            if (sbvsc.gtui_visibility == GTUIVisibilityGone && !sbv.isHidden)
            {
                sbv.bounds = CGRectMake(sbvOldBounds.origin.x, sbvOldBounds.origin.y, 0, 0);
            }
            
            if (sbvgtuiFrame.sizeClass.viewLayoutCompleteBlock != nil)
            {
                sbvgtuiFrame.sizeClass.viewLayoutCompleteBlock(self, sbv);
                sbvgtuiFrame.sizeClass.viewLayoutCompleteBlock = nil;
            }
            
            
            if (sbvgtuiFrame.multiple)
                sbvgtuiFrame.sizeClass = [sbv gtuiDefaultSizeClass];
            [sbvgtuiFrame reset];
        }
        
        
        if (newSelfSize.width != CGFLOAT_MAX && (lsc.wrapContentWidth || lsc.wrapContentHeight))
        {
            
            
            //因为布局子视图的新老尺寸计算在上面有两种不同的方法，因此这里需要考虑两种计算的误差值，而这两种计算的误差值是不超过1/屏幕精度的。
            //因此我们认为当二者的值超过误差时我们才认为有尺寸变化。
            BOOL isWidthAlter =  _gtuiCGFloatErrorNotEqual(newSelfSize.width, oldSelfSize.width, sSizeError);
            BOOL isHeightAlter = _gtuiCGFloatErrorNotEqual(newSelfSize.height, oldSelfSize.height, sSizeError);
            
            //如果父视图也是布局视图，并且自己隐藏则不调整自身的尺寸和位置。
            BOOL isAdjustSelf = YES;
            if (self.superview != nil && [self.superview isKindOfClass:[GTUIBaseLayout class]])
            {
                GTUIBaseLayout *supl = (GTUIBaseLayout*)self.superview;
                if ([supl gtuiIsNoLayoutSubview:self])
                    isAdjustSelf = NO;
            }
            if (isAdjustSelf && (isWidthAlter || isHeightAlter))
            {
                
                if (newSelfSize.width < 0)
                {
                    newSelfSize.width = 0;
                }
                
                if (newSelfSize.height < 0)
                {
                    newSelfSize.height = 0;
                }
                
                if (CGAffineTransformIsIdentity(self.transform))
                {
                    CGRect currentFrame = self.frame;
                    if (isWidthAlter && lsc.wrapContentWidth)
                        currentFrame.size.width = newSelfSize.width;
                    
                    if (isHeightAlter && lsc.wrapContentHeight)
                        currentFrame.size.height = newSelfSize.height;
                    
                    self.frame = currentFrame;
                }
                else
                {
                    CGRect currentBounds = self.bounds;
                    CGPoint currentCenter = self.center;
                    
                    if (isWidthAlter && lsc.wrapContentWidth)
                    {
                        currentBounds.size.width = newSelfSize.width;
                        currentCenter.x += (newSelfSize.width - oldSelfSize.width) * self.layer.anchorPoint.x;
                    }
                    
                    if (isHeightAlter && lsc.wrapContentHeight)
                    {
                        currentBounds.size.height = newSelfSize.height;
                        currentCenter.y += (newSelfSize.height - oldSelfSize.height) * self.layer.anchorPoint.y;
                    }
                    
                    self.bounds = currentBounds;
                    self.center = currentCenter;
                    
                }
            }
        }
        
        
        //这里只用width判断的原因是如果newSelfSize被计算成功则size中的所有值都不是CGFLOAT_MAX，所以这里选width只是其中一个代表。
        if (newSelfSize.width != CGFLOAT_MAX)
        {
            UIView *supv = self.superview;
            
            
            //更新边界线。
            if (_borderlineLayerDelegate != nil)
            {
                CGRect borderlineRect = CGRectMake(0, 0, newSelfSize.width, newSelfSize.height);
                if ([supv isKindOfClass:[GTUIBaseLayout class]])
                {
                    //这里给父布局视图一个机会来可以改变当前布局的borderlineRect的值，也就是显示的边界线有可能会超出当前布局视图本身的区域。
                    //比如一些表格或者其他的情况。默认情况下这个函数什么也不做。
                    [((GTUIBaseLayout*)supv) gtuiHookSublayout:self borderlineRect:&borderlineRect];
                }
                
                [_borderlineLayerDelegate setNeedsLayoutIn:borderlineRect withLayer:self.layer];
                
            }
            
            //如果自己的父视图是非UIScrollView以及非布局视图。以及自己是wrapContentWidth或者wrapContentHeight时，并且如果设置了在父视图居中或者居下或者居右时要在父视图中更新自己的位置。
            if (supv != nil && ![supv isKindOfClass:[GTUIBaseLayout class]])
            {
                CGPoint centerPonintSelf = self.center;
                CGRect rectSelf = self.bounds;
                CGRect rectSuper = supv.bounds;
                
                //特殊处理低版本下的top和bottom的两种安全区域的场景。
                if ((lsc.topPosInner.isSafeAreaPos || lsc.bottomPosInner.isSafeAreaPos) && [UIDevice currentDevice].systemVersion.doubleValue < 11 )
                {
                    if (lsc.topPosInner.isSafeAreaPos)
                    {
                        centerPonintSelf.y = [lsc.topPosInner realPosIn:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                    }
                    else
                    {
                        centerPonintSelf.y  = rectSuper.size.height - rectSelf.size.height - [lsc.bottomPosInner realPosIn:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                    }
                }
                
                //如果自己的父视图是非UIScrollView以及非布局视图。以及自己是wrapContentWidth或者wrapContentHeight时，并且如果设置了在父视图居中或者居下或者居右时要在父视图中更新自己的位置。
                if (![supv isKindOfClass:[UIScrollView class]] && (lsc.wrapContentWidth || lsc.wrapContentHeight))
                {
                    
                    if ([GTUIBaseLayout isRTL])
                        centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x;
                    
                    if (lsc.wrapContentWidth)
                    {
                        //如果只设置了右边，或者只设置了居中则更新位置。。
                        if (lsc.centerXPosInner.posVal != nil)
                        {
                            centerPonintSelf.x = (rectSuper.size.width - rectSelf.size.width)/2 + self.layer.anchorPoint.x * rectSelf.size.width;
                            
                            centerPonintSelf.x += [lsc.centerXPosInner realPosIn:rectSuper.size.width];
                        }
                        else if (lsc.trailingPosInner.posVal != nil && lsc.leadingPosInner.posVal == nil)
                        {
                            centerPonintSelf.x  = rectSuper.size.width - rectSelf.size.width - [lsc.trailingPosInner realPosIn:rectSuper.size.width] + self.layer.anchorPoint.x * rectSelf.size.width;
                        }
                        
                    }
                    
                    if (lsc.wrapContentHeight)
                    {
                        if (lsc.centerYPosInner.posVal != nil)
                        {
                            centerPonintSelf.y = (rectSuper.size.height - rectSelf.size.height)/2 + [lsc.centerYPosInner realPosIn:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        }
                        else if (lsc.bottomPosInner.posVal != nil && lsc.topPosInner.posVal == nil)
                        {
                            //这里可能有坑，在有安全区时。但是先不处理了。
                            centerPonintSelf.y  = rectSuper.size.height - rectSelf.size.height - [lsc.bottomPosInner realPosIn:rectSuper.size.height] + self.layer.anchorPoint.y * rectSelf.size.height;
                        }
                    }
                    
                    if ([GTUIBaseLayout isRTL])
                        centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x;
                    
                }
                
                //如果有变化则只调整自己的center。而不变化
                if (!_gtuiCGPointEqual(self.center, centerPonintSelf))
                {
                    self.center = centerPonintSelf;
                }
                
            }
            
            
            //这里处理当布局视图的父视图是非布局父视图，且父视图具有wrap属性时需要调整父视图的尺寸。
            if (supv != nil && ![supv isKindOfClass:[GTUIBaseLayout class]])
            {
                if (supv.wrapContentHeight || supv.wrapContentWidth)
                {
                    //调整父视图的高度和宽度。frame值。
                    CGRect superBounds = supv.bounds;
                    CGPoint superCenter = supv.center;
                    
                    if (supv.wrapContentHeight)
                    {
                        superBounds.size.height = [self gtuiValidMeasure:supv.heightSizeInner sbv:supv calcSize:lsc.gtui_top + newSelfSize.height + lsc.gtui_bottom sbvSize:superBounds.size selfLayoutSize:newSelfSize];
                        superCenter.y += (superBounds.size.height - supv.bounds.size.height) * supv.layer.anchorPoint.y;
                    }
                    
                    if (supv.wrapContentWidth)
                    {
                        superBounds.size.width = [self gtuiValidMeasure:supv.widthSizeInner sbv:supv calcSize:lsc.gtui_leading + newSelfSize.width + lsc.gtui_trailing sbvSize:superBounds.size selfLayoutSize:newSelfSize];
                        superCenter.x += (superBounds.size.width - supv.bounds.size.width) * supv.layer.anchorPoint.x;
                    }
                    
                    if (!_gtuiCGRectEqual(supv.bounds, superBounds))
                    {
                        supv.center = superCenter;
                        supv.bounds = superBounds;
                    }
                    
                }
            }
            
            //处理父视图是滚动视图时动态调整滚动视图的contentSize
            [self gtuiAlterScrollViewContentSize:newSelfSize lsc:lsc];
        }
        
        
        if (selfgtuiFrame.multiple)
            selfgtuiFrame.sizeClass = [self gtuiDefaultSizeClass];
        _isGTUILayouting = NO;
        
    }
    
    if (self.endLayoutBlock != nil)
        self.endLayoutBlock();
    self.endLayoutBlock = nil;
    
    //执行屏幕旋转的处理逻辑。
    if (currentScreenOrientation != 0 && self.rotationToDeviceOrientationBlock != nil)
    {
        if (_lastScreenOrientation == 0)
        {
            _lastScreenOrientation = currentScreenOrientation;
            self.rotationToDeviceOrientationBlock(self,YES, currentScreenOrientation == 1);
        }
        else
        {
            if (_lastScreenOrientation != currentScreenOrientation)
            {
                _lastScreenOrientation = currentScreenOrientation;
                self.rotationToDeviceOrientationBlock(self, NO, currentScreenOrientation == 1);
            }
        }
        
        _lastScreenOrientation = currentScreenOrientation;
    }
    
    
}


#pragma mark -- Private Methods



-(BOOL)gtuiIsRelativePos:(CGFloat)margin
{
    return margin > 0 && margin < 1;
}


-(GTUIGravity)gtuiGetSubviewVertGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc vertGravity:(GTUIGravity)vertGravity
{
    GTUIGravity sbvVertAligement = sbvsc.gtui_alignment & GTUIGravityHorzMask;
    GTUIGravity sbvVertGravity = GTUIGravityVertTop;
    
    if (vertGravity != GTUIGravityNone)
    {
        sbvVertGravity = vertGravity;
        if (sbvVertAligement != GTUIGravityNone)
        {
            sbvVertGravity = sbvVertAligement;
        }
    }
    else
    {
        
        if (sbvVertAligement != GTUIGravityNone)
        {
            sbvVertGravity = sbvVertAligement;
        }
        
        if (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)
        {
            sbvVertGravity = GTUIGravityVertFill;
        }
        else if (sbvsc.centerYPosInner.posVal != nil)
        {
            sbvVertGravity = GTUIGravityVertCenter;
        }
        else if (sbvsc.topPosInner.posVal != nil)
        {
            sbvVertGravity = GTUIGravityVertTop;
        }
        else if (sbvsc.bottomPosInner.posVal != nil)
        {
            sbvVertGravity = GTUIGravityVertBottom;
        }
    }
    
    return sbvVertGravity;
}


-(void)gtuiCalcVertGravity:(GTUIGravity)vertGravity
                     sbv:(UIView *)sbv
                   sbvsc:(UIView*)sbvsc
              paddingTop:(CGFloat)paddingTop
           paddingBottom:(CGFloat)paddingBottom
             baselinePos:(CGFloat)baselinePos
                selfSize:(CGSize)selfSize
                   pRect:(CGRect*)pRect
{
    
    
    CGFloat  topMargin =  [self gtuiValidMargin:sbvsc.topPosInner sbv:sbv calcPos:[sbvsc.topPosInner realPosIn:selfSize.height - paddingTop - paddingBottom] selfLayoutSize:selfSize];
    
    CGFloat  centerMargin = [self gtuiValidMargin:sbvsc.centerYPosInner sbv:sbv calcPos:[sbvsc.centerYPosInner realPosIn:selfSize.height - paddingTop - paddingBottom] selfLayoutSize:selfSize];
    
    CGFloat  bottomMargin = [self gtuiValidMargin:sbvsc.bottomPosInner sbv:sbv calcPos:[sbvsc.bottomPosInner realPosIn:selfSize.height - paddingTop - paddingBottom] selfLayoutSize:selfSize];
    
    //确保设置基线对齐的视图都是UILabel,UITextField,UITextView
    if (baselinePos == CGFLOAT_MAX && vertGravity == GTUIGravityVertBaseline)
        vertGravity = GTUIGravityVertTop;
    
    UIFont *sbvFont = nil;
    if (vertGravity == GTUIGravityVertBaseline)
    {
        sbvFont = [self gtuiGetSubviewFont:sbv];
    }
    
    if (sbvFont == nil && vertGravity == GTUIGravityVertBaseline)
        vertGravity = GTUIGravityVertTop;
    
    
    if (vertGravity == GTUIGravityVertTop)
    {
        pRect->origin.y = paddingTop + topMargin;
    }
    else if (vertGravity == GTUIGravityVertBottom)
    {
        pRect->origin.y = selfSize.height - paddingBottom - bottomMargin - pRect->size.height;
    }
    else if (vertGravity == GTUIGravityVertBaseline)
    {
        //得到基线位置。
        pRect->origin.y = baselinePos - sbvFont.ascender - (pRect->size.height - sbvFont.lineHeight) / 2;
        
    }
    else if (vertGravity == GTUIGravityVertFill)
    {
        pRect->origin.y = paddingTop + topMargin;
        pRect->size.height = [self gtuiValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:selfSize.height - paddingTop - paddingBottom - topMargin - bottomMargin  sbvSize:pRect->size selfLayoutSize:selfSize];
    }
    else if (vertGravity == GTUIGravityVertCenter)
    {
        pRect->origin.y = (selfSize.height - paddingTop - paddingBottom - topMargin - bottomMargin - pRect->size.height)/2 + paddingTop + topMargin + centerMargin;
    }
    else if (vertGravity == GTUIGravityVertWindow_Center)
    {
        if (self.window != nil)
        {
            pRect->origin.y = (CGRectGetHeight(self.window.bounds) - topMargin - bottomMargin - pRect->size.height)/2 + topMargin + centerMargin;
            pRect->origin.y =  [self.window convertPoint:pRect->origin toView:self].y;
        }
    }
    else
    {
        ;
    }
    
    
}


-(GTUIGravity)gtuiGetSubviewHorzGravity:(UIView*)sbv sbvsc:(UIView*)sbvsc horzGravity:(GTUIGravity)horzGravity
{
    GTUIGravity sbvHorzAligement = [self gtuiConvertLeftRightGravityToLeadingTrailing:sbvsc.gtui_alignment & GTUIGravityVertMask];
    GTUIGravity sbvHorzGravity = GTUIGravityHorzLeading;
    
    if (horzGravity != GTUIGravityNone)
    {
        sbvHorzGravity = horzGravity;
        if (sbvHorzAligement != GTUIGravityNone)
        {
            sbvHorzGravity = sbvHorzAligement;
        }
    }
    else
    {
        
        if (sbvHorzAligement != GTUIGravityNone)
        {
            sbvHorzGravity = sbvHorzAligement;
        }
        
        if (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)
        {
            sbvHorzGravity = GTUIGravityHorzFill;
        }
        else if (sbvsc.centerXPosInner.posVal != nil)
        {
            sbvHorzGravity = GTUIGravityHorzCenter;
        }
        else if (sbvsc.leadingPosInner.posVal != nil)
        {
            sbvHorzGravity = GTUIGravityHorzLeading;
        }
        else if (sbvsc.trailingPosInner.posVal != nil)
        {
            sbvHorzGravity = GTUIGravityHorzTrailing;
        }
    }
    
    return sbvHorzGravity;
}


-(void)gtuiCalcHorzGravity:(GTUIGravity)horzGravity
                     sbv:(UIView *)sbv
                   sbvsc:(UIView*)sbvsc
          paddingLeading:(CGFloat)paddingLeading
         paddingTrailing:(CGFloat)paddingTrailing
                selfSize:(CGSize)selfSize
                   pRect:(CGRect*)pRect
{
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
    
    CGFloat leadingMargin = [self gtuiValidMargin:sbvsc.leadingPosInner sbv:sbv calcPos:[sbvsc.leadingPosInner realPosIn:selfSize.width - paddingHorz] selfLayoutSize:selfSize];
    
    CGFloat centerMargin = [self gtuiValidMargin:sbvsc.centerXPosInner sbv:sbv calcPos:[sbvsc.centerXPosInner realPosIn:selfSize.width - paddingHorz] selfLayoutSize:selfSize];
    
    CGFloat  trailingMargin = [self gtuiValidMargin:sbvsc.trailingPosInner sbv:sbv calcPos:[sbvsc.trailingPosInner realPosIn:selfSize.width - paddingHorz] selfLayoutSize:selfSize];
    
    
    if (horzGravity == GTUIGravityHorzLeading)
    {
        pRect->origin.x = paddingLeading + leadingMargin;
    }
    else if (horzGravity == GTUIGravityHorzTrailing)
    {
        pRect->origin.x = selfSize.width - paddingTrailing - trailingMargin - pRect->size.width;
    }
    if (horzGravity == GTUIGravityHorzFill)
    {
        
        pRect->origin.x = paddingLeading + leadingMargin;
        pRect->size.width = [self gtuiValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:selfSize.width - paddingHorz - leadingMargin -  trailingMargin sbvSize:pRect->size selfLayoutSize:selfSize];
        
    }
    else if (horzGravity == GTUIGravityHorzCenter)
    {
        pRect->origin.x = (selfSize.width - paddingHorz - leadingMargin -  trailingMargin - pRect->size.width)/2 + paddingLeading + leadingMargin + centerMargin;
    }
    else if (horzGravity == GTUIGravityHorzWindowCenter)
    {
        if (self.window != nil)
        {
            pRect->origin.x = (CGRectGetWidth(self.window.bounds) - leadingMargin - trailingMargin - pRect->size.width)/2 + leadingMargin +  centerMargin;
            pRect->origin.x =  [self.window convertPoint:pRect->origin toView:self].x;
            
            //因为从右到左布局最后统一进行了转换，但是窗口居中是不按布局来控制的，所以这里为了保持不变需要进行特殊处理。
            if ([GTUIBaseLayout isRTL])
            {
                pRect->origin.x = selfSize.width - pRect->origin.x - pRect->size.width;
            }
        }
        
    }
    else
    {
        ;
    }
}


-(void)gtuiCalcSizeOfWrapContentSubview:(UIView*)sbv sbvsc:(UIView*)sbvsc sbvgtuiFrame:(GTUIFrame*)sbvgtuiFrame
{
    BOOL isLayoutView = [sbv isKindOfClass:[GTUIBaseLayout class]];
    BOOL isWrapWidth = (sbvsc.widthSizeInner.dimeSelfVal != nil) || (!isLayoutView && sbvsc.wrapContentWidth); //宽度包裹特殊处理
    BOOL isWrapHeight = (sbvsc.heightSizeInner.dimeSelfVal != nil) || (!isLayoutView && sbvsc.wrapContentSize);//高度包裹也特殊处理
    
    
    if (isWrapWidth || isWrapHeight)
    {
        
        CGSize thatFits = CGSizeZero;
        //在一些场景中，计算包裹时有可能设置了最大的尺寸约束，所以这里要进行特殊处理。
        thatFits.width = sbvsc.widthSizeInner.uBoundValInner.dimeNumVal.doubleValue;
        thatFits.height = sbvsc.heightSizeInner.uBoundValInner.dimeNumVal.doubleValue;
        
        CGSize fitSize = [sbv sizeThatFits:thatFits];
        if (isWrapWidth)
        {
            if (sbvsc.wrapContentWidth)
                sbvgtuiFrame.width = fitSize.width;
            else
                sbvgtuiFrame.width = [sbvsc.widthSizeInner measureWith:fitSize.width];
        }
        
        if (isWrapHeight)
        {
            if (sbvsc.wrapContentHeight)
                sbvgtuiFrame.height = fitSize.height;
            else
                sbvgtuiFrame.height = [sbvsc.heightSizeInner measureWith:fitSize.height];
        }
    }
}


-(CGSize)gtuiCalcSizeInNoLayoutSuperview:(UIView*)newSuperview currentSize:(CGSize)size
{
    if (newSuperview == nil || [newSuperview isKindOfClass:[GTUIBaseLayout class]])
        return size;
    
    CGRect rectSuper = newSuperview.bounds;
    UIView *ssc = newSuperview.gtuiCurrentSizeClassInner;
    UIView *lsc = self.gtuiCurrentSizeClass;
    
    if (!ssc.wrapContentWidth)
    {
        if (lsc.widthSizeInner.dimeRelaVal.view == newSuperview)
        {
            if (lsc.widthSizeInner.dimeRelaVal.dime == GTUIGravityHorzFill)
                size.width = [lsc.widthSizeInner measureWith:rectSuper.size.width];
            else
                size.width = [lsc.widthSizeInner measureWith:rectSuper.size.height];
            
            size.width = [self gtuiValidMeasure:lsc.widthSizeInner sbv:self calcSize:size.width sbvSize:size selfLayoutSize:rectSuper.size];
        }
        
        if (lsc.leadingPosInner.posVal != nil && lsc.trailingPosInner.posVal != nil)
        {
            CGFloat leadingMargin = [lsc.leadingPosInner realPosIn:rectSuper.size.width];
            CGFloat trailingMargin = [lsc.trailingPosInner realPosIn:rectSuper.size.width];
            size.width = rectSuper.size.width - leadingMargin - trailingMargin;
            size.width = [self gtuiValidMeasure:lsc.widthSizeInner sbv:self calcSize:size.width sbvSize:size selfLayoutSize:rectSuper.size];
            
        }
        
        if (size.width < 0)
        {
            size.width = 0;
        }
    }
    
    if (!ssc.wrapContentHeight)
    {
        if (lsc.heightSizeInner.dimeRelaVal.view == newSuperview)
        {
            if (lsc.heightSizeInner.dimeRelaVal.dime == GTUIGravityVertFill)
                size.height = [lsc.heightSizeInner measureWith:rectSuper.size.height];
            else
                size.height = [lsc.heightSizeInner measureWith:rectSuper.size.width];
            
            size.height = [self gtuiValidMeasure:lsc.heightSizeInner sbv:self calcSize:size.height sbvSize:size selfLayoutSize:rectSuper.size];
            
        }
        
        if (lsc.topPosInner.posVal != nil && lsc.bottomPosInner.posVal != nil)
        {
            CGFloat topMargin = [lsc.topPosInner realPosIn:rectSuper.size.height];
            CGFloat bottomMargin = [lsc.bottomPosInner realPosIn:rectSuper.size.height];
            size.height = rectSuper.size.height - topMargin - bottomMargin;
            size.height = [self gtuiValidMeasure:lsc.heightSizeInner sbv:self calcSize:size.height sbvSize:size selfLayoutSize:rectSuper.size];
            
        }
        
        if (size.height < 0)
        {
            size.height = 0;
        }
        
    }
    
    
    return size;
}


-(BOOL)gtuiUpdateLayoutRectInNoLayoutSuperview:(UIView*)newSuperview
{
    BOOL isAdjust = NO;
    
    CGRect rectSuper = newSuperview.bounds;
    
    UIView *lsc = self.gtuiCurrentSizeClass;
    
    CGFloat leadingMargin = [lsc.leadingPosInner realPosIn:rectSuper.size.width];
    CGFloat trailingMargin = [lsc.trailingPosInner realPosIn:rectSuper.size.width];
    CGFloat topMargin = [lsc.topPosInner realPosIn:rectSuper.size.height];
    CGFloat bottomMargin = [lsc.bottomPosInner realPosIn:rectSuper.size.height];
    CGRect rectSelf = self.bounds;
    
    //得到在设置center后的原始值。
    rectSelf.origin.y = self.center.y - rectSelf.size.height * self.layer.anchorPoint.y;
    rectSelf.origin.x = self.center.x - rectSelf.size.width * self.layer.anchorPoint.x;
    CGRect oldRectSelf = rectSelf;
    
    //确定左右边距和宽度。
    if (lsc.widthSizeInner.dimeVal != nil)
    {
        lsc.wrapContentWidth = NO;
        
        if (lsc.widthSizeInner.dimeRelaVal != nil)
        {
            if (lsc.widthSizeInner.dimeRelaVal.view == newSuperview)
            {
                if (lsc.widthSizeInner.dimeRelaVal.dime == GTUIGravityHorzFill)
                    rectSelf.size.width = [lsc.widthSizeInner measureWith:rectSuper.size.width];
                else
                    rectSelf.size.width = [lsc.widthSizeInner measureWith:rectSuper.size.height];
                
            }
            else
            {
                rectSelf.size.width = [lsc.widthSizeInner measureWith:lsc.widthSizeInner.dimeRelaVal.view.estimatedRect.size.width];
            }
            isAdjust = YES;
        }
        else
            rectSelf.size.width = lsc.widthSizeInner.measure;
        
    }
    
    //这里要判断自己的宽度设置了最小和最大宽度依赖于父视图的情况。如果有这种情况，则父视图在变化时也需要调整自身。
    if (lsc.widthSizeInner.lBoundValInner.dimeRelaVal.view == newSuperview || lsc.widthSizeInner.uBoundValInner.dimeRelaVal.view == newSuperview)
    {
        isAdjust = YES;
    }
    
    rectSelf.size.width = [self gtuiValidMeasure:lsc.widthSizeInner sbv:self calcSize:rectSelf.size.width sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
    
    if ([GTUIBaseLayout isRTL])
        rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width;
    
    
    if (lsc.leadingPosInner.posVal != nil && lsc.trailingPosInner.posVal != nil)
    {
        isAdjust = YES;
        lsc.wrapContentWidth = NO;
        rectSelf.size.width = rectSuper.size.width - leadingMargin - trailingMargin;
        rectSelf.size.width = [self gtuiValidMeasure:lsc.widthSizeInner sbv:self calcSize:rectSelf.size.width sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
        
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            
            //在ios11后如果是滚动视图的contentInsetAdjustmentBehavior设置为UIScrollViewContentInsetAdjustmentAlways
            //那么系统不管contentSize如何总是会将安全区域叠加到contentInsets所以这里的边距不应该是偏移的边距而是0
            UIScrollView *scrollSuperView = nil;
            if ([newSuperview isKindOfClass:[UIScrollView class]])
                scrollSuperView = (UIScrollView*)newSuperview;
            if (scrollSuperView != nil && lsc.leadingPosInner.isSafeAreaPos)
            {
                leadingMargin = lsc.leadingPosInner.offsetVal + ([GTUIBaseLayout isRTL] ? scrollSuperView.safeAreaInsets.right : scrollSuperView.safeAreaInsets.left) - ([GTUIBaseLayout isRTL] ? scrollSuperView.adjustedContentInset.right : scrollSuperView.adjustedContentInset.left);
            }
        }
#endif
        
        rectSelf.origin.x = leadingMargin;
    }
    else if (lsc.centerXPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.x = (rectSuper.size.width - rectSelf.size.width)/2;
        rectSelf.origin.x += [lsc.centerXPosInner realPosIn:rectSuper.size.width];
    }
    else if (lsc.leadingPosInner.posVal != nil)
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            
            //iOS11中的滚动条的安全区会叠加到contentInset里面。因此这里要特殊处理，让x轴的开始位置不应该算偏移。
            UIScrollView *scrollSuperView = nil;
            if ([newSuperview isKindOfClass:[UIScrollView class]])
                scrollSuperView = (UIScrollView*)newSuperview;
            if (scrollSuperView != nil && lsc.leadingPosInner.isSafeAreaPos)
            {
                leadingMargin = lsc.leadingPosInner.offsetVal + ([GTUIBaseLayout isRTL] ? scrollSuperView.safeAreaInsets.right : scrollSuperView.safeAreaInsets.left) - ([GTUIBaseLayout isRTL] ? scrollSuperView.adjustedContentInset.right : scrollSuperView.adjustedContentInset.left);
            }
        }
#endif
        rectSelf.origin.x = leadingMargin;
    }
    else if (lsc.trailingPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.x  = rectSuper.size.width - rectSelf.size.width - trailingMargin;
    }
    else;
    
    
    if (lsc.heightSizeInner.dimeVal != nil)
    {
        lsc.wrapContentHeight = NO;
        
        if (lsc.heightSizeInner.dimeRelaVal != nil)
        {
            if (lsc.heightSizeInner.dimeRelaVal.view == newSuperview)
            {
                if (lsc.heightSizeInner.dimeRelaVal.dime == GTUIGravityVertFill)
                    rectSelf.size.height = [lsc.heightSizeInner measureWith:rectSuper.size.height];
                else
                    rectSelf.size.height = [lsc.heightSizeInner measureWith:rectSuper.size.width];
            }
            else
            {
                rectSelf.size.height = [lsc.heightSizeInner measureWith:lsc.heightSizeInner.dimeRelaVal.view.estimatedRect.size.height];
            }
            isAdjust = YES;
        }
        else
            rectSelf.size.height = lsc.heightSizeInner.measure;
    }
    
    //这里要判断自己的高度设置了最小和最大高度依赖于父视图的情况。如果有这种情况，则父视图在变化时也需要调整自身。
    if (lsc.heightSizeInner.lBoundValInner.dimeRelaVal.view == newSuperview || lsc.heightSizeInner.uBoundValInner.dimeRelaVal.view == newSuperview)
    {
        isAdjust = YES;
    }
    
    rectSelf.size.height = [self gtuiValidMeasure:lsc.heightSizeInner sbv:self calcSize:rectSelf.size.height sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
    
    if (lsc.topPosInner.posVal != nil && lsc.bottomPosInner.posVal != nil)
    {
        isAdjust = YES;
        lsc.wrapContentHeight = NO;
        rectSelf.size.height = rectSuper.size.height - topMargin - bottomMargin;
        rectSelf.size.height = [self gtuiValidMeasure:lsc.heightSizeInner sbv:self calcSize:rectSelf.size.height sbvSize:rectSelf.size selfLayoutSize:rectSuper.size];
        
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            
            //在ios11后如果是滚动视图的contentInsetAdjustmentBehavior设置为UIScrollViewContentInsetAdjustmentAlways
            //那么系统不管contentSize如何总是会将安全区域叠加到contentInsets所以这里的边距不应该是偏移的边距而是0
            UIScrollView *scrollSuperView = nil;
            if ([newSuperview isKindOfClass:[UIScrollView class]])
                scrollSuperView = (UIScrollView*)newSuperview;
            if (scrollSuperView != nil && lsc.topPosInner.isSafeAreaPos)
            {
                topMargin = lsc.topPosInner.offsetVal + scrollSuperView.safeAreaInsets.top - scrollSuperView.adjustedContentInset.top;
            }
        }
#endif
        
        rectSelf.origin.y = topMargin;
    }
    else if (lsc.centerYPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.y = (rectSuper.size.height - rectSelf.size.height)/2 + [lsc.centerYPosInner realPosIn:rectSuper.size.height];
    }
    else if (lsc.topPosInner.posVal != nil)
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            
            //在ios11后如果是滚动视图的contentInsetAdjustmentBehavior设置为UIScrollViewContentInsetAdjustmentAlways
            //那么系统不管contentSize如何总是会将安全区域叠加到contentInsets所以这里的边距不应该是偏移的边距而是0
            UIScrollView *scrollSuperView = nil;
            if ([newSuperview isKindOfClass:[UIScrollView class]])
                scrollSuperView = (UIScrollView*)newSuperview;
            if (scrollSuperView != nil && lsc.topPosInner.isSafeAreaPos)
            {
                topMargin = lsc.topPosInner.offsetVal + scrollSuperView.safeAreaInsets.top - scrollSuperView.adjustedContentInset.top;
            }
        }
#endif
        rectSelf.origin.y = topMargin;
    }
    else if (lsc.bottomPosInner.posVal != nil)
    {
        isAdjust = YES;
        rectSelf.origin.y  = rectSuper.size.height - rectSelf.size.height - bottomMargin;
    }
    else;
    
    if ([GTUIBaseLayout isRTL])
        rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width;
    
    rectSelf = _gtuiCGRectRound(rectSelf);
    if (!_gtuiCGRectEqual(rectSelf, oldRectSelf))
    {
        if (rectSelf.size.width < 0)
        {
            rectSelf.size.width = 0;
        }
        if (rectSelf.size.height < 0)
        {
            rectSelf.size.height = 0;
        }
        
        if (CGAffineTransformIsIdentity(self.transform))
        {
            self.frame = rectSelf;
        }
        else
        {
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,rectSelf.size.width, rectSelf.size.height);
            self.center = CGPointMake(rectSelf.origin.x + self.layer.anchorPoint.x * rectSelf.size.width, rectSelf.origin.y + self.layer.anchorPoint.y * rectSelf.size.height);
        }
    }
    else if (lsc.wrapContentWidth || lsc.wrapContentHeight)
    {
        [self setNeedsLayout];
    }
    
    
    
    return isAdjust;
    
}

-(CGFloat)gtuiHeightFromFlexedHeightView:(UIView*)sbv sbvsc:(UIView*)sbvsc inWidth:(CGFloat)width
{
    CGFloat h = [sbv sizeThatFits:CGSizeMake(width, 0)].height;
    if ([sbv isKindOfClass:[UIImageView class]])
    {
        //根据图片的尺寸进行等比缩放得到合适的高度。
        UIImage *img = ((UIImageView*)sbv).image;
        if (img != nil && img.size.width != 0)
        {
            h = img.size.height * (width / img.size.width);
        }
    }
    else if ([sbv isKindOfClass:[UIButton class]])
    {
        //按钮特殊处理多行的。。
        UIButton *button = (UIButton*)sbv;
        
        if (button.titleLabel != nil)
        {
            //得到按钮本身的高度，以及单行文本的高度，这样就能算出按钮和文本的间距
            CGSize buttonSize = [button sizeThatFits:CGSizeMake(0, 0)];
            CGSize buttonTitleSize = [button.titleLabel sizeThatFits:CGSizeMake(0, 0)];
            CGSize sz = [button.titleLabel sizeThatFits:CGSizeMake(width, 0)];
            h = sz.height + buttonSize.height - buttonTitleSize.height; //这个sz只是纯文本的高度，所以要加上原先按钮和文本的高度差。。
        }
    }
    else
        ;
    
    if (sbvsc.heightSizeInner == nil)
        return h;
    else
        return [sbvsc.heightSizeInner measureWith:h];
}


-(CGFloat)gtuiGetBoundLimitMeasure:(GTUILayoutSize*)boundDime sbv:(UIView*)sbv dimeType:(GTUIGravity)dimeType sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize isUBound:(BOOL)isUBound
{
    CGFloat value = isUBound ? CGFLOAT_MAX : -CGFLOAT_MAX;
    if (boundDime == nil)
        return value;
    
    GTUILayoutValueType lValueType = boundDime.dimeValType;
    if (lValueType == GTUILayoutValueTypeNSNumber)
    {
        value = boundDime.dimeNumVal.doubleValue;
    }
    else if (lValueType == GTUILayoutValueTypeLayoutDime)
    {
        if (boundDime.dimeRelaVal.view == self)
        {
            if (boundDime.dimeRelaVal.dime == GTUIGravityHorzFill)
                value = selfLayoutSize.width - (boundDime.dimeRelaVal.view == self ? (self.gtuiLayoutLeadingPadding + self.gtuiLayoutTrailingPadding) : 0);
            else
                value = selfLayoutSize.height - (boundDime.dimeRelaVal.view == self ? (self.gtuiLayoutTopPadding + self.gtuiLayoutBottomPadding) :0);
        }
        else if (boundDime.dimeRelaVal.view == sbv)
        {
            if (boundDime.dimeRelaVal.dime == dimeType)
            {
                //约束冲突：无效的边界设置方法
                NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
            }
            else
            {
                if (boundDime.dimeRelaVal.dime == GTUIGravityHorzFill)
                    value = sbvSize.width;
                else
                    value = sbvSize.height;
            }
        }
        else if (boundDime.dimeSelfVal != nil)
        {
            if (dimeType == GTUIGravityHorzFill)
                value = sbvSize.width;
            else
                value = sbvSize.height;
        }
        else
        {
            if (boundDime.dimeRelaVal.dime == GTUIGravityHorzFill)
            {
                value = boundDime.dimeRelaVal.view.estimatedRect.size.width;
            }
            else
            {
                value = boundDime.dimeRelaVal.view.estimatedRect.size.height;
            }
        }
        
    }
    else
    {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
    }
    
    if (value == CGFLOAT_MAX || value == -CGFLOAT_MAX)
        return value;
    
    return  [boundDime measureWith:value];
    
}



-(CGFloat)gtuiValidMeasure:(GTUILayoutSize*)dime sbv:(UIView*)sbv calcSize:(CGFloat)calcSize sbvSize:(CGSize)sbvSize selfLayoutSize:(CGSize)selfLayoutSize
{
    if (dime == nil)
        return calcSize;
    
    //算出最大最小值。
    CGFloat min = dime.isActive? [self gtuiGetBoundLimitMeasure:dime.lBoundValInner sbv:sbv dimeType:dime.dime sbvSize:sbvSize selfLayoutSize:selfLayoutSize isUBound:NO] : -CGFLOAT_MAX;
    CGFloat max = dime.isActive ?  [self gtuiGetBoundLimitMeasure:dime.uBoundValInner sbv:sbv dimeType:dime.dime sbvSize:sbvSize selfLayoutSize:selfLayoutSize isUBound:YES] : CGFLOAT_MAX;
    
    calcSize = _gtuiCGFloatMax(min, calcSize);
    calcSize = _gtuiCGFloatMin(max, calcSize);
    
    return calcSize;
}


-(CGFloat)gtuiGetBoundLimitMargin:(GTUILayoutPosition*)boundPos sbv:(UIView*)sbv selfLayoutSize:(CGSize)selfLayoutSize
{
    CGFloat value = 0;
    if (boundPos == nil)
        return value;
    
    GTUILayoutValueType lValueType = boundPos.posValType;
    if (lValueType == GTUILayoutValueTypeNSNumber)
        value = boundPos.posNumVal.doubleValue;
    else if (lValueType == GTUILayoutValueTypeLayoutPos)
    {
        CGRect rect = boundPos.posRelaVal.view.gtuiFrame.frame;
        
        GTUIGravity pos = boundPos.posRelaVal.pos;
        if (pos == GTUIGravityHorzLeading)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMinX(rect);
        }
        else if (pos == GTUIGravityHorzCenter)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMidX(rect);
        }
        else if (pos == GTUIGravityHorzTrailing)
        {
            if (rect.origin.x != CGFLOAT_MAX)
                value = CGRectGetMaxX(rect);
        }
        else if (pos == GTUIGravityVertTop)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMinY(rect);
        }
        else if (pos == GTUIGravityVertCenter)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMidY(rect);
        }
        else if (pos == GTUIGravityVertBottom)
        {
            if (rect.origin.y != CGFLOAT_MAX)
                value = CGRectGetMaxY(rect);
        }
    }
    else
    {
        //约束冲突：无效的边界设置方法
        NSCAssert(0, @"Constraint exception!! %@ has invalid lBound or uBound setting",sbv);
    }
    
    return value + boundPos.offsetVal;
}


-(CGFloat)gtuiValidMargin:(GTUILayoutPosition*)pos sbv:(UIView*)sbv calcPos:(CGFloat)calcPos selfLayoutSize:(CGSize)selfLayoutSize
{
    if (pos == nil)
        return calcPos;
    
    //算出最大最小值
    CGFloat min = (pos.isActive && pos.lBoundValInner != nil) ? [self gtuiGetBoundLimitMargin:pos.lBoundValInner sbv:sbv selfLayoutSize:selfLayoutSize] : -CGFLOAT_MAX;
    CGFloat max = (pos.isActive && pos.uBoundValInner != nil) ? [self gtuiGetBoundLimitMargin:pos.uBoundValInner sbv:sbv selfLayoutSize:selfLayoutSize] : CGFLOAT_MAX;
    
    calcPos = _gtuiCGFloatMax(min, calcPos);
    calcPos = _gtuiCGFloatMin(max, calcPos);
    return calcPos;
}

-(BOOL)gtuiIsNoLayoutSubview:(UIView*)sbv
{
    UIView *sbvsc = sbv.gtuiCurrentSizeClass;
    
    if (sbvsc.useFrame)
        return YES;
    
    if (sbv.isHidden)
    {
        return sbvsc.gtui_visibility != GTUIVisibilityInvisible;
    }
    else
    {
        return sbvsc.gtui_visibility == GTUIVisibilityGone;
    }
    
}

-(NSMutableArray*)gtuiGetLayoutSubviews
{
    return [self gtuiGetLayoutSubviewsFrom:self.subviews];
}

-(NSMutableArray*)gtuiGetLayoutSubviewsFrom:(NSArray*)sbsFrom
{
    NSMutableArray *sbs = [NSMutableArray arrayWithCapacity:sbsFrom.count];
    BOOL isReverseLayout = self.reverseLayout;
    
    if (isReverseLayout)
    {
        [sbs addObjectsFromArray:[sbsFrom reverseObjectEnumerator].allObjects];
    }
    else
    {
        [sbs addObjectsFromArray:sbsFrom];
        
    }
    
    for (NSInteger i = sbs.count - 1; i >=0; i--)
    {
        UIView *sbv = sbs[i];
        if ([self gtuiIsNoLayoutSubview:sbv])
        {
            [sbs removeObjectAtIndex:i];
        }
    }
    
    return sbs;
    
}

-(void)gtuiSetSubviewRelativeDimeSize:(GTUILayoutSize*)dime selfSize:(CGSize)selfSize lsc:(GTUIBaseLayout*)lsc pRect:(CGRect*)pRect
{
    if (dime.dimeRelaVal == nil)
        return;
    
    if (dime.dime == GTUIGravityHorzFill)
    {
        
        if (dime.dimeRelaVal == lsc.widthSizeInner && !lsc.wrapContentWidth)
            pRect->size.width = [dime measureWith:(selfSize.width - lsc.gtuiLayoutLeadingPadding - lsc.gtuiLayoutTrailingPadding)];
        else if (dime.dimeRelaVal == lsc.heightSizeInner)
            pRect->size.width = [dime measureWith:(selfSize.height - lsc.gtuiLayoutTopPadding - lsc.gtuiLayoutBottomPadding)];
        else if (dime.dimeRelaVal == dime.view.heightSizeInner)
            pRect->size.width = [dime measureWith:pRect->size.height];
        else if (dime.dimeRelaVal.dime == GTUIGravityHorzFill)
            pRect->size.width = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.width];
        else
            pRect->size.width = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.height];
    }
    else
    {
        if (dime.dimeRelaVal == lsc.heightSizeInner && !lsc.wrapContentHeight)
            pRect->size.height = [dime measureWith:(selfSize.height - lsc.gtuiLayoutTopPadding - lsc.gtuiLayoutBottomPadding)];
        else if (dime.dimeRelaVal == lsc.widthSizeInner)
            pRect->size.height = [dime measureWith:(selfSize.width - lsc.gtuiLayoutLeadingPadding - lsc.gtuiLayoutTrailingPadding)];
        else if (dime.dimeRelaVal == dime.view.widthSizeInner)
            pRect->size.height = [dime measureWith:pRect->size.width];
        else if (dime.dimeRelaVal.dime == GTUIGravityHorzFill)
            pRect->size.height = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.width];
        else
            pRect->size.height = [dime measureWith:dime.dimeRelaVal.view.estimatedRect.size.height];
    }
}

-(CGSize)gtuiAdjustSizeWhenNoSubviews:(CGSize)size sbs:(NSArray *)sbs lsc:(GTUIBaseLayout*)lsc
{
    //如果没有子视图，并且padding不参与空子视图尺寸计算则尺寸应该扣除padding的值。
    if (sbs.count == 0 && !lsc.zeroPadding)
    {
        if (lsc.wrapContentWidth)
            size.width -= (lsc.gtuiLayoutLeadingPadding + lsc.gtuiLayoutTrailingPadding);
        if (lsc.wrapContentHeight)
            size.height -= (lsc.gtuiLayoutTopPadding + lsc.gtuiLayoutBottomPadding);
    }
    
    return size;
}

- (void)gtuiAdjustLayoutSelfSize:(CGSize *)pSelfSize lsc:(GTUIBaseLayout*)lsc
{
    //调整自己的尺寸。
    pSelfSize->height = [self gtuiValidMeasure:lsc.heightSizeInner sbv:self calcSize:pSelfSize->height sbvSize:*pSelfSize selfLayoutSize:self.superview.bounds.size];
    
    pSelfSize->width = [self gtuiValidMeasure:lsc.widthSizeInner sbv:self calcSize:pSelfSize->width sbvSize:*pSelfSize selfLayoutSize:self.superview.bounds.size];
}

-(void)gtuiAdjustSubviewsRTLPos:(NSArray*)sbs selfWidth:(CGFloat)selfWidth
{
    if ([GTUIBaseLayout isRTL])
    {
        for (UIView *sbv in sbs)
        {
            GTUIFrame *gtuiFrame = sbv.gtuiFrame;
            
            gtuiFrame.leading = selfWidth - gtuiFrame.leading - gtuiFrame.width;
            gtuiFrame.trailing = gtuiFrame.leading + gtuiFrame.width;
            
        }
    }
}


-(void)gtuiAdjustSubviewsLayoutTransform:(NSArray*)sbs lsc:(GTUIBaseLayout*)lsc selfWidth:(CGFloat)selfWidth selfHeight:(CGFloat)selfHeight
{
    CGAffineTransform layoutTransform = lsc.layoutTransform;
    if (!CGAffineTransformIsIdentity(layoutTransform))
    {
        for (UIView *sbv in sbs)
        {
            GTUIFrame *gtuiFrame = sbv.gtuiFrame;
            
            //取子视图中心点坐标。因为这个坐标系的原点是布局视图的左上角，所以要转化为数学坐标系的原点坐标, 才能应用坐标变换。
            CGPoint centerPoint = CGPointMake(gtuiFrame.leading + gtuiFrame.width / 2 - selfWidth / 2,
                                              gtuiFrame.top + gtuiFrame.height / 2 - selfHeight / 2);
            
            //应用坐标变换
            centerPoint = CGPointApplyAffineTransform(centerPoint, layoutTransform);
            
            //还原为左上角坐标系。
            centerPoint.x +=  selfWidth / 2;
            centerPoint.y += selfHeight / 2;
            
            //根据中心点的变化调整开始和结束位置。
            gtuiFrame.leading = centerPoint.x - gtuiFrame.width / 2;
            gtuiFrame.trailing = gtuiFrame.leading + gtuiFrame.width;
            gtuiFrame.top = centerPoint.y - gtuiFrame.height / 2;
            gtuiFrame.bottom = gtuiFrame.top + gtuiFrame.height;
        }
    }
}

-(GTUIGravity)gtuiConvertLeftRightGravityToLeadingTrailing:(GTUIGravity)horzGravity
{
    if (horzGravity == GTUIGravityHorzLeft)
    {
        if ([GTUIBaseLayout isRTL])
            return GTUIGravityHorzTrailing;
        else
            return GTUIGravityHorzLeading;
    }
    else if (horzGravity == GTUIGravityHorzRight)
    {
        if ([GTUIBaseLayout isRTL])
            return GTUIGravityHorzLeading;
        else
            return GTUIGravityHorzTrailing;
    }
    else
        return horzGravity;
    
}

-(UIFont*)gtuiGetSubviewFont:(UIView*)sbv
{
    UIFont *sbvFont = nil;
    if ([sbv isKindOfClass:[UILabel class]] ||
        [sbv isKindOfClass:[UITextField class]] ||
        [sbv isKindOfClass:[UITextView class]] ||
        [sbv isKindOfClass:[UIButton class]])
    {
        sbvFont = [sbv valueForKey:@"font"];
    }
    
    return sbvFont;
}

-(CGFloat)gtuiLayoutTopPadding
{
    return self.gtuiCurrentSizeClass.gtuiLayoutTopPadding;
}
-(CGFloat)gtuiLayoutBottomPadding
{
    return self.gtuiCurrentSizeClass.gtuiLayoutBottomPadding;
}
-(CGFloat)gtuiLayoutLeftPadding
{
    return self.gtuiCurrentSizeClass.gtuiLayoutLeftPadding;
}
-(CGFloat)gtuiLayoutRightPadding
{
    return self.gtuiCurrentSizeClass.gtuiLayoutRightPadding;
}
-(CGFloat)gtuiLayoutLeadingPadding
{
    return self.gtuiCurrentSizeClass.gtuiLayoutLeadingPadding;
}
-(CGFloat)gtuiLayoutTrailingPadding
{
    return self.gtuiCurrentSizeClass.gtuiLayoutTrailingPadding;
}


- (void)gtuiAlterScrollViewContentSize:(CGSize)newSize lsc:(GTUIBaseLayout*)lsc
{
    if (self.adjustScrollViewContentSizeMode == GTUIAdjustScrollViewContentSizeModeYes && self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrolv = (UIScrollView*)self.superview;
        CGSize contsize = scrolv.contentSize;
        CGRect rectSuper = scrolv.bounds;
        
        //这里把自己在父视图中的上下左右边距也算在contentSize的包容范围内。
        CGFloat leadingMargin = [lsc.leadingPosInner realPosIn:rectSuper.size.width];
        CGFloat trailingMargin = [lsc.trailingPosInner realPosIn:rectSuper.size.width];
        CGFloat topMargin = [lsc.topPosInner realPosIn:rectSuper.size.height];
        CGFloat bottomMargin = [lsc.bottomPosInner realPosIn:rectSuper.size.height];
        
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        if (@available(iOS 11.0, *)) {
            if (/*scrolv.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentAlways*/ 1)
            {
                if (lsc.leadingPosInner.isSafeAreaPos)
                    leadingMargin = lsc.leadingPosInner.offsetVal;// + scrolv.safeAreaInsets.left - scrolv.adjustedContentInset.left;
                
                if (lsc.trailingPosInner.isSafeAreaPos)
                    trailingMargin = lsc.trailingPosInner.offsetVal;// + scrolv.safeAreaInsets.right - scrolv.adjustedContentInset.right;
                
                if (lsc.topPosInner.isSafeAreaPos)
                    topMargin = lsc.topPosInner.offsetVal;
                
                if (lsc.bottomPosInner.isSafeAreaPos)
                    bottomMargin = lsc.bottomPosInner.offsetVal;
            }
        }
#endif
        
        
        
        if (contsize.height != newSize.height + topMargin + bottomMargin)
            contsize.height = newSize.height + topMargin + bottomMargin;
        if (contsize.width != newSize.width + leadingMargin + trailingMargin)
            contsize.width = newSize.width + leadingMargin + trailingMargin;
        
        //因为调整contentsize可能会调整contentOffset，所以为了保持一致性这里要还原掉原来的contentOffset
        CGPoint oldOffset = scrolv.contentOffset;
        if (!CGSizeEqualToSize(scrolv.contentSize, contsize))
            scrolv.contentSize =  contsize;
        
        if ((oldOffset.x <= 0 || oldOffset.x <= contsize.width - rectSuper.size.width) &&
            (oldOffset.y <= 0 || oldOffset.y <= contsize.height - rectSuper.size.height))
        {
            if (!CGPointEqualToPoint(scrolv.contentOffset, oldOffset))
            {
                scrolv.contentOffset = oldOffset;
            }
        }
    }
}

GTUISizeClass _gtuiGlobalSizeClass = 0xFF;

//获取全局的当前的SizeClass,减少获取次数的调用。
-(GTUISizeClass)gtuiGetGlobalSizeClass
{
    //找到最根部的父视图。
    if (_gtuiGlobalSizeClass == 0xFF || ![self.superview isKindOfClass:[GTUIBaseLayout class]])
    {
        GTUISizeClass sizeClass;
        if ([UIDevice currentDevice].systemVersion.floatValue < 8)
            sizeClass = GTUISizeClasshAny | GTUISizeClasswAny;
        else
            sizeClass = (GTUISizeClass)((self.traitCollection.verticalSizeClass << 2) | self.traitCollection.horizontalSizeClass);
#if TARGET_OS_IOS
        UIDeviceOrientation ori =   [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationIsPortrait(ori))
        {
            sizeClass |= GTUISizeClassPortrait;
        }
        else if (UIDeviceOrientationIsLandscape(ori))
        {
            sizeClass |= GTUISizeClassLandscape;
        }
        //如果 ori == UIDeviceOrientationUnknown 的话, 默认给竖屏设置
        else {
            sizeClass |= GTUISizeClassPortrait;
        };
#endif
        _gtuiGlobalSizeClass = sizeClass;
    }
    else
    {
        ;
    }
    
    return _gtuiGlobalSizeClass;
}

-(void)gtuiRemoveSubviewObserver:(UIView*)subview
{
    
    GTUIFrame *sbvgtuiFrame = objc_getAssociatedObject(subview, ASSOCIATEDOBJECT_KEY_gtuiLAYOUT_FRAME);
    if (sbvgtuiFrame != nil)
    {
        sbvgtuiFrame.sizeClass.viewLayoutCompleteBlock = nil;
        if (sbvgtuiFrame.hasObserver)
        {
            [subview removeObserver:self forKeyPath:@"hidden"];
            [subview removeObserver:self forKeyPath:@"frame"];
            
            //有时候我们可能会把滚动视图加入到布局视图中去，滚动视图的尺寸有可能设置为wrapContent,这样就会调整center。从而需要重新激发滚动视图的布局
            //这也就是为什么只监听center的原因了。布局子视图也是如此。
            if ([subview isKindOfClass:[GTUIBaseLayout class]] || [subview isKindOfClass:[UIScrollView class]])
            {
                [subview removeObserver:self forKeyPath:@"center"];
            }
            else if ([subview isKindOfClass:[UILabel class]])
            {
                [subview removeObserver:self forKeyPath:@"text"];
                [subview removeObserver:self forKeyPath:@"attributedText"];
            }
            else;
            
            sbvgtuiFrame.hasObserver = NO;
        }
    }
}

-(void)gtuiAddSubviewObserver:(UIView*)subview sbvgtuiFrame:(GTUIFrame*)sbvgtuiFrame
{
    
    if (!sbvgtuiFrame.hasObserver)
    {
        //添加hidden, frame,center的属性通知。
        [subview addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:_gtuiObserverContextA];
        [subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:_gtuiObserverContextA];
        if ([subview isKindOfClass:[GTUIBaseLayout class]] || [subview isKindOfClass:[UIScrollView class]])
        {
            [subview addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:_gtuiObserverContextA];
        }
        else if ([subview isKindOfClass:[UILabel class]])
        {//如果是UILabel则一旦设置了text和attributedText则
            
            [subview addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:_gtuiObserverContextB];
            [subview addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:_gtuiObserverContextB];
        }
        else;
        
        sbvgtuiFrame.hasObserver = YES;
        
    }
}


-(void)gtuiAdjustSubviewWrapContentSet:(UIView*)sbv isEstimate:(BOOL)isEstimate sbvgtuiFrame:(GTUIFrame*)sbvgtuiFrame sbvsc:(UIView*)sbvsc selfSize:(CGSize)selfSize sizeClass:(GTUISizeClass)sizeClass pHasSubLayout:(BOOL*)pHasSubLayout
{
    if (!isEstimate)
    {
        sbvgtuiFrame.frame = sbv.bounds;
        [self gtuiCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvgtuiFrame:sbvgtuiFrame];
    }
    
    if ([sbv isKindOfClass:[GTUIBaseLayout class]])
    {
        
        if (sbvsc.wrapContentHeight && (sbvsc.heightSizeInner.dimeVal != nil || (sbvsc.topPosInner.posVal != nil && sbvsc.bottomPosInner.posVal != nil)))
        {
            sbvsc.wrapContentHeight = NO;
        }
        
        if (sbvsc.wrapContentWidth && (sbvsc.widthSizeInner.dimeVal != nil || (sbvsc.leadingPosInner.posVal != nil && sbvsc.trailingPosInner.posVal != nil)))
        {
            sbvsc.wrapContentWidth = NO;
        }
        
        
        if (pHasSubLayout != nil && (sbvsc.wrapContentHeight || sbvsc.wrapContentWidth))
            *pHasSubLayout = YES;
        
        if (isEstimate && (sbvsc.wrapContentHeight || sbvsc.wrapContentWidth))
        {
            [(GTUIBaseLayout*)sbv sizeThatFits:sbvgtuiFrame.frame.size inSizeClass:sizeClass];
            if (sbvgtuiFrame.multiple)
            {
                sbvgtuiFrame.sizeClass = [sbv gtuiBestSizeClass:sizeClass]; //因为estimateLayoutRect执行后会还原，所以这里要重新设置
            }
        }
    }
    
}



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
        {
            rect.size.width = [sbvsc.widthSizeInner measureWith:selfSize.height - paddingTop - paddingBottom];
        }
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

-(void)gtuiHookSublayout:(GTUIBaseLayout *)sublayout borderlineRect:(CGRect *)pRect
{
    //do nothing...
}


@end


@implementation GTUIFrame

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _leading = CGFLOAT_MAX;
        _trailing = CGFLOAT_MAX;
        _top = CGFLOAT_MAX;
        _bottom = CGFLOAT_MAX;
        _width = CGFLOAT_MAX;
        _height = CGFLOAT_MAX;
    }
    
    return self;
}

-(void)reset
{
    _leading = CGFLOAT_MAX;
    _trailing = CGFLOAT_MAX;
    _top = CGFLOAT_MAX;
    _bottom = CGFLOAT_MAX;
    _width = CGFLOAT_MAX;
    _height = CGFLOAT_MAX;
}


-(CGRect)frame
{
    return CGRectMake(_leading, _top,_width, _height);
}

-(void)setFrame:(CGRect)frame
{
    _leading = frame.origin.x;
    _top = frame.origin.y;
    _width  = frame.size.width;
    _height = frame.size.height;
    _trailing = _leading + _width;
    _bottom = _top + _height;
}

-(BOOL)multiple
{
    return self.sizeClasses.count > 1;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"leading:%g, top:%g, width:%g, height:%g, trailing:%g, bottom:%g",_leading,_top,_width,_height,_trailing,_bottom];
}


@end


