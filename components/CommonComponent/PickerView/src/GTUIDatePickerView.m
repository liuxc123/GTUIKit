//
//  GTUIDatePickerView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "GTUIDatePickerView.h"
#import "private/NSDate+GTDatePickerView.h"
#import "private/GTPickerViewMacro.h"
#import "GTUIMetrics.h"

typedef enum : NSUInteger {
    GTUIDatePickerStyleSystem,    //  系统样式 UIDatePicker 类
    GTUIDatePickerStyleCustom     //  自定义样式 UIPickerView 类
} GTUIDatePickerStyle;


@interface GTUIDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    // 记录 年、月、日、时、分 当前选择的位置
    NSInteger _yearIndex;
    NSInteger _monthIndex;
    NSInteger _dayIndex;
    NSInteger _hourIndex;
    NSInteger _minuteIndex;

    NSString *_title;
    UIDatePickerMode _datePickerMode;
    BOOL _isAutoSelect;      // 是否开启自动选择
}
/** 时间选择器1 */
@property (nonatomic, strong) UIDatePicker *datePicker;
/** 时间选择器2 */
@property (nonatomic, strong) UIPickerView *pickerView;
/// 日期存储数组
@property(nonatomic, strong) NSArray *yearArr;
@property(nonatomic, strong) NSArray *monthArr;
@property(nonatomic, strong) NSArray *dayArr;
@property(nonatomic, strong) NSArray *hourArr;
@property(nonatomic, strong) NSArray *minuteArr;
/** 显示类型 */
@property (nonatomic, assign) GTUIDatePickerMode pickerMode;
/** 时间选择器的类型 */
@property (nonatomic, assign) GTUIDatePickerStyle pickerStyle;
/** 限制最小日期 */
@property (nonatomic, strong) NSDate *minLimitDate;
/** 限制最大日期 */
@property (nonatomic, strong) NSDate *maxLimitDate;
/** 当前选择的日期 */
@property (nonatomic, strong) NSDate *selectDate;
/** 选择的日期的格式 */
@property (nonatomic, strong) NSString *selectDateFormatter;
/** 线的颜色 */
@property (nonatomic, strong) UIColor *lineColor;
// 选中行文本的颜色
@property (nonatomic, strong) UIColor  *selecteRowTextColor;
// 选中行背景颜色
@property (nonatomic, strong) UIColor  *selectRowBGColor;
// 行高
@property (nonatomic, assign) CGFloat  rowHeight;
/** 选中后的回调 */
@property (nonatomic, copy) GTUIDateResultBlock resultBlock;
/** 取消选择的回调 */
@property (nonatomic, copy) GTUIDateCancelBlock cancelBlock;
/** 存取选中行 */
@property (nonatomic,strong) NSMutableDictionary *selectedRowCache;
@end

@implementation GTUIDatePickerView

#pragma mark - 1.显示时间选择器
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                       resultBlock:(GTUIDateResultBlock)resultBlock{


    [self showDatePickerWithTitle:title
                            dateType:dateType
                     defaultSelValue:defaultSelValue
                        isAutoSelect:NO
                         resultBlock:resultBlock
                         cancelBlock:nil];

}

#pragma mark - 2.显示时间选择器（支持 设置自动选择、取消选择的回调）
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                      isAutoSelect:(BOOL)isAutoSelect
                       resultBlock:(GTUIDateResultBlock)resultBlock
                       cancelBlock:(GTUIDateCancelBlock)cancelBlock{


    [self showDatePickerWithTitle:title
                            dateType:dateType
                     defaultSelValue:defaultSelValue
                             minDate:nil
                             maxDate:nil
                        isAutoSelect:isAutoSelect
                         resultBlock:resultBlock
                         cancelBlock:cancelBlock];

}

#pragma mark - 3.显示时间选择器（支持 设置自动选择、最大值、最小值、取消选择的回调）
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                           minDate:(NSDate *)minDate
                           maxDate:(NSDate *)maxDate
                      isAutoSelect:(BOOL)isAutoSelect
                       resultBlock:(GTUIDateResultBlock)resultBlock
                       cancelBlock:(GTUIDateCancelBlock)cancelBlock{


    [self showDatePickerWithTitle:title
                            dateType:dateType
                     defaultSelValue:defaultSelValue
                             minDate:minDate
                             maxDate:maxDate
                        isAutoSelect:isAutoSelect
                           lineColor:nil
                           rowHeight:0
                         resultBlock:resultBlock
                         cancelBlock:cancelBlock];

}
#pragma mark - 4.显示时间选择器（支持 设置自动选择、最大值、最小值、自定义分割线颜色、行高、取消选择的回调）
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                           minDate:(NSDate *)minDate
                           maxDate:(NSDate *)maxDate
                      isAutoSelect:(BOOL)isAutoSelect
                         lineColor:(UIColor *)lineColor
                         rowHeight:(CGFloat)rowHeight
                       resultBlock:(GTUIDateResultBlock)resultBlock
                       cancelBlock:(GTUIDateCancelBlock)cancelBlock {

    [self showDatePickerWithTitle:title
                            dateType:dateType
                     defaultSelValue:defaultSelValue
                             minDate:minDate maxDate:maxDate
                        isAutoSelect:isAutoSelect
                           lineColor:lineColor
                           rowHeight:rowHeight
                   leftBtnTitleColor:nil
                  rightBtnTitleColor:nil
                         resultBlock:resultBlock
                         cancelBlock:cancelBlock];
}


