//
//  GTUIDoubleTitleView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUIDoubleTitleView.h"

@interface GTUIDoubleTitleView ()

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *detailTitleLabel;

@end

@implementation GTUIDoubleTitleView

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInitWithSubviews];
    }
    return self;
}

- (UIView *)initWithTitle:(NSString *)title detailTitle:(NSString *)detaileTitle
{
    self = [super init];
    if (self) {
        self.titleLabel.text = title;
        self.detailTitleLabel.text = detaileTitle;
        [self commonInitWithSubviews];
    }
    return self;
}

- (void)commonInitWithSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailTitleLabel];
    [self layoutSubviews];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    [self.detailTitleLabel sizeToFit];
    CGFloat width = MAX(CGRectGetWidth(self.titleLabel.bounds), CGRectGetWidth(self.detailTitleLabel.bounds));
    CGFloat height = CGRectGetHeight(self.titleLabel.bounds) + CGRectGetHeight(self.detailTitleLabel.bounds);
    self.titleLabel.frame =CGRectMake(0, 0, width, CGRectGetHeight(self.titleLabel.bounds));
    self.detailTitleLabel.frame = CGRectMake(0, CGRectGetHeight(self.titleLabel.bounds), width, CGRectGetHeight(self.detailTitleLabel.bounds));
    self.bounds = CGRectMake(0, 0, width, height);
}

#pragma mark - Public

- (void)updateTitle:(NSString *)title {
    self.titleLabel.text = title;
    [self layoutSubviews];
}

- (void)updateTitleFont:(UIFont *)titleFont {
    self.titleLabel.font = titleFont;
    [self layoutSubviews];
}

- (void)updateDetailTitle:(NSString *)detailTitle {
    self.detailTitleLabel.text = detailTitle;
    [self layoutSubviews];
}

- (void)updateDetailTitleFont:(UIFont *)detailTitleFont {
    self.detailTitleLabel.font = detailTitleFont;
    [self layoutSubviews];
}


#pragma mark - set/get

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = UIColor.blackColor;
    }
    return _titleLabel;
}

- (UILabel *)detailTitleLabel {
    if (!_detailTitleLabel) {
        _detailTitleLabel = [[UILabel alloc] init];
        _detailTitleLabel.textAlignment = NSTextAlignmentCenter;
        _detailTitleLabel.font = [UIFont systemFontOfSize:10];
        _detailTitleLabel.textColor = UIColor.lightGrayColor;
    }
    return _detailTitleLabel;
}


@end
