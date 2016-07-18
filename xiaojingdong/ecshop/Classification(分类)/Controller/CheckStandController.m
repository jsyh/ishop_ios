//
//  CheckStandController.m
//  ecshop
//
//  Created by jsyh-mac on 16/1/11.
//  Copyright © 2016年 jsyh. All rights reserved.
//收银台页

#import "CheckStandController.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "UIColor+Hex.h"
#import "WXApi.h"
#import "MyAllOrderViewController.h"

#import <AlipaySDK/AlipaySDK.h>
@interface CheckStandController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * table;
    UILabel * lab2;
}
@end

@implementation CheckStandController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self initNavigationBar];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"订单中心" style:UIBarButtonItemStylePlain target:self action:@selector(centerBtn)];
}
-(void)createUI
{
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 35)];
    UILabel * lab1=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 100, 20)];
    lab1.text=@"请选择支付方式";
    lab1.textColor=[UIColor lightGrayColor];
    lab1.textAlignment=NSTextAlignmentLeft;
    lab1.font=[UIFont systemFontOfSize:14];
    lab2=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 7, 110, 20)];
    lab2.textAlignment=NSTextAlignmentLeft;
    NSString *labStr = [NSString stringWithFormat:@"¥%@",_jiage];
    lab2.text=labStr;
    lab2.textAlignment=NSTextAlignmentRight;
    lab2.textColor=[UIColor redColor];
    lab2.font=[UIFont systemFontOfSize:13];
    [headView addSubview:lab2];
    [headView addSubview:lab1];
    [self.view addSubview:headView];
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    table.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:table];
   
}
-(void)centerBtn
{
    MyAllOrderViewController * order=[[MyAllOrderViewController alloc]init];
    order.index = 0;
    [self.navigationController pushViewController:order animated:YES];
    //    [self presentViewController:order animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string=@"string";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:string];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==0) {
        cell.imageView.image=[UIImage imageNamed:@"pay_balance"];
        cell.textLabel.text=@"余额支付";
        cell.detailTextLabel.text=@"用户余额支付";
        
    }
    else if (indexPath.section==1)
    {
        cell.imageView.image=[UIImage imageNamed:@"pay_Alipay"];
        cell.textLabel.text=@"支付宝支付";
        cell.detailTextLabel.text=@"支付宝安全支付";
    }
        else if(indexPath.section == 2){
            cell.textLabel.text = @"微信支付";
            cell.imageView.image = [UIImage imageNamed:@"pay_WX"];
            cell.detailTextLabel.text=@"微信支付";
        }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIApplication * appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString * receNs= app.tempDic[@"data"][@"key"];
    NSString * pathh;
    if (indexPath.section==0) {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定使用您的账户余额支付吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else if (indexPath.section==1)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSString *url1 = data[@"url"];
        
        pathh=[NSString stringWithFormat:@"%@/order/pay?key=%@&order_id=%@&type=4",url1,receNs,_orderNs];
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        [manager GET:pathh parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"选择支付宝成功%@",responseObject);
            NSString * sttrr=responseObject[@"data"];
            NSString *appScheme = @"alisdk";
            [[AlipaySDK defaultService] payOrder:sttrr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message: resultDic[@"memo"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self centerBtn];
                }];
                [alertVC addAction:cancelAction];
                [alertVC addAction:okAction];
                [self presentViewController:alertVC animated:YES completion:nil];

            }];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.description);
        }];
    }
        else if(indexPath.section == 2){
            [self bizPay];
        }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex//点击弹窗按钮后
{
    NSLog(@"buttonIndex:%ld",(long)buttonIndex);
    if (buttonIndex == 0) {//取消
        
    }else if (buttonIndex == 1){//确定
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSString *url1 = data[@"url"];
        
        UIApplication * appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString * receNs= app.tempDic[@"data"][@"key"];
        NSString * pathp=[NSString stringWithFormat:@"%@/order/pay?key=%@&order_id=%@&type=1",url1,receNs,_orderNs];
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        [manager GET:pathp parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            //NSLog(@"选择余额成功%@",responseObject);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message: responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               [self centerBtn];
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.description);
        }];
    }
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
    NSString *navigationRightColor = data[@"navigationRightColor"];
    NSString *navigationRightFont = data[@"navigationRightFont"];
    int rightFont = [navigationRightFont intValue];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    label.text = @"收银台";
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
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 10, 25, 80, 30)];
    [rightBtn setTitle:@"订单中心" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:navigationRightColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:rightFont];
    [rightBtn addTarget:self action:@selector(centerBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    [self.view addSubview:view];
    
    
}
-(void)back{
    if ([self.type isEqualToString:@"0"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    
    
}
- (void)bizPay {
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"没有安装微信");

    }else if (![WXApi isWXAppSupportApi]){
        NSLog(@"不支持微信支付");
 
    }else{
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSString *url1 = data[@"url"];
        
        UIApplication * appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString * receNs= app.tempDic[@"data"][@"key"];
        NSString * pathp=[NSString stringWithFormat:@"%@/order/pay?key=%@&order_id=%@&type=5",url1,receNs,_orderNs];
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
         __weak typeof(self) weakSelf = self;
        [manager GET:pathp parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dict = responseObject[@"data"];
              NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dict objectForKey:@"partnerid"];//商户号
            req.prepayId            = [dict objectForKey:@"prepayid"];//预支付交易会话ID
            req.nonceStr            = [dict objectForKey:@"noncestr"];//随机字符串
            req.timeStamp           = stamp.intValue;//签名
            req.package             = [dict objectForKey:@"package"];//扩展字段，暂歇固定值 Sign=WXPay
            req.sign                = [dict objectForKey:@"sign"];//签名
            [WXApi sendReq:req];
           [weakSelf centerBtn];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.description);
        }];

    }

   
    
//    NSString *res = [self jumpToBizPay];
//    if( ![@"" isEqual:res] ){
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        
//        [alter show];
//        
//    }
    
}
- (NSString *)jumpToBizPay {
    
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"没有安装微信");
        return nil;
    }else if (![WXApi isWXAppSupportApi]){
        NSLog(@"不支持微信支付");
        return nil;
    }
    NSLog(@"安装了微信，而且微信支持支付");
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];//商户号
                req.prepayId            = [dict objectForKey:@"prepayid"];//预支付交易会话ID
                req.nonceStr            = [dict objectForKey:@"noncestr"];//随机字符串
                req.timeStamp           = stamp.intValue;//签名
                req.package             = [dict objectForKey:@"package"];//扩展字段，暂歇固定值 Sign=WXPay
                req.sign                = [dict objectForKey:@"sign"];//签名
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}
@end
