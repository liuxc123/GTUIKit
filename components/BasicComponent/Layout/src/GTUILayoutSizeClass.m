//
//  GTUILayoutSizeClass.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUILayoutSizeClass.h"
#import "GTUILayoutPosition+Private.h"
#import "GTUILayoutSize+Private.h"
#import "GTUIGridNode.h"
#import "GTUIBaseLayout.h"

@interface GTUIViewSizeClass()

@property(nonatomic, assign) BOOL wrapWidth;
@property(nonatomic, assign) BOOL wrapHeight;

@end

@implementation GTUIViewSizeClass

BOOL _gtuiisRTL = NO;

+(BOOL)isRTL
{
    return _gtuiisRTL;
}

+(void)setIsRTL:(BOOL)isRTL
{
    _gtuiisRTL = isRTL;
}

-(id)init
{
    return [super init];
}

-(GTUILayoutPosition*)topPosInner
{
    return _topPos;
}

-(GTUILayoutPosition*)leadingPosInner
{
    return _leadingPos;
}


-(GTUILayoutPosition*)bottomPosInner
{
    return _bottomPos;
}

-(GTUILayoutPosition*)trailingPosInner
{
    return _trailingPos;
}

-(GTUILayoutPosition*)centerXPosInner
{
    return _centerXPos;
}

-(GTUILayoutPosition*)centerYPosInner
{
    return _centerYPos;
}

-(GTUILayoutPosition*)leftPosInner
{
    return [GTUIViewSizeClass isRTL] ? self.trailingPosInner : self.leadingPosInner;
}

-(GTUILayoutPosition*)rightPosInner
{
    return [GTUIViewSizeClass isRTL] ? self.leadingPosInner : self.trailingPosInner;
}

-(GTUILayoutPosition*)baselinePosInner
{
    return _baselinePos;
}

-(GTUILayoutSize*)widthSizeInner
{
    return _widthSize;
}


-(GTUILayoutSize*)heightSizeInner
{
    return _heightSize;
}



//..

-(GTUILayoutPosition*)topPos
{
    if (_topPos == nil)
    {
        _topPos = [GTUILayoutPosition new];
        _topPos.view = self.view;
        _topPos.pos = GTUIGravityVertTop;
        
    }
    
    return _topPos;
}

-(GTUILayoutPosition*)leadingPos
{
    if (_leadingPos == nil)
    {
        _leadingPos = [GTUILayoutPosition new];
        _leadingPos.view = self.view;
        _leadingPos.pos = GTUIGravityHorzLeading;
    }
    
    return _leadingPos;
}


-(GTUILayoutPosition*)bottomPos
{
    if (_bottomPos == nil)
    {
        _bottomPos = [GTUILayoutPosition new];
        _bottomPos.view = self.view;
        _bottomPos.pos = GTUIGravityVertBottom;
        
    }
    
    return _bottomPos;
}


-(GTUILayoutPosition*)trailingPos
{
    if (_trailingPos == nil)
    {
        _trailingPos = [GTUILayoutPosition new];
        _trailingPos.view = self.view;
        _trailingPos.pos = GTUIGravityHorzTrailing;
    }
    
    return _trailingPos;
    
}


-(GTUILayoutPosition*)centerXPos
{
    if (_centerXPos == nil)
    {
        _centerXPos = [GTUILayoutPosition new];
        _centerXPos.view = self.view;
        _centerXPos.pos = GTUIGravityHorzCenter;
        
    }
    
    return _centerXPos;
}

-(GTUILayoutPosition*)centerYPos
{
    if (_centerYPos == nil)
    {
        _centerYPos = [GTUILayoutPosition new];
        _centerYPos.view = self.view;
        _centerYPos.pos = GTUIGravityVertCenter;
        
    }
    
    return _centerYPos;
}



-(GTUILayoutPosition*)leftPos
{
    return [GTUIViewSizeClass isRTL] ? self.trailingPos : self.leadingPos;
}

