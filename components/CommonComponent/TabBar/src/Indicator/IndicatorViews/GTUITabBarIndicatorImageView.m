//
//  GTUITabBarIndicatorImageView.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarIndicatorImageView.h"
#import "GTUITabBarFactory.h"

@implementation GTUITabBarIndicatorImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _indicatorImageViewSize = CGSizeMake(30, 20);
        _indicatorImageViewRollEnabled = NO;
        
        _indicatorImageView = [[UIImageView alloc] init];
        self.indicatorImageView.frame = CGRectMake(0, 0, self.indicatorImageViewSize.width, self.indicatorImageViewSize.height);
        self.indicatorImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.indicatorImageView];
    }
    return self;
}

- (void)setIndicatorImageViewSize:(CGSize)indicatorImageViewSize {
    _indicatorImageViewSize = indicatorImageViewSize;
    
    self.indicatorImageView.frame = CGRectMake(0, 0, self.indicatorImageViewSize.width, self.indicatorImageViewSize.height);
}

#pragma mark - GTUITabBarComponentProtocol

- (void)refreshState:(CGRect)selectedCellFrame {
    CGFloat x = selectedCellFrame.origin.x + (selectedCellFrame.size.width - self.indicatorImageViewSize.width)/2;
    CGFloat y = self.superview.bounds.size.height - self.indicatorImageViewSize.height - self.verticalMargin;
    if (self.componentPosition == GTUITabBarComponentPositionTop) {
        y = self.verticalMargin;
    }
    self.frame = CGRectMake(x, y, self.indicatorImageViewSize.width, self.indicatorImageViewSize.height);
}

- (void)contentScrollViewDidScrollWithLeftCellFrame:(CGRect)leftCellFrame rightCellFrame:(CGRect)rightCellFrame selectedPosition:(GTUITabBarCellClickedPosition)selectedPosition percent:(CGFloat)percent {
    
    CGFloat targetWidth = self.indicatorImageViewSize.width;
    CGFloat targetX = 0;
    
    if (percent == 0) {
        targetX = leftCellFrame.origin.x + (leftCellFrame.size.width - targetWidth)/2.0;
    }else {
        CGFloat leftX = leftCellFrame.origin.x + (leftCellFrame.size.width - targetWidth)/2;
        CGFloat rightX = rightCellFrame.origin.x + (rightCellFrame.size.width - targetWidth)/2;
        targetX = [GTUITabBarFactory interpolationFrom:leftX to:rightX percent:percent];
    }
    
    //允许变动frame的情况：1、允许滚动；2、不允许滚动，但是已经通过手势滚动切换一页内容了；
    if (self.scrollEnabled == YES || (self.scrollEnabled == NO && percent == 0)) {
        CGRect frame = self.frame;
        frame.origin.x = targetX;
        self.frame = frame;
        
        if (self.indicatorImageViewRollEnabled) {
            self.indicatorImageView.transform = CGAffineTransformMakeRotation(M_PI*2*percent);
        }
    }
}

- (void)selectedCell:(CGRect)cellFrame clickedRelativePosition:(GTUITabBarCellClickedPosition)clickedRelativePosition isClicked:(BOOL)isClicked {
    CGRect toFrame = self.frame;
    toFrame.origin.x = cellFrame.origin.x + (cellFrame.size.width - self.indicatorImageViewSize.width)/2;
    if (self.scrollEnabled) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.frame = toFrame;
        } completion:^(BOOL finished) {
        }];
        if (self.indicatorImageViewRollEnabled && isClicked) {
            CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotateAnimation.toValue = @(M_PI*2*((clickedRelativePosition == GTUITabBarCellClickedPositionLeft) ? -1 : 1));
            rotateAnimation.duration = 0.25;
            [self.indicatorImageView.layer addAnimation:rotateAnimation forKey:@"rotate"];
        }
    }else {
        self.frame = toFrame;
    }
}

@end
