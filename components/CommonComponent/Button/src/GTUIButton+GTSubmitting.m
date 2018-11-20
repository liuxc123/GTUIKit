//
//  GTUIButton+GTSubmitting.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/19.
//

#import "GTUIButton+GTSubmitting.h"
#import  <objc/runtime.h>

@interface UIButton ()

@property (nonatomic, retain) UIView *spinnerView;
@property(nonatomic, strong) UIView *modalView;
@property(nonatomic, strong) UILabel *spinnerTitleLabel;

@end

@implementation GTUIButton (GTSubmitting)

- (void)beginSubmitting:(NSString *)title {
    self.submitting = @YES;
    self.hidden = YES;

    self.modalView = [[UIView alloc] initWithFrame:self.frame];
    self.modalView.backgroundColor =
    [self.backgroundColor colorWithAlphaComponent:0.6];
    self.modalView.layer.cornerRadius = self.layer.cornerRadius;
    self.modalView.layer.borderWidth = self.layer.borderWidth;
    self.modalView.layer.borderColor = self.layer.borderColor;

    CGRect viewBounds = self.modalView.bounds;

    if (self.spinnerView == nil) {
        self.spinnerView = [[UIActivityIndicatorView alloc]
                               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }

    self.spinnerView.tintColor = self.titleLabel.textColor;

    CGRect spinnerViewBounds = self.spinnerView.bounds;
    self.spinnerView.frame = CGRectMake(
                                           15, viewBounds.size.height / 2 - spinnerViewBounds.size.height / 2,
                                           spinnerViewBounds.size.width, spinnerViewBounds.size.height);
    self.spinnerTitleLabel = [[UILabel alloc] initWithFrame:viewBounds];
    self.spinnerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.spinnerTitleLabel.text = title;
    self.spinnerTitleLabel.font = self.titleLabel.font;
    self.spinnerTitleLabel.textColor = self.titleLabel.textColor;
    [self.modalView addSubview:self.spinnerView];
    [self.modalView addSubview:self.spinnerTitleLabel];
    [self.superview addSubview:self.modalView];
    [(UIActivityIndicatorView *)self.spinnerView startAnimating];

}

- (void)endSubmitting {

}


#pragma mark Set/Get

- (void)setSubmitting:(NSNumber *)submitting {
    objc_setAssociatedObject(self, @selector(setSubmitting:), submitting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)isSubmitting {
    return objc_getAssociatedObject(self, @selector(setSubmitting:));
}

- (void)setSpinnerView:(UIView *)spinnerView {
    objc_setAssociatedObject(self, @selector(setSpinnerView:), spinnerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)spinnerView {
    return objc_getAssociatedObject(self, @selector(setSpinnerView:));
}

- (void)setModalView:(UIView *)modalView {
    objc_setAssociatedObject(self, @selector(setModalView:), modalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)modalView {
    return objc_getAssociatedObject(self, @selector(setModalView:));
}

- (void)setSpinnerTitleLabel:(UILabel *)spinnerTitleLabel {
    objc_setAssociatedObject(self, @selector(setSpinnerTitleLabel:), spinnerTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)spinnerTitleLabel {
    return objc_getAssociatedObject(self, @selector(setSpinnerTitleLabel:));
}

@end
