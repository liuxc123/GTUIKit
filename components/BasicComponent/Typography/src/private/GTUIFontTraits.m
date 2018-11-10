//
//  GTUIFontTraits.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/8.
//

#import "GTUIFontTraits.h"

static NSDictionary<NSString *, GTUIFontTraits *> *_body1Traits;
static NSDictionary<NSString *, GTUIFontTraits *> *_body2Traits;
static NSDictionary<NSString *, GTUIFontTraits *> *_buttonTraits;
static NSDictionary<NSString *, GTUIFontTraits *> *_captionTraits;
static NSDictionary<NSString *, GTUIFontTraits *> *_display1Traits;
static NSDictionary<NSString *, GTUIFontTraits *> *_display2Traits;
static NSDictionary<NSString *, GTUIFontTraits *> *_display3Traits;
static NSDictionary<NSString *, GTUIFontTraits *> *_display4Traits;
static NSDictionary<NSString *, GTUIFontTraits *> *_headlineTraits;
static NSDictionary<NSString *, GTUIFontTraits *> *_subheadlineTraits;
static NSDictionary<NSString *, GTUIFontTraits *> *_titleTraits;

static NSDictionary<NSNumber *, NSDictionary *> *_styleTable;

@interface GTUIFontTraits (GTUITypographyPrivate)

+ (instancetype)traitsWithPointSize:(CGFloat)pointSize
                             weight:(CGFloat)weight
                            leading:(CGFloat)leading
                           tracking:(CGFloat)tracking;

- (instancetype)initWithPointSize:(CGFloat)pointSize
                           weight:(CGFloat)weight
                          leading:(CGFloat)leading
                         tracking:(CGFloat)tracking;

@end

