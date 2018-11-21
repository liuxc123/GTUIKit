//
//  GTUIIntrinsicHeightTextView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUIIntrinsicHeightTextView.h"

@implementation GTUIIntrinsicHeightTextView

/**
 When a value in the CGSize of intrinsicContentSize is -1, it's considered undefined. For the
 GTUIMultilineTextField, we want this to always be defined so our layouts are not ambiguous.
 */
- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    if (size.height == UIViewNoIntrinsicMetric) {
        size.height = [self contentSize].height;
    }
    return size;
}

@end
