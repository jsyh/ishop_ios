//
//  ChangePasswordViewController.m
//  ecshop
//
//  Created by Jin on 15/12/9.
//  Copyright © 2015年 jsyh. All rights reserved.
//修改密码

#import "ChangePasswordViewController.h"
#import "RegisterView.h"

#import "RequestModel.h"
#import "UIColor+Hex.h"
#define kWIDTH [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *passwordText1;
@property(nonatomic,strong)UITextField *passwordText2;
@property(nonatomic,strong)UITextField *oldPasswordText;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UIView *view1;
@property(nonatomic,strong)UIView *view2;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self draw];
//    [self initNavigationBar];
    // Do any additional setup after loading the view.
}
-(void)draw{
    //背景图
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
    UIImage *image = [UIImage imageNamed:@"login_background.png"];
    imgView.image = image;
    [self.view addSubview:imgView];
    //头像
    float logoW = 190.0/750.0;
    float logoH = 156.0/1334.0;
    float centerX = kWIDTH/2;
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(centerX-logoW*kWIDTH/2, logoH*kHEIGHT, logoW*kWIDTH, logoW*kWIDTH)];
    //    UIImage *headImg = [UIImage imageNamed:@"null_head.png"];
    //    headView.image = headImg;
    headView.layer.borderWidth = 1;
    headView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:headView];
    
    
    //修改密码
    float userY = 144.0/1334.0;
    float userX = 72.0/750.0;
    UILabel *registerLab = [[UILabel alloc]initWithFrame:CGRectMake(userX*kWIDTH, headView.frame.origin.y + headView.frame.size.height+userY*kHEIGHT, 200, 15)];
    registerLab.text = @"修改密码";
    registerLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    registerLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:registerLab];
    
    UIView *view0 = [[UIView alloc]initWithFrame:CGRectMake(0, registerLab.frame.origin.y + registerLab.frame.size.height+15, self.view.frame.size.width, 50)];
    view0.backgroundColor = [UIColor clearColor];
    UIImageView *oldpasswordImg = [[UIImageView alloc]initWithFrame:CGRectMake(userX*kWIDTH, 14, 18, 18)];
    oldpasswordImg.image = [UIImage imageNamed:@"personal_login_password"];
    [view0 addSubview:oldpasswordImg];
    self.oldPasswordText = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 80, 50)];
    self.oldPasswordText.placeholder = @"旧密码";
    self.oldPasswordText.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.oldPasswordText.font = [UIFont systemFontOfSize:15];
    self.oldPasswordText.returnKeyType = UIReturnKeyNext;
    self.oldPasswordText.delegate = self;
    [view0 addSubview:self.oldPasswordText];
    [self.view addSubview:view0];
    
    
    
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, view0.frame.origin.y + view0.frame.size.height, self.view.frame.size.width, 50)];
    _view1.backgroundColor = [UIColor clearColor];
    
    UIImageView *userImgView = [[UIImageView alloc]initWithFrame:CGRectMake(userX*kWIDTH, 14, 18, 18)];
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
    
    
    
    UIImageView *passwordImgView = [[UIImageView alloc]initWithFrame:CGRectMake(userX*kWIDTH, 14, 18, 18)];
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
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(userX*kWIDTH, view0.frame.origin.y, kWIDTH-kWIDTH*userX*2, 2)];
    view3.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:view3];
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(userX*kWIDTH, view0.frame.size.height + view0.frame.origin.y, kWIDTH-kWIDTH*userX*2, 1)];
    view4.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:view4];
    
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(userX*kWIDTH, _view1.frame.size.height + _view1.frame.origin.y, kWIDTH-kWIDTH*userX*2, 1)];
    view5.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:view5];
    UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(userX*kWIDTH, _view2.frame.size.height+_view2.frame.origin.y, kWIDTH-kWIDTH*userX*2, 1)];
    view6.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:view6];
    //下一步按钮
    float a68 = 68.0/1334.0;
    float a144 = 144.0/1334.0;
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _nextBtn.frame = CGRectMake(kWIDTH*userX, _view2.frame.size.height + _view2.frame.origin.y + a144*kHEIGHT, kWIDTH-kWIDTH*userX*2, a68*kHEIGHT) ;
    _nextBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _nextBtn.alpha = 0.8f;
    _nextBtn.layer.cornerRadius = a68*kHEIGHT/2;
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor colorWithHexString:@"#ff3b30"] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(changePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    //返回按钮
    float a44 = 44.0/750.0;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.frame = CGRectMake(a44*kWIDTH, headView.center.y-a44*kWIDTH/2, a44*kWIDTH, a44*kWIDTH);
    [backBtn setImage:[UIImage imageNamed:@"personal_login_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    
}

-(void)changePassword:(id)sender{
    NSLog(@"修改密码");
    NSString *api_token = [RequestModel model:@"user" action:@"modifypasswd"];
    NSDictionary *dict = @{@"api_token":api_token,@"new_pwd":_passwordText1.text,@"user_pwd":_oldPasswordText.text,@"key":self.tempDic[@"data"][@"key"]};
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
#pragma mark textfiled delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = _view2.frame;
    int offset = frame.origin.y + 50 - (kHEIGHT - 216);
    
    //将试图的y坐标上移offset个单位，以使下面腾出地方用于软键盘的显示
    if (offset > 0) {
        self.view.frame = CGRectMake(0, -offset, kWIDTH, kHEIGHT);
        
    }
    
    [UIView commitAnimations];
    
    
    
    
}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame = CGRectMake(0, 0, kWIDTH, kHEIGHT);
}
//关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