-(GTUILayoutPosition*)rightPos
{
    return [GTUIViewSizeClass isRTL] ? self.leadingPos : self.trailingPos;
}

-(GTUILayoutPosition*)baselinePos
{
    if (_baselinePos == nil)
    {
        _baselinePos = [GTUILayoutPosition new];
        _baselinePos.view = self.view;
        _baselinePos.pos = GTUIGravityVertBaseline;
    }
    
    return _baselinePos;
}



-(CGFloat)gtui_top
{
    return self.topPosInner.absVal;
}

- (void)setGtui_top:(CGFloat)gtui_top
{
    [self.topPos __equalTo:@(gtui_top)];
}

-(CGFloat)gtui_leading
{
    return self.leadingPosInner.absVal;
}

- (void)setGtui_leading:(CGFloat)gtui_leading
{
    [self.leadingPos __equalTo:@(gtui_leading)];
}


-(CGFloat)gtui_bottom
{
    return self.bottomPosInner.absVal;
}

- (void)setGtui_bottom:(CGFloat)gtui_bottom
{
    [self.bottomPos __equalTo:@(gtui_bottom)];
}

-(CGFloat)gtui_trailing
{
    return self.trailingPosInner.absVal;
}

- (void)setGtui_trailing:(CGFloat)gtui_trailing
{
    [self.trailingPos __equalTo:@(gtui_trailing)];
}

-(CGFloat)gtui_centerX
{
    return self.centerXPosInner.absVal;
}

- (void)setGtui_centerX:(CGFloat)gtui_centerX
{
    [self.centerXPos __equalTo:@(gtui_centerX)];
}

- (CGFloat)gtui_centerY
{
    return self.centerYPosInner.absVal;
}

- (void)setGtui_centerY:(CGFloat)gtui_centerY
{
    [self.centerYPos __equalTo:@(gtui_centerY)];
}

-(CGPoint)gtui_center
{
    return CGPointMake(self.gtui_centerX, self.gtui_centerY);
}

-(void)setGtui_center:(CGPoint)gtui_center
{
    self.gtui_centerX = gtui_center.x;
    self.gtui_centerY = gtui_center.y;
}

- (CGFloat)gtui_left
{
    return self.leftPosInner.absVal;
}

- (void)setGtui_left:(CGFloat)gtui_left
{
    [self.leftPos __equalTo:@(gtui_left)];
}

-(CGFloat)gtui_right
{
    return self.rightPosInner.absVal;
}

-(void)setGtui_right:(CGFloat)gtui_right
{
    [self.rightPos __equalTo:@(gtui_right)];
}




-(CGFloat)gtui_margin
{
    return self.leftPosInner.absVal;
}

- (void)setGtui_margin:(CGFloat)gtui_margin
{
    [self.topPos __equalTo:@(gtui_margin)];
    [self.leftPos __equalTo:@(gtui_margin)];
    [self.rightPos __equalTo:@(gtui_margin)];
    [self.bottomPos __equalTo:@(gtui_margin)];
}


-(CGFloat)gtui_horzMargin
{
    return self.leftPosInner.absVal;
}

-(void)setGtui_horzMargin:(CGFloat)gtui_horzMargin
{
    [self.leftPos __equalTo:@(gtui_horzMargin)];
    [self.rightPos __equalTo:@(gtui_horzMargin)];
}

-(CGFloat)gtui_vertMargin
{
    return self.topPosInner.absVal;
}

-(void)setGtui_vertMargin:(CGFloat)gtui_vertMargin
{
    [self.topPos __equalTo:@(gtui_vertMargin)];
    [self.bottomPos __equalTo:@(gtui_vertMargin)];
}




-(GTUILayoutSize*)widthSize
{
    if (_widthSize == nil)
    {
        _widthSize = [GTUILayoutSize new];
        _widthSize.view = self.view;
        _widthSize.dime = GTUIGravityHorzFill;
        
    }
    
    return _widthSize;
}


