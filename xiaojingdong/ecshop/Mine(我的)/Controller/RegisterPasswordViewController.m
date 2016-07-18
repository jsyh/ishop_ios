//
//  RegisterPasswordViewController.m
//  ecshop
//
//  Created by Jin on 16/4/19.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "RegisterPasswordViewController.h"
#import "UIColor+Hex.h"
#import "RequestModel.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface RegisterPasswordViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *passwordText1;
@property(nonatomic,strong)UITextField *passwordText2;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UIView *view1;
@property(nonatomic,strong)UIView *view2;
@end

@implementation RegisterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self draw];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UILabel *registerLab = [[UILabel alloc]initWithFrame:CGRectMake(userX*WIDTH, headView.frame.origin.y + headView.frame.size.height+userY*HEIGHT, 200, 15)];
    registerLab.text = @"新用户注册-设置密码";
    registerLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    registerLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:registerLab];
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, registerLab.frame.origin.y + registerLab.frame.size.height+15, self.view.frame.size.width, 50)];
    _view1.backgroundColor = [UIColor clearColor];
    
    UIImageView *userImgView = [[UIImageView alloc]initWithFrame:CGRectMake(userX*WIDTH, 14, 18, 18)];
    userImgView.image = [UIImage imageNamed:@"personal_login_password"];
    [_view1 addSubview:userImgView];
    self.passwordText1 = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 80, 50)];
    self.passwordText1.placeholder = @"设置密码";
    self.passwordText1.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.passwordText1.font = [UIFont systemFontOfSize:15];
    self.passwordText1.returnKeyType = UIReturnKeyNext;
    self.passwordText1.delegate = self;
//    [self.passwordText1 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_view1 addSubview:self.passwordText1];
    
    [self.view addSubview:_view1];
    //密码
    
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(0, _view1.frame.origin.y + _view1.frame.size.height, self.view.frame.size.width, 50)];
    _view2.backgroundColor = [UIColor clearColor];
    
    
    
    UIImageView *passwordImgView = [[UIImageView alloc]initWithFrame:CGRectMake(userX*WIDTH, 14, 18, 18)];
    passwordImgView.image = [UIImage imageNamed:@"personal_login_password"];
    [_view2 addSubview:passwordImgView];
    
    self.passwordText2 = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 80, 50)];
    self.passwordText2.placeholder = @"确认密码";
    self.passwordText2.font = [UIFont systemFontOfSize:15];
    self.passwordText2.returnKeyType = UIReturnKeyDone;
    self.passwordText2.delegate = self;
    self.passwordText2.textColor = [UIColor colorWithHexString:@"#ffffff"];
//    [self.passwordText2 addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_view2 addSubview:self.passwordText2];
    
    
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
    [_nextBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor colorWithHexString:@"#ff3b30"] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    //返回按钮
    float a44 = 44.0/750.0;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.frame = CGRectMake(a44*WIDTH, headView.center.y-a44*WIDTH/2, a44*WIDTH, a44*WIDTH);
    [backBtn setImage:[UIImage imageNamed:@"personal_login_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
   
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 完成注册
-(void)nextAction:(id)sender{
    if (_passwordText1.text.length>0) {
        NSLog(@"完成注册");
        if ([_passwordText1.text isEqualToString:_passwordText2.text]) {
            NSString *api_token = [RequestModel model:@"user" action:@"register"];
            NSDictionary *dict = @{@"api_token":api_token,@"passwd":_passwordText1.text,@"code":self.code,@"type":@"0",@"phone":self.phone};
            __weak typeof(self) weakSelf = self;
            [RequestModel requestWithDictionary:dict model:@"user" action:@"register" block:^(id result) {
                NSDictionary *dic = result;
                NSLog(@"获得的数据：%@",dic);
                 NSDictionary *dictt = @{@"api_token":api_token,@"user":weakSelf.phone,@"passwd":weakSelf.passwordText1.text};
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //注册成功后登陆
                    [RequestModel requestWithDictionary:dictt model:@"user" action:@"login" block:^(id result) {
                        NSDictionary *dic = result;
                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                        
                        UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            if ([dic[@"msg"]isEqualToString:@"登录成功"]) {
                                
                                
                                NSDictionary *dicc;
                                dicc = @{@"dic":dic,@"userName":self.phone};
#pragma mark -- 注册通知各页已经登录
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:dicc];
                                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                            }
                        }];
                        [alertVC addAction:cancelAction];
                        [alertVC addAction:okAction];
                        [weakSelf presentViewController:alertVC animated:YES completion:nil];
                        
                        NSLog(@"in");
                    }];
                    
                    
                }];
                [alertVC addAction:cancelAction];
                [alertVC addAction:okAction];
                [weakSelf presentViewController:alertVC animated:YES completion:nil];
            }];
            
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"两次输入密码不一致,请重新输入" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];

    }
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
