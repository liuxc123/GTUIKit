//
//  GTUIGridNode.m
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import "GTUIGridNode.h"
#import "GTUILayoutDelegate.h"
#import "GTUIBaseLayout.h"
#import "GTUIGridLayout.h"


/////////////////////////////////////////////////////////////////////////////////////////////



/**
 为支持栅格触摸而建立的触摸委托派生类。
 */
@interface GTUIGridNodeTouchEventDelegate : GTUITouchEventDelegate

@property(nonatomic, weak) id<GTUIGridNode> grid;
@property(nonatomic, weak) CALayer *gridLayer;

@property(nonatomic, assign) NSInteger tag;
@property(nonatomic, strong) id actionData;

-(instancetype)initWithLayout:(GTUIBaseLayout*)layout grid:(id<GTUIGridNode>)grid;

@end


@implementation GTUIGridNodeTouchEventDelegate

-(instancetype)initWithLayout:(GTUIBaseLayout*)layout grid:(id<GTUIGridNode>)grid
{
    self = [super initWithLayout:layout];
    if (self != nil)
    {
        _grid = grid;
    }
    
    return self;
}


-(void)gtuiSetTouchHighlighted
{
    //如果有高亮则建立一个高亮子层。
    if (self.layout.highlightedBackgroundColor != nil)
    {
        if (self.gridLayer == nil)
        {
            CALayer *layer = [[CALayer alloc] init];
            layer.zPosition = -1;
            [self.layout.layer addSublayer:layer];
            self.gridLayer = layer;
        }
        self.gridLayer.frame = self.grid.gridRect;
        self.gridLayer.backgroundColor = self.layout.highlightedBackgroundColor.CGColor;
    }
}

-(void)gtuiResetTouchHighlighted
{
    //恢复高亮，删除子图层
    if (self.gridLayer != nil)
    {
        [self.gridLayer removeFromSuperlayer];
    }
    self.gridLayer = nil;
}

-(id)gtuiActionSender
{
    return _grid;
}

-(void)dealloc
{
    [self gtuiResetTouchHighlighted];
}


@end



typedef struct _GTUIGridOptionalProperties1
{
    uint32_t subGridType:2;
    uint32_t gravity:16;
    uint32_t placeholder:1;
    uint32_t anchor:1;
    
}GTUIGridOptionalProperties1;


/**
 为节省栅格的内存而构建的可选属性列表1:子栅格间距，栅格内边距，停靠方式。
 */
typedef struct  _GTUIGridOptionalProperties2
{
    //格子内子栅格的间距
    CGFloat subviewSpace;
    //格子内视图的内边距。
    UIEdgeInsets padding;
    //格子内子视图的对齐停靠方式。
}GTUIGridOptionalProperties2;


@interface GTUIGridNode()

@property(nonatomic, assign) GTUIGridOptionalProperties1 optionalProperties1;
@property(nonatomic, assign) GTUIGridOptionalProperties2 *optionalProperties2;
@property(nonatomic, strong) GTUIBorderlineLayerDelegate *borderlineLayerDelegate;
@property(nonatomic, strong) GTUIGridNodeTouchEventDelegate *touchEventDelegate;


@end


@implementation GTUIGridNode

-(instancetype)initWithMeasure:(CGFloat)measure superGrid:(id<GTUIGridNode>)superGrid
{
    self = [self init];
    if (self != nil)
    {
        _measure = measure;
        _subGrids = nil;
        _gridRect = CGRectZero;
        _superGrid = superGrid;
        _optionalProperties2 = NULL;
        _borderlineLayerDelegate = nil;
        _touchEventDelegate = nil;
        memset(&_optionalProperties1, 0, sizeof(GTUIGridOptionalProperties1));
    }
    
    return self;
}

-(GTUIGridOptionalProperties2*)optionalProperties2
{
    if (_optionalProperties2 == NULL)
    {
        _optionalProperties2 = (GTUIGridOptionalProperties2*)malloc(sizeof(GTUIGridOptionalProperties2));
        memset(_optionalProperties2, 0, sizeof(GTUIGridOptionalProperties2));
    }
    
    return _optionalProperties2;
}

-(void)dealloc
{
    if (_optionalProperties2 != NULL)
        free(_optionalProperties2);
    _optionalProperties2 = NULL;
}

#pragma mark -- GTUIGridAction

-(NSInteger)tag
{
    return _touchEventDelegate.tag;
}

-(void)setTag:(NSInteger)tag
{
    
    if (_touchEventDelegate == nil && tag != 0)
    {
        _touchEventDelegate =  [[GTUIGridNodeTouchEventDelegate alloc] initWithLayout:(GTUIBaseLayout*)[self gridLayoutView] grid:self];
    }
    
    _touchEventDelegate.tag = tag;
}

-(id)actionData
{
    return _touchEventDelegate.actionData;
}

- (NSString *)action
{
    return NSStringFromSelector(_touchEventDelegate.action);
}

-(void)setActionData:(id)actionData
{
    if (_touchEventDelegate == nil && actionData != nil)
    {
        _touchEventDelegate =  [[GTUIGridNodeTouchEventDelegate alloc] initWithLayout:(GTUIBaseLayout*)[self gridLayoutView] grid:self];
    }
    
    _touchEventDelegate.actionData = actionData;
}