#pragma mark - 5.显示时间选择器（支持 设置自动选择、最大值、最小值、自定义分割线颜色、行高、按钮的颜色、取消选择的回调）
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                           minDate:(NSDate *)minDate
                           maxDate:(NSDate *)maxDate
                      isAutoSelect:(BOOL)isAutoSelect
                         lineColor:(UIColor *)lineColor
                         rowHeight:(CGFloat)rowHeight
                 leftBtnTitleColor:(UIColor *)leftBtnTitleColor
                rightBtnTitleColor:(UIColor *)rightBtnTitleColor
                       resultBlock:(GTUIDateResultBlock)resultBlock
                       cancelBlock:(GTUIDateCancelBlock)cancelBlock {
    [self showDatePickerWithTitle:title
                            dateType:dateType
                     defaultSelValue:defaultSelValue
                             minDate:minDate
                             maxDate:maxDate
                        isAutoSelect:isAutoSelect
                           lineColor:lineColor
                           rowHeight:rowHeight
                   leftBtnTitleColor:leftBtnTitleColor
                  rightBtnTitleColor:rightBtnTitleColor
                 selecteRowTextColor:nil
                    selectRowBGColor:nil
                         resultBlock:resultBlock
                         cancelBlock:cancelBlock];
}

#pragma mark - 6.显示时间选择器（支持 设置自动选择、最大值、最小值、自定义分割线颜色、选中文本行颜色、行高、按钮的颜色、取消选择的回调）
+ (void)showDatePickerWithTitle:(NSString *)title
                          dateType:(GTUIDatePickerMode)dateType
                   defaultSelValue:(NSString *)defaultSelValue
                           minDate:(NSDate *)minDate
                           maxDate:(NSDate *)maxDate
                      isAutoSelect:(BOOL)isAutoSelect
                         lineColor:(UIColor *)lineColor
                         rowHeight:(CGFloat)rowHeight
                 leftBtnTitleColor:(UIColor *)leftBtnTitleColor
                rightBtnTitleColor:(UIColor *)rightBtnTitleColor
               selecteRowTextColor:(UIColor *)selecteRowTextColor
                  selectRowBGColor:(UIColor *)selectRowBGColor
                       resultBlock:(GTUIDateResultBlock)resultBlock
                       cancelBlock:(GTUIDateCancelBlock)cancelBlock {
    GTUIDatePickerView *datePickerView = [[GTUIDatePickerView alloc] initWithTitle:title
                                                                      dateType:dateType
                                                               defaultSelValue:defaultSelValue
                                                                       minDate:minDate
                                                                       maxDate:maxDate
                                                                     lineColor:lineColor
                                                                     rowHeight:rowHeight
                                                                  isAutoSelect:isAutoSelect
                                                             leftBtnTitleColor:leftBtnTitleColor
                                                            rightBtnTitleColor:rightBtnTitleColor
                                                           selecteRowTextColor:selecteRowTextColor
                                                              selectRowBGColor:selectRowBGColor
                                                                   resultBlock:resultBlock
                                                                   cancelBlock:cancelBlock];
    [datePickerView showPickerViewWithAnimation:YES];
}

