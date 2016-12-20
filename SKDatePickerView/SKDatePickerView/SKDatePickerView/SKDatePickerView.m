//
//  SKDatePickerView.m
//  SKDatePickerView
//
//  Created by pactera on 2016/12/19.
//  Copyright © 2016年 songke. All rights reserved.
//

#import "SKDatePickerView.h"

//屏幕尺寸的宏
#define SKScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define SKScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

//颜色相关的宏
#define SKRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define SKRGB(r, g, b) SKRGBA(r, g, b, 1.0f)

//toolBar高度
static const CGFloat SKSystemHeight = 44;
//分割线宽度
static const CGFloat SKLineHeight = 0.5;
//较小间隙
static const CGFloat SKSmallPadding = 5;
//按钮距边宽度
static const CGFloat SKBigPadding = 15;

@interface SKDatePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

/** 1.内容视图 */
@property (nonatomic, strong) UIView *contentView;
/** 2.top分割线 */
@property (nonatomic, strong)UIView *topLine;
/** 3.选择器 */
@property (nonatomic, strong)UIPickerView *pickerView;
/** 4.左边的按钮 */
@property (nonatomic, strong)UIButton *leftButton;
/** 5.右边的按钮 */
@property (nonatomic, strong)UIButton *righBtutton;
/** 6.标题label */
@property (nonatomic, strong)UILabel *labelTitle;
/** 7.bottom分割线*/
@property (nonatomic, strong)UIView *bottomLine;

/** 1.年 */
@property (nonatomic, assign)NSInteger year;
/** 2.月 */
@property (nonatomic, assign)NSInteger month;
/** 3.日 */
@property (nonatomic, assign)NSInteger day;

/** 1.最小的年份，default is 1900 */
@property (nonatomic, assign)NSInteger yearLeast;
/** 2.显示年份数量，default is 200 */
@property (nonatomic, assign)NSInteger yearSum;

@end

@implementation SKDatePickerView

- (void)dealloc {
    NSLog(@"我销毁了--------");
}

#pragma mark - 自定义初始化方法
- (instancetype)initWithYearLeast:(NSInteger)yearLeast yearSum:(NSInteger)yearSum {
    if (self = [super init]) {
        _yearLeast = yearLeast;
        _yearSum   = yearSum;
        [self setupUI];
    }
    return self;
}

#pragma mark - 私有方法
/** 设置UI */
- (void)setupUI {
    // 1.设置数据的默认值
    _title = @"请选择日期";
    _font = [UIFont systemFontOfSize:15];
    _titleColor = [UIColor blackColor];
    _borderButtonColor = SKRGB(143, 143, 143);
    _heightPicker = 255;
    _showType = SKCityPickerViewShowTypeBottom;
    _heightPickerComponent = 28;
    
    _year  = [self currentDateComponents].year;
    _month = [self currentDateComponents].month;
    _day   = [self currentDateComponents].day;
    
    // 2.设置自身的属性
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = SKRGBA(0, 0, 0, 0.3);
    self.layer.opacity = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [self addGestureRecognizer:tap];
    
    // 3.添加子视图
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.pickerView];
    [self.contentView addSubview:self.leftButton];
    [self.contentView addSubview:self.righBtutton];
    [self.contentView addSubview:self.labelTitle];
    [self.contentView addSubview:self.bottomLine];
    
    [self.pickerView selectRow:(_year - _yearLeast) inComponent:0 animated:NO];
    [self.pickerView selectRow:(_month - 1) inComponent:1 animated:NO];
    [self.pickerView selectRow:(_day - 1) inComponent:2 animated:NO];
}

- (NSDateComponents *)currentDateComponents
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    return [calendar components:unitFlags fromDate:[NSDate date]];
}

/** 计算当月有多少天 */
- (NSInteger)getDaysWithYear:(NSInteger)year month:(NSInteger)month
{
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12: {
            return 31;
            break;
        }
            
        case 4:
        case 6:
        case 9:
        case 11:{
            return 30;
            break;
        }
            
        case 2: {
            if (year%400==0 || (year%100!=0 && year%4 == 0)) {
                return 29;
            }else{
                return 28;
            }
            break;
        }
            
        default:
            return 0;
            break;
    }
}

//更新数据
- (void)reloadData
{
    self.year  = [self.pickerView selectedRowInComponent:0] + self.yearLeast;
    self.month = [self.pickerView selectedRowInComponent:1] + 1;
    self.day   = [self.pickerView selectedRowInComponent:2] + 1;
    self.labelTitle.text = [NSString stringWithFormat:@"%ld年%02ld月%02ld日", self.year, self.month, self.day];
}

//移除选择器
- (void)removeView
{
    if (self.contentMode == SKCityPickerViewShowTypeBottom) {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y += self.contentView.frame.size.height;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:0.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y += (SKScreenHeight + self.contentView.frame.size.height) / 2;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:0.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

//点击事件
- (void)buttonRightClick:(UIButton *)rightButton
{
    [self removeView];
    if (self.choiceBlock != nil) {
        self.choiceBlock(self.year, self.month, self.day);
    }
}

#pragma mark - 暴露在外的方法
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    if (self.showType == SKCityPickerViewShowTypeBottom) {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y -= self.contentView.frame.size.height;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:1.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
        }];
    }else {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y -= (SKScreenHeight + self.contentView.frame.size.height) / 2;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:1.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearSum;
    }else if(component == 1) {
        return 12;
    }else {
        NSInteger yearSelected = [pickerView selectedRowInComponent:0] + self.yearLeast;
        NSInteger monthSelected = [pickerView selectedRowInComponent:1] + 1;
        return  [self getDaysWithYear:yearSelected month:monthSelected];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            break;
        case 1:
            [pickerView reloadComponent:2];
        default:
            break;
    }
    
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    NSString *text;
    if (component == 0) {
        text =  [NSString stringWithFormat:@"%zd", row + self.yearLeast];
    }else if (component == 1){
        text =  [NSString stringWithFormat:@"%zd", row + 1];
    }else{
        text = [NSString stringWithFormat:@"%zd", row + 1];
    }
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}

