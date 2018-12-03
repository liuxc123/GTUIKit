//
//  GTUIGridLayout.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUIGridLayout.h"
#import "GTUILayout+Private.h"
#import "GTUIGridNode.h"

NSString * const kGTUIGridTag = @"tag";
NSString * const kGTUIGridAction = @"action";
NSString * const kGTUIGridActionData = @"action-data";
NSString * const kGTUIGridRows = @"rows";
NSString * const kGTUIGridCols = @"cols";
NSString * const kGTUIGridSize = @"size";
NSString * const kGTUIGridPadding = @"padding";
NSString * const kGTUIGridSpace = @"space";
NSString * const kGTUIGridGravity = @"gravity";
NSString * const kGTUIGridPlaceholder = @"placeholder";
NSString * const kGTUIGridAnchor = @"anchor";
NSString * const kGTUIGridOverlap = @"overlap";
NSString * const kGTUIGridTopBorderline = @"top-borderline";
NSString * const kGTUIGridBottomBorderline = @"bottom-borderline";
NSString * const kGTUIGridLeftBorderline = @"left-borderline";
NSString * const kGTUIGridRightBorderline = @"right-borderline";

NSString * const kGTUIGridBorderlineColor = @"color";
NSString * const kGTUIGridBorderlineThick = @"thick";
NSString * const kGTUIGridBorderlineHeadIndent = @"head";
NSString * const kGTUIGridBorderlineTailIndent = @"tail";
NSString * const kGTUIGridBorderlineOffset = @"offset";
NSString * const kGTUIGridBorderlineDash = @"dash";


NSString * const vGTUIGridSizeWrap = @"wrap";
NSString * const vGTUIGridSizeFill = @"fill";


NSString * const vGTUIGridGravityTop = @"top";
NSString * const vGTUIGridGravityBottom = @"bottom";
NSString * const vGTUIGridGravityLeft = @"left";
NSString * const vGTUIGridGravityRight = @"right";
NSString * const vGTUIGridGravityLeading = @"leading";
NSString * const vGTUIGridGravityTrailing = @"trailing";
NSString * const vGTUIGridGravityCenterX = @"centerX";
NSString * const vGTUIGridGravityCenterY = @"centerY";
NSString * const vGTUIGridGravityWidthFill = @"width";
NSString * const vGTUIGridGravityHeightFill = @"height";


//视图组和动作数据
@interface GTUIViewGroupAndActionData : NSObject

@property(nonatomic, strong) NSMutableArray *viewGroup;
@property(nonatomic, strong) id actionData;

+(instancetype)viewGroup:(NSArray*)viewGroup actionData:(id)actionData;

@end

@implementation GTUIViewGroupAndActionData

-(instancetype)initWithViewGroup:(NSArray*)viewGroup actionData:(id)actionData
{
    self = [self init];
    if (self != nil)
    {
        _viewGroup = [NSMutableArray arrayWithArray:viewGroup];
        _actionData = actionData;
    }
    
    return self;
}

+(instancetype)viewGroup:(NSArray*)viewGroup actionData:(id)actionData
{
    return [[[self class] alloc] initWithViewGroup:viewGroup actionData:actionData];
}


@end





@interface GTUIGridLayout()<GTUIGridNode>

@property(nonatomic, weak) GTUIGridLayoutViewSizeClass *lastSizeClass;

@property(nonatomic, strong) NSMutableDictionary *tagsDict;
@property(nonatomic, assign) BOOL tagsDictLock;

@end


@implementation GTUIGridLayout

-(NSMutableDictionary*)tagsDict
{
    if (_tagsDict == nil)
    {
        _tagsDict = [NSMutableDictionary new];
    }
    
    return _tagsDict;
}

#pragma mark -- Public Methods

+(id<GTUIGrid>)createTemplateGrid:(NSInteger)gridTag
{
    id<GTUIGrid> grid  =  [[GTUIGridNode alloc] initWithMeasure:0 superGrid:nil];
    grid.tag = gridTag;
    
    return grid;
}


//删除所有子栅格
-(void)removeGrids
{
    [self removeGridsIn:GTUISizeClasshAny | GTUISizeClasswAny];
}

-(void)removeGridsIn:(GTUISizeClass)sizeClass
{
    id<GTUIGridNode> lsc = (id<GTUIGridNode>)[self fetchLayoutSizeClass:sizeClass];
    [lsc.subGrids removeAllObjects];
    lsc.subGridsType = GTUISubGridsTypeUnknown;
    
    [self setNeedsLayout];
}

-(id<GTUIGrid>) gridContainsSubview:(UIView*)subview
{
    return [self gridHitTest:subview.center];
}

-(NSArray<UIView*>*) subviewsContainedInGrid:(id<GTUIGrid>)grid
{
    
    id<GTUIGridNode> gridNode = (id<GTUIGridNode>)grid;
    
#ifdef DEBUG
    NSAssert([gridNode gridLayoutView] == self, @"oops! 非栅格布局中的栅格");
#endif
    
    NSMutableArray *retSbs = [NSMutableArray new];
    NSArray *sbs = [self gtuiGetLayoutSubviews];
    for (UIView *sbv in sbs)
    {
        if (CGRectContainsRect(gridNode.gridRect, sbv.frame))
        {
            [retSbs addObject:sbv];
        }
    }
    
    return retSbs;
}


-(void)addViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData to:(NSInteger)gridTag
{
    [self insertViewGroup:viewGroup withActionData:actionData atIndex:(NSUInteger)-1 to:gridTag];
}

