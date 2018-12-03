//
//  GTUILayoutPosition.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUILayoutPosition.h"
#import "GTUILayoutPosition+Private.h"
#import "GTUIBaseLayout.h"
#import "GTUILayoutMath.h"

@implementation GTUILayoutPosition
{
    id _posVal;
    CGFloat _offsetVal;
    GTUILayoutPosition *_lBoundVal;
    GTUILayoutPosition *_uBoundVal;
}

+(CGFloat)safeAreaMargin
{
    //在2018年12月02号定义的一个数字，没有其他特殊意义。
    return -20181202;
}

-(instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        _active = YES;
        _view = nil;
        _pos = GTUIGravityNone;
        _posVal = nil;
        _posValType = GTUILayoutValueTypeNil;
        _offsetVal = 0;
        _lBoundVal = nil;
        _uBoundVal = nil;
    }
    
    return self;
}

#pragma mark - Public Methods

-(GTUILayoutPosition* (^)(id val))gtui_equalTo
{
    return ^id(id val){
        
        return [self __equalTo:val];
    };
}


-(GTUILayoutPosition* (^)(CGFloat val))gtui_offset
{
    return ^id(CGFloat val){
        
        return [self __offset:val];
    };
}


-(GTUILayoutPosition* (^)(CGFloat val))gtui_min
{
    return ^id(CGFloat val){
        
        return [self __min:val];
    };
}


-(GTUILayoutPosition* (^)(CGFloat val))gtui_max
{
    return ^id(CGFloat val){
        
        return [self __max:val];
    };
}

-(GTUILayoutPosition* (^)(id posVal, CGFloat offset))gtui_lBound
{
    return ^id(id posVal, CGFloat offset){
        
        return [self __lBound:posVal offsetVal:offset];
    };
}

-(GTUILayoutPosition* (^)(id posVal, CGFloat offset))gtui_uBound
{
    return ^id(id posVal, CGFloat offset){
        
        return [self __uBound:posVal offsetVal:offset];
    };
}

-(void)gtui_Clear
{
    [self __clear];
}

-(GTUILayoutPosition* (^)(id val))equalTo
{
    return ^id(id val){
        
        return [self __equalTo:val];
    };
}


-(GTUILayoutPosition* (^)(CGFloat val))offset
{
    return ^id(CGFloat val){
        
        return [self __offset:val];
    };
}

-(GTUILayoutPosition* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
        
        return [self __min:val];
    };
}

-(GTUILayoutPosition* (^)(id posVal, CGFloat offsetVal))lBound
{
    return ^id(id posVal, CGFloat offsetVal){
        
        return [self __lBound:posVal offsetVal:offsetVal];
    };
}

-(GTUILayoutPosition* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
        
        return [self __max:val];
    };
}

-(GTUILayoutPosition* (^)(id posVal, CGFloat offsetVal))uBound
{
    return ^id(id posVal, CGFloat offsetVal){
        
        return [self __uBound:posVal offsetVal:offsetVal];
    };
}

-(void)clear
{
    [self __clear];
}

-(void)setActive:(BOOL)active
{
    if (_active != active)
    {
        _active = active;
        _lBoundVal.active = active;
        _uBoundVal.active = active;
        [self setNeedsLayout];
    }
}

-(id)posVal
{
    return self.isActive ? _posVal : nil;
}

-(CGFloat)offsetVal
{
    return self.isActive? _offsetVal : 0;
}

-(CGFloat)minVal
{
    return self.isActive && _lBoundVal != nil ? _lBoundVal.posNumVal.doubleValue : -CGFLOAT_MAX;
}

-(CGFloat)maxVal
{
    return self.isActive && _uBoundVal != nil ?  _uBoundVal.posNumVal.doubleValue : CGFLOAT_MAX;
}

#pragma mark - NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    GTUILayoutPosition *lp = [[[self class] allocWithZone:zone] init];
    lp.view = self.view;
    lp->_active = _active;
    lp->_pos = _pos;
    lp->_posValType = _posValType;
    lp->_posVal = _posVal;
    lp->_offsetVal = _offsetVal;
    if (_lBoundVal != nil)
    {
        lp->_lBoundVal = [[[self class] allocWithZone:zone] init];
        lp->_lBoundVal->_active = _active;
        [[lp->_lBoundVal __equalTo:_lBoundVal.posVal] __offset:_lBoundVal.offsetVal];
    }
    if (_uBoundVal != nil)
    {
        lp->_uBoundVal = [[[self class] allocWithZone:zone] init];
        lp->_uBoundVal->_active = _active;
        [[lp->_uBoundVal __equalTo:_uBoundVal.posVal] __offset:_uBoundVal.offsetVal];
    }
    
    return lp;
    
}