-(GTUILayoutSize*)heightSize
{
    if (_heightSize == nil)
    {
        _heightSize = [GTUILayoutSize new];
        _heightSize.view = self.view;
        _heightSize.dime = GTUIGravityVertFill;
        
    }
    
    return _heightSize;
}


-(CGFloat)gtui_width
{
    return self.widthSizeInner.measure;
}

-(void)setGtui_width:(CGFloat)width
{
    [self.widthSize __equalTo:@(width)];
}

-(CGFloat)gtui_height
{
    return self.heightSizeInner.measure;
}

-(void)setGtui_height:(CGFloat)height
{
    [self.heightSize __equalTo:@(height)];
}

-(CGSize)gtui_size
{
    return CGSizeMake(self.gtui_Width, self.gtui_height);
}

-(void)setGtui_size:(CGSize)gtui_size
{
    self.gtui_width = gtui_size.width;
    self.gtui_height = gtui_size.height;
}



-(void)setWeight:(CGFloat)weight
{
    if (weight < 0)
        weight = 0;
    
    if (_weight != weight)
        _weight = weight;
}

-(BOOL)wrapContentWidth
{
    return self.wrapWidth;
}

-(BOOL)wrapContentHeight
{
    return self.wrapHeight;
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    if (self.wrapWidth != wrapContentWidth)
    {
        self.wrapWidth = wrapContentWidth;
        
        if (wrapContentWidth)
        {
#ifdef GTUI_USEPREFIXMETHOD
            self.widthSize.gtui_equalTo(self.widthSize);
#else
            self.widthSize.equalTo(self.widthSize);
#endif
        }
        else
        {
            if (self.widthSizeInner.dimeSelfVal != nil)
            {
#ifdef GTUI_USEPREFIXMETHOD
                self.widthSizeInner.equalTo(nil);
#else
                self.widthSizeInner.equalTo(nil);
#endif
            }
        }
    }
}


-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    if (self.wrapHeight != wrapContentHeight)
    {
        self.wrapHeight = wrapContentHeight;
        
        if (wrapContentHeight)
        {
            if([_view isKindOfClass:[UILabel class]])
            {
                if (((UILabel*)_view).numberOfLines == 1)
                    ((UILabel*)_view).numberOfLines = 0;
            }
        }
    }
}

-(BOOL)wrapContentSize
{
    return self.wrapContentWidth && self.wrapContentHeight;
}


-(void)setWrapContentSize:(BOOL)wrapContentSize
{
    self.wrapContentWidth = self.wrapContentHeight = wrapContentSize;
}




-(NSString*)debugDescription
{
    
    NSString*dbgDesc = [NSString stringWithFormat:@"\nView:\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\nweight=%f\nuseFrame=%@\nnoLayout=%@\ngtui_visibility=%lu\ngtui_alignment=%lu\nwrapContentWidth=%@\nwrapContentHeight=%@\nreverseFloat=%@\nclearFloat=%@",
                        self.topPosInner,
                        self.leadingPosInner,
                        self.bottomPosInner,
                        self.trailingPosInner,
                        self.centerXPosInner,
                        self.centerYPosInner,
                        self.widthSizeInner,
                        self.heightSizeInner,
                        self.weight,
                        self.useFrame ? @"YES":@"NO",
                        self.noLayout? @"YES":@"NO",
                        (unsigned long)self.gtui_visibility,
                        (unsigned long)self.gtui_alignment,
                        self.wrapContentWidth ? @"YES":@"NO",
                        self.wrapContentHeight ? @"YES":@"NO",
                        self.reverseFloat ? @"YES":@"NO",
                        self.clearFloat ? @"YES":@"NO"];
    
    
    return dbgDesc;
}


