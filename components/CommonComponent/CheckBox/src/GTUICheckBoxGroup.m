//
//  GTUICheckBoxGroup.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/6.
//

#import "GTUICheckBoxGroup.h"
#import "GTUICheckBox.h"

@interface GTUICheckBoxGroup ()

@property (nonatomic, strong, nonnull) NSHashTable *checkBoxes;

@end

/** Defines private methods that we can call on the check box.
 */
@interface GTUICheckBox ()

@property (strong, nonatomic, nullable) GTUICheckBoxGroup *group;

- (void)_setOn:(BOOL)on animated:(BOOL)animated notifyGroup:(BOOL)notifyGroup;

@end

@implementation GTUICheckBoxGroup

- (instancetype)init {
    self = [super init];
    if (self) {
        _mustHaveSelection = NO;
        _checkBoxes = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

+ (nonnull instancetype)groupWithCheckBoxes:(nullable NSArray<GTUICheckBox *> *)checkBoxes {
    GTUICheckBoxGroup *group = [[GTUICheckBoxGroup alloc] init];
    for (GTUICheckBox *checkbox in checkBoxes) {
        [group addCheckBoxToGroup:checkbox];
    }

    return group;
}

- (void)addCheckBoxToGroup:(nonnull GTUICheckBox *)checkBox {
    if (checkBox.group) {
        [checkBox.group removeCheckBoxFromGroup:checkBox];
    }

    [checkBox _setOn:NO animated:NO notifyGroup:NO];
    checkBox.group = self;

    [self.checkBoxes addObject:checkBox];
}

- (void)removeCheckBoxFromGroup:(nonnull GTUICheckBox *)checkBox {
    if (![self.checkBoxes containsObject:checkBox]) {
        // Not in this group
        return;
    }

    checkBox.group = nil;
    [self.checkBoxes removeObject:checkBox];
}

#pragma mark Getters

- (GTUICheckBox *)selectedCheckBox {
    GTUICheckBox *selected = nil;
    for (GTUICheckBox *checkBox in self.checkBoxes) {
        if(checkBox.on){
            selected = checkBox;
            break;
        }
    }

    return selected;
}

#pragma mark Setters

- (void)setSelectedCheckBox:(GTUICheckBox *)selectedCheckBox {
    if (selectedCheckBox) {
        for (GTUICheckBox *checkBox in self.checkBoxes) {
            BOOL shouldBeOn = (checkBox == selectedCheckBox);
            if(checkBox.on != shouldBeOn){
                [checkBox _setOn:shouldBeOn animated:YES notifyGroup:NO];
            }
        }
    } else {
        // Selection is nil
        if(self.mustHaveSelection && [self.checkBoxes count] > 0){
            // We must have a selected checkbox, so re-call this method with the first checkbox
            self.selectedCheckBox = [self.checkBoxes anyObject];
        } else {
            for (GTUICheckBox *checkBox in self.checkBoxes) {
                BOOL shouldBeOn = NO;
                if(checkBox.on != shouldBeOn){
                    [checkBox _setOn:shouldBeOn animated:YES notifyGroup:NO];
                }
            }
        }
    }
}

- (void)setMustHaveSelection:(BOOL)mustHaveSelection {
    _mustHaveSelection = mustHaveSelection;

    // If it must have a selection and we currently don't, select the first box
    if (mustHaveSelection && !self.selectedCheckBox) {
        self.selectedCheckBox = [self.checkBoxes anyObject];
    }
}

#pragma mark Private methods called by GTUICheckBox

- (void)_checkBoxSelectionChanged:(GTUICheckBox *)checkBox {
    if ([checkBox on]) {
        // Change selected checkbox to this one
        self.selectedCheckBox = checkBox;
    } else if(checkBox == self.selectedCheckBox) {
        // Selected checkbox was this one, clear it
        self.selectedCheckBox = nil;
    }
}

@end
