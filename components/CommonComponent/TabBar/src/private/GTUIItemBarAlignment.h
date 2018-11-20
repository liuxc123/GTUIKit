//
//  GTUIItemBarAlignment.h
//  Pods
//
//  Created by liuxc on 2018/11/20.
//

#import <Foundation/Foundation.h>

/** Alignment styles for items in a tab bar. */
typedef NS_ENUM(NSInteger, GTUIItemBarAlignment) {
    /** Items are aligned on the leading edge and sized to fit their content. */
    GTUIItemBarAlignmentLeading,

    /** Items are justified to equal size across the width of the screen. */
    GTUIItemBarAlignmentJustified,

    /**
     * Items are sized to fit their content and center-aligned as a group. If they do not fit in view,
     * they will be leading-aligned instead.
     */
    GTUIItemBarAlignmentCenter,

    /** Items are center-aligned on the selected item. */
    GTUIItemBarAlignmentCenterSelected,
};