-(void)setTarget:(id)target action:(SEL)action
{
    if (_touchEventDelegate == nil && target != nil)
    {
        _touchEventDelegate = [[GTUIGridNodeTouchEventDelegate alloc] initWithLayout:(GTUIBaseLayout*)[self gridLayoutView] grid:self];
    }
    
    [_touchEventDelegate setTarget:target action:action];
    
    //  if (target == nil)
    //    _touchEventDelegate = nil;
}


- (NSDictionary *)gridDictionary
{
    return [GTUIGridNode translateGridNode:self toGridDictionary:
            [NSMutableDictionary new]];
}

- (void)setGridDictionary:(NSDictionary *)gridDictionary
{
    [_subGrids removeAllObjects];
    self.subGridsType = GTUISubGridsTypeUnknown;
    if (gridDictionary == nil)
        return;
    
    [GTUIGridNode translateGridDicionary:gridDictionary toGridNode:self];
}




#pragma mark -- GTUIGrid

-(GTUISubGridsType)subGridsType
{
    return (GTUISubGridsType)_optionalProperties1.subGridType;
}

-(void)setSubGridsType:(GTUISubGridsType)subGridsType
{
    _optionalProperties1.subGridType = subGridsType;
}


-(GTUIGravity)gravity
{
    return (GTUIGravity)_optionalProperties1.gravity;
}

-(void)setGravity:(GTUIGravity)gravity
{
    _optionalProperties1.gravity = gravity;
}


-(BOOL)placeholder
{
    return _optionalProperties1.placeholder == 1;
}

-(void)setPlaceholder:(BOOL)placeholder
{
    _optionalProperties1.placeholder = placeholder ? 1 : 0;
}

-(BOOL)anchor
{
    return _optionalProperties1.anchor;
}

-(void)setAnchor:(BOOL)anchor
{
    _optionalProperties1.anchor = anchor ? 1 : 0;
}

-(GTUIGravity)overlap
{
    return self.gravity;
}

-(void)setOverlap:(GTUIGravity)overlap
{
    self.anchor = YES;
    self.measure = 0;
    self.gravity = overlap;
}



-(id<GTUIGrid>)addRow:(CGFloat)measure
{
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == GTUISubGridsTypeCol)
    {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }
    
    GTUIGridNode *rowGrid = [[GTUIGridNode alloc] initWithMeasure:measure superGrid:self];
    self.subGridsType = GTUISubGridsTypeRow;
    [self.subGrids addObject:rowGrid];
    return rowGrid;
}

-(id<GTUIGrid>)addCol:(CGFloat)measure
{
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == GTUISubGridsTypeRow)
    {
        NSAssert(0, @"oops! 当前的子格子是行格子，不能再添加列格子。");
    }
    
    GTUIGridNode *colGrid = [[GTUIGridNode alloc] initWithMeasure:measure superGrid:self];
    self.subGridsType = GTUISubGridsTypeCol;
    [self.subGrids addObject:colGrid];
    return colGrid;
}

-(id<GTUIGrid>)addRowGrid:(id<GTUIGrid>)grid
{
    NSAssert(grid.superGrid == nil, @"oops!");
    
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == GTUISubGridsTypeCol)
    {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }
    
    self.subGridsType = GTUISubGridsTypeRow;
    [self.subGrids addObject:(id<GTUIGridNode>)grid];
    ((GTUIGridNode*)grid).superGrid = self;
    return grid;
}

-(id<GTUIGrid>)addColGrid:(id<GTUIGrid>)grid
{
    NSAssert(grid.superGrid == nil, @"oops!");
    
    //如果有子格子，但是第一个子格子不是行则报错误。
    if (self.subGridsType == GTUISubGridsTypeRow)
    {
        NSAssert(0, @"oops! 当前的子格子是列格子，不能再添加行格子。");
    }
    
    self.subGridsType = GTUISubGridsTypeCol;
    [self.subGrids addObject:(id<GTUIGridNode>)grid];
    ((GTUIGridNode*)grid).superGrid = self;
    return grid;
    
}

-(id<GTUIGrid>)addRowGrid:(id<GTUIGrid>)grid measure:(CGFloat)measure
{
    id<GTUIGridNode> gridNode =  (id<GTUIGridNode>)[self addRowGrid:grid];
    gridNode.measure = measure;
    return gridNode;
}

-(id<GTUIGrid>)addColGrid:(id<GTUIGrid>)grid measure:(CGFloat)measure
{
    id<GTUIGridNode> gridNode =  (id<GTUIGridNode>)[self addColGrid:grid];
    gridNode.measure = measure;
    return gridNode;
}



