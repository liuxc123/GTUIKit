//
//  UIFont+GTUISimpleEquality.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import "UIFont+GTUISimpleEquality.h"

#import "GTMath.h"

@implementation UIFont (GTUISimpleEquality)

- (BOOL)gtui_isSimplyEqual:(UIFont *)font {
    return [self.fontName isEqualToString:font.fontName] &&
    GTUICGFloatEqual(self.pointSize, font.pointSize) &&
    [[self.fontDescriptor objectForKey:UIFontDescriptorFaceAttribute]
     isEqual:[font.fontDescriptor objectForKey:UIFontDescriptorFaceAttribute]];
}

@end
