//
//  GTUIEmptyBaseView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "GTUIEmptyBaseView.h"
#import "GTUIMetrics.h"

@implementation GTUIEmptyBaseView

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.autoShowEmptyView = YES;//默认自动显隐

        [self prepare];
    }
    return self;
}

- (void)prepare{

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIView *view = self.superview;
    //不是UIScrollView，不做操作
    if (view && [view isKindOfClass:[UIView class]]){
        self.width = view.width;
        self.height = view.height;
    }

    [self setupSubviews];
}

- (void)setupSubviews{
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];

    //不是UIScrollView，不做操作
    if (newSuperview && ![newSuperview isKindOfClass:[UIView class]]) return;

    if (newSuperview) {
        self.width = newSuperview.width;
        self.height = newSuperview.height;
    }
}

#pragma mark - 实例化

+ (instancetype)emptyActionViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr btnTitleStr:(NSString *)btnTitleStr target:(id)target action:(SEL)action{

    GTUIEmptyBaseView *emptyView = [[self alloc] init];

    [emptyView creatEmptyViewWithImage:nil imageStr:imageStr titleStr:titleStr detailStr:detailStr btnTitleStr:btnTitleStr target:target action:action];

    return emptyView;
}
+ (instancetype)emptyActionViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr btnTitleStr:(NSString *)btnTitleStr btnClickBlock:(GTUIActionTapBlock)btnClickBlock{

    GTUIEmptyBaseView *emptyView = [[self alloc] init];

    [emptyView creatEmptyViewWithImage:nil imageStr:imageStr titleStr:titleStr detailStr:detailStr btnTitleStr:btnTitleStr btnClickBlock:btnClickBlock];

    return emptyView;
}
+ (instancetype)emptyViewWithImageStr:(NSString *)imageStr titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr{

    GTUIEmptyBaseView *emptyView = [[self alloc] init];

    [emptyView creatEmptyViewWithImage:nil imageStr:imageStr titleStr:titleStr detailStr:detailStr btnTitleStr:nil btnClickBlock:nil];

    return emptyView;
}



/**
 构造方法4 - 创建emptyView

 @param image       image图片对象
 @param titleStr    标题
 @param detailStr   详细描述
 @param btnTitleStr 按钮的名称
 @param target      响应的对象
 @param action      按钮点击事件
 @return 返回一个emptyView
 */
+ (instancetype)emptyActionViewWithImage:(UIImage *)image
                                titleStr:(NSString *)titleStr
                               detailStr:(NSString *)detailStr
                             btnTitleStr:(NSString *)btnTitleStr
                                  target:(id)target
                                  action:(SEL)action {

    GTUIEmptyBaseView *emptyView = [[self alloc] init];

    [emptyView creatEmptyViewWithImage:image imageStr:nil titleStr:titleStr detailStr:detailStr btnTitleStr:btnTitleStr target:target action:action];

    return emptyView;
}

+ (instancetype)emptyActionViewWithImage:(UIImage *)image
                                titleStr:(NSString *)titleStr
                               detailStr:(NSString *)detailStr
                             btnTitleStr:(NSString *)btnTitleStr
                           btnClickBlock:(GTUIActionTapBlock)btnClickBlock {

    GTUIEmptyBaseView *emptyView = [[self alloc] init];

    [emptyView creatEmptyViewWithImage:image imageStr:nil titleStr:titleStr detailStr:detailStr btnTitleStr:btnTitleStr btnClickBlock:btnClickBlock];

    return emptyView;
}

+ (instancetype)emptyViewWithCustomView:(UIView *)customView{

    GTUIEmptyBaseView *emptyView = [[self alloc] init];

    [emptyView creatEmptyViewWithCustomView:customView];

    return emptyView;
}


- (void)creatEmptyViewWithImage:(UIImage *)image imageStr:(NSString *)imageStr titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr btnTitleStr:(NSString *)btnTitleStr target:(id)target action:(SEL)action{

    _image = image;
    _imageStr = imageStr;
    _titleStr = titleStr;
    _detailStr = detailStr;
    _btnTitleStr = btnTitleStr;
    _actionBtnTarget = target;
    _actionBtnAction = action;

    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
        [_contentView addGestureRecognizer:tap];
    }
}

- (void)creatEmptyViewWithImage:(UIImage *)image imageStr:(NSString *)imageStr titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr btnTitleStr:(NSString *)btnTitleStr btnClickBlock:(GTUIActionTapBlock)btnClickBlock{

    _image = image;
    _imageStr = imageStr;
    _titleStr = titleStr;
    _detailStr = detailStr;
    _btnTitleStr = btnTitleStr;
    _btnClickBlock = btnClickBlock;

    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
        [_contentView addGestureRecognizer:tap];
    }
}
- (void)creatEmptyViewWithCustomView:(UIView *)customView{

    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
    }

    if (!_customView) {
        [_contentView addSubview:customView];
    }
    _customView = customView;
}

#pragma mark - Setter

-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    [self layoutSubviews];
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self layoutSubviews];
}
- (void)setDetailStr:(NSString *)detailStr{
    _detailStr = detailStr;
    [self layoutSubviews];
}
- (void)setBtnTitleStr:(NSString *)btnTitleStr{
    _btnTitleStr = btnTitleStr;
    [self layoutSubviews];
}
- (void)tapContentView:(UITapGestureRecognizer *)tap{
    if (_tapContentViewBlock) {
        _tapContentViewBlock();
    }
}

@end
