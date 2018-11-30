//
//  GTUIToast+GTUIKit.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/29.
//

#import "GTUIToast+GTUIKit.h"

// The Bundle for string resources.
static NSString *const kGTUIToastBundle = @"GTUIToast.bundle";

@implementation GTUIToast (GTUIKit)

+ (GTUIToast *)presentToastWithText:(NSString *)text {
    return [GTUIToast presentToastWithIn:nil text:text];
}

+ (GTUIToast *)presentToastWithIn:(UIView *)superview text:(NSString *)text {
    GTUIToast *toast = [GTUIToast createGTUIProgressHUDviewWithtext:text superView:superview];
    toast.mode = GTUIToastModeText;
    toast.yOffset = GTUIProgressBottomMaxOffset;
    toast.backgroundView.hidden = YES;
    toast.userInteractionEnabled = NO;
    toast.label.numberOfLines = 2;
    return toast;
}

+ (GTUIToast *)presentToastWithin:(UIView *)superview
                         withIcon:(GTUIToastIcon)icon
                             text:(NSString *)text {
    return [GTUIToast presentToastWithin:superview withIcon:icon text:text duration:0 delay:0.0f completion:nil];
}

+ (GTUIToast *)presentToastWithin:(UIView *)superview
                         withIcon:(GTUIToastIcon)icon
                             text:(NSString *)text
                         duration:(NSTimeInterval)duration {
    return [GTUIToast presentToastWithin:superview withIcon:icon text:text duration:duration delay:0.0f completion:nil];
}


+ (GTUIToast *)presentToastWithin:(UIView *)superview
                         withIcon:(GTUIToastIcon)icon
                             text:(NSString *)text
                         duration:(NSTimeInterval)duration
                       completion:(void (^)(void))completion {

    return [GTUIToast presentToastWithin:superview withIcon:icon text:text duration:duration delay:0.0f completion:nil];
}


+ (GTUIToast *)presentToastWithin:(UIView *)superview
                         withIcon:(GTUIToastIcon)icon
                             text:(NSString *)text
                         duration:(NSTimeInterval)duration
                            delay:(NSTimeInterval)delay
                       completion:(void(^)(void))completion {

    NSString *showText = [text copy];
    if (!text) showText = [GTUIToast toastTextWithType:icon];

    GTUIToast *toast = [GTUIToast createGTUIProgressHUDviewWithtext:showText superView:superview];
    toast.completionBlock = completion;
    toast.userInteractionEnabled = NO;

    UIImage *iconName = [GTUIToast toastIconWithType:icon];
    toast.mode = [GTUIToast toastModeWithType:icon];
    if (iconName) toast.customView = [[UIImageView alloc] initWithImage:iconName];
    if (duration != 0) [toast hideAnimated:YES afterDelay:duration];
    return toast;
}

+ (GTUIToast *)presentModelToastWithin:(UIView *)superview text:(NSString *)text {
    return [GTUIToast presentModelToastWithin:superview withIcon:GTUIToastIconNone text:text duration:GTUIToast_Default_Duration delay:0.f completion: nil];
}

+ (GTUIToast *)presentModelToastWithin:(UIView *)superview
                              withIcon:(GTUIToastIcon)icon
                                  text:(NSString *)text
                              duration:(NSTimeInterval)duration
                            completion:(void (^)(void))completion
{
    return [GTUIToast presentModelToastWithin:superview withIcon:icon text:text duration:duration delay:0.f completion: completion];
}

+ (GTUIToast *)presentModelToastWithin:(UIView *)superview withIcon:(GTUIToastIcon)icon text:(NSString *)text duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void (^)(void))completion {

    NSString *showText = [text copy];
    if (!text) showText = [GTUIToast toastTextWithType:icon];

    GTUIToast *toast = [GTUIToast createGTUIProgressHUDviewWithtext:showText superView:superview];
    toast.userInteractionEnabled = YES;

    toast.backgroundView.style = GTUIToastBackgroundStyleBlur;
    toast.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];

    UIImage *iconName = [GTUIToast toastIconWithType:icon];
    toast.mode = [GTUIToast toastModeWithType:icon];
    toast.customView = [[UIImageView alloc] initWithImage:iconName];
    toast.completionBlock = completion;
    if (duration != 0) [toast hideAnimated:YES afterDelay:duration];
    return toast;
}

