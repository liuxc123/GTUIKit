//
//  GTUIOverlayUtilities.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import <UIKit/UIKit.h>

/**
 Utility function which converts a rectangle in overlay coordinates into the local coordinate
 space of the given @c target
 */
OBJC_EXPORT CGRect GTUIOverlayConvertRectToView(CGRect overlayFrame, UIView *targetView);
