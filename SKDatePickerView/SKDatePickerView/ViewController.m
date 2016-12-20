//
//  ViewController.m
//  SKDatePickerView
//
//  Created by pactera on 2016/12/19.
//  Copyright © 2016年 songke. All rights reserved.
//

#import "ViewController.h"
#import "SKDatePickerView.h"

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) SKDatePickerView *datePickerView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.delegate = self;
    
    self.datePickerView = [[SKDatePickerView alloc] initWithYearLeast:2000 yearSum:100];
    
//    self.datePickerView.title = @"点击此处选择日期";
//    self.datePickerView.font = [UIFont systemFontOfSize:20];
//    self.datePickerView.titleColor = [UIColor redColor];
//    self.datePickerView.borderButtonColor = [UIColor redColor];
//    self.datePickerView.heightPickerComponent = 50;
    
    __weak typeof(self) weakSelf = self;
    self.datePickerView.choiceBlock = ^(NSInteger year, NSInteger month, NSInteger day){
        NSLog(@"%ld年%ld月%ld日", year,month,day);
        weakSelf.textField.text = [NSString stringWithFormat:@"%ld年%ld月%02ld日",year,month,day];
    };
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.datePickerView show];
    return NO;
}


@end
