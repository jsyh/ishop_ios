//
//  BrandViewController.m
//  ecshop
//
//  Created by Jin on 16/5/30.
//  Copyright © 2016年 jsyh. All rights reserved.
//品牌街

#import "BrandViewController.h"
#import "SearchListViewController.h"
#import "goodDetailViewController.h"
#import "MyTabBarViewController.h"
#import "SureOrderViewController.h"
#import "UIColor+Hex.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "integralExchangeViewController.h"
@interface BrandViewController ()<UIWebViewDelegate>
{
    NSURLRequest *requestt;
    UIView *viewww;//网络不好时的view
}
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation BrandViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    [tabbar hiddenTabbar:YES];
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
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
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

    NSURL *url=[NSURL URLWithString:self.url];
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
    NSString *urlStr=self.url;
    [_webview loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]]];
    [_webview.scrollView.mj_header endRefreshing];
}
-(void)reloadNotNet
{
    viewww.hidden = YES;
    
    
    NSString *urlStr=@"http://demo2.ishopv.com/mapp/stores.php";
    [_webview loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]]];
    [self afn];
}
#pragma mark-webview点击图片
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL * ulrNew=request.URL;
    NSString * newUrl=[NSString stringWithFormat:@"%@",ulrNew];
    
    NSString *url1 = self.url;
    if ([newUrl isEqualToString:url1])
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return YES;
    }else if([newUrl containsString:@"brand.php?id="]){
        NSString *goodsID = [[newUrl componentsSeparatedByString:@"id="]lastObject];
        SearchListViewController *searchVC = [SearchListViewController new];
        searchVC.brandID = goodsID;
        [self.navigationController pushViewController:searchVC animated:YES];
    }else if ([newUrl containsString:@"goods.php?id="]){
        NSString *goodsID = [[newUrl componentsSeparatedByString:@"id="]lastObject];
        goodDetailViewController *goodsVC = [goodDetailViewController new];
        goodsVC.goodID = goodsID;
        [self.navigationController pushViewController:goodsVC animated:YES];
    }else if ([newUrl containsString:@"category.php?id="]){
        NSString *goodsID = [[newUrl componentsSeparatedByString:@"id="]lastObject];
        SearchListViewController *searchVC = [SearchListViewController new];
        searchVC.gooddid = goodsID;
        [self.navigationController pushViewController:searchVC animated:YES];
    }else if ([newUrl containsString:@"exchange.php?id="]){
        NSString *goodsID = [[newUrl componentsSeparatedByString:@"id="]lastObject];
        goodsID = [[goodsID componentsSeparatedByString:@"&"]firstObject];
        integralExchangeViewController *goodsVC = [integralExchangeViewController new];
        goodsVC.goodID = goodsID;
        [self.navigationController pushViewController:goodsVC animated:YES];
     
    }else if([newUrl containsString:@"exchange.php?"]){

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    //brand品牌街  activity优惠活动
    if ([self.type isEqualToString:@"brand"]) {
        label.text = @"品牌街";
    }else if ([self.type isEqualToString:@"activity"]){
        label.text = @"优惠活动";
    }else if([self.type isEqualToString:@"pro_search"]){
        label.text = @"团购";
    }else{
        label.text = @"积分商城";
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    [view addSubview:label];
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 63, self.view.frame.size.width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
    
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
