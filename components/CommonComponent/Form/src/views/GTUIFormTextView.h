//
//  GTUIFormTextView.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import <UIKit/UIKit.h>

@interface GTUIFormTextView : UITextView

@property (nonatomic) NSString *placeholder;
@property (nonatomic) UIColor *placeholderColor;

@property (readonly) UILabel *placeHolderLabel;

@end
