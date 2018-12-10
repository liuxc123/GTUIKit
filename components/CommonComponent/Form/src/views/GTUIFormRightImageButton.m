//
//  GTUIFormRightImageButton.m
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormRightImageButton.h"

@implementation GTUIFormRightImageButton

- (CGSize)intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    return CGSizeMake(s.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
                      s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);

}

@end
