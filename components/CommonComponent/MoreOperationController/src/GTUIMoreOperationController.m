//
//  GTUIMoreOperationController.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/11.
//

#import "GTUIMoreOperationController.h"

#define TagOffset 999

@implementation GTUIMoreOperationController (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self appearance];
    });
}

static GTUIMoreOperationController *moreOperationViewControllerAppearance;
+ (instancetype)appearance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self resetAppearance];
    });
    return moreOperationViewControllerAppearance;
}

+ (void)resetAppearance {
    if (!moreOperationViewControllerAppearance) {
        moreOperationViewControllerAppearance = [[GTUIMoreOperationController alloc] init];
        moreOperationViewControllerAppearance.contentBackgroundColor = [UIColor whiteColor];
        moreOperationViewControllerAppearance.contentSeparatorColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.15f];
        moreOperationViewControllerAppearance.cancelButtonBackgroundColor = [UIColor whiteColor];
        moreOperationViewControllerAppearance.cancelButtonTitleColor = [UIColor whiteColor];;
        moreOperationViewControllerAppearance.cancelButtonSeparatorColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.15f];
        moreOperationViewControllerAppearance.itemBackgroundColor = [UIColor clearColor];
        moreOperationViewControllerAppearance.itemTitleColor = [UIColor darkGrayColor];
        moreOperationViewControllerAppearance.itemTitleFont = [UIFont systemFontOfSize:17];
        moreOperationViewControllerAppearance.cancelButtonFont = [UIFont boldSystemFontOfSize:17];
        moreOperationViewControllerAppearance.contentEdgeMargin = 10;
        moreOperationViewControllerAppearance.contentMaximumWidth = [UIScreen mainScreen].bounds.size.width - moreOperationViewControllerAppearance.contentEdgeMargin * 2;
        moreOperationViewControllerAppearance.contentCornerRadius = 10;
        moreOperationViewControllerAppearance.itemTitleMarginTop = 9;
        moreOperationViewControllerAppearance.topScrollViewInsets = UIEdgeInsetsMake(18, 14, 12, 14);
        moreOperationViewControllerAppearance.bottomScrollViewInsets = UIEdgeInsetsMake(18, 14, 12, 14);
        moreOperationViewControllerAppearance.cancelButtonHeight = 52.0;
        moreOperationViewControllerAppearance.cancelButtonMarginTop = 0;
    }
}

@end

@interface GTUIMoreOperationItemView ()

@property (nonatomic, assign, readwrite) GTUIMoreOperationItemType itemType;

@end

@implementation GTUIMoreOperationItemView {
    NSInteger _tag;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageLocation = GTUIButtonImageLocationTop;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.imageView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
}

- (void)setTag:(NSInteger)tag {
    _tag = tag + TagOffset;
    [super setTag:_tag];
}

- (NSInteger)tag {
    return _tag - TagOffset;
}

@end

@interface GTUIMoreOperationController ()


@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIControl *maskView;
@property(nonatomic, strong) UIScrollView *importantItemsScrollView;
@property(nonatomic, strong) UIScrollView *normalItemsScrollView;

@property(nonatomic, strong) CALayer *scrollViewDividingLayer;
@property(nonatomic, strong) CALayer *cancelButtonDividingLayer;

@property(nonatomic, strong) NSMutableArray *importantItems;
@property(nonatomic, strong) NSMutableArray *normalItems;
@property(nonatomic, strong) NSMutableArray *importantShowingItems;
@property(nonatomic, strong) NSMutableArray *normalShowingItems;

@property(nonatomic, assign, readwrite) BOOL showing;
@property(nonatomic, assign, readwrite) BOOL animating;

@end

@implementation GTUIMoreOperationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self didInitialized];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialized];
    }
    return self;
}

- (void)didInitialized {
    if (moreOperationViewControllerAppearance) {
        self.contentBackgroundColor = [GTUIMoreOperationController appearance].contentBackgroundColor;
        self.contentSeparatorColor = [GTUIMoreOperationController appearance].contentSeparatorColor;
        self.cancelButtonBackgroundColor = [GTUIMoreOperationController appearance].cancelButtonBackgroundColor;
        self.cancelButtonTitleColor = [GTUIMoreOperationController appearance].cancelButtonTitleColor;
        self.cancelButtonSeparatorColor = [GTUIMoreOperationController appearance].cancelButtonSeparatorColor;
        self.itemBackgroundColor = [GTUIMoreOperationController appearance].itemBackgroundColor;
        self.itemTitleColor = [GTUIMoreOperationController appearance].itemTitleColor;
        self.itemTitleFont = [GTUIMoreOperationController appearance].itemTitleFont;
        self.cancelButtonFont = [GTUIMoreOperationController appearance].cancelButtonFont;
        self.contentEdgeMargin = [GTUIMoreOperationController appearance].contentEdgeMargin;
        self.contentMaximumWidth = [GTUIMoreOperationController appearance].contentMaximumWidth;
        self.contentCornerRadius = [GTUIMoreOperationController appearance].contentCornerRadius;
        self.itemTitleMarginTop = [GTUIMoreOperationController appearance].itemTitleMarginTop;
        self.topScrollViewInsets = [GTUIMoreOperationController appearance].topScrollViewInsets;
        self.bottomScrollViewInsets = [GTUIMoreOperationController appearance].bottomScrollViewInsets;
        self.cancelButtonHeight = [GTUIMoreOperationController appearance].cancelButtonHeight;
        self.cancelButtonMarginTop = [GTUIMoreOperationController appearance].cancelButtonMarginTop;
    }
    self.importantItems = [[NSMutableArray alloc] init];
    self.normalItems = [[NSMutableArray alloc] init];
    self.importantShowingItems = [[NSMutableArray alloc] init];
    self.normalShowingItems = [[NSMutableArray alloc] init];

//[self initSubviewsIfNeeded];
}



@end
