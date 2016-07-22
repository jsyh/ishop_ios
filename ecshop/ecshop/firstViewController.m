//
//  firstViewController.m
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//首页

#import "firstViewController.h"
#import "SearchViewController.h"
#import "Masonry.h"
#import "goodDetailViewController.h"
#import "SearchListViewController.h"
#import "MyTabBarViewController.h"
#import "BarCodeViewController.h"
#import "AFNetworkReachabilityManager.h"
@interface firstViewController ()<UIWebViewDelegate,QRCodeDelegate,UIAlertViewDelegate>
{
    NSURLRequest *requestt;
    UIView *topView;//导航栏
   // UIView * viewww;
}
@property (nonatomic, strong) UIWebView *webview;

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
    //    [super viewWillAppear:animated];
    MyTabBarViewController * tabbar =(MyTabBarViewController *)self.navigationController.tabBarController;
    
    [tabbar hiddenTabbar:NO];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createUI];
   // [self afn];
    self.navigationController.navigationBar.hidden=YES;
    
    
}
//-(void)afn
//{
//    //1.创建网络状态监测管理者
//    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
//    
//    //2.监听改变
//    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                [self createNoNet];
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//                [self createNoNet];
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                
//                break;
//            default:
//                break;
//        }
//    }];
//}
//-(void)createNoNet
//{
//    viewww=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
//    viewww.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
//    UIImageView * notImgView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-47, viewww.frame.size.height/2-149,94, 75)];
//    UIImage * notImg=[UIImage imageNamed:@"ic_network_error.png"];
//    notImg=[notImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    notImgView.image=notImg;
//    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-75, viewww.frame.size.height/2-64, 150 , 20)];
//    label.numberOfLines=0;
//    label.text=@"网络请求失败!";
//    label.font=[UIFont systemFontOfSize:17];
//    label.textColor=[UIColor lightGrayColor];
//    label.textAlignment=NSTextAlignmentCenter;
//    UIButton * notBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    notBtn.frame=CGRectMake(self.view.frame.size.width/2-55, viewww.frame.size.height/2-34, 110, 50);
//    notBtn.layer.cornerRadius = 10.0;
//    [notBtn.layer setBorderWidth:1];
//    notBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    notBtn.backgroundColor=[UIColor whiteColor];
//    [notBtn setTitle:@"重新加载" forState:UIControlStateNormal ];
//    notBtn.titleLabel.font=[UIFont systemFontOfSize:15];
//    [notBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [notBtn addTarget:self action:@selector(reloadNotNet) forControlEvents:UIControlEventTouchUpInside];
//    [viewww addSubview:notImgView];
//    [viewww addSubview:notBtn];
//    [viewww addSubview:label];
//    [self.view addSubview:viewww];
//
//}
//-(void)reloadNotNet
//{
//    
//}
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
    
}

//创建主界面
-(void)createUI
{
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0,-20, self.view.frame.size.width, self.view.frame.size.height+20)];
    self.webview.backgroundColor = [UIColor whiteColor];
    _webview.delegate=self;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url1 = data[@"shareurl"];
    
    NSString *urlStr=url1;
    NSURL *url=[NSURL URLWithString:urlStr];
    requestt = [[NSURLRequest alloc]initWithURL:url];
    [_webview loadRequest:requestt];
    [self.view addSubview:_webview];
#pragma mark-左侧扫一扫  右侧消息
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    topView.backgroundColor = [UIColor redColor];
    topView.alpha = 0;
    [self.view addSubview:topView];
    //左侧扫一扫
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 24, 50, 40);
    UIImage * image1=[UIImage imageNamed:@"home_head_icon_saoyisao"];
    image1=[image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:image1 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //右侧消息
    UIButton * button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(self.view.frame.size.width-50, 24, 50, 40);
    UIImage * image2=[UIImage imageNamed:@"home_head_icon_information"];
    [button2 setImage:image2 forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(bitBtn2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
#pragma mark-搜索
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(56, 25, self.view.frame.size.width-109, 32);
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.layer.borderWidth=1;
    searchBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    searchBtn.layer.cornerRadius = 5;
    searchBtn.layer.masksToBounds=YES;
    [searchBtn addTarget:self action:@selector(pushSearch) forControlEvents:UIControlEventTouchUpInside];
    UIImage * imagebtn=[UIImage imageNamed:@"search"];
    imagebtn=[imagebtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView * imageviewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 18, 18)];
    imageviewLeft.image=imagebtn;
    UILabel * centerLab=[[UILabel alloc]initWithFrame:CGRectMake(40, 8, 200, 18)];
    centerLab.text=@"点我搜索";
    centerLab.textColor=[UIColor lightGrayColor];
    centerLab.font=[UIFont systemFontOfSize:16];
    centerLab.textAlignment=NSTextAlignmentLeft;
    [searchBtn addSubview:centerLab];
    [searchBtn addSubview:imageviewLeft];
    [self.view addSubview:searchBtn];
}
#pragma mark-webview点击图片
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL * ulrNew=request.URL;
    NSString * newUrl=[NSString stringWithFormat:@"%@",ulrNew];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url1 = data[@"shareurl"];
    if ([newUrl isEqualToString:url1])
    {
        return YES;
    }
    _myType = [[newUrl componentsSeparatedByString:@"/"] lastObject];
    if (!([newUrl rangeOfString:@"type"].location==NSNotFound)) {
    
        SearchListViewController * search=[[SearchListViewController alloc]init];
        search.typeStay=_myType;
        [self.navigationController pushViewController:search animated:NO];
        
    }else if(!([newUrl rangeOfString:@"ad"].location==NSNotFound)){
        
        newUrl = url1;
        
        return YES;
    }
    
    else {
        goodDetailViewController * good=[[goodDetailViewController alloc]init];
        good.goodID=_myType;
        [self.navigationController pushViewController:good animated:NO];
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
    NSLog(@"%@ --%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"offset---scroll:%f",self.webview.scrollView.contentOffset.y);
    [self.webview.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew
                                 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    UIScrollView *scrollView = object;
    int offset = scrollView.contentOffset.y;
    
    CGFloat alpha = 0;
    CGFloat a = 180 - offset;
    CGFloat b = a / 180;
    alpha=1-b;
    if (alpha <= 0.7) {
        topView.alpha = alpha;
        NSLog(@"%f - %f",scrollView.contentOffset.y,alpha);
        NSLog(@"a - %f",a);
        NSLog(@"b - %f",b);
    }
    
}
@end
