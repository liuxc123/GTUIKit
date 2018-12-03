//
//  GTUILayoutSize.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUILayoutSize.h"
#import "GTUILayoutSize+Private.h"
#import "GTUIBaseLayout.h"
#import "GTUILayoutMath.h"

@implementation GTUILayoutSize
{
    id _dimeVal;
    CGFloat _addVal;
    CGFloat _multiVal;
    GTUILayoutSize *_lBoundVal;
    GTUILayoutSize *_uBoundVal;
}


+(CGFloat)wrap
{
    return -1;
}

+(CGFloat)fill
{
    return -2;
}

+(CGFloat)average
{
    return -3;
}


-(id)init
{
    self= [super init];
    if (self !=nil)
    {
        _active = YES;
        _view = nil;
        _dime = GTUIGravityNone;
        _dimeVal = nil;
        _dimeValType = GTUILayoutValueTypeNil;
        _addVal = 0;
        _multiVal = 1;
        _lBoundVal = nil;
        _uBoundVal = nil;
    }
    
    return self;
}


#pragma mark - Public Methods

-(GTUILayoutSize* (^)(id val))gtui_equalTo
{
    return ^id(id val){
        
        return [self __equalTo:val];
    };
}

-(GTUILayoutSize* (^)(CGFloat val))gtui_add
{
    return ^id(CGFloat val){
        
        return [self __add:val];
    };
}

-(GTUILayoutSize* (^)(CGFloat val))gtui_multiply
{
    return ^id(CGFloat val){
        
        return [self __multiply:val];
    };
    
}

-(GTUILayoutSize* (^)(CGFloat val))gtui_min
{
    return ^id(CGFloat val){
        
        return [self __min:val];
    };
    
}

-(GTUILayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))gtui_lBound
{
    
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        
        return [self __lBound:sizeVal addVal:addVal multiVal:multiVal];
        
    };
}

-(GTUILayoutSize* (^)(CGFloat val))gtui_max
{
    return ^id(CGFloat val){
        
        return [self __max:val];
    };
}

-(GTUILayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))gtui_uBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        
        return [self __uBound:sizeVal addVal:addVal multiVal:multiVal];
    };
    
}

-(void)gtui_clear
{
    [self __clear];
}


-(GTUILayoutSize* (^)(id val))equalTo
{
    return ^id(id val){
        
        return [self __equalTo:val];
    };
}

-(GTUILayoutSize* (^)(CGFloat val))add
{
    return ^id(CGFloat val){
        
        return [self __add:val];
    };
}

-(GTUILayoutSize* (^)(CGFloat val))multiply
{
    return ^id(CGFloat val){
        
        return [self __multiply:val];
    };
    
}

-(GTUILayoutSize* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
        
        return [self __min:val];
    };
    
}

-(GTUILayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))lBound
{
    
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        
        return [self __lBound:sizeVal addVal:addVal multiVal:multiVal];
        
    };
}

-(GTUILayoutSize* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
        
        return [self __max:val];
    };
}

