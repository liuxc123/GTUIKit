//
//  GTUIBadgeProtocol.h
//  GTCatalog
//
//  Created by liuxc on 2018/12/1.
//

#import <Foundation/Foundation.h>

#pragma mark -- types definition

#define kBadgeBreatheAniKey     @"breathe"
#define kBadgeRotateAniKey      @"rotate"
#define kBadgeShakeAniKey       @"shake"
#define kBadgeScaleAniKey       @"scale"
#define kBadgeBounceAniKey      @"bounce"

//key for associative methods during runtime
static char badgeLabelKey;
static char badgeBgColorKey;
static char badgeFontKey;
static char badgeTextColorKey;
static char badgeAniTypeKey;
static char badgeFrameKey;
static char badgeCenterOffsetKey;
static char badgeMaximumBadgeNumberKey;
static char badgeRadiusKey;

typedef NS_ENUM(NSUInteger, GTUIBadgeStyle)
{
    GTUIBadgeStyleRedDot = 0,          /* red dot style */
    GTUIBadgeStyleNumber,              /* badge with number */
    GTUIBadgeStyleNew                  /* badge with a fixed text "new" */
};

typedef NS_ENUM(NSUInteger, GTUIBadgeAnimType)
{
    GTUIBadgeAnimTypeNone = 0,         /* without animation, badge stays still */
    GTUIBadgeAnimTypeScale,            /* scale effect */
    GTUIBadgeAnimTypeShake,            /* shaking effect */
    GTUIBadgeAnimTypeBounce,           /* bouncing effect */
    GTUIBadgeAnimTypeBreathe           /* breathing light effect, which makes badge more attractive */
};

#pragma mark -- protocol definition

@protocol GTUIBadgeProtocol <NSObject>

@required

@property (nonatomic, strong) UILabel *badge;                       /* badge entity, which is adviced not to set manually */
@property (nonatomic, strong) UIFont *badgeFont;                    /* [UIFont boldSystemFontOfSize:9] by default if not set */
@property (nonatomic, strong) UIColor *badgeBgColor;                /* red color by default if not set */
@property (nonatomic, strong) UIColor *badgeTextColor;              /* white color by default if not set */
@property (nonatomic, assign) CGRect badgeFrame;                    /* we have optimized the badge frame and center.
                                                                     This property is adviced not to set manually */

@property (nonatomic, assign) CGPoint  badgeCenterOffset;           /* offset from right-top corner. {0,0} by default */
/* For x, negative number means left offset
 For y, negative number means bottom offset */

@property (nonatomic, assign) GTUIBadgeAnimType aniType;               /* NOTE that this is not animation type of badge's
                                                                     appearing, nor  hidding*/

@property (nonatomic, assign) NSInteger badgeMaximumBadgeNumber;    /*for GTUIBadgeStyleNumber style badge,
                                                                     if badge value is above badgeMaximumBadgeNumber,
                                                                     "badgeMaximumBadgeNumber+" will be printed. */

/**
 *  show badge with red dot style and GTUIBadgeAnimTypeNone by default.
 */
- (void)showBadge;

/**
 *  shoGTUIBadge
 *
 *  @param style GTUIBadgeStyle type
 *  @param value (if 'style' is GTUIBadgeStyleRedDot or GTUIBadgeStyleNew,
 this value will be ignored. In this case, any value will be ok.)
 *   @param aniType GTUIBadgeAnimType
 */
- (void)showBadgeWithStyle:(GTUIBadgeStyle)style
                     value:(NSInteger)value
             animationType:(GTUIBadgeAnimType)aniType;


/**
 *  clear badge
 */
- (void)clearBadge;

@optional

@property (nonatomic, assign) CGFloat badgeRadius;

@end
