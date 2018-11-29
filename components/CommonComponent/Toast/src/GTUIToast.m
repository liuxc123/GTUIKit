//
//  GTUIToast.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import "GTUIToast.h"



static const CGFloat SVProgressHUDParallaxDepthPoints = 10.0f;
static const CGFloat SVProgressHUDUndefinedProgress = -1;
static const CGFloat SVProgressHUDDefaultAnimationDuration = 0.15f;
static const CGFloat SVProgressHUDVerticalSpacing = 12.0f;
static const CGFloat SVProgressHUDHorizontalSpacing = 12.0f;
static const CGFloat SVProgressHUDLabelSpacing = 8.0f;

@interface GTUIToast ()

@property (nonatomic, strong) UIControl *controlView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, readwrite) CGFloat progress;

@end

@implementation GTUIToast

#pragma mark - lift circle
- (instancetype)initWithText:(NSString *)text iconImage:(UIImage *)image position:(GTUIToastPosition)position {
    self = [super initWithFrame:CGRectZero];
    if (self) {

    }
    return self;
}

#pragma mark - Helpers

+ (UIImage *)toastIconWithType:(GTUIToastIcon)iconType
{
    UIImage *iconImage = nil;
    switch (iconType) {
        case GTUIToastIconNone:
            break;
        case GTUIToastIconSuccess:
            break;
        case GTUIToastIconFailure:
            break;
        case GTUIToastIconLoading:
            break;
        case GTUIToastIconNetFailure:
            break;
        case GTUIToastIconSecurityScan:
            break;
        case GTUIToastIconNetError:
            break;
        case GTUIToastIconProgress:
            break;
        case GTUIToastIconAlert:
            break;
        default:
            break;
    }

    return iconImage;
}



@end