#pragma mark - Private Methods

-(NSNumber*)posNumVal
{
    if (_posVal == nil || !self.isActive)
        return nil;
    
    if (_posValType == GTUILayoutValueTypeNSNumber)
    {
        return _posVal;
    }
    else if (_posValType == GTUILayoutValueTypeUILayoutSupport)
    {
        //只有在11以后并且是设置了safearea缩进才忽略UILayoutSupport。
        UIView *superview = self.view.superview;
        if (superview != nil &&
            [UIDevice currentDevice].systemVersion.doubleValue >= 11 &&
            [superview isKindOfClass:[GTUIBaseLayout class]])
        {
            UIRectEdge edge = ((GTUIBaseLayout*)superview).insetsPaddingFromSafeArea;
            if ((_pos == GTUIGravityVertTop && (edge & UIRectEdgeTop) == UIRectEdgeTop) ||
                (_pos == GTUIGravityVertBottom && (edge & UIRectEdgeBottom) == UIRectEdgeBottom))
            {
                return @(0);
            }
        }
        
        return @([((id<UILayoutSupport>)_posVal) length]);
    }
    else if (_posValType == GTUILayoutValueTypeSafeArea)
    {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
        
        if (@available(iOS 11.0, *)) {
            
            UIView *superView = self.view.superview;
            /* UIEdgeInsets insets = superView.safeAreaInsets;
             UIScrollView *superScrollView = nil;
             if ([superView isKindOfClass:[UIScrollView class]])
             {
             superScrollView = (UIScrollView*)superView;
             
             }
             */
            
            switch (_pos) {
                case GTUIGravityHorzLeading:
                    return  [GTUIBaseLayout isRTL]? @(superView.safeAreaInsets.right) : @(superView.safeAreaInsets.left);
                    break;
                case GTUIGravityHorzTrailing:
                    return  [GTUIBaseLayout isRTL]? @(superView.safeAreaInsets.left) : @(superView.safeAreaInsets.right);
                    break;
                case GTUIGravityVertTop:
                    return @(superView.safeAreaInsets.top);
                    break;
                case GTUIGravityVertBottom:
                    return @(superView.safeAreaInsets.bottom);
                    break;
                default:
                    return @(0);
                    break;
            }
        }
#endif
        if (_pos == GTUIGravityVertTop)
        {
            return @([self findContainerVC].topLayoutGuide.length);
        }
        else if (_pos == GTUIGravityVertBottom)
        {
            return @([self findContainerVC].bottomLayoutGuide.length);
        }
        
        return @(0);
        
    }
    
    
    return nil;
    
}

-(UIViewController*)findContainerVC
{
    UIViewController *vc = nil;
    
    @try {
        
        UIView *v = self.view;
        while (v != nil)
        {
            vc = [v valueForKey:@"viewDelegate"];
            if (vc != nil)
                break;
            v = [v superview];
        }
        
    } @catch (NSException *exception) {
        
    }
    
    return vc;
}



-(GTUILayoutPosition*)posRelaVal
{
    if (_posVal == nil || !self.isActive)
        return nil;
    
    if (_posValType == GTUILayoutValueTypeLayoutPos)
        return _posVal;
    
    return nil;
    
}


-(NSArray*)posArrVal
{
    if (_posVal == nil || !self.isActive)
        return nil;
    
    if (_posValType == GTUILayoutValueTypeArray)
        return _posVal;
    
    return nil;
    
}

-(GTUILayoutPosition*)lBoundVal
{
    if (_lBoundVal == nil)
    {
        _lBoundVal = [[GTUILayoutPosition alloc] init];
        _lBoundVal->_active = _active;
        [_lBoundVal __equalTo:@(-CGFLOAT_MAX)];
    }
    return _lBoundVal;
}

-(GTUILayoutPosition*)uBoundVal
{
    if (_uBoundVal == nil)
    {
        _uBoundVal = [[GTUILayoutPosition alloc] init];
        _uBoundVal->_active = _active;
        [_uBoundVal __equalTo:@(CGFLOAT_MAX)];
    }
    
    return _uBoundVal;
}

