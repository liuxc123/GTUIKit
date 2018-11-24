//
//  GTUIAlertActionManager.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import <Foundation/Foundation.h>
#import "GTButton.h"
#import "GTDialogs.h"

@interface GTUIAlertActionManager : NSObject
/**
 List of the actions that were added to the action manager.
 */
@property(nonatomic, nonnull, strong, readonly) NSArray<GTUIAlertAction *> *actions;

/**
 Returns the list of buttons for the provided actions. Only returns buttons which have already
 been created. Unlike buttonForAction, it does not create buttons, and as a results, may
 return a shorter list than the actions array. Order of buttons resembles order of actions,
 but is not guaranteed.

 Note: It is the caller's responsibility to make sure buttons is added to the view hierarchy.
 */
@property(nonatomic, nonnull, strong, readonly) NSArray<GTUIButton *> *buttonsInActionOrder;

/**
 Adding an action with no associated button (will be created later)
 */
- (void)addAction:(nonnull GTUIAlertAction *)action;

/**
 Returns true if the action has been previously added to the array
 */
- (BOOL)hasAction:(nonnull GTUIAlertAction *)action;

/**
 Returns the button for the action. Returns nil if the button hasn't been created yet.

 Note: It is the caller's responsibility to make sure the button is added to the view hierarchy.
 */
- (nullable GTUIButton *)buttonForAction:(nonnull GTUIAlertAction *)action;

/**
 Returns the action for the given button.
 */
- (nullable GTUIAlertAction *)actionForButton:(nonnull GTUIButton *)button;

/**
 Creates a button for the given action if the action is not yet associated with a button.
 If the action is already associated with a button, then the existing button is returned.
 The given Target and selector are assigned to the button when it's created (or ignored
 if the button is already exists).

 Note: It is the caller's responsibility to make sure the button is added to the view hierarchy.
 */
- (nullable GTUIButton *)createButtonForAction:(nonnull GTUIAlertAction *)action
                                       target:(nullable id)target
                                     selector:(SEL _Nonnull)selector;

@end
