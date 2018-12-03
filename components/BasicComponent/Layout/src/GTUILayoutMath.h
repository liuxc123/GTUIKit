//
//  GTUILayoutMath.h
//  GTUILayout
//
//  Created by liuxc on 2018/12/2.
//  Copyright © 2018 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern BOOL _gtuiCGFloatErrorEqual(CGFloat f1, CGFloat f2, CGFloat error);
extern BOOL _gtuiCGFloatErrorNotEqual(CGFloat f1, CGFloat f2, CGFloat error);


extern BOOL _gtuiCGFloatLess(CGFloat f1, CGFloat f2);
extern BOOL _gtuiCGFloatGreat(CGFloat f1, CGFloat f2);
extern BOOL _gtuiCGFloatEqual(CGFloat f1, CGFloat f2);
extern BOOL _gtuiCGFloatNotEqual(CGFloat f1, CGFloat f2);
extern BOOL _gtuiCGFloatLessOrEqual(CGFloat f1, CGFloat f2);
extern BOOL _gtuiCGFloatGreatOrEqual(CGFloat f1, CGFloat f2);
extern BOOL _gtuiCGSizeEqual(CGSize sz1, CGSize sz2);
extern BOOL _gtuiCGPointEqual(CGPoint pt1, CGPoint pt2);
extern BOOL _gtuiCGRectEqual(CGRect rect1, CGRect rect2);


extern CGFloat _gtuiCGFloatRound(CGFloat f);
extern CGRect _gtuiCGRectRound(CGRect rect);
extern CGSize _gtuiCGSizeRound(CGSize size);
extern CGPoint _gtuiCGPointRound(CGPoint point);
extern CGRect _gtuiLayoutCGRectRound(CGRect rect);

extern CGFloat _gtuiCGFloatMax(CGFloat a, CGFloat b);
extern CGFloat _gtuiCGFloatMin(CGFloat a, CGFloat b);

//a*b + c
extern CGFloat _gtuiCGFloatFma(CGFloat a, CGFloat b, CGFloat c);

NS_ASSUME_NONNULL_END
