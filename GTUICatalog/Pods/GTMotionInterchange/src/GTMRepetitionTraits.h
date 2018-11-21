//
//  GTMRepetitionTraits.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>

/**
 A generalized representation of a repetition traits.
 */
@protocol GTMRepetitionTraits <NSObject, NSCopying>

/**
 Whether the animation should animate backwards after animating forwards.
 */
@property(nonatomic, assign) BOOL autoreverses;

@end
