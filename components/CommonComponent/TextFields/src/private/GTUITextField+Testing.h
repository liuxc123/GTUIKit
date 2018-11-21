//
//  GTUITextField+Testing.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

#import "GTUITextField.h"

/**
 Exposes parts of GTUITextField for testing.
 */
@interface GTUITextField (Testing)

/**
 Synthesizes a touch on the clear button of the text field.
 */
- (void)clearButtonDidTouch;

@end