#pragma mark -- NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    GTUIViewSizeClass *lsc = [[[self class] allocWithZone:zone] init];
    
    
    //这里不会复制hidden属性
    lsc->_view = _view;
    lsc->_topPos = [self.topPosInner copy];
    lsc->_leadingPos = [self.leadingPosInner copy];
    lsc->_bottomPos = [self.bottomPosInner copy];
    lsc->_trailingPos = [self.trailingPosInner copy];
    lsc->_centerXPos = [self.centerXPosInner copy];
    lsc->_centerYPos = [self.centerYPosInner copy];
    lsc->_baselinePos = [self.baselinePos copy];
    lsc->_widthSize = [self.widthSizeInner copy];
    lsc->_heightSize = [self.heightSizeInner copy];
    lsc->_wrapWidth = self.wrapWidth;
    lsc->_wrapHeight = self.wrapHeight;
    lsc.useFrame = self.useFrame;
    lsc.noLayout = self.noLayout;
    lsc.gtui_visibility = self.gtui_visibility;
    lsc.gtui_alignment = self.gtui_alignment;
    lsc.weight = self.weight;
    lsc.reverseFloat = self.isReverseFloat;
    lsc.clearFloat = self.clearFloat;
    
    
    return lsc;
}


@end

@implementation GTUILayoutViewSizeClass

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _zeroPadding = YES;
        _insetsPaddingFromSafeArea = UIRectEdgeLeft | UIRectEdgeRight;
        _insetLandscapeFringePadding = NO;
        _layoutTransform = CGAffineTransformIdentity;
    }
    
    return self;
}

-(void)setWrapContentWidth:(BOOL)wrapContentWidth
{
    if (self.wrapWidth != wrapContentWidth)
    {
        self.wrapWidth = wrapContentWidth;
    }
    
}

-(void)setWrapContentHeight:(BOOL)wrapContentHeight
{
    if (self.wrapHeight != wrapContentHeight)
    {
        self.wrapHeight = wrapContentHeight;
    }
    
}



-(UIEdgeInsets)padding
{
    return UIEdgeInsetsMake(self.topPadding, self.leftPadding, self.bottomPadding, self.rightPadding);
}

-(void)setPadding:(UIEdgeInsets)padding
{
    self.topPadding = padding.top;
    self.leftPadding = padding.left;
    self.bottomPadding = padding.bottom;
    self.rightPadding = padding.right;
}

-(CGFloat)leftPadding
{
    return [GTUIViewSizeClass isRTL] ? self.trailingPadding : self.leadingPadding;
}

-(void)setLeftPadding:(CGFloat)leftPadding
{
    if ([GTUIViewSizeClass isRTL])
    {
        self.trailingPadding = leftPadding;
    }
    else
    {
        self.leadingPadding = leftPadding;
    }
}

-(CGFloat)rightPadding
{
    return [GTUIViewSizeClass isRTL] ? self.leadingPadding : self.trailingPadding;
}

-(void)setRightPadding:(CGFloat)rightPadding
{
    if ([GTUIViewSizeClass isRTL])
    {
        self.leadingPadding = rightPadding;
    }
    else
    {
        self.trailingPadding = rightPadding;
    }
}


-(CGFloat)gtuiLayoutTopPadding
{
    //如果padding值是特殊的值。
    if (self.topPadding >= GTUILayoutPosition.safeAreaMargin - 2000 && self.topPadding <= GTUILayoutPosition.safeAreaMargin + 2000)
    {
        
        CGFloat topPaddingAdd = 20.0; //默认高度是状态栏的高度。
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            topPaddingAdd = self.view.safeAreaInsets.top;
        }
#endif
        return  self.topPadding - GTUILayoutPosition.safeAreaMargin + topPaddingAdd;
    }
    
    if ((self.insetsPaddingFromSafeArea & UIRectEdgeTop) == UIRectEdgeTop)
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            return self.topPadding + self.view.safeAreaInsets.top;
        }
#endif
    }
    
    return self.topPadding;
}

