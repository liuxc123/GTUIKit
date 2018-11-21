//
//  GTUITextInputCharacterCounter.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

@protocol GTUITextInput;

/**
 Protocol for custom character counters.

 Instead of relying on the default character count which is naive (counts each character regardless
 of context), this object can instead choose to do sophisticated counting (ie: ignoring whitespace,
 ignoring url strings, ignoring usernames, etc).
 */
@protocol GTUITextInputCharacterCounter <NSObject>

/**
 Returns the count of characters for the text field.

 @param textInput   The text input to count from.

 @return            The count of characters.
 */
- (NSUInteger)characterCountForTextInput:(nullable UIView<GTUITextInput> *)textInput;

@end

/**
 The default character counter.

 GTUITextInputAllCharactersCounter is naive (counts each character regardless of context).
 */
@interface GTUITextInputAllCharactersCounter : NSObject <GTUITextInputCharacterCounter>

@end
