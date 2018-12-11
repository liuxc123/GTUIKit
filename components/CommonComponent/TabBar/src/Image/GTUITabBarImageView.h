//
//  GTUITabBarImageView.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorView.h"
#import "GTUITabBarImageCellModel.h"
#import "GTUITabBarImageCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTUITabBarImageView : GTUITabBarIndicatorView

@property (nonatomic, strong) NSArray <NSString *>*imageNames;

@property (nonatomic, strong) NSArray <NSURL *>*imageURLs;

@property (nonatomic, strong) NSArray <NSString *>*selectedImageNames;

@property (nonatomic, strong) NSArray <NSURL *>*selectedImageURLs;

@property (nonatomic, copy, nullable) void(^loadImageCallback)(UIImageView *imageView, NSURL *imageURL);   //使用imageURL从远端下载图片进行加载，建议使用SDWebImage等第三方库进行下载。

@property (nonatomic, assign) CGSize imageSize;     //默认CGSizeMake(20, 20)

@property (nonatomic, assign) CGFloat imageCornerRadius; //图片圆角

@property (nonatomic, assign) BOOL imageZoomEnabled;     //默认为NO

@property (nonatomic, assign) CGFloat imageZoomScale;    //默认1.2，imageZoomEnabled为YES才生效

@end

NS_ASSUME_NONNULL_END
