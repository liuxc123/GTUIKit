//
//  NSExpression+GTUIFormAdditions.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "NSExpression+GTUIFormAdditions.h"

@implementation NSExpression (GTUIFormAdditions)

- (NSMutableArray *)getExpressionVars {
    switch (self.expressionType) {
        case NSFunctionExpressionType:{
            NSString* str = [NSString stringWithFormat:@"%@", self];
            if ([str rangeOfString:@"."].location != NSNotFound)
                str = [str substringWithRange:NSMakeRange(1, [str rangeOfString:@"."].location - 1)];
            else
                str = [str substringFromIndex:1];
            return [[NSMutableArray alloc] initWithObjects: str, nil];
            break;
        }
        default:
            return nil;
            break;
    }
}

@end
