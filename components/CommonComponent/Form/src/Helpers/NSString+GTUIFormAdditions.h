//
//  NSString+GTUIFormAdditions.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTUIFormDescriptor.h"

@interface NSString (GTUIFormAdditions)

- (NSPredicate *)formPredicate;

- (NSString *)formKeyForPredicateType:(GTCPredicateType)predicateType;

- (CGSize)gtc_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;

@end
