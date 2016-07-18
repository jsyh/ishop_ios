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
#import "NSString+Hashing.h"
#import "UIColor+Hex.h"
#import "MyTabBarViewController.h"
#import "UMSocial.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define H(b) Height * b / 667.0
#define W(a) Width * a / 375.0
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
#define kColorOffButton [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
@interface LoginViewController ()<UITextFieldDelegate>

//用户名
@property (nonatomic,strong)UITextField *userText;
//密码
@property (nonatomic,strong)UITextField *passwordText;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIView *view1;
@property(nonatomic,strong)UIView *view2;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBack;
    [self draw];
    // Do any additional setup after loading the view.
}
-(void)draw{
    
    //背景图

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    UIImage *image = [UIImage imageNamed:@"login_background.png"];
    imgView.image = image;
    [self.view addSubview:imgView];
    //头像
    float logoW = 190.0/750.0;
    float logoH = 156.0/1334.0;
    float centerX = WIDTH/2;
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(centerX-logoW*WIDTH/2, logoH*HEIGHT, logoW*WIDTH, logoW*WIDTH)];
    headView.layer.borderWidth = 1;
    headView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:headView];
    //账号
    float userY = 144.0/1334.0;
    float userX = 72.0/750.0;
    UILabel *loginLab = [[UILabel alloc]initWithFrame:CGRectMake(userX*WIDTH, headView.frame.origin.y + headView.frame.size.height+userY*HEIGHT, 100, 15)];
    loginLab.text = @"登录";
    loginLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    loginLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:loginLab];
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, loginLab.frame.origin.y + loginLab.frame.size.height+15, self.view.frame.size.width, 50)];
    _view1.backgroundColor = [UIColor clearColor];

    UIImageView *userImgView = [[UIImageView alloc]initWithFrame:CGRectMake(userX*WIDTH, 14, 18, 18)];
    userImgView.image = [UIImage imageNamed:@"personal_user_name"];
    [_view1 addSubview:userImgView];
    self.userText = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 80, 50)];
    self.userText.placeholder = @"手机号";
    self.userText.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.userText.font = [UIFont systemFontOfSize:15];
    self.userText.keyboardType = UIKeyboardTypePhonePad;
    self.userText.returnKeyType = UIReturnKeyNext;
    self.userText.delegate = self;
    [_view1 addSubview:self.userText];

    [self.view addSubview:_view1];
    //密码

    _view2 = [[UIView alloc]initWithFrame:CGRectMake(0, _view1.frame.origin.y + _view1.frame.size.height, self.view.frame.size.width, 50)];
    _view2.backgroundColor = [UIColor clearColor];


    
    UIImageView *passwordImgView = [[UIImageView alloc]initWithFrame:CGRectMake(userX*WIDTH, 14, 18, 18)];
    passwordImgView.image = [UIImage imageNamed:@"personal_login_password"];
    [_view2 addSubview:passwordImgView];

    self.passwordText = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 80, 50)];
    self.passwordText.placeholder = @"输入密码";
    self.passwordText.font = [UIFont systemFontOfSize:15];
    self.passwordText.secureTextEntry = YES;
    self.passwordText.returnKeyType = UIReturnKeyDone;
    self.passwordText.delegate = self;
    self.passwordText.textColor = [UIColor colorWithHexString:@"#ffffff"];

    [_view2 addSubview:self.passwordText];
  

    [self.view addSubview:_view2];
    //白线
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(userX*WIDTH, _view1.frame.origin.y, WIDTH-WIDTH*userX*2, 2)];
    view3.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:view3];
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(userX*WIDTH, _view1.frame.size.height + _view1.frame.origin.y, WIDTH-WIDTH*userX*2, 1)];
    view4.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:view4];
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(userX*WIDTH, _view2.frame.size.height+_view2.frame.origin.y, WIDTH-WIDTH*userX*2, 1)];
    view5.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:view5];
    //登录按钮
    float a68 = 68.0/1334.0;
    float a144 = 144.0/1334.0;
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    _loginBtn.frame = CGRectMake(WIDTH*userX, _view2.frame.size.height + _view2.frame.origin.y + a144*HEIGHT, WIDTH-WIDTH*userX*2, a68*HEIGHT) ;
    _loginBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _loginBtn.alpha = 0.8f;
    _loginBtn.layer.cornerRadius = a68*HEIGHT/2;
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor colorWithHexString:@"#ff3b30"] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(actionForLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    //快速注册
    float a24 = 24.0/1334.0;
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    registerBtn.frame = CGRectMake(WIDTH - userX*WIDTH-80, _loginBtn.frame.origin.y + _loginBtn.frame.size.height + a24*HEIGHT, 80, a24*HEIGHT);
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [registerBtn setTitle:@"快速注册>" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(changeToRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    //找回密码
    UIButton *findpasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [findpasswordBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [findpasswordBtn addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];

    findpasswordBtn.frame = CGRectMake(WIDTH*userX, _loginBtn.frame.origin.y+_loginBtn.frame.size.height+a24*HEIGHT, 80, a24*HEIGHT);
    findpasswordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [findpasswordBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.view addSubview:findpasswordBtn];
    //返回按钮
    float a44 = 44.0/750.0;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.frame = CGRectMake(WIDTH-userX*WIDTH-a44*WIDTH, headView.center.y-a44*WIDTH/2, a44*WIDTH, a44*WIDTH);
    [backBtn setImage:[UIImage imageNamed:@"personal_login_cancel"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
#pragma mark --第三方登录
    //微博登录
    UIButton *weiboLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboLoginBtn.frame = CGRectMake(WIDTH/2-100, findpasswordBtn.frame.origin.y+findpasswordBtn.frame.size.height+12, 40, 40);
//    weiboLoginBtn.backgroundColor = [UIColor whiteColor];
    [weiboLoginBtn setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    [weiboLoginBtn addTarget:self action:@selector(weiboLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboLoginBtn];
    //腾讯
    UIButton *qqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqLoginBtn.frame = CGRectMake(WIDTH/2-20, weiboLoginBtn.frame.origin.y, 40, 40);

    [qqLoginBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [qqLoginBtn addTarget:self action:@selector(qqLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqLoginBtn];
    //微信
    UIButton *weixinLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinLoginBtn.frame = CGRectMake(WIDTH/2+60, findpasswordBtn.frame.origin.y+findpasswordBtn.frame.size.height+12, 40, 40);
    [weixinLoginBtn setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [weixinLoginBtn addTarget:self action:@selector(weixinLoginAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:weixinLoginBtn];
    
}
//微博登录
-(void)weiboLoginAction{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSString *userStr = snsAccount.userName;
            NSString *api_token = [RequestModel model:@"user" action:@"auto_login"];
            NSDictionary *dict = @{@"api_token":api_token,@"uid":snsAccount.usid,@"username":snsAccount.userName,@"type":@"weibo"};
            __weak typeof(self) weakSelf = self;
            [RequestModel requestWithDictionary:dict model:@"user" action:@"auto_login" block:^(id result) {
                NSDictionary *dic = result;
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([dic[@"msg"]isEqualToString:@"登录成功"]) {
                        
                        weakSelf.mykey = dic[@"data"][@"key"];
                        
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        NSDictionary *dicc;
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
            
        }});
}
//腾讯登录
-(void)qqLoginAction{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            NSString *userStr = snsAccount.userName;
            NSString *api_token = [RequestModel model:@"user" action:@"auto_login"];
            NSDictionary *dict = @{@"api_token":api_token,@"uid":snsAccount.usid,@"username":snsAccount.userName,@"type":@"qq"};
            __weak typeof(self) weakSelf = self;
            [RequestModel requestWithDictionary:dict model:@"user" action:@"auto_login" block:^(id result) {
                NSDictionary *dic = result;
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([dic[@"msg"]isEqualToString:@"登录成功"]) {
                        
                        weakSelf.mykey = dic[@"data"][@"key"];
                        
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        NSDictionary *dicc;
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

        }});
}
//微信登录
-(void)weixinLoginAction{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSString *userStr = snsAccount.userName;
            NSString *api_token = [RequestModel model:@"user" action:@"auto_login"];
            NSDictionary *dict = @{@"api_token":api_token,@"uid":snsAccount.usid,@"username":snsAccount.userName,@"type":@"weixin"};
            __weak typeof(self) weakSelf = self;
            [RequestModel requestWithDictionary:dict model:@"user" action:@"auto_login" block:^(id result) {
                NSDictionary *dic = result;
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([dic[@"msg"]isEqualToString:@"登录成功"]) {
                        weakSelf.mykey = dic[@"data"][@"key"];
                        
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        NSDictionary *dicc;
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

    });
}
-(void)back{

    if ([self.type isEqualToString:@"购物车"]) {
        MyTabBarViewController * tabBarViewController = (MyTabBarViewController * )self.tabBarController;
        UINavigationController * nav = [tabBarViewController.viewControllers objectAtIndex:4];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [nav popToRootViewControllerAnimated:YES];
        
        UIButton * button = [[UIButton alloc]init];
        button.tag = 104;
        [tabBarViewController buttonClicked:button];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
                NSDictionary *dicc;
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



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
 
}
#pragma mark textfiled delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = _view2.frame;
    int offset = frame.origin.y + 50 - (HEIGHT - 216);
    
    //将试图的y坐标上移offset个单位，以使下面腾出地方用于软键盘的显示
    if (offset > 0) {
        self.view.frame = CGRectMake(0, -offset, WIDTH, HEIGHT);

    }
    
    [UIView commitAnimations];
    
    
    
    
}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
}
@end
