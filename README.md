# SKDatePickerView
三级联动日期选择器

调用初始化方法
SKDatePickerView *datePickerView = [[SKDatePickerView alloc] initWithYearLeast:2000 yearSum:100];\n
设置相应属性不设置则为默认值
//    self.datePickerView.title = @"点击此处选择日期";
//    self.datePickerView.font = [UIFont systemFontOfSize:20];
//    self.datePickerView.titleColor = [UIColor redColor];
//    self.datePickerView.borderButtonColor = [UIColor redColor];
//    self.datePickerView.heightPickerComponent = 50;

选择成功后会调用成功后的block
datePickerView.choiceBlock = ^(NSInteger year, NSInteger month, NSInteger day){
NSLog(@"%ld年%ld月%ld日", year,month,day);
};

调用show方法
[datePickerView show];

具体使用请查看demo