-(CGFloat)gtuiLayoutBottomPadding
{
    //如果padding值是特殊的值。
    if (self.bottomPadding >= GTUILayoutPosition.safeAreaMargin - 2000 && self.bottomPadding <= GTUILayoutPosition.safeAreaMargin + 2000)
    {
        CGFloat bottomPaddingAdd = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            bottomPaddingAdd = self.view.safeAreaInsets.bottom;
        }
#endif
        return self.bottomPadding - GTUILayoutPosition.safeAreaMargin + bottomPaddingAdd;
    }
    
    if ((self.insetsPaddingFromSafeArea & UIRectEdgeBottom) == UIRectEdgeBottom )
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            
            return self.bottomPadding + self.view.safeAreaInsets.bottom;
        }
#endif
    }
    
    return self.bottomPadding;
}

-(CGFloat)gtuiLayoutLeadingPadding
{
    if (self.leadingPadding >= GTUILayoutPosition.safeAreaMargin - 2000 && self.leadingPadding <= GTUILayoutPosition.safeAreaMargin + 2000)
    {
        CGFloat leadingPaddingAdd = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            leadingPaddingAdd = self.view.safeAreaInsets.left; //因为这里左右的缩进都是一样的，因此不需要考虑RTL的情况。
        }
#endif
        return self.leadingPadding - GTUILayoutPosition.safeAreaMargin + leadingPaddingAdd;
    }
    
    
    CGFloat inset = 0;
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
    
    if (@available(iOS 11.0, *)) {
        
        UIRectEdge edge = [GTUIViewSizeClass isRTL]? UIRectEdgeRight:UIRectEdgeLeft;
#if TARGET_OS_IOS
        UIDeviceOrientation devori = [GTUIViewSizeClass isRTL]? UIDeviceOrientationLandscapeLeft: UIDeviceOrientationLandscapeRight;
#endif
        if ((self.insetsPaddingFromSafeArea & edge) == edge)
        {
#if TARGET_OS_IOS
            
            //如果只缩进刘海那一边。并且同时设置了左右缩进，并且当前刘海方向是尾部那么就不缩进了。
            if (self.insetLandscapeFringePadding &&
                (self.insetsPaddingFromSafeArea & (UIRectEdgeLeft | UIRectEdgeRight)) == (UIRectEdgeLeft | UIRectEdgeRight) &&
                [UIDevice currentDevice].orientation == devori)
            {
                inset = 0;
            }
            else
#endif
                inset = [GTUIViewSizeClass isRTL]? self.view.safeAreaInsets.right : self.view.safeAreaInsets.left;
        }
    }
#endif
    
    return self.leadingPadding + inset;
}

-(CGFloat)gtuiLayoutTrailingPadding
{
    if (self.trailingPadding >= GTUILayoutPosition.safeAreaMargin - 2000 && self.trailingPadding <= GTUILayoutPosition.safeAreaMargin + 2000)
    {
        CGFloat trailingPaddingAdd = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            trailingPaddingAdd = self.view.safeAreaInsets.right;
        }
#endif
        return self.trailingPadding - GTUILayoutPosition.safeAreaMargin + trailingPaddingAdd;
    }
    
    
    CGFloat inset = 0;
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
    
    if (@available(iOS 11.0, *)) {
        UIRectEdge edge = [GTUIViewSizeClass isRTL]? UIRectEdgeLeft:UIRectEdgeRight;
#if TARGET_OS_IOS
        UIDeviceOrientation devori = [GTUIViewSizeClass isRTL]? UIDeviceOrientationLandscapeRight: UIDeviceOrientationLandscapeLeft;
#endif
        if ((self.insetsPaddingFromSafeArea & edge) == edge)
        {
#if TARGET_OS_IOS
            //如果只缩进刘海那一边。并且同时设置了左右缩进，并且当前刘海方向是头部那么就不缩进了。
            if (self.insetLandscapeFringePadding &&
                (self.insetsPaddingFromSafeArea & (UIRectEdgeLeft | UIRectEdgeRight)) == (UIRectEdgeLeft | UIRectEdgeRight) &&
                [UIDevice currentDevice].orientation == devori)
            {
                inset = 0;
            }
            else
#endif
                inset = [GTUIViewSizeClass isRTL]? self.view.safeAreaInsets.left : self.view.safeAreaInsets.right;
        }
    }
