//
//  ExpressView.m
//  ecshop
//
//  Created by jsyh-mac on 16/1/7.
//  Copyright © 2016年 jsyh. All rights reserved.
//选择配送方式

#import "ExpressView.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "SureOrderController.h"
#import "UIColor+Hex.h"
@interface ExpressView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * datasource;//数据源
    UITableView * table1;
}
@end

@implementation ExpressView
-(void)viewWillAppear:(BOOL)animated
{

}
-(void)viewWillDisappear:(BOOL)animated
{

}
- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.opaque=YES;
    datasource=[[NSMutableArray alloc]init];
    [self createTable];
    [self requestInfo];
    [self initNavigationBar];
   
}
-(void)requestInfo
{
    UIApplication * appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *url1 = data[@"url"];
    
    NSString * strr= app.tempDic[@"data"][@"key"];
    NSString*path=[NSString stringWithFormat:@"%@/order/delivery?key=%@",url1,strr];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       [datasource addObjectsFromArray:responseObject[@"data"]];
            [table1 reloadData];
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
-(void)createTable
{
    table1=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    table1.opaque=YES;
    table1.delegate=self;
    table1.dataSource=self;
    [self.view addSubview:table1];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId=@"cellId";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.opaque=YES;
    }
    cell.textLabel.text=datasource[indexPath.row][@"shipping_name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _money=datasource[indexPath.row][@"shipp_fee"];
    _excessId=datasource[indexPath.row][@"shipping_id"];
    _yunName=datasource[indexPath.row][@"shipping_name"];
    
    NSNotificationCenter *ncInfo=[NSNotificationCenter defaultCenter];
    NSMutableDictionary *mydic=[[NSMutableDictionary alloc]init];
    [mydic setObject:[NSString stringWithFormat:@"%@",self.money] forKey:@"myMoney"];
    [mydic setObject:[NSString stringWithFormat:@"%@",self.excessId]forKey:@"myID"];
    [mydic setObject:[NSString stringWithFormat:@"%@",self.yunName] forKey:@"myName"];
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:mydic,@"myInfo", nil];
    NSNotification *nofiInfo=[[NSNotification alloc]initWithName:@"yunfeiInfo" object:nil userInfo:dict];
    [ncInfo postNotification:nofiInfo];
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
    NSString *navigationTitleFont = data[@"navigationTitleFont"];
    int titleFont = [navigationTitleFont intValue];
    NSString *naiigationTitleColor = data[@"naiigationTitleColor"];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor colorWithHexString:naviBGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    label.text = @"选择配送方式";
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
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
