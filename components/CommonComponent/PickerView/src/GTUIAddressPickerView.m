//
//  GTUIAddressPickerView.m
//  GTCatalog
//
//  Created by liuxc on 2018/11/30.
//

#import "GTUIAddressPickerView.h"
#import "private/GTPickerViewMacro.h"
#import "GTUIMetrics.h"

@interface GTUIAddressPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView *_selectBackView;
    BOOL _isDataSourceValid;    // 数据源是否合法
    NSInteger _provinceIndex;   // 记录省选中的位置
    NSInteger _cityIndex;       // 记录市选中的位置
    NSInteger _areaIndex;       // 记录区选中的位置
    NSArray * _defaultSelectedArr;
}
// 地址选择器
@property (nonatomic, strong) UIPickerView          *pickerView;
// 省模型数组
@property (nonatomic, strong) NSArray               *provinceArr;
// 市模型数组
@property (nonatomic, strong) NSArray               *cityArr;
// 区模型数组
@property (nonatomic, strong) NSArray               *areaArr;
// 数据源
@property (nonatomic, strong) NSArray               *dataSource;
// 选中的省
@property(nonatomic, strong) GTProvinceModel        *selectProvinceModel;
// 选中的市
@property(nonatomic, strong) GTCityModel            *selectCityModel;
// 选中的区
@property(nonatomic, strong) GTAreaModel            *selectAreaModel;
// 选中后的回调
@property (nonatomic, copy) GTUIAddressResultBlock    resultBlock;
// 取消选择的回调
@property (nonatomic, copy) GTUIAddressCancelBlock    cancelBlock;
// 展示类型
@property (nonatomic, assign) GTUIAddressPickerMode   pickerViewMode;
// 是否开启自动选择
@property (nonatomic, assign) BOOL                  isAutoSelect;
// 分割线的颜色
@property (nonatomic, strong) UIColor               *lineColor;
// 选中行文本的颜色
@property (nonatomic, strong) UIColor               *selecteRowTextColor;
// 选中行背景颜色
@property (nonatomic, strong) UIColor               *selectRowBGColor;
// 行高
@property (nonatomic, assign) CGFloat               rowHeight;
@end


@implementation GTUIAddressPickerView


