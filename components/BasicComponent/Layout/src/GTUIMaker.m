//
//  GTUIMaker.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUIMaker.h"

#if TARGET_OS_IPHONE

#import "GTUILayoutPosition.h"
#import "GTUILayoutSize.h"
#import "GTUILayoutPosition+Private.h"
#import "GTUILayoutSize+Private.h"

@interface GTUIMaker ()

- (instancetype)initWithViews:(NSArray *)views;

@end

@implementation GTUIMaker
{
    NSArray *_gtuiViews;
    NSMutableArray *_keys;
    BOOL  _clear;
}


- (instancetype)initWithViews:(NSArray *)views
{
    self = [super init];
    if (self) {
        _gtuiViews = views;
        _keys = [[NSMutableArray alloc] init];
        _clear = NO;
    }
    return self;
}


-(GTUIMaker*)addMethod:(NSString*)method
{
    if (_clear)
        [_keys removeAllObjects];
    _clear = NO;
    
    [_keys addObject:method];
    return self;
}



-(GTUIMaker*)top
{
    return [self addMethod:@"topPos"];
}

-(GTUIMaker*)left
{
    return [self addMethod:@"leftPos"];
}

-(GTUIMaker*)bottom
{
    return [self addMethod:@"bottomPos"];
}

-(GTUIMaker*)right
{
    return [self addMethod:@"rightPos"];
}

-(GTUIMaker*)margin
{
    [self top];
    [self left];
    [self right];
    return [self bottom];
}

-(GTUIMaker*)leading
{
    return [self addMethod:@"leadingPos"];
    
}

-(GTUIMaker*)trailing
{
    return [self addMethod:@"trailingPos"];
    
}


-(GTUIMaker*)height
{
    return [self addMethod:@"heightSize"];
}

-(GTUIMaker*)width
{
    return [self addMethod:@"widthSize"];
}

-(GTUIMaker*)useFrame
{
    return [self addMethod:@"useFrame"];
}

-(GTUIMaker*)noLayout
{
    return [self addMethod:@"noLayout"];
    
}


-(GTUIMaker*)wrapContentHeight
{
    return [self addMethod:@"wrapContentHeight"];
}

-(GTUIMaker*)wrapContentWidth
{
    return [self addMethod:@"wrapContentWidth"];
}

-(GTUIMaker*)reverseLayout
{
    return [self addMethod:@"reverseLayout"];
}



-(GTUIMaker*)weight
{
    return [self addMethod:@"weight"];
    
}

-(GTUIMaker*)reverseFloat
{
    return [self addMethod:@"reverseFloat"];
}

-(GTUIMaker*)clearFloat
{
    return [self addMethod:@"clearFloat"];
}

-(GTUIMaker*)noBoundaryLimit
{
    return [self addMethod:@"noBoundaryLimit"];
}

-(GTUIMaker*)topPadding
{
    
    return [self addMethod:@"topPadding"];
    
}

-(GTUIMaker*)leftPadding
{
    return [self addMethod:@"leftPadding"];
    
}

-(GTUIMaker*)bottomPadding
{
    
    return [self addMethod:@"bottomPadding"];
    
}

-(GTUIMaker*)rightPadding
{
    return [self addMethod:@"rightPadding"];
    
}

-(GTUIMaker*)leadingPadding
{
    
    return [self addMethod:@"leadingPadding"];
    
}

-(GTUIMaker*)trailingPadding
{
    return [self addMethod:@"trailingPadding"];
    
}


-(GTUIMaker*)padding
{
    [self addMethod:@"topPadding"];
    [self addMethod:@"leftPadding"];
    [self addMethod:@"bottomPadding"];
    return [self addMethod:@"rightPadding"];
}

-(GTUIMaker*)zeroPadding
{
    return [self addMethod:@"zeroPadding"];
}

-(GTUIMaker*)orientation
{
    return [self addMethod:@"orientation"];
    
}

-(GTUIMaker*)gravity
{
    return [self addMethod:@"gravity"];
    
}


-(GTUIMaker*)centerX
{
    return [self addMethod:@"centerXPos"];
}

-(GTUIMaker*)centerY
{
    return [self addMethod:@"centerYPos"];
}

-(GTUIMaker*)center
{
    [self addMethod:@"centerXPos"];
    return [self addMethod:@"centerYPos"];
}
-(GTUIMaker*)baseline
{
    return [self addMethod:@"baselinePos"];
}


-(GTUIMaker*)visibility
{
    return [self addMethod:@"gtui_visibility"];
}

-(GTUIMaker*)alignment
{
    return [self addMethod:@"gtui_alignment"];
}



-(GTUIMaker*)sizeToFit
{
    for (UIView *gtuiView in _gtuiViews)
    {
        [gtuiView sizeToFit];
    }
    
    return self;
}



-(GTUIMaker*)space
{
    return [self addMethod:@"subviewSpace"];
    
}

-(GTUIMaker*)shrinkType
{
    return [self addMethod:@"shrinkType"];
    
}


-(GTUIMaker*)arrangedCount
{
    return [self addMethod:@"arrangedCount"];
}

-(GTUIMaker*)autoArrange
{
    return [self addMethod:@"autoArrange"];
}

-(GTUIMaker*)arrangedGravity
{
    return [self addMethod:@"arrangedGravity"];
    
}

-(GTUIMaker*)vertSpace
{
    return [self addMethod:@"subviewVSpace"];
    
}

-(GTUIMaker*)horzSpace
{
    return [self addMethod:@"subviewHSpace"];
    
}

