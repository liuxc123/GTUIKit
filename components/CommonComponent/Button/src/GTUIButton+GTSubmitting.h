//
//  GTUIButton+GTSubmitting.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import "GTUIButton.h"

@interface GTUIButton (GTSubmitting)

/**
 按钮点击后，禁用按钮并在按钮上显示ActivityIndicator，以及title

 @param title 按钮上显示的文字
 */
- (void)beginSubmitting:(NSString *)title;

/**
 按钮点击后，恢复按钮点击前的状态
 */
- (void)endSubmitting;

/**
 *
 *  @brief  按钮是否正在提交中
 */
@property(nonatomic, readonly, getter=isSubmitting) NSNumber *submitting;

@end
