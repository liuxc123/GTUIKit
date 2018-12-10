//
//  GTUIFormTextViewCell.h
//  GTForm
//
//  Created by liuxc on 2018/10/23.
//

#import "GTUIFormTextView.h"
#import "GTUIFormBaseCell.h"
#import <UIKit/UIKit.h>

extern NSString *const GTUIFormTextViewLengthPercentage;
extern NSString *const GTUIFormTextViewMaxNumberOfCharacters;

@interface GTUIFormTextViewCell : GTUIFormBaseCell

@property (nonatomic, readonly) UILabel * textLabel;
@property (nonatomic, readonly) GTUIFormTextView * textView;

@property (nonatomic) NSNumber *textViewLengthPercentage;
@property (nonatomic) NSNumber *textViewMaxNumberOfCharacters;

@end