@implementation GTUIFontTraits


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
+ (void)initialize {
    _body1Traits = @{
                     UIContentSizeCategoryExtraSmall :
                         [GTUIFontTraits traitsWithPointSize:11 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategorySmall :
                         [GTUIFontTraits traitsWithPointSize:12 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryMedium :
                         [GTUIFontTraits traitsWithPointSize:13 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryLarge :
                         [GTUIFontTraits traitsWithPointSize:14 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryExtraLarge :
                         [GTUIFontTraits traitsWithPointSize:16 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryExtraExtraLarge :
                         [GTUIFontTraits traitsWithPointSize:18 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryExtraExtraExtraLarge :
                         [GTUIFontTraits traitsWithPointSize:20 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryAccessibilityMedium :
                         [GTUIFontTraits traitsWithPointSize:25 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryAccessibilityLarge :
                         [GTUIFontTraits traitsWithPointSize:30 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraLarge :
                         [GTUIFontTraits traitsWithPointSize:37 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraExtraLarge :
                         [GTUIFontTraits traitsWithPointSize:44 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraExtraExtraLarge :
                         [GTUIFontTraits traitsWithPointSize:52 weight:UIFontWeightRegular leading:0.0 tracking:0.0],
                     };

    _body2Traits = @{
                     UIContentSizeCategoryExtraSmall : [[GTUIFontTraits alloc] initWithPointSize:11
                                                                                         weight:UIFontWeightMedium
                                                                                        leading:0.0
                                                                                       tracking:0.0],
                     UIContentSizeCategorySmall : [[GTUIFontTraits alloc] initWithPointSize:12
                                                                                    weight:UIFontWeightMedium
                                                                                   leading:0.0
                                                                                  tracking:0.0],
                     UIContentSizeCategoryMedium : [[GTUIFontTraits alloc] initWithPointSize:13
                                                                                     weight:UIFontWeightMedium
                                                                                    leading:0.0
                                                                                   tracking:0.0],
                     UIContentSizeCategoryLarge : [[GTUIFontTraits alloc] initWithPointSize:14
                                                                                    weight:UIFontWeightMedium
                                                                                   leading:0.0
                                                                                  tracking:0.0],
                     UIContentSizeCategoryExtraLarge : [[GTUIFontTraits alloc] initWithPointSize:16
                                                                                         weight:UIFontWeightMedium
                                                                                        leading:0.0
                                                                                       tracking:0.0],
                     UIContentSizeCategoryExtraExtraLarge :
                         [[GTUIFontTraits alloc] initWithPointSize:18
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryExtraExtraExtraLarge :
                         [[GTUIFontTraits alloc] initWithPointSize:20
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryAccessibilityMedium :
                         [[GTUIFontTraits alloc] initWithPointSize:25
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryAccessibilityLarge :
                         [[GTUIFontTraits alloc] initWithPointSize:30
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraLarge :
                         [[GTUIFontTraits alloc] initWithPointSize:37
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraExtraLarge :
                         [[GTUIFontTraits alloc] initWithPointSize:44
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryAccessibilityExtraExtraExtraLarge :
                         [[GTUIFontTraits alloc] initWithPointSize:52
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     };

    _buttonTraits = @{
                      UIContentSizeCategoryExtraSmall : [[GTUIFontTraits alloc] initWithPointSize:11
                                                                                          weight:UIFontWeightMedium
                                                                                         leading:0.0
                                                                                        tracking:0.0],
                      UIContentSizeCategorySmall : [[GTUIFontTraits alloc] initWithPointSize:12
                                                                                     weight:UIFontWeightMedium
                                                                                    leading:0.0
                                                                                   tracking:0.0],
                      UIContentSizeCategoryMedium : [[GTUIFontTraits alloc] initWithPointSize:13
                                                                                      weight:UIFontWeightMedium
                                                                                     leading:0.0
                                                                                    tracking:0.0],
                      UIContentSizeCategoryLarge : [[GTUIFontTraits alloc] initWithPointSize:14
                                                                                     weight:UIFontWeightMedium
                                                                                    leading:0.0
                                                                                   tracking:0.0],
                      UIContentSizeCategoryExtraLarge : [[GTUIFontTraits alloc] initWithPointSize:16
                                                                                          weight:UIFontWeightMedium
                                                                                         leading:0.0
                                                                                        tracking:0.0],
                      UIContentSizeCategoryExtraExtraLarge :
                          [[GTUIFontTraits alloc] initWithPointSize:18
                                                            weight:UIFontWeightMedium
                                                           leading:0.0
                                                          tracking:0.0],
                      UIContentSizeCategoryExtraExtraExtraLarge :
                          [[GTUIFontTraits alloc] initWithPointSize:20
                                                            weight:UIFontWeightMedium
                                                           leading:0.0
                                                          tracking:0.0],
                      };

    _captionTraits = @{
                       UIContentSizeCategoryExtraSmall : [[GTUIFontTraits alloc] initWithPointSize:11
                                                                                           weight:UIFontWeightRegular
                                                                                          leading:0.0
                                                                                         tracking:0.0],
                       UIContentSizeCategorySmall : [[GTUIFontTraits alloc] initWithPointSize:11
                                                                                      weight:UIFontWeightRegular
                                                                                     leading:0.0
                                                                                    tracking:0.0],
                       UIContentSizeCategoryMedium : [[GTUIFontTraits alloc] initWithPointSize:11
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                       UIContentSizeCategoryLarge : [[GTUIFontTraits alloc] initWithPointSize:12
                                                                                      weight:UIFontWeightRegular
                                                                                     leading:0.0
                                                                                    tracking:0.0],
                       UIContentSizeCategoryExtraLarge : [[GTUIFontTraits alloc] initWithPointSize:14
                                                                                           weight:UIFontWeightRegular
                                                                                          leading:0.0
                                                                                         tracking:0.0],
                       UIContentSizeCategoryExtraExtraLarge :
                           [[GTUIFontTraits alloc] initWithPointSize:16
                                                             weight:UIFontWeightRegular
                                                            leading:0.0
                                                           tracking:0.0],
                       UIContentSizeCategoryExtraExtraExtraLarge :
                           [[GTUIFontTraits alloc] initWithPointSize:18
                                                             weight:UIFontWeightRegular
                                                            leading:0.0
                                                           tracking:0.0],
                       };

    _display1Traits = @{
                        UIContentSizeCategoryExtraSmall : [[GTUIFontTraits alloc] initWithPointSize:28
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategorySmall : [[GTUIFontTraits alloc] initWithPointSize:30
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryMedium : [[GTUIFontTraits alloc] initWithPointSize:32
                                                                                        weight:UIFontWeightRegular
                                                                                       leading:0.0
                                                                                      tracking:0.0],
                        UIContentSizeCategoryLarge : [[GTUIFontTraits alloc] initWithPointSize:34
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryExtraLarge : [[GTUIFontTraits alloc] initWithPointSize:36
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategoryExtraExtraLarge :
                            [[GTUIFontTraits alloc] initWithPointSize:38
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        UIContentSizeCategoryExtraExtraExtraLarge :
                            [[GTUIFontTraits alloc] initWithPointSize:40
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        };

    _display2Traits = @{
                        UIContentSizeCategoryExtraSmall : [[GTUIFontTraits alloc] initWithPointSize:39
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategorySmall : [[GTUIFontTraits alloc] initWithPointSize:41
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryMedium : [[GTUIFontTraits alloc] initWithPointSize:43
                                                                                        weight:UIFontWeightRegular
                                                                                       leading:0.0
                                                                                      tracking:0.0],
                        UIContentSizeCategoryLarge : [[GTUIFontTraits alloc] initWithPointSize:45
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryExtraLarge : [[GTUIFontTraits alloc] initWithPointSize:47
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategoryExtraExtraLarge :
                            [[GTUIFontTraits alloc] initWithPointSize:49
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        UIContentSizeCategoryExtraExtraExtraLarge :
                            [[GTUIFontTraits alloc] initWithPointSize:51
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        };

    _display3Traits = @{
                        UIContentSizeCategoryExtraSmall : [[GTUIFontTraits alloc] initWithPointSize:50
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategorySmall : [[GTUIFontTraits alloc] initWithPointSize:52
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryMedium : [[GTUIFontTraits alloc] initWithPointSize:54
                                                                                        weight:UIFontWeightRegular
                                                                                       leading:0.0
                                                                                      tracking:0.0],
                        UIContentSizeCategoryLarge : [[GTUIFontTraits alloc] initWithPointSize:56
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryExtraLarge : [[GTUIFontTraits alloc] initWithPointSize:58
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategoryExtraExtraLarge :
                            [[GTUIFontTraits alloc] initWithPointSize:60
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        UIContentSizeCategoryExtraExtraExtraLarge :
                            [[GTUIFontTraits alloc] initWithPointSize:62
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        };

    _display4Traits = @{
                        UIContentSizeCategoryExtraSmall : [[GTUIFontTraits alloc] initWithPointSize:100
                                                                                            weight:UIFontWeightLight
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategorySmall : [[GTUIFontTraits alloc] initWithPointSize:104
                                                                                       weight:UIFontWeightLight
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryMedium : [[GTUIFontTraits alloc] initWithPointSize:108
                                                                                        weight:UIFontWeightLight
                                                                                       leading:0.0
                                                                                      tracking:0.0],
                        UIContentSizeCategoryLarge : [[GTUIFontTraits alloc] initWithPointSize:112
                                                                                       weight:UIFontWeightLight
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryExtraLarge : [[GTUIFontTraits alloc] initWithPointSize:116
                                                                                            weight:UIFontWeightLight
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategoryExtraExtraLarge :
                            [[GTUIFontTraits alloc] initWithPointSize:120
                                                              weight:UIFontWeightLight
                                                             leading:0.0
                                                            tracking:0.0],
                        UIContentSizeCategoryExtraExtraExtraLarge :
                            [[GTUIFontTraits alloc] initWithPointSize:124
                                                              weight:UIFontWeightLight
                                                             leading:0.0
                                                            tracking:0.0],
                        };

    _headlineTraits = @{
                        UIContentSizeCategoryExtraSmall : [[GTUIFontTraits alloc] initWithPointSize:21
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategorySmall : [[GTUIFontTraits alloc] initWithPointSize:22
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryMedium : [[GTUIFontTraits alloc] initWithPointSize:23
                                                                                        weight:UIFontWeightRegular
                                                                                       leading:0.0
                                                                                      tracking:0.0],
                        UIContentSizeCategoryLarge : [[GTUIFontTraits alloc] initWithPointSize:24
                                                                                       weight:UIFontWeightRegular
                                                                                      leading:0.0
                                                                                     tracking:0.0],
                        UIContentSizeCategoryExtraLarge : [[GTUIFontTraits alloc] initWithPointSize:26
                                                                                            weight:UIFontWeightRegular
                                                                                           leading:0.0
                                                                                          tracking:0.0],
                        UIContentSizeCategoryExtraExtraLarge :
                            [[GTUIFontTraits alloc] initWithPointSize:28
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        UIContentSizeCategoryExtraExtraExtraLarge :
                            [[GTUIFontTraits alloc] initWithPointSize:30
                                                              weight:UIFontWeightRegular
                                                             leading:0.0
                                                            tracking:0.0],
                        };

    _subheadlineTraits = @{
                           UIContentSizeCategoryExtraSmall : [[GTUIFontTraits alloc] initWithPointSize:13
                                                                                               weight:UIFontWeightRegular
                                                                                              leading:0.0
                                                                                             tracking:0.0],
                           UIContentSizeCategorySmall : [[GTUIFontTraits alloc] initWithPointSize:14
                                                                                          weight:UIFontWeightRegular
                                                                                         leading:0.0
                                                                                        tracking:0.0],
                           UIContentSizeCategoryMedium : [[GTUIFontTraits alloc] initWithPointSize:15
                                                                                           weight:UIFontWeightRegular
                                                                                          leading:0.0
                                                                                         tracking:0.0],
                           UIContentSizeCategoryLarge : [[GTUIFontTraits alloc] initWithPointSize:16
                                                                                          weight:UIFontWeightRegular
                                                                                         leading:0.0
                                                                                        tracking:0.0],
                           UIContentSizeCategoryExtraLarge : [[GTUIFontTraits alloc] initWithPointSize:18
                                                                                               weight:UIFontWeightRegular
                                                                                              leading:0.0
                                                                                             tracking:0.0],
                           UIContentSizeCategoryExtraExtraLarge :
                               [[GTUIFontTraits alloc] initWithPointSize:20
                                                                 weight:UIFontWeightRegular
                                                                leading:0.0
                                                               tracking:0.0],
                           UIContentSizeCategoryExtraExtraExtraLarge :
                               [[GTUIFontTraits alloc] initWithPointSize:22
                                                                 weight:UIFontWeightRegular
                                                                leading:0.0
                                                               tracking:0.0],
                           };

    _titleTraits = @{
                     UIContentSizeCategoryExtraSmall : [[GTUIFontTraits alloc] initWithPointSize:17
                                                                                         weight:UIFontWeightMedium
                                                                                        leading:0.0
                                                                                       tracking:0.0],
                     UIContentSizeCategorySmall : [[GTUIFontTraits alloc] initWithPointSize:18
                                                                                    weight:UIFontWeightMedium
                                                                                   leading:0.0
                                                                                  tracking:0.0],
                     UIContentSizeCategoryMedium : [[GTUIFontTraits alloc] initWithPointSize:19
                                                                                     weight:UIFontWeightMedium
                                                                                    leading:0.0
                                                                                   tracking:0.0],
                     UIContentSizeCategoryLarge : [[GTUIFontTraits alloc] initWithPointSize:20
                                                                                    weight:UIFontWeightMedium
                                                                                   leading:0.0
                                                                                  tracking:0.0],
                     UIContentSizeCategoryExtraLarge : [[GTUIFontTraits alloc] initWithPointSize:22
                                                                                         weight:UIFontWeightMedium
                                                                                        leading:0.0
                                                                                       tracking:0.0],
                     UIContentSizeCategoryExtraExtraLarge :
                         [[GTUIFontTraits alloc] initWithPointSize:24
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     UIContentSizeCategoryExtraExtraExtraLarge :
                         [[GTUIFontTraits alloc] initWithPointSize:26
                                                           weight:UIFontWeightMedium
                                                          leading:0.0
                                                         tracking:0.0],
                     };

    _styleTable = @{
                    @(GTUIFontTextStyleBody1) : _body1Traits,
                    @(GTUIFontTextStyleBody2) : _body2Traits,
                    @(GTUIFontTextStyleButton) : _buttonTraits,
                    @(GTUIFontTextStyleCaption) : _captionTraits,
                    @(GTUIFontTextStyleDisplay1) : _display1Traits,
                    @(GTUIFontTextStyleDisplay2) : _display2Traits,
                    @(GTUIFontTextStyleDisplay3) : _display3Traits,
                    @(GTUIFontTextStyleDisplay4) : _display4Traits,
                    @(GTUIFontTextStyleHeadline) : _headlineTraits,
                    @(GTUIFontTextStyleSubheadline) : _subheadlineTraits,
                    @(GTUIFontTextStyleTitle) : _titleTraits
                    };
}
#pragma clang diagnostic pop

+ (instancetype)traitsWithPointSize:(CGFloat)pointSize
                             weight:(CGFloat)weight
                            leading:(CGFloat)leading
                           tracking:(CGFloat)tracking {
    return [[GTUIFontTraits alloc] initWithPointSize:pointSize
                                             weight:weight
                                            leading:leading
                                           tracking:tracking];
}

- (instancetype)initWithPointSize:(CGFloat)pointSize
                           weight:(CGFloat)weight
                          leading:(CGFloat)leading
                         tracking:(CGFloat)tracking {
    self = [super init];
    if (self) {
        _pointSize = pointSize;
        _weight = weight;
        _leading = leading;
        _tracking = tracking;
    }

    return self;
}

+ (GTUIFontTraits *)traitsForTextStyle:(GTUIFontTextStyle)style
                         sizeCategory:(NSString *)sizeCategory {
    NSDictionary *traitsTable = _styleTable[@(style)];
    NSCAssert(traitsTable, @"traitsTable cannot be nil. Is style valid?");

    GTUIFontTraits *traits;
    if (traitsTable) {
        if (sizeCategory) {
            traits = traitsTable[sizeCategory];
        }

        // If you have queried the table for a sizeCategory that doesn't exist, we will return the
        // traits for XXXL.  This handles the case where the values are requested for one of the
        // accessibility size categories beyond XXXL such as
        // UIContentSizeCategoryAccessibilityExtraLarge.  Accessbility size categories are only
        // defined for the Body Font Style.
        if (traits == nil) {
            traits = traitsTable[UIContentSizeCategoryExtraExtraExtraLarge];
        }
    }

    return traits;
}


@end
