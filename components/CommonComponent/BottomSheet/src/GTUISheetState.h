//
//  GTUISheetState.h
//  Pods
//
//  Created by liuxc on 2018/11/23.
//

/**
 The GTUISheetState enum provides the different possible states the bottom sheet can be in.
 There are currently 3 different states for the bottom sheet:

 - GTUISheetStateClosed: This state is reached when the bottom sheet is dragged down and is
 dismissed.
 - GTUISheetStatePreferred: This state is reached when the bottom sheet is half collapsed - when
 it visible but not in full screen. This state is also the default state for the sheet.
 - GTUISheetStateExtended: This state is reached when the sheet is expanded and is in full screen.
 */
typedef NS_ENUM(NSUInteger, GTUISheetState) {
    GTUISheetStateClosed,
    GTUISheetStatePreferred,
    GTUISheetStateExtended      
};

