//
//  GTUIDialogShadowedView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/26.
//

#import "GTUIDialogShadowedView.h"

#import "GTShadowLayer.h"

@implementation GTUIDialogShadowedView

+ (Class)layerClass {
    return [GTUIShadowLayer class];
}

- (GTUIShadowLayer *)shadowLayer {
    return (GTUIShadowLayer *)self.layer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[self shadowLayer] setElevation:GTUIShadowElevationDialog];
    }
    return self;
}

- (GTUIShadowElevation)elevation {
    return [self shadowLayer].elevation;
}

- (void)setElevation:(GTUIShadowElevation)elevation {
    [[self shadowLayer] setElevation:elevation];
}

@end
