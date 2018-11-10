//
//  GTFCatalogExample.h
//  Pods-GTCatalog_Tests
//
//  Created by liuxc on 2018/8/15.
//

#import <Foundation/Foundation.h>

/**
 The GTFCatalogExample protocol defines methods that examples are expected to implement in order to
 customize their location and behavior in the Catalog by Convention.

 Examples should not formally conform to this protocol. Examples should simply implement these
 methods by convention.
 */
@protocol GTFCatalogExample <NSObject>

/**
 Returns a dictionary with metaata information for the example.
 */
+ (nonnull NSDictionary<NSString *, NSObject *> *)catalogMetadata;

@optional

/** Return a list of breadcrumbs defining the navigation path taken to reach this example. */
+ (nonnull NSArray<NSString *> *)catalogBreadcrumbs
__attribute__((deprecated("use catalogMetadata[GTFBreadcrumbs] instead.")));

/**
 Return a BOOL stating whether this example should be treated as the primary demo of the component.
 */
+ (BOOL)catalogIsPrimaryDemo
__attribute__((deprecated("use catalogMetadata[GTFIsPrimaryDemo] instead.")));;

/**
 Return a BOOL stating whether this example is presentable and should be part of the catalog app.
 */
+ (BOOL)catalogIsPresentable
__attribute__((deprecated("use catalogMetadata[GTFIsPresentable] instead.")));

/**
 Return a BOOL stating whether this example is in debug mode and should appear as the initial view controller.
 */
+ (BOOL)catalogIsDebug
__attribute__((deprecated("use catalogMetadata[GTFIsDebug] instead.")));

/**
 Return the name of a UIStoryboard from which the example's view controller should be instantiated.
 */
- (nonnull NSString *)catalogStoryboardName
__attribute__((deprecated("use catalogMetadata[GTFStoryboardName] instead.")));

/** Return a description of the example. */
- (nonnull NSString *)catalogDescription
__attribute__((deprecated("use catalogMetadata[GTFDescription] instead.")));

/** Return a link to related information or resources. */
- (nonnull NSURL *)catalogRelatedInfo
__attribute__((deprecated("use catalogMetadata[GTFRelatedInfo] instead.")));

@end