-(GTUILayoutSize* (^)(id sizeVal, CGFloat addVal, CGFloat multiVal))uBound
{
    return ^id(id sizeVal, CGFloat addVal, CGFloat multiVal){
        
        return [self __uBound:sizeVal addVal:addVal multiVal:multiVal];
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



-(id)dimeVal
{
    if (self.isActive)
    {
        if (_dimeValType == GTUILayoutValueTypeLayoutDime && _dimeVal == nil)
            return self;
        
        return _dimeVal;
    }
    else
        return nil;
    
}

-(CGFloat)minVal
{
    return (self.isActive && _lBoundVal != nil) ?  _lBoundVal.dimeNumVal.doubleValue : -CGFLOAT_MAX;
}

-(CGFloat)maxVal
{
    return (self.isActive && _uBoundVal != nil) ?  _uBoundVal.dimeNumVal.doubleValue : CGFLOAT_MAX;
}

#pragma mark -- NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    GTUILayoutSize *ld = [[[self class] allocWithZone:zone] init];
    ld.view = self.view;
    ld->_active = _active;
    ld->_dime = _dime;
    ld->_addVal = _addVal;
    ld->_multiVal = _multiVal;
    ld->_dimeVal = _dimeVal;
    ld->_dimeValType = _dimeValType;
    if (_lBoundVal != nil)
    {
        ld->_lBoundVal = [[[self class] allocWithZone:zone] init];
        ld->_lBoundVal->_active = _active;
        [[[ld->_lBoundVal __equalTo:_lBoundVal.dimeVal] __add:_lBoundVal.addVal] __multiply:_lBoundVal.multiVal];
        
    }
    
    if (_uBoundVal != nil)
    {
        ld->_uBoundVal = [[[self class] allocWithZone:zone] init];
        ld->_uBoundVal->_active = _active;
        [[[ld->_uBoundVal __equalTo:_uBoundVal.dimeVal] __add:_uBoundVal.addVal] __multiply:_uBoundVal.multiVal];
        
    }
    
    
    return self;
}

#pragma mark -- Private Methods


-(NSNumber*)dimeNumVal
{
    if (_dimeVal == nil || !self.isActive)
        return nil;
    
    if (_dimeValType == GTUILayoutValueTypeNSNumber)
        return _dimeVal;
    return nil;
}

-(GTUILayoutSize*)dimeRelaVal
{
    if (_dimeVal == nil || !self.isActive)
        return nil;
    if (_dimeValType == GTUILayoutValueTypeLayoutDime)
        return _dimeVal;
    return nil;
    
}


-(NSArray*)dimeArrVal
{
    if (_dimeVal == nil || !self.isActive)
        return nil;
    if (_dimeValType == GTUILayoutValueTypeArray)
        return _dimeVal;
    return nil;
    
}


-(GTUILayoutSize*)dimeSelfVal
{
    if (_dimeValType == GTUILayoutValueTypeLayoutDime && _dimeVal == nil && self.isActive)
        return self;
    
    return nil;
}


-(GTUILayoutSize*)lBoundVal
{
    if (_lBoundVal == nil)
    {
        _lBoundVal = [[GTUILayoutSize alloc] init];
        _lBoundVal->_active = _active;
        [_lBoundVal __equalTo:@(-CGFLOAT_MAX)];
    }
    
    return _lBoundVal;
}

-(GTUILayoutSize*)uBoundVal
{
    
    if (_uBoundVal == nil)
    {
        _uBoundVal = [[GTUILayoutSize alloc] init];
        _uBoundVal->_active = _active;
        [_uBoundVal __equalTo:@(CGFLOAT_MAX)];
    }
    return _uBoundVal;
}

-(GTUILayoutSize*)lBoundValInner
{
    return _lBoundVal;
}

-(GTUILayoutSize*)uBoundValInner
{
    return _uBoundVal;
}


-(GTUILayoutSize*)__equalTo:(id)val
{
    
    if (![_dimeVal isEqual:val])
    {
        if ([val isKindOfClass:[NSNumber class]])
        {
            _dimeValType = GTUILayoutValueTypeNSNumber;
        }
        else if ([val isMemberOfClass:[GTUILayoutSize class]])
        {
            _dimeValType = GTUILayoutValueTypeLayoutDime;
            
            //我们支持尺寸等于自己的情况，用来支持那些尺寸包裹内容但又想扩展尺寸的场景，为了不造成循环引用这里做特殊处理
            //当尺寸等于自己时，我们只记录_dimeValType，而把值设置为nil
            if (val == self)
            {
                val = nil;
            }
        }
        else if ([val isKindOfClass:[UIView class]])
        {
            
            UIView *rview = (UIView*)val;
            _dimeValType = GTUILayoutValueTypeLayoutDime;
            
            switch (_dime) {
                case GTUIGravityHorzFill:
                    val = rview.widthSize;
                    break;
                case GTUIGravityVertFill:
                    val = rview.heightSize;
                    break;
                default:
                    NSAssert(0, @"oops!");
                    break;
            }
            
        }
        else if ([val isKindOfClass:[NSArray class]])
        {
            _dimeValType = GTUILayoutValueTypeArray;
        }
        else
        {
            _dimeValType = GTUILayoutValueTypeNil;
        }
        
        _dimeVal = val;
        [self setNeedsLayout];
    }
    else
    {
        //参考上面自己等于自己的特殊情况需要特殊处理。
        if (val == nil && _dimeVal == nil && _dimeValType == GTUILayoutValueTypeLayoutDime)
        {
            _dimeValType = GTUILayoutValueTypeNil;
            [self setNeedsLayout];
        }
    }
    
    return self;
}

//加
-(GTUILayoutSize*)__add:(CGFloat)val
{
    
    if (_addVal != val)
    {
        _addVal = val;
        [self setNeedsLayout];
    }
    
    return self;
}


//乘
-(GTUILayoutSize*)__multiply:(CGFloat)val
{
    
    if (_multiVal != val)
    {
        _multiVal = val;
        [self setNeedsLayout];
    }
    
    return self;
    
}


-(GTUILayoutSize*)__min:(CGFloat)val
{
    if (self.lBoundVal.dimeNumVal.doubleValue != val)
    {
        [self.lBoundVal __equalTo:@(val)];
        [self setNeedsLayout];
    }
    
    return self;
}


-(GTUILayoutSize*)__lBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal
{
    if (sizeVal == self)
        sizeVal = self.lBoundVal;
    
    [[[self.lBoundVal __equalTo:sizeVal] __add:addVal] __multiply:multiVal];
    [self setNeedsLayout];
    
    return self;
}


-(GTUILayoutSize*)__max:(CGFloat)val
{
    if (self.uBoundVal.dimeNumVal.doubleValue != val)
    {
        [self.uBoundVal __equalTo:@(val)];
        [self setNeedsLayout];
    }
    
    return self;
}

-(GTUILayoutSize*)__uBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal
{
    if (sizeVal == self)
        sizeVal = self.uBoundVal;
    
    [[[self.uBoundVal __equalTo:sizeVal] __add:addVal] __multiply:multiVal];
    [self setNeedsLayout];
    
    return self;
}



-(void)__clear
{
    _active = YES;
    _addVal = 0;
    _multiVal = 1;
    _lBoundVal = nil;
    _uBoundVal = nil;
    _dimeVal = nil;
    _dimeValType = GTUILayoutValueTypeNil;
    
    [self setNeedsLayout];
}



-(CGFloat) measure
{
    return self.isActive ? _gtuiCGFloatFma(self.dimeNumVal.doubleValue,  _multiVal,  _addVal) : 0;
}

-(CGFloat)measureWith:(CGFloat)size
{
    return self.isActive ?  _gtuiCGFloatFma(size, _multiVal , _addVal) : size;
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


+(NSString*)dimestrFromDime:(GTUILayoutSize*)dimeobj showView:(BOOL)showView
{
    
    NSString *viewstr = @"";
    if (showView)
    {
        viewstr = [NSString stringWithFormat:@"View:%p.", dimeobj.view];
    }
    
    NSString *dimeStr = @"";
    
    switch (dimeobj.dime) {
        case GTUIGravityHorzFill:
            dimeStr = @"widthSize";
            break;
        case GTUIGravityVertFill:
            dimeStr = @"heightSize";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@",viewstr,dimeStr];
    
}

#pragma mark -- Override Methods

-(NSString*)description
{
    NSString *dimeValStr = @"";
    switch (_dimeValType) {
        case GTUILayoutValueTypeNil:
            dimeValStr = @"nil";
            break;
        case GTUILayoutValueTypeNSNumber:
            dimeValStr = [_dimeVal description];
            break;
        case GTUILayoutValueTypeLayoutDime:
            dimeValStr = [GTUILayoutSize dimestrFromDime:_dimeVal showView:YES];
            break;
        case GTUILayoutValueTypeArray:
        {
            dimeValStr = @"[";
            for (NSObject *obj in _dimeVal)
            {
                if ([obj isMemberOfClass:[GTUILayoutSize class]])
                {
                    dimeValStr = [dimeValStr stringByAppendingString:[GTUILayoutSize dimestrFromDime:(GTUILayoutSize*)obj showView:YES]];
                }
                else
                {
                    dimeValStr = [dimeValStr stringByAppendingString:[obj description]];
                    
                }
                
                if (obj != [_dimeVal lastObject])
                    dimeValStr = [dimeValStr stringByAppendingString:@", "];
                
            }
            
            dimeValStr = [dimeValStr stringByAppendingString:@"]"];
            
        }
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@=%@, Multiply=%g, Add=%g, Max=%g, Min=%g",[GTUILayoutSize dimestrFromDime:self showView:NO], dimeValStr, _multiVal, _addVal, _uBoundVal.dimeNumVal.doubleValue == CGFLOAT_MAX ? NAN : _uBoundVal.dimeNumVal.doubleValue , _lBoundVal.dimeNumVal.doubleValue == -CGFLOAT_MAX ? NAN : _lBoundVal.dimeNumVal.doubleValue];
    
}



@end