-(GTUIMaker*)pagedCount
{
    return [self addMethod:@"pagedCount"];
    
}




-(GTUIMaker* (^)(id val))equalTo
{
    _clear = YES;
    return ^id(id val) {
        
        for (NSString *key in self->_keys)
        {
            
            for (UIView * gtuiView in self->_gtuiViews)
            {
                if ([val isKindOfClass:[NSNumber class]])
                {
                    id oldVal = [gtuiView valueForKey:key];
                    if ([oldVal isKindOfClass:[GTUILayoutPosition class]])
                    {
                        [((GTUILayoutPosition*)oldVal) __equalTo:val];
                    }
                    else if ([oldVal isKindOfClass:[GTUILayoutSize class]])
                    {
                        [((GTUILayoutSize*)oldVal) __equalTo:val];
                    }
                    else
                        [gtuiView setValue:val forKey:key];
                }
                else if ([val isKindOfClass:[GTUILayoutPosition class]])
                {
                    [((GTUILayoutPosition*)[gtuiView valueForKey:key]) __equalTo:val];
                }
                else if ([val isKindOfClass:[GTUILayoutSize class]])
                {
                    [((GTUILayoutSize*)[gtuiView valueForKey:key]) __equalTo:val];
                }
                else if ([val isKindOfClass:[NSArray class]])
                {
                    [((GTUILayoutSize*)[gtuiView valueForKey:key]) __equalTo:val];
                }
                else if ([val isKindOfClass:[UIView class]])
                {
                    id oldVal = [val valueForKey:key];
                    if ([oldVal isKindOfClass:[GTUILayoutPosition class]])
                    {
                        [((GTUILayoutPosition*)[gtuiView valueForKey:key]) __equalTo:oldVal];
                    }
                    else if ([oldVal isKindOfClass:[GTUILayoutSize class]])
                    {
                        [((GTUILayoutSize*)[gtuiView valueForKey:key]) __equalTo:oldVal];
                        
                    }
                    else
                    {
                        [gtuiView setValue:oldVal forKey:key];
                    }
                }
            }
            
        }
        
        return self;
    };
}

-(GTUIMaker* (^)(CGFloat val))offset
{
    _clear = YES;
    
    return ^id(CGFloat val) {
        
        for (NSString *key in self->_keys)
        {
            for (UIView *gtuiView in self->_gtuiViews)
            {
                
                [((GTUILayoutPosition*)[gtuiView valueForKey:key]) __offset:val];
            }
        }
        
        return self;
    };
}

-(GTUIMaker* (^)(CGFloat val))multiply
{
    _clear = YES;
    return ^id(CGFloat val) {
        
        for (NSString *key in self->_keys)
        {
            for (UIView *gtuiView in self->_gtuiViews)
            {
                
                [((GTUILayoutSize*)[gtuiView valueForKey:key]) __multiply:val];
            }
        }
        return self;
    };
    
}

-(GTUIMaker* (^)(CGFloat val))add
{
    _clear = YES;
    return ^id(CGFloat val) {
        
        for (NSString *key in self->_keys)
        {
            
            for (UIView *gtuiView in self->_gtuiViews)
            {
                
                [((GTUILayoutSize*)[gtuiView valueForKey:key]) __add:val];
            }
        }
        return self;
    };
    
}

-(GTUIMaker* (^)(id val))min
{
    _clear = YES;
    return ^id(id val) {
        
        for (NSString *key in self->_keys)
        {
            
            for (UIView *gtuiView in self->_gtuiViews)
            {
                
                
                id val2 = val;
                if ([val isKindOfClass:[UIView class]])
                    val2 = [val valueForKey:key];
                
                id oldVal = [gtuiView valueForKey:key];
                if ([oldVal isKindOfClass:[GTUILayoutPosition class]])
                {
                    [((GTUILayoutPosition*)oldVal) __lBound:val2 offsetVal:0];
                }
                else if ([oldVal isKindOfClass:[GTUILayoutSize class]])
                {
                    [((GTUILayoutSize*)oldVal) __lBound:val2 addVal:0 multiVal:1];
                }
                else
                    ;
            }
        }
        return self;
    };
    
}

-(GTUIMaker* (^)(id val))max
{
    _clear = YES;
    return ^id(id val) {
        
        for (NSString *key in self->_keys)
        {
            for (UIView *gtuiView in self->_gtuiViews)
            {
                id val2 = val;
                if ([val isKindOfClass:[UIView class]])
                    val2 = [val valueForKey:key];
                
                id oldVal = [gtuiView valueForKey:key];
                if ([oldVal isKindOfClass:[GTUILayoutPosition class]])
                {
                    [((GTUILayoutPosition*)oldVal) __uBound:val2 offsetVal:0];
                }
                else if ([oldVal isKindOfClass:[GTUILayoutSize class]])
                {
                    [((GTUILayoutSize*)oldVal) __uBound:val2 addVal:0 multiVal:1];
                }
                else
                    ;
            }
        }
        return self;
    };
    
}



@end


@implementation UIView(GTUIMakerExt)


-(void)makeLayout:(void(^)(GTUIMaker *make))layoutMaker
{
    GTUIMaker *maker = [[GTUIMaker alloc] initWithViews:@[self]];
    layoutMaker(maker);
}

-(void)allSubviewMakeLayout:(void(^)(GTUIMaker *make))layoutMaker
{
    GTUIMaker *maker = [[GTUIMaker alloc] initWithViews:self.subviews];
    layoutMaker(maker);
}


@end

#endif
