//
//  GTUIFormTool.h
//  GTCatalog
//
//  Created by liuxc on 2018/10/22.
//

#import <Foundation/Foundation.h>

@interface GTUIFormTool : NSObject

+ (id)objectForKey:(NSString *)key;
+ (void)setObject:(id)value forKey:(NSString *)key;

+ (BOOL)boolForKey:(NSString *)key;
+ (void)setBool:(BOOL)value forKey:(NSString *)key;

@end
