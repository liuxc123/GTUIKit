//
//  GTAddressModel.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import <Foundation/Foundation.h>

// 省
@interface GTProvinceModel : NSObject
/**
 * 省对应的code或id
 */
@property (nonatomic, copy) NSString *code;
/**
 * 省的名称
 */
@property (nonatomic, copy) NSString *name;
/**
 * 省的索引
 */
@property (nonatomic, assign) NSInteger index;
/**
 * 城市数组
 */
@property (nonatomic, strong) NSArray *citylist;

@end

// 市
@interface GTCityModel : NSObject
/**
 * 市对应的code或id
 */
@property (nonatomic, copy) NSString *code;
/**
 * 市的名称
 */
@property (nonatomic, copy) NSString *name;
/**
 * 市的索引
 */
@property (nonatomic, assign) NSInteger index;
/**
 * 地区数组
 */
@property (nonatomic, strong) NSArray *arealist;

@end

// 区
@interface GTAreaModel : NSObject
/**
 *  区对应的code或id
 */
@property (nonatomic, copy) NSString *code;
/**
 *  区的名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  区的索引
 */
@property (nonatomic, assign) NSInteger index;

@end

