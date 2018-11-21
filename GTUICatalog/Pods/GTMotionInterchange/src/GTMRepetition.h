//
//  GTMRepetition.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>

#import "GTMRepetitionTraits.h"
#import "GTMSubclassingRestricted.h"

/**
 Represents repetition that repeats a specific number of times.
 */
GTM_SUBCLASSING_RESTRICTED
@interface GTMRepetition: NSObject <NSCopying, GTMRepetitionTraits>

/**
 Initializes the instance with the given number of repetitions.

 Autoreversing is disabled.

 @param numberOfRepetitions May be fractional. Initializing with greatestFiniteMagnitude will cause
 the animation to repeat forever.
 */
- (nonnull instancetype)initWithNumberOfRepetitions:(double)numberOfRepetitions;

/**
 Initializes the instance with the given number of repetitions and autoreversal behavior.

 @param numberOfRepetitions May be fractional. Initializing with greatestFiniteMagnitude will cause
 the animation to repeat forever.
 @param autoreverses Whether the animation should animate backwards after animating forwards.
 */
- (nonnull instancetype)initWithNumberOfRepetitions:(double)numberOfRepetitions
                                       autoreverses:(BOOL)autoreverses
NS_DESIGNATED_INITIALIZER;

#pragma mark - Traits

/**
 The number of repetitions that will occur before this animation stops repeating.
 */
@property(nonatomic, assign) double numberOfRepetitions;

/**
 Unavailable.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

@end