#endif
    
    return self.trailingPadding + inset;
}

-(CGFloat)gtuiLayoutLeftPadding
{
    return [GTUIViewSizeClass isRTL] ? [self gtuiLayoutTrailingPadding] : [self gtuiLayoutLeadingPadding];
}
-(CGFloat)gtuiLayoutRightPadding
{
    return [GTUIViewSizeClass isRTL] ? [self gtuiLayoutLeadingPadding] : [self gtuiLayoutTrailingPadding];
}


-(CGFloat)subviewSpace
{
    return self.subviewVSpace;
}

-(void)setSubviewSpace:(CGFloat)subviewSpace
{
    self.subviewVSpace = subviewSpace;
    self.subviewHSpace = subviewSpace;
}


- (id)copyWithZone:(NSZone *)zone
{
    GTUILayoutViewSizeClass *lsc = [super copyWithZone:zone];
    lsc.topPadding = self.topPadding;
    lsc.leadingPadding = self.leadingPadding;
    lsc.bottomPadding = self.bottomPadding;
    lsc.trailingPadding = self.trailingPadding;
    lsc.zeroPadding = self.zeroPadding;
    lsc.insetsPaddingFromSafeArea = self.insetsPaddingFromSafeArea;
    lsc.insetLandscapeFringePadding = self.insetLandscapeFringePadding;
    lsc.gravity = self.gravity;
    lsc.reverseLayout = self.reverseLayout;
    lsc.layoutTransform = self.layoutTransform;
    lsc.subviewVSpace = self.subviewVSpace;
    lsc.subviewHSpace = self.subviewHSpace;
    
    return lsc;
}

-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nLayout:\npadding=%@\nzeroPadding=%@\ngravity=%lu\nreverseLayout=%@\nsubviewVertSpace=%f\nsubviewHorzSpace=%f",
               dbgDesc,
               NSStringFromUIEdgeInsets(self.padding),
               self.zeroPadding?@"YES":@"NO",
               (unsigned long)self.gravity,
               self.reverseLayout?@"YES":@"NO",
               self.subviewVSpace,
               self.subviewHSpace
               ];
    
    
    return dbgDesc;
}


@end


@implementation GTUISequentLayoutViewSizeClass



- (id)copyWithZone:(NSZone *)zone
{
    GTUISequentLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    lsc.orientation = self.orientation;
    
    
    return lsc;
}

-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nSequentLayout: \norientation=%lu",
               dbgDesc,
               (unsigned long)self.orientation
               ];
    
    
    return dbgDesc;
}



@end


@implementation GTUILinearLayoutViewSizeClass

- (id)copyWithZone:(NSZone *)zone
{
    GTUILinearLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    
    lsc.shrinkType = self.shrinkType;
    
    return lsc;
}

-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nLinearLayout: \nshrinkType=%lu",
               dbgDesc,
               (unsigned long)self.shrinkType
               ];
    
    
    return dbgDesc;
}



@end


@implementation GTUITableLayoutViewSizeClass

@end

@implementation GTUIFloatLayoutViewSizeClass

- (id)copyWithZone:(NSZone *)zone
{
    GTUIFloatLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    
    lsc.subviewSize = self.subviewSize;
    lsc.minSpace = self.minSpace;
    lsc.maxSpace = self.maxSpace;
    lsc.noBoundaryLimit = self.noBoundaryLimit;
    
    return lsc;
}


-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nFloatLayout: \nnoBoundaryLimit=%@",
               dbgDesc,
               self.noBoundaryLimit ? @"YES":@"NO"];
    
    return dbgDesc;
}



@end


@implementation GTUIFlowLayoutViewSizeClass

- (id)copyWithZone:(NSZone *)zone
{
    GTUIFlowLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    
    lsc.arrangedCount = self.arrangedCount;
    lsc.autoArrange = self.autoArrange;
    lsc.arrangedGravity = self.arrangedGravity;
    lsc.subviewSize = self.subviewSize;
    lsc.minSpace = self.minSpace;
    lsc.maxSpace = self.maxSpace;
    lsc.pagedCount = self.pagedCount;
    
    return lsc;
}