-(id<GTUIGrid>)cloneGrid
{
    GTUIGridNode *grid = [[GTUIGridNode alloc] initWithMeasure:self.measure superGrid:nil];
    //克隆各种属性。
    grid.subGridsType = self.subGridsType;
    grid.placeholder = self.placeholder;
    grid.anchor = self.anchor;
    grid.gravity = self.gravity;
    grid.tag = self.tag;
    grid.actionData = self.actionData;
    if (self->_optionalProperties2 != NULL)
    {
        grid.subviewSpace = self.subviewSpace;
        grid.padding = self.padding;
    }
    
    //拷贝分割线。
    if (self->_borderlineLayerDelegate != nil)
    {
        grid.topBorderline = self.topBorderline;
        grid.bottomBorderline = self.bottomBorderline;
        grid.leadingBorderline = self.leadingBorderline;
        grid.trailingBorderline = self.trailingBorderline;
    }
    
    //拷贝事件处理。
    if (self->_touchEventDelegate != nil)
    {
        [grid setTarget:self->_touchEventDelegate.target action:self->_touchEventDelegate.action];
    }
    
    //克隆子节点。
    if (self.subGridsType != GTUISubGridsTypeUnknown)
    {
        for (GTUIGridNode *subGrid in self.subGrids)
        {
            GTUIGridNode *newsubGrid = (GTUIGridNode*)[subGrid cloneGrid];
            if (self.subGridsType == GTUISubGridsTypeRow)
                [grid addRowGrid:newsubGrid];
            else
                [grid addColGrid:newsubGrid];
        }
    }
    
    return grid;
}


-(void)removeFromSuperGrid
{
    [self.superGrid.subGrids removeObject:self];
    if (self.superGrid.subGrids.count == 0)
    {
        self.superGrid.subGridsType = GTUISubGridsTypeUnknown;
    }
    
    //如果可能销毁高亮层。
    [_touchEventDelegate gtuiResetTouchHighlighted];
    _borderlineLayerDelegate = nil;
    self.superGrid = nil;
}

#pragma mark --  GTUIGridNode

-(NSMutableArray<id<GTUIGridNode>>*)subGrids
{
    if (_subGrids == nil)
    {
        _subGrids = [NSMutableArray new];
    }
    return _subGrids;
}

//格子内子栅格的间距
-(CGFloat)subviewSpace
{
    if (_optionalProperties2 == NULL)
        return 0;
    else
        return _optionalProperties2->subviewSpace;
}

-(void)setSubviewSpace:(CGFloat)subviewSpace
{
    self.optionalProperties2->subviewSpace = subviewSpace;
}

//格子内视图的内边距。
-(UIEdgeInsets)padding
{
    if (_optionalProperties2 == NULL)
        return UIEdgeInsetsZero;
    else
        return _optionalProperties2->padding;
    
}

-(void)setPadding:(UIEdgeInsets)padding
{
    self.optionalProperties2->padding = padding;
}




-(CGFloat)updateGridSize:(CGSize)superSize superGrid:(id<GTUIGridNode>)superGrid withMeasure:(CGFloat)measure
{
    if (superGrid.subGridsType == GTUISubGridsTypeCol)
    {
        _gridRect.size.width = measure;
        _gridRect.size.height = superSize.height;
    }
    else
    {
        _gridRect.size.width = superSize.width;
        _gridRect.size.height = measure;
        
    }
    
    return measure;
}

-(CGFloat)updateGridOrigin:(CGPoint)superOrigin superGrid:(id<GTUIGridNode>)superGrid withOffset:(CGFloat)offset
{
    if (superGrid.subGridsType == GTUISubGridsTypeCol)
    {
        _gridRect.origin.x = offset;
        _gridRect.origin.y = superOrigin.y;
        return _gridRect.size.width;
    }
    else if (superGrid.subGridsType == GTUISubGridsTypeRow)
    {
        _gridRect.origin.x = superOrigin.x;
        _gridRect.origin.y = offset;
        
        return _gridRect.size.height;
    }
    else
    {
        return 0;
    }
    
}


-(UIView*)gridLayoutView
{
    return [[self superGrid] gridLayoutView];
}

-(SEL)gridAction
{
    return _touchEventDelegate.action;
}


-(void)setBorderlineNeedLayoutIn:(CGRect)rect withLayer:(CALayer*)layer
{
    [_borderlineLayerDelegate setNeedsLayoutIn:rect withLayer:layer];
}

-(void)showBorderline:(BOOL)show
{
    _borderlineLayerDelegate.topBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.bottomBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.leadingBorderlineLayer.hidden = !show;
    _borderlineLayerDelegate.trailingBorderlineLayer.hidden = !show;
    
    //销毁高亮。。 按理来说不应该出现在这里的。。。。
    if (!show)
        [_touchEventDelegate gtuiResetTouchHighlighted];
    
    for (GTUIGridNode *subGrid in self.subGrids)
    {
        [subGrid showBorderline:show];
    }
}


-(GTUIBorderline*)topBorderline
{
    return _borderlineLayerDelegate.topBorderline;
}

-(void)setTopBorderline:(GTUIBorderline *)topBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    
    _borderlineLayerDelegate.topBorderline = topBorderline;
}


-(GTUIBorderline*)bottomBorderline
{
    return _borderlineLayerDelegate.bottomBorderline;
}

-(void)setBottomBorderline:(GTUIBorderline *)bottomBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    
    _borderlineLayerDelegate.bottomBorderline = bottomBorderline;
}


-(GTUIBorderline*)leftBorderline
{
    return _borderlineLayerDelegate.leftBorderline;
}

-(void)setLeftBorderline:(GTUIBorderline *)leftBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    
    _borderlineLayerDelegate.leftBorderline = leftBorderline;
}


-(GTUIBorderline*)rightBorderline
{
    return _borderlineLayerDelegate.rightBorderline;
}

-(void)setRightBorderline:(GTUIBorderline *)rightBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    
    _borderlineLayerDelegate.rightBorderline = rightBorderline;
}


