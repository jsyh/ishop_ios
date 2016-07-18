//
//  FindViewController.m
//  ecshop
//
//  Created by Jin on 16/3/29.
//  Copyright © 2016年 jsyh. All rights reserved.
//

//发现页面

#import "FindViewController.h"
#import "goodDetailViewController.h"
#import "GoShopViewController.h"
#import "MyTabBarViewController.h"
#import "UIColor+Hex.h"
#import "OpenQQViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
@interface FindViewController ()<UIWebViewDelegate>
{
    NSURLRequest *requestt;
    UIView *viewww;//网络不好时的view
}
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation FindViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self creatUI];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNoNet];
    [self afn];
    // Do any additional setup after loading the view.
}
-(void)creatUI{
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 114)];
    
    self.webview.backgroundColor = [UIColor whiteColor];
    _webview.opaque=YES;
    _webview.delegate=self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshColl)];
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"释放开始加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    _webview.scrollView.mj_header = header;
    for (UIView *subView in [_webview subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)subView setShowsHorizontalScrollIndicator:NO];
            [(UIScrollView *)subView setShowsVerticalScrollIndicator:NO];
        }
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url1 = data[@"firstUrl"];
    NSString *urlStr=[NSString stringWithFormat:@"%@brand.php",url1];
    NSURL *url=[NSURL URLWithString:urlStr];
    requestt = [[NSURLRequest alloc]initWithURL:url];
    [_webview loadRequest:requestt];
    [self.view addSubview:_webview];
}
-(void)afn
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    
    hud.labelText=@"loading";
    //检测网络是否可用
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    [self stringFromStatus:status];
    
    
    
}
-(void)stringFromStatus:(NetworkStatus)status{
    //    NSString *string;
    switch (status) {
        case NotReachable:
            //            string = @"Not Reachable";
            viewww.hidden = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            break;
        case ReachableViaWiFi:
            //            string = @"Reachable via WIFI";
            
            viewww.hidden = YES;
            break;
        case ReachableViaWWAN:
            //            string = @"Reachable via WWAN";
            viewww.hidden = YES;
            break;
        default:
            //            string = @"Unknown";
            break;
    }
    
}
-(void)createNoNet
{
    viewww=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    viewww.hidden = YES;
    viewww.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    UIImageView * notImgView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-47, viewww.frame.size.height/2-149,94, 75)];
    UIImage * notImg=[UIImage imageNamed:@"ic_network_error.png"];
    notImg=[notImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    notImgView.image=notImg;
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-75, viewww.frame.size.height/2-64, 150 , 20)];
    label.numberOfLines=0;
    label.text=@"网络请求失败!";
    label.font=[UIFont systemFontOfSize:17];
    label.textColor=[UIColor lightGrayColor];
    label.textAlignment=NSTextAlignmentCenter;
    UIButton * notBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    notBtn.frame=CGRectMake(self.view.frame.size.width/2-35, viewww.frame.size.height/2-34, 70, 30);
    notBtn.layer.cornerRadius = 10.0;
    [notBtn.layer setBorderWidth:1];
    notBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    notBtn.backgroundColor=[UIColor whiteColor];
    [notBtn setTitle:@"重新加载" forState:UIControlStateNormal ];
    notBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [notBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [notBtn addTarget:self action:@selector(reloadNotNet) forControlEvents:UIControlEventTouchUpInside];
    [viewww addSubview:notImgView];
    [viewww addSubview:notBtn];
    [viewww addSubview:label];
    [self.view addSubview:viewww];
    
}
-(void)refreshColl{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    
    hud.labelText=@"loading";
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url1 = data[@"firstUrl"];
    NSString *urlStr=[NSString stringWithFormat:@"%@brand.php",url1];
    
    [_webview loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]]];
    [_webview.scrollView.mj_header endRefreshing];
}
-(void)reloadNotNet
{
    viewww.hidden = YES;
 
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url1 = data[@"firstUrl"];
    NSString *urlStr=[NSString stringWithFormat:@"%@brand.php",url1];
    [_webview loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]]];
    [self afn];
}
#pragma mark-webview点击图片
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL * ulrNew=request.URL;
    NSString * newUrl=[NSString stringWithFormat:@"%@",ulrNew];

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *urlStr = data[@"firstUrl"];
    NSString *url1=[NSString stringWithFormat:@"%@brand.php",urlStr];
    
    if ([newUrl isEqualToString:url1])
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return YES;
    }else if([newUrl containsString:@"goods.php?id="]){
        NSString *goodsID = [[newUrl componentsSeparatedByString:@"id="]lastObject];
        goodDetailViewController *goodsVC = [goodDetailViewController new];
        goodsVC.goodID = goodsID;
        [self.navigationController pushViewController:goodsVC animated:YES];
    }else if([newUrl containsString:@"suppId="]){
        NSString *goodsID = [[newUrl componentsSeparatedByString:@"suppId="]lastObject];
        GoShopViewController *goodsVC = [GoShopViewController new];
        goodsVC.shopUrl = newUrl;
        goodsVC.shopID = goodsID;
        MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
        [tabbar hiddenTabbar:YES];

        [self.navigationController pushViewController:goodsVC animated:YES];
    }else if ([newUrl containsString:@"site=qq"]){
        NSString *string = newUrl;

        string = [[string componentsSeparatedByString:@"uin="]lastObject];
        string = [[string componentsSeparatedByString:@"&site="]firstObject];
        if (string.length>0) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"联系QQ:%@",string] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                OpenQQViewController *openQQVC = [OpenQQViewController new];
                openQQVC.tempQQ = string;
                [self.navigationController pushViewController:openQQVC animated:NO];
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];

        }
    }else if ([newUrl containsString:@"stores.php?id="]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return YES;
    }
    return NO;
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
    NSString *tabbar = data[@"tabbar3"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    label.text = tabbar;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    [view addSubview:label];
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 63, self.view.frame.size.width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
    [self.view addSubview:view];
    
    
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