#pragma mark - 初始化时间选择器
- (instancetype)initWithTitle:(NSString *)title
                     dateType:(GTUIDatePickerMode)pickerMode
              defaultSelValue:(NSString *)defaultSelValue
                      minDate:(NSDate *)minDate
                      maxDate:(NSDate *)maxDate
                    lineColor:(UIColor *)lineColor
                    rowHeight:(CGFloat)rowHeight
                 isAutoSelect:(BOOL)isAutoSelect
            leftBtnTitleColor:(UIColor *)leftBtnTitleColor
           rightBtnTitleColor:(UIColor *)rightBtnTitleColor
          selecteRowTextColor:(UIColor *)selecteRowTextColor
             selectRowBGColor:(UIColor *)selectRowBGColor
                  resultBlock:(GTUIDateResultBlock)resultBlock
                  cancelBlock:(GTUIDateCancelBlock)cancelBlock{

    if (self = [super init]) {
        _title                      = title;
        _isAutoSelect               = isAutoSelect;
        _resultBlock                = resultBlock;
        _cancelBlock                = cancelBlock;
        self.pickerMode             = pickerMode;
        self.lineColor              = lineColor;
        self.rowHeight              = rowHeight ? rowHeight : 35.0f;
        self.selecteRowTextColor    = selecteRowTextColor;
        self.selectRowBGColor       = selectRowBGColor;
        // 配置按钮的文本颜色
        if (leftBtnTitleColor || rightBtnTitleColor) {

            [self setUpConfirmTitleColor:rightBtnTitleColor cancelColor:leftBtnTitleColor];
        }

        [self setupSelectDateFormatter:pickerMode];
        // 设置最小值限制
        if (minDate) {
            self.minLimitDate   = minDate;
        }else{

            if (self.pickerMode == GTUIDatePickerModeTime || self.pickerMode == GTUIDatePickerModeCountDownTimer || self.pickerMode == GTUIDatePickerModeHM) {
                self.pickerMode = GTUIDatePickerModeHM;
                self.minLimitDate = [NSDate gt_setHour:0 minute:0];
            }else if (self.pickerMode == GTUIDatePickerModeMDHM){
                self.minLimitDate = [NSDate gt_setMonth:1 day:1 hour:0 minute:0];
            }else if (self.pickerMode == GTUIDatePickerModeMD){
                self.minLimitDate = [NSDate gt_setMonth:1 day:1];
            }else{
                self.minLimitDate = [NSDate distantPast]; // 遥远的过去的一个时间点
            }

        }

        // 最大值限制
        if (maxDate) {

            self.maxLimitDate = maxDate;
        }else{
            if (self.pickerMode == GTUIDatePickerModeTime || self.pickerMode == GTUIDatePickerModeCountDownTimer || self.pickerMode == GTUIDatePickerModeHM) {

                self.maxLimitDate = [NSDate gt_setHour:23 minute:59];

            } else if (self.pickerMode == GTUIDatePickerModeMDHM) {

                self.maxLimitDate = [NSDate gt_setMonth:12 day:31 hour:23 minute:59];

            } else if (self.pickerMode == GTUIDatePickerModeMD) {

                self.maxLimitDate = [NSDate gt_setMonth:12 day:31];

            } else {

                self.maxLimitDate = [NSDate distantFuture]; // 遥远的未来的一个时间点
            }
        }

        BOOL minMOreThanMax = [self.minLimitDate gt_compare:self.maxLimitDate format:self.selectDateFormatter] == NSOrderedDescending;

        NSAssert(!minMOreThanMax, @"最小日期不能大于最大日期!");

        if (minMOreThanMax) {
            // 如果最小日期大于了最大日期，就忽略两个值
            self.minLimitDate = [NSDate distantPast];
            self.maxLimitDate = [NSDate distantFuture];
        }


        // 默认选中的日期

        if (defaultSelValue && defaultSelValue.length > 0) {

            NSDate *defaultSelDate  = [NSDate gt_getDate:defaultSelValue format:self.selectDateFormatter];
            if (!defaultSelDate) {
                NSLog(@"参数格式错误！参数 defaultSelValue 的正确格式是：%@", self.selectDateFormatter);
                NSAssert(defaultSelDate, @"参数格式错误！请检查形参 defaultSelValue 的格式");
                defaultSelDate = [NSDate date]; // 默认值参数格式错误时，重置/忽略默认值，防止在 Release 环境下崩溃！
            }

            if (self.pickerMode == GTUIDatePickerModeTime || self.pickerMode == GTUIDatePickerModeCountDownTimer || self.pickerMode == GTUIDatePickerModeHM) {
                self.selectDate = [NSDate gt_setHour:defaultSelDate.gt_hour minute:defaultSelDate.gt_minute];
            } else if (self.pickerMode == GTUIDatePickerModeMDHM) {
                self.selectDate = [NSDate gt_setMonth:defaultSelDate.gt_month day:defaultSelDate.gt_day hour:defaultSelDate.gt_hour minute:defaultSelDate.gt_minute];
            } else if (self.pickerMode == GTUIDatePickerModeMD) {
                self.selectDate = [NSDate gt_setMonth:defaultSelDate.gt_month day:defaultSelDate.gt_day];
            } else {
                self.selectDate = defaultSelDate;
            }
        }else {
            // 不设置默认日期，就默认选中今天的日期
            self.selectDate = [NSDate date];
        }

        BOOL selectLessThanMin = [self.selectDate gt_compare:self.minLimitDate format:self.selectDateFormatter] == NSOrderedAscending;
        BOOL selectMoreThanMax = [self.selectDate gt_compare:self.maxLimitDate format:self.selectDateFormatter] == NSOrderedDescending;
        NSAssert(!selectLessThanMin, @"默认选择的日期不能小于最小日期！");
        NSAssert(!selectMoreThanMax, @"默认选择的日期不能大于最大日期！");
        if (selectLessThanMin) {
            self.selectDate = self.minLimitDate;
        }
        if (selectMoreThanMax) {
            self.selectDate = self.maxLimitDate;
        }

#ifdef DEBUG
        NSLog(@"最小时间date：%@", self.minLimitDate);
        NSLog(@"默认时间date：%@", self.selectDate);
        NSLog(@"最大时间date：%@", self.maxLimitDate);

        NSLog(@"最小时间：%@", [NSDate gt_getDateString:self.minLimitDate format:self.selectDateFormatter]);
        NSLog(@"默认时间：%@", [NSDate gt_getDateString:self.selectDate format:self.selectDateFormatter]);
        NSLog(@"最大时间：%@", [NSDate gt_getDateString:self.maxLimitDate format:self.selectDateFormatter]);
#endif

        if (self.pickerStyle == GTUIDatePickerStyleCustom) {
            [self initDefaultDateArray];
        }
        [self initWithAllView];

        // 默认滚动的行
        if (self.pickerStyle == GTUIDatePickerStyleSystem) {
            [self.datePicker setDate:self.selectDate animated:NO];
        } else if (self.pickerStyle == GTUIDatePickerStyleCustom) {
            [self scrollToSelectDate:self.selectDate animated:NO];
        }
    }
    return self;
}

