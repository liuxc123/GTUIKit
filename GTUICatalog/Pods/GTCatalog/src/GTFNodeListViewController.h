//
//  GTFNodeListViewController.h
//  Pods-GTCatalog_Tests
//
//  Created by liuxc on 2018/8/15.
//

#import <UIKit/UIKit.h>

/** This key represents a strings array of the breadcrumbs showing the hierarchy of the example */
FOUNDATION_EXTERN NSString *_Nonnull const GTFBreadcrumbs;
/** This key represents a boolean value if the example is for debugging */
FOUNDATION_EXTERN NSString *_Nonnull const GTFIsDebug;
/** This key represents a string for the description for the example */
FOUNDATION_EXTERN NSString *_Nonnull const GTFDescription;
/** This key represents a boolean value if to present the example in the Catalog app or not */
FOUNDATION_EXTERN NSString *_Nonnull const GTFIsPresentable;
/** This key represents a boolean value if the example is the primary demo */
FOUNDATION_EXTERN NSString *_Nonnull const GTFIsPrimaryDemo;
/** This key represents an NSURL value providing related info for the example */
FOUNDATION_EXTERN NSString *_Nonnull const GTFRelatedInfo;
/** This key represents a string value of the storyboard name for the example */
FOUNDATION_EXTERN NSString *_Nonnull const GTFStoryboardName;

@class GTFNode;

/**
 An instance of GTFNodeListViewController is able to represent a non-example GTFNode instance as a
 UITableView.
 */
@interface GTFNodeListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/** Initializes a GTFNodeViewController instance with a non-example node. */
- (nonnull instancetype)initWithNode:(nonnull GTFNode *)node;

- (nonnull instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;

@property(nonatomic, strong, nonnull) UITableView *tableView;

/** The node that this view controller must represent. */
@property(nonatomic, strong, nonnull, readonly) GTFNode *node;

@end

/**
 Returns the root of a GTFNode tree representing the complete catalog navigation hierarchy.

 Only classes that implement +catalogBreadcrumbs and return at least one breadcrumb will be part of
 the tree.
 */
FOUNDATION_EXTERN GTFNode *_Nonnull GTFCreateNavigationTree(void);

/**
 Returns the root of a GTFNode tree representing only the presentable catalog navigation hierarchy.

 Only classes that implement +catalogIsPresentable with a return value of YES,
 and +catalogBreadcrumbs and return at least one breadcrumb will be part of the tree.
 */
FOUNDATION_EXTERN GTFNode *_Nonnull GTFCreatePresentableNavigationTree(void);

/**
 A node describes a single navigable page in the Catalog by Convention.

 A node either has children or it is an example.

 - If a node has children, then the node should be represented by a list of some sort.
 - If a node is an example, then the example controller can be instantiated with
 createExampleViewController.
 */
@interface GTFNode : NSObject

/** Nodes cannot be created by clients. */
- (nonnull instancetype)init NS_UNAVAILABLE;

/** The title for this node. */
@property(nonatomic, copy, nonnull, readonly) NSString *title;

/** The children of this node. */
@property(nonatomic, strong, nonnull) NSArray<GTFNode *> *children;

/**
 The example you wish to debug as the initial view controller.
 If there are multiple examples with catalogIsDebug returning YES
 the debugLeaf will hold the example that has been iterated on last
 in the hierarchy tree.
 */
@property(nonatomic, strong, nullable) GTFNode *debugLeaf;

/**
 This NSDictionary holds all the metadata related to this GTFNode.
 If it is an example noe, a primary demo, related info,
 if presentable in Catalog, etc.
 */
@property(nonatomic, strong, nonnull) NSDictionary *metadata;

/** Returns YES if this is an example node. */
- (BOOL)isExample;

/**
 Returns YES if this the primary demo for this component.

 Can only return YES if isExample also returns YES.
 */
- (BOOL)isPrimaryDemo;

/** Returns YES if this is a presentable example.  */
- (BOOL)isPresentable;

/** Returns String representation of exampleViewController class name if it exists */
- (nullable NSString *)exampleViewControllerName;

/**
 Returns an instance of a UIViewController for presentation purposes.

 Check that isExample returns YES before invoking.
 */
- (nonnull UIViewController *)createExampleViewController;

/**
 Returns a description of the example.

 Check that isExample returns YES before invoking.
 */
- (nullable NSString *)exampleDescription;

/** Returns a link to related information for the example. */
- (nullable NSURL *)exampleRelatedInfo;

@end

