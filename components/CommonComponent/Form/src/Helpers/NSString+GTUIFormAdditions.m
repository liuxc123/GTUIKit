//
//  NSString+GTUIFormAdditions.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "NSString+GTUIFormAdditions.h"

@implementation NSString (GTUIFormAdditions)

- (NSPredicate *)formPredicate {

    // returns an array of strings where the first one is the new string with the correct replacements
    // and the rest are all the tags that appear in the string
    NSString* separator = @"$";

    NSArray* tokens = [self componentsSeparatedByString:separator];
    NSMutableString* new_string = [[NSMutableString alloc] initWithString:tokens[0]];
    NSRange range;
    for (int i = 1; i < tokens.count; i++) {
        [new_string appendString:separator];
        NSArray* subtokens = [[tokens[i] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" <>!=+-&|()"]][0]
                              componentsSeparatedByString:@"."];
        NSString* tag = subtokens[0];
        NSString* attribute;
        if ([subtokens count] >= 2) {
            attribute = subtokens[1];
        }
        [new_string appendString:tag];
        range = [tokens[i] rangeOfString:[NSString stringWithFormat:@"%@", tag]];
        if (!attribute || (![attribute isEqualToString:@"value"] && ![attribute isEqualToString:@"isHidden"] && ![attribute isEqualToString:@"isDisabled"])){
            [new_string appendString:@".value"];
        }
        [new_string appendString:[tokens[i] substringFromIndex:range.location + range.length]];
    }
    return [NSPredicate predicateWithFormat:new_string];
}

- (NSString *)formKeyForPredicateType:(GTCPredicateType)predicateType {
    return [NSString stringWithFormat:@"%@-%@", self, (predicateType == GTCPredicateTypeHidden ? @"hidden" : @"disabled") ];
}

- (CGSize)gtc_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight {
    if (self.length) {
        NSDictionary *attributes = @{NSFontAttributeName : font};
        CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
        return [self boundingRectWithSize:maxSize
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:attributes
                                  context:nil].size;
    } else {
        return CGSizeZero;
    }
}


@end