-(void)insertViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData atIndex:(NSUInteger)index to:(NSInteger)gridTag
{
    if (gridTag == 0)
    {
        for (UIView *sbv in viewGroup)
        {
            if (sbv != (UIView*)[NSNull null])
                [self addSubview:sbv];
        }
        
        return;
    }
    
    //...
    NSNumber *key = @(gridTag);
    NSMutableArray *viewGroupArray = [self.tagsDict objectForKey:key];
    if (viewGroupArray == nil)
    {
        viewGroupArray = [NSMutableArray new];
        [self.tagsDict setObject:viewGroupArray forKey:key];
    }
    
    GTUIViewGroupAndActionData *va = [GTUIViewGroupAndActionData viewGroup:viewGroup actionData:actionData];
    if (index == (NSUInteger)-1)
    {
        [viewGroupArray addObject:va];
    }
    else
    {
        [viewGroupArray insertObject:va atIndex:index];
    }
    
    for (UIView *sbv in viewGroup)
    {
        if (sbv != (UIView*)[NSNull null])
            [self addSubview:sbv];
    }
    
    [self setNeedsLayout];
}

-(void)replaceViewGroup:(NSArray<UIView*> *)viewGroup withActionData:(id)actionData atIndex:(NSUInteger)index to:(NSInteger)gridTag
{
    if (gridTag == 0)
    {
        return;
    }
    
    //...
    NSNumber *key = @(gridTag);
    NSMutableArray<GTUIViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (viewGroupArray == nil || (index >= viewGroupArray.count))
    {
        [self addViewGroup:viewGroup withActionData:actionData to:gridTag];
        return;
    }
    
    
    //这里面有可能有存在的视图， 有可能存在于子视图数组里面，有可能存在于其他视图组里面。
    //如果存在于其他标签则要从其他标签删除。。。
    //而且多余的还要删除。。。这个好复杂啊。。
    //先不考虑这么复杂的情况，只认为替换掉当前索引的视图即可，如果视图本来就在子视图里面则不删除，否则就添加。而被替换掉的则需要删除。
    //每个视图都在老的里面查找，如果找到则处理，如果没有找到
    self.tagsDictLock = YES;
    
    GTUIViewGroupAndActionData *va = viewGroupArray[index];
    va.actionData = actionData;
    
    if (va.viewGroup != viewGroup)
    {
        for (UIView *sbv in viewGroup)
        {
            NSUInteger oldIndex = [va.viewGroup indexOfObject:sbv];
            if (oldIndex == NSNotFound)
            {
                if (sbv != (UIView*)[NSNull null])
                    [self addSubview:sbv];
            }
            else
            {
                [va.viewGroup removeObjectAtIndex:oldIndex];
            }
        }
        
        //原来多余的视图删除
        for (UIView *sbv in va.viewGroup)
        {
            if (sbv != (UIView*)[NSNull null])
                [sbv removeFromSuperview];
        }
        
        //将新的视图组给替换掉。
        [va.viewGroup setArray:viewGroup];
    }
    
    self.tagsDictLock = NO;
    
    
    [self setNeedsLayout];
    
}


-(void)moveViewGroupAtIndex:(NSUInteger)index from:(NSInteger)origGridTag to:(NSInteger)destGridTag
{
    [self moveViewGroupAtIndex:index from:origGridTag toIndex:-1 to:destGridTag];
}

-(void)moveViewGroupAtIndex:(NSUInteger)index1 from:(NSInteger)origGridTag  toIndex:(NSUInteger)index2 to:(NSInteger)destGridTag
{
    if (origGridTag == 0 || destGridTag == 0 || (origGridTag == destGridTag))
        return;
    
    if (_tagsDict == nil)
        return;
    
    NSNumber *origKey = @(origGridTag);
    NSMutableArray<GTUIViewGroupAndActionData*> *origViewGroupArray = [self.tagsDict objectForKey:origKey];
    
    if (index1 < origViewGroupArray.count)
    {
        
        NSNumber *destKey = @(destGridTag);
        
        NSMutableArray<GTUIViewGroupAndActionData*> *destViewGroupArray = [self.tagsDict objectForKey:destKey];
        if (destViewGroupArray == nil)
        {
            destViewGroupArray = [NSMutableArray new];
            [self.tagsDict setObject:destViewGroupArray forKey:destKey];
        }
        
        if (index2 > destViewGroupArray.count)
            index2 = destViewGroupArray.count;
        
        
        GTUIViewGroupAndActionData *va = origViewGroupArray[index1];
        [origViewGroupArray removeObjectAtIndex:index1];
        if (origViewGroupArray.count == 0)
        {
            [self.tagsDict removeObjectForKey:origKey];
        }
        
        [destViewGroupArray insertObject:va atIndex:index2];
        
        
    }
    
    [self setNeedsLayout];
    
}



-(void)removeViewGroupAtIndex:(NSUInteger)index from:(NSInteger)gridTag
{
    if (gridTag == 0)
        return;
    
    if (_tagsDict == nil)
        return;
    
    NSNumber *key = @(gridTag);
    NSMutableArray<GTUIViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (index < viewGroupArray.count)
    {
        GTUIViewGroupAndActionData *va = viewGroupArray[index];
        
        self.tagsDictLock = YES;
        for (UIView *sbv in va.viewGroup)
        {
            if (sbv != (UIView*)[NSNull null])
                [sbv removeFromSuperview];
        }
        self.tagsDictLock = NO;
        
        
        [viewGroupArray removeObjectAtIndex:index];
        
        if (viewGroupArray.count == 0)
        {
            [self.tagsDict removeObjectForKey:key];
        }
        
    }
    
    [self setNeedsLayout];
}



-(void)removeViewGroupFrom:(NSInteger)gridTag
{
    if (gridTag == 0)
        return;
    
    if (_tagsDict == nil)
        return;
    
    NSNumber *key = @(gridTag);
    NSMutableArray<GTUIViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (viewGroupArray != nil)
    {
        self.tagsDictLock = YES;
        for (GTUIViewGroupAndActionData * va in viewGroupArray)
        {
            for (UIView *sbv in va.viewGroup)
            {
                if (sbv != (UIView*)[NSNull null])
                    [sbv removeFromSuperview];
            }
        }
        
        self.tagsDictLock = NO;
        
        [self.tagsDict removeObjectForKey:key];
    }
    
    [self setNeedsLayout];
    
}



