//
//  GTUIShapeScheme.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTUIShapeCategory.h"

/**
 A simple shape scheme that provides semantic meaning.
 Each GTUIShapeCategory is mapped to a component.
 The mapping is based on the component's surface size.
 There are no optional properties and all shapes must be provided,
 supporting more reliable shape theming.
 */
@protocol GTUIShapeScheming

/**
 The shape defining small sized components.
 */
@property(nonnull, readonly, nonatomic) GTUIShapeCategory *smallComponentShape;

/**
 The shape defining medium sized components.
 */
@property(nonnull, readonly, nonatomic) GTUIShapeCategory *mediumComponentShape;

/**
 The shape defining large sized components.
 */
@property(nonnull, readonly, nonatomic) GTUIShapeCategory *largeComponentShape;

@end

/**
 An enum of default shape schemes that are supported.
 */
typedef NS_ENUM(NSInteger, GTUIShapeSchemeDefaults) {
    /**
     The Material defaults, circa September 2018.
     */
    GTUIShapeSchemeDefaults201809
};

/**
 A simple implementation of @c GTUIShapeScheming that provides Material default shape values from
 which basic customizations can be made.
 */
@interface GTUIShapeScheme : NSObject <GTUIShapeScheming>

// Redeclare protocol properties as readwrite
@property(nonnull, readwrite, nonatomic) GTUIShapeCategory *smallComponentShape;
@property(nonnull, readwrite, nonatomic) GTUIShapeCategory *mediumComponentShape;
@property(nonnull, readwrite, nonatomic) GTUIShapeCategory *largeComponentShape;

/**
 Initializes the shape scheme with the latest material defaults.
 */
- (nonnull instancetype)init;

/**
 Initializes the shape scheme with the shapes associated with the given defaults.
 */
- (nonnull instancetype)initWithDefaults:(GTUIShapeSchemeDefaults)defaults;

@end
