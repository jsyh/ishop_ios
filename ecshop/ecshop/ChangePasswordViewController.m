//
//  ChangePasswordViewController.m
//  ecshop
//
//  Created by Jin on 15/12/9.
//  Copyright © 2015年 jsyh. All rights reserved.
//修改密码

#import "ChangePasswordViewController.h"
#import "RegisterView.h"
#import "Masonry.h"
#import "RequestModel.h"
#import "UIColor+Hex.h"
#define kWIDTH [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1]
#define kColorOffButton [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)RegisterView *userView;
@property (nonatomic,strong)RegisterView *passwordView1;
@property (nonatomic,strong)RegisterView *passwordView2;
@property(nonatomic,strong)RegisterView *oldPassword;
@property (nonatomic,strong)UIButton *button;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = kColorBack;
    [self draw];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}
-(void)draw{

    //用户名
    _userView = [RegisterView lab:@"用户名：" textFiled:@"请填写您的用户名" frameX:0 frameY:64];
    _userView.txtField.delegate = self;
    [_userView.txtField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_userView];
    //密码
    _passwordView1 = [RegisterView lab:@"新密码：" textFiled:@"请输入您的新密码" frameX:0 frameY:115];
    _passwordView1.txtField.secureTextEntry = YES;
    [_passwordView1.txtField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_passwordView1];
    
    //旧密码
    _oldPassword = [RegisterView lab:@"旧密码" textFiled:@"请输入您现在的密码" frameX:0 frameY:166];
    _oldPassword.txtField.secureTextEntry = YES;
    [_oldPassword.txtField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_oldPassword];
    //确认密码
    _passwordView2 = [RegisterView lab:@"确认密码：" textFiled:@"请确认您的新密码" frameX:0 frameY:217];
    _passwordView2.txtField.secureTextEntry = YES;
    [_passwordView2.txtField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_passwordView2];
    //注册按钮
    _button = [UIButton buttonWithType:UIButtonTypeCustom];

    _button.backgroundColor = kColorOffButton;
    [_button setTitle:@"确定" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _button.frame = CGRectMake(30, _passwordView2.frame.size.height +_passwordView2.frame.origin.y + 20, self.view.frame.size.width - 60, 40);
    _button.titleLabel.font = [UIFont systemFontOfSize:15];
    _button.userInteractionEnabled = YES;
    [_button addTarget:self action:@selector(changePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];

    
}
-(void)textFieldChanged:(id)sender{
    if (_userView.temp.length>0&&_oldPassword.temp.length>0&&_passwordView1.temp.length>0&&_passwordView2.temp.length>0) {
        _button.backgroundColor = [UIColor redColor];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.userInteractionEnabled = YES;
    }else{
        _button.backgroundColor = kColorOffButton;
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _button.userInteractionEnabled = YES;
    }
}
-(void)changePassword:(id)sender{
    NSLog(@"修改密码");
    NSString *api_token = [RequestModel model:@"user" action:@"modifypasswd"];
    NSDictionary *dict = @{@"api_token":api_token,@"username":_userView.temp,@"new_pwd":_passwordView1.temp,@"user_pwd":_oldPassword.temp,@"key":self.tempDic[@"data"][@"key"]};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"modifypasswd" block:^(id result) {
        NSDictionary *dic = result;
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [weakSelf presentViewController:alertVC animated:YES completion:nil];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark -- 自定义导航栏
- (void)initNavigationBar{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *naviBGColor = data[@"navigationBGColor"];
    NSString *navigationTitleFont = data[@"navigationTitleFont"];
    int titleFont = [navigationTitleFont intValue];
    NSString *naiigationTitleColor = data[@"naiigationTitleColor"];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    
    label.text = @"修改密码";
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:titleFont];
    label.textColor = [UIColor colorWithHexString:naiigationTitleColor];
    [view addSubview:label];
    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    //    btn.backgroundColor = [UIColor redColor];
    [btn addSubview:imgView];
    //    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
