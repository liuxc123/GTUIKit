//
//  GTMRepetitionOverTime.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>

#import "GTMRepetitionTraits.h"
#import "GTMSubclassingRestricted.h"

/**
 Represents repetition that repeats until a specific duration has passed.
 */
GTM_SUBCLASSING_RESTRICTED
@interface GTMRepetitionOverTime: NSObject <NSCopying, GTMRepetitionTraits>

/**
 Initializes the instance with the given duration.

 @param duration The amount of time, in seconds, over which the animation will repeat.
 */
- (nonnull instancetype)initWithDuration:(double)duration;

/**
 Initializes the instance with the given duration and autoreversal behavior.

 @param duration The amount of time, in seconds, over which the animation will repeat.
 @param autoreverses Whether the animation should animate backwards after animating forwards.
 */
- (nonnull instancetype)initWithDuration:(double)duration autoreverses:(BOOL)autoreverses
NS_DESIGNATED_INITIALIZER;

#pragma mark - Traits

/**
 The amount of time, in seconds, that will pass before this animation stops repeating.
 */
@property(nonatomic, assign) double duration;

/**
 Unavailable.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

@end


