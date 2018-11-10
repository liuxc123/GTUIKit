//
//  GTUITypographyScheme.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import "GTUITypographyScheme.h"

@implementation GTUITypographyScheme

- (instancetype)init {
    return [self initWithDefaults:GTUITypographySchemeDefaults201804];
}

- (instancetype)initWithDefaults:(GTUITypographySchemeDefaults)defaults {
    self = [super init];
    if (self) {
        switch (defaults) {
            case GTUITypographySchemeDefaults201804:
#if defined(__IPHONE_8_2)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
#pragma clang diagnostic ignored "-Wtautological-pointer-compare"
                _headline1 = [UIFont systemFontOfSize:96.0 weight:UIFontWeightLight];
                _headline2 = [UIFont systemFontOfSize:60.0 weight:UIFontWeightLight];
                _headline3 = [UIFont systemFontOfSize:48.0 weight:UIFontWeightRegular];
                _headline4 = [UIFont systemFontOfSize:34.0 weight:UIFontWeightRegular];
                _headline5 = [UIFont systemFontOfSize:24.0 weight:UIFontWeightRegular];
                _headline6 = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
                _subtitle1 = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
                _subtitle2 = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
                _body1 = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
                _body2 = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
                _caption = [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
                _button = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
                _overline = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
#pragma clang diagnostic pop
#else
                // TODO(#1296): Remove after we drop support for iOS 8
                _headline1 = [UIFont systemFontOfSize:96.0];
                _headline2 = [UIFont systemFontOfSize:60.0];
                _headline3 = [UIFont systemFontOfSize:48.0];
                _headline4 = [UIFont systemFontOfSize:34.0];
                _headline5 = [UIFont systemFontOfSize:24.0];
                _headline6 = [UIFont systemFontOfSize:20.0];
                _subtitle1 = [UIFont systemFontOfSize:16.0];
                _subtitle2 = [UIFont systemFontOfSize:14.0];
                _body1 = [UIFont systemFontOfSize:16.0];
                _body2 = [UIFont systemFontOfSize:14.0];
                _caption = [UIFont systemFontOfSize:12.0];
                _button = [UIFont systemFontOfSize:14.0];
                _overline = [UIFont systemFontOfSize:12.0];
#endif
                break;
        }
    }
    return self;
}


@end