- (void)setupSelectDateFormatter:(GTUIDatePickerMode)mode{
    switch (mode) {
        case GTUIDatePickerModeTime:
        {
            self.selectDateFormatter = @"HH:mm";
            self.pickerStyle = GTUIDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeTime;
        }
            break;
        case GTUIDatePickerModeDate:
        {
            self.selectDateFormatter = @"yyyy-MM-dd";
            self.pickerStyle = GTUIDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeDate;
        }
            break;
        case GTUIDatePickerModeDateAndTime:
        {
            self.selectDateFormatter = @"yyyy-MM-dd HH:mm";
            self.pickerStyle = GTUIDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeDateAndTime;
        }
            break;
        case GTUIDatePickerModeCountDownTimer:
        {
            self.selectDateFormatter = @"HH:mm";
            self.pickerStyle = GTUIDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeCountDownTimer;
        }
            break;

        case GTUIDatePickerModeYMDHM:
        {
            self.selectDateFormatter = @"yyyy-MM-dd HH:mm";
            self.pickerStyle = GTUIDatePickerStyleCustom;
        }
            break;
        case GTUIDatePickerModeMDHM:
        {
            self.selectDateFormatter = @"MM-dd HH:mm";
            self.pickerStyle = GTUIDatePickerStyleCustom;
        }
            break;
        case GTUIDatePickerModeYMD:
        {
            self.selectDateFormatter = @"yyyy-MM-dd";
            self.pickerStyle = GTUIDatePickerStyleCustom;
        }
            break;
        case GTUIDatePickerModeYM:
        {
            self.selectDateFormatter = @"yyyy-MM";
            self.pickerStyle = GTUIDatePickerStyleCustom;
        }
            break;
        case GTUIDatePickerModeY:
        {
            self.selectDateFormatter = @"yyyy";
            self.pickerStyle = GTUIDatePickerStyleCustom;
        }
            break;
        case GTUIDatePickerModeMD:
        {
            self.selectDateFormatter = @"MM-dd";
            self.pickerStyle = GTUIDatePickerStyleCustom;
        }
            break;
        case GTUIDatePickerModeHM:
        {
            self.selectDateFormatter = @"HH:mm";
            self.pickerStyle = GTUIDatePickerStyleCustom;
        }
            break;

        default:
            break;
    }
}

#pragma mark - 初始化子视图
- (void)initWithAllView {
    [super initWithAllView];
    self.titleLab.text = _title;
    // 添加时间选择器
    if (self.pickerStyle == GTUIDatePickerStyleSystem) {
        [self.alertView addSubview:self.datePicker];
    } else if (self.pickerStyle == GTUIDatePickerStyleCustom) {
        [self.alertView addSubview:self.pickerView];
    }

}


