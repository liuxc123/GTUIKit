//
//  GTUIProgressViewMotionSpec.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <Foundation/Foundation.h>
#import <GTMotionInterchange/GTMotionInterchange.h>

@interface GTUIProgressViewMotionSpec : NSObject

@property(nonatomic, class, readonly) GTMMotionTiming willChangeProgress;
@property(nonatomic, class, readonly) GTMMotionTiming willChangeHidden;

// This object is not meant to be instantiated.
- (instancetype)init NS_UNAVAILABLE;

@end
