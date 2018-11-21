//
//  GTMRepetitionOverTime.m
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import "GTMRepetitionOverTime.h"

@implementation GTMRepetitionOverTime

@synthesize autoreverses = _autoreverses;

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithDuration:(double)duration {
    return [self initWithDuration:duration autoreverses:NO];
}

- (instancetype)initWithDuration:(double)duration autoreverses:(BOOL)autoreverses {
    self = [super init];
    if (self) {
        _duration = duration;
        _autoreverses = autoreverses;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(__unused NSZone *)zone {
    return [[[self class] alloc] initWithDuration:self.duration autoreverses:self.autoreverses];
}

@end


