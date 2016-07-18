//
//  firstViewController.m
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//首页

#import "firstViewController.h"
#import "SearchViewController.h"
#import "goodDetailViewController.h"
#import "SearchListViewController.h"
#import "MyTabBarViewController.h"
#import "BarCodeViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "UIColor+Hex.h"
#import "UMSocial.h"
#import "FindViewController.h"
#import "MJRefresh.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "BrandViewController.h"
@interface firstViewController ()<UIWebViewDelegate,QRCodeDelegate,UIAlertViewDelegate>
{
    NSURLRequest *requestt;
    UIView *topView;//导航栏
     UIView * viewww;
}
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic,strong) UIActivityIndicatorView *testActivityIndicator;

@end

@implementation firstViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    
    [tabbar hiddenTabbar:NO];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    
    [tabbar hiddenTabbar:NO];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createUI];
    
    self.navigationController.navigationBar.hidden=YES;
    [self createNoNet];
     [self afn];
   
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
-(void)reloadNotNet
{
    viewww.hidden = YES;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url1 = data[@"firstUrl"];
    
    NSString *urlStr=url1;
    [_webview loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]]];
     [self afn];
}
#pragma mark-扫一扫点击事件
-(void)bitBtn:(id)sender
{
    BarCodeViewController * code=[[BarCodeViewController alloc]init];
    code.delegate=self;
    [self presentViewController:code animated:YES completion:^{
        
    }];
    
}
-(void)QRCodeScanFinishiResult:(NSString *)result
{
    goodDetailViewController* good=[[goodDetailViewController alloc]init];
    if ([result rangeOfString:@"goods_id:"].location !=NSNotFound) {
        int a=[[result substringFromIndex:9 ]intValue];
        good.goodID=[NSString stringWithFormat:@"%d",a] ;
        [self.navigationController pushViewController:good animated:YES];
    }else {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,只能扫描我们的商品二维码哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}
//消息点击事件
-(void)bitBtn2:(id)sender
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url = data[@"shareurl"];
    NSString *UMSharekey = data[@"UMSharekey"];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMSharekey
                                      shareText:@"小京东购物APP"
                                     shareImage:[UIImage imageNamed:@"logo"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ,UMShareToTencent,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url=url;
    [UMSocialData defaultData].extConfig.qzoneData.url=url;
    [UMSocialData defaultData].extConfig.qqData.url=url;
}

//创建主界面
-(void)createUI
{
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0,44, self.view.frame.size.width, self.view.frame.size.height-44)];
    _webview.backgroundColor = [UIColor whiteColor];
    _webview.delegate=self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshColl)];
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"释放回到首页" forState:MJRefreshStatePulling];
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
    
    NSString *urlStr=url1;
    [_webview loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]]];
    [self.view addSubview:_webview];