-(GTUIBorderline*)leadingBorderline
{
    return _borderlineLayerDelegate.leadingBorderline;
}

-(void)setLeadingBorderline:(GTUIBorderline *)leadingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    
    _borderlineLayerDelegate.leadingBorderline = leadingBorderline;
}



-(GTUIBorderline*)trailingBorderline
{
    return _borderlineLayerDelegate.trailingBorderline;
}

-(void)setTrailingBorderline:(GTUIBorderline *)trailingBorderline
{
    if (_borderlineLayerDelegate == nil)
    {
        _borderlineLayerDelegate = [[GTUIBorderlineLayerDelegate alloc] initWithLayoutLayer:[self gridLayoutView].layer];
    }
    
    _borderlineLayerDelegate.trailingBorderline = trailingBorderline;
}


-(id<GTUIGridNode>)gridHitTest:(CGPoint)point
{
    
    //如果不在范围内点击则直接返回
    if (!CGRectContainsPoint(self.gridRect, point))
        return nil;
    
    
    //优先测试子视图。。然后再自己。。
    NSArray<id<GTUIGridNode>> * subGrids = nil;
    if (self.subGridsType != GTUISubGridsTypeUnknown)
        subGrids = self.subGrids;
    
    
    for (id<GTUIGridNode> sbvGrid in subGrids)
    {
        id<GTUIGridNode> testGrid =  [sbvGrid gridHitTest:point];
        if (testGrid != nil)
            return testGrid;
    }
    
    if (_touchEventDelegate != nil)
        return self;
    
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (GTUIBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (GTUIBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (GTUIBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchEventDelegate != nil && _touchEventDelegate.layout == nil)
    {
        _touchEventDelegate.layout = (GTUIBaseLayout*)[self gridLayoutView];
    }
    [_touchEventDelegate touchesCancelled:touches withEvent:event];
}



////////////////////////////////////////////


+(void)translateGridDicionary:(NSDictionary *)gridDictionary toGridNode:(id<GTUIGridNode>)gridNode
{
    id actionData = [gridDictionary objectForKey:kGTUIGridActionData];
    [self createActionData:actionData gridNode:gridNode];
    
    NSNumber *tag = [gridDictionary objectForKey:kGTUIGridTag];
    [self createTag:tag.integerValue gridNode:gridNode];
    
    NSString *action = [gridDictionary objectForKey:kGTUIGridAction];
    [self createAction:action gridNode:gridNode];
    
    NSString *padding = [gridDictionary objectForKey:kGTUIGridPadding];
    [self createPadding:padding gridNode:gridNode];
    
    NSNumber *space = [gridDictionary objectForKey:kGTUIGridSpace];
    [self createSpace:space.doubleValue gridNode:gridNode];
    
    NSNumber *placeholder = [gridDictionary objectForKey:kGTUIGridPlaceholder];
    [self createPlaceholder:placeholder.boolValue gridNode:gridNode];
    
    NSNumber *anchor = [gridDictionary objectForKey:kGTUIGridAnchor];;
    [self createAnchor:anchor.boolValue gridNode:gridNode];
    
    NSString *overlap = [gridDictionary objectForKey:kGTUIGridOverlap];
    [self createOverlap:overlap gridNode:gridNode];
    
    NSString *gravity = [gridDictionary objectForKey:kGTUIGridGravity];
    [self createGravity:gravity gridNode:gridNode];
    
    NSDictionary *dictionary = [gridDictionary objectForKey:kGTUIGridTopBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:0];
    
    dictionary = [gridDictionary objectForKey:kGTUIGridLeftBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:1];
    
    dictionary = [gridDictionary objectForKey:kGTUIGridBottomBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:2];
    
    dictionary = [gridDictionary objectForKey:kGTUIGridRightBorderline];
    [self createBorderline:dictionary gridNode:gridNode borderline:3];
    
    id tempCols = [gridDictionary objectForKey:kGTUIGridCols];
    [self createCols:tempCols gridNode:gridNode];
    
    id tempRows = [gridDictionary objectForKey:kGTUIGridRows];
    [self createRows:tempRows gridNode:gridNode];
}


/**
 添加行栅格，返回新的栅格。其中的measure可以设置如下的值：
 1.大于等于1的常数，表示固定尺寸。
 2.大于0小于1的常数，表示占用整体尺寸的比例
 3.小于0大于-1的常数，表示占用剩余尺寸的比例
 4.GTUILayoutSize.wrap 表示尺寸由子栅格包裹
 5.GTUILayoutSize.fill 表示占用栅格剩余的尺寸
 */
+(CGFloat)createLayoutSize:(id)gridSize
{
    if ([gridSize isKindOfClass:[NSNumber class]]) {
        return [gridSize doubleValue];
    }else if ([gridSize isKindOfClass:[NSString class]]){
        if ([gridSize isEqualToString:vGTUIGridSizeFill]) {
            return GTUILayoutSize.fill;
        }else if ([gridSize isEqualToString:vGTUIGridSizeWrap]){
            return GTUILayoutSize.wrap;
        }else if ([gridSize hasSuffix:@"%"]){
            
            if ([gridSize isEqualToString:@"100%"] ||
                [gridSize isEqualToString:@"-100%"])return GTUILayoutSize.fill;
            
            return [gridSize doubleValue] / 100.0;
        }
    }
    return GTUILayoutSize.fill;
}

//action-data 数据
+ (void)createActionData:(id)actionData gridNode:(id<GTUIGridNode>)gridNode
{
    if (actionData) {
        gridNode.actionData = actionData;
    }
}

//tag:1
+ (void)createTag:(NSInteger)tag gridNode:(id<GTUIGridNode>)gridNode
{
    if (tag != 0) {
        gridNode.tag = tag;
    }
}

//action
+ (void)createAction:(NSString *)action gridNode:(id<GTUIGridNode>)gridNode
{
    if (action.length > 0) {
        GTUIGridLayout *layout = (GTUIGridLayout *)[gridNode gridLayoutView];
        SEL sel = NSSelectorFromString(action);
        if (layout.gridActionTarget != nil && sel != nil && [layout.gridActionTarget respondsToSelector:sel]) {
            [gridNode setTarget:layout.gridActionTarget action:sel];
        }
    }
}

//padding:"{10,10,10,10}"
+ (void)createPadding:(NSString *)padding gridNode:(id<GTUIGridNode>)gridNode
{
    if (padding.length > 0){
        gridNode.padding = UIEdgeInsetsFromString(padding);
    }
}

//space:10.0
+ (void)createSpace:(CGFloat)space gridNode:(id<GTUIGridNode>)gridNode
{
    if (space != 0.0){
        gridNode.subviewSpace = space;
    }
}

//palceholder:true/false
+ (void)createPlaceholder:(BOOL)placeholder gridNode:(id<GTUIGridNode>)gridNode
{
    if (placeholder) {
        gridNode.placeholder = placeholder;
    }
}

//anchor:true/false
+ (void)createAnchor:(BOOL)anchor gridNode:(id<GTUIGridNode>)gridNode
{
    if (anchor) {
        gridNode.anchor = anchor;
    }
}

//overlap:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)createOverlap:(NSString *)overlap gridNode:(id<GTUIGridNode>)gridNode
{
    GTUIGravity tempGravity = GTUIGravityNone;
    NSArray *array = [overlap componentsSeparatedByString:@"|"];
    for (NSString *temp in array) {
        tempGravity |= [self returnGravity:temp];
    }
    if (tempGravity != GTUIGravityNone){
        gridNode.overlap = tempGravity;
    }
}

//gravity:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)createGravity:(NSString *)gravity gridNode:(id<GTUIGridNode>)gridNode
{
    GTUIGravity tempGravity = GTUIGravityNone;
    NSArray *array = [gravity componentsSeparatedByString:@"|"];
    for (NSString *temp in array) {
        tempGravity |= [self returnGravity:temp];
    }
    
    if (tempGravity != GTUIGravityNone)
        gridNode.gravity = tempGravity;
}

+ (GTUIGravity)returnGravity:(NSString *)gravity
{
    
    if ([gravity rangeOfString:vGTUIGridGravityTop].location != NSNotFound) {
        return  GTUIGravityVertTop;
    }else if ([gravity rangeOfString:vGTUIGridGravityBottom].location != NSNotFound) {
        return GTUIGravityVertBottom;
    }else if ([gravity rangeOfString:vGTUIGridGravityLeft].location != NSNotFound) {
        return GTUIGravityHorzLeft;
    }else if ([gravity rangeOfString:vGTUIGridGravityRight].location != NSNotFound) {
        return GTUIGravityHorzRight;
    }else if ([gravity rangeOfString:vGTUIGridGravityLeading].location != NSNotFound) {
        return GTUIGravityHorzLeading;
    }else if ([gravity rangeOfString:vGTUIGridGravityTrailing].location != NSNotFound) {
        return GTUIGravityHorzTrailing;
    }else if ([gravity rangeOfString:vGTUIGridGravityCenterX].location != NSNotFound) {
        return GTUIGravityHorzCenter;
    }else if ([gravity rangeOfString:vGTUIGridGravityCenterY].location != NSNotFound) {
        return GTUIGravityVertCenter;
    }else if ([gravity rangeOfString:vGTUIGridGravityWidthFill].location != NSNotFound) {
        return GTUIGravityHorzFill;
    }else if ([gravity rangeOfString:vGTUIGridGravityHeightFill].location != NSNotFound) {
        return GTUIGravityVertFill;
    }else{
        return GTUIGravityNone;
    }
}


//{"color":"#AAA",thick:1.0, head:1.0, tail:1.0, offset:1} borderline:{上,左,下,右}
+ (void)createBorderline:(NSDictionary *)dictionary gridNode:(id<GTUIGridNode>)gridNode borderline:(NSInteger)borderline
{
    if (dictionary) {
        GTUIBorderline *line = [GTUIBorderline new];
        NSString *color = [dictionary objectForKey:kGTUIGridBorderlineColor];
        if (color) {
            line.color = [UIColor gtuiColorWithHexString:color];
        }
        line.thick  = [[dictionary objectForKey:kGTUIGridBorderlineThick] doubleValue];
        line.headIndent = [[dictionary objectForKey:kGTUIGridBorderlineHeadIndent] doubleValue];
        line.tailIndent = [[dictionary objectForKey:kGTUIGridBorderlineTailIndent] doubleValue];
        line.offset = [[dictionary objectForKey:kGTUIGridBorderlineOffset] doubleValue];
        line.dash = [[dictionary objectForKey:kGTUIGridBorderlineDash] doubleValue];
        switch (borderline) {
            case 0: gridNode.topBorderline = line; break;
            case 1: gridNode.leftBorderline = line;break;
            case 2: gridNode.bottomBorderline = line;break;
            case 3: gridNode.rightBorderline = line;break;
            default:
                break;
        }
    }
}

//"cols":[{}]
+ (void)createCols:(NSArray<NSDictionary*>*)cols gridNode:(id<GTUIGridNode>)gridNode
{
    for (NSDictionary *dic in cols) {
        NSString *gridSize = [dic objectForKey:kGTUIGridSize];
        CGFloat measure = [self createLayoutSize:gridSize];
        GTUIGridNode *temp = (GTUIGridNode*)[gridNode addCol:measure];
        [self translateGridDicionary:dic toGridNode:temp];
    }
}

//"rows":[{}]
+ (void)createRows:(id)rows gridNode:(id<GTUIGrid>)gridNode
{
    for (NSDictionary *dic in rows) {
        NSString *gridSize = [dic objectForKey:kGTUIGridSize];
        CGFloat measure = [self createLayoutSize:gridSize];
        GTUIGridNode *temp = (GTUIGridNode*)[gridNode addRow:measure];
        [self translateGridDicionary:dic toGridNode:temp];
    }
}


#pragma mark 节点转换字典

/**
 节点转换字典
 
 @param gridNode 节点
 @return 字典
 */
+ (NSDictionary *)translateGridNode:(id<GTUIGridNode>)gridNode toGridDictionary:(NSMutableDictionary *)gridDictionary
{
    if (gridNode == nil) return  nil;
    
    [self returnLayoutSizeWithGridNode:gridNode result:gridDictionary];
    
    [self returnActionDataWithGridNode:gridNode result:gridDictionary];
    
    [self returnTagWithGridNode:gridNode result:gridDictionary];
    
    [self returnActionWithGridNode:gridNode result:gridDictionary];
    
    [self returnPaddingWithGridNode:gridNode result:gridDictionary];
    
    [self returnSpaceWithGridNode:gridNode result:gridDictionary];
    
    [self returnPlaceholderWithGridNode:gridNode result:gridDictionary];
    
    [self returnAnchorWithGridNode:gridNode result:gridDictionary];
    
    [self returnOverlapWithGridNode:gridNode result:gridDictionary];
    
    [self returnGravityWithGridNode:gridNode result:gridDictionary];
    
    [self returnBorderlineWithGridNode:gridNode borderline:0 result:gridDictionary];
    
    [self returnBorderlineWithGridNode:gridNode borderline:1 result:gridDictionary];
    
    [self returnBorderlineWithGridNode:gridNode borderline:2 result:gridDictionary];
    
    [self returnBorderlineWithGridNode:gridNode borderline:3 result:gridDictionary];
    
    [self returnArrayColsRowsGridNode:gridNode result:gridDictionary];
    
    return gridDictionary;
}


/**
 添加行栅格，返回新的栅格。其中的measure可以设置如下的值：
 1.大于等于1的常数，表示固定尺寸。
 2.大于0小于1的常数，表示占用整体尺寸的比例
 3.小于0大于-1的常数，表示占用剩余尺寸的比例
 4.GTUILayoutSize.wrap 表示尺寸由子栅格包裹
 5.GTUILayoutSize.fill 表示占用栅格剩余的尺寸
 */
+ (void)returnLayoutSizeWithGridNode:(id<GTUIGridNode>)gridNode result:(NSMutableDictionary *)result
{
    id value = nil;
    if (gridNode.measure == GTUILayoutSize.wrap) {
        value  = vGTUIGridSizeWrap;
    }else if (gridNode.measure == GTUILayoutSize.fill) {
        value  = vGTUIGridSizeFill;
    }else{
        if (gridNode.measure > 0 && gridNode.measure < 1) {
            value = [NSString stringWithFormat:@"%@%%",(@(gridNode.measure * 100)).stringValue];
        }else if (gridNode.measure > -1 && gridNode.measure < 0) {
            value = [NSString stringWithFormat:@"%@%%",(@(gridNode.measure * 100)).stringValue];
        }else{
            value = [NSNumber numberWithDouble:gridNode.measure];
        }
    }
    [result setObject:value forKey:kGTUIGridSize];
}

//action-data 数据
+ (void)returnActionDataWithGridNode:(id<GTUIGridNode>)gridNode result:(NSMutableDictionary *)result
{
    if (gridNode.actionData) {
        [result setObject:gridNode.actionData forKey:kGTUIGridActionData];
    }
}

//tag:1
+ (void)returnTagWithGridNode:(id<GTUIGridNode>)gridNode result:(NSMutableDictionary *)result
{
    if (gridNode.tag != 0) {
        [result setObject:[NSNumber numberWithInteger:gridNode.tag] forKey:kGTUIGridTag];
    }
}

//action
+ (void)returnActionWithGridNode:(id<GTUIGridNode>)gridNode result:(NSMutableDictionary *)result
{
    SEL action = gridNode.gridAction;
    if (action) {
        [result setObject:NSStringFromSelector(action) forKey:kGTUIGridAction];
    }
}

//padding:"{10,10,10,10}"
+ (void)returnPaddingWithGridNode:(id<GTUIGridNode>)gridNode result:(NSMutableDictionary *)result
{
    NSString *temp = NSStringFromUIEdgeInsets(gridNode.padding);
    if (temp && ![temp isEqualToString:@"{0, 0, 0, 0}"]) {
        [result setObject:temp forKey:kGTUIGridPadding];
    }
}



//space:10.0
+ (void)returnSpaceWithGridNode:(id<GTUIGridNode>)gridNode result:(NSMutableDictionary *)result
{
    if (gridNode.subviewSpace != 0.0) {
        [result setObject:[NSNumber numberWithDouble:gridNode.subviewSpace] forKey:kGTUIGridSpace];
    }
}

//palceholder:true/false
+ (void)returnPlaceholderWithGridNode:(id<GTUIGridNode>)gridNode result:(NSMutableDictionary *)result
{
    if (gridNode.placeholder) {
        [result setObject:[NSNumber numberWithBool:gridNode.placeholder] forKey:kGTUIGridPlaceholder];
    }
}

//anchor:true/false
+ (void)returnAnchorWithGridNode:(id<GTUIGridNode>)gridNode result:(NSMutableDictionary *)result
{
    if (gridNode.anchor) {
        [result setObject:[NSNumber numberWithBool:gridNode.anchor] forKey:kGTUIGridAnchor];
    }
}

//overlap:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)returnOverlapWithGridNode:(id<GTUIGridNode>)gridNode result:(NSMutableDictionary *)result
{
    GTUIGravity gravity = gridNode.overlap;
    if (gravity != GTUIGravityNone)
    {
        static NSDictionary *data = nil;
        if (data == nil)
        {
            data = @{
                     [NSNumber numberWithUnsignedShort:GTUIGravityVertTop]:vGTUIGridGravityTop,
                     [NSNumber numberWithUnsignedShort:GTUIGravityVertBottom]:vGTUIGridGravityBottom,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzLeft]:vGTUIGridGravityLeft,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzRight]:vGTUIGridGravityRight,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzLeading]:vGTUIGridGravityLeading,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzTrailing]:vGTUIGridGravityTrailing,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzCenter]:vGTUIGridGravityCenterX,
                     [NSNumber numberWithUnsignedShort:GTUIGravityVertCenter]:vGTUIGridGravityCenterY,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzFill]:vGTUIGridGravityWidthFill,
                     [NSNumber numberWithUnsignedShort:GTUIGravityVertFill]:vGTUIGridGravityHeightFill
                     };
        }
        
        NSMutableArray *gravitystrs = [NSMutableArray new];
        GTUIGravity horzGravity = gravity & GTUIGravityVertMask;
        NSString *horzstr = data[@(horzGravity)];
        if (horzstr != nil)
            [gravitystrs addObject:horzstr];
        
        GTUIGravity vertGravity = gravity & GTUIGravityHorzMask;
        NSString *vertstr = data[@(vertGravity)];
        if (vertstr != nil)
            [gravitystrs addObject:vertstr];
        
        NSString *temp = [gravitystrs componentsJoinedByString:@"|"];
        if (temp.length) {
            [result setObject:temp forKey:kGTUIGridOverlap];
        }
    }
}