-(GTUILayoutPosition*)lBoundValInner
{
    return _lBoundVal;
}

-(GTUILayoutPosition*)uBoundValInner
{
    return _uBoundVal;
}



-(GTUILayoutPosition*)__equalTo:(id)val
{
    
    if (![_posVal isEqual:val])
    {
        if ([val isKindOfClass:[NSNumber class]])
        {
            //特殊处理设置为safeAreaMargin边距的值。
            if ([val doubleValue] == [GTUILayoutPosition safeAreaMargin])
            {
                
                _posValType = GTUILayoutValueTypeSafeArea;
            }
            else
            {
                _posValType = GTUILayoutValueTypeNSNumber;
            }
        }
        else if ([val isKindOfClass:[GTUILayoutPosition class]])
            _posValType = GTUILayoutValueTypeLayoutPos;
        else if ([val isKindOfClass:[NSArray class]])
            _posValType = GTUILayoutValueTypeArray;
        else if ([val conformsToProtocol:@protocol(UILayoutSupport)])
        {
            //这里只有上边和下边支持，其他不支持。。
            if (_pos != GTUIGravityVertTop && _pos != GTUIGravityVertBottom)
            {
                NSAssert(0, @"oops! only topPos or bottomPos can set to id<UILayoutSupport>");
            }
            
            _posValType = GTUILayoutValueTypeUILayoutSupport;
        }
        else if ([val isKindOfClass:[UIView class]])
        {
            UIView *rview = (UIView*)val;
            _posValType = GTUILayoutValueTypeLayoutPos;
            
            switch (_pos) {
                case GTUIGravityHorzLeading:
                    val = rview.leadingPos;
                    break;
                case GTUIGravityHorzCenter:
                    val = rview.centerXPos;
                    break;
                case GTUIGravityHorzTrailing:
                    val = rview.trailingPos;
                    break;
                case GTUIGravityVertTop:
                    val = rview.topPos;
                    break;
                case GTUIGravityVertCenter:
                    val = rview.centerYPos;
                    break;
                case GTUIGravityVertBottom:
                    val = rview.bottomPos;
                    break;
                case GTUIGravityVertBaseline:
                    val = rview.baselinePos;
                    break;
                default:
                    NSAssert(0, @"oops!");
                    break;
            }
            
        }
        else
            _posValType = GTUILayoutValueTypeNil;
        
        _posVal = val;
        [self setNeedsLayout];
    }
    
    return self;
}

-(GTUILayoutPosition*)__offset:(CGFloat)val
{
    
    if (_offsetVal != val)
    {
        _offsetVal = val;
        [self setNeedsLayout];
    }
    
    return self;
}

-(GTUILayoutPosition*)__min:(CGFloat)val
{
    
    if (self.lBoundVal.posNumVal.doubleValue != val)
    {
        [self.lBoundVal __equalTo:@(val)];
        
        [self setNeedsLayout];
    }
    
    return self;
}

-(GTUILayoutPosition*)__lBound:(id)posVal offsetVal:(CGFloat)offsetVal
{
    
    [[self.lBoundVal __equalTo:posVal] __offset:offsetVal];
    
    [self setNeedsLayout];
    
    return self;
}


-(GTUILayoutPosition*)__max:(CGFloat)val
{
    
    if (self.uBoundVal.posNumVal.doubleValue != val)
    {
        [self.uBoundVal __equalTo:@(val)];
        [self setNeedsLayout];
    }
    
    return self;
}

-(GTUILayoutPosition*)__uBound:(id)posVal offsetVal:(CGFloat)offsetVal
{
    
    [[self.uBoundVal __equalTo:posVal] __offset:offsetVal];
    
    [self setNeedsLayout];
    
    return self;
}



-(void)__clear
{
    _active = YES;
    _posVal = nil;
    _posValType = GTUILayoutValueTypeNil;
    _offsetVal = 0;
    _lBoundVal = nil;
    _uBoundVal = nil;
    [self setNeedsLayout];
}




