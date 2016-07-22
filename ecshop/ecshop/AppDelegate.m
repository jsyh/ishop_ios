//
//  AppDelegate.m
//  ecshop
//
//  Created by jsyh-mac on 15/11/30.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "firstViewController.h"
#import "secondViewController.h"
#import "thirdViewController.h"
#import "fourthViewController.h"
#import "MyTabBarViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UserGuideViewController.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyWindow];
    
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *UMSharekey = data[@"UMSharekey"];
    NSString *WXAppId = data[@"WXAppId"];
    NSString *WXappSecret = data[@"WXappSecret"];
    NSString *url = data[@"url"];
    NSString *QQWithAppId = data[@"QQWithAppId"];
    NSString *QQappKey = data[@"QQappKey"];
    
    //友盟分享
    [UMSocialData setAppKey:UMSharekey];
    //微信分享
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXappSecret url:url];
    //手机qq分享
    [UMSocialQQHandler setQQWithAppId:QQWithAppId appKey:QQappKey url:url];
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    
    firstViewController *first=[[firstViewController alloc]init];
    
    UINavigationController *firstNV = [[UINavigationController alloc]initWithRootViewController:first];
    
    secondViewController *second=[[secondViewController alloc]init];
    UINavigationController *secondNV = [[UINavigationController alloc]initWithRootViewController:second];
    thirdViewController *third=[[thirdViewController alloc]init];
    
    UINavigationController *thirdNV = [[UINavigationController alloc]initWithRootViewController:third];
    fourthViewController *fourth=[[fourthViewController alloc]init];
    UINavigationController *fourthNV = [[UINavigationController alloc]initWithRootViewController:fourth];
 
    NSArray *array=@[firstNV,secondNV,thirdNV,fourthNV];
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
    
    
    //向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:@"wxb4ba3c02aa476ea1" withDescription:@"demo 2.0"];

    
   // [self gotoDaoHangYe];
    return YES;    
}
//-(void)gotoDaoHangYe
//{
//    NSFileManager *manager = [NSFileManager defaultManager];
//    [manager createFileAtPath:[NSHomeDirectory() stringByAppendingString:@"/aa.text"] contents:nil attributes:nil];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//      UIImageView
//        
//    } completion:^(BOOL finished) {
////        [scrollView removeFromSuperview];
////        [pageCtr removeFromSuperview];
//        
//    }];
//}
-(void)loginSuccess:(NSNotification *)sender{
    NSLog(@"%@",sender.object);
    NSDictionary *dic = sender.object;
    self.tempDic = dic[@"dic"];
    self.userName = dic[@"userName"];
}
-(void)quiteSuccess:(NSNotification *)sender{
    self.tempDic = nil;
    self.userName = nil;
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if ([UMSocialSnsService handleOpenURL:url]) {
        return [UMSocialSnsService handleOpenURL:url];
    }else if([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]]){
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else{
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    
//    BOOL result=[UMSocialSnsService handleOpenURL:url];
//    if (result==FALSE) {
//        //调用其他SDK,例如支付宝SDK
//        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//    }
    
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
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else{
        
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        return YES;
    }
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

@end