//gravity:@"top|bottom|left|right|centerX|centerY|width|height"
+ (void)returnGravityWithGridNode:(id<GTUIGridNode>)gridNode result:(NSMutableDictionary *)result
{
    GTUIGravity gravity = gridNode.gravity;
    if (gravity != GTUIGravityNone)
    {
        static NSDictionary *data = nil;
        if (data == nil)
        {
            data = @{
                     [NSNumber numberWithUnsignedShort:GTUIGravityVertTop]:vGTUIGridGravityTop,
                     [NSNumber numberWithUnsignedShort:GTUIGravityVertBottom]:vGTUIGridGravityBottom,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzLeft]:vGTUIGridGravityLeft,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzRight]:vGTUIGridGravityRight,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzLeading]:vGTUIGridGravityLeading,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzTrailing]:vGTUIGridGravityTrailing,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzCenter]:vGTUIGridGravityCenterX,
                     [NSNumber numberWithUnsignedShort:GTUIGravityVertCenter]:vGTUIGridGravityCenterY,
                     [NSNumber numberWithUnsignedShort:GTUIGravityHorzFill]:vGTUIGridGravityWidthFill,
                     [NSNumber numberWithUnsignedShort:GTUIGravityVertFill]:vGTUIGridGravityHeightFill
                     };
        }
        
        NSMutableArray *gravitystrs = [NSMutableArray new];
        GTUIGravity horzGravity = gravity & GTUIGravityVertMask;
        NSString *horzstr = data[@(horzGravity)];
        if (horzstr != nil)
            [gravitystrs addObject:horzstr];
        
        GTUIGravity vertGravity = gravity & GTUIGravityHorzMask;
        NSString *vertstr = data[@(vertGravity)];
        if (vertstr != nil)
            [gravitystrs addObject:vertstr];
        
        NSString *temp = [gravitystrs componentsJoinedByString:@"|"];
        if (temp.length) {
            [result setObject:temp forKey:kGTUIGridGravity];
        }
    }
}



