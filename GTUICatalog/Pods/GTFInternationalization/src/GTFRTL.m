//
//  GTFRTL.m
//  Pods-GTFInternationalization_Example
//
//  Created by liuxc on 2018/8/20.
//

#import "GTFRTL.h"


UIViewAutoresizing GTFLeadingMarginAutoresizingMaskForLayoutDirection(
                                                                      UIUserInterfaceLayoutDirection layoutDirection) {
    switch (layoutDirection) {
        case UIUserInterfaceLayoutDirectionLeftToRight:
            return UIViewAutoresizingFlexibleLeftMargin;
        case UIUserInterfaceLayoutDirectionRightToLeft:
            return UIViewAutoresizingFlexibleRightMargin;
    }
    NSCAssert(NO, @"Invalid enumeration value %i.", (int)layoutDirection);
    return UIViewAutoresizingFlexibleLeftMargin;
}

UIViewAutoresizing GTFTrailingMarginAutoresizingMaskForLayoutDirection(
                                                                       UIUserInterfaceLayoutDirection layoutDirection) {
    switch (layoutDirection) {
        case UIUserInterfaceLayoutDirectionLeftToRight:
            return UIViewAutoresizingFlexibleRightMargin;
        case UIUserInterfaceLayoutDirectionRightToLeft:
            return UIViewAutoresizingFlexibleLeftMargin;
    }
    NSCAssert(NO, @"Invalid enumeration value %i.", (int)layoutDirection);
    return UIViewAutoresizingFlexibleRightMargin;
}

CGRect GTFRectFlippedHorizontally(CGRect frame, CGFloat containerWidth) {
    CGRect flippedRect = CGRectStandardize(frame);
    CGFloat leadingInset = CGRectGetMinX(flippedRect);
    CGFloat width = CGRectGetWidth(flippedRect);
    flippedRect.origin.x = containerWidth - leadingInset - width;

    return flippedRect;
}

UIEdgeInsets GTFInsetsFlippedHorizontally(UIEdgeInsets insets) {
    UIEdgeInsets flippedInsets = insets;
    flippedInsets.left = insets.right;
    flippedInsets.right = insets.left;

    return flippedInsets;
}

UIEdgeInsets GTFInsetsMakeWithLayoutDirection(CGFloat top,
                                              CGFloat leading,
                                              CGFloat bottom,
                                              CGFloat trailing,
                                              UIUserInterfaceLayoutDirection layoutDirection) {
    switch (layoutDirection) {
        case UIUserInterfaceLayoutDirectionLeftToRight:
            return UIEdgeInsetsMake(top, leading, bottom, trailing);
        case UIUserInterfaceLayoutDirectionRightToLeft:
            return UIEdgeInsetsMake(top, trailing, bottom, leading);
    }
    NSCAssert(NO, @"Invalid enumeration value %i.", (int)layoutDirection);
    return UIEdgeInsetsMake(top, leading, bottom, trailing);
}

