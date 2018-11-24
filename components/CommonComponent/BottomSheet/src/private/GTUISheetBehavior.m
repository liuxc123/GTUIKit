//
//  GTUISheetBehavior.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/23.
//

#import "GTUISheetBehavior.h"

@interface GTUISheetBehavior ()
@property(nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property(nonatomic) UIDynamicItemBehavior *itemBehavior;
@property(nonatomic) id <UIDynamicItem> item;
@end

@implementation GTUISheetBehavior

- (instancetype)initWithItem:(id <UIDynamicItem>)item {
    self = [super init];
    if (self) {
        _item = item;
        _attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.item
                                                        attachedToAnchor:CGPointZero];
        _attachmentBehavior.frequency = 3.5f;
        _attachmentBehavior.damping = 0.4f;
        _attachmentBehavior.length = 0.f;
        [self addChildBehavior:_attachmentBehavior];

        _itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.item]];
        _itemBehavior.density = 100.f;
        _itemBehavior.resistance = 10.f;
        [self addChildBehavior:_itemBehavior];
    }
    return self;
}

- (void)setTargetPoint:(CGPoint)targetPoint {
    _targetPoint = targetPoint;
    self.attachmentBehavior.anchorPoint = targetPoint;
}

- (void)setVelocity:(CGPoint)velocity {
    _velocity = velocity;
    CGPoint currentVelocity = [self.itemBehavior linearVelocityForItem:self.item];
    CGPoint velocityDelta = CGPointMake(velocity.x - currentVelocity.x,
                                        velocity.y - currentVelocity.y);
    [self.itemBehavior addLinearVelocity:velocityDelta forItem:self.item];
}

@end

