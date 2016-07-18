//
//  AppDelegate.m
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "firstViewController.h"
#import "secondViewController.h"
#import "fourthViewController.h"
#import "MyTabBarViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UserGuideViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "FindViewController.h"
#import "GoodsCarViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Reachability.h"
#define WIDTH (float)(self.window.frame.size.width)
#define HEIGHT (float)(self.window.frame.size.height)
@interface AppDelegate ()<UITabBarControllerDelegate,WXApiDelegate>
@property (nonatomic,strong)Reachability *conn;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyWindow];
//    获取UserDefault
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [userDefault objectForKey:@"dic"];
    self.tempDic = dic;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *UMSharekey = data[@"UMSharekey"];
    NSString *WXAppId = data[@"WXAppId"];
    NSString *WXappSecret = data[@"WXappSecret"];
    NSString *url = data[@"url"];
    NSString *QQWithAppId = data[@"QQWithAppId"];
    NSString *QQappKey = data[@"QQappKey"];
    NSString *sinaAppKey =data[@"sinaAppkey"];
    NSString *sinaAppSecret = data[@"sinaAppSecret"];
    //友盟分享
    [UMSocialData setAppKey:UMSharekey];
    //微信分享
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXappSecret url:url];
    //向微信支付注册wxd930ea5d5a258f4f
    [WXApi registerApp:WXAppId withDescription:@"com.jsyh.xjd"];
    //手机qq分享
    [UMSocialQQHandler setQQWithAppId:QQWithAppId appKey:QQappKey url:url];
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    //新浪分享
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:sinaAppKey secret:sinaAppSecret RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    firstViewController *first=[[firstViewController alloc]init];
    
    UINavigationController *firstNV = [[UINavigationController alloc]initWithRootViewController:first];
    
    secondViewController *second=[[secondViewController alloc]init];
    UINavigationController *secondNV = [[UINavigationController alloc]initWithRootViewController:second];
    GoodsCarViewController *goodsCarVC = [GoodsCarViewController new];
     UINavigationController *thirdNV = [[UINavigationController alloc]initWithRootViewController:goodsCarVC];

    fourthViewController *fourth=[[fourthViewController alloc]init];
    UINavigationController *fourthNV = [[UINavigationController alloc]initWithRootViewController:fourth];
    FindViewController *findVC = [[FindViewController alloc]init];
    UINavigationController *findNV = [[UINavigationController alloc]initWithRootViewController:findVC];
    
    NSArray *array=@[firstNV,secondNV,findNV,thirdNV,fourthNV];
    MyTabBarViewController *tab=[[MyTabBarViewController alloc]init];
    tab.tabBar.hidden = YES;
    
    tab.viewControllers=array;
    //    [tab.viewControllers objectAtIndex:0];
    UIButton * button = [[UIButton alloc]init];
    button.tag = 100;
    [tab buttonClicked:button];
    
    //      UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:tab];
    tab.delegate=self;
#pragma mark --接收登录通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginSuccess:) name:@"login" object:nil];
#pragma mark --接收退出通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(quiteSuccess:) name:@"quite" object:nil];
    // self.window.rootViewController=tab;
    self.window.rootViewController=tab;
    
    

    
 
    // [self gotoDaoHangYe];
    //检测网络是否可用
//    Reachability *reach = [Reachability reachabilityForInternetConnection];
//    NetworkStatus status = [reach currentReachabilityStatus];
//    UIAlertView *alret = [[UIAlertView alloc]initWithTitle:@"Reachability" message:[self stringFromStatus:status] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alret show];
    return YES;
}

-(NSString *)stringFromStatus:(NetworkStatus)status{
    NSString *string;
    switch (status) {
        case NotReachable:
            string = @"Not Reachable";
            break;
        case ReachableViaWiFi:
            string = @"Reachable via WIFI";
            break;
        case ReachableViaWWAN:
            string = @"Reachable via WWAN";
            break;
        default:
            string = @"Unknown";
            break;
    }
    return string;
}
-(void)loginSuccess:(NSNotification *)sender{
    //    NSLog(@"%@",sender.object);
    NSDictionary *dic = sender.object;
    self.tempDic = dic[@"dic"];
    self.userName = dic[@"userName"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //登陆成功后把用户名和密码存储到UserDefault
    [userDefaults setObject:dic[@"dic"] forKey:@"dic"];
    
    [userDefaults synchronize];
}
-(void)quiteSuccess:(NSNotification *)sender{
    
    self.tempDic = nil;
    self.userName = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   
    [userDefaults removeObjectForKey:@"dic"];
    
    [userDefaults synchronize];
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
//    if ([UMSocialSnsService handleOpenURL:url]) {
//        return [UMSocialSnsService handleOpenURL:url];
//    }else if([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]]){
//        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//    }else{
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//        return YES;
//    }
    
    BOOL result=[UMSocialSnsService handleOpenURL:url];
    if([WXApi handleOpenURL:url delegate:self]){
        return YES;
    }
    if (result==FALSE) {
        //调用其他SDK,例如支付宝SDK
        
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
        
        
    }
    return result;
}

-(CGRect)createFrameWithX:(CGFloat)x andY:(CGFloat)y andWidth:(CGFloat)width andHeight:(CGFloat)height
{
    return CGRectMake(x * (WIDTH / 375.0), y * (HEIGHT/667.0), width * (WIDTH / 375.0), height * (HEIGHT / 667.0));
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