#pragma mark - 1.显示地址选择器
+(void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSeleArr
                                   resuleBlock:(GTUIAddressResultBlock)resultBlock{

    [self showAddressPickerWithDefaultSelected:defaultSeleArr
                                     isAutoSelect:NO
                                      resultBlock:resultBlock];

}


+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                   isAutoSelect:(BOOL)isAutoSelect
                                    resultBlock:(GTUIAddressResultBlock)resultBlock{

    [self showAddressPickerWithShowType:GTUIAddressPickerModeArea
                           defaultSelected:defaultSelectedArr
                              isAutoSelect:isAutoSelect
                               resultBlock:resultBlock
                               cancelBlock:nil];

}
+ (void)showAddressPickerWithShowType:(GTUIAddressPickerMode)pickerMode
                         defaultSelected:(NSArray *)defaultSelectedArr
                            isAutoSelect:(BOOL)isAutoSelect
                             resultBlock:(GTUIAddressResultBlock)resultBlock
                             cancelBlock:(GTUIAddressCancelBlock)cancelBlock{

    [self showAddressPickerWithShowType:pickerMode
                                dataSource:nil
                           defaultSelected:defaultSelectedArr
                              isAutoSelect:isAutoSelect
                               resultBlock:resultBlock
                               cancelBlock:cancelBlock];
}

+ (void)showAddressPickerWithShowType:(GTUIAddressPickerMode)pickerMode
                              dataSource:(NSArray *)dataSource
                         defaultSelected:(NSArray *)defaultSelectedArr
                            isAutoSelect:(BOOL)isAutoSelect
                             resultBlock:(GTUIAddressResultBlock)resultBlock
                             cancelBlock:(GTUIAddressCancelBlock)cancelBlock{

    [self showAddressPickerWithShowType:pickerMode
                                dataSource:dataSource
                           defaultSelected:defaultSelectedArr
                              isAutoSelect:isAutoSelect
                                 lineColor:nil
                        selectRowTextColor:nil
                          selectRowBGColor:nil
                      confirmBtnTitleColor:nil
                       cancelBtnTitleColor:nil
                                 rowHeight:0
                               resultBlock:resultBlock
                               cancelBlock:cancelBlock];

}
+ (void)showAddressPickerWithShowType:(GTUIAddressPickerMode)pickerMode
                              dataSource:(NSArray *)dataSource
                         defaultSelected:(NSArray *)defaultSelectedArr
                            isAutoSelect:(BOOL)isAutoSelect
                               lineColor:(UIColor *)lineColor
                      selectRowTextColor:(UIColor *)selectRowTextColor
                        selectRowBGColor:(UIColor *)selectRowBGColor
                             resultBlock:(GTUIAddressResultBlock)resultBlock
                             cancelBlock:(GTUIAddressCancelBlock)cancelBlock{

    [self showAddressPickerWithShowType:pickerMode
                                dataSource:dataSource
                           defaultSelected:defaultSelectedArr
                              isAutoSelect:isAutoSelect
                                 lineColor:lineColor
                        selectRowTextColor:selectRowTextColor
                          selectRowBGColor:selectRowBGColor
                      confirmBtnTitleColor:nil
                       cancelBtnTitleColor:nil
                                 rowHeight:0
                               resultBlock:resultBlock
                               cancelBlock:cancelBlock];
}

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
                             cancelBlock:(GTUIAddressCancelBlock)cancelBlock{

    GTUIAddressPickerView *addressPickerView = [[GTUIAddressPickerView alloc]
                                              initWithShowPickerViewMode:pickerMode
                                              dataSource:dataSource
                                              defaultSelected:defaultSelectedArr
                                              isAutoSelected:isAutoSelect
                                              lineColor:lineColor
                                              selectRowTextColor:selectRowTextColor
                                              selectRowBGColor:selectRowBGColor
                                              confirmBtnTitleColor:confirmBtnTitleColor
                                              cancelBtnTitleColor:cancelBtnTitleColor
                                              rowHeight:rowHeight
                                              resultBlock:resultBlock
                                              cancelBlock:cancelBlock];

    [addressPickerView showPickerViewWithAnimation:YES];

}

#pragma mark - 创建一个 pickerview
-(instancetype)initWithShowPickerViewMode:(GTUIAddressPickerMode)pickerViewMode
                               dataSource:(NSArray *)dataSource
                          defaultSelected:(NSArray *)defaultSelectedArr
                           isAutoSelected:(BOOL)isAutoSelect
                                lineColor:(UIColor *)lineColor
                       selectRowTextColor:(UIColor *)selectRowTextColor
                         selectRowBGColor:(UIColor *)selectRowBGColor
                     confirmBtnTitleColor:(UIColor *)confirmBtnTitleColor
                      cancelBtnTitleColor:(UIColor *)cancelBtnTitleColor
                                rowHeight:(CGFloat)rowHeight
                              resultBlock:(GTUIAddressResultBlock)resultBlock
                              cancelBlock:(GTUIAddressCancelBlock)cancelBlock{

    if (self = [super init]) {
        _isDataSourceValid          = YES;
        self.pickerViewMode         = pickerViewMode;
        _defaultSelectedArr         = defaultSelectedArr;
        self.dataSource             = dataSource;
        self.resultBlock            = resultBlock;
        self.cancelBlock            = cancelBlock;
        self.isAutoSelect           = isAutoSelect;
        self.lineColor              = lineColor;
        self.selecteRowTextColor    = selectRowTextColor;
        self.selectRowBGColor       = selectRowBGColor;
        self.rowHeight              = rowHeight ? rowHeight : 35.0f;


        if (confirmBtnTitleColor || cancelBtnTitleColor) {

            [self setUpConfirmTitleColor:confirmBtnTitleColor cancelColor:cancelBtnTitleColor];
        }

        [self loadAddressData];

        if (_isDataSourceValid) {
            [self initWithAllView];
        }
    }

    return self;

}
-(void)initWithAllView{
    [super initWithAllView];

    if (self.pickerViewMode == GTUIAddressPickerModeProvince) {
        self.titleLab.text = @"请选择省份";
    }else if (self.pickerViewMode == GTUIAddressPickerModeCity){
        self.titleLab.text = @"请选择城市";
    }else{
        self.titleLab.text = @"请选择地区";
    }
    [self.alertView addSubview:self.pickerView];

    [self.pickerView reloadAllComponents];
}

#pragma mark - 加载数据源
-(void)loadAddressData{
    if (!self.dataSource || self.dataSource.count == 0) {
        NSString *filePath = [[GTUIAddressPickerView bundle] pathForResource:@"GTUIAddress" ofType:@"plist"];
        NSArray *dataSource = [NSArray arrayWithContentsOfFile:filePath];

        if (!dataSource || dataSource.count == 0) {
            return;
        }
        self.dataSource = dataSource;
    }

    // 解析数据
    [self parseDataSource];

    // 设置默认值
    [self setUpDefaultValue];

    // 设置默认滚动
    [self scrollToRow:_provinceIndex secondRow:_cityIndex thirdRow:_areaIndex];
}

-(void)setUpDefaultValue{
    __block NSString *selectProvinceName = nil;
    __block NSString *selectCityName = nil;
    __block NSString *selectAreaName = nil;

    // 1. 获取默认选中的省市区名称
    if (_defaultSelectedArr) {
        if (_defaultSelectedArr.count > 0 && [_defaultSelectedArr[0] isKindOfClass:[NSString class]]) {
            selectProvinceName = _defaultSelectedArr[0];
        }

        if (_defaultSelectedArr.count > 1 && [_defaultSelectedArr[1] isKindOfClass:[NSString class]]) {
            selectCityName = _defaultSelectedArr[1];
        }
        if (_defaultSelectedArr.count > 2 && [_defaultSelectedArr[2] isKindOfClass:[NSString class]]) {
            selectAreaName = _defaultSelectedArr[2];
        }
    }

    // 根据名称快速找到默认选中的省市区索引
    @weakify(self)

    [self.provinceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        GTProvinceModel *model = obj;

        if ([model.name isEqualToString:selectProvinceName]) {
            self->_provinceIndex = idx;
            self.selectProvinceModel = model;
            *stop = YES;
        }else{
            if (idx == self.provinceArr.count - 1) {
                self->_provinceIndex = 0;
                self.selectProvinceModel = [self.provinceArr firstObject];
            }
        }
    }];

    if (self.pickerViewMode == GTUIAddressPickerModeCity || self.pickerViewMode == GTUIAddressPickerModeArea) {
        self.cityArr = [self getCityModelArray:_provinceIndex];
        @weakify(self)
        [self.cityArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            GTCityModel *model = obj;
            if ([model.name isEqualToString:selectCityName]) {
                self->_cityIndex = idx;
                self.selectCityModel = model;
                *stop = YES;
            } else {
                if (idx == self.cityArr.count - 1) {
                    self->_cityIndex = 0;
                    self.selectCityModel = [self.cityArr firstObject];
                }
            }
        }];
    }
    if (self.pickerViewMode == GTUIAddressPickerModeArea) {
        self.areaArr = [self getAreaModelArray:_provinceIndex cityIndex:_cityIndex];
        @weakify(self)
        [self.areaArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            GTAreaModel *model = obj;
            if ([model.name isEqualToString:selectAreaName]) {
                self->_areaIndex = idx;
                self.selectAreaModel = model;
                *stop = YES;
            } else {
                if (idx == self.cityArr.count - 1) {
                    self->_areaIndex = 0;
                    self.selectAreaModel = [self.areaArr firstObject];
                }
            }
        }];
    }

}
// 根据 省索引 获取 城市模型数组
- (NSArray *)getCityModelArray:(NSInteger)provinceIndex {
    GTProvinceModel *provinceModel = self.provinceArr[provinceIndex];
    // 返回城市模型数组
    return provinceModel.citylist;
}

