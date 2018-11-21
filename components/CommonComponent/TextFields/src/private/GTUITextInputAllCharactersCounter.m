//
//  GTUITextInputAllCharactersCounter.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "GTUITextInputCharacterCounter.h"

#import "GTUITextInput.h"

@implementation GTUITextInputAllCharactersCounter

- (NSUInteger)characterCountForTextInput:(UIView<GTUITextInput> *)textInput {
    return textInput.text.length;
}

@end
