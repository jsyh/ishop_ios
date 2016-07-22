//
//  RegisterView.m
//  ecshop
//
//  Created by Jin on 15/12/3.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "RegisterView.h"
#import "AppDelegate.h"
@implementation RegisterView
+(RegisterView *)lab:(NSString *)lab textFiled:(NSString *)file frameX:(CGFloat)frameX frameY:(CGFloat)frameY{

    RegisterView *view = [[RegisterView alloc]initWithFrame:CGRectMake(frameX, frameY, [UIScreen mainScreen].bounds.size.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    //label

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ([UIScreen mainScreen].bounds.size.width/5)*2-40, 50)];
    label.text = lab;
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    //textfield

    view.txtField = [[UITextField alloc]initWithFrame:CGRectMake( ([UIScreen mainScreen].bounds.size.width/5)*2-30 , 0, ([UIScreen mainScreen].bounds.size.width/5)*3 , 50)];
    view.txtField.placeholder = file;
    view.txtField.font = [UIFont systemFontOfSize:15];
    view.temp = view.txtField.text;
    [view addSubview:view.txtField];
    return view;
    
}
-(NSString *)temp{
    return self.txtField.text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
