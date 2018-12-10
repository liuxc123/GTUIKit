//
//  NSArray+GTUIFormAdditions.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "NSArray+GTUIFormAdditions.h"
#import "NSObject+GTUIFormAdditions.h"

@implementation NSArray (GTUIFormAdditions)

- (NSInteger)formIndexForItem:(id)item {
    for (id selectedValueItem in self) {
        if ([[selectedValueItem valueData] isEqual:[item valueData]]){
            return [self indexOfObject:selectedValueItem];
        }
    }
    return NSNotFound;
}

@end
