//
//  GTUIIntrinsicHeightTextView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

/**
 This differs from UITextView in only one way: the intrinsicContentSize's height will never be
 UIViewNoIntrinsicMetric (-1). If [super intrinsicContentSize].height == -1, return the
 contentSize's height.

 NOTE: UITextView is a subclass of UIScrollView. That's why it has a contentSize.
 */

@interface GTUIIntrinsicHeightTextView : UITextView

@end
