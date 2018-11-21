//
//  GTMSubclassingRestricted.h
//  FBSnapshotTestCase
//
//  Created by liuxc on 2018/8/14.
//

#import <Foundation/Foundation.h>

#ifndef GTM_SUBCLASSING_RESTRICTED
#if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#define GTM_SUBCLASSING_RESTRICTED __attribute__((objc_subclassing_restricted))
#else
#define GTM_SUBCLASSING_RESTRICTED
#endif
#endif  // #ifndef GTM_SUBCLASSING_RESTRICTED
