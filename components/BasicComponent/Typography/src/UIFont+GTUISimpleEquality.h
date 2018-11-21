//
//  UIFont+GTUISimpleEquality.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/21.
//

#import <UIKit/UIKit.h>

@interface UIFont (GTUISimpleEquality)

/*
 Checks simple characteristics: name, weight, pointsize, traits.

 While the actual implementation of UIFont's isEqual: is not known, it is believed that
 isSimplyEqual: is more 'shallow' than isEqual:.
 */

- (BOOL)gtui_isSimplyEqual:(UIFont*)font;

@end