#pragma mark - 设置日期数据源数组
- (void)initDefaultDateArray {
    // 1. 设置 yearArr 数组
    [self setupYearArr];
    // 2.设置 monthArr 数组
    [self setupMonthArr:self.selectDate.gt_year];
    // 3.设置 dayArr 数组
    [self setupDayArr:self.selectDate.gt_year month:self.selectDate.gt_month];
    // 4.设置 hourArr 数组
    [self setupHourArr:self.selectDate.gt_year month:self.selectDate.gt_month day:self.selectDate.gt_day];
    // 5.设置 minuteArr 数组
    [self setupMinuteArr:self.selectDate.gt_year month:self.selectDate.gt_month day:self.selectDate.gt_day hour:self.selectDate.gt_hour];
    // 根据 默认选择的日期 计算出 对应的索引
    _yearIndex = self.selectDate.gt_year - self.minLimitDate.gt_year;
    _monthIndex = self.selectDate.gt_month - ((_yearIndex == 0) ? self.minLimitDate.gt_month : 1);
    _dayIndex = self.selectDate.gt_day - ((_yearIndex == 0 && _monthIndex == 0) ? self.minLimitDate.gt_day : 1);
    _hourIndex = self.selectDate.gt_hour - ((_yearIndex == 0 && _monthIndex == 0 && _dayIndex == 0) ? self.minLimitDate.gt_hour : 0);
    _minuteIndex = self.selectDate.gt_minute - ((_yearIndex == 0 && _monthIndex == 0 && _dayIndex == 0 && _hourIndex == 0) ? self.minLimitDate.gt_minute : 0);

}
#pragma mark - 滚动到指定的时间位置
- (void)scrollToSelectDate:(NSDate *)selectDate animated:(BOOL)animated {
    // 根据 当前选择的日期 计算出 对应的索引
    NSInteger yearIndex = selectDate.gt_year - self.minLimitDate.gt_year;
    NSInteger monthIndex = selectDate.gt_month - ((yearIndex == 0) ? self.minLimitDate.gt_month : 1);
    NSInteger dayIndex = selectDate.gt_day - ((yearIndex == 0 && monthIndex == 0) ? self.minLimitDate.gt_day : 1);
    NSInteger hourIndex = selectDate.gt_hour - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0) ? self.minLimitDate.gt_hour : 0);
    NSInteger minuteIndex = selectDate.gt_minute - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0 && hourIndex == 0) ? self.minLimitDate.gt_minute : 0);

    NSArray *indexArr = [NSArray array];
    if (self.pickerMode == GTUIDatePickerModeYMDHM) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex)];
    } else if (self.pickerMode == GTUIDatePickerModeMDHM) {
        indexArr = @[@(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex)];
    } else if (self.pickerMode == GTUIDatePickerModeYMD) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex)];
    } else if (self.pickerMode == GTUIDatePickerModeYM) {
        indexArr = @[@(yearIndex), @(monthIndex)];
    } else if (self.pickerMode == GTUIDatePickerModeY) {
        indexArr = @[@(yearIndex)];
    } else if (self.pickerMode == GTUIDatePickerModeMD) {
        indexArr = @[@(monthIndex), @(dayIndex)];
    } else if (self.pickerMode == GTUIDatePickerModeHM) {
        indexArr = @[@(hourIndex), @(minuteIndex)];
    }
    for (NSInteger i = 0; i < indexArr.count; i++) {

        [self.pickerView selectRow:[indexArr[i] integerValue] inComponent:i animated:animated];

        //保存选中的行
        [self.selectedRowCache setObject:@([indexArr[i] integerValue]) forKey:@(i)];
    }
}
#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
// pickerView 有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (self.pickerMode) {
        case GTUIDatePickerModeYMDHM:
            return 5;
            break;
        case GTUIDatePickerModeMDHM:
            return 4;
            break;
        case GTUIDatePickerModeYMD:
            return 3;
            break;
        case GTUIDatePickerModeYM:
            return 2;
            break;
        case GTUIDatePickerModeY:
            return 1;
            break;
        case GTUIDatePickerModeMD:
            return 2;
            break;
        case GTUIDatePickerModeHM:
            return 2;
            break;

        default:
            break;
    }
    return 0;
}
// pickerView 表盘上有多少行

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray * rowsArr = [NSArray array];
    switch (self.pickerMode) {
        case GTUIDatePickerModeYMDHM:
            rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count)];
            break;
        case GTUIDatePickerModeMDHM:
            rowsArr = @[@(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count)];
            break;
        case GTUIDatePickerModeYMD:
            rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count)];
            break;
        case GTUIDatePickerModeYM:
            rowsArr = @[@(self.yearArr.count), @(self.monthArr.count)];
            break;
        case GTUIDatePickerModeY:
            rowsArr = @[@(self.yearArr.count)];
            break;
        case GTUIDatePickerModeMD:
            rowsArr = @[@(self.monthArr.count), @(self.dayArr.count)];
            break;
        case GTUIDatePickerModeHM:
            rowsArr = @[@(self.hourArr.count), @(self.minuteArr.count)];
            break;

        default:
            break;
    }
    return [rowsArr[component] integerValue];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    //设置分割线的颜色
    if (self.lineColor) {
        // 设置分割线的颜色
        ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = self.lineColor;
        ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = self.lineColor;
    }

    // 设置选中行的背景色
    if (self.selectRowBGColor) {
        [self setUpPickerView:pickerView customSelectedBGRowColor:self.selectRowBGColor];
    }

    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20.0f * kScaleFit];
        // 字体自适应属性
        label.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        label.minimumScaleFactor = 0.5f;

        NSInteger selected = [(NSNumber *)[self.selectedRowCache objectForKey:@(component)] integerValue];
        // 设置选中行的文本颜色
        if (self.selecteRowTextColor && selected == row) {
            [label setTextColor:self.selecteRowTextColor];
        };
    }

    [self setDateLabelText:label component:component row:row];

    return label;
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.rowHeight * kScaleFit;
}

#pragma mark - 配置背景色
- (void)setUpPickerView:(UIPickerView *)pickerView customSelectedBGRowColor:(UIColor *)color
{
    NSArray *subviews = pickerView.subviews;
    if (!(subviews.count > 0)) {
        return;
    }
    if (!color) {
        return;
    }
    NSArray *coloms = subviews.firstObject;
    if (coloms) {
        NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
        if (subviewCache.count > 0) {
            UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
            if (middleContainerView) {
                middleContainerView.backgroundColor = color;
            }
        }
    }
}

