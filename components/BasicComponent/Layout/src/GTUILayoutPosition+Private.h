//
//  GTUILayoutPosition+Private.h
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUILayoutPosition.h"

NS_ASSUME_NONNULL_BEGIN

/**
 布局位置内部定义
 */
@interface GTUILayoutPosition ()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) GTUIGravity pos;
@property(nonatomic, assign) GTUILayoutValueType posValType;

@property(nonatomic, readonly, strong) NSNumber *posNumVal;
@property(nonatomic, readonly, strong) GTUILayoutPosition *posRelaVal;
@property(nonatomic, readonly, strong) NSArray *posArrVal;

@property(nonatomic, readonly, strong) GTUILayoutPosition *lBoundVal;
@property(nonatomic, readonly, strong) GTUILayoutPosition *uBoundVal;

@property(nonatomic, readonly, strong) GTUILayoutPosition *lBoundValInner;
@property(nonatomic, readonly, strong) GTUILayoutPosition *uBoundValInner;



-(GTUILayoutPosition*)__equalTo:(id)val;
-(GTUILayoutPosition*)__offset:(CGFloat)val;
-(GTUILayoutPosition*)__min:(CGFloat)val;
-(GTUILayoutPosition*)__lBound:(id)posVal offsetVal:(CGFloat)offsetVal;
-(GTUILayoutPosition*)__max:(CGFloat)val;
-(GTUILayoutPosition*)__uBound:(id)posVal offsetVal:(CGFloat)offsetVal;
-(void)__clear;


// minVal <= posNumVal + offsetVal <=maxVal . 注意这个只试用于相对布局。对于线性布局和框架布局来说，因为可以支持相对边距。
// 所以线性布局和框架布局不能使用这个属性。
@property(nonatomic,readonly, assign) CGFloat absVal;

//获取真实的位置值
-(CGFloat)realPosIn:(CGFloat)size;

-(BOOL)isRelativePos;

-(BOOL)isSafeAreaPos;


@end

NS_ASSUME_NONNULL_END
