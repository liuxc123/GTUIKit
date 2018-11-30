//
//  GTUIAddressPickerView.h
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "GTUIBasePickerView.h"
#import "GTAddressModel.h"

typedef NS_ENUM(NSUInteger, GTUIAddressPickerMode) {
    GTUIAddressPickerModeProvince,
    GTUIAddressPickerModeCity,
    GTUIAddressPickerModeArea
};


typedef void(^GTUIAddressResultBlock)(GTProvinceModel *province, GTCityModel *city, GTAreaModel *area);
typedef void(^GTUIAddressCancelBlock)(void);

@interface GTUIAddressPickerView : GTUIBasePickerView

/**
 *  1.显示地址选择器
 *
 *  @param defaultSeleArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param resultBlock              选择后的回调
 *
 */
+(void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSeleArr
                                   resuleBlock:(GTUIAddressResultBlock)resultBlock;
/**
 *  2.显示地址选择器（支持 设置自动选择 和 自定义主题颜色）
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值

 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                   isAutoSelect:(BOOL)isAutoSelect
                                    resultBlock:(GTUIAddressResultBlock)resultBlock;

/**
 *  3.显示地址选择器（支持 设置选择器类型、设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param pickerMode                 地址选择器显示类型
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock              选择后的回调
 *  @param cancelBlock              取消选择的回调
 *
 */
+ (void)showAddressPickerWithShowType:(GTUIAddressPickerMode)pickerMode
                         defaultSelected:(NSArray *)defaultSelectedArr
                            isAutoSelect:(BOOL)isAutoSelect
                             resultBlock:(GTUIAddressResultBlock)resultBlock
                             cancelBlock:(GTUIAddressCancelBlock)cancelBlock;

/**
 *  4.显示地址选择器（支持 设置选择器类型、传入地区数据源、设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param pickerMode                 地址选择器显示类型
 *  @param dataSource               地区数据源
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock              选择后的回调
 *  @param cancelBlock              取消选择的回调
 *
 */
+ (void)showAddressPickerWithShowType:(GTUIAddressPickerMode)pickerMode
                              dataSource:(NSArray *)dataSource
                         defaultSelected:(NSArray *)defaultSelectedArr
                            isAutoSelect:(BOOL)isAutoSelect
                             resultBlock:(GTUIAddressResultBlock)resultBlock
                             cancelBlock:(GTUIAddressCancelBlock)cancelBlock;

/**
 *  5.显示地址选择器（支持 设置选择器类型、传入地区数据源、设置自动选择、自定义分割线/文本/行背景颜色、,取消选择的回调）
 *
 *  @param pickerMode                 地址选择器显示类型
 *  @param dataSource               地区数据源
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param lineColor                分割线颜色
 *  @param selectRowTextColor       选中行的文本颜色
 *  @param selectRowBGColor         选中行的背景颜色
 *  @param resultBlock              选择后的回调
 *  @param cancelBlock              取消选择的回调
 *
 */
+ (void)showAddressPickerWithShowType:(GTUIAddressPickerMode)pickerMode
                              dataSource:(NSArray *)dataSource
                         defaultSelected:(NSArray *)defaultSelectedArr
                            isAutoSelect:(BOOL)isAutoSelect
                               lineColor:(UIColor *)lineColor
                      selectRowTextColor:(UIColor *)selectRowTextColor
                        selectRowBGColor:(UIColor *)selectRowBGColor
                             resultBlock:(GTUIAddressResultBlock)resultBlock
                             cancelBlock:(GTUIAddressCancelBlock)cancelBlock;


/**
 *  6.显示地址选择器（支持 设置选择器类型、传入地区数据源、设置自动选择、自定义分割线/文本/行背景颜色、按钮颜色、行高、取消选择的回调）
 *
 *  @param pickerMode                 地址选择器显示类型
 *  @param dataSource               地区数据源
 *  @param defaultSelectedArr       默认选中的值(传数组，如：@[@"浙江省", @"杭州市", @"西湖区"])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param lineColor                分割线颜色
 *  @param selectRowTextColor       选中行的文本颜色
 *  @param selectRowBGColor         选中行的背景颜色
 *  @param confirmBtnTitleColor     确认按钮颜色
 *  @param cancelBtnTitleColor      取消按钮颜色
 *  @param rowHeight                行高
 *  @param resultBlock              选择后的回调
 *  @param cancelBlock              取消选择的回调
 *
 */
+ (void)showAddressPickerWithShowType:(GTUIAddressPickerMode)pickerMode
                              dataSource:(NSArray *)dataSource
                         defaultSelected:(NSArray *)defaultSelectedArr
                            isAutoSelect:(BOOL)isAutoSelect
                               lineColor:(UIColor *)lineColor
                      selectRowTextColor:(UIColor *)selectRowTextColor
                        selectRowBGColor:(UIColor *)selectRowBGColor
                    confirmBtnTitleColor:(UIColor *)confirmBtnTitleColor
                     cancelBtnTitleColor:(UIColor *)cancelBtnTitleColor
                               rowHeight:(CGFloat)rowHeight
                             resultBlock:(GTUIAddressResultBlock)resultBlock
                             cancelBlock:(GTUIAddressCancelBlock)cancelBlock;

@end
