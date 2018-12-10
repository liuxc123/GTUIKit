//
//  GTUIFormOptionsObject.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>
#import "GTUIFormRowDescriptor.h"

@interface GTUIFormOptionsObject : NSObject <GTUIFormOptionObject, NSCoding>

@property (nonatomic) NSString * formDisplaytext;
@property (nonatomic) id formValue;

+(GTUIFormOptionsObject *)formOptionsObjectWithValue:(id)value displayText:(NSString *)displayText;
+(GTUIFormOptionsObject *)formOptionsOptionForValue:(id)value fromOptions:(NSArray *)options;
+(GTUIFormOptionsObject *)formOptionsOptionForDisplayText:(NSString *)displayText fromOptions:(NSArray *)options;

@end
