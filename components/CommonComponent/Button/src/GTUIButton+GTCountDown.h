//
//  GTUIButton+GTCountDown.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import "GTUIButton.h"

@interface GTUIButton (GTCountDown)

/**
 倒计时按钮

 @param timeout 倒计时时间（单位：秒）
 @param title 标题
 @param waitTitle 倒计时标题
 */
- (void)startCountDownWithTimeOut:(NSInteger)timeout title:(NSString *)title waitTitle:(NSString *)waitTitle;

@end
