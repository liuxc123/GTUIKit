//
//  GTUIPaletteExpansions.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

UIColor* _Nonnull GTUIPaletteTintFromTargetColor(UIColor* _Nonnull targetColor,
                                                NSString* _Nonnull tintName);

UIColor* _Nonnull GTUIPaletteAccentFromTargetColor(UIColor* _Nonnull targetColor,
                                                  NSString* _Nonnull accentName);
