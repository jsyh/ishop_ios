//
//  CheckStandController.m
//  ecshop
//
//  Created by jsyh-mac on 16/1/11.
//  Copyright © 2016年 jsyh. All rights reserved.
//收银台页

#import "CheckStandController.h"
#import "MyOrderViewController.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "UIColor+Hex.h"
#import "WXApiRequestHandler.h"
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
    lab2=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 7, 60, 20)];
    lab2.textAlignment=NSTextAlignmentLeft;
    lab2.text=_jiage;
    lab2.textColor=[UIColor redColor];
    lab2.font=[UIFont systemFontOfSize:13];
    [headView addSubview:lab2];
    [headView addSubview:lab1];
    [self.view addSubview:headView];
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    [self.view addSubview:table];
    
}
-(void)centerBtn
{
    MyOrderViewController * order=[[MyOrderViewController alloc]init];
    order.tagg = @"0";
    [self.navigationController pushViewController:order animated:YES];
    //    [self presentViewController:order animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
        cell.imageView.image=[UIImage imageNamed:@"支付-余额支付"];
        cell.textLabel.text=@"余额支付";
        cell.detailTextLabel.text=@"用户余额支付";
        
    }
    else if (indexPath.section==1)
    {
        cell.imageView.image=[UIImage imageNamed:@"支付-支付宝支付"];
        cell.textLabel.text=@"支付宝支付";
        cell.detailTextLabel.text=@"支付宝安全支付";
    }
    //    else if(indexPath.section == 2){
    //        cell.textLabel.text = @"微信支付";
    //        cell.imageView.image = [UIImage imageNamed:@"支付-微信支付"];
    //        cell.detailTextLabel.text=@"微信支付";
    //    }
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
                //                    UIAlertView * aaa=[[UIAlertView alloc]initWithTitle:@"提示" message:@"购买成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                //                    [aaa show];
            }];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error.description);
        }];
    }
    //    else if(indexPath.section == 2){
    //        [self bizPay];
    //    }
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
            UIAlertView * alll=[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alll show];
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)bizPay {
    NSString *res = [WXApiRequestHandler jumpToBizPay];
    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
        
    }
    
}
@end