-(NSString*)debugDescription
{
    NSString *dbgDesc = [super debugDescription];
    
    dbgDesc = [NSString stringWithFormat:@"%@\nFlowLayout: \narrangedCount=%ld\nautoArrange=%@\narrangedGravity=%lu\npagedCount=%ld",
               dbgDesc,
               (long)self.arrangedCount,
               self.autoArrange ? @"YES":@"NO",
               (long)self.arrangedGravity,
               (long)self.pagedCount
               ];
    
    return dbgDesc;
}


@end


@implementation GTUIRelativeLayoutViewSizeClass

@end

@implementation GTUIFrameLayoutViewSizeClass



@end

@implementation GTUIPathLayoutViewSizeClass

@end


@interface GTUIGridLayoutViewSizeClass()<GTUIGridNode>

@property(nonatomic, strong) GTUIGridNode *rootGrid;

@end


@implementation GTUIGridLayoutViewSizeClass


-(GTUIGridNode*)rootGrid
{
    if (_rootGrid == nil)
    {
        _rootGrid = [[GTUIGridNode alloc] initWithMeasure:0 superGrid:nil];
    }
    return _rootGrid;
}

//添加行栅格，返回新的栅格。
-(id<GTUIGrid>)addRow:(CGFloat)measure
{
    id<GTUIGridNode> node = (id<GTUIGridNode>)[self.rootGrid addRow:measure];
    node.superGrid = self;
    return node;
}

//添加列栅格，返回新的栅格。
-(id<GTUIGrid>)addCol:(CGFloat)measure
{
    id<GTUIGridNode> node = (id<GTUIGridNode>)[self.rootGrid addCol:measure];
    node.superGrid = self;
    return node;
}