-(void)exchangeViewGroupAtIndex:(NSUInteger)index1 from:(NSInteger)gridTag1  withViewGroupAtIndex:(NSUInteger)index2 from:(NSInteger)gridTag2
{
    if (gridTag1 == 0 || gridTag2 == 0)
        return;
    
    NSNumber *key1 = @(gridTag1);
    NSMutableArray<GTUIViewGroupAndActionData*> *viewGroupArray1 = [self.tagsDict objectForKey:key1];
    
    NSMutableArray<GTUIViewGroupAndActionData*> *viewGroupArray2 = nil;
    
    if (gridTag1 == gridTag2)
    {
        viewGroupArray2 = viewGroupArray1;
        if (index1 == index2)
            return;
    }
    else
    {
        NSNumber *key2 = @(gridTag2);
        viewGroupArray2 = [self.tagsDict objectForKey:key2];
    }
    
    if (index1 < viewGroupArray1.count && index2 < viewGroupArray2.count)
    {
        self.tagsDictLock = YES;
        
        if (gridTag1 == gridTag2)
        {
            [viewGroupArray1 exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
        }
        else
        {
            GTUIViewGroupAndActionData *va1 = viewGroupArray1[index1];
            GTUIViewGroupAndActionData *va2 = viewGroupArray2[index2];
            
            [viewGroupArray1 removeObjectAtIndex:index1];
            [viewGroupArray2 removeObjectAtIndex:index2];
            
            [viewGroupArray1 insertObject:va2 atIndex:index1];
            [viewGroupArray2 insertObject:va1 atIndex:index2];
        }
        
        
        self.tagsDictLock = NO;
        
        
    }
    
    [self setNeedsLayout];
    
}


-(NSUInteger)viewGroupCountOf:(NSInteger)gridTag
{
    if (gridTag == 0)
        return 0;
    
    if (_tagsDict == nil)
        return 0;
    
    NSNumber *key = @(gridTag);
    NSMutableArray<GTUIViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    
    return viewGroupArray.count;
}



-(NSArray<UIView*> *)viewGroupAtIndex:(NSUInteger)index from:(NSInteger)gridTag
{
    if (gridTag == 0)
        return nil;
    
    if (_tagsDict == nil)
        return nil;
    
    
    NSNumber *key = @(gridTag);
    NSMutableArray<GTUIViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
    if (index < viewGroupArray.count)
    {
        return viewGroupArray[index].viewGroup;
    }
    
    return nil;
}








#pragma mark -- GTUIGrid

-(id)actionData
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    return lsc.actionData;
}

-(void)setActionData:(id)actionData
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    lsc.actionData = actionData;
}

//添加行。返回新的栅格。
-(id<GTUIGrid>)addRow:(CGFloat)measure
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    id<GTUIGridNode> node = (id<GTUIGridNode>)[lsc addRow:measure];
    node.superGrid = self;
    return node;
}

//添加列。返回新的栅格。
-(id<GTUIGrid>)addCol:(CGFloat)measure
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    id<GTUIGridNode> node = (id<GTUIGridNode>)[lsc addCol:measure];
    node.superGrid = self;
    return node;
}

-(id<GTUIGrid>)addRowGrid:(id<GTUIGrid>)grid
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    id<GTUIGridNode> node = (id<GTUIGridNode>)[lsc addRowGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<GTUIGrid>)addColGrid:(id<GTUIGrid>)grid
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    id<GTUIGridNode> node = (id<GTUIGridNode>)[lsc addColGrid:grid];
    node.superGrid = self;
    return node;
}

-(id<GTUIGrid>)addRowGrid:(id<GTUIGrid>)grid measure:(CGFloat)measure
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    id<GTUIGridNode> node = (id<GTUIGridNode>)[lsc addRowGrid:grid measure:measure];
    node.superGrid = self;
    return node;
    
}

-(id<GTUIGrid>)addColGrid:(id<GTUIGrid>)grid measure:(CGFloat)measure
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    id<GTUIGridNode> node = (id<GTUIGridNode>)[lsc addColGrid:grid measure:measure];
    node.superGrid = self;
    return node;
    
}



-(id<GTUIGrid>)cloneGrid
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    return [lsc cloneGrid];
}

-(void)removeFromSuperGrid
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    return [lsc removeFromSuperGrid];
    
}

-(id<GTUIGrid>)superGrid
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    
    return lsc.superGrid;
}

-(void)setSuperGrid:(id<GTUIGridNode>)superGrid
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    lsc.superGrid = superGrid;
}

-(BOOL)placeholder
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    
    return lsc.placeholder;
}

-(void)setPlaceholder:(BOOL)placeholder
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    lsc.placeholder = placeholder;
}


-(BOOL)anchor
{
    
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    
    return lsc.anchor;
}

-(void)setAnchor:(BOOL)anchor
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    lsc.anchor = anchor;
}

-(GTUIGravity)overlap
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    
    return lsc.overlap;
}

-(void)setOverlap:(GTUIGravity)overlap
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    lsc.overlap = overlap;
}

-(NSDictionary*)gridDictionary
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    return lsc.gridDictionary;
}


-(void)setGridDictionary:(NSDictionary *)gridDictionary
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    lsc.gridDictionary = gridDictionary;
}


#pragma mark -- GTUIGridNode


-(NSMutableArray<id<GTUIGridNode>> *)subGrids
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    return (NSMutableArray<id<GTUIGridNode>> *)(lsc.subGrids);
}

-(void)setSubGrids:(NSMutableArray<id<GTUIGridNode>> *)subGrids
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    lsc.subGrids = subGrids;
}

-(GTUISubGridsType)subGridsType
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    
    return lsc.subGridsType;
}

-(void)setSubGridsType:(GTUISubGridsType)subGridsType
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    lsc.subGridsType = subGridsType;
}


-(CGFloat)measure
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    return lsc.measure;
}

-(void)setMeasure:(CGFloat)measure
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    lsc.measure = measure;
}

