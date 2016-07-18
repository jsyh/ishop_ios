//
//  fourthViewController.m
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//第四页

#import "fourthViewController.h"
#import "AppDelegate.h"
#import "MineTableViewCell.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "OpinionViewController.h"
#import "SettingViewController.h"
#import "MyAccountViewController.h"
#import "AddressViewController.h"
#import "RequestModel.h"
#import "PersonalInfoModel.h"
#import "MyAttentionViewController.h"
#import "RechargeViewController.h"
#import "MyTabBarViewController.h"
#import "UIColor+Hex.h"
#import "CouponsViewController.h"
#import "IntegrationViewController.h"
#import "MyMoneyViewController.h"
#import "MyAttentionShopViewController.h"
#import "MyEvaluationViewController.h"
#import "AboutViewController.h"
#import "MyAllOrderViewController.h"
#import "ReturnGoodsViewController.h"
#import "GXCustomButton.h"
#import "HelpViewController.h"
//尾视图按钮高度


//:CGRectMake(W(90), H(35), W(80), H(15))
#define kViewHeight 50
#define kColorBack [UIColor colorWithHexString:@"#f2f2f2"]
@interface fourthViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    GXCustomButton *button1;
    GXCustomButton *button2;
    GXCustomButton *button3;
    GXCustomButton *button4;
}
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSString *mykey;
@property (nonatomic,assign)NSInteger tagg;
@property (nonatomic,strong)NSMutableArray *modArray;
@property (nonatomic,strong)PersonalInfoModel *model;
//关注商品的label
@property (nonatomic,strong)UILabel *labelForGoods1;
//余额
@property (nonatomic,strong)UILabel *labelForBalance1;
//积分
@property (nonatomic,strong)UILabel *labelForIntegration1;
//用户名
@property (nonatomic,strong)UILabel *label1;
//未登录
@property (nonatomic,strong)UIView *viewForLogin;
//已登录
@property (nonatomic,strong)UIView *viewForLogin1;
//登录后头像
@property (nonatomic,strong)UIImageView *headView1;
@property (nonatomic,strong)NSString *waitPayNum;//待付款个数
@property (nonatomic,strong)NSString *waitSendNum;//待发货个数
@property (nonatomic,strong)NSString *waitReceiveNum;//待收货个数
@property (nonatomic,strong)NSString *completedNum;//已完成个数
@property (nonatomic,strong)NSString *payStr;//待付款角标
@property (nonatomic,strong)NSString *shippingSendStr;//待发货角标
@property (nonatomic,strong)NSString *shippingStr;//待收货角标
@property (nonatomic,strong)NSString *commentStr;//待评价角标

@property(nonatomic,strong) UIButton *signBtn;//签到按钮
@property(nonatomic,strong)UIImageView *backgroundView;//签到的背景
@property(nonatomic,strong)UIButton *settingBtn;//设置按钮

@end

