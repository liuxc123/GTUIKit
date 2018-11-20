//
//  GTUIFloatingButton.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/20.
//

#import "GTUIButton.h"

/**
 Shapes for Material Floating buttons.

 The mini size should only be used when required for visual continuity with other elements on the
 screen.
 */
typedef NS_ENUM(NSInteger, GTUIFloatingButtonShape) {
    /**
     A 56-point circular button surrounding a 24- or 36-point square icon or short text.
     */
    GTUIFloatingButtonShapeDefault = 0,
    /**
     A 40-point circular button surrounding a 24-point square icon or short text.
     */
    GTUIFloatingButtonShapeMini = 1
};

typedef NS_ENUM(NSInteger, GTUIFloatingButtonMode) {
    /**
     The floating button is a circle with its contents centered.
     */
    GTUIFloatingButtonModeNormal = 0,

    /**
     The floating button is a "pill shape" with the image to one side of the title.
     */
    GTUIFloatingButtonModeExpanded = 1,
};

typedef NS_ENUM(NSInteger, GTUIFloatingButtonImageLocation) {
    /**
     The image of the floating button is on the leading side of the title.
     */
    GTUIFloatingButtonImageLocationLeading = 0,

    /**
     The image of the floating button is on the trailing side of the title.
     */
    GTUIFloatingButtonImageLocationTrailing = 1,
};


@interface GTUIFloatingButton : GTUIButton

/**
 The mode of the floating button can either be .normal (a circle) or .expanded (a pill-shaped
 rounded rectangle). In the @c .normal mode, the button should have either an image or a title,
 but not both.  In the @c .expanded mode, the button should have both an image and a title.

 The @c .normal layout is identical to that of UIButton. The content will be centered (or otherwise
 aligned based on the @c contentHorizontalAlignment and @c contentVerticalAlignment properties. In
 @c .expanded layout, the image view will be inset from the leading edge (or trailing edge when
 @c imageLocation is .trailing). The "bounding box" for the title will be inset from the opposite
 edge and separated from @c imageView by @c imageTitleSpace and the title label will be
 leading-aligned within this box. In @c .expanded mode, the @c contentVerticalAlignment and
 @c contentHorizontalAlignment properties are ignored.

 The default value is @c .normal .
 */
@property(nonatomic, assign) GTUIFloatingButtonMode mode;


/**
 Returns a GTUIFloatingButton with default colors and the given @c shape.

 @param shape Button shape.
 @return Button with shape.
 */
+ (nonnull instancetype)floatingButtonWithShape:(GTUIFloatingButtonShape)shape;

/**
 @return The default floating button size dimension.
 */
+ (CGFloat)defaultDimension;

/**
 @return The mini floating button size dimension.
 */
+ (CGFloat)miniDimension;

/**
 Initializes self to a button with the given @c shape.

 @param frame Button frame.
 @param shape Button shape.
 @return Button with shape.
 */
- (nonnull instancetype)initWithFrame:(CGRect)frame
                                shape:(GTUIFloatingButtonShape)shape NS_DESIGNATED_INITIALIZER;

/**
 Initializes self to a button with the GTUIFloatingButtonShapeDefault shape.

 @param frame Button frame.
 @return Button with GTUIFloatingButtonShapeDefault shape.
 */
- (nonnull instancetype)initWithFrame:(CGRect)frame;

/**
 Initializes self to a button with the GTUIFloatingButtonShapeDefault shape.

 @return Button with GTUIFloatingButtonShapeDefault shape.
 */
- (nonnull instancetype)init;

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

- (void)setMinimumSize:(CGSize)size NS_UNAVAILABLE;

/**
 Sets the minimum size when the button has the specified @c shape @c mode.
 Setting a size of @c CGSizeZero is equivalent to no minimum size.  To set a fixed size for a
 button, use the same value when setting the minimum and maximum sizes for a @c shape and @c mode
 combination.

 @param minimumSize The new minimum size of the button.
 @param shape The shape that the size constrains.
 @param mode The mode that the size constrains.
 */
- (void)setMinimumSize:(CGSize)minimumSize
              forShape:(GTUIFloatingButtonShape)shape
                inMode:(GTUIFloatingButtonMode)mode UI_APPEARANCE_SELECTOR;

- (void)setMaximumSize:(CGSize)maximumSize NS_UNAVAILABLE;

/**
 Sets the maximum size when the button has the specified @c shape and @c mode.
 Setting a size of @c CGSizeZero is equivalent to no maximum size.  To set a fixed size for a
 button, use the same value when setting the minimum and maximum sizes for a @c shape and @c mode
 combination.

 @param maximumSize The new maximum size of the button.
 @param shape The shape that the size constrains.
 @param mode The mode that the size constrains.
 */
- (void)setMaximumSize:(CGSize)maximumSize
              forShape:(GTUIFloatingButtonShape)shape
                inMode:(GTUIFloatingButtonMode)mode UI_APPEARANCE_SELECTOR;

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets NS_UNAVAILABLE;

/**
 Sets the @c contentEdgeInsets value when the button has the specified @c shape and @c mode.
 The behavior of @c contentEdgeInsets is the same as for UIButton. The button will layout its
 subviews within the rectangle generated by insetting its @c bounds by @c contentEdgeInsets.

 @param contentEdgeInsets The new content edge insets value.
 @param shape The shape for the content edge insets.
 @param mode The mode for the content edge insets.
 */
- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                    forShape:(GTUIFloatingButtonShape)shape
                      inMode:(GTUIFloatingButtonMode)mode UI_APPEARANCE_SELECTOR;

- (void)setHitAreaInsets:(UIEdgeInsets)hitAreaInsets NS_UNAVAILABLE;

/**
 Sets the @c hitAreaInsets value when the button has the specified @c shape and @c mode.

 @param hitAreaInsets The new hit area insets value.
 @param shape The shape for the hit area insets.
 @param mode The mode for the hit area insets.
 */
- (void)setHitAreaInsets:(UIEdgeInsets)hitAreaInsets
                forShape:(GTUIFloatingButtonShape)shape
                  inMode:(GTUIFloatingButtonMode)mode UI_APPEARANCE_SELECTOR;

@end
