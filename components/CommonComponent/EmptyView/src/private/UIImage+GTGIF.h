//
//  UIImage+GTGIF.h
//  GTKit
//
//  Created by liuxc on 2018/5/20.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GTGIF)

/**
 图片赋值
 支持png、jpeg、jpg、gif、webp、apng等格式

 @param name 图片名称 如果是.png可以省略 如果是其他格式必须带带上格式
 @return U
 */
+ (UIImage *_Nullable)gt_imageNamed:(NSString *_Nullable)name;

/*
 UIImage *animation = [UIImage animatedImageWithAnimatedGIFData:theData];
 
 I interpret `theData` as a GIF.  I create an animated `UIImage` using the source images in the GIF.
 
 The GIF stores a separate duration for each frame, in units of centiseconds (hundredths of a second).  However, a `UIImage` only has a single, total `duration` property, which is a floating-point number.
 
 To handle this mismatch, I add each source image (from the GIF) to `animation` a varying number of times to match the ratios between the frame durations in the GIF.
 
 For example, suppose the GIF contains three frames.  Frame 0 has duration 3.  Frame 1 has duration 9.  Frame 2 has duration 15.  I divide each duration by the greatest common denominator of all the durations, which is 3, and add each frame the resulting number of times.  Thus `animation` will contain frame 0 3/3 = 1 time, then frame 1 9/3 = 3 times, then frame 2 15/3 = 5 times.  I set `animation.duration` to (3+9+15)/100 = 0.27 seconds.
 */
+ (UIImage * _Nullable)gt_animatedImageWithAnimatedGIFData:(NSData * _Nonnull)theData;

/*
 UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:theURL];
 
 I interpret the contents of `theURL` as a GIF.  I create an animated `UIImage` using the source images in the GIF.
 
 I operate exactly like `+[UIImage animatedImageWithAnimatedGIFData:]`, except that I read the data from `theURL`.  If `theURL` is not a `file:` URL, you probably want to call me on a background thread or GCD queue to avoid blocking the main thread.
 */
+ (UIImage * _Nullable)gt_animatedImageWithAnimatedGIFURL:(NSURL * _Nonnull)theURL;



@end
