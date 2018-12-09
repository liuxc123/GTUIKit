//
//  GTUITabBarTitleCell.m
//  GTCatalog
//
//  Created by liuxc on 2018/12/9.
//

#import "GTUITabBarTitleCell.h"
#import "GTUITabBarTitleCellModel.h"

@interface GTUITabBarTitleCell ()
@property (nonatomic, strong) CALayer *maskLayer;

@end

@implementation GTUITabBarTitleCell

- (void)initializeViews
{
    [super initializeViews];
    
    _titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    _maskTitleLabel = [[UILabel alloc] init];
    _maskTitleLabel.hidden = YES;
    self.maskTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.maskTitleLabel];
    
    _maskLayer = [CALayer layer];
    self.maskLayer.backgroundColor = [UIColor redColor].CGColor;
    self.maskTitleLabel.layer.mask = self.maskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.center = self.contentView.center;
    self.maskTitleLabel.center = self.contentView.center;
}

- (void)reloadData:(GTUITabBarBaseCellModel *)cellModel {
    [super reloadData:cellModel];
    
    GTUITabBarTitleCellModel *myCellModel = (GTUITabBarTitleCellModel *)cellModel;
    
    CGFloat pointSize = myCellModel.titleFont.pointSize;
    UIFontDescriptor *fontDescriptor = myCellModel.titleFont.fontDescriptor;
    
    if (myCellModel.selected) {
        fontDescriptor = myCellModel.titleSelectedFont.fontDescriptor;
        pointSize = myCellModel.titleSelectedFont.pointSize;
    }
    if (myCellModel.titleLabelZoomEnabled) {
        self.titleLabel.font = [UIFont fontWithDescriptor:fontDescriptor size:pointSize*myCellModel.titleLabelZoomScale];
        self.maskTitleLabel.font = [UIFont fontWithDescriptor:fontDescriptor size:pointSize*myCellModel.titleLabelZoomScale];
    }else {
        self.titleLabel.font = [UIFont fontWithDescriptor:fontDescriptor size:pointSize];
        self.maskTitleLabel.font = [UIFont fontWithDescriptor:fontDescriptor size:pointSize];
    }
    
    NSString *titleString = myCellModel.title ? myCellModel.title : @"";
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:titleString];
    if (myCellModel.titleLabelStrokeWidthEnabled) {
        [attriString addAttribute:NSStrokeWidthAttributeName value:@(myCellModel.titleLabelSelectedStrokeWidth) range:NSMakeRange(0, myCellModel.title.length)];
    }
    
    self.maskTitleLabel.hidden = !myCellModel.titleLabelMaskEnabled;
    if (myCellModel.titleLabelMaskEnabled) {
        self.titleLabel.textColor = myCellModel.titleColor;
        self.maskTitleLabel.font = myCellModel.titleFont;
        self.maskTitleLabel.textColor = myCellModel.titleSelectedColor;
        
        self.maskTitleLabel.attributedText = attriString;
        [self.maskTitleLabel sizeToFit];
        
        CGRect frame = myCellModel.backgroundViewMaskFrame;
        frame.origin.x -= (self.contentView.bounds.size.width - self.maskTitleLabel.bounds.size.width)/2;
        frame.origin.y = 0;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.maskLayer.frame = frame;
        [CATransaction commit];
    }else {
        if (myCellModel.selected) {
            self.titleLabel.textColor = myCellModel.titleSelectedColor;
        }else {
            self.titleLabel.textColor = myCellModel.titleColor;
        }
    }
    
    self.titleLabel.attributedText = attriString;
    [self.titleLabel sizeToFit];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
