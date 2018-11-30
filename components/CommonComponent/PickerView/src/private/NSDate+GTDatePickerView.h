//
//  NSDate+GTDatePickerView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (GTDatePickerView)

/// 获取指定date的详细信息
@property (readonly) NSInteger gt_year;    // 年
@property (readonly) NSInteger gt_month;   // 月
@property (readonly) NSInteger gt_day;     // 日
@property (readonly) NSInteger gt_hour;    // 时
@property (readonly) NSInteger gt_minute;  // 分
@property (readonly) NSInteger gt_second;  // 秒
@property (readonly) NSInteger gt_weekday; // 星期

/** 创建 date */
/** yyyy */
+ (nullable NSDate *)gt_setYear:(NSInteger)year;
/** yyyy-MM */
+ (nullable NSDate *)gt_setYear:(NSInteger)year month:(NSInteger)month;
/** yyyy-MM-dd */
+ (nullable NSDate *)gt_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
/** yyyy-MM-dd HH:mm */
+ (nullable NSDate *)gt_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
/** MM-dd HH:mm */
+ (nullable NSDate *)gt_setMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
/** MM-dd */
+ (nullable NSDate *)gt_setMonth:(NSInteger)month day:(NSInteger)day;
/** HH:mm */
+ (nullable NSDate *)gt_setHour:(NSInteger)hour minute:(NSInteger)minute;


/** 日期和字符串之间的转换：NSDate --> NSString */
+ (nullable  NSString *)gt_getDateString:(NSDate *)date format:(NSString *)format;
/** 日期和字符串之间的转换：NSString --> NSDate */
+ (nullable  NSDate *)gt_getDate:(NSString *)dateString format:(NSString *)format;
/** 获取某个月的天数（通过年月求每月天数）*/
+ (NSUInteger)gt_getDaysInYear:(NSInteger)year month:(NSInteger)month;

/**  获取 日期加上/减去某天数后的新日期 */
- (nullable NSDate *)gt_getNewDate:(NSDate *)date addDays:(NSTimeInterval)days;

/**
 *  比较两个时间大小（可以指定比较级数，即按指定格式进行比较）
 */
- (NSComparisonResult)gt_compare:(NSDate *)targetDate format:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
