//
//  MyTabBarViewController.m
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//自定义tabbar

#import "MyTabBarViewController.h"
#import "UIColor+Hex.h"
#import "UserGuideViewController.h"
#import "AppDelegate.h"
#define tabCount 5
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define H(b) Height * b / 667.0
#define W(a) Width * a / 375.0
@interface MyTabBarViewController ()
{
    UIImageView *customBar;
    UILabel *smallLab1;
    UIView *smallView1;
}
@end

@implementation MyTabBarViewController
-(void)setIntroductionView
{
    
    UserGuideViewController *userVC = [[UserGuideViewController alloc]init];
    [self addChildViewController:userVC];
    [self.view addSubview:userVC.view];
    
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [viewController viewWillAppear:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.selectedViewController viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
#pragma mark -- 引导页
    //    [self setIntroductionView];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [self setIntroductionView];
        
        //启动引导页
    }else{
        //不是第一次启动的话
        
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
}
-(void)creatUI
{
    
#pragma mark --接收登录通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(cartNum:) name:@"cart_num" object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(quite:) name:@"quite" object:nil];
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *tabBarItemFont = data[@"tabBarItemFont"];
    //字体大小
    int tabBarFont = [tabBarItemFont intValue];
    NSString *tabBarBackgroundColor = data[@"tabBarBackgroundColor"];
    NSString *tabBarIitmColorAfter = data[@"tabBarIitmColorAfter"];
    NSString *tabBarIitmColorBefore = data[@"tabBarIitmColorBefore"];
    NSString *tabbar1 = data[@"tabbar1"];
    NSString *tabbar2 = data[@"tabbar2"];
    NSString *tabbar3 = data[@"tabbar3"];
    NSString *tabbar4 = data[@"tabbar4"];
    NSString *tabbar5 = data[@"tabbar5"];
    self.tabBar.hidden=YES;
    customBar = [[UIImageView alloc]init];
    //获取屏幕的尺寸
    CGSize size = [UIScreen mainScreen].bounds.size;
    //设置customBar位置和大小，屏幕的最低部
    customBar.frame = CGRectMake(0, size.height - 49, size.width, 49);
    //    [customBar setBackgroundColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0]];
    [customBar setBackgroundColor:[UIColor colorWithHexString:tabBarBackgroundColor]];
    customBar.alpha = 0.95;
    //线
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, 1)];
    view.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [customBar addSubview:view];
    
    [self.view addSubview:customBar];
    NSArray *arr=@[tabbar1,tabbar2,tabbar3,tabbar4,tabbar5];
    for (int i = 0; i < tabCount; i++)
    {
        UIButton *button = [[UIButton alloc]init];
        button.frame = CGRectMake(i * size.width/tabCount, 0, size.width/tabCount, 49);
        if (i == 0) {
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home"]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home"]] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_press"]] forState:UIControlStateSelected];
        }else if (i == 1){
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_category"]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_category"]] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_category_press"]] forState:UIControlStateSelected];
            
        }else if (i == 2){
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_found"]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_found"]] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_found_press"]] forState:UIControlStateSelected];
        }
        else if (i == 3){
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_cart"]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_cart"]] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_cart_press"]] forState:UIControlStateSelected];
        }else if (i == 4){
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_me"]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_me"]] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_me_press"]] forState:UIControlStateSelected];
        }
        
        
        if (i == 3) {
            smallView1 = [[UIView alloc]initWithFrame:CGRectMake(button.frame.size.width - W(35), H(3), 12, 12)];
            smallView1.backgroundColor = [UIColor redColor];
            [smallView1.layer setCornerRadius:6];
            smallLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
            smallLab1.font = [UIFont systemFontOfSize:8];
            smallLab1.text = @"12";
            smallLab1.textAlignment = NSTextAlignmentCenter;
            smallLab1.textColor = [UIColor whiteColor];
            [smallView1 addSubview:smallLab1];
            [button addSubview:smallView1];
            
            smallView1.hidden = YES;
            
        }
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:tabBarIitmColorBefore] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:tabBarIitmColorBefore] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithHexString:tabBarIitmColorAfter] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:tabBarFont];
        if (i==3) {
            button.titleEdgeInsets = UIEdgeInsetsMake(35, -20, 0, 5);
            button.imageEdgeInsets = UIEdgeInsetsMake(0,15, 15, -10);
        }else if (i == 2){
            button.titleEdgeInsets = UIEdgeInsetsMake(35, -20, 0, 0);
            button.imageEdgeInsets = UIEdgeInsetsMake(0,20, 15, -5);
        }
        else if(i==4){
            button.titleEdgeInsets = UIEdgeInsetsMake(35, -20, 0, 5);
            button.imageEdgeInsets = UIEdgeInsetsMake(0,20, 15, 0);
        }else
        {
            button.titleEdgeInsets = UIEdgeInsetsMake(35, -20, 0, 12);
            button.imageEdgeInsets = UIEdgeInsetsMake(0,12, 15, 0);
        }
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, -30, 0);
//        button.imageEdgeInsets = UIEdgeInsetsMake(0,23, 13, -6);
      
        button.tag = 100 + i;
        [customBar addSubview:button];
    }
    customBar.userInteractionEnabled = YES;
}
-(void)hiddenTabbar:(BOOL)hiden
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    [UIView animateWithDuration:0.5 animations:^{
        if (hiden) {
            customBar.frame = CGRectMake(0, size.height, size.width, 49);
        }
        else
        {
            customBar.frame = CGRectMake(0, size.height - 49, size.width, 49);
        }
    }];
}
-(void)buttonClicked:(UIButton *)button
{
    for(int i = 0; i < tabCount; i++)
    {
        UIButton *btn = (id)[self.view viewWithTag:100 + i];
        if (btn != button) {
            btn.selected = NO;
        }
        
    }
    UIButton * tabBarBtn = [customBar viewWithTag:button.tag];
    tabBarBtn.selected = YES;
    self.selectedIndex = button.tag - 100;
}
- (void)dealloc {
    NSLog(@"%@ --%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)cartNum:(NSNotification *)sender{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSDictionary *dic = sender.object;
    smallLab1.text = dic[@"cart_num"];
    if (app.tempDic != nil) {
        smallView1.hidden = NO;
    }else{
        smallView1.hidden = YES;
    }
}
-(void)quite:(NSNotification *)sender{
    
    smallView1.hidden = YES;
    
}
@end
