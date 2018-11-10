//
//  GTFRuntime.m
//  Pods-GTCatalog_Tests
//
//  Created by liuxc on 2018/8/15.
//

#import "GTFRuntime.h"
#import "GTFCatalogExample.h"
#import <objc/runtime.h>

#pragma mark Metadata keys

NSString *const GTFBreadcrumbs    = @"breadcrumbs";
NSString *const GTFIsDebug        = @"debug";
NSString *const GTFDescription    = @"description";
NSString *const GTFIsPresentable  = @"presentable";
NSString *const GTFIsPrimaryDemo  = @"primaryDemo";
NSString *const GTFRelatedInfo    = @"relatedInfo";
NSString *const GTFStoryboardName = @"storyboardName";

#pragma mark Class invocations

static NSArray<NSString *> *GTFCatalogBreadcrumbsFromClass(Class aClass) {
    return [aClass performSelector:@selector(catalogBreadcrumbs)];
}

static BOOL GTFCatalogIsPrimaryDemoFromClass(Class aClass) {
    BOOL isPrimary = NO;
    if ([aClass respondsToSelector:@selector(catalogIsPrimaryDemo)]) {
        isPrimary = [aClass catalogIsPrimaryDemo];
    }
    return isPrimary;
}

static BOOL GTFCatalogIsPresentableFromClass(Class aClass) {
    BOOL isPresentable = NO;
    if ([aClass respondsToSelector:@selector(catalogIsPresentable)]) {
        isPresentable = [aClass catalogIsPresentable];
    }
    return isPresentable;
}

static BOOL GTFCatalogIsDebugLeaf(Class aClass) {
    BOOL isDebugLeaf = NO;
    if ([aClass respondsToSelector:@selector(catalogIsDebug)]) {
        isDebugLeaf = [aClass catalogIsDebug];
    }
    return isDebugLeaf;
}

static NSURL *GTFRelatedInfoFromClass(Class aClass) {
    NSURL *catalogRelatedInfo = nil;
    if ([aClass respondsToSelector:@selector(catalogRelatedInfo)]) {
        catalogRelatedInfo = [aClass catalogRelatedInfo];
    }
    return catalogRelatedInfo;
}

static NSString *GTFDescriptionFromClass(Class aClass) {
    NSString *catalogDescription = nil;
    if ([aClass respondsToSelector:@selector(catalogDescription)]) {
        catalogDescription = [aClass catalogDescription];
    }
    return catalogDescription;
}

static NSString *GTFStoryboardNameFromClass(Class aClass) {
    NSString *catalogStoryboardName = nil;
    if ([aClass respondsToSelector:@selector(catalogStoryboardName)]) {
        catalogStoryboardName = [aClass catalogStoryboardName];
    }
    return catalogStoryboardName;
}

static NSDictionary *GTFConstructMetadataFromMethods(Class aClass) {
    NSMutableDictionary *catalogMetadata = [NSMutableDictionary new];
    if ([aClass respondsToSelector:@selector(catalogBreadcrumbs)]) {
        [catalogMetadata setObject:GTFCatalogBreadcrumbsFromClass(aClass) forKey:GTFBreadcrumbs];
        [catalogMetadata setObject:[NSNumber numberWithBool:GTFCatalogIsPrimaryDemoFromClass(aClass)]
                            forKey:GTFIsPrimaryDemo];
        [catalogMetadata setObject:[NSNumber numberWithBool:GTFCatalogIsPresentableFromClass(aClass)]
                            forKey:GTFIsPresentable];
        [catalogMetadata setObject:[NSNumber numberWithBool:GTFCatalogIsDebugLeaf(aClass)]
                            forKey:GTFIsDebug];
        NSURL *relatedInfo;
        if ((relatedInfo = GTFRelatedInfoFromClass(aClass)) != nil) {
            [catalogMetadata setObject:GTFRelatedInfoFromClass(aClass) forKey:GTFRelatedInfo];
        }
        NSString *description;
        if ((description = GTFDescriptionFromClass(aClass)) != nil) {
            [catalogMetadata setObject:GTFDescriptionFromClass(aClass) forKey:GTFDescription];
        }
        NSString *storyboardName;
        if ((storyboardName = GTFStoryboardNameFromClass(aClass)) != nil) {
            [catalogMetadata setObject:GTFStoryboardNameFromClass(aClass) forKey:GTFStoryboardName];
        }
    }
    return catalogMetadata;
}

