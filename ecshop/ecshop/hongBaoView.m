//
//  hongBaoView.m
//  ecshop
//
//  Created by jsyh-mac on 16/1/7.
//  Copyright © 2016年 jsyh. All rights reserved.
//红包

#import "hongBaoView.h"
#import "CouponTableCell.h"
#import "RequestModel.h"
#import "AppDelegate.h"
#import "SureOrderController.h"
#import "UIColor+Hex.h"
@interface hongBaoView ()<UITableViewDelegate,UITableViewDataSource,sendRequestInfo>
{
    UITableView * monTab;
    NSMutableArray * monSource;
    
    BOOL panduan;
}
@end

@implementation hongBaoView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self creatTab];
    [self relodInfo];
    [self initNavigationBar];
    panduan=YES;
    
}
-(void)relodInfo
{
    UIApplication * appli=[UIApplication sharedApplication];
    AppDelegate * app=appli.delegate;
    NSString * appStr=app.tempDic[@"data"][@"key"];
    NSString *api_token = [RequestModel model:@"order" action:@"bouns"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":appStr,@"money":self.money};
    //    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"order" action:@"bouns" block:^(id result) {
        [self sendMessage:result];
    }];
}
-(void)sendMessage:(id)message
{
    
    [monSource addObjectsFromArray:message[@"data"]];
    NSLog(@"红包信息%@",message[@"data"]);
    [monTab reloadData];
}
-(void)creatTab
{
    monSource=[[NSMutableArray alloc]init];
    monTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    monTab.delegate=self;
    monTab.dataSource=self;
    [self.view addSubview:monTab];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return monSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *stringg=@"CouponTableCell";
    CouponTableCell * cell=[tableView dequeueReusableCellWithIdentifier:stringg];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CouponTableCell" owner:self options:nil] lastObject];
    }
    
    cell.nameLab.text=monSource[indexPath.row][@"type_name"];
    cell.moneyLab.text= monSource[indexPath.row][@"type_money"];
    cell.requireLab.text=[NSString stringWithFormat:@"满%@可以使用",monSource[indexPath.row][@"min_goods_amount"]];
    cell.stateLab.text=monSource[indexPath.row][@"status"];
    
    NSString * time1=monSource[indexPath.row][@"use_start_date"];
    NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[time1 floatValue]];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY-MM-dd"];
    NSString * startTime = [df stringFromDate:dt];
    
    NSString * time2=monSource[indexPath.row][@"use_end_date"];
    NSDate * dt2 = [NSDate dateWithTimeIntervalSince1970:[time2 floatValue]];
    NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"YYYY-MM-dd"];
    NSString * endTime = [df2 stringFromDate:dt2];
    cell.timeLab.text=[NSString stringWithFormat:@"有效期:%@至%@",startTime,endTime];
    
    UIImage * imageUser;
        cell.timeLab.backgroundColor=[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:145.0/255.0 alpha:1.0];
        cell.stateLab.backgroundColor=[UIColor colorWithRed:244.0/255.0 green:152.0/255.0 blue:145.0/255.0 alpha:1.0];
        imageUser=[UIImage imageNamed:@"bouns_content_bg_notused"];
        imageUser=[imageUser imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        cell.pictureStateImgView.image=imageUser;
        
       return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (panduan==YES) {
        hongbaoId=monSource[indexPath.row][@"bonus_id"];
        typeID=monSource[indexPath.row][@"bonus_type_id"];
        name=monSource[indexPath.row][@"type_name"];
        mianzhi=monSource[indexPath.row][@"type_money"];
        kydiyong=monSource[indexPath.row][@"min_goods_amount"];
        NSNotificationCenter *ncMon=[NSNotificationCenter defaultCenter];
        NSMutableDictionary *mydic=[[NSMutableDictionary alloc]init];
        [mydic setObject:[NSString stringWithFormat:@"%@",name] forKey:@"monName"];
        [mydic setObject:[NSString stringWithFormat:@"%@",mianzhi]forKey:@"monHow"];
        [mydic setObject:[NSString stringWithFormat:@"%@",kydiyong] forKey:@"mondiyong"];
        [mydic setObject:[NSString stringWithFormat:@"%@",hongbaoId] forKey:@"baoID"];
        [mydic setObject:[NSString stringWithFormat:@"%@",typeID] forKey:@"typeIID"];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:mydic,@"myMon", nil];
        NSNotification *MonInfo=[[NSNotification alloc]initWithName:@"MonInfo" object:nil userInfo:dict];
        [ncMon postNotification:MonInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else if (panduan==NO){
        hongbaoId=@"";
        typeID=@"";
        name=@"";
        mianzhi=@"";
        kydiyong=@"";
        NSNotificationCenter *ncMon=[NSNotificationCenter defaultCenter];
        NSMutableDictionary *mydic=[[NSMutableDictionary alloc]init];
        [mydic setObject:[NSString stringWithFormat:@"%@",name] forKey:@"monName"];
        [mydic setObject:[NSString stringWithFormat:@"%@",mianzhi]forKey:@"monHow"];
        [mydic setObject:[NSString stringWithFormat:@"%@",kydiyong] forKey:@"mondiyong"];
        [mydic setObject:[NSString stringWithFormat:@"%@",hongbaoId] forKey:@"baoID"];
        [mydic setObject:[NSString stringWithFormat:@"%@",typeID] forKey:@"typeIID"];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:mydic,@"myMon", nil];
        NSNotification *MonInfo=[[NSNotification alloc]initWithName:@"MonInfo" object:nil userInfo:dict];
        [ncMon postNotification:MonInfo];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
-(void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 自定义导航栏
- (void)initNavigationBar{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *naviBGColor = data[@"navigationBGColor"];
    NSString *navigationTitleFont = data[@"navigationTitleFont"];
    int titleFont = [navigationTitleFont intValue];
    NSString *naiigationTitleColor = data[@"naiigationTitleColor"];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    label.text = @"选择红包";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:titleFont];
    label.textColor = [UIColor colorWithHexString:naiigationTitleColor];
    [view addSubview:label];
  
    
    UIImage *img = [UIImage imageNamed:@"back.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 20, 20)];
    imgView.image = img;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    [btn addSubview:imgView];
    [btn addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 25, 60, 32)];
    
    [btn2 setTitle:@"取消选择" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn2.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn2 addTarget:self action:@selector(backButton2) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn2];
    [self.view addSubview:view];
    
    
}
-(void)backButton2{
    
    hongbaoId=@"";
    typeID=@"";
    name=@"";
    mianzhi=@"";
    kydiyong=@"";
    NSNotificationCenter *ncMon=[NSNotificationCenter defaultCenter];
    NSMutableDictionary *mydic=[[NSMutableDictionary alloc]init];
    [mydic setObject:[NSString stringWithFormat:@"%@",name] forKey:@"monName"];
    [mydic setObject:[NSString stringWithFormat:@"%@",mianzhi]forKey:@"monHow"];
    [mydic setObject:[NSString stringWithFormat:@"%@",kydiyong] forKey:@"mondiyong"];
    [mydic setObject:[NSString stringWithFormat:@"%@",hongbaoId] forKey:@"baoID"];
    [mydic setObject:[NSString stringWithFormat:@"%@",typeID] forKey:@"typeIID"];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:mydic,@"myMon", nil];
    NSNotification *MonInfo=[[NSNotification alloc]initWithName:@"MonInfo" object:nil userInfo:dict];
    [ncMon postNotification:MonInfo];
    
    
    [self.navigationController popViewControllerAnimated:YES];
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

@end