//{"color":"#AAA",thick:1.0, head:1.0, tail:1.0, offset:1} borderline:{上,左,下,右}
+ (void)returnBorderlineWithGridNode:(id<GTUIGridNode>)gridNode borderline:(NSInteger)borderline result:(NSMutableDictionary *)result
{
    NSString *key = nil;
    GTUIBorderline *line = nil;
    switch (borderline) {
        case 0: key = kGTUIGridTopBorderline;line = gridNode.topBorderline; break;
        case 1: key = kGTUIGridLeftBorderline;line = gridNode.leftBorderline;break;
        case 2: key = kGTUIGridBottomBorderline;line = gridNode.bottomBorderline;break;
        case 3: key = kGTUIGridRightBorderline;line = gridNode.rightBorderline;break;
        default:
            break;
    }
    if (line) {
        NSMutableDictionary *dictionary =  [NSMutableDictionary new];
        if (line.color) {
            [dictionary setObject:[line.color gtuiHexString] forKey:kGTUIGridBorderlineColor];
        }
        if (line.thick != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.thick] forKey:kGTUIGridBorderlineThick];
        }
        if (line.headIndent != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.headIndent] forKey:kGTUIGridBorderlineHeadIndent];
        }
        if (line.tailIndent != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.tailIndent] forKey:kGTUIGridBorderlineTailIndent];
        }
        if (line.offset != 0) {
            [dictionary setObject:[NSNumber numberWithDouble:line.offset] forKey:kGTUIGridBorderlineOffset];
        }
        if (line.dash != 0){
            [dictionary setObject:[NSNumber numberWithDouble:line.offset] forKey:kGTUIGridBorderlineDash];
        }
        [result setObject:dictionary forKey:key];
    }
}