-(CGRect)gridRect
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    return lsc.gridRect;
}

-(void)setGridRect:(CGRect)gridRect
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    lsc.gridRect = gridRect;
}

//更新格子尺寸。
-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<GTUIGridNode>)superGrid withMeasure:(CGFloat)measure
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    return [lsc updateGridSize:superSize superGrid:superGrid withMeasure:measure];
}

-(CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<GTUIGridNode>)superGrid withOffset:(CGFloat)offset
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    
    return [lsc updateGridOrigin:superOrigin superGrid:superGrid withOffset:offset];
}



-(UIView*)gridLayoutView
{
    return self;
}

-(SEL)gridAction
{
    return nil;
}

-(void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer *)layer
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    [lsc setBorderlineNeedLayoutIn:rect withLayer:layer];
    
}

-(void)showBorderline:(BOOL)show
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    [lsc showBorderline:show];
    
}

-(id<GTUIGrid>)gridHitTest:(CGPoint)point
{
    GTUIGridLayout *lsc = self.gtuiCurrentSizeClass;
    return [lsc gridHitTest:point];
}


#pragma mark -- Touches Event

-(id<GTUIGridNode>)gtuiBestHitGrid:(NSSet *)touches
{
    GTUISizeClass sizeClass = [self gtuiGetGlobalSizeClass];
    id<GTUIGridNode> bestSC = (id<GTUIGridNode>)[self gtuiBestSizeClass:sizeClass];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return  [bestSC gridHitTest:point];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [[self gtuiBestHitGrid:touches] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self gtuiBestHitGrid:touches] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self gtuiBestHitGrid:touches] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self gtuiBestHitGrid:touches] touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}



#pragma mark -- Override Methods

-(void)dealloc
{
    //这里提前释放所有的数据，防止willRemoveSubview中重复删除。。
    _tagsDict = nil;
}

-(void)removeAllSubviews
{
    _tagsDict = nil;  //提前释放所有绑定的数据
    [super removeAllSubviews];
}

-(void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
    
    //如果子试图在样式里面则从样式里面删除
    if (_tagsDict != nil && !self.tagsDictLock)
    {
        [_tagsDict enumerateKeysAndObjectsUsingBlock:^(id   key, id   obj, BOOL *  stop) {
            
            NSMutableArray *viewGroupArray = (NSMutableArray*)obj;
            NSInteger sbsCount = viewGroupArray.count;
            for (NSInteger j = 0; j < sbsCount; j++)
            {
                GTUIViewGroupAndActionData *va = viewGroupArray[j];
                NSInteger sbvCount = va.viewGroup.count;
                for (NSInteger i = 0; i < sbvCount; i++)
                {
                    if (va.viewGroup[i] == subview)
                    {
                        [va.viewGroup removeObjectAtIndex:i];
                        break;
                        *stop = YES;
                    }
                }
                
                if (va.viewGroup.count == 0)
                {
                    [viewGroupArray removeObjectAtIndex:j];
                    break;
                }
                
                if (*stop)
                    break;
            }
            
            
        }];
    }
}


-(CGSize)calcLayoutRect:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(GTUISizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutRect:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self gtuiGetLayoutSubviews];
    
    
    GTUIFrame *gtuiFrame = self.gtuiFrame;
    
    GTUIGridLayout *lsc =  [self gtuiCurrentSizeClassFrom:gtuiFrame];
    
    //只有在非评估，并且当sizeclass的数量大于1个，并且当前的sizeclass和lastSizeClass不一致的时候
    if (!isEstimate && gtuiFrame.multiple)
    {
        //将子栅格中的layer隐藏。
        if (self.lastSizeClass != nil && ((GTUIGridLayoutViewSizeClass*)lsc) != self.lastSizeClass)
            [((id<GTUIGridNode>)self.lastSizeClass) showBorderline:NO];
        
        self.lastSizeClass = (GTUIGridLayoutViewSizeClass*)lsc;
    }
    
    
    //设置根格子的rect为布局视图的大小。
    lsc.gridRect = CGRectMake(0, 0, selfSize.width, selfSize.height);
    
    
    NSMutableDictionary *tagKeyIndexDict = [NSMutableDictionary dictionaryWithCapacity:self.tagsDict.count];
    for (NSNumber *key in self.tagsDict)
    {
        [tagKeyIndexDict setObject:@(0) forKey:key];
    }
    
    //遍历尺寸
    NSInteger index = 0;
    CGFloat selfMeasure = [self gtuiTraversalGridSize:lsc gridSize:selfSize lsc:lsc sbs:sbs pIndex:&index tagViewGroupIndexDict:tagKeyIndexDict tagViewGroup:nil pTagIndex:nil];
    if (lsc.wrapContentHeight)
    {
        selfSize.height =  selfMeasure;
    }
    
    if (lsc.wrapContentWidth)
    {
        selfSize.width = selfMeasure;
    }
    
    //遍历位置。
    for (NSNumber *key in self.tagsDict)
    {
        [tagKeyIndexDict setObject:@(0) forKey:key];
    }
    
    NSEnumerator<UIView*> *enumerator = sbs.objectEnumerator;
    [self gtuiTraversalGridOrigin:lsc gridOrigin:CGPointMake(0, 0) lsc:lsc sbvEnumerator:enumerator tagViewGroupIndexDict:tagKeyIndexDict tagSbvEnumerator:nil  isEstimate:isEstimate sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
    
    
    //遍历那些还剩余的然后设置为0.
    [tagKeyIndexDict enumerateKeysAndObjectsUsingBlock:^(id key, NSNumber *viewGroupIndexNumber, BOOL *  stop) {
        
        NSArray<GTUIViewGroupAndActionData*> *viewGroupArray = self.tagsDict[key];
        NSInteger viewGroupIndex = viewGroupIndexNumber.integerValue;
        for (NSInteger i = viewGroupIndex; i < viewGroupArray.count; i++)
        {
            GTUIViewGroupAndActionData *va = viewGroupArray[i];
            for (UIView *sbv in va.viewGroup)
            {
                if (sbv != (UIView*)[NSNull null])
                {
                    sbv.gtuiFrame.frame = CGRectZero;
                    
                    //这里面让所有视图的枚举器也走一遍，解决下面的重复设置的问题。
                    UIView *anyway = enumerator.nextObject;
                    anyway = nil;  //防止有anyway编译告警而设置。
                }
            }
        }
    }];
    
    
    //处理那些剩余没有放入格子的子视图的frame设置为0
    for (UIView *sbv = enumerator.nextObject; sbv; sbv = enumerator.nextObject)
    {
        sbv.gtuiFrame.frame = CGRectZero;
    }
    
    
    [self gtuiAdjustLayoutSelfSize:&selfSize lsc:lsc];
    
    //对所有子视图进行布局变换
    [self gtuiAdjustSubviewsLayoutTransform:sbs lsc:lsc selfWidth:selfSize.width selfHeight:selfSize.height];
    //对所有子视图进行RTL设置
    [self gtuiAdjustSubviewsRTLPos:sbs selfWidth:selfSize.width];
    
    return [self gtuiAdjustSizeWhenNoSubviews:selfSize sbs:sbs lsc:lsc];
}

