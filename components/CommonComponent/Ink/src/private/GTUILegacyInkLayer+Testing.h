//
//  GTUILegacyInkLayer+Testing.h
//  Pods
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUILegacyInkLayer.h"

@protocol GTUILegacyInkLayerRippleDelegate <NSObject>

@optional

- (void)animationDidStop:(CAAnimation *)anim
              shapeLayer:(CAShapeLayer *)shapeLayer
                finished:(BOOL)finished;

@end

@interface GTUILegacyInkLayer ()  <GTUILegacyInkLayerRippleDelegate>
@end

@interface GTUILegacyInkLayerRipple : CAShapeLayer
@end

@interface GTUILegacyInkLayerForegroundRipple : GTUILegacyInkLayerRipple
- (void)exit:(BOOL)animated;
@end

@interface GTUILegacyInkLayerBackgroundRipple : GTUILegacyInkLayerRipple
- (void)exit:(BOOL)animated;
@end

