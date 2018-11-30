//
//  GTUINetErrorView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "GTUINetErrorView.h"

const NSString *kImageKey = @"imagekey";
const NSString *kTitleStrKey = @"titleStrkey";
const NSString *kDetailStrKey = @"detailStrkey";
const NSString *kBtnStrKey = @"btnStrKey";

#define DEFAULTBORDERWIDTH (1.0f / [[UIScreen mainScreen] scale] + 0.02f)

@implementation GTUINetErrorView

+ (instancetype)netErrorViewWithStyle:(GTUINetErrorStyle)style type:(GTUINetErrorType)type {

    return  [GTUINetErrorView netErrorViewWithStyle:style type:type target:nil action:nil];
}

+ (instancetype)netErrorViewWithStyle:(GTUINetErrorStyle)style
                                 type:(GTUINetErrorType)type
                               target:(id)target
                               action:(SEL)action {

    GTUINetErrorView *netErrorView;
    NSDictionary *infoDictionary = [GTUINetErrorView netErrorViewImageWithStyle:style type:type];

    netErrorView = [GTUINetErrorView emptyActionViewWithImage:infoDictionary[kImageKey] titleStr:infoDictionary[kTitleStrKey] detailStr:infoDictionary[kDetailStrKey] btnTitleStr:infoDictionary[infoDictionary] target:target action:action];

    if (style == GTUINetErrorStyleMiniimalist) {
        netErrorView.actionBtnBorderWidth = DEFAULTBORDERWIDTH;
        netErrorView.actionBtnBorderColor = [UIColor colorWithRed:108.0/255.f green:188.0/255.f blue:238.0/255.f alpha:1.f];
        netErrorView.actionBtnTitleColor = [UIColor colorWithRed:108.0/255.f green:188.0/255.f blue:238.0/255.f alpha:1.f];
        netErrorView.titleLabTextColor = [UIColor colorWithRed:84.0/255.f green:84.0/255.f blue:84.0/255.f alpha:1.f];
    } else {
        netErrorView.titleLabTextColor = [UIColor colorWithRed:84.0/255.f green:84.0/255.f blue:84.0/255.f alpha:1.f];
        netErrorView.actionBtnBorderWidth = 0;
        netErrorView.actionBtnBorderColor = [UIColor clearColor];
        netErrorView.actionBtnTitleColor = [UIColor colorWithRed:108.0/255.f green:188.0/255.f blue:238.0/255.f alpha:1.f];
    }

    return netErrorView;
}


+ (NSDictionary *)netErrorViewImageWithStyle:(GTUINetErrorStyle)style type:(GTUINetErrorType)type {

    NSMutableDictionary *infoDictionary = [NSMutableDictionary dictionary];


    if (style == GTUINetErrorStyleMiniimalist) {
        switch (type) {
            case GTUINetErrorTypeLimit://系统繁忙
                infoDictionary[kImageKey] = nil;
                infoDictionary[kTitleStrKey] = @"请稍等哦，马上出来";
                infoDictionary[kBtnStrKey] = @"刷新";
                break;
            case GTUINetErrorTypeAlert:
            case GTUINetErrorTypeNotFound:
                infoDictionary[kImageKey] = nil;
                infoDictionary[kTitleStrKey] = @"忙不过来了，客官请稍候";
                infoDictionary[kBtnStrKey] = @"刷新";
                break;
            case GTUINetErrorTypeNetworkError:
                infoDictionary[kImageKey] = nil;
                infoDictionary[kTitleStrKey] = @"网络不给力";
                infoDictionary[kBtnStrKey] = @"点击重试";
                break;
            case GTUINetErrorTypeEmpty:
                infoDictionary[kImageKey] = nil;
                infoDictionary[kTitleStrKey] = @"什么都没有";
                infoDictionary[kBtnStrKey] = @"点击重试";
                break;
            case GTUINetErrorTypeUserLogout:
                infoDictionary[kImageKey] = nil;
                infoDictionary[kTitleStrKey] = @"此用户注销";
                infoDictionary[kBtnStrKey] = @"刷新";
                break;
            default:
                break;
        }
    }

    return infoDictionary;
}


#pragma mark - Resource bundle

+ (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[self bundlePathWithName:@"GTUINetErrorView.bundle"]];
    });

    return bundle;
}

+ (NSString *)bundlePathWithName:(NSString *)bundleName {
    // In iOS 8+, we could be included by way of a dynamic framework, and our resource bundles may
    // not be in the main .app bundle, but rather in a nested framework, so figure out where we live
    // and use that as the search location.
    NSBundle *bundle = [NSBundle bundleForClass:[GTUINetErrorView class]];
    NSString *resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle) resourcePath];
    return [resourcePath stringByAppendingPathComponent:bundleName];
}

@end
