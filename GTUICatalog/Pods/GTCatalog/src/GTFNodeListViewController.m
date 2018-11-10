//
//  GTFNodeListViewController.m
//  Pods-GTCatalog_Tests
//
//  Created by liuxc on 2018/8/15.
//

#import "GTFNodeListViewController.h"

#import "GTFCatalogExample.h"
#import "private/GTFRuntime.h"

@interface GTFNode()
@property(nonatomic, strong, nullable) NSMutableDictionary *map;
@property(nonatomic, strong, nullable) Class exampleClass;
@end

@implementation GTFNode {
    NSMutableArray *_children;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = [title copy];
        self.map = [NSMutableDictionary dictionary];
        _children = [NSMutableArray array];
        GTFFixViewDebuggingIfNeeded();
    }
    return self;
}

- (NSComparisonResult)compare:(GTFNode *)otherObject {
    return [self.title compare:otherObject.title];
}

- (void)addChild:(GTFNode *)child {
    self.map[child.title] = child;
    [_children addObject:child];
}

- (void)finalizeNode {
    _children = [[_children sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
}

#pragma mark Public

- (BOOL)isExample {
    return self.exampleClass != nil;
}

- (NSString *)exampleViewControllerName {
    NSAssert(self.exampleClass != nil, @"This node has no associated example.");
    return NSStringFromClass(_exampleClass);
}

- (UIViewController *)createExampleViewController {
    NSAssert(self.exampleClass != nil, @"This node has no associated example.");
    return GTFViewControllerFromClass(self.exampleClass, self.metadata);
}

- (NSString *)exampleDescription {
    NSString *description = [self.metadata objectForKey:GTFDescription];
    if (description != nil && [description isKindOfClass:[NSString class]]) {
        return description;
    }
    return nil;
}

- (NSURL *)exampleRelatedInfo {
    NSURL *relatedInfo = [self.metadata objectForKey:GTFRelatedInfo];
    if (relatedInfo != nil && [relatedInfo isKindOfClass:[NSURL class]]) {
        return relatedInfo;
    }
    return nil;
}

- (BOOL)isPrimaryDemo {
    id isPrimaryDemo;
    if ((isPrimaryDemo = [self.metadata objectForKey:GTFIsPrimaryDemo]) != nil) {
        return [isPrimaryDemo boolValue];
    }
    return NO;
}

- (BOOL)isPresentable {
    id isPresentable;
    if ((isPresentable = [self.metadata objectForKey:GTFIsPresentable]) != nil) {
        return [isPresentable boolValue];
    }
    return NO;
}

@end

@implementation GTFNodeListViewController

- (instancetype)initWithNode:(GTFNode *)node {
    NSAssert(!self.node.isExample, @"%@ cannot represent example nodes.",
             NSStringFromClass([self class]));

    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _node = node;

        self.title = self.node.title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView =
    [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask =
    (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSIndexPath *selectedRow = self.tableView.indexPathForSelectedRow;
    if (selectedRow) {
        [[self transitionCoordinator] animateAlongsideTransition:^(id context) {
            [self.tableView deselectRowAtIndexPath:selectedRow animated:YES];
        }
                                                      completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                                          if ([context isCancelled]) {
                                                              [self.tableView selectRowAtIndexPath:selectedRow
                                                                                          animated:NO
                                                                                    scrollPosition:UITableViewScrollPositionNone];
                                                          }
                                                      }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tableView flashScrollIndicators];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.node.children count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.node.children[(NSUInteger)indexPath.row] title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GTFNode *node = self.node.children[(NSUInteger)indexPath.row];
    UIViewController *viewController = nil;
    if ([node isExample]) {
        viewController = [node createExampleViewController];
    } else {
        viewController = [[[self class] alloc] initWithNode:node];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end

static void GTFAddNodeFromBreadCrumbs(GTFNode *tree,
                                      NSArray<NSString *> *breadCrumbs,
                                      Class aClass,
                                      NSDictionary *metadata) {
    // Walk down the navigation tree one breadcrumb at a time, creating nodes along the way.

    GTFNode *node = tree;
    for (NSUInteger ix = 0; ix < [breadCrumbs count]; ++ix) {
        NSString *title = breadCrumbs[ix];
        BOOL isLastCrumb = ix == [breadCrumbs count] - 1;

        // Don't walk the last crumb
        if (node.map[title] && !isLastCrumb) {
            node = node.map[title];
            continue;
        }

        GTFNode *child = [[GTFNode alloc] initWithTitle:title];
        [node addChild:child];
        child.metadata = metadata;
        if ([[child.metadata objectForKey:GTFIsPrimaryDemo] boolValue] == YES) {
            node.metadata = child.metadata;
        }
        if ([[child.metadata objectForKey:GTFIsDebug] boolValue] == YES) {
            tree.debugLeaf = child;
        }
        node = child;
    }

    node.exampleClass = aClass;
}

static GTFNode *GTFCreateTreeWithOnlyPresentable(BOOL onlyPresentable) {
    NSArray *allClasses = GTFGetAllCompatibleClasses();
    NSArray *filteredClasses = [allClasses filteredArrayUsingPredicate:
                                [NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        NSDictionary *metadata = GTFCatalogMetadataFromClass(object);
        id breadcrumbs = [metadata objectForKey:GTFBreadcrumbs];
        BOOL validObject =  breadcrumbs != nil && [breadcrumbs isKindOfClass:[NSArray class]];
        if (onlyPresentable) {
            validObject &= ([[metadata objectForKey:GTFIsPresentable] boolValue] == YES);
        }
        return validObject;
    }]];

    GTFNode *tree = [[GTFNode alloc] initWithTitle:@"Root"];
    for (Class aClass in filteredClasses) {
        // Each example view controller defines its own breadcrumbs (metadata[GTFBreadcrumbs]).
        NSDictionary *metadata = GTFCatalogMetadataFromClass(aClass);
        NSArray *breadCrumbs = [metadata objectForKey:GTFBreadcrumbs];
        if ([[breadCrumbs firstObject] isKindOfClass:[NSString class]]) {
            GTFAddNodeFromBreadCrumbs(tree, breadCrumbs, aClass, metadata);
        } else if ([[breadCrumbs firstObject] isKindOfClass:[NSArray class]]) {
            for (NSArray<NSString *> *parallelBreadCrumb in breadCrumbs) {
                GTFAddNodeFromBreadCrumbs(tree, parallelBreadCrumb, aClass, metadata);
            }
        }
    }

    // Perform final post-processing on the nodes.
    NSMutableArray *queue = [NSMutableArray arrayWithObject:tree];
    while ([queue count] > 0) {
        GTFNode *node = [queue firstObject];
        [queue removeObjectAtIndex:0];
        [queue addObjectsFromArray:node.children];

        [node finalizeNode];
    }

    return tree;
}

GTFNode *GTFCreateNavigationTree(void) {
    return GTFCreateTreeWithOnlyPresentable(NO);
}

GTFNode *GTFCreatePresentableNavigationTree(void) {
    return GTFCreateTreeWithOnlyPresentable(YES);
}