NSDictionary *GTFCatalogMetadataFromClass(Class aClass) {
    NSDictionary *catalogMetadata;
    if ([aClass respondsToSelector:@selector(catalogMetadata)]) {
        catalogMetadata = [aClass catalogMetadata];
    } else {
        catalogMetadata = GTFConstructMetadataFromMethods(aClass);
    }
    return catalogMetadata;
}

#pragma mark Runtime enumeration

NSArray<Class> *GTFGetAllCompatibleClasses(void) {
    int numberOfClasses = objc_getClassList(NULL, 0);
    Class *classList = (Class *)malloc((size_t)numberOfClasses * sizeof(Class));
    objc_getClassList(classList, numberOfClasses);

    NSMutableArray<Class> *classes = [NSMutableArray array];

    NSSet *ignoredClasses = [NSSet setWithArray:@[
                                                  @"SwiftObject", @"Object", @"FigIrisAutoTrimmerMotionSampleExport", @"NSLeafProxy"
                                                  ]];
    NSArray *ignoredPrefixes = @[ @"Swift.", @"_", @"JS", @"WK", @"PF" ];

    for (int ix = 0; ix < numberOfClasses; ++ix) {
        Class aClass = classList[ix];
        NSString *className = NSStringFromClass(aClass);
        if ([ignoredClasses containsObject:className]) {
            continue;
        }
        BOOL hasIgnoredPrefix = NO;
        for (NSString *prefix in ignoredPrefixes) {
            if ([className hasPrefix:prefix]) {
                hasIgnoredPrefix = YES;
                break;
            }
        }
        if (hasIgnoredPrefix) {
            continue;
        }
        if (![aClass isSubclassOfClass:[UIViewController class]]) {
            continue;
        }
        [classes addObject:aClass];
    }

    free(classList);

    return classes;
}

NSArray<Class> *GTFClassesRespondingToSelector(NSArray<Class> *classes, SEL selector) {
    NSMutableArray<Class> *filteredClasses = [NSMutableArray array];
    for (Class aClass in classes) {
        if ([aClass respondsToSelector:selector]) {
            [filteredClasses addObject:aClass];
        }
    }
    return filteredClasses;
}

#pragma mark UIViewController instantiation

UIViewController *GTFViewControllerFromClass(Class aClass, NSDictionary *metadata) {
    if ([metadata objectForKey:GTFStoryboardName]) {
        NSString *storyboardName = [metadata objectForKey:GTFStoryboardName];
        NSBundle *bundle = [NSBundle bundleForClass:aClass];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:bundle];
        NSCAssert(storyboard, @"expecting a storyboard to exist at %@", storyboardName);
        UIViewController *vc = [storyboard instantiateInitialViewController];
        NSCAssert(vc, @"expecting a initialViewController in the storyboard %@", storyboardName);
        return vc;
    }
    return [[aClass alloc] init];
}

#pragma mark Fix View Debugging

void GTFFixViewDebuggingIfNeeded(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method original = class_getInstanceMethod([UIView class], @selector(viewForBaselineLayout));
        class_addMethod([UIView class], @selector(viewForFirstBaselineLayout),
                        method_getImplementation(original), method_getTypeEncoding(original));
        class_addMethod([UIView class], @selector(viewForLastBaselineLayout),
                        method_getImplementation(original), method_getTypeEncoding(original));
    });
}

