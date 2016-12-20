//
//  SKDatePickerView.h
//  SKDatePickerView
//
//  Created by pactera on 2016/12/19.
//  Copyright © 2016年 songke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SKCityPickerViewShowType) {
    SKCityPickerViewShowTypeBottom, // 1.选择器在视图的下方
    SKCityPickerViewShowTypeCenter  // 2.选择器在视图的中间
};

typedef void(^datePickerViewBlock)(NSInteger year, NSInteger month, NSInteger day);

@interface SKDatePickerView : UIView

/** 1.标题，默认为"请选择城市地区"*/
@property (nonatomic, copy) NSString *title;
/** 2.字体，为系统默认字体 */
@property (nonatomic, strong) UIFont *font;
/** 3.字体颜色，默认为黑色 */
@property (nonatomic,strong) UIColor *titleColor;
/** 4.按钮边框颜色颜色及分割线颜色，默认为(143, 143, 143) */
@property (nonatomic, strong) UIColor *borderButtonColor;
/** 5.选择器的高度，默认为255 */
@property (nonatomic, assign)CGFloat heightPicker;
/** 6.视图的显示方式 默认为下方*/
@property (nonatomic, assign)SKCityPickerViewShowType showType;
/** 7.中间选择框的高度，默认32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

/**
 * 初始化方法
 *
 * @param yearLeast NSInteger 最小年份
 *
 * @param yearSum NSInteger 显示的年数
 */
- (instancetype)initWithYearLeast:(NSInteger)yearLeast yearSum:(NSInteger)yearSum;
/** 选择成功之后的回调*/
@property (nonatomic, copy) datePickerViewBlock choiceBlock;

- (void)show;

@end