//"cols":[{}] "rows":[{}]
+ (void)returnArrayColsRowsGridNode:(id<GTUIGridNode>)gridNode result:(NSMutableDictionary *)result
{
    GTUISubGridsType subGridsType = gridNode.subGridsType;
    if (subGridsType != GTUISubGridsTypeUnknown) {
        NSMutableArray<NSDictionary *> *temp = [NSMutableArray<NSDictionary *> arrayWithCapacity:gridNode.subGrids.count];
        NSString *key = nil;
        switch (subGridsType) {
            case GTUISubGridsTypeCol:
            {
                key = kGTUIGridCols;
                break;
            }
            case GTUISubGridsTypeRow:
            {
                key = kGTUIGridRows;
                break;
            }
            default:
                break;
        }
        for (id<GTUIGridNode> node  in gridNode.subGrids) {
            [temp addObject:[self translateGridNode:node toGridDictionary:[NSMutableDictionary new]]];
        }
        
        if (key) {
            [result setObject:temp forKey:key];
        }
        
    }
}



@end


@implementation UIColor (GTUIGrid)

static NSDictionary*  gtuiDefaultColors()
{
    static NSDictionary *colors = nil;
    if (colors == nil)
    {
        colors = @{
                   @"black":UIColor.blackColor,
                   @"darkgray":UIColor.darkGrayColor,
                   @"lightgray":UIColor.lightGrayColor,
                   @"white":UIColor.whiteColor,
                   @"gray":UIColor.grayColor,
                   @"red":UIColor.redColor,
                   @"green":UIColor.greenColor,
                   @"cyan":UIColor.cyanColor,
                   @"yellow":UIColor.yellowColor,
                   @"magenta":UIColor.magentaColor,
                   @"orange":UIColor.orangeColor,
                   @"purple":UIColor.purpleColor,
                   @"brown":UIColor.brownColor,
                   @"clear":UIColor.clearColor
                   };
    }
    
    return colors;
}


