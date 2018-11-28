//
//  GTUILayoutMetrics.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/7.
//

#import "GTUILayoutMetrics.h"
#import "GTApplication.h"

static const CGFloat kFixedStatusBarHeightOnPreiPhoneXDevices = 20;

static BOOL HasHardwareSafeAreas(void) {
    static BOOL hasHardwareSafeAreas = NO;
    if (@available(iOS 11.0, *)) {
        static BOOL hasCheckedForHardwareSafeAreas = NO;
        static dispatch_once_t onceToken;
        if (!hasCheckedForHardwareSafeAreas && [UIApplication gtui_safeSharedApplication].keyWindow) {
            dispatch_once(&onceToken, ^{
                UIEdgeInsets insets = [UIApplication gtui_safeSharedApplication].keyWindow.safeAreaInsets;
                hasHardwareSafeAreas = (insets.top > kFixedStatusBarHeightOnPreiPhoneXDevices
                                        || insets.left > 0
                                        || insets.bottom > 0
                                        || insets.right > 0);

                hasCheckedForHardwareSafeAreas = YES;
            });
        }
    }
    return hasHardwareSafeAreas;
}

CGFloat GTUIDeviceTopSafeAreaInset(void) {
    CGFloat topInset = kFixedStatusBarHeightOnPreiPhoneXDevices;
    if (@available(iOS 11.0, *)) {
        if (HasHardwareSafeAreas()) {
            UIEdgeInsets insets = [UIApplication gtui_safeSharedApplication].keyWindow.safeAreaInsets;
            topInset = insets.top;
        }
    }
    return topInset;
}

CGFloat GTUIDeviceBottomSafeAreaInset(void) {
    CGFloat bottomInset = 0;
    if (@available(iOS 11.0, *)) {
        if (HasHardwareSafeAreas()) {
            UIEdgeInsets insets = [UIApplication gtui_safeSharedApplication].keyWindow.safeAreaInsets;
            bottomInset = insets.bottom;
        }
    }
    return bottomInset;
}


