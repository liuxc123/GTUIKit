//
//  GTUITextInputUnderlineView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

/**
 A view that draws the underline effect for an instance of GTUITextInput. The underline has 2
 possible states enabled and disabled. Disabled shows a dotted line instead of solid.
 */
@interface GTUITextInputUnderlineView : UIView <NSCopying>

@property(nonatomic, strong) UIColor *color;
@property(nonatomic, strong) UIColor *disabledColor;
@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, assign) CGFloat lineHeight;

@end