// 根据 省索引和城市索引 获取 区域模型数组
- (NSArray *)getAreaModelArray:(NSInteger)provinceIndex cityIndex:(NSInteger)cityIndex {
    GTProvinceModel *provinceModel = self.provinceArr[provinceIndex];
    GTCityModel *cityModel = provinceModel.citylist[cityIndex];
    // 返回地区模型数组
    return cityModel.arealist;
}

#pragma mark - Resource bundle

+ (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[self bundlePathWithName:@"GTUIPickerView.bundle"]];
    });

    return bundle;
}

+ (NSString *)bundlePathWithName:(NSString *)bundleName {
    // In iOS 8+, we could be included by way of a dynamic framework, and our resource bundles may
    // not be in the main .app bundle, but rather in a nested framework, so figure out where we live
    // and use that as the search location.
    NSBundle *bundle = [NSBundle bundleForClass:[GTUIAddressPickerView class]];
    NSString *resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle) resourcePath];
    return [resourcePath stringByAppendingPathComponent:bundleName];
}

#pragma mark - 解析数据源
- (void)parseDataSource {
    NSMutableArray *tempArr1 = [NSMutableArray array];
    for (NSDictionary *proviceDic in self.dataSource) {
        GTProvinceModel *proviceModel = [[GTProvinceModel alloc]init];
        proviceModel.code = proviceDic[@"code"];
        proviceModel.name = proviceDic[@"name"];
        proviceModel.index = [self.dataSource indexOfObject:proviceDic];
        NSArray *citylist = proviceDic[@"citylist"];
        NSMutableArray *tempArr2 = [NSMutableArray array];
        for (NSDictionary *cityDic in citylist) {
            GTCityModel *cityModel = [[GTCityModel alloc]init];
            cityModel.code = cityDic[@"code"];
            cityModel.name = cityDic[@"name"];
            cityModel.index = [citylist indexOfObject:cityDic];
            NSArray *arealist = cityDic[@"arealist"];
            NSMutableArray *tempArr3 = [NSMutableArray array];
            for (NSDictionary *areaDic in arealist) {
                GTAreaModel *areaModel = [[GTAreaModel alloc]init];
                areaModel.code = areaDic[@"code"];
                areaModel.name = areaDic[@"name"];
                areaModel.index = [arealist indexOfObject:areaDic];
                [tempArr3 addObject:areaModel];
            }
            cityModel.arealist = [tempArr3 copy];
            [tempArr2 addObject:cityModel];
        }
        proviceModel.citylist = [tempArr2 copy];
        [tempArr1 addObject:proviceModel];
    }
    self.provinceArr = [tempArr1 copy];
}

