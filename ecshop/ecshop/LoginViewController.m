//
//  LoginViewController.m
//  ecshop
//
//  Created by Jin on 15/12/3.
//  Copyright © 2015年 jsyh. All rights reserved.
//登录

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "RequestModel.h"
#import "ForgetPasswordViewController.h"
#import "MD5/NSString+Hashing.h"
#import "UIColor+Hex.h"
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
#define kColorOffButton [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton *passwordBtn;
//用户名
@property (nonatomic,strong)UITextField *userText;
//密码
@property (nonatomic,strong)UITextField *passwordText;
@property(nonatomic,strong)UIButton *loginBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = kColorBack;
    [self draw];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}
-(void)draw{
    
    //背景图

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.height/7)*2)];
    UIImage *image = [UIImage imageNamed:@"会员中心-已登录-背景1.png"];
    imgView.image = image;
    [self.view addSubview:imgView];
    //头像
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width/5, self.view.frame.size.width/5)];
    UIImage *headImg = [UIImage imageNamed:@"null_head.png"];
    headView.image = headImg;
    [self.view addSubview:headView];
    //账号

    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, imgView.frame.origin.y + imgView.frame.size.height, self.view.frame.size.width, 50)];
    view1.backgroundColor = [UIColor whiteColor];

    UILabel *userLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 50)];
    userLab.text = @"账号：";
    userLab.textAlignment = NSTextAlignmentRight;
    userLab.font = [UIFont systemFontOfSize:15];
    [view1 addSubview:userLab];

    self.userText = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 80, 50)];
    self.userText.placeholder = @"用户名/手机号";
    self.userText.font = [UIFont systemFontOfSize:15];
    self.userText.returnKeyType = UIReturnKeyNext;
    self.userText.delegate = self;
    [self.userText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [view1 addSubview:self.userText];

    [self.view addSubview:view1];
    //密码

    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.frame.origin.y + view1.frame.size.height, self.view.frame.size.width, 50)];
    view2.backgroundColor = [UIColor whiteColor];

    UILabel *passwordLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 50)];
    passwordLab.text = @"密码：";
    passwordLab.textAlignment = NSTextAlignmentRight;
    passwordLab.font = [UIFont systemFontOfSize:15];
    [view2 addSubview:passwordLab];
    

    self.passwordText = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 80, 50)];
    self.passwordText.placeholder = @"输入密码";
    self.passwordText.font = [UIFont systemFontOfSize:15];
    self.passwordText.secureTextEntry = YES;
    self.passwordText.returnKeyType = UIReturnKeyDone;
    self.passwordText.delegate = self;
    [self.passwordText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [view2 addSubview:self.passwordText];
    _passwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    _passwordBtn.frame = CGRectMake(self.view.frame.size.width - 55, 10, 50, 30) ;
    UIImage *passImg = [UIImage imageNamed:@"hide_password.png"];
    [_passwordBtn setImage:passImg forState:UIControlStateNormal];
    [_passwordBtn addTarget:self action:@selector(changePass:) forControlEvents:UIControlEventTouchUpInside];
    _passwordBtn.tag = 1000;
    [view2 addSubview:_passwordBtn];
    [self.view addSubview:view2];

    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(75, view1.frame.size.height + view1.frame.origin.y, self.view.frame.size.width - 75, 1)];
    view3.backgroundColor = kColorBack;
    [self.view addSubview:view3];
    
    //登录按钮
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    _loginBtn.frame = CGRectMake(30, view2.frame.size.height + view2.frame.origin.y + 20, self.view.frame.size.width - 60, 35) ;
    _loginBtn.backgroundColor = kColorOffButton;
    _loginBtn.layer.cornerRadius = 10;
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(actionForLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    //快速注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    registerBtn.frame = CGRectMake(5, _loginBtn.frame.origin.y + _loginBtn.frame.size.height + 10, 80, 40);
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(changeToRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    //找回密码
    UIButton *findpasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [findpasswordBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findpasswordBtn addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];

    findpasswordBtn.frame = CGRectMake(self.view.frame.size.width - 85, registerBtn.frame.origin.y, 80, 40);
    findpasswordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [findpasswordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:findpasswordBtn];
}
-(void)textFieldChanged:(id)sender{
    if (_userText.text.length>0&&_passwordText.text.length>0) {
        _loginBtn.backgroundColor = [UIColor redColor];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.userInteractionEnabled = YES;
    }else{
        _loginBtn.backgroundColor = kColorOffButton;
        [_loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _loginBtn.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//登录方法
-(void)actionForLogin:(id)sender{
    NSString *userStr = self.userText.text;
    NSString *passwordStr = self.passwordText.text;
    NSString *api_token = [RequestModel model:@"user" action:@"login"];
    NSDictionary *dict = @{@"api_token":api_token,@"user":userStr,@"passwd":passwordStr};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"login" block:^(id result) {
        NSDictionary *dic = result;
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([dic[@"msg"]isEqualToString:@"登录成功"]) {
                
                weakSelf.mykey = dic[@"data"][@"key"];
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                NSDictionary *dicc = [[NSDictionary alloc]init];
                dicc = @{@"dic":dic,@"userName":userStr};
#pragma mark -- 注册通知各页已经登录
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:dicc];
            }
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [weakSelf presentViewController:alertVC animated:YES completion:nil];
        
        NSLog(@"in");
    }];
    NSLog(@"out");
}
//关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//明文密文按钮
-(void)changePass:(id)sender{
    if (_passwordBtn.tag == 1000) {
        [_passwordBtn setImage:[UIImage imageNamed:@"show_password.png"] forState:UIControlStateNormal];
        self.passwordText.secureTextEntry = NO;
        _passwordBtn.tag = 2000;
    }
    else if(_passwordBtn.tag == 2000){
        [_passwordBtn setImage:[UIImage imageNamed:@"hide_password.png"] forState:UIControlStateNormal];
        self.passwordText.secureTextEntry = YES;
        _passwordBtn.tag = 1000;
    }
}
//跳转到注册页面
-(void)changeToRegister:(id)sender{
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
//忘记密码
-(void)forgetPassword:(id)sender{
    ForgetPasswordViewController *forgetVC = [ForgetPasswordViewController new];
    
    [self.navigationController pushViewController:forgetVC animated:YES];
}

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
    label.text = @"登录";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:titleFont];
    label.textColor = [UIColor colorWithHexString:naiigationTitleColor];
    [view addSubview:label];
    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    [btn addSubview:imgView];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
 
}
@end