- (void)setProgressPrefix:(NSString *)prefix {
    self.label.text = prefix;
}

- (void)setProgressText:(float)value {
    self.progress = value;
}

- (void)dismissToast {
    [GTUIToast hideHUDForView:self.superview animated:YES];
}

+ (void)dismissAllToastWithView:(UIView *)view {
    [GTUIToast hideAllHUDsForView:view animated:YES];
}

+ (void)dismissAllToast {
    UIView *winView = (UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideAllHUDsForView:winView animated:YES];
    [self hideAllHUDsForView:[self getCurrentUIVC].view animated:YES];
}

- (CGFloat)yOffset {
    return self.offset.y;
}

- (void)setYOffset:(CGFloat)yOffset {
    CGPoint tempOffset = self.offset;
    tempOffset.y = yOffset;
    self.offset = tempOffset;
}

- (CGFloat)xOffset {
    return self.offset.x;
}

- (void)setXOffset:(CGFloat)xOffset {
    CGPoint tempOffset = self.offset;
    tempOffset.x = xOffset;
    self.offset = tempOffset;
}

#pragma mark - Helpers

+ (GTUIToast *)createGTUIProgressHUDviewWithtext:(NSString *)text superView:(UIView *)superView {
    UIView  *view = superView ? superView : (UIView*)[UIApplication sharedApplication].delegate.window ;
    GTUIToast *toast = [GTUIToast showHUDAddedTo:view animated:YES];
    toast.animationType = GTUIToastAnimationZoom;
    toast.bezelView.color = [UIColor blackColor];
    toast.label.text=text?text:@"加载中.....";
    toast.label.font=[UIFont systemFontOfSize:15];
    toast.contentColor = [UIColor whiteColor];
    toast.removeFromSuperViewOnHide = YES;
    toast.square = YES;

    return toast;
}

+ (UIImage *)toastIconWithType:(GTUIToastIcon)iconType
{
    UIImage *iconImage = nil;
    switch (iconType) {
        case GTUIToastIconNone:
            break;
        case GTUIToastIconSuccess:
            iconImage = [GTUIToast toastResourceImage:@"success_toast"];
            break;
        case GTUIToastIconFailure:
            iconImage = [GTUIToast toastResourceImage:@"failure_toast"];
            break;
        case GTUIToastIconLoading:
            break;
        case GTUIToastIconNetFailure:
            iconImage = [GTUIToast toastResourceImage:@"failure_toast"];
            break;
        case GTUIToastIconSecurityScan:
            iconImage = [GTUIToast toastResourceImage:@"security_toast"];
            break;
        case GTUIToastIconNetError:
            iconImage = [GTUIToast toastResourceImage:@"failure_toast"];
            break;
        case GTUIToastIconProgress:
            break;
        case GTUIToastIconAlert:
            iconImage = [GTUIToast toastResourceImage:@"failure_toast"];
            break;
        default:
            break;
    }

    return iconImage;
}

+ (NSString *)toastTextWithType:(GTUIToastIcon)iconType
{
    NSString *iconText = @"";
    switch (iconType) {
        case GTUIToastIconNone:
            break;
        case GTUIToastIconSuccess:
            iconText = @"成功提示";
            break;
        case GTUIToastIconFailure:
            iconText = @"系统繁忙";
            break;
        case GTUIToastIconLoading:
            iconText = @"加载中";
            break;
        case GTUIToastIconNetFailure:
            iconText = @"网络不给力";
            break;
        case GTUIToastIconSecurityScan:
            iconText = @"安全扫描";
            break;
        case GTUIToastIconNetError:
            iconText = @"网络无法连接";
            break;
        case GTUIToastIconProgress:
            break;
        case GTUIToastIconAlert:
            iconText = @"警告提示";
            break;
        default:
            break;
    }

    return iconText;
}


