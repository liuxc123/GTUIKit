//
//  GTPickerViewMacro.h
//  Pods
//
//  Created by liuxc on 2018/11/30.
//

#ifndef GTPickerViewMacro_h
#define GTPickerViewMacro_h


#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define kGTPickerHeight 216

#define kGTTopViewHeight 44


#define GT_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define GT_IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

// 等比例适配系数
#define kScaleFit (GT_IS_IPHONE ? ((ScreenWidth < ScreenHeight) ? ScreenWidth / 375.0f : ScreenWidth / 667.0f) : 1.1f)
// 字体适配
#define kFontSize(value)     [UIFont systemFontOfSize:(value) * kScaleFit]

// color  format：0xFFFFFF
#define k16RGBColor(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

// 默认主题颜色
#define kDefaultThemeColor k16RGBColor(0x464646)
// topView视图的背景颜色
#define kBRToolBarColor k16RGBColor(0xFDFDFD)

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* GTPickerViewMacro_h */
