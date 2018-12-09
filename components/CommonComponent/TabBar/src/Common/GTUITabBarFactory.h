//
//  GTUITabBarFactory.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarFactory : NSObject

+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent;

+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END
