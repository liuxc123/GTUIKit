//
//  NSArray+GTFUtils.h
//  GTFTextAccessibility
//
//  Created by liuxc on 2018/8/20.
//

#import <Foundation/Foundation.h>

typedef id (^GTFMappingFunction)(id object);

/** Functional extensions to NSArray. */
@interface NSArray (GTFUtils)

/**
 * Returns an array consisting of applying |function| to each element of self in order.
 *
 * @param function A block mapping an input element to an output element.
 * @return An array of the same size as self containing elements mapped through the function.
 */
- (NSArray *)gtf_arrayByMappingObjects:(GTFMappingFunction)function;

/**
 * Returns a sorted version of |array| by using the passed comparator on self.
 *
 * @note The comparator acts of elements of self, @em not |array|.
 *
 * Example:
 * @code
 * NSArray *weights = @[ 100, 200, 50 ];
 * NSArray *dogs = @[ @"Bruno", @"Tiger", @"Spot" ];
 * NSComparator *ascending = ... NSString comparator ...
 * NSArray *sortedDogs = [weights gtf_sortArray:dogs
 *                              usingComparator:ascending];
 * // sortedDogs is @[ @"Spot", @"Bruno", @"Tiger" ].
 * @endcode
 *
 * @param array The array to sort.
 * @param comparator A comparator acting on elements of self.
 * @return A sorted copy of |array|.
 */
- (NSArray *)gtf_sortArray:(NSArray *)array usingComparator:(NSComparator)comparator;

@end