#pragma mark-左侧扫一扫  右侧分享
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#FF5001"];
    [self.view addSubview:topView];
    //左侧扫一扫
    float buttonFloatX = 24.0/750.0;
    float height = [UIScreen mainScreen].bounds.size.height;
    float width = [UIScreen mainScreen].bounds.size.width;
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 20, 40, 44);
   
    UIImage * image1=[UIImage imageNamed:@"home_sao"];
    image1=[image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:image1 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //右侧分享
    UIButton * button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(width-40, 20, 40, 44);
    UIImage * image2=[UIImage imageNamed:@"home_share"];
    [button2 setImage:image2 forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(bitBtn2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
#pragma mark-搜索
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    float searchFloat = 88.0/750.0;
    float searchY = 12.0/1334.0;
    searchBtn.frame=CGRectMake(searchFloat*width, searchY*height+20, width-40-4*buttonFloatX*width, 32);
    searchBtn.backgroundColor = [UIColor colorWithHexString:@"#E53B00"];
//    searchBtn.layer.borderWidth=1;
//    searchBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    searchBtn.layer.cornerRadius = 16;
    searchBtn.layer.masksToBounds=YES;
    [searchBtn addTarget:self action:@selector(pushSearch) forControlEvents:UIControlEventTouchUpInside];
    UIImage * imagebtn=[UIImage imageNamed:@"home_search"];
    float imageX = 24.0/750.0;
    float imageY = 16.0/1334.0;
    imagebtn=[imagebtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView * imageviewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(imageX*width, imageY*height, 18, 18)];
    imageviewLeft.image=imagebtn;
    float centerX = 80.0/750.0;
    float centerW = 200.0/750.0;
    UILabel * centerLab=[[UILabel alloc]initWithFrame:CGRectMake(centerX*width, imageY*height, centerW*width, 16)];
    centerLab.text=@"点我搜索";
    centerLab.textColor=[UIColor whiteColor];
    centerLab.font=[UIFont systemFontOfSize:16];
    centerLab.textAlignment=NSTextAlignmentLeft;
    [searchBtn addSubview:centerLab];
    [searchBtn addSubview:imageviewLeft];
    [self.view addSubview:searchBtn];
}
-(void)refreshColl{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url1 = data[@"firstUrl"];
    
    NSString *urlStr=url1;
    [_webview loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]]];
    [_webview.scrollView.mj_header endRefreshing];
}
#pragma mark-webview点击图片
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL * ulrNew=request.URL;
    NSString * newUrl=[NSString stringWithFormat:@"%@",ulrNew];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url1 = data[@"firstUrl"];
    /**
     *  http://demo2.ishopv.com/mapp/search.php?intro=promotion 限时特卖更多
     *  http://demo2.ishopv.com/mapp/catalog.php     全部商品
     *  http://demo2.ishopv.com/mapp/stores.php      店铺街
     *  http://demo2.ishopv.com/mapp/brand.php       品牌街
     *  http://demo2.ishopv.com/mapp/activity.php    优惠活动
     *  http://demo2.ishopv.com/mapp/pro_search.php  团购
     *  http://demo2.ishopv.com/mapp/exchange.php    积分商城
     *  http://demo2.ishopv.com/mapp/flow.php        购物车
     *  http://demo2.ishopv.com/mapp/user.php        个人中心
     */
    if ([newUrl isEqualToString:url1])
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return YES;
    }
    NSString * typeStr = [[newUrl componentsSeparatedByString:@"="] lastObject];
    if (!([newUrl rangeOfString:@"search.php?intro="].location==NSNotFound)) {
        
        SearchListViewController * search=[[SearchListViewController alloc]init];
        search.typeStay=typeStr;
        [self.navigationController pushViewController:search animated:NO];
        
    }else if (!([newUrl rangeOfString:@"catalog"].location==NSNotFound)){
        NSLog(@"全部商品");
        MyTabBarViewController * tabBarViewController = (MyTabBarViewController * )self.tabBarController;
        UINavigationController * nav = [tabBarViewController.viewControllers objectAtIndex:1];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [nav popToRootViewControllerAnimated:YES];
        
        UIButton * button = [[UIButton alloc]init];
        button.tag = 101;
        [tabBarViewController buttonClicked:button];
    }else if (!([newUrl rangeOfString:@"stores"].location==NSNotFound)){
        MyTabBarViewController * tabBarViewController = (MyTabBarViewController * )self.tabBarController;
        UINavigationController * nav = [tabBarViewController.viewControllers objectAtIndex:2];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [nav popToRootViewControllerAnimated:YES];
        
        UIButton * button = [[UIButton alloc]init];
        button.tag = 102;
        [tabBarViewController buttonClicked:button];
         NSLog(@"店铺街");
    }else if (!([newUrl rangeOfString:@"brand"].location==NSNotFound)){
        NSLog(@"品牌街");
        BrandViewController *brandVC = [BrandViewController new];
        brandVC.url = newUrl;
        brandVC.type = @"brand";
        [self.navigationController pushViewController:brandVC animated:YES];
        return NO;
    }else if (!([newUrl rangeOfString:@"activity"].location==NSNotFound)){
        NSLog(@"优惠活动");
        BrandViewController *brandVC = [BrandViewController new];
        brandVC.url = newUrl;
        brandVC.type = @"activity";
        [self.navigationController pushViewController:brandVC animated:YES];
        return NO;
    }else if (!([newUrl rangeOfString:@"pro_search"].location==NSNotFound)){
         NSLog(@"团购");
        BrandViewController *brandVC = [BrandViewController new];
        brandVC.url = newUrl;
         brandVC.type = @"pro_search";
        [self.navigationController pushViewController:brandVC animated:YES];
        return NO;
    }else if (!([newUrl rangeOfString:@"exchange"].location==NSNotFound)){
         NSLog(@"积分商城");
        BrandViewController *brandVC = [BrandViewController new];
        brandVC.url = newUrl;
        brandVC.type = @"exchange";
        [self.navigationController pushViewController:brandVC animated:YES];
        return NO;
    }else if (!([newUrl rangeOfString:@"flow"].location==NSNotFound)){
        
        MyTabBarViewController * tabBarViewController = (MyTabBarViewController * )self.tabBarController;
        UINavigationController * nav = [tabBarViewController.viewControllers objectAtIndex:3];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [nav popToRootViewControllerAnimated:YES];
        
        UIButton * button = [[UIButton alloc]init];
        button.tag = 103;
        [tabBarViewController buttonClicked:button];
         NSLog(@"购物车");
    }else if (!([newUrl rangeOfString:@"user"].location==NSNotFound)){
        MyTabBarViewController * tabBarViewController = (MyTabBarViewController * )self.tabBarController;
        UINavigationController * nav = [tabBarViewController.viewControllers objectAtIndex:4];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [nav popToRootViewControllerAnimated:YES];
        
        UIButton * button = [[UIButton alloc]init];
        button.tag = 104;
        [tabBarViewController buttonClicked:button];
         NSLog(@"个人中心");
    }
    else if(!([newUrl rangeOfString:@"ad"].location==NSNotFound)){
        
  
        
        return YES;
    }
    
    else {
        goodDetailViewController * good=[goodDetailViewController new];
        good.goodID=typeStr;
        [self.navigationController pushViewController:good animated:YES];
    }
    
    return NO;
}
#pragma mark-点击我跳转点击事件
-(void)pushSearch
{
    SearchViewController *search=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:NO];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)dealloc {
    //    NSLog(@"%@ --%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