@implementation fourthViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:NO];
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    self.tempDic = app.tempDic;
    if (app.tempDic == nil) {
        //未登录
        _viewForLogin.hidden = NO;
        _viewForLogin1.hidden = YES;
        self.tagg = 1;
        [self.table reloadData];
    }else{
        //登录后
        self.userName = app.userName;
        _viewForLogin.hidden = YES;
        _viewForLogin1.hidden = NO;
        
        [self myAccount];
        self.tagg = 2;
        [self.table reloadData];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
        NSLog(@"imageFile->>%@",imageFilePath);
        UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//
        if (selfPhoto != nil) {
            _headView1.image = selfPhoto;
            [_headView1.layer setCornerRadius:CGRectGetHeight([_headView1 bounds]) / 2];  //修改半径，实现头像的圆形化
            _headView1.layer.masksToBounds = YES;
        }else{
            UIImage *headImg = [UIImage imageNamed:@"comment_user_photo"];
            _headView1.image = headImg;
        }
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    self.view.backgroundColor = kColorBack;
    [self draw];
    [self draw1];
    UIImage *img = [UIImage imageNamed:@"个人中心-标题栏-设置icon.png"];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    
    // Do any additional setup after loading the view.
}
#pragma mark --我关注的商品等请求的数据
-(void)mygoods{
    
}
-(void)change:(id)sender{
    SettingViewController *settingVC = [SettingViewController new];
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    settingVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark --跳转我的红包
-(void)goodsAction:(id)sender{
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    CouponsViewController *couponsVC = [[CouponsViewController alloc]init];
    [self.navigationController pushViewController:couponsVC animated:YES];
    
}
#pragma mark --跳转到我的积分
-(void)changeToCharge:(id)sender{
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    IntegrationViewController *integrationVC = [[IntegrationViewController alloc]init];
    integrationVC.integrationStr = self.model.integration;
    integrationVC.qd = self.model.qd;
    integrationVC.points = self.model.points;
    integrationVC.type = @"1";
    [self.navigationController pushViewController:integrationVC animated:YES];
//    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
//    [tabbar hiddenTabbar:YES];
//    RechargeViewController *reVC = [RechargeViewController new];
//    reVC.temp = _labelForBalance1.text;
//    [self.navigationController pushViewController:reVC animated:YES];
}
#pragma mark --跳转到我的余额界面
-(void)myMoney{
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    MyMoneyViewController *moneyVC = [MyMoneyViewController new];
    moneyVC.moneyStr =  self.model.user_money;
    [self.navigationController pushViewController:moneyVC animated:YES];
}
#pragma mark --登录后跳转到个人设置页面
-(void)changeToMine:(id)sender{
    MyAccountViewController *myVC = [MyAccountViewController new];
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    myVC.hidesBottomBarWhenPushed = YES;
    myVC.tempDic = self.tempDic;
    myVC.userName = self.userName;
    [self.navigationController pushViewController:myVC animated:YES];
}
#pragma mark -- 登录后
-(void)draw1{
   
    _viewForLogin1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    _viewForLogin1.hidden = YES;
    [self initNavigationBar];
    //背景图
    //    UIImageView *imgView = [[UIImageView alloc]initWithFrame:[app createFrameWithX:0 andY:0 andWidth:375 andHeight:250]];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, H(200))];
    imgView.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageNamed:@"personal_bg"];
    
    imgView.image = image;
    
//    [_viewForLogin1 addSubview:imgView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 20, imgView.frame.size.width, imgView.frame.size.height - 84);
    [button addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:button];
    //头像
    float headY90 = 90.0/1334.0;
    float headX70 = 70.0/750.0;
    float headW124 = 124.0/750.0;
    _headView1 = [[UIImageView alloc]initWithFrame:CGRectMake(headX70*Width, headY90*Height, Width*headW124, Width*headW124)];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//
    if (selfPhoto != nil) {
        _headView1.image = selfPhoto;
        [_headView1.layer setCornerRadius:CGRectGetHeight([_headView1 bounds]) / 2];  //修改半径，实现头像的圆形化
        _headView1.layer.masksToBounds = YES;
    }else{
        UIImage *headImg = [UIImage imageNamed:@"personal_photo"];
        _headView1.image = headImg;
    }
    
    
    [imgView addSubview:_headView1];

    

    //我的红包按钮
 
    UIButton *goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    goodsBtn.frame =CGRectMake(0, _headView1.frame.size.height+_headView1.frame.origin.y+H(35), Width/3, H(40));
    //红包数量
    
    _labelForGoods1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width/3, H(15))];
    _labelForGoods1.text = @"0";
    _labelForGoods1.font = [UIFont systemFontOfSize:W(15)];
    _labelForGoods1.textColor = [UIColor whiteColor];
    _labelForGoods1.textAlignment = NSTextAlignmentCenter;
    [goodsBtn addSubview:_labelForGoods1];
    
    
    UILabel *labelForGoods2 = [[UILabel alloc]initWithFrame:CGRectMake(0, H(20), self.view.frame.size.width/3, H(15))];
    labelForGoods2.text = @"我的红包";
    labelForGoods2.font = [UIFont systemFontOfSize:W(14)];
    labelForGoods2.textColor = [UIColor whiteColor];
    labelForGoods2.textAlignment = NSTextAlignmentCenter;
    [goodsBtn addSubview:labelForGoods2];
    [goodsBtn addTarget:self action:@selector(goodsAction:) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:goodsBtn];
    //我的积分按钮
    UIButton *balanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [balanceBtn addTarget:self action:@selector(changeToCharge:) forControlEvents:UIControlEventTouchUpInside];
    
    balanceBtn.frame = CGRectMake(Width/3, _headView1.frame.size.height+_headView1.frame.origin.y+H(35), Width/3, H(40));
    //我的积分
    
    _labelForBalance1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width/3, H(15))];
    _labelForBalance1.text = @"0";
    _labelForBalance1.font = [UIFont systemFontOfSize:W(15)];
    _labelForBalance1.textColor = [UIColor whiteColor];
    _labelForBalance1.textAlignment = NSTextAlignmentCenter;
    [balanceBtn addSubview:_labelForBalance1];
    
    
    UILabel *labelForBalance2 = [[UILabel alloc]initWithFrame:CGRectMake(0,H(20), Width/3, H(15))];
    labelForBalance2.text = @"我的积分";
    labelForBalance2.font = [UIFont systemFontOfSize:W(14)];
    labelForBalance2.textColor = [UIColor whiteColor];
    labelForBalance2.textAlignment = NSTextAlignmentCenter;
    [balanceBtn addSubview:labelForBalance2];
    [imgView addSubview:balanceBtn];
    //我的余额按钮
    UIButton *integrationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    integrationBtn.frame =CGRectMake(Width-Width/3, _headView1.frame.size.height+_headView1.frame.origin.y+H(35), Width/3, H(40));
    [integrationBtn addTarget:self action:@selector(myMoney) forControlEvents:UIControlEventTouchUpInside];
    //我的余额
    _labelForIntegration1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width/3, H(15))];
    _labelForIntegration1.text = @"0";
    _labelForIntegration1.font = [UIFont systemFontOfSize:W(15)];
    _labelForIntegration1.textColor = [UIColor whiteColor];
    _labelForIntegration1.textAlignment = NSTextAlignmentCenter;
    [integrationBtn addSubview:_labelForIntegration1];
    
    UILabel *labelForIntegration2 = [[UILabel alloc]initWithFrame:CGRectMake(0, H(20), Width/3, H(15))];
    labelForIntegration2.text = @"我的余额";
    labelForIntegration2.font = [UIFont systemFontOfSize:W(14)];
    labelForIntegration2.textColor = [UIColor whiteColor];
    labelForIntegration2.textAlignment = NSTextAlignmentCenter;
    [integrationBtn addSubview:labelForIntegration2];
    [imgView addSubview:integrationBtn];
    
    //线条
    
    UIView *viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(goodsBtn.frame.size.width, goodsBtn.frame.origin.y+H(10), 1, H(20))];
    viewLine1.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [imgView addSubview:viewLine1];
    
    UIView *viewLine2 = [[UIView alloc]initWithFrame:CGRectMake(Width-goodsBtn.frame.size.width, goodsBtn.frame.origin.y+H(10), 1, H(20))];
    viewLine2.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [imgView addSubview:viewLine2];
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-H(55)) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.tableHeaderView = imgView;
    _table.dataSource = self;
    _table.backgroundColor = kColorBack;
    [_table setShowsVerticalScrollIndicator:NO];
    [self setExtraCellLineHidden:_table];
    
    //用户名label
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(_headView1.frame.size.width+_headView1.frame.origin.x+W(12), _headView1.center.y-H(7.5), W(200), H(15))];
    _label1.text = self.userName;
    _label1.font = [UIFont systemFontOfSize:W(15)];
    _label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [imgView addSubview:_label1];
    
    //签到
    _backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(Width - W(75), _headView1.center.y-H(20)/2, W(75), H(25))];
    _backgroundView.image = [UIImage imageNamed:@"sign_background"];
    _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signBtn.frame = CGRectMake(0, 0, _backgroundView.frame.size.width, _backgroundView.frame.size.height);
    [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [_signBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _signBtn.titleLabel.font = [UIFont systemFontOfSize:W(14)];
    [_signBtn setImage:[UIImage imageNamed:@"signed"] forState:UIControlStateNormal];

    _signBtn.imageEdgeInsets = UIEdgeInsetsMake(0, W(33), 0, -W(33));
    _signBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -W(23), 0, W(23));
    [_signBtn addTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_signBtn];
    _backgroundView.userInteractionEnabled = YES;
    [imgView addSubview:_backgroundView];
    
    //设置按钮
    
    UIImage *img = [UIImage imageNamed:@"personal_setup"];
    _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingBtn.frame = CGRectMake(_backgroundView.frame.origin.x -2*W(20), _headView1.center.y-W(20)/2, W(20), W(20));
    [_settingBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [_settingBtn setBackgroundImage:img forState:UIControlStateNormal];
    [imgView addSubview:_settingBtn];
    [_viewForLogin1 addSubview:_table];
    
    [self.view addSubview:_viewForLogin1];
}
-(void)signAction:(UIButton *)button{
    NSLog(@"签到");

//    NSString *signText = _signBtn.titleLabel.text;
//    if ([signText isEqualToString:@"签到"]) {
//        NSString *api_token = [RequestModel model:@"attendance" action:@"qiandao"];
//        UIApplication *appli=[UIApplication sharedApplication];
//        AppDelegate *app=appli.delegate;
//        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"]};
//        
//        __weak typeof(self) weakSelf = self;
//        [RequestModel requestWithDictionary:dict model:@"attendance" action:@"qiandao" block:^(id result) {
//            NSDictionary *dic = result;
//            NSLog(@"%@",dic);
//            NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
//            if ([code isEqualToString:@"1"]) {
//                weakSelf.backgroundView.frame = CGRectMake(Width - W(95), weakSelf.headView1.center.y-H(20)/2, W(95), H(25));
//                weakSelf.settingBtn.frame = CGRectMake(weakSelf.backgroundView.frame.origin.x -2*W(20), weakSelf.headView1.center.y-W(20)/2, W(20), W(20));
//                [weakSelf.signBtn setTitle:@"已签到" forState:UIControlStateNormal];
//                weakSelf.signBtn.imageEdgeInsets = UIEdgeInsetsMake(0, W(55), 0, -W(55));
//                weakSelf.signBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -W(13), 0, W(13));
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:dic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
//            }
//        }];
//       
//    }else{
//        MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
//        [tabbar hiddenTabbar:YES];
//        IntegrationViewController *integrationVC = [[IntegrationViewController alloc]init];
//        integrationVC.integrationStr = self.model.integration;
//        integrationVC.qd = @"1";
//        integrationVC.points = self.model.points;
//        [self.navigationController pushViewController:integrationVC animated:YES];
//    }
    
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    IntegrationViewController *integrationVC = [[IntegrationViewController alloc]init];
    integrationVC.integrationStr = self.model.integration;
    NSString *name = button.titleLabel.text;
    if ([name isEqualToString:@"签到"]) {
        integrationVC.qd = @"0";
    }else{
        integrationVC.qd = @"1";
    }
    
    integrationVC.points = self.model.points;
    integrationVC.type = @"0";
    [self.navigationController pushViewController:integrationVC animated:YES];

    
}
#pragma mark -- 未登录
-(void)draw{
   
    _viewForLogin = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    _viewForLogin.hidden = NO;
    [self initNavigationBar];
    //背景图
  
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, 200)];
    imgView.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageNamed:@"personal_bg"];
    imgView.image = image;