#pragma mark - 懒加载控件属性
- (UIView *)contentView
{
    if (!_contentView) {
        CGFloat contentX = 0;
        CGFloat contentY = SKScreenHeight;
        CGFloat contentW = SKScreenWidth;
        CGFloat contentH = self.heightPicker;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(contentX, contentY, contentW, contentH)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return _contentView;
}

- (UIView *)topLine
{
    if (!_topLine) {
        CGFloat topLineX = 0;
        CGFloat topLineY = SKSystemHeight - SKLineHeight;
        CGFloat topLineW = SKScreenWidth;
        CGFloat topLineH = SKLineHeight;
        _topLine = [[UIView alloc]initWithFrame:CGRectMake(topLineX, topLineY, topLineW, topLineH)];
        _topLine.backgroundColor = self.borderButtonColor;
    }
    return _topLine;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        CGFloat pickerW = SKScreenWidth;
        CGFloat pickerH = self.contentView.frame.size.height - SKSystemHeight;
        CGFloat pickerX = 0;
        CGFloat pickerY = SKSystemHeight;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerX, pickerY, pickerW, pickerH)];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIButton *)leftButton
{
    if (!_leftButton) {
        CGFloat leftW = SKSystemHeight;
        CGFloat leftH = SKSystemHeight - SKSmallPadding * 2;
        CGFloat leftX = SKBigPadding;
        CGFloat leftY = SKSmallPadding;
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(leftX, leftY, leftW, leftH)];
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [_leftButton setTitleColor:self.titleColor forState:UIControlStateNormal];
        [_leftButton.layer setBorderColor:self.borderButtonColor.CGColor];
        [_leftButton.layer setBorderWidth:SKLineHeight];
        [_leftButton.layer setCornerRadius:4];
        [_leftButton.titleLabel setFont:self.font];
        [_leftButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)righBtutton
{
    if (!_righBtutton) {
        CGFloat rightW = self.leftButton.frame.size.width;
        CGFloat rightH = self.leftButton.frame.size.height;
        CGFloat rightX = SKScreenWidth - rightW - SKBigPadding;
        CGFloat rightY = self.leftButton.frame.origin.y;
        _righBtutton = [[UIButton alloc]initWithFrame:CGRectMake(rightX, rightY, rightW, rightH)];
        [_righBtutton setTitle:@"确定" forState:UIControlStateNormal];
        [_righBtutton setTitleColor:self.titleColor forState:UIControlStateNormal];
        [_righBtutton.layer setBorderColor:self.borderButtonColor.CGColor];
        [_righBtutton.layer setBorderWidth:SKLineHeight];
        [_righBtutton.layer setCornerRadius:4];
        [_righBtutton.titleLabel setFont:self.font];
        [_righBtutton addTarget:self action:@selector(buttonRightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _righBtutton;
}

- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        CGFloat titleX = SKSmallPadding * 2 + self.leftButton.frame.size.width;
        CGFloat titleY = 0;
        CGFloat titleW = SKScreenWidth - titleX * 2;
        CGFloat titleH = SKSystemHeight - SKLineHeight;
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.textColor = self.titleColor;
        _labelTitle.text = self.title;
        _labelTitle.font = self.font;
        _labelTitle.adjustsFontSizeToFitWidth = YES;
    }
    return _labelTitle;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        CGFloat lineX = 0;
        CGFloat lineY = self.pickerView.frame.origin.y + self.pickerView.frame.size.height;
        CGFloat lineW = self.contentView.frame.size.width;
        CGFloat lineH = SKLineHeight;
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        _bottomLine.backgroundColor = self.borderButtonColor;
    }
    return _bottomLine;
}

#pragma mark - --- setter

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.labelTitle.text = title;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.leftButton.titleLabel.font = font;
    self.righBtutton.titleLabel.font = font;
    self.labelTitle.font = font;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.labelTitle.textColor = titleColor;
    [self.leftButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.righBtutton setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setBorderButtonColor:(UIColor *)borderButtonColor
{
    _borderButtonColor = borderButtonColor;
    self.leftButton.layer.borderColor = self.borderButtonColor.CGColor;
    self.righBtutton.layer.borderColor = self.borderButtonColor.CGColor;
}

- (void)setHeightPicker:(CGFloat)heightPicker
{
    _heightPicker = heightPicker;
    CGRect frame = self.contentView.frame;
    frame.size.height = heightPicker;
    self.contentView.frame = frame;
}

- (void)setShowType:(SKCityPickerViewShowType)showType {
    _showType = showType;
    if (showType == SKCityPickerViewShowTypeCenter) {
        CGRect frame = self.contentView.frame;
        frame.size.height += SKSystemHeight;
        self.contentView.frame = frame;
    }
}

- (void)setYearLeast:(NSInteger)yearLeast
{
    _yearLeast = yearLeast;
}

- (void)setYearSum:(NSInteger)yearSum
{
    _yearSum = yearSum;
}
@end
