//
//  GTUILayoutDelegate.h
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "GTUIBorderline.h"

NS_ASSUME_NONNULL_BEGIN

@class GTUIBaseLayout;

/**绘制线条层委托实现类**/
#ifdef MAC_OS_X_VERSION_10_12
@interface GTUIBorderlineLayerDelegate : NSObject<CALayerDelegate>
#else
@interface GTUIBorderlineLayerDelegate : NSObject
#endif

@property(nonatomic, strong) GTUIBorderline *topBorderline; /**顶部边界线*/
@property(nonatomic, strong) GTUIBorderline *leadingBorderline; /**头部边界线*/
@property(nonatomic, strong) GTUIBorderline *bottomBorderline;  /**底部边界线*/
@property(nonatomic, strong) GTUIBorderline *trailingBorderline;  /**尾部边界线*/
@property(nonatomic, strong) GTUIBorderline *leftBorderline;   /**左边边界线*/
@property(nonatomic, strong) GTUIBorderline *rightBorderline;   /**左边边界线*/


@property(nonatomic ,strong) CAShapeLayer *topBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *leadingBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *bottomBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *trailingBorderlineLayer;


-(instancetype)initWithLayoutLayer:(CALayer*)layoutLayer;

-(void)setNeedsLayoutIn:(CGRect)rect withLayer:(CALayer*)layer;

@end




//触摸事件的委托代码基类。
@interface GTUITouchEventDelegate : NSObject

@property(nonatomic, weak)  GTUIBaseLayout *layout;
@property(nonatomic, weak)  id target;
@property(nonatomic)  SEL action;

-(instancetype)initWithLayout:(GTUIBaseLayout*)layout;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)setTarget:(id)target action:(SEL)action;
-(void)setTouchDownTarget:(id)target action:(SEL)action;
-(void)setTouchCancelTarget:(id)target action:(SEL)action;


//subclass override this method
-(void)gtuiSetTouchHighlighted;
-(void)gtuiResetTouchHighlighted;
-(void)gtuiResetTouchHighlighted2;
-(id)gtuiActionSender;


@end


//布局视图的触摸委托代理。
@interface GTUILayoutTouchEventDelegate : GTUITouchEventDelegate

@property(nonatomic,strong)  UIColor *highlightedBackgroundColor;

@property(nonatomic,assign)  CGFloat highlightedOpacity;

@property(nonatomic,strong)  UIImage *highlightedBackgroundImage;

@end


NS_ASSUME_NONNULL_END
