//
//  GTUIFormRowNavigationAccessoryView.m
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import "GTUIFormRowNavigationAccessoryView.h"

@interface GTUIFormRowNavigationAccessoryView ()

@property (nonatomic) UIBarButtonItem *fixedSpace;
@property (nonatomic) UIBarButtonItem *flexibleSpace;

@end

@implementation GTUIFormRowNavigationAccessoryView


@synthesize previousButton = _previousButton;
@synthesize nextButton = _nextButton;
@synthesize doneButton = _doneButton;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.0)];
    if (self) {
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth);
        NSArray * items = [NSArray arrayWithObjects:self.previousButton,
                           self.fixedSpace,
                           self.nextButton,
                           self.flexibleSpace,
                           self.doneButton, nil];
        [self setItems:items];
    }
    return self;
}

#pragma mark - Properties

-(UIBarButtonItem *)previousButton
{
    if (_previousButton) return _previousButton;
    _previousButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:nil action:nil];
    return _previousButton;
}

-(UIBarButtonItem *)fixedSpace
{
    if (_fixedSpace) return _fixedSpace;
    _fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    _fixedSpace.width = 22.0;
    return _fixedSpace;
}

-(UIBarButtonItem *)nextButton
{
    if (_nextButton) return _nextButton;
    _nextButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:nil action:nil];
    return _nextButton;
}

-(UIBarButtonItem *)flexibleSpace
{
    if (_flexibleSpace) return _flexibleSpace;
    _flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    return _flexibleSpace;
}

-(UIBarButtonItem *)doneButton
{
    if (_doneButton) return _doneButton;
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    return _doneButton;
}

#pragma mark - Helpers

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event
{
}


@end