//    [_viewForLogin addSubview:imgView];
    
    //登录按钮
    float aW206 = 206.0/750.0;
    float aY120 = 120.0/1334.0;
    UIView *loginBackView = [[UIView alloc]initWithFrame:CGRectMake(Width/2-aW206*Width/2, aY120*Height, aW206*Width, 40)];
    loginBackView.backgroundColor = [UIColor blackColor];
    loginBackView.layer.cornerRadius = 20;
    loginBackView.alpha = 0.25;
    [imgView addSubview:loginBackView];
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor clearColor];
    loginBtn.frame = CGRectMake(Width/2-aW206*Width/2, aY120*Height, aW206*Width, 40);
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(changeToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:loginBtn];
    
    //设置按钮
    float aX70 = 70.0/750.0;
    float aW40 = 40.0/750.0;
    UIImage *img = [UIImage imageNamed:@"personal_setup"];
    UIButton *settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width-Width*aX70-aW40*Width, loginBackView.center.y-aW40*Width/2, aW40*Width, aW40*Width)];
    [settingBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setBackgroundImage:img forState:UIControlStateNormal];
    [imgView addSubview:settingBtn];
    
    //我的红包
    float aY96 = 96.0/1334.0;
    UILabel *hongbaoNumLab = [[UILabel alloc]initWithFrame:CGRectMake(0, loginBackView.frame.size.height+loginBackView.frame.origin.y+aY96*Height, Width/3, 15)];
    hongbaoNumLab.text = @"0";
    hongbaoNumLab.font = [UIFont systemFontOfSize:15];
    hongbaoNumLab.textAlignment = NSTextAlignmentCenter;
    hongbaoNumLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [imgView addSubview:hongbaoNumLab];
    
    UILabel *hongbaoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, hongbaoNumLab.frame.size.height+hongbaoNumLab.frame.origin.y+6, Width/3, 15)];
    hongbaoLab.text = @"我的红包";
    hongbaoLab.font = [UIFont systemFontOfSize:14];
    hongbaoLab.textAlignment = NSTextAlignmentCenter;
    hongbaoLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [imgView addSubview:hongbaoLab];
    
    //我的积分
    UILabel *myIntegralNumLab = [[UILabel alloc]initWithFrame:CGRectMake(Width/3, loginBackView.frame.size.height+loginBackView.frame.origin.y+aY96*Height, Width/3, 15)];
    myIntegralNumLab.text = @"0";
    myIntegralNumLab.font = [UIFont systemFontOfSize:15];
    myIntegralNumLab.textAlignment = NSTextAlignmentCenter;
    myIntegralNumLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [imgView addSubview:myIntegralNumLab];
    UILabel *myIntegralLab = [[UILabel alloc]initWithFrame:CGRectMake(Width/3, hongbaoNumLab.frame.size.height+hongbaoNumLab.frame.origin.y+6, Width/3, 15)];
    myIntegralLab.text = @"我的积分";
    myIntegralLab.font = [UIFont systemFontOfSize:14];
    myIntegralLab.textAlignment = NSTextAlignmentCenter;
    myIntegralLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [imgView addSubview:myIntegralLab];
    //我的余额
    UILabel *myMoneyNumLab = [[UILabel alloc]initWithFrame:CGRectMake((Width/3)*2, loginBackView.frame.size.height+loginBackView.frame.origin.y+aY96*Height, Width/3, 15)];
    myMoneyNumLab.text = @"0";
    myMoneyNumLab.font = [UIFont systemFontOfSize:15];
    myMoneyNumLab.textAlignment = NSTextAlignmentCenter;
    myMoneyNumLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [imgView addSubview:myMoneyNumLab];
    UILabel *myMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake((Width/3)*2, hongbaoNumLab.frame.size.height+hongbaoNumLab.frame.origin.y+6, Width/3, 15)];
    myMoneyLab.text = @"我的余额";
    myMoneyLab.font = [UIFont systemFontOfSize:14];
    myMoneyLab.textAlignment = NSTextAlignmentCenter;
    myMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [imgView addSubview:myMoneyLab];
    //画线
    UIView *viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(hongbaoLab.frame.size.width, hongbaoNumLab.frame.origin.y+10, 1, 20)];
    viewLine1.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [imgView addSubview:viewLine1];
    
    UIView *viewLine2 = [[UIView alloc]initWithFrame:CGRectMake(Width-hongbaoLab.frame.size.width, hongbaoNumLab.frame.origin.y+10, 1, 20)];
    viewLine2.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [imgView addSubview:viewLine2];
    
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-50) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.tableHeaderView = imgView;
    _table.dataSource = self;
    _table.backgroundColor = kColorBack;
    [_viewForLogin addSubview:_table];
 
    [self.view addSubview:_viewForLogin];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)changeToLogin:(id)sender{
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
-(void)changeToRegister:(id)sender{
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }else if(section == 3){
        return 2;
    }else if(section == 4){
        return 2;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    if (section == 0) {
        
        UIView *view11 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        float size = Width/5;
        view11.backgroundColor = [UIColor whiteColor];
        //button1
        button1 = [[GXCustomButton alloc]init];
        
        button1.frame = CGRectMake(0, 0,size, kViewHeight);
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button1 setTitle:@"待付款" forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"personal_order_unpaid"] forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:11];
        button1.titleLabel.textAlignment = NSTextAlignmentCenter;
        button1.imageView.contentMode = UIViewContentModeCenter;
        [button1 addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
       UIView * smallView1 = [[UIView alloc]initWithFrame:CGRectMake(button1.frame.size.width - W(35), H(3), 12, 12)];
        smallView1.backgroundColor = [UIColor redColor];
        [smallView1.layer setCornerRadius:6];
        UILabel *smallLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        smallLab1.font = [UIFont systemFontOfSize:8];
        if (_payStr.length >0) {
            if ([_payStr isEqualToString:@"0"]) {
                smallView1.hidden = YES;
            }else{
                smallView1.hidden = NO;
            }
        }else{
            smallView1.hidden = YES;
        }
            
        
        smallLab1.text = _payStr;
        smallLab1.textAlignment = NSTextAlignmentCenter;
        smallLab1.textColor = [UIColor whiteColor];
        [smallView1 addSubview:smallLab1];
        [button1 addSubview:smallView1];
        
        
        [view11 addSubview:button1];
        //button2
        button2 = [[GXCustomButton alloc]init];
        
        button2.frame = CGRectMake(size, 0, size, kViewHeight);
        [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"personal_order_unsend"] forState:UIControlStateNormal];
        [button2 setTitle:@"待发货" forState:UIControlStateNormal];

        button2.titleLabel.font = [UIFont systemFontOfSize:11];
        button2.titleLabel.textAlignment = NSTextAlignmentCenter;
        button2.imageView.contentMode = UIViewContentModeCenter;
        [button2 addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView * smallView2 = [[UIView alloc]initWithFrame:CGRectMake(button2.frame.size.width - W(35), H(3), 12, 12)];
        smallView2.backgroundColor = [UIColor redColor];
        [smallView2.layer setCornerRadius:6];
        UILabel *smallLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        smallLab2.font = [UIFont systemFontOfSize:8];
        if (_shippingSendStr.length >0) {
            if ([_shippingSendStr isEqualToString:@"0"]) {
                smallView2.hidden = YES;
            }else{
                smallView2.hidden = NO;
            }
        }else{
            smallView2.hidden = YES;
        }
        
        
        smallLab2.text = _shippingSendStr;
        smallLab2.textAlignment = NSTextAlignmentCenter;
        smallLab2.textColor = [UIColor whiteColor];
        [smallView2 addSubview:smallLab2];
        [button2 addSubview:smallView2];
        
        
        [view11 addSubview:button2];
        //button3
        button3 = [[GXCustomButton alloc]init];
        
        button3.frame = CGRectMake(size*2, 0, size, kViewHeight);
        [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button3.titleLabel.textAlignment = NSTextAlignmentCenter;
        button3.imageView.contentMode = UIViewContentModeCenter;
        [button3 setTitle:@"待收货" forState:UIControlStateNormal];
        [button3 setImage:[UIImage imageNamed:@"personal_order_unreceived"] forState:UIControlStateNormal];

        button3.titleLabel.font = [UIFont systemFontOfSize:11];
        
        
        [button3 addTarget:self action:@selector(receivedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * smallView3 = [[UIView alloc]initWithFrame:CGRectMake(button3.frame.size.width - W(35), H(3), 12, 12)];
        smallView3.backgroundColor = [UIColor redColor];
        [smallView3.layer setCornerRadius:6];
        UILabel *smallLab3= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        smallLab3.font = [UIFont systemFontOfSize:8];
        if (_shippingStr.length >0) {
            if ([_shippingStr isEqualToString:@"0"]) {
                smallView3.hidden = YES;
            }else{
                smallView3.hidden = NO;
            }
        }else{
            smallView3.hidden = YES;
        }
        
        
        smallLab3.text = _shippingStr;
        smallLab3.textAlignment = NSTextAlignmentCenter;
        smallLab3.textColor = [UIColor whiteColor];
        [smallView3 addSubview:smallLab3];
        [button3 addSubview:smallView3];
        
        [view11 addSubview:button3];
        //button4
        button4 = [[GXCustomButton alloc]init];
        
        button4.frame = CGRectMake(size*3, 0, size, kViewHeight);
        [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button4 setTitle:@"待评价" forState:UIControlStateNormal];
        [button4 addTarget:self action:@selector(waitComment:) forControlEvents:UIControlEventTouchUpInside];
        [button4 setImage:[UIImage imageNamed:@"personal_order_uncomment"] forState:UIControlStateNormal];
        button4.titleLabel.textAlignment = NSTextAlignmentCenter;
        button4.imageView.contentMode = UIViewContentModeCenter;
        button4.titleLabel.font = [UIFont systemFontOfSize:11];
        UIView * smallView4 = [[UIView alloc]initWithFrame:CGRectMake(button4.frame.size.width - W(35), H(3), 12, 12)];
        smallView4.backgroundColor = [UIColor redColor];
        [smallView4.layer setCornerRadius:6];
        UILabel *smallLab4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        smallLab4.font = [UIFont systemFontOfSize:8];
        if (_commentStr.length >0) {
            if ([_commentStr isEqualToString:@"0"]) {
                smallView4.hidden = YES;
            }else{
                smallView4.hidden = NO;
            }
        }else{
            smallView4.hidden = YES;
        }
        
        
        smallLab4.text = _commentStr;
        smallLab4.textAlignment = NSTextAlignmentCenter;
        smallLab4.textColor = [UIColor whiteColor];
        [smallView4 addSubview:smallLab4];
        [button4 addSubview:smallView4];
        [view11 addSubview:button4];
        
        //button5
        GXCustomButton *button5 = [[GXCustomButton alloc]init];
        
        button5.frame = CGRectMake(size*4, 0, size, kViewHeight);
        [button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button5 setImage:[UIImage imageNamed:@"personal_order_unservice"] forState:UIControlStateNormal];
        [button5 setTitle:@"退款/售后" forState:UIControlStateNormal];
        

        button5.titleLabel.font = [UIFont systemFontOfSize:11];
        button5.titleLabel.textAlignment = NSTextAlignmentCenter;
        button5.imageView.contentMode = UIViewContentModeCenter;
        [button5 addTarget:self action:@selector(customerAction:) forControlEvents:UIControlEventTouchUpInside];
        [view11 addSubview:button5];
        //线条
        UIView *viewLine1 = [[UIView alloc]init];
        viewLine1.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
        viewLine1.backgroundColor = kColorBack;
        [view11 addSubview:viewLine1];
        
        return view11;
    }else{
        return nil;
    }
}
//待付款
-(void)payAction:(id)sender{
    NSLog(@"待付款");
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    if (self.tagg == 1) {
        LoginViewController *registerVC = [LoginViewController new];
        [self.navigationController pushViewController:registerVC animated:YES];
    }else if(self.tagg == 2){
        //我的订单
        MyAllOrderViewController *myVC = [MyAllOrderViewController new];
        myVC.index = 1;
        myVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myVC animated:YES];
    }
    
}
//待发货
-(void)sendAction:(id)sender{
    NSLog(@"待发货");
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    if (self.tagg == 1) {
        LoginViewController *registerVC = [LoginViewController new];
        [self.navigationController pushViewController:registerVC animated:YES];
    }else if (self.tagg == 2){
        //我的订单
        MyAllOrderViewController *myVC = [MyAllOrderViewController new];
        myVC.hidesBottomBarWhenPushed = YES;
        myVC.index = 2;
        [self.navigationController pushViewController:myVC animated:YES];
    }
}
//待收货
-(void)receivedAction:(id)sender{
    NSLog(@"待收货");
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    if (self.tagg == 1) {
        LoginViewController *registerVC = [LoginViewController new];
        [self.navigationController pushViewController:registerVC animated:YES];
    }else if (self.tagg == 2){
        //我的订单
        MyAllOrderViewController *myVC = [MyAllOrderViewController new];
        myVC.hidesBottomBarWhenPushed = YES;
        myVC.index = 3;
        [self.navigationController pushViewController:myVC animated:YES];
    }
}
//待评价
-(void)waitComment:(id)sender{
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    if (self.tagg == 1) {
        LoginViewController *registerVC = [LoginViewController new];
        [self.navigationController pushViewController:registerVC animated:YES];
    }else if (self.tagg == 2){
        //我的订单
        MyAllOrderViewController *myVC = [MyAllOrderViewController new];
        myVC.hidesBottomBarWhenPushed = YES;
        myVC.index = 4;
        [self.navigationController pushViewController:myVC animated:YES];
    }
}
//已完成
-(void)customerAction:(id)sender{
    NSLog(@"售后");
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
    if (self.tagg == 1) {
        LoginViewController *registerVC = [LoginViewController new];
        [self.navigationController pushViewController:registerVC animated:YES];
    }else if (self.tagg == 2){
        ReturnGoodsViewController *myVC = [ReturnGoodsViewController new];

        [self.navigationController pushViewController:myVC animated:YES];
    }
}
//尾视图大小
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }else{
        return 1;
    }
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00001;
    }else if (section == 1) {
        return 10;
    }else{
        return 9;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"cell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:self options:nil]lastObject];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.lab.text = @"全部订单";
            cell.img.image = [UIImage imageNamed:@"personal_total_orders"];
            cell.lab2.text = @"查看全部购买商品";
            cell.lab2.textAlignment = NSTextAlignmentRight;
            
        }
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.lab.text = @"收藏的商品";
            cell.img.image = [UIImage imageNamed:@"personal_collected_goods"];
            if (self.model.attention.length>0) {
                cell.lab2.text = self.model.attention;
            }else{
                cell.lab2.text = @"0";
            }
            
        }else{
            if (self.model.supplier.length>0) {
                cell.lab2.text = self.model.supplier;
            }else{
                cell.lab2.text = @"0";
            }
            cell.lab.text = @"收藏的店铺";
            cell.img.image = [UIImage imageNamed:@"personal_collected_shops"];
        }
        
    }else if(indexPath.section == 2){
        cell.lab.text = @"地址管理";
        cell.img.image = [UIImage imageNamed:@"personal_address_manager"];
        cell.lab2.text = @"";
    }else if(indexPath.section == 3){
        if (indexPath.row == 0) {
            cell.lab.text = @"我的评价";
            cell.img.image = [UIImage imageNamed:@"personal_my_comments"];
            cell.lab2.text = @"";
        }else{
            cell.lab.text = @"我的分享";
            cell.img.image = [UIImage imageNamed:@"personal_my_share"];
            cell.lab2.text = @"";
        }
    }else if(indexPath.section == 4){
        if (indexPath.row == 0) {
            cell.lab.text = @"帮助与反馈";
            cell.img.image = [UIImage imageNamed:@"personal_help"];
            cell.lab2.text = @"";
        }else{
            cell.lab.text = @"关于";
            cell.img.image = [UIImage imageNamed:@"personal_about"];
            cell.lab2.text = @"";
        }
    }
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
#pragma mark --未登录选择cell
    if (self.tagg == 1) {
        LoginViewController *registerVC = [LoginViewController new];
        registerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:registerVC animated:YES];
        
    }