-(id)createSizeClassInstance
{
    return [GTUIGridLayoutViewSizeClass new];
}

#pragma mark -- Private Methods

//遍历位置
-(void)gtuiTraversalGridOrigin:(id<GTUIGridNode>)grid  gridOrigin:(CGPoint)gridOrigin lsc:(GTUIGridLayout*)lsc sbvEnumerator:(NSEnumerator<UIView*>*)sbvEnumerator tagViewGroupIndexDict:(NSMutableDictionary*)tagViewGroupIndexDict tagSbvEnumerator:(NSEnumerator<UIView*>*)tagSbvEnumerator isEstimate:(BOOL)isEstimate sizeClass:(GTUISizeClass)sizeClass pHasSubLayout:(BOOL*)pHasSubLayout
{
    //这要优化减少不必要的空数组的建立。。
    NSArray<id<GTUIGridNode>> * subGrids = nil;
    if (grid.subGridsType != GTUISubGridsTypeUnknown)
        subGrids = grid.subGrids;
    
    //绘制边界线。。
    if (!isEstimate)
    {
        [grid setBorderlineNeedLayoutIn:grid.gridRect withLayer:self.layer];
    }
    
    
    if (grid.tag != 0)
    {
        NSNumber *key = @(grid.tag);
        
        NSMutableArray<GTUIViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
        NSNumber *viewGroupIndex = [tagViewGroupIndexDict objectForKey:key];
        if (viewGroupArray != nil && viewGroupIndex != nil)
        {
            if (viewGroupIndex.integerValue < viewGroupArray.count)
            {
                //这里将动作的数据和栅格进行关联。
                grid.actionData = viewGroupArray[viewGroupIndex.integerValue].actionData;
                
                tagSbvEnumerator =  viewGroupArray[viewGroupIndex.integerValue].viewGroup.objectEnumerator;
                [tagViewGroupIndexDict setObject:@(viewGroupIndex.integerValue + 1) forKey:key];
            }
            else
            {
                grid.actionData = nil;
                tagSbvEnumerator = nil;
                sbvEnumerator = nil;
            }
        }
        else
        {
            tagSbvEnumerator = nil;
        }
    }
    
    CGFloat paddingTop;
    CGFloat paddingLeading;
    CGFloat paddingBottom;
    CGFloat paddingTrailing;
    if (grid == lsc)
    {
        paddingTop = lsc.gtuiLayoutTopPadding;
        paddingLeading = lsc.gtuiLayoutLeadingPadding;
        paddingBottom = lsc.gtuiLayoutBottomPadding;
        paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    }
    else
    {
        UIEdgeInsets gridPadding = grid.padding;
        paddingTop = gridPadding.top;
        paddingLeading = [GTUIBaseLayout isRTL] ? gridPadding.right : gridPadding.left;
        paddingBottom = gridPadding.bottom;
        paddingTrailing = [GTUIBaseLayout isRTL] ? gridPadding.left : gridPadding.right;
    }
    
    //处理叶子节点。
    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder)
    {
        //设置子视图的位置和尺寸。。
        UIView *sbv = nil;
        UIView *tagSbv = tagSbvEnumerator.nextObject;
        
        if (tagSbv != (UIView*)[NSNull null])
            sbv = sbvEnumerator.nextObject;
        
        if (tagSbv != nil && tagSbv != (UIView*)[NSNull null] && tagSbvEnumerator != nil)
            sbv = tagSbv;
        
        if (sbv != nil)
        {
            //调整位置和尺寸。。。
            GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
            
            UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
            
            //取垂直和水平对齐
            GTUIGravity vertGravity = grid.gravity & GTUIGravityHorzMask;
            if (vertGravity == GTUIGravityNone)
                vertGravity = GTUIGravityVertFill;
            
            GTUIGravity horzGravity = grid.gravity & GTUIGravityVertMask;
            if (horzGravity == GTUIGravityNone)
                horzGravity = GTUIGravityHorzFill;
            else
                horzGravity = [self gtuiConvertLeftRightGravityToLeadingTrailing:horzGravity];
            
            
            //如果非叶子栅格设置为anchor则子视图的内容总是填充的
            CGFloat tempPaddingTop = paddingTop;
            CGFloat tempPaddingLeading = paddingLeading;
            CGFloat tempPaddingBottom = paddingBottom;
            CGFloat tempPaddingTrailing = paddingTrailing;
            
            if (grid.anchor && subGrids.count > 0)
            {
                vertGravity = GTUIGravityVertFill;
                horzGravity = GTUIGravityHorzFill;
                tempPaddingTop = 0;
                tempPaddingLeading = 0;
                tempPaddingBottom = 0;
                tempPaddingTrailing = 0;
            }
            
            //如果是尺寸为0，并且设置为了anchor的话那么就根据自身
            
            //如果尺寸是0则因为前面有算出尺寸，所以这里就不进行调整了。
            if (grid.measure != 0 && [sbv isKindOfClass:[GTUIBaseLayout class]])
            {
                [self gtuiAdjustSubviewWrapContentSet:sbv isEstimate:isEstimate sbvgtuiFrame:sbvgtuiFrame sbvsc:sbvsc selfSize:grid.gridRect.size sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
            }
            else
            {
            }
            
            [self gtuiCalcSubViewRect:sbv sbvsc:sbvsc sbvgtuiFrame:sbvgtuiFrame lsc:lsc vertGravity:vertGravity horzGravity:horzGravity inSelfSize:grid.gridRect.size paddingTop:tempPaddingTop paddingLeading:tempPaddingLeading paddingBottom:tempPaddingBottom paddingTrailing:tempPaddingTrailing pMaxWrapSize:NULL];
            
            sbvgtuiFrame.leading += gridOrigin.x;
            sbvgtuiFrame.top += gridOrigin.y;
            
        }
    }
    
    
    
    //处理子格子的位置。
    
    CGFloat offset = 0;
    if (grid.subGridsType == GTUISubGridsTypeCol)
    {
        offset = gridOrigin.x + paddingLeading;
        
        GTUIGravity horzGravity = [self gtuiConvertLeftRightGravityToLeadingTrailing:grid.gravity & GTUIGravityVertMask];
        if (horzGravity == GTUIGravityHorzCenter || horzGravity == GTUIGravityHorzTrailing)
        {
            //得出所有子栅格的宽度综合
            CGFloat subGridsWidth = 0;
            for (id<GTUIGridNode> sbvGrid in subGrids)
            {
                subGridsWidth += sbvGrid.gridRect.size.width;
            }
            
            if (subGrids.count > 1)
                subGridsWidth += grid.subviewSpace * (subGrids.count - 1);
            
            
            if (horzGravity == GTUIGravityHorzCenter)
            {
                offset += (grid.gridRect.size.width - paddingLeading - paddingTrailing - subGridsWidth)/2;
            }
            else
            {
                offset += grid.gridRect.size.width - paddingLeading - paddingTrailing - subGridsWidth;
            }
        }
        
        
    }
    else if (grid.subGridsType == GTUISubGridsTypeRow)
    {
        offset = gridOrigin.y + paddingTop;
        
        GTUIGravity vertGravity = grid.gravity & GTUIGravityHorzMask;
        if (vertGravity == GTUIGravityVertCenter || vertGravity == GTUIGravityVertBottom)
        {
            //得出所有子栅格的宽度综合
            CGFloat subGridsHeight = 0;
            for (id<GTUIGridNode> sbvGrid in subGrids)
            {
                subGridsHeight += sbvGrid.gridRect.size.height;
            }
            
            if (subGrids.count > 1)
                subGridsHeight += grid.subviewSpace * (subGrids.count - 1);
            
            if (vertGravity == GTUIGravityVertCenter)
            {
                offset += (grid.gridRect.size.height - paddingTop - paddingBottom - subGridsHeight)/2;
            }
            else
            {
                offset += grid.gridRect.size.height - paddingTop - paddingBottom - subGridsHeight;
            }
        }
        
    }
    else
    {
        
    }
    
    
    
    CGPoint paddingGridOrigin = CGPointMake(gridOrigin.x + paddingLeading, gridOrigin.y + paddingTop);
    for (id<GTUIGridNode> sbvGrid in subGrids)
    {
        offset += [sbvGrid updateGridOrigin:paddingGridOrigin superGrid:grid withOffset:offset];
        offset += grid.subviewSpace;
        [self gtuiTraversalGridOrigin:sbvGrid gridOrigin:sbvGrid.gridRect.origin lsc:lsc sbvEnumerator:sbvEnumerator tagViewGroupIndexDict:tagViewGroupIndexDict tagSbvEnumerator:((sbvGrid.tag != 0)? nil: tagSbvEnumerator) isEstimate:isEstimate sizeClass:sizeClass pHasSubLayout:pHasSubLayout];
    }
    
    //如果栅格中的tagSbvEnumerator还有剩余的视图没有地方可填，那么就将尺寸和位置设置为0
    if (grid.tag != 0)
    {
        //枚举那些剩余的
        for (UIView *sbv = tagSbvEnumerator.nextObject; sbv; sbv = tagSbvEnumerator.nextObject)
        {
            if (sbv != (UIView*)[NSNull null])
            {
                sbv.gtuiFrame.frame = CGRectZero;
                
                //所有子视图枚举器也要移动。
                UIView *anyway = sbvEnumerator.nextObject;
                anyway = nil;
            }
        }
    }
    
}

