//
//  GTUILayoutSize+Private.h
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUILayoutSize.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUILayoutSize ()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) GTUIGravity dime;
@property(nonatomic, assign) GTUILayoutValueType dimeValType;

@property(nonatomic, readonly, strong) NSNumber *dimeNumVal;
@property(nonatomic, readonly, strong) GTUILayoutSize *dimeRelaVal;
@property(nonatomic, readonly, strong) NSArray *dimeArrVal;
@property(nonatomic, readonly, strong) GTUILayoutSize *dimeSelfVal;

@property(nonatomic, readonly, strong) GTUILayoutSize *lBoundVal;
@property(nonatomic, readonly, strong) GTUILayoutSize *uBoundVal;

@property(nonatomic, readonly, strong) GTUILayoutSize *lBoundValInner;
@property(nonatomic, readonly, strong) GTUILayoutSize *uBoundValInner;



-(GTUILayoutSize*)__equalTo:(id)val;
-(GTUILayoutSize*)__add:(CGFloat)val;
-(GTUILayoutSize*)__multiply:(CGFloat)val;
-(GTUILayoutSize*)__min:(CGFloat)val;
-(GTUILayoutSize*)__lBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
-(GTUILayoutSize*)__max:(CGFloat)val;
-(GTUILayoutSize*)__uBound:(id)sizeVal addVal:(CGFloat)addVal multiVal:(CGFloat)multiVal;
-(void)__clear;



//只有为数值时才有意义。
@property(nonatomic, readonly, assign) CGFloat measure;


-(CGFloat)measureWith:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