#pragma mark --登陆后选择cell
    else if (self.tagg == 2){
        if (indexPath.section == 0) {
            //我的订单
            MyAllOrderViewController *myVC = [MyAllOrderViewController new];
            myVC.index = 0;
            myVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myVC animated:YES];
        }else if(indexPath.section == 1){
            //收藏
            if (indexPath.row == 0) {
                //收藏的商品
                MyAttentionViewController *myAttentionVC = [MyAttentionViewController new];
                MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
                [tabbar hiddenTabbar:YES];
                [self.navigationController pushViewController:myAttentionVC animated:YES];
            }
            else{
                //收藏的店铺
                MyAttentionShopViewController *myshopVC = [MyAttentionShopViewController new];
                MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
                [tabbar hiddenTabbar:YES];
                [self.navigationController pushViewController:myshopVC animated:YES];
            }
            //红包
//            CouponsViewController *myHBVC = [[CouponsViewController alloc]init];
//            [self.navigationController pushViewController:myHBVC animated:YES];
            
        }
        else if (indexPath.section == 2){
            
            //地址管理
            AddressViewController *addressVC = [AddressViewController new];
            addressVC.tempDic = self.tempDic;
            addressVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressVC animated:YES];
           
        }else if (indexPath.section == 3){
            if (indexPath.row == 0) {
                //我的评价
                MyEvaluationViewController *myEvaluationVC = [[MyEvaluationViewController alloc]init];
                [self.navigationController pushViewController:myEvaluationVC animated:YES];
            }else{
                //我的分享
                HelpViewController *helpVC = [HelpViewController new];
                [self.navigationController pushViewController:helpVC animated:YES];
            }
        }else if (indexPath.section == 4){
            if (indexPath.row == 0) {
                //帮助与反馈
                OpinionViewController *opinVC = [OpinionViewController new];
                [self.navigationController pushViewController:opinVC animated:YES];
                
            }else{
                //关于
                AboutViewController *aboutVC = [AboutViewController new];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 46;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark--我的资料数据请求
-(void)myAccount{
    NSString *api_token = [RequestModel model:@"user" action:@"userinfo"];
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"]};
    
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"userinfo" block:^(id result) {
        NSDictionary *dic = result;
        weakSelf.modArray = [[NSMutableArray alloc]init];
        for (NSMutableDictionary *dict in dic[@"data"]) {
            weakSelf.model = [PersonalInfoModel new];
            
            weakSelf.model.user_id = dict[@"user_id"];//缺少
            weakSelf.model.nick_name = dict[@"nick_name"];
            weakSelf.model.sex = dict[@"sex"];
            weakSelf.model.address = dict[@"address"];
            weakSelf.model.mobile = dict[@"mobile"];
            weakSelf.model.integration = dict[@"integration"];
            weakSelf.model.attention = dict[@"attention"];
            weakSelf.model.user_money = dict[@"user_money"];
            weakSelf.model.pay = dict[@"pay"];
            weakSelf.model.shipping_send = dict[@"shipping_send"];
            weakSelf.model.cart_num = dict[@"cart_num"];
            weakSelf.model.bounts = dict[@"bounts"];
            weakSelf.model.comment = dict[@"comment"];
            weakSelf.model.shipping = dict[@"shipping"];
            weakSelf.model.supplier = dict[@"supplier"];
            weakSelf.model.points = dict[@"points"];
            NSString *qd = [NSString stringWithFormat:@"%@",dict[@"qd"]];
             weakSelf.model.qd = qd;
            if ([qd isEqualToString:@"0"]) {
                weakSelf.backgroundView.frame = CGRectMake(Width - W(75), weakSelf.headView1.center.y-H(20)/2, W(75), H(25));
                weakSelf.settingBtn.frame = CGRectMake(weakSelf.backgroundView.frame.origin.x -2*W(20), weakSelf.headView1.center.y-W(20)/2, W(20), W(20));
                [weakSelf.signBtn setTitle:@"签到" forState:UIControlStateNormal];
                weakSelf.signBtn.imageEdgeInsets = UIEdgeInsetsMake(0, W(33), 0, -W(33));
                weakSelf.signBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -W(23), 0, W(23));
            }else if ([qd isEqualToString:@"1"]){
               
                weakSelf.backgroundView.frame = CGRectMake(Width - W(95), weakSelf.headView1.center.y-H(20)/2, W(95), H(25));
                weakSelf.settingBtn.frame = CGRectMake(weakSelf.backgroundView.frame.origin.x -2*W(20), weakSelf.headView1.center.y-W(20)/2, W(20), W(20));
                [weakSelf.signBtn setTitle:@"已签到" forState:UIControlStateNormal];
                weakSelf.signBtn.imageEdgeInsets = UIEdgeInsetsMake(0, W(55), 0, -W(55));
                weakSelf.signBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -W(13), 0, W(13));
            }
            weakSelf.labelForGoods1.text = weakSelf.model.bounts;
            weakSelf.labelForBalance1.text = weakSelf.model.integration;
            weakSelf.labelForIntegration1.text = weakSelf.model.user_money;
            weakSelf.label1.text = weakSelf.model.nick_name;
            NSString *a = [NSString stringWithFormat:@"%@",dict[@"pay"]];
            NSString *b = [NSString stringWithFormat:@"%@",dict[@"shipping_send"]];
            
            NSString *c = [NSString stringWithFormat:@"%@",dict[@"shipping"]];
            NSString *d = [NSString stringWithFormat:@"%@",dict[@"comment"]];
            weakSelf.payStr = a;
            weakSelf.shippingSendStr = b;
            weakSelf.shippingStr = c;
            weakSelf.commentStr = d;
            
            [weakSelf.modArray addObject:weakSelf.model];
            NSString *cartNum = [NSString stringWithFormat:@"%@",dict[@"cart_num"]];
            NSDictionary *dicc ;
            dicc = @{@"cart_num":cartNum};
#pragma mark -- 发送购物车数量通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cart_num" object:dicc];
            
        }
        [weakSelf.table reloadData];
        
    }];
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}
#pragma mark -- 自定义导航栏
- (void)initNavigationBar{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *naviBGColor = data[@"navigationBGColor"];
    NSString *tabbar = data[@"tabbar4"];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    label.text = tabbar;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    [view addSubview:label];
    
    UIImage *img = [UIImage imageNamed:@"个人中心-标题栏-设置icon.png"];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(label.frame.size.width + label.frame.origin.x + 60, 30, 30, 30)];
    [btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [view addSubview:btn];
    
    [self.viewForLogin addSubview:view];
    [self.viewForLogin1 addSubview:view];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cart_num" object:nil];
    
}
@end
