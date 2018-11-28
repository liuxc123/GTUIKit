//
//  GTUIDialogAction.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/27.
//

#import "GTUIDialogAction.h"

@implementation GTUIDialogAction

+ (instancetype)actionWithTitle:(nonnull NSString *)title
                        handler:(GTUIActionHandler)handler {
    return [[GTUIDialogAction alloc] initWithTitle:title image:nil actionType:GTUIActionTypeDefault handler:handler];
}

+ (instancetype)actionWithTitle:(NSString *)title
                     actionType:(GTUIActionType)actionType
                        handler:(GTUIActionHandler)handler {
    return [[GTUIDialogAction alloc] initWithTitle:title image:nil actionType:actionType handler:handler];
}

+ (instancetype)actionWithTitle:(NSString *)title
                          image:(UIImage *)image
                     actionType:(GTUIActionType)actionType
                        handler:(GTUIActionHandler)handler {
    return [[GTUIDialogAction alloc] initWithTitle:title image:image actionType:actionType handler:handler];
}

- (instancetype)initWithTitle:(nonnull NSString *)title
                        image:(UIImage * _Nullable)image
                   actionType:(GTUIActionType)actionType
                      handler:(GTUIActionHandler)handler {
    self = [super init];
    if (self) {

        _title = [title copy];
        _image = [image copy];
        _type = actionType;
        _completionHandler = [handler copy];
    }
    return self;
}

- (id)copyWithZone:(__unused NSZone *)zone {
    GTUIDialogAction *action = [[self class] actionWithTitle:self.title image:self.image actionType:self.type handler:self.completionHandler];
    action.accessibilityIdentifier = self.accessibilityIdentifier;

    return action;
}

- (void)update{
    if (self.updateBlock) self.updateBlock(self);
}

@end