#pragma mark - 滚动到指定行
- (void)scrollToRow:(NSInteger)provinceIndex secondRow:(NSInteger)cityIndex thirdRow:(NSInteger)areaIndex {
    if (self.pickerViewMode == GTUIAddressPickerModeProvince) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
    } else if (self.pickerViewMode == GTUIAddressPickerModeCity) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
    } else if (self.pickerViewMode == GTUIAddressPickerModeArea) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:areaIndex inComponent:2 animated:YES];
    }
}


#pragma mark - 背景视图的点击事件
- (void)backViewTapAction:(UITapGestureRecognizer *)sender {
    [self dismissPickerViewWithAnimation:NO];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 取消按钮的点击事件
- (void)leftBtnClickAction:(UIButton *)sender {
    [self dismissPickerViewWithAnimation:YES];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 确定按钮的点击事件
- (void)rightBtnClickAction:(UIButton *)sender{
    [self dismissPickerViewWithAnimation:YES];
    // 点击确定按钮后，执行回调
    if(self.resultBlock) {
        self.resultBlock(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
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


#pragma amrk - UIPickerViewDelegate , UIPickerViewDataSource
// 设置 pickerView 上有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    if (self.pickerViewMode == GTUIAddressPickerModeProvince) {

        return 1;

    }else if (self.pickerViewMode == GTUIAddressPickerModeCity){

        return 2;

    }else if(self.pickerViewMode == GTUIAddressPickerModeArea){

        return 3;
    }

    return 0;

}

// 设置 pickerview 上有多少行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        // 返回省的个数
        return self.provinceArr.count;
    }

    if (component == 1) {
        // 返回市的个数
        return self.cityArr.count;
    }

    if (component == 2) {
        // 返回区的个数
        return self.areaArr.count;
    }

    return 0;

}


// 配置 pickerView 的显示内容,在此方法中实现省份和城市间的联动
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    if (self.lineColor) {
        // 设置分割线的颜色
        ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = self.lineColor;
        ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = self.lineColor;
    }


    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.alertView.frame.size.width / 3, self.rowHeight * kScaleFit)];
    backView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5*kScaleFit, 0, (self.alertView.frame.size.width) / 3 - 10 * kScaleFit, self.rowHeight * kScaleFit)];
    [backView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kFontSize(18);
    label.adjustsFontSizeToFitWidth = YES;
    // 字体自适应属性
    label.minimumScaleFactor = 0.5f;

    if (component == 0) {
        GTProvinceModel *model = self.provinceArr[row];
        label.text = model.name;

        if (row == _provinceIndex && self.selecteRowTextColor) {
            label.textColor = self.selecteRowTextColor;
        }

    }else if (component == 1 ){
        GTCityModel *model = self.cityArr[row];
        label.text = model.name;

        if (row == _cityIndex && self.selecteRowTextColor) {
            label.textColor = self.selecteRowTextColor;
        }

    }else if (component == 2 ){
        GTAreaModel *model = self.areaArr[row];
        label.text = model.name;

        if (row == _areaIndex && self.selecteRowTextColor) {
            label.textColor = self.selecteRowTextColor;
        }

    }

    return backView;
}