+ (UIColor *)gtuiColorWithHexString:(NSString *)hexString
{
    if (hexString.length == 0)
        return nil;
    
    //判断是否以#开头,如果不是则直接读取具体的颜色值。
    if ([hexString characterAtIndex:0] != '#')
    {
        return [gtuiDefaultColors() objectForKey:hexString.lowercaseString];
    }
    
    if (hexString.length != 7 && hexString.length != 9)
        return nil;
    
    NSScanner *scanner = [NSScanner scannerWithString:[hexString substringFromIndex:1]];
    unsigned int val = 0;
    [scanner scanHexInt:&val];
    
    unsigned char blue  = val & 0xFF;
    unsigned char green = (val >> 8) & 0xFF;
    unsigned char red = (val >> 16) & 0xFF;
    unsigned char alpha = hexString.length == 7 ? 0xFF : (val >> 24) & 0xFF;
    
    return [[UIColor alloc ] initWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
}


- (NSString *)gtuiHexString {
    
    CGFloat red = 0, green = 0, blue = 0, alpha = 1;
    
    if (![self getRed:&red green:&green blue:&blue alpha:&alpha])
        return nil;
    
    if (alpha != 1)
    {
        return [NSString stringWithFormat:@"#%02X%02X%02X%02X", (int)(red * 255), (int)(green * 255), (int)(blue * 255), (int)(alpha * 255)];
    }
    else
    {
        return [NSString stringWithFormat:@"#%02X%02X%02X", (int)(red * 255), (int)(green * 255), (int)(blue * 255)];
    }
}

@end