-(CGFloat)absVal
{
    if (self.isActive)
    {
        CGFloat retVal = _offsetVal;
        
        if (self.posNumVal != nil)
            retVal +=self.posNumVal.doubleValue;
        
        if (_uBoundVal != nil)
            retVal = _gtuiCGFloatMin(_uBoundVal.posNumVal.doubleValue, retVal);
        
        if (_lBoundVal != nil)
            retVal = _gtuiCGFloatMax(_lBoundVal.posNumVal.doubleValue, retVal);
        
        return retVal;
    }
    else
        return 0;
}

-(BOOL)isRelativePos
{
    if (self.isActive)
    {
        CGFloat realPos = self.posNumVal.doubleValue;
        return realPos > 0 && realPos < 1;
        
    }
    else
        return NO;
}

-(BOOL)isSafeAreaPos
{
    return self.isActive && (_posValType == GTUILayoutValueTypeSafeArea || _posValType == GTUILayoutValueTypeUILayoutSupport);
}


-(CGFloat)realPosIn:(CGFloat)size
{
    if (self.isActive)
    {
        CGFloat realPos = self.posNumVal.doubleValue;
        if (realPos > 0 && realPos < 1)
            realPos *= size;
        
        realPos += _offsetVal;
        
        if (_uBoundVal != nil)
            realPos = _gtuiCGFloatMin(_uBoundVal.posNumVal.doubleValue, realPos);
        
        if (_lBoundVal != nil)
            realPos = _gtuiCGFloatMax(_lBoundVal.posNumVal.doubleValue, realPos);
        
        return realPos;
    }
    else
        return 0;
    
}


-(void)setNeedsLayout
{
    if (_view != nil && _view.superview != nil && [_view.superview isKindOfClass:[GTUIBaseLayout class]])
    {
        GTUIBaseLayout* lb = (GTUIBaseLayout*)_view.superview;
        if (!lb.isGTUILayouting)
            [_view.superview setNeedsLayout];
    }
    
}



+(NSString*)posstrFromPos:(GTUILayoutPosition*)posobj showView:(BOOL)showView
{
    
    NSString *viewstr = @"";
    if (showView)
    {
        viewstr = [NSString stringWithFormat:@"View:%p.", posobj.view];
    }
    
    NSString *posStr = @"";
    
    switch (posobj.pos) {
        case GTUIGravityHorzLeading:
            posStr = @"leadingPos";
            break;
        case GTUIGravityHorzCenter:
            posStr = @"centerXPos";
            break;
        case GTUIGravityHorzTrailing:
            posStr = @"trailingPos";
            break;
        case GTUIGravityVertTop:
            posStr = @"topPos";
            break;
        case GTUIGravityVertCenter:
            posStr = @"centerYPos";
            break;
        case GTUIGravityVertBottom:
            posStr = @"bottomPos";
            break;
        case GTUIGravityVertBaseline:
            posStr = @"baselinePos";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@",viewstr,posStr];
    
    
}


#pragma mark -- Override Method

-(NSString*)description
{
    NSString *posValStr = @"";
    switch (_posValType) {
        case GTUILayoutValueTypeNil:
            posValStr = @"nil";
            break;
        case GTUILayoutValueTypeNSNumber:
            posValStr = [_posVal description];
            break;
        case GTUILayoutValueTypeLayoutPos:
            posValStr = [GTUILayoutPosition posstrFromPos:_posVal showView:YES];
            break;
        case GTUILayoutValueTypeArray:
        {
            posValStr = @"[";
            for (NSObject *obj in _posVal)
            {
                if ([obj isKindOfClass:[GTUILayoutPosition class]])
                {
                    posValStr = [posValStr stringByAppendingString:[GTUILayoutPosition posstrFromPos:(GTUILayoutPosition*)obj showView:YES]];
                }
                else
                {
                    posValStr = [posValStr stringByAppendingString:[obj description]];
                    
                }
                
                if (obj != [_posVal lastObject])
                    posValStr = [posValStr stringByAppendingString:@", "];
                
            }
            
            posValStr = [posValStr stringByAppendingString:@"]"];
            
        }
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@=%@, Offset=%g, Max=%g, Min=%g",[GTUILayoutPosition posstrFromPos:self showView:NO], posValStr, _offsetVal, _uBoundVal.posNumVal.doubleValue == CGFLOAT_MAX ? NAN : _uBoundVal.posNumVal.doubleValue , _uBoundVal.posNumVal.doubleValue == -CGFLOAT_MAX ? NAN : _lBoundVal.posNumVal.doubleValue];
    
}


@end
