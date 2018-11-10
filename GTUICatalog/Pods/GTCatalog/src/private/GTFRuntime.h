//
//  GTFRuntime.h
//  Pods-GTCatalog_Tests
//
//  Created by liuxc on 2018/8/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark Class invocations

/** Invokes +catalogMetadata on the class and returns the NSDictionary value */
FOUNDATION_EXTERN NSDictionary *GTFCatalogMetadataFromClass(Class aClass);

#pragma mark Runtime enumeration

/** Returns all Objective-C and Swift classes available to the runtime. */
FOUNDATION_EXTERN NSArray<Class> *GTFGetAllCompatibleClasses(void);

/** Returns an array of classes that respond to a given static method selector. */
FOUNDATION_EXTERN NSArray<Class> *GTFClassesRespondingToSelector(NSArray<Class> *classes,
                                                                 SEL selector);

/**
 Internal helper method that allows invoking aClass with selector and puts
 the return value in retValue.
 */
void GTFCatalogInvokeFromClassAndSelector(Class aClass, SEL selector, void *retValue);

#pragma mark UIViewController instantiation

/**
 Creates a view controller instance from the provided class.

 If the provided class implements +(NSString *)catalogStoryboardName, a UIStoryboard instance will
 be created with the returned name. The returned view controller will be instantiated by invoking
 -instantiateInitialViewController on the UIStoryboard instance.
 */
FOUNDATION_EXTERN UIViewController *GTFViewControllerFromClass(Class aClass, NSDictionary *metadata);

#pragma mark Fix View Debugging

/**
 Fixes View Debugging in Xcode when running on iOS 8 and below. See
 http://stackoverflow.com/questions/36313850/debug-view-hierarchy-in-xcode-7-3-fails
 */
FOUNDATION_EXTERN void GTFFixViewDebuggingIfNeeded(void);
