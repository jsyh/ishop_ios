//
//  RegisterViewController.m
//  ecshop
//
//  Created by Jin on 15/12/3.
//  Copyright © 2015年 jsyh. All rights reserved.
//注册页

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "RegisterView.h"
#import "RequestModel.h"
#import "UIColor+Hex.h"
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
#define kColorOffButton [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)RegisterView *userView;
@property (nonatomic,strong)RegisterView *emailView;
@property (nonatomic,strong)RegisterView *passwordView1;
@property (nonatomic,strong)RegisterView *passwordView2;
@property (nonatomic,strong)UIButton *registerBtn;
@end

@implementation RegisterViewController

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
    //邮箱
    _emailView = [RegisterView lab:@"邮  箱：" textFiled:@"请填写您的邮箱" frameX:0 frameY:115];
    [_emailView.txtField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_emailView];
    //密码
    _passwordView1 = [RegisterView lab:@"密  码：" textFiled:@"请填写您的密码" frameX:0 frameY:166];
    [_passwordView1.txtField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_passwordView1];
    //确认密码
    _passwordView2 = [RegisterView lab:@"确认密码：" textFiled:@"请再次填写您的密码" frameX:0 frameY:217];
    [_passwordView2.txtField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _passwordView2.txtField.delegate = self;
    [self.view addSubview:_passwordView2];

    //注册按钮
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.frame = CGRectMake(20, _passwordView2.frame.size.height + _passwordView2.frame.origin.y +20, self.view.frame.size.width - 40, 40);
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_registerBtn.layer setCornerRadius:10];
    _registerBtn.backgroundColor = kColorOffButton;
    [_registerBtn setTitle:@"我要注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _registerBtn.userInteractionEnabled = NO;
    [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
}
-(void)textFieldChanged:(id)sender{
    if (_userView.temp.length>0&&_emailView.temp.length>0&&_passwordView1.temp.length>0&&_passwordView2.temp.length>0) {
        _registerBtn.backgroundColor = [UIColor redColor];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerBtn.userInteractionEnabled = YES;
    }else{
        _registerBtn.backgroundColor = kColorOffButton;
        [_registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _registerBtn.userInteractionEnabled = NO;
    }
}

-(void)registerAction:(id)sender{
    
    if ( [self isValidateEmail:_emailView.temp]) {
        if ([_passwordView1.temp isEqualToString: _passwordView2.temp]) {
            NSString *api_token = [RequestModel model:@"user" action:@"register"];
            NSDictionary *dict = @{@"api_token":api_token,@"username":_userView.temp,@"passwd":_passwordView1.temp,@"email":_emailView.temp};
            __weak typeof(self) weakSelf = self;
            [RequestModel requestWithDictionary:dict model:@"user" action:@"register" block:^(id result) {
                NSDictionary *dic = result;
                NSLog(@"获得的数据：%@",dic);
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                [alertVC addAction:cancelAction];
                [alertVC addAction:okAction];
                [weakSelf presentViewController:alertVC animated:YES completion:nil];
            }];
            
        }else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"两次输入的密码不一致，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }else{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"邮箱格式不正确，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    
    
}
//判断是否是邮箱格式
-(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    label.text = @"注册";
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
@end
