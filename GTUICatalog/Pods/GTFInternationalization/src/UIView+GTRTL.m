//
//  UIView+GTRTL.m
//  Pods-GTFInternationalization_Example
//
//  Created by liuxc on 2018/8/20.
//

#import "UIView+GTRTL.h"

#import <objc/runtime.h>

#define GTF_BASE_SDK_EQUAL_OR_ABOVE(x) \
(defined(__IPHONE_##x) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_##x))

// UISemanticContentAttribute was added in iOS SDK 9.0 but is available on devices running earlier
// version of iOS. We ignore the partial-availability warning that gets thrown on our use of this
// symbol.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"

static inline UIUserInterfaceLayoutDirection
MDFUserInterfaceLayoutDirectionForSemanticContentAttributeRelativeToLayoutDirection(
                                                                                    UISemanticContentAttribute semanticContentAttribute,
                                                                                    UIUserInterfaceLayoutDirection userInterfaceLayoutDirection) {
    switch (semanticContentAttribute) {
        case UISemanticContentAttributeUnspecified:
            return userInterfaceLayoutDirection;
        case UISemanticContentAttributePlayback:
        case UISemanticContentAttributeSpatial:
        case UISemanticContentAttributeForceLeftToRight:
            return UIUserInterfaceLayoutDirectionLeftToRight;
        case UISemanticContentAttributeForceRightToLeft:
            return UIUserInterfaceLayoutDirectionRightToLeft;
    }
    NSCAssert(NO, @"Invalid enumeration value %i.", (int)semanticContentAttribute);
    return userInterfaceLayoutDirection;
}

@interface UIView (MaterialRTLPrivate)

// On iOS 9 and above, gtf_semanticContentAttribute is backed by UIKit's semanticContentAttribute.
// On iOS 8 and below, gtf_semanticContentAttribute is backed by an associated object.
@property(nonatomic, setter=gtf_setAssociatedSemanticContentAttribute:)
UISemanticContentAttribute gtf_associatedSemanticContentAttribute;

@end

@implementation UIView (MaterialRTL)

- (UISemanticContentAttribute)gtf_semanticContentAttribute {
#if GTF_BASE_SDK_EQUAL_OR_ABOVE(9_0)
    if ([self respondsToSelector:@selector(semanticContentAttribute)]) {
        return self.semanticContentAttribute;
    } else
#endif  // GTF_BASE_SDK_EQUAL_OR_ABOVE(9_0)
    {
        return self.gtf_associatedSemanticContentAttribute;
    }
}

- (void)gtf_setSemanticContentAttribute:(UISemanticContentAttribute)semanticContentAttribute {
#if GTF_BASE_SDK_EQUAL_OR_ABOVE(9_0)
    if ([self respondsToSelector:@selector(semanticContentAttribute)]) {
        self.semanticContentAttribute = semanticContentAttribute;
    } else
#endif  // GTF_BASE_SDK_EQUAL_OR_ABOVE(9_0)
    {
        self.gtf_associatedSemanticContentAttribute = semanticContentAttribute;
    }

    // Invalidate the layout.
    [self setNeedsLayout];
}

- (UIUserInterfaceLayoutDirection)gtf_effectiveUserInterfaceLayoutDirection {
#if GTF_BASE_SDK_EQUAL_OR_ABOVE(10_0)
    if ([self respondsToSelector:@selector(effectiveUserInterfaceLayoutDirection)]) {
        return self.effectiveUserInterfaceLayoutDirection;
    } else {
        return [UIView gtf_userInterfaceLayoutDirectionForSemanticContentAttribute:
                self.gtf_semanticContentAttribute];
    }
#else
    return [UIView gtf_userInterfaceLayoutDirectionForSemanticContentAttribute:
            self.gtf_semanticContentAttribute];
#endif  // GTF_BASE_SDK_EQUAL_OR_ABOVE(10_0)
}

+ (UIUserInterfaceLayoutDirection)gtf_userInterfaceLayoutDirectionForSemanticContentAttribute:
(UISemanticContentAttribute)attribute {
#if GTF_BASE_SDK_EQUAL_OR_ABOVE(9_0)
    if ([self
         respondsToSelector:@selector(userInterfaceLayoutDirectionForSemanticContentAttribute:)]) {
        return [self userInterfaceLayoutDirectionForSemanticContentAttribute:attribute];
    } else
#endif  // GTF_BASE_SDK_EQUAL_OR_ABOVE(9_0)
    {
        // If we are running in the context of an app, we query [UIApplication sharedApplication].
        // Otherwise use a default of Left-to-Right.
        UIUserInterfaceLayoutDirection applicationLayoutDirection =
        UIUserInterfaceLayoutDirectionLeftToRight;
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        // Can I use kAppBundleIdentifier ?
        if ([bundlePath hasSuffix:@".app"]) {
            // We can't call sharedApplication directly or an error gets thrown for app extensions.
            UIApplication *application =
            [[UIApplication class] performSelector:@selector(sharedApplication)];
            applicationLayoutDirection = application.userInterfaceLayoutDirection;
        }
        return [self
                gtf_userInterfaceLayoutDirectionForSemanticContentAttribute:attribute
                relativeToLayoutDirection:applicationLayoutDirection];
    }
}

+ (UIUserInterfaceLayoutDirection)
gtf_userInterfaceLayoutDirectionForSemanticContentAttribute:
(UISemanticContentAttribute)semanticContentAttribute
relativeToLayoutDirection:
(UIUserInterfaceLayoutDirection)layoutDirection {
#if GTF_BASE_SDK_EQUAL_OR_ABOVE(10_0)
    if ([self
         respondsToSelector:@selector(userInterfaceLayoutDirectionForSemanticContentAttribute:
                                      relativeToLayoutDirection:)]) {
             return [self userInterfaceLayoutDirectionForSemanticContentAttribute:semanticContentAttribute
                                                        relativeToLayoutDirection:layoutDirection];
         } else {
             return MDFUserInterfaceLayoutDirectionForSemanticContentAttributeRelativeToLayoutDirection(
                                                                                                        semanticContentAttribute, layoutDirection);
         }
#else
    return MDFUserInterfaceLayoutDirectionForSemanticContentAttributeRelativeToLayoutDirection(
                                                                                               semanticContentAttribute, layoutDirection);
#endif  // GTF_BASE_SDK_EQUAL_OR_ABOVE(10_0)
}

@end

@implementation UIView (MaterialRTLPrivate)

- (UISemanticContentAttribute)gtf_associatedSemanticContentAttribute {
    NSNumber *semanticContentAttributeNumber =
    objc_getAssociatedObject(self, @selector(gtf_semanticContentAttribute));
    if (semanticContentAttributeNumber != nil) {
        return [semanticContentAttributeNumber integerValue];
    }
    return UISemanticContentAttributeUnspecified;
}

- (void)gtf_setAssociatedSemanticContentAttribute:
(UISemanticContentAttribute)semanticContentAttribute {
    objc_setAssociatedObject(self, @selector(gtf_semanticContentAttribute),
                             @(semanticContentAttribute), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma clang diagnostic pop
