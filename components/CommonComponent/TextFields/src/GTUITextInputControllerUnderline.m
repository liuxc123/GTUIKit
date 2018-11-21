//
//  GTUITextInputControllerUnderline.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputControllerUnderline.h"


static const CGFloat GTUITextInputControllerUnderlineDefaultUnderlineActiveHeight = 2;
static const CGFloat GTUITextInputControllerUnderlineDefaultUnderlineNormalHeight = 1;

static CGFloat _underlineHeightActiveDefault =
GTUITextInputControllerUnderlineDefaultUnderlineActiveHeight;
static CGFloat _underlineHeightNormalDefault =
GTUITextInputControllerUnderlineDefaultUnderlineNormalHeight;

@interface GTUITextInputControllerUnderline ()
@end

@implementation GTUITextInputControllerUnderline

#pragma mark - Properties

+ (CGFloat)underlineHeightActiveDefault {
    return _underlineHeightActiveDefault;
}

+ (void)setUnderlineHeightActiveDefault:(CGFloat)underlineHeightActiveDefault {
    _underlineHeightActiveDefault = underlineHeightActiveDefault;
}

+ (CGFloat)underlineHeightNormalDefault {
    return _underlineHeightNormalDefault;
}

+ (void)setUnderlineHeightNormalDefault:(CGFloat)underlineHeightNormalDefault {
    _underlineHeightNormalDefault = underlineHeightNormalDefault;
}

@end

