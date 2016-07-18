//
//  MyMoneyViewController.m
//  ecshop
//
//  Created by Jin on 16/4/26.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "MyMoneyViewController.h"
#import "UIColor+Hex.h"
#import "RechargeViewController.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface MyMoneyViewController ()

@end

@implementation MyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    [self creatUI];
    // Do any additional setup after loading the view.
}
-(void)creatUI{
    float a298 = 298.0/1334.0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, a298*Height)];
    view.backgroundColor = [UIColor orangeColor];
    UILabel *integrationLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, Width, 35)];
    integrationLab.text = [NSString stringWithFormat:@"%@",self.moneyStr];
    integrationLab.textAlignment = NSTextAlignmentCenter;
    integrationLab.font = [UIFont systemFontOfSize:35];
    [view addSubview:integrationLab];
    integrationLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, integrationLab.frame.origin.y+integrationLab.frame.size.height+32, Width, 10)];
    nameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:10];
    nameLab.text = @"余额总计";
    [view addSubview:nameLab];
    
    [self.view addSubview:view];
    float a606 = 606.0/750.0;
    float aX = (Width - a606*Width)/2.0;
    UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeBtn.frame = CGRectMake(aX,Height-50-34 , a606*Width, 34);
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rechargeBtn addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    rechargeBtn.layer.cornerRadius = 17;
    rechargeBtn.layer.borderWidth = 1;
    rechargeBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
    rechargeBtn.layer.masksToBounds = YES;
    [self.view addSubview:rechargeBtn];
    
}
-(void)rechargeAction{
    
    RechargeViewController *recharVC = [RechargeViewController new];
    recharVC.temp = self.moneyStr;
    [self.navigationController pushViewController:recharVC animated:YES];
    
   
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
    label.text = @"我的余额";
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
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0,view.frame.size.height-1 , self.view.frame.size.width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
    
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
