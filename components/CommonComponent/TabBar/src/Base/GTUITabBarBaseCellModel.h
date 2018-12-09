//
//  GTUITabBarBaseCellModel.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarBaseCellModel : NSObject

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, assign) CGFloat cellSpacing;

@property (nonatomic, assign) BOOL cellWidthZoomEnabled;

@property (nonatomic, assign) CGFloat cellWidthZoomScale;

@end

NS_ASSUME_NONNULL_END