//添加栅格，返回被添加的栅格。这个方法和下面的cloneGrid配合使用可以用来构建那些需要重复添加栅格的场景。
-(id<GTUIGrid>)addRowGrid:(id<GTUIGrid>)grid
{
    id<GTUIGridNode> node = (id<GTUIGridNode>)[self.rootGrid addRowGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<GTUIGrid>)addColGrid:(id<GTUIGrid>)grid
{
    id<GTUIGridNode> node = (id<GTUIGridNode>)[self.rootGrid addColGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<GTUIGrid>)addRowGrid:(id<GTUIGrid>)grid measure:(CGFloat)measure
{
    id<GTUIGridNode> node = (id<GTUIGridNode>)[self.rootGrid addRowGrid:grid measure:measure];
    node.superGrid = self;
    return node;
    
}

-(id<GTUIGrid>)addColGrid:(id<GTUIGrid>)grid measure:(CGFloat)measure
{
    id<GTUIGridNode> node = (id<GTUIGridNode>)[self.rootGrid addColGrid:grid measure:measure];
    node.superGrid = self;
    return node;
    
}


//克隆出一个新栅格以及其下的所有子栅格。
-(id<GTUIGrid>)cloneGrid
{
    return nil;
}

//从父栅格中删除。
-(void)removeFromSuperGrid
{
}

//得到父栅格。
-(id<GTUIGrid>)superGrid
{
    return nil;
}

-(void)setSuperGrid:(id<GTUIGridNode>)superGrid
{
    
}

-(BOOL)placeholder
{
    return NO;
}

-(void)setPlaceholder:(BOOL)placeholder
{
}

-(BOOL)anchor
{
    return NO;
}

-(void)setAnchor:(BOOL)anchor
{
    //do nothing
}

-(GTUIGravity)overlap
{
    return self.gravity;
}

-(void)setOverlap:(GTUIGravity)overlap
{
    self.gravity = overlap;
}


-(NSInteger)tag
{
    return self.view.tag;
}

-(void)setTag:(NSInteger)tag
{
    self.view.tag = tag;
}

-(id)actionData
{
    return self.rootGrid.actionData;
}

-(void)setActionData:(id)actionData
{
    self.rootGrid.actionData = actionData;
}

-(void)setTarget:(id)target action:(SEL)action
{
    //do nothing.
}

//得到所有子栅格
-(NSArray<id<GTUIGrid>> *)subGrids
{
    return self.rootGrid.subGrids;
}


-(void)setSubGrids:(NSMutableArray *)subGrids
{
    self.rootGrid.subGrids = subGrids;
}

-(GTUISubGridsType)subGridsType
{
    return self.rootGrid.subGridsType;
}

-(void)setSubGridsType:(GTUISubGridsType)subGridsType
{
    self.rootGrid.subGridsType = subGridsType;
}


-(GTUIBorderline*)topBorderline
{
    return nil;
}

-(void)setTopBorderline:(GTUIBorderline *)topBorderline
{
}


-(GTUIBorderline*)bottomBorderline
{
    return nil;
}

-(void)setBottomBorderline:(GTUIBorderline *)bottomBorderline
{
}


-(GTUIBorderline*)leftBorderline
{
    return nil;
}

-(void)setLeftBorderline:(GTUIBorderline *)leftBorderline
{
}


-(GTUIBorderline*)rightBorderline
{
    return nil;
}

-(void)setRightBorderline:(GTUIBorderline *)rightBorderline
{
}

-(GTUIBorderline*)leadingBorderline
{
    return nil;
}

-(void)setLeadingBorderline:(GTUIBorderline *)leadingBorderline
{
    
}

-(GTUIBorderline*)trailingBorderline
{
    return nil;
}

-(void)setTrailingBorderline:(GTUIBorderline *)trailingBorderline
{
    
}


-(NSDictionary*)gridDictionary
{
    return [GTUIGridNode translateGridNode:self toGridDictionary:[NSMutableDictionary new]];
}

-(void)setGridDictionary:(NSDictionary *)gridDictionary
{
    GTUIGridNode *rootNode = self.rootGrid;
    [rootNode.subGrids removeAllObjects];
    rootNode.subGridsType = GTUISubGridsTypeUnknown;
    
    [self.view setNeedsLayout];
    
    if (gridDictionary == nil)
        return;
    
    [GTUIGridNode translateGridDicionary:gridDictionary toGridNode:self];
}

-(CGFloat)measure
{
    return GTUILayoutSize.fill;
    //return self.rootGrid.measure;
}

-(void)setMeasure:(CGFloat)measure
{
    //self.rootGrid.measure = measure;
}

-(CGRect)gridRect
{
    return self.rootGrid.gridRect;
}

-(void)setGridRect:(CGRect)gridRect
{
    self.rootGrid.gridRect = gridRect;
}

//更新格子尺寸。
-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<GTUIGridNode>)superGrid withMeasure:(CGFloat)measure
{
    return [self.rootGrid updateGridSize:superSize superGrid:superGrid withMeasure:measure];
}

-(CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<GTUIGridNode>)superGrid withOffset:(CGFloat)offset
{
    return [self.rootGrid updateGridOrigin:superOrigin superGrid:superGrid withOffset:offset];
}


-(UIView*)gridLayoutView
{
    return self.view;
}

-(SEL)gridAction
{
    return nil;
}

-(void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer *)layer
{
    [self.rootGrid setBorderlineNeedLayoutIn:rect withLayer:layer];
}

-(void)showBorderline:(BOOL)show
{
    [self.rootGrid showBorderline:show];
}

-(id<GTUIGridNode>)gridHitTest:(CGPoint)point
{
    return [self.rootGrid gridHitTest:point];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //do nothing;
}




- (id)copyWithZone:(NSZone *)zone
{
    GTUIGridLayoutViewSizeClass *lsc = [super copyWithZone:zone];
    lsc->_rootGrid = (GTUIGridNode*)[self.rootGrid cloneGrid];
    
    
    return lsc;
}


@end

