//
//  GTUILoadingView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "GTUILoadingView.h"
#import "private/UIImage+GTGIF.h"
#import "GTUIMetrics.h"

//每个子控件之间的间距
#define kSubViewMargin 20.f

//描述字体
#define kTitleLabFont [UIFont systemFontOfSize:16.f]

//详细描述字体
#define kDetailLabFont [UIFont systemFontOfSize:14.f]

//按钮字体大小
#define kActionBtnFont  [UIFont systemFontOfSize:14.f]
//按钮高度
#define kActionBtnHeight 40.f
//水平方向内边距
#define kActionBtnHorizontalMargin 30.f

//黑色
#define kBlackColor [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.f]
//灰色
#define kGrayColor [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.f]

@interface GTUILoadingView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView      *indicatorView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIView      *customV;

@end

@implementation GTUILoadingView
{
    CGFloat contentMaxWidth; //最大宽度
    CGFloat contentWidth;    //内容物宽度
    CGFloat contentHeight;   //内容物高度
    CGFloat subViweMargin;   //间距
}

- (void)prepare{
    [super prepare];
    self.contentViewY = 1000;//默认值,用来判断是否设置过content的Y值
}

- (void)setupSubviews {
    [super setupSubviews];

    contentMaxWidth = self.width - 30.f; //最大宽度（ScrollView 的宽 - 30）
    contentWidth = 0;//内容物宽度
    contentHeight = 0;//内容物高度
    subViweMargin = self.subViewMargin ? self.subViewMargin : kSubViewMargin;

    NSMutableArray<UIImage *> *imageArray = [NSMutableArray array];

    if (self.imageStr != nil && ![self.imageStr isEqualToString:@""]) {
        [imageArray addObject:[UIImage gt_imageNamed:self.imageStr]];
    }

    if (self.gifImageData != nil) {
        [imageArray addObject:[UIImage gt_animatedImageWithAnimatedGIFData:self.gifImageData]];
    }

    if (self.imageStrArray != nil && self.imageStrArray.count > 0) {
        for (NSString *imageStr in self.imageStrArray) {
            UIImage *image = [UIImage gt_imageNamed:imageStr];
            [imageArray addObject:image];
        }
    }

    //占位图片
    if (imageArray.count > 0) {
        [self setupImageView:imageArray];
    }else{
        if (_imageView) {
            [_imageView stopAnimating];
            [_imageView removeFromSuperview];
        }
    }

    //loading 底部控件
    if (_imageView != nil) {
        [self setupIndicatorView];
    } else {
        if (_indicatorView) {
            [_indicatorView removeFromSuperview];
        }
    }


    //标题
    if (self.titleStr.length) {
        [self setupTitleLabel:self.titleStr];
    }else{
        if (_titleLabel) {
            [_titleLabel removeFromSuperview];
        }
    }


    //自定义view
    if (self.customView) {
        contentWidth = self.customView.width;
        contentHeight = self.customView.bottom;
    }

    ///设置frame
    [self setSubViewFrame];
}

- (void)setSubViewFrame{

    //获取self原始宽高
    CGFloat scrollViewWidth = self.bounds.size.width;
    CGFloat scrollViewHeight = self.bounds.size.height;

    //重新设置self的frame（大小为content的大小）
    self.size = CGSizeMake(contentWidth, contentHeight);
    CGFloat emptyViewCenterX = scrollViewWidth * 0.5f;
    CGFloat emptyViewCenterY = scrollViewHeight * 0.5f;
    self.center = CGPointMake(emptyViewCenterX, emptyViewCenterY);

    //设置contentView
    self.contentView.frame = self.bounds;

    //子控件的centerX设置
    CGFloat centerX = self.contentView.width * 0.5f;
    if (self.customView) {
        self.customView.centerX      = centerX;

    }else{
        _indicatorView.centerX = centerX;
        _titleLabel.centerX       = centerX;
    }

    //有无设置偏移
    if (self.contentViewOffset) {
        self.centerY += self.contentViewOffset;
    }

    //有无设置Y坐标值
    if (self.contentViewY < 1000) {
        self.y = self.contentViewY;
    }

}

