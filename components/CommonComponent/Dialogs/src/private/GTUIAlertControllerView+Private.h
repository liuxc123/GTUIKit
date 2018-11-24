//
//  GTUIAlertControllerView+Private.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/22.
//

#import <UIKit/UIKit.h>

#import "GTUIAlertActionManager.h"
#import "GTButton.h"


@interface GTUIAlertControllerView ()

@property(nonatomic, nonnull, strong) UILabel *titleLabel;
@property(nonatomic, nonnull, strong) UILabel *messageLabel;

@property(nonatomic, nullable, strong) UIImageView *titleIconImageView;

@property(nonatomic, nullable, weak) GTUIAlertActionManager *actionManager;

- (void)addActionButton:(nonnull GTUIButton *)button;
+ (void)styleAsTextButton:(nonnull GTUIButton *)button;

- (CGSize)calculatePreferredContentSizeForBounds:(CGSize)boundsSize;

- (void)updateFonts;


@end