// 4.选中时回调的委托方法，在此方法中实现省份和城市间的联动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    //保存选中的行
    [self.selectedRowCache setObject:@(row) forKey:@(component)];

    [self.pickerView reloadComponent:component];

    // 获取滚动后选择的日期
    self.selectDate = [self getDidSelectedDate:component row:row];
    // 设置是否开启自动回调
    if (_isAutoSelect) {
        // 滚动完成后，执行block回调
        if (self.resultBlock) {
            NSString *selectDateValue = [NSDate gt_getDateString:self.selectDate format:self.selectDateFormatter];
            self.resultBlock(selectDateValue);
        }
    }

}

#pragma mark - 设置pickerView 每一行的文字显示
- (void)setDateLabelText:(UILabel *)label component:(NSInteger)component row:(NSInteger)row {

    switch (self.pickerMode) {
        case GTUIDatePickerModeYMDHM:
            if (component == 0) {
                label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
            } else if (component == 1) {
                label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
            } else if (component == 2) {
                label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
            } else if (component == 3) {
                label.text = [NSString stringWithFormat:@"%@时", self.hourArr[row]];
            } else if (component == 4) {
                label.text = [NSString stringWithFormat:@"%@分", self.minuteArr[row]];
            }
            break;
        case GTUIDatePickerModeMDHM:
            if (component == 0) {
                label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
            } else if (component == 1) {
                label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
            } else if (component == 2) {
                label.text = [NSString stringWithFormat:@"%@时", self.hourArr[row]];
            } else if (component == 3) {
                label.text = [NSString stringWithFormat:@"%@分", self.minuteArr[row]];
            }
            break;
        case GTUIDatePickerModeYMD:
            if (component == 0) {
                label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
            } else if (component == 1) {
                label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
            } else if (component == 2) {
                label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
            }
            break;
        case GTUIDatePickerModeYM:
            if (component == 0) {
                label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
            } else if (component == 1) {
                label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
            }
            break;
        case GTUIDatePickerModeY:
            if (component == 0) {
                label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
            }
            break;
        case GTUIDatePickerModeMD:
            if (component == 0) {
                label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
            } else if (component == 1) {
                label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
            }
            break;
        case GTUIDatePickerModeHM:
            if (component == 0) {
                label.text = [NSString stringWithFormat:@"%@时", self.hourArr[row]];
            } else if (component == 1) {
                label.text = [NSString stringWithFormat:@"%@分", self.minuteArr[row]];
            }
            break;

        default:
            break;
    }
}


- (NSDate *)getDidSelectedDate:(NSInteger)component row:(NSInteger)row {

    NSString *selectDateValue = nil;
    switch (self.pickerMode) {
        case GTUIDatePickerModeYMDHM:
            if (component == 0) {
                _yearIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:1];
                [self.pickerView reloadComponent:2];
                [self.pickerView reloadComponent:3];
                [self.pickerView reloadComponent:4];

            } else if (component == 1) {
                _monthIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:2];
                [self.pickerView reloadComponent:3];
                [self.pickerView reloadComponent:4];
            } else if (component == 2) {
                _dayIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:3];
                [self.pickerView reloadComponent:4];
            } else if (component == 3) {
                _hourIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:4];
            } else if (component == 4) {
                _minuteIndex = row;
            }
            selectDateValue = [NSString stringWithFormat:@"%@-%02ld-%02ld %02ld:%02ld", self.yearArr[_yearIndex], (long)[self.monthArr[_monthIndex] integerValue], (long)[self.dayArr[_dayIndex] integerValue], (long)[self.hourArr[_hourIndex] integerValue], (long)[self.minuteArr[_minuteIndex] integerValue]];
            break;
        case GTUIDatePickerModeMDHM:
            if (component == 0) {
                _monthIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:1];
                [self.pickerView reloadComponent:2];
                [self.pickerView reloadComponent:3];
            } else if (component == 1) {
                _dayIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:2];
                [self.pickerView reloadComponent:3];
            } else if (component == 2) {
                _hourIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:3];
            } else if (component == 3) {
                _minuteIndex = row;
            }
            selectDateValue = [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld", (long)[self.monthArr[_monthIndex] integerValue], (long)[self.dayArr[_dayIndex] integerValue], (long)[self.hourArr[_hourIndex] integerValue], (long)[self.minuteArr[_minuteIndex] integerValue]];
            break;
        case GTUIDatePickerModeYMD:
            if (component == 0) {
                _yearIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:1];
                [self.pickerView reloadComponent:2];
            } else if (component == 1) {
                _monthIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:2];
            } else if (component == 2) {
                _dayIndex = row;
            }
            selectDateValue = [NSString stringWithFormat:@"%@-%02ld-%02ld", self.yearArr[_yearIndex], (long)[self.monthArr[_monthIndex] integerValue], (long)[self.dayArr[_dayIndex] integerValue]];
            break;
        case GTUIDatePickerModeYM:
            if (component == 0) {
                _yearIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:1];
            } else if (component == 1) {
                _monthIndex = row;
            }
            selectDateValue = [NSString stringWithFormat:@"%@-%02ld", self.yearArr[_yearIndex], (long)[self.monthArr[_monthIndex] integerValue]];
            break;
        case GTUIDatePickerModeY:
            if (component == 0) {
                _yearIndex = row;
            }
            selectDateValue = [NSString stringWithFormat:@"%@", self.yearArr[_yearIndex]];
            break;
        case GTUIDatePickerModeMD:
            if (component == 0) {
                _monthIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:1];
            } else if (component == 1) {
                _dayIndex = row;
            }
            selectDateValue = [NSString stringWithFormat:@"%02ld-%02ld", (long)[self.monthArr[_monthIndex] integerValue], (long)[self.dayArr[_dayIndex] integerValue]];
            break;
        case GTUIDatePickerModeHM:
            if (component == 0) {
                _hourIndex = row;
                [self updateDateArray];
                [self.pickerView reloadComponent:1];
            } else if (component == 1) {
                _minuteIndex = row;
            }
            selectDateValue = [NSString stringWithFormat:@"%02ld:%02ld", (long)[self.hourArr[_hourIndex] integerValue], (long)[self.minuteArr[_minuteIndex] integerValue]];
            break;

        default:
            break;
    }
    return [NSDate gt_getDate:selectDateValue format:self.selectDateFormatter];
}

