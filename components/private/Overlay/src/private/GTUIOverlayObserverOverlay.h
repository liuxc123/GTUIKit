//
//  GTUIOverlayObserverOverlay.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import <UIKit/UIKit.h>

#import "GTUIOverlayTransitioning.h"

/**
 Object representing a single overlay being displayed on screen.
 */
@interface GTUIOverlayObserverOverlay : NSObject <GTUIOverlay>

/**
 The unique identifier for the given overlay.
 */
@property(nonatomic, copy) NSString *identifier;

/**
 The frame of the overlay, in screen coordinates.
 */
@property(nonatomic, assign) CGRect frame;

@end
