//
//  GTUIIconView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/9.
//

#import "GTUIIconView.h"
#import <CoreText/CoreText.h>

#define kICONFONT_DefaultColor [UIColor colorWithRed:0.0/255.0 green:142/255.0 blue:229/255.0 alpha:1.0];
#define kICONFONT_BundleName (@"GTIconfont.bundle")

@implementation GTUIIconView

+ (void)load {
    @autoreleasepool {
        NSURL *url = [[GTUIIconView bundle] URLForResource:kICONFONT_FONTNAME withExtension:@"ttf"];
        [UIImage registerIconFont:kICONFONT_FONTNAME fontPathURL:url];
    }
}

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initIconFontCommon];
        [self drawIconFontWithName:self.name fontName:self.fontName];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name {
    self = [super initWithFrame:frame];
    if (self) {
        [self initIconFontCommon];
        _name = name;
        [self drawIconFontWithName:self.name fontName:self.fontName];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name fontName:(NSString *)fontName {
    self = [super initWithFrame:frame];
    if (self) {
        [self initIconFontCommon];
        _name = name;
        _fontName = fontName;
        [self drawIconFontWithName:self.name fontName:self.fontName];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name fontName:(NSString *)fontName color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        [self initIconFontCommon];
        _name = name;
        _fontName = fontName;
        _color = color;
        [self drawIconFontWithName:self.name fontName:self.fontName];
    }
    return self;
}

- (void)initIconFontCommon {
    _color = kICONFONT_DefaultColor;
    _fontName = kICONFONT_FONTNAME;
    _imageInsets = UIEdgeInsetsZero;

}

- (void)drawIconFontWithName:(NSString *)name fontName:(NSString *)fontName {
    self.image = [UIImage iconWithName:name fontName:fontName imageInsets:self.imageInsets width:CGRectGetWidth(self.frame) color:self.color];
}

- (CGSize)iconViewSize {
    return self.image.size;
}

#pragma mark - Getters
- (void)setColor:(UIColor *)color {
    _color = color;
    [self drawIconFontWithName:self.name fontName:self.fontName];
}

- (void)setName:(NSString *)name {
    _name = name;
    [self drawIconFontWithName:name fontName:self.fontName];
}

- (void)setImageInsets:(UIEdgeInsets)imageInsets {
    _imageInsets = imageInsets;
    [self drawIconFontWithName:self.name fontName:self.fontName];
}

#pragma mark - Resource Bundle
+ (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[GTUIIconView bundlePathWithName:kICONFONT_BundleName]];
    });

    return bundle;
}

+ (NSString *)bundlePathWithName:(NSString *)bundleName {
    // In iOS 8+, we could be included by way of a dynamic framework, and our resource bundles may
    // not be in the main .app bundle, but rather in a nested framework, so figure out where we live
    // and use that as the search location.
    NSBundle *bundle = [NSBundle bundleForClass:[GTUIIconView class]];
    NSString *resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle)resourcePath];
    return [resourcePath stringByAppendingPathComponent:bundleName];
}




@end

@implementation UIImage (GTUIIconFont)

+ (void)registerIconFont:(NSString *)fontName
                fontPath:(NSString *)fontPath
{

    NSURL *fontFileUrl = [[NSBundle bundleWithPath:fontPath] URLForResource:fontName withExtension:@"ttf"];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[fontFileUrl path]], @"Font file doesn't exist");
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontFileUrl);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CFErrorRef error = NULL;
    CTFontManagerRegisterGraphicsFont(newFont, &error);
    CGFontRelease(newFont);
    if (error) CFRelease(error);
}

+ (void)registerIconFont:(NSString *)fontName
                fontPathURL:(NSURL *)fontPathURL
{
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[fontPathURL path]], @"Font file doesn't exist");
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontPathURL);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CFErrorRef error = NULL;
    CTFontManagerRegisterGraphicsFont(newFont, &error);
    CGFontRelease(newFont);
    if (error) CFRelease(error);
}

+ (UIImage *)iconWithName:(NSString *)name
                    width:(CGFloat)width
                    color:(UIColor *)color
{
    return [UIImage iconWithName:name fontName:kICONFONT_FONTNAME width:width color:color];
}


+ (UIImage *)iconWithName:(NSString *)name
                 fontName:(NSString *)fontName
                    width:(CGFloat)width
                    color:(UIColor *)color
{
    return [UIImage iconWithName:name fontName:fontName imageInsets:UIEdgeInsetsZero width:width color:color];
}

+ (UIImage *)iconWithName:(NSString *)name
                 fontName:(NSString *)fontName
              imageInsets:(UIEdgeInsets)imageInsets
                    width:(CGFloat)width
                    color:(UIColor *)color
{
    CGFloat w1 = width - imageInsets.left - imageInsets.right;
    CGFloat w2 = width - imageInsets.top - imageInsets.bottom;
    CGFloat size = MIN(w1, w2);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat realSize = size * scale;
    CGFloat imageSize = width * scale;

    UIFont *font = [UIFont fontWithName:fontName size:realSize];
    if (font == nil) {
        NSURL *url = [[GTUIIconView bundle] URLForResource:kICONFONT_FONTNAME withExtension:@"ttf"];
        [UIImage registerIconFont:kICONFONT_FONTNAME fontPathURL:url];
        font = [UIFont fontWithName:kICONFONT_FONTNAME size:realSize];
    }

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageSize, imageSize), NO, 0.0);

    // ---------- begin context ----------
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGPoint point = CGPointMake(imageInsets.left*scale, imageInsets.top*scale);

    if ([name respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
        [name drawAtPoint:point withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: color}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGContextSetFillColorWithColor(context, color.CGColor);
        [name drawAtPoint:point withFont:font];
#pragma clang pop
    }

    // fill background
//    [backgroundColor setFill];
//    CGContextFillRect(context, CGRectMake(0, 0, imageSize, imageSize));

    UIImage *iconImage = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:scale orientation:UIImageOrientationUp];

    // ---------- end context ----------
    UIGraphicsEndImageContext();

    return iconImage;
}


@end