#pragma mark - 更新日期数据源数组
- (void)updateDateArray {
    NSInteger year = [self.yearArr[_yearIndex] integerValue];
    // 1.设置 monthArr 数组
    [self setupMonthArr:year];
    // 更新索引：防止更新 monthArr 后数组越界
    _monthIndex = (_monthIndex > self.monthArr.count - 1) ? (self.monthArr.count - 1) : _monthIndex;

    NSInteger month = [self.monthArr[_monthIndex] integerValue];
    // 2.设置 dayArr 数组
    [self setupDayArr:year month:month];
    // 更新索引：防止更新 dayArr 后数组越界
    _dayIndex = (_dayIndex > self.dayArr.count - 1) ? (self.dayArr.count - 1) : _dayIndex;

    NSInteger day = [self.dayArr[_dayIndex] integerValue];
    // 3.设置 hourArr 数组
    [self setupHourArr:year month:month day:day];
    // 更新索引：防止更新 hourArr 后数组越界
    _hourIndex = (_hourIndex > self.hourArr.count - 1) ? (self.hourArr.count - 1) : _hourIndex;

    NSInteger hour = [self.hourArr[_hourIndex] integerValue];
    // 4.设置 minuteArr 数组
    [self setupMinuteArr:year month:month day:day hour:hour];
    // 更新索引：防止更新 monthArr 后数组越界
    _minuteIndex = (_minuteIndex > self.minuteArr.count - 1) ? (self.minuteArr.count - 1) : _minuteIndex;
}

// 设置 yearArr 数组
- (void)setupYearArr {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = self.minLimitDate.gt_year; i <= self.maxLimitDate.gt_year; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.yearArr = [tempArr copy];
}


// 设置 monthArr 数组
- (void)setupMonthArr:(NSInteger)year {
    NSInteger startMonth = 1;
    NSInteger endMonth = 12;
    if (year == self.minLimitDate.gt_year) {
        startMonth = self.minLimitDate.gt_month;
    }
    if (year == self.maxLimitDate.gt_year) {
        endMonth = self.maxLimitDate.gt_month;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endMonth - startMonth + 1)];
    for (NSInteger i = startMonth; i <= endMonth; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.monthArr = [tempArr copy];
}

// 设置 dayArr 数组
- (void)setupDayArr:(NSInteger)year month:(NSInteger)month {
    NSInteger startDay = 1;
    NSInteger endDay = [NSDate gt_getDaysInYear:year month:month];
    if (year == self.minLimitDate.gt_year && month == self.minLimitDate.gt_month) {
        startDay = self.minLimitDate.gt_day;
    }
    if (year == self.maxLimitDate.gt_year && month == self.maxLimitDate.gt_month) {
        endDay = self.maxLimitDate.gt_day;
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = startDay; i <= endDay; i++) {
        [tempArr addObject:[NSString stringWithFormat:@"%zi",(long)i]];
    }
    self.dayArr = [tempArr copy];
}

// 设置 hourArr 数组
- (void)setupHourArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSInteger startHour = 0;
    NSInteger endHour = 23;
    if (year == self.minLimitDate.gt_year && month == self.minLimitDate.gt_month && day == self.minLimitDate.gt_day) {
        startHour = self.minLimitDate.gt_hour;
    }
    if (year == self.maxLimitDate.gt_year && month == self.maxLimitDate.gt_month && day == self.maxLimitDate.gt_day) {
        endHour = self.maxLimitDate.gt_hour;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endHour - startHour + 1)];
    for (NSInteger i = startHour; i <= endHour; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.hourArr = [tempArr copy];
}

