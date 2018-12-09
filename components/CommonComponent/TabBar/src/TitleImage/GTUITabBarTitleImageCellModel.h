//
//  GTUITabBarTitleImageCellModel.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorCellModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GTUITabBarTitleImageType) {
    GTUITabBarTitleImageTypeTopImage = 0,
    GTUITabBarTitleImageTypeLeftImage,
    GTUITabBarTitleImageTypeBottomImage,
    GTUITabBarTitleImageTypeRightImage,
    GTUITabBarTitleImageTypeOnlyImage,
    GTUITabBarTitleImageTypeOnlyTitle,
};

@interface GTUITabBarTitleImageCellModel : GTUITabBarIndicatorCellModel

@property (nonatomic, assign) GTUITabBarTitleImageType imageType;

@property (nonatomic, copy) void(^loadImageCallback)(UIImageView *imageView, NSURL *imageURL);

@property (nonatomic, copy) NSString *imageName;    //加载bundle内的图片

@property (nonatomic, strong) NSURL *imageURL;      //图片URL

@property (nonatomic, copy) NSString *selectedImageName;

@property (nonatomic, strong) NSURL *selectedImageURL;

@property (nonatomic, assign) CGSize imageSize;     //默认CGSizeMake(20, 20)

@property (nonatomic, assign) CGFloat titleImageSpacing;    //titleLabel和ImageView的间距，默认5

@property (nonatomic, assign) BOOL imageZoomEnabled;

@property (nonatomic, assign) CGFloat imageZoomScale;

@end

NS_ASSUME_NONNULL_END