-(void)gtuiBlankTraverse:(id<GTUIGridNode>)grid sbs:(NSArray<UIView*>*)sbs pIndex:(NSInteger*)pIndex tagSbs:(NSArray<UIView*> *)tagSbs pTagIndex:(NSInteger*)pTagIndex
{
    NSArray<id<GTUIGridNode>> *subGrids = nil;
    if (grid.subGridsType != GTUISubGridsTypeUnknown)
        subGrids = grid.subGrids;
    
    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder)
    {
        BOOL isNoNullSbv = YES;
        if (grid.tag == 0 && pTagIndex != NULL)
        {
            *pTagIndex = *pTagIndex + 1;
            
            if (tagSbs != nil && *pTagIndex < tagSbs.count && tagSbs[*pTagIndex] == (UIView*)[NSNull null])
                isNoNullSbv = NO;
        }
        
        if (isNoNullSbv)
            *pIndex = *pIndex + 1;
        
    }
    
    for (id<GTUIGridNode> sbvGrid in subGrids)
    {
        [self gtuiBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagSbs pTagIndex:(grid.tag != 0)? NULL : pTagIndex];
    }
}

//遍历尺寸。
-(CGFloat)gtuiTraversalGridSize:(id<GTUIGridNode>)grid gridSize:(CGSize)gridSize lsc:(GTUIGridLayout*)lsc sbs:(NSArray<UIView*>*)sbs pIndex:(NSInteger*)pIndex tagViewGroupIndexDict:(NSMutableDictionary*)tagViewGroupIndexDict  tagViewGroup:(NSArray<UIView*>*)tagViewGroup  pTagIndex:(NSInteger*)pTagIndex
{
    NSArray<id<GTUIGridNode>> *subGrids = nil;
    if (grid.subGridsType != GTUISubGridsTypeUnknown)
        subGrids = grid.subGrids;
    
    
    CGFloat paddingTop;
    CGFloat paddingLeading;
    CGFloat paddingBottom;
    CGFloat paddingTrailing;
    if (grid == lsc)
    {
        paddingTop = lsc.gtuiLayoutTopPadding;
        paddingLeading = lsc.gtuiLayoutLeadingPadding;
        paddingBottom = lsc.gtuiLayoutBottomPadding;
        paddingTrailing = lsc.gtuiLayoutTrailingPadding;
    }
    else
    {
        UIEdgeInsets gridPadding = grid.padding;
        paddingTop = gridPadding.top;
        paddingLeading = [GTUIBaseLayout isRTL] ? gridPadding.right : gridPadding.left;
        paddingBottom = gridPadding.bottom;
        paddingTrailing = [GTUIBaseLayout isRTL] ? gridPadding.left : gridPadding.right;
    }
    
    CGFloat fixedMeasure = 0;  //固定部分的尺寸
    CGFloat validMeasure = 0;  //整体有效的尺寸
    if (subGrids.count > 1)
        fixedMeasure += (subGrids.count - 1) * grid.subviewSpace;
    
    if (grid.subGridsType == GTUISubGridsTypeCol)
    {
        fixedMeasure += paddingLeading + paddingTrailing;
        validMeasure = grid.gridRect.size.width - fixedMeasure;
    }
    else if(grid.subGridsType == GTUISubGridsTypeRow)
    {
        fixedMeasure += paddingTop + paddingBottom;
        validMeasure = grid.gridRect.size.height - fixedMeasure;
    }
    else;
    
    
    //得到匹配的form
    if (grid.tag != 0)
    {
        NSNumber *key = @(grid.tag);
        NSMutableArray<GTUIViewGroupAndActionData*> *viewGroupArray = [self.tagsDict objectForKey:key];
        NSNumber *viewGroupIndex = [tagViewGroupIndexDict objectForKey:key];
        if (viewGroupArray != nil && viewGroupIndex != nil)
        {
            if (viewGroupIndex.integerValue < viewGroupArray.count)
            {
                tagViewGroup = viewGroupArray[viewGroupIndex.integerValue].viewGroup;
                NSInteger tagIndex = 0;
                pTagIndex = &tagIndex;
                [tagViewGroupIndexDict setObject:@(viewGroupIndex.integerValue + 1) forKey:key];
            }
            else
            {
                tagViewGroup = nil;
                pTagIndex = NULL;
                sbs = nil;
            }
        }
        else
        {
            tagViewGroup = nil;
            pTagIndex = NULL;
        }
    }
    
    
    //叶子节点
    if ((grid.anchor || subGrids.count == 0) && !grid.placeholder)
    {
        BOOL isNotNullSbv = YES;
        NSArray *tempSbs = sbs;
        NSInteger *pTempIndex = pIndex;
        
        if (tagViewGroup != nil && pTagIndex != NULL)
        {
            tempSbs = tagViewGroup;
            pTempIndex = pTagIndex;
        }
        
        //如果尺寸是包裹
        if (grid.measure == GTUILayoutSize.wrap ||  (grid.measure == 0 && grid.anchor))
        {
            if (*pTempIndex < tempSbs.count)
            {
                //加这个条件是根栅格如果是叶子栅格的话不处理这种情况。
                if (grid.superGrid != nil)
                {
                    UIView *sbv = tempSbs[*pTempIndex];
                    if (sbv != (UIView*)[NSNull null])
                    {
                        
                        //叶子节点
                        if (!grid.anchor || (grid.measure == 0 && grid.anchor))
                        {
                            GTUIFrame *sbvgtuiFrame = sbv.gtuiFrame;
                            UIView *sbvsc = [self gtuiCurrentSizeClassFrom:sbvgtuiFrame];
                            sbvgtuiFrame.frame = sbv.bounds;
                            
                            //如果子视图不设置任何约束但是又是包裹的则这里特殊处理。
                            if (sbvsc.widthSizeInner == nil && sbvsc.heightSizeInner == nil && !sbvsc.wrapContentSize)
                            {
                                CGSize size = CGSizeZero;
                                if (grid.superGrid.subGridsType == GTUISubGridsTypeRow)
                                {
                                    size.width = gridSize.width - paddingLeading - paddingTrailing;
                                }
                                else
                                {
                                    size.height = gridSize.height - paddingTop - paddingBottom;
                                }
                                
                                size = [sbv sizeThatFits:size];
                                sbvgtuiFrame.width = size.width;
                                sbvgtuiFrame.height = size.height;
                            }
                            else
                            {
                                
                                [self gtuiCalcSizeOfWrapContentSubview:sbv sbvsc:sbvsc sbvgtuiFrame:sbvgtuiFrame];
                                
                                [self gtuiCalcSubViewRect:sbv sbvsc:sbvsc sbvgtuiFrame:sbvgtuiFrame lsc:lsc vertGravity:GTUIGravityNone horzGravity:GTUIGravityNone inSelfSize:grid.gridRect.size paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing pMaxWrapSize:NULL];
                            }
                            
                            if (grid.superGrid.subGridsType == GTUISubGridsTypeRow)
                            {
                                fixedMeasure = paddingTop + paddingBottom + sbvgtuiFrame.height;
                            }
                            else
                            {
                                fixedMeasure = paddingLeading + paddingTrailing + sbvgtuiFrame.width;
                            }
                        }
                    }
                    else
                        isNotNullSbv = NO;
                }
            }
        }
        
        //索引加1跳转到下一个节点。
        if (tagViewGroup != nil &&  pTagIndex != NULL)
        {
            *pTempIndex = *pTempIndex + 1;
        }
        
        if (isNotNullSbv)
            *pIndex = *pIndex + 1;
    }
    
    
    if (subGrids.count > 0)
    {
        
        NSMutableArray<id<GTUIGridNode>> *weightSubGrids = [NSMutableArray new];  //比重尺寸子格子数组
        NSMutableArray<NSNumber*> *weightSubGridsIndexs = [NSMutableArray new]; //比重尺寸格子的开头子视图位置索引
        NSMutableArray<NSNumber*> *weightSubGridsTagIndexs = [NSMutableArray new]; //比重尺寸格子的开头子视图位置索引
        
        
        NSMutableArray<id<GTUIGridNode>> *fillSubGrids = [NSMutableArray new];    //填充尺寸格子数组
        NSMutableArray<NSNumber*> *fillSubGridsIndexs = [NSMutableArray new];   //填充尺寸格子的开头子视图位置索引
        NSMutableArray<NSNumber*> *fillSubGridsTagIndexs = [NSMutableArray new];   //填充尺寸格子的开头子视图位置索引
        
        
        //包裹尺寸先遍历所有子格子
        CGSize gridSize2 = gridSize;
        if (grid.subGridsType == GTUISubGridsTypeRow)
        {
            gridSize2.width -= (paddingLeading + paddingTrailing);
        }
        else
        {
            gridSize2.height -= (paddingTop + paddingBottom);
        }
        
        for (id<GTUIGridNode> sbvGrid in subGrids)
        {
            if (sbvGrid.measure == GTUILayoutSize.wrap)
            {
                
                CGFloat measure = [self gtuiTraversalGridSize:sbvGrid gridSize:gridSize2 lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
                fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid  withMeasure:measure];
                
            }
            else if (sbvGrid.measure >= 1 || sbvGrid.measure == 0)
            {
                fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:sbvGrid.measure];
                
                //遍历儿子节点。。
                [self gtuiTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
                
            }
            else if (sbvGrid.measure > 0 && sbvGrid.measure < 1)
            {
                fixedMeasure += [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:validMeasure * sbvGrid.measure];
                
                //遍历儿子节点。。
                [self gtuiTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:pIndex tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
                
            }
            else if (sbvGrid.measure < 0 && sbvGrid.measure > -1)
            {
                [weightSubGrids addObject:sbvGrid];
                [weightSubGridsIndexs addObject:@(*pIndex)];
                
                if (pTagIndex != NULL)
                {
                    [weightSubGridsTagIndexs addObject:@(*pTagIndex)];
                }
                
                //这里面空转一下。
                [self gtuiBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagViewGroup pTagIndex:pTagIndex];
                
                
            }
            else if (sbvGrid.measure == GTUILayoutSize.fill)
            {
                [fillSubGrids addObject:sbvGrid];
                
                [fillSubGridsIndexs addObject:@(*pIndex)];
                
                if (pTagIndex != NULL)
                {
                    [fillSubGridsTagIndexs addObject:@(*pTagIndex)];
                }
                
                //这里面空转一下。
                [self gtuiBlankTraverse:sbvGrid sbs:sbs pIndex:pIndex tagSbs:tagViewGroup pTagIndex:pTagIndex];
            }
            else
            {
                NSAssert(0, @"oops!");
            }
        }
        
        
        //算出剩余的尺寸。
        BOOL hasTagIndex = (pTagIndex != NULL);
        CGFloat remainedMeasure = 0;
        if (grid.subGridsType == GTUISubGridsTypeCol)
        {
            remainedMeasure = grid.gridRect.size.width - fixedMeasure;
        }
        else if (grid.subGridsType == GTUISubGridsTypeRow)
        {
            remainedMeasure = grid.gridRect.size.height - fixedMeasure;
        }
        else;
        
        NSInteger weightSubGridCount = weightSubGrids.count;
        if (weightSubGridCount > 0)
        {
            for (NSInteger i = 0; i < weightSubGridCount; i++)
            {
                id<GTUIGridNode> sbvGrid = weightSubGrids[i];
                remainedMeasure -= [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:-1 * remainedMeasure * sbvGrid.measure];
                
                NSInteger index = weightSubGridsIndexs[i].integerValue;
                if (hasTagIndex)
                {
                    NSInteger tagIndex = weightSubGridsTagIndexs[i].integerValue;
                    pTagIndex = &tagIndex;
                }
                else
                {
                    pTagIndex = NULL;
                }
                
                [self gtuiTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:&index tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
            }
        }
        
        NSInteger fillSubGridsCount = fillSubGrids.count;
        if (fillSubGridsCount > 0)
        {
            NSInteger totalCount = fillSubGridsCount;
            for (NSInteger i = 0; i < fillSubGridsCount; i++)
            {
                id<GTUIGridNode> sbvGrid = fillSubGrids[i];
                remainedMeasure -= [sbvGrid updateGridSize:gridSize2 superGrid:grid withMeasure:_gtuiCGFloatRound(remainedMeasure * (1.0/totalCount))];
                totalCount -= 1;
                
                NSInteger index = fillSubGridsIndexs[i].integerValue;
                
                if (hasTagIndex)
                {
                    NSInteger tagIndex = fillSubGridsTagIndexs[i].integerValue;
                    pTagIndex = &tagIndex;
                }
                else
                {
                    pTagIndex = nil;
                }
                
                [self gtuiTraversalGridSize:sbvGrid gridSize:sbvGrid.gridRect.size lsc:lsc sbs:sbs pIndex:&index tagViewGroupIndexDict:tagViewGroupIndexDict tagViewGroup:tagViewGroup pTagIndex:pTagIndex];
            }
        }
    }
    return fixedMeasure;
}


@end
