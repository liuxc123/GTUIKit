//
//  GTUIAlertActionManager.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import "GTUIAlertActionManager.h"

@interface GTUIAlertActionManager ()

@property(nonatomic, nonnull, strong) NSMapTable<GTUIAlertAction *, GTUIButton *> *actionButtons;

@end

@implementation GTUIAlertActionManager {
    NSMutableArray<GTUIAlertAction *> *_actions;
}

@dynamic buttonsInActionOrder;

- (instancetype)init {
    self = [super init];
    if (self) {
        _actions = [[NSMutableArray alloc] init];
        _actionButtons = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory
                                               valueOptions:NSMapTableStrongMemory];
    }
    return self;
}

- (NSArray<GTUIButton *> *)buttonsInActionOrder {
    NSMutableArray<GTUIButton *> *buttons =
    [[NSMutableArray alloc] initWithCapacity:self.actions.count];
    if ([self.actionButtons count] > 0) {
        for (GTUIAlertAction *action in self.actions) {
            GTUIButton *button = [self.actionButtons objectForKey:action];
            if (button) {
                [buttons addObject:button];
            }
        }
    }
    return buttons;
}

- (void)addAction:(nonnull GTUIAlertAction *)action {
    [_actions addObject:action];
}

- (BOOL)hasAction:(nonnull GTUIAlertAction *)action {
    return [_actions indexOfObject:action] != NSNotFound;
}

- (nullable GTUIButton *)buttonForAction:(nonnull GTUIAlertAction *)action {
    return [self.actionButtons objectForKey:action];
}

- (nullable GTUIAlertAction *)actionForButton:(nonnull GTUIButton *)button {
    for (GTUIAlertAction *action in self.actionButtons) {
        GTUIButton *currButton = [self.actionButtons objectForKey:action];
        if (currButton == button) {
            return action;
        }
    }
    return nil;
}

// creating a new buttons and associating it with the given action. the button is not added
// to view hierarchy.
- (nullable GTUIButton *)createButtonForAction:(nonnull GTUIAlertAction *)action
                                       target:(nullable id)target
                                     selector:(SEL _Nonnull)selector {
    GTUIButton *button = [self.actionButtons objectForKey:action];
    if (button == nil) {
        button = [self makeButtonForAction:action target:target selector:selector];
        [self.actionButtons setObject:button forKey:action];
    }
    return button;
}

- (GTUIButton *)makeButtonForAction:(GTUIAlertAction *)action
                            target:(id)target
                          selector:(SEL)selector {
    GTUIButton *button = [[GTUIButton alloc] initWithFrame:CGRectZero];
    [button setTitle:action.title forState:UIControlStateNormal];
    button.accessibilityIdentifier = action.accessibilityIdentifier;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
