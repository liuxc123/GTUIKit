//
//  GTUIButtonBar+Private.h
//  Pods
//
//  Created by liuxc on 2018/11/19.
//

#import "GTUIButtonBar.h"

@interface GTUIButtonBar (Builder)

/**
 Finds the corresponding UIBarButtonItem and calls its target/action with the item as the first
 parameter.
 */
- (void)didTapButton:(UIButton *)button event:(UIEvent *)event;

@end
