//
//  GTUITabBarImageCellModel.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarImageCellModel : GTUITabBarIndicatorCellModel

@property (nonatomic, copy) void(^loadImageCallback)(UIImageView *imageView, NSURL *imageURL);

@property (nonatomic, copy) NSString *imageName;    //加载bundle内的图片

@property (nonatomic, strong) NSURL *imageURL;      //图片URL

@property (nonatomic, copy) NSString *selectedImageName;

@property (nonatomic, strong) NSURL *selectedImageURL;

@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, assign) CGFloat imageCornerRadius;

@property (nonatomic, assign) BOOL imageZoomEnabled;

@property (nonatomic, assign) CGFloat imageZoomScale;

@end

NS_ASSUME_NONNULL_END
