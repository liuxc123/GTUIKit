//
//  NSPredicate+GTUIFormAdditions.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "NSPredicate+GTUIFormAdditions.h"
#import "NSExpression+GTUIFormAdditions.h"

@implementation NSPredicate (GTUIFormAdditions)

- (NSMutableArray *)getPredicateVars {
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    if ([self isKindOfClass:([NSCompoundPredicate class])]) {
        for (id object in ((NSCompoundPredicate*) self).subpredicates ) {
            [ret addObjectsFromArray:[object getPredicateVars]];
        }
    }
    else if ([self isKindOfClass:([NSComparisonPredicate class])]){
        [ret addObjectsFromArray:[((NSComparisonPredicate*) self).leftExpression getExpressionVars]];
        [ret addObjectsFromArray:[((NSComparisonPredicate*) self).rightExpression getExpressionVars]];
    }
    return ret;
}

@end