// 设置 pickerview 的行高
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return self.rowHeight * kScaleFit;
}

#pragma mark - pickerview 的选中回调
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component == 0) {
        // 保存选择的省份的索引
        _provinceIndex = row;
        switch (self.pickerViewMode) {
            case GTUIAddressPickerModeProvince:
            {
                self.selectProvinceModel = self.provinceArr[_provinceIndex];
                self.selectCityModel = nil;
                self.selectAreaModel = nil;

            }
                break;
            case GTUIAddressPickerModeCity:
            {
                self.cityArr = [self getCityModelArray:_provinceIndex];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                self.selectProvinceModel = self.provinceArr[_provinceIndex];
                self.selectCityModel = self.cityArr[0];
                self.selectAreaModel = nil;
                _cityIndex = 0;
            }
                break;
            case GTUIAddressPickerModeArea:
            {
                self.cityArr = [self getCityModelArray:_provinceIndex];
                self.areaArr = [self getAreaModelArray:_provinceIndex cityIndex:0];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectProvinceModel = self.provinceArr[_provinceIndex];
                self.selectCityModel = self.cityArr[0];
                self.selectAreaModel = self.areaArr[0];
                _cityIndex = 0;
                _areaIndex = 0;
            }
                break;
            default:
                break;
        }
    }

    if (component == 1) { // 选择市
        // 保存选择的城市的索引
        _cityIndex = row;
        switch (self.pickerViewMode) {
            case GTUIAddressPickerModeCity:
            {
                self.selectCityModel = self.cityArr[_cityIndex];
                self.selectAreaModel = nil;

            }
                break;
            case GTUIAddressPickerModeArea:
            {
                self.areaArr = [self getAreaModelArray:_provinceIndex cityIndex:_cityIndex];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectCityModel = self.cityArr[_cityIndex];
                self.selectAreaModel = self.areaArr[0];
                _areaIndex = 0;
            }
                break;
            default:
                break;
        }
    }
    if (component == 2) { // 选择区
        // 保存选择的地区的索引
        _areaIndex = row;
        if (self.pickerViewMode == GTUIAddressPickerModeArea) {
            self.selectAreaModel = self.areaArr[_areaIndex];
        }
    }

    // 自动获取数据，滚动完就执行回调
    if (self.isAutoSelect) {
        if (self.resultBlock) {
            self.resultBlock(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
        }
    }

    [pickerView reloadAllComponents];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.subviews.count) {

        NSArray *subviews = self.pickerView.subviews;
        if (!(subviews.count > 0)) {
            return;
        }

        NSArray *coloms = subviews.firstObject;
        NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
        if (subviewCache.count > 0) {
            UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
            if (middleContainerView) {
                middleContainerView.backgroundColor = self.selectRowBGColor;
            }
        }
    }

}

#pragma mark - Getter && Setter
-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kGTTopViewHeight + 0.5, self.alertView.frame.size.width, kGTPickerHeight)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
        // 设置子视图的大小随着父视图变化
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _pickerView;
}

-(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

-(NSArray *)provinceArr{
    if (!_provinceArr) {
        _provinceArr = [NSArray array];
    }
    return _provinceArr;
}

-(NSArray *)cityArr{
    if (!_cityArr) {
        _cityArr = [NSArray array];
    }
    return _cityArr;
}

-(NSArray *)areaArr{
    if (!_areaArr) {
        _areaArr = [NSArray array];
    }
    return _areaArr;
}

-(GTProvinceModel *)selectProvinceModel{
    if (!_selectProvinceModel) {
        _selectProvinceModel = [[GTProvinceModel alloc]init];
    }
    return _selectProvinceModel;
}

-(GTCityModel *)selectCityModel{
    if (!_selectCityModel) {
        _selectCityModel = [[GTCityModel alloc]init];
        _selectCityModel.code = @"";
        _selectCityModel.name = @"";
    }
    return _selectCityModel;
}

-(GTAreaModel *)selectAreaModel{
    if (!_selectAreaModel) {
        _selectAreaModel = [[GTAreaModel alloc]init];
        _selectAreaModel.code = @"";
        _selectAreaModel.name = @"";
    }
    return _selectAreaModel;
}

@end