#pragma mark - ------------------ Setup View ------------------
- (void)setupImageView:(NSArray<UIImage *> *)imgs{
    [self.imageView stopAnimating];

    if (imgs.count == 0) {
        return;
    }

    if (imgs.count == 1) {
        self.imageView.image = imgs[0];
    } else {
        self.imageView.animationImages = imgs;
        [self.imageView startAnimating];
    }


    CGFloat imgViewWidth = imgs[0].size.width;
    CGFloat imgViewHeight = imgs[0].size.height;

    if (self.imageSize.width && self.imageSize.height) {//设置了宽高大小
        if (imgViewWidth > imgViewHeight) {//以宽为基准，按比例缩放高度
            imgViewHeight = (imgViewHeight / imgViewWidth) * self.imageSize.width;
            imgViewWidth = self.imageSize.width;

        }else{//以高为基准，按比例缩放宽度
            imgViewWidth = (imgViewWidth / imgViewHeight) * self.imageSize.height;
            imgViewHeight = self.imageSize.height;
        }
    }
    self.imageView.frame = CGRectMake(0, 0, imgViewWidth, imgViewHeight);
}

- (void)setupIndicatorView {

    if (_imageView.superview != nil) {
        self.indicatorView.size = CGSizeMake(self.imageView.width, self.imageView.height);
    }

    contentWidth = self.indicatorView.size.width;
    contentHeight = self.indicatorView.bottom;
}

- (void)setupTitleLabel:(NSString *)titleStr{

    UIFont *font = self.titleLabFont.pointSize ? self.titleLabFont : kTitleLabFont;
    CGFloat fontSize = font.pointSize;
    UIColor *textColor = self.titleLabTextColor ? self.titleLabTextColor : kBlackColor;
    CGFloat width = [self returnTextWidth:titleStr size:CGSizeMake(contentMaxWidth, fontSize) font:font].width;

    self.titleLabel.frame = CGRectMake(0, contentHeight + subViweMargin, width, fontSize);
    self.titleLabel.font = font;
    self.titleLabel.text = titleStr;
    self.titleLabel.textColor = textColor;

    contentWidth = width > contentWidth ? width : contentWidth;
    contentHeight = self.titleLabel.bottom;
}


#pragma mark - 懒加载

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        [self.contentView addSubview:_indicatorView];
    }
    return _indicatorView;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

#pragma mark - Properties Set

#pragma mark 内容物背景视图 相关
- (void)setSubViewMargin:(CGFloat)subViewMargin{
    if (_subViewMargin != subViewMargin) {
        _subViewMargin = subViewMargin;

        if (_indicatorView || _titleLabel || self.customView) {//此判断的意思只是确定self是否已加载完毕
            [self setupSubviews];
        }
    }
}
- (void)setContentViewOffset:(CGFloat)contentViewOffset{
    if (_contentViewOffset != contentViewOffset) {
        _contentViewOffset = contentViewOffset;

        if (_indicatorView || _titleLabel || self.customView) {
            self.centerY += self.contentViewOffset;
        }
    }
}

- (void)setContentViewY:(CGFloat)contentViewY{
    if (_contentViewY != contentViewY) {
        _contentViewY = contentViewY;

        if (_indicatorView || _titleLabel || self.customView) {
            self.y = self.contentViewY;
        }
    }
}

#pragma mark 提示图Image 相关
- (void)setImageSize:(CGSize)imageSize{
    if (_imageSize.width != imageSize.width || _imageSize.height != imageSize.height) {
        _imageSize = imageSize;

        if (_imageView) {
            [self setupSubviews];
        }
    }
}

#pragma mark LoadingView 相关


#pragma mark 描述Label 相关
-(void)setTitleLabFont:(UIFont *)titleLabFont{
    if (_titleLabFont != titleLabFont) {
        _titleLabFont = titleLabFont;

        if (_titleLabel) {
            [self setupSubviews];
        }
    }

}
- (void)setTitleLabTextColor:(UIColor *)titleLabTextColor{
    if (_titleLabTextColor != titleLabTextColor) {
        _titleLabTextColor = titleLabTextColor;

        if (_titleLabel) {
            _titleLabel.textColor = titleLabTextColor;
        }
    }
}


#pragma mark - Help Method

- (CGSize)returnTextWidth:(NSString *)text size:(CGSize)size font:(UIFont *)font{
    CGSize textSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    return textSize;
}


@end
