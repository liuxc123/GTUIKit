//
//  GTMRepetition.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMRepetition.h"

@implementation GTMRepetition

@synthesize autoreverses = _autoreverses;

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithNumberOfRepetitions:(double)numberOfRepetitions {
    return [self initWithNumberOfRepetitions:numberOfRepetitions autoreverses:NO];
}

- (instancetype)initWithNumberOfRepetitions:(double)numberOfRepetitions
                               autoreverses:(BOOL)autoreverses {
    self = [super init];
    if (self) {
        _numberOfRepetitions = numberOfRepetitions;
        _autoreverses = autoreverses;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(__unused NSZone *)zone {
    return [[[self class] alloc] initWithNumberOfRepetitions:self.numberOfRepetitions
                                                autoreverses:self.autoreverses];
}

@end


