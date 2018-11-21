//
//  GTUITextInputBorderView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

@interface GTUITextInputBorderView : UIView <NSCopying>

/**
 The color of the area inside the border.

 Default is clear.
 */
@property(nonatomic, nullable, strong) UIColor *borderFillColor UI_APPEARANCE_SELECTOR;

/**
 The path of the area to be highlighted with a border. This could either be with a drawn line or a
 drawn fill.

 Note: The settable properties of the UIBezierPath are respected (.lineWidth, etc).

 Default is a rectangle of the same width as the input with rounded top corners. That means the
 underline labels are not included inside the border. Settable properties of UIBezierPath are left
 at
 system defaults.
 */
@property(nonatomic, nullable, strong) UIBezierPath *borderPath UI_APPEARANCE_SELECTOR;

/**
 The color of the border itself.

 Default is clear.
 */
@property(nonatomic, nullable, strong) UIColor *borderStrokeColor UI_APPEARANCE_SELECTOR;

@end
