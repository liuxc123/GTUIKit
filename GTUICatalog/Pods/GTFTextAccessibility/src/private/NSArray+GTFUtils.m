//
//  NSArray+GTFUtils.m
//  GTFTextAccessibility
//
//  Created by liuxc on 2018/8/20.
//

#import "NSArray+GTFUtils.h"

@implementation NSArray (GTFUtils)

- (NSArray *)gtf_arrayByMappingObjects:(GTFMappingFunction)function {
    NSAssert(function, @"Mapping block must not be NULL.");
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [array addObject:function(obj)];
    }];
    return [array copy];
}

- (BOOL)gtf_anyObjectPassesTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    NSIndexSet *indices = [self indexesOfObjectsPassingTest:predicate];
    return [indices count] > 0;
}

- (BOOL)gtf_allObjectsPassTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    NSIndexSet *indices = [self indexesOfObjectsPassingTest:predicate];
    return [indices count] == [self count];
}

- (NSArray *)gtf_sortArray:(NSArray *)array usingComparator:(NSComparator)comparator {
    NSAssert(comparator, @"Comparator block must not be NULL.");

    NSUInteger numElements = [self count];
    NSAssert([array count] == numElements, @"Array %@ must have length %lu.", array,
             (unsigned long)numElements);

    // Create a permutation array by sorting self with comparator.
    NSMutableArray *permutation = [[NSMutableArray alloc] initWithCapacity:numElements];
    for (NSUInteger i = 0; i < numElements; ++i) {
        [permutation addObject:@(i)];
    }

    NSArray *sortedPermutation = [permutation sortedArrayUsingComparator:^(id a, id b) {
        NSUInteger firstIndex = [a unsignedIntegerValue];
        NSUInteger secondIndex = [b unsignedIntegerValue];
        return comparator(self[firstIndex], self[secondIndex]);
    }];

    // Permute array into order.
    NSMutableArray *sorted = [[NSMutableArray alloc] initWithCapacity:numElements];
    for (NSUInteger i = 0; i < numElements; ++i) {
        NSUInteger index = [sortedPermutation[i] unsignedIntegerValue];
        [sorted addObject:array[index]];
    }
    return [sorted copy];
}

@end
