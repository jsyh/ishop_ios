//
//  RechargeViewController.m
//  ecshop
//
//  Created by Jin on 16/1/5.
//  Copyright © 2016年 jsyh. All rights reserved.
//充值页

#import "RechargeViewController.h"
#import "AppDelegate.h"
#import "RequestModel.h"
#import "UIColor+Hex.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <AlipaySDK/AlipaySDK.h>
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
#define kColorOffButton [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
@interface RechargeViewController ()<UITextFieldDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIButton *button;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBack;
   
    [self draw];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}
-(void)draw{
    //账户余额
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, self.view.frame.size.width, 40)];
    label.font = [UIFont systemFontOfSize:15];
//    label.text = @"账户余额：";
    label.text = [NSString stringWithFormat:@"账户余额： %@",self.temp];
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    //充值的金额
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 120, self.view.frame.size.width - 20, 50)];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.placeholder = @"请输入您要充值的金额!";
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_textField];
    //充值按钮
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(20, 200, self.view.frame.size.width - 40, 40);
    _button.titleLabel.font = [UIFont systemFontOfSize:15];
    [_button.layer setCornerRadius:10];
    [_button setTitle:@"充值" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _button.userInteractionEnabled = NO;
    _button.backgroundColor = kColorOffButton;
    [_button addTarget:self action:@selector(charge:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}
-(void)charge:(id)sender{
    

    [_textField resignFirstResponder];
    UIActionSheet *menu = [[UIActionSheet alloc]initWithTitle:@"选择充值平台" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
    menu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        //支付宝
        [self recharge];
    }else if(buttonIndex == 1){
        //微信
        [self WXrecharge];
    }
    
    
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
#pragma mark -- 微信充值
- (void)WXrecharge{
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"没有安装微信");

    }else if (![WXApi isWXAppSupportApi]){
        NSLog(@"不支持微信支付");

    }else{
        NSLog(@"安装了微信，而且微信支持支付");
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString *api_token = [RequestModel model:@"user" action:@"recharge"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"price":_textField.text,@"type":@"2"};
         __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"user" action:@"recharge" block:^(id result) {
            NSDictionary *dic = result;
            NSLog(@"%@",dic);
            NSDictionary *dictt = dic[@"data"];
            NSMutableString *stamp  = [dictt objectForKey:@"timestamp"];
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dictt objectForKey:@"partnerid"];//商户号
            req.prepayId            = [dictt objectForKey:@"prepayid"];//预支付交易会话ID
            req.nonceStr            = [dictt objectForKey:@"noncestr"];//随机字符串
            req.timeStamp           = stamp.intValue;//签名
            req.package             = [dictt objectForKey:@"package"];//扩展字段，暂歇固定值 Sign=WXPay
            req.sign                = [dictt objectForKey:@"sign"];//签名
            [WXApi sendReq:req];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dictt objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }];
    }
   
}

#pragma mark -- 支付宝充值
- (void)recharge{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"user" action:@"recharge"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"price":_textField.text,@"type":@"1"};

    [RequestModel requestWithDictionary:dict model:@"user" action:@"recharge" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        NSString *orderString = dic[@"data"];
        __weak typeof(self) weakSelf = self;
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdk";
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message: resultDic[@"memo"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        }];
    }];
}
-(void)textFieldChanged:(id)sender{
    if (_textField.text.length>0) {
        _button.backgroundColor = [UIColor redColor];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.userInteractionEnabled = YES;
    }else{
        _button.backgroundColor = kColorOffButton;
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _button.userInteractionEnabled = NO;
    }
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
    
    label.text = @"账户充值";
    
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