+ (GTUIToastMode)toastModeWithType:(GTUIToastIcon)iconType
{
    GTUIToastMode toastMode = GTUIToastModeCustomView;
    switch (iconType) {
        case GTUIToastIconNone:
            toastMode = GTUIToastModeText;
            break;
        case GTUIToastIconSuccess:
        case GTUIToastIconFailure:
        case GTUIToastIconNetFailure:
        case GTUIToastIconSecurityScan:
        case GTUIToastIconNetError:
        case GTUIToastIconAlert:
            toastMode = GTUIToastModeCustomView;
            break;
        case GTUIToastIconLoading:
            toastMode = GTUIToastModeIndeterminate;
            break;
        case GTUIToastIconProgress:
            toastMode = GTUIToastModeAnnularDeterminate;
            break;
        default:
            break;
    }

    return toastMode;
}

#pragma mark - Resource bundle

+ (UIImage *)toastResourceImage:(NSString *)imageName {
    return [UIImage imageNamed:imageName inBundle:[GTUIToast bundle] compatibleWithTraitCollection:nil];
}

+ (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[self bundlePathWithName:kGTUIToastBundle]];
    });

    return bundle;
}

+ (NSString *)bundlePathWithName:(NSString *)bundleName {
    // In iOS 8+, we could be included by way of a dynamic framework, and our resource bundles may
    // not be in the main .app bundle, but rather in a nested framework, so figure out where we live
    // and use that as the search location.
    NSBundle *bundle = [NSBundle bundleForClass:[GTUIToast class]];
    NSString *resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle) resourcePath];
    return [resourcePath stringByAppendingPathComponent:bundleName];
}


#pragma mark --- 获取当前Window试图---------
//获取当前屏幕显示的viewcontroller
+ (UIViewController*)getCurrentWindowVC
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        //2、通过navigationcontroller弹出VC
        //        NSLog(@"subviews == %@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    return nextResponder;
}

+ (UINavigationController*)getCurrentNaVC
{

    UIViewController  *viewVC = (UIViewController*)[ self getCurrentWindowVC ];
    UINavigationController  *naVC;
    if ([viewVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController  *tabbar = (UITabBarController*)viewVC;
        naVC = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        if (naVC.presentedViewController) {
            while (naVC.presentedViewController) {
                naVC = (UINavigationController*)naVC.presentedViewController;
            }
        }
    }else
        if ([viewVC isKindOfClass:[UINavigationController class]]) {

            naVC  = (UINavigationController*)viewVC;
            if (naVC.presentedViewController) {
                while (naVC.presentedViewController) {
                    naVC = (UINavigationController*)naVC.presentedViewController;
                }
            }
        }else
            if ([viewVC isKindOfClass:[UIViewController class]])
            {
                if (viewVC.navigationController) {
                    return viewVC.navigationController;
                }
                return  (UINavigationController*)viewVC;
            }
    return naVC;
}

+ (UIViewController*)getCurrentUIVC
{
    UIViewController   *cc;
    UINavigationController  *na = (UINavigationController*)[[self class] getCurrentNaVC];
    if ([na isKindOfClass:[UINavigationController class]]) {
        cc =  na.viewControllers.lastObject;
    }else
    {
        cc = (UIViewController*)na;
    }
    return cc;
}
+ (UIViewController *)getSubUIVCWithVC:(UIViewController*)vc
{
    UIViewController   *cc;
    cc =  vc.childViewControllers.lastObject;
    if (cc.childViewControllers>0) {

        [[self class] getSubUIVCWithVC:cc];
    }else
    {
        return cc;
    }
    return cc;
}


@end
