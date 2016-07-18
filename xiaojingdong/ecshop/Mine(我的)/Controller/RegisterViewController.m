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
#import "RegisterPasswordViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
#define kColorOffButton [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UIButton *registerBtn;
@property (nonatomic,strong)UITextField *userText;
@property (nonatomic,strong)UITextField *passwordText;
@property (nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UIView *view1;
@property(nonatomic,strong)UIView *view2;
@property(nonatomic,strong)NSString *type;//注册的类型 0邮箱注册，1手机注册
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *phone;
@end

@implementation RegisterViewController

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
    //    UIImage *headImg = [UIImage imageNamed:@"null_head.png"];
    //    headView.image = headImg;
    headView.layer.borderWidth = 1;
    headView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:headView];
    //账号
    float userY = 144.0/1334.0;
    float userX = 72.0/750.0;
    UILabel *registerLab = [[UILabel alloc]initWithFrame:CGRectMake(userX*WIDTH, headView.frame.origin.y + headView.frame.size.height+userY*HEIGHT, 100, 15)];
    registerLab.text = @"新用户注册";
    registerLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    registerLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:registerLab];
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, registerLab.frame.origin.y + registerLab.frame.size.height+15, self.view.frame.size.width, 50)];
    _view1.backgroundColor = [UIColor clearColor];
    
    UIImageView *userImgView = [[UIImageView alloc]initWithFrame:CGRectMake(userX*WIDTH, 14, 18, 18)];
    userImgView.image = [UIImage imageNamed:@"personal_user_name"];
    [_view1 addSubview:userImgView];
    self.userText = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 80, 50)];
    self.userText.placeholder = @"手机号";
    self.userText.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.userText.font = [UIFont systemFontOfSize:15];
    self.userText.returnKeyType = UIReturnKeyNext;
    self.userText.delegate = self;

    [_view1 addSubview:self.userText];
    
    [self.view addSubview:_view1];
    //密码
    
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(0, _view1.frame.origin.y + _view1.frame.size.height, self.view.frame.size.width, 50)];
    _view2.backgroundColor = [UIColor clearColor];
    
    
    
    UIImageView *passwordImgView = [[UIImageView alloc]initWithFrame:CGRectMake(userX*WIDTH, 14, 18, 18)];
    passwordImgView.image = [UIImage imageNamed:@"personal_verify_code"];
    [_view2 addSubview:passwordImgView];
    
    self.passwordText = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 80, 50)];
    self.passwordText.placeholder = @"输入验证码";
    self.passwordText.font = [UIFont systemFontOfSize:15];
  
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
    //下一步按钮
    float a68 = 68.0/1334.0;
    float a144 = 144.0/1334.0;
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _nextBtn.frame = CGRectMake(WIDTH*userX, _view2.frame.size.height + _view2.frame.origin.y + a144*HEIGHT, WIDTH-WIDTH*userX*2, a68*HEIGHT) ;
    _nextBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _nextBtn.alpha = 0.8f;
    _nextBtn.layer.cornerRadius = a68*HEIGHT/2;
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor colorWithHexString:@"#ff3b30"] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    //返回按钮
    float a44 = 44.0/750.0;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.frame = CGRectMake(WIDTH-userX*WIDTH-a44*WIDTH, headView.center.y-a44*WIDTH/2, a44*WIDTH, a44*WIDTH);
    [backBtn setImage:[UIImage imageNamed:@"personal_login_cancel"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
   
    [self.view addSubview:backBtn];
    //获取验证码按钮
    float a70 = 70.0/750.0;
    float a44Y = 44.0/1334.0;
    UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getCodeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    getCodeBtn.alpha = 0.8f;
    getCodeBtn.layer.cornerRadius = a44Y*HEIGHT/2;
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:W(14)];
    getCodeBtn.frame = CGRectMake(WIDTH-WIDTH*userX-a70*WIDTH, 12, a70*WIDTH, a44Y*HEIGHT);
    [getCodeBtn setTitle:@"获取" forState:UIControlStateNormal];
    [getCodeBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
     [getCodeBtn setTitleColor:[UIColor colorWithHexString:@"#ff3b30"] forState:UIControlStateNormal];
    [_view2 addSubview:getCodeBtn];
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}




#pragma mark -- 跳转下一步
-(void)nextAction:(id)sender{
    
    if (_phone.length > 0) {
        if (self.passwordText.text.length > 0) {
            NSDictionary *dictt = @{@"mobile":_phone,@"code":self.passwordText.text};
            __weak typeof(self) weakSelf = self;
            [RequestModel requestWithDictionary:dictt model:@"user" action:@"check_code" block:^(id result) {
                NSLog(@"%@",result);
                if ([result[@"msg"] isEqualToString:@"验证成功"]) {
                    RegisterPasswordViewController *registerVC = [RegisterPasswordViewController new];
                    registerVC.code = _passwordText.text;
                    registerVC.phone = _phone;
                    [self.navigationController pushViewController:registerVC animated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:result[@"msg"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            }];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写您的验证码" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写您的手机号" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    
    
    
    
}
#pragma mark --获取验证码
-(void)getCodeAction:(id)sender{
    if ([self checkPhoneNumInput:_userText.text]) {
        //是手机格式
        _type = @"1";
        _phone = _userText.text;
        
        
        
        NSLog(@"是手机");
        
        
        NSDictionary *dictt = @{@"username":_phone};
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dictt model:@"user" action:@"del_code" block:^(id result) {
            NSLog(@"%@",result);
            
            
            NSDictionary *dict = @{@"mobile":weakSelf.userText.text,@"type":@0};
            
            [RequestModel requestWithDictionary:dict model:@"user" action:@"send" block:^(id result) {
                NSDictionary *dic = result;
                NSLog(@"获得的数据：%@",dic);
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertVC addAction:cancelAction];
                [alertVC addAction:okAction];
                [weakSelf presentViewController:alertVC animated:YES completion:nil];
            }];
            
        }];
        
        
    }else{
        //不是手机格式
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"请输入正确的格式" preferredStyle:UIAlertControllerStyleAlert];
        //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        //            [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    
}




//判断是否是手机格式
-(BOOL)checkPhoneNumInput:(NSString*)string{
  
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|70|77)\\d{8}$";
  
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
  
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
 
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL res1 = [regextestmobile evaluateWithObject:string];
    
    BOOL res2 = [regextestcm evaluateWithObject:string];
    
    BOOL res3 = [regextestcu evaluateWithObject:string];
    
    BOOL res4 = [regextestct evaluateWithObject:string];
    
    
    
    if (res1 || res2 || res3 || res4 )
        
    {
        
        return YES;
        
    }
    
    else
        
    {
        
        return NO;
        
    }
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