// 设置 minuteArr 数组
- (void)setupMinuteArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
    NSInteger startMinute = 0;
    NSInteger endMinute = 59;
    if (year == self.minLimitDate.gt_year && month == self.minLimitDate.gt_month && day == self.minLimitDate.gt_day && hour == self.minLimitDate.gt_hour) {
        startMinute = self.minLimitDate.gt_minute;
    }
    if (year == self.maxLimitDate.gt_year && month == self.maxLimitDate.gt_month && day == self.maxLimitDate.gt_day && hour == self.maxLimitDate.gt_hour) {
        endMinute = self.maxLimitDate.gt_minute;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endMinute - startMinute + 1)];
    for (NSInteger i = startMinute; i <= endMinute; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.minuteArr = [tempArr copy];
}

#pragma mark - 时间选择器的滚动响应事件
- (void)didSelectValueChanged:(UIDatePicker *)sender {
    self.selectDate = sender.date;
    BOOL selectLessThanMin = [self.selectDate gt_compare:self.minLimitDate format:self.selectDateFormatter] == NSOrderedAscending;
    BOOL selectMoreThanMax = [self.selectDate gt_compare:self.maxLimitDate format:self.selectDateFormatter] == NSOrderedDescending;

    if (selectLessThanMin) {
        self.selectDate = self.minLimitDate;
    }
    if (selectMoreThanMax) {
        self.selectDate = self.maxLimitDate;
    }
    [self.datePicker setDate:self.selectDate animated:YES];

    // 设置是否开启自动回调
    if (_isAutoSelect) {
        // 滚动完成后，执行block回调
        if (self.resultBlock) {
            NSString *selectDateValue = [NSDate gt_getDateString:self.selectDate format:self.selectDateFormatter];
            self.resultBlock(selectDateValue);
        }
    }
}


#pragma mark - 背景视图的点击事件
- (void)backViewTapAction:(UITapGestureRecognizer *)sender {
    [self dismissPickerViewWithAnimation:NO];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 右边按钮点击事件
-(void)rightBtnClickAction:(UIButton *)sender{
    // 点击确定按钮后，执行block回调
    [self dismissPickerViewWithAnimation:YES];
    if (self.resultBlock) {
        NSString *selectDateValue = [NSDate gt_getDateString:self.selectDate format:self.selectDateFormatter];
        self.resultBlock(selectDateValue);
    }
}

#pragma mark - 左边按钮点击事件
-(void)leftBtnClickAction:(UIButton *)sender{
    [self dismissPickerViewWithAnimation:YES];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 弹出窗口
-(void)showPickerViewWithAnimation:(BOOL)animation{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];

    if (animation) {
        CGRect rect = self.alertView.frame;
        rect.origin.y = ScreenHeight;
        self.alertView.frame = rect;

        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kGTPickerHeight + kGTTopViewHeight + GTUIDeviceBottomSafeAreaInset();
            self.alertView.frame = rect;
        }];
    }
}
#pragma mark - 关闭视图方法
- (void)dismissPickerViewWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kGTPickerHeight + kGTTopViewHeight + GTUIDeviceBottomSafeAreaInset();
        self.alertView.frame = rect;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Getter && Setter
#pragma mark - 时间选择器 系统样式
-(UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kGTTopViewHeight + 0.5, self.alertView.frame.size.width, kGTPickerHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth ;
        _datePicker.datePickerMode = _datePickerMode;
        // 设置 datepicker 的国际化 locale, 以简体中文显示日期
        _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CHS_CN"];
        // 设置时间范围
        if (self.minLimitDate) {
            _datePicker.minimumDate = self.minLimitDate;
        }
        if (self.maxLimitDate) {
            _datePicker.maximumDate = self.maxLimitDate;
        }
        // 滚动改变值的响应事件
        [_datePicker addTarget:self action:@selector(didSelectValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - 时间选择器  自定义 pickerView
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kGTTopViewHeight + 0.5, self.alertView.frame.size.width, kGTPickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        // 设置子视图的大小随着父视图变化
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

-(NSMutableDictionary *)selectedRowCache{
    if (!_selectedRowCache) {
        _selectedRowCache =[NSMutableDictionary dictionary];
    }
    return _selectedRowCache;
}
- (NSArray *)yearArr {
    if (!_yearArr) {
        _yearArr = [NSArray array];
    }
    return _yearArr;
}

- (NSArray *)monthArr {
    if (!_monthArr) {
        _monthArr = [NSArray array];
    }
    return _monthArr;
}

- (NSArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSArray array];
    }
    return _dayArr;
}

- (NSArray *)hourArr {
    if (!_hourArr) {
        _hourArr = [NSArray array];
    }
    return _hourArr;
}

- (NSArray *)minuteArr {
    if (!_minuteArr) {
        _minuteArr = [NSArray array];
    }
    return _minuteArr;
}
@end
