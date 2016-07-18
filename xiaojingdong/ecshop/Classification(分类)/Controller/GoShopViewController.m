//
//  GoShopViewController.m
//  ecshop
//
//  Created by Jin on 16/4/6.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "GoShopViewController.h"
#import "UIColor+Hex.h"
#import "goodDetailViewController.h"
#import "RequestModel.h"
#import "LoginViewController.h"
#import "MyTabBarViewController.h"
@interface GoShopViewController ()<UIWebViewDelegate>
{
    BOOL careShop;//判断是否关注
}
@property (nonatomic,strong)UIButton *careBtn;//关注按钮

@end

@implementation GoShopViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    [self creatWebView];
    if (_attention == 1) {
        careShop = YES;
    }else{
        careShop = NO;
    }
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    if (app.tempDic == NULL) {
        
    }else{
        [self careReloadRequest];
    }
    
    // Do any additional setup after loading the view.
}
-(void)creatWebView{
    UIWebView *myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.shopUrl]]];
    myWebView.delegate = self;
    for (UIView *subView in [myWebView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)subView setShowsHorizontalScrollIndicator:NO];
            [(UIScrollView *)subView setShowsVerticalScrollIndicator:NO];
        }
    }
    [self.view addSubview:myWebView];
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
#pragma mark -请求数据
//收藏接口
-(void)reloadRequest
{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString * receNss= app.tempDic[@"data"][@"key"];
    NSDictionary *dict;
    NSString *api_token = [RequestModel model:@"goods" action:@"collect"];
    
    dict = @{@"api_token":api_token,@"id_values":self.shopID,@"key":receNss,@"type":@"1"};
    
  
    [RequestModel requestWithDictionary:dict model:@"goods" action:@"collect" block:^(id result) {
       
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:result[@"msg"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}

//查看是否收藏
-(void)careReloadRequest{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString * receNss= app.tempDic[@"data"][@"key"];
    NSDictionary *dict;
    NSString *api_token = [RequestModel model:@"first" action:@"attention"];
    
    dict = @{@"api_token":api_token,@"supplier_id":self.shopID,@"key":receNss};
    
    
    [RequestModel requestWithDictionary:dict model:@"first" action:@"attention" block:^(id result) {
        
        NSString * code = result[@"code"];
        NSLog(@"%@",code);
        if ([code isEqualToString:@"1"]) {
            [self.careBtn setImage:[UIImage imageNamed:@"goods_detail_collect_press"] forState:UIControlStateNormal];
            careShop=YES;
        }else{
            [self.careBtn setImage:[UIImage imageNamed:@"goods_detail_collect"] forState:UIControlStateNormal];
            careShop=NO;
        }
    }];

}
#pragma mark --webviewdelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL * ulrNew=request.URL;
    NSString * newUrl=[NSString stringWithFormat:@"%@",ulrNew];
    NSLog(@"%@",newUrl);
    if (!([newUrl rangeOfString:@"suppId="].location==NSNotFound )) {
        return YES;
    }else if( [newUrl containsString:@"goods.php?id="] ){
        NSString *goodsID = [[newUrl componentsSeparatedByString:@"="] lastObject];
        goodDetailViewController *goodVC = [goodDetailViewController new];
        goodVC.goodID = goodsID;
        [self.navigationController pushViewController:goodVC animated:YES];
    }else if ([newUrl containsString:@"tel:"]){
        NSString *tel = newUrl;
        UIWebView *callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tel]]];
        [self.view addSubview:callWebview];

    }else if ([newUrl isEqualToString:@"http://demo2.ishopv.com/mobile"]){
        MyTabBarViewController * tabBarViewController = (MyTabBarViewController * )self.tabBarController;
        UINavigationController * nav = [tabBarViewController.viewControllers objectAtIndex:0];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [nav popToRootViewControllerAnimated:YES];
        
        UIButton * button = [[UIButton alloc]init];
        button.tag = 100;
        [tabBarViewController buttonClicked:button];
    }
     return NO;
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
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    
    labelTitle.text = @"店铺";
    
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont systemFontOfSize:titleFont];
    labelTitle.textColor = [UIColor colorWithHexString:naiigationTitleColor];
    [view addSubview:labelTitle];
    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    [btn addSubview:imgView];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    

    _careBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 45, 25, 40, 40)];

    [_careBtn addTarget:self action:@selector(careAction) forControlEvents:UIControlEventTouchUpInside];
    if (_attention==1) {
        [_careBtn setImage:[UIImage imageNamed:@"goods_detail_collect_press"] forState:UIControlStateNormal];
    }else{
        [_careBtn setImage:[UIImage imageNamed:@"goods_detail_collect"] forState:UIControlStateNormal];
    }
    
    
    [view addSubview:_careBtn];
    [self.view addSubview:view];
    
}
//关注
-(void)careAction{
    NSLog(@"关注了");
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString * receNss= app.tempDic[@"data"][@"key"];
    
    if (receNss == NULL) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请先登录" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
        LoginViewController *loginVC = [LoginViewController new];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        if (careShop) {

             [_careBtn setImage:[UIImage imageNamed:@"goods_detail_collect"] forState:UIControlStateNormal];
            NSString *api_token = [RequestModel model:@"goods" action:@"qcollect"];
            // strr=@"0";
            NSDictionary *dict = @{@"api_token":api_token,@"id_values":self.shopID,@"key":receNss,@"type":@"1"};
            [RequestModel requestWithDictionary:dict model:@"goods" action:@"qcollect" block:^(id result) {
                NSString *str = result[@"msg"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:str message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                careShop=NO;
            }];
            
        }else{
            [_careBtn setImage:[UIImage imageNamed:@"goods_detail_collect_press"] forState:UIControlStateNormal];
            [self reloadRequest];
            careShop = YES;
        }
       
        
    }
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
