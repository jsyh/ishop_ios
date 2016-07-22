//
//  MyOrderViewController.m
//  ecshop
//
//  Created by Jin on 15/12/7.
//  Copyright © 2015年 jsyh. All rights reserved.
//我的订单

#import "MyOrderViewController.h"
#import "MyOrderViewCell.h"
#import "PendingPaymentViewCell.h"
#import "AppDelegate.h"
#import "RequestModel.h"
#import "shangpinModel.h"
#import "CheckStandController.h"
#import "thirdViewController.h"
#import "OrderDetailViewController.h"
#import "SDRefresh.h"
#import "UIColor+Hex.h"
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,SDRefreshViewAnimationDelegate>
@property(nonatomic,strong)UITableView *table;
//存放物品
@property (nonatomic,strong)NSMutableArray *modArray;
//存放订单
@property (nonatomic,strong)NSMutableArray *orderArray;
//
@property (nonatomic,strong)NSMutableDictionary *orderDic;
@property (nonatomic, copy) NSString * chertid;//获得cell的orderid

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, assign) NSInteger totalRowCount;
@property (nonatomic, weak) UIImageView *animationView;
@property (nonatomic, weak) UIImageView *boxView;
@property (nonatomic, weak) UILabel *label;
@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    if ([self.tagg isEqualToString:@"0"]) {
        
        [self myOrder];
        [self draw];
    }else if ([self.tagg isEqualToString:@"1"]){
      
        [self waitpay:@"obligation"];
        [self draw];
        
    }else if ([self.tagg isEqualToString:@"3"]){
        
        [self waitpay:@"send_goods"];
        [self draw];
        
    }else if ([self.tagg isEqualToString:@"4"]){
       
        [self draw];
        [self waitpay:@"reciv_goods"];
        
    }else if ([self.tagg isEqualToString:@"5"]){
        
        [self waitpay:@"order_sucess"];
        [self draw];
        
    }
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)draw{
    
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    self.tempDic = app.tempDic;
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    [self setupHeader];
    [self setupFooter];
    [self.view addSubview:_table];
    
}
//我的订单
-(void)myOrder{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    self.tempDic = app.tempDic;
    NSString *api_token = [RequestModel model:@"user" action:@"order"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":self.tempDic[@"data"][@"key"]};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"order" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        
        
        weakSelf.orderArray = [[NSMutableArray alloc]init];
        weakSelf.orderDic = [[NSMutableDictionary alloc]init];
        for (NSMutableDictionary *dict in dic[@"data"]) {
            shangpinModel *model2 = [shangpinModel new];
            weakSelf.modArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dictt in dict[@"goods"]) {
                shangpinModel *model1 = [shangpinModel new];
                model1.goodsName = dictt[@"goods_name"];
                model1.goodsNumber = dictt[@"goods_number"];
                model1.goodsPrice = dictt[@"goods_price"];
                model1.goodsImage = dictt[@"goods_thumb"];
                [weakSelf.modArray addObject:model1];
            }
            model2.orderId = dict[@"order_id"];
            model2.orderSn = dict[@"order_sn"];
            model2.status = dict[@"status"];
            model2.total = dict[@"total"];
            
            [weakSelf.orderArray addObject:model2];
            [weakSelf.orderDic setValue:weakSelf.modArray forKey:model2.orderId];
            
        }
        
        
        [weakSelf.table reloadData];
    }];
    
}
//待付款
-(void)waitpay :(NSString*)action{
    NSString *api_token = [RequestModel model:@"order" action:action];
    NSDictionary *dict = @{@"api_token":api_token,@"key":self.tempDic[@"data"][@"key"]};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"order" action:action block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"获得的数据：%@",dic);
        weakSelf.orderArray = nil;
        weakSelf.orderDic = nil;
        weakSelf.orderArray = [[NSMutableArray alloc]init];
        weakSelf.orderDic = [[NSMutableDictionary alloc]init];
        for (NSMutableDictionary *dict in dic[@"data"]) {
            weakSelf.modArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dictt in dict[@"goods"]) {
                shangpinModel *model1 = [shangpinModel new];
                model1.goodsName = dictt[@"goods_name"];
                model1.goodsNumber = dictt[@"goods_number"];
                model1.goodsPrice = dictt[@"goods_price"];
                model1.goodsImage = dictt[@"goods_thumb"];
                [weakSelf.modArray addObject:model1];
            }
            shangpinModel *model2 = [shangpinModel new];
            model2.orderId = dict[@"order_id"];
            model2.orderSn = dict[@"order_sn"];
            if ([action isEqualToString:@"obligation"]) {
                model2.status = @"6";
            }else if ([action isEqualToString:@"send_goods"]) {
                model2.status = @"7";
            }else if ([action isEqualToString:@"reciv_goods"]) {
                model2.status = @"8";
            }else if ([action isEqualToString:@"order_sucess"]) {
                model2.status = @"9";
            }
            
            //订单状态0未确认1已确认 2已取消 3无效 4退货 5已分单
            model2.order_status = dict[@"order_status"];
            //支付状态 0未付款1付款中 2已付款
            model2.pay_status = dict[@"pay_status"];
            //发货状态 0未发货1已发货 2已取消 3配货中 5发货中
            model2.shipping_status = dict[@"shipping_status"];
            model2.total = dict[@"total"];
            [weakSelf.orderArray addObject:model2];
            
            [weakSelf.orderDic setValue:weakSelf.modArray forKey:model2.orderId];
            
            
            
        }
        
        
        [weakSelf.table reloadData];
    }];
}
#pragma mark -tableViewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    shangpinModel *model = [shangpinModel new];
    model = _orderArray[section];
    return [[_orderDic objectForKey:model.orderId] count];
}
//设置section的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _orderArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    shangpinModel *modell = [shangpinModel new];
    modell = _orderArray[section];
    UILabel *labForWaitPay = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 5, 70, 40)];
    labForWaitPay.font = [UIFont systemFontOfSize:15];
    if ([modell.status isEqualToString:@"1"]) {
        
        labForWaitPay.text = @"待付款";
        
    }else if([modell.status isEqualToString:@"2"]){
        labForWaitPay.text = @"已取消";
    }else if([modell.status isEqualToString:@"3"]){
        labForWaitPay.text = @"待发货";
    }else if([modell.status isEqualToString:@"4"]){
        labForWaitPay.text = @"已发货";
    }else if([modell.status isEqualToString:@"5"]){
        labForWaitPay.text = @"已完成";
    }else if([modell.status isEqualToString:@"6"]){
        labForWaitPay.text = @"等待付款";
    }else if([modell.status isEqualToString:@"7"]){
        labForWaitPay.text = @"待发货";
    }else if([modell.status isEqualToString:@"8"]){
        labForWaitPay.text = @"待收货";
    }else if([modell.status isEqualToString:@"9"]){
        labForWaitPay.text = @"已完成";
    }
    
    labForWaitPay.textColor = [UIColor redColor];
    [headerView addSubview:labForWaitPay];
    
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    footerView.backgroundColor = [UIColor whiteColor];
    UILabel *labRealMoney = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, (self.view.frame.size.width/5)*2, 40)];
    
    shangpinModel *model = [shangpinModel new];
    model = _orderArray[section];
    
    labRealMoney.text = [NSString stringWithFormat:@"实付款：%@",model.total];
    labRealMoney.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:labRealMoney];
    
    if ([model.status isEqualToString:@"1"]) {
        
        //取消按钮
        UIButton *btnForCancel = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width/5)*3, 10, self.view.frame.size.width/5-5, 35)];
        [btnForCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnForCancel setTitleColor:kColorBack forState:UIControlStateNormal];
        btnForCancel.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnForCancel.layer setBorderWidth:0.8];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 239/255.0, 239/255.0, 244/255.0, 1 });
        CGColorSpaceRelease(colorSpace);
        [btnForCancel.layer setBorderColor:colorref];
        CGColorRelease(colorref);
        [btnForCancel.layer setCornerRadius:10];
        [btnForCancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btnForCancel];
        
        //去支付按钮
        UIButton *btnForPay = [UIButton buttonWithType:UIButtonTypeCustom];
        btnForPay.frame = CGRectMake((self.view.frame.size.width/5)*4, 10, self.view.frame.size.width/5-5, 35);
        [btnForPay setTitle:@"去支付" forState:UIControlStateNormal];
        [btnForPay setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btnForPay.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnForPay addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnForPay.layer setBorderWidth:0.8];
        CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();

        CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 1, 0, 0, 1 });
        [btnForPay.layer setBorderColor:colorref1];
        CGColorRelease(colorref1);
        [btnForPay.layer setCornerRadius:10];
        CGColorSpaceRelease(colorSpace1);
        [footerView addSubview:btnForPay];
        
    }else if([model.status isEqualToString:@"2"]){
        //放回购物车
        UIButton *btnForBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnForBack setTitle:@"放回购物车" forState:UIControlStateNormal];
        btnForBack.frame = CGRectMake((self.view.frame.size.width/5)*4 - 25, 10, self.view.frame.size.width/5+20, 35);
        [btnForBack.layer setBorderWidth:0.8];
        [btnForBack setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btnForBack.titleLabel.font = [UIFont systemFontOfSize:15];
        CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
        
        CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 1, 0, 0, 1 });
        
        [btnForBack.layer setBorderColor:colorref1];
        CGColorRelease(colorref1);
        CGColorSpaceRelease(colorSpace1);
        [btnForBack.layer setCornerRadius:10];
        [footerView addSubview:btnForBack];
    }else if([model.status isEqualToString:@"3"]){
        
    }else if([model.status isEqualToString:@"4"]){
        UIButton *btnForSure = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnForSure setTitle:@"确认收货" forState:UIControlStateNormal];
        btnForSure.frame = CGRectMake((self.view.frame.size.width/5)*4 - 15, 10, self.view.frame.size.width/5+10, 35);
        [btnForSure setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btnForSure.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnForSure addTarget:self action:@selector(received:) forControlEvents:UIControlEventTouchUpInside];
        [btnForSure.layer setBorderWidth:0.8];
        CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
        
        CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 1, 0, 0, 1 });
        [btnForSure.layer setBorderColor:colorref1];
        CGColorRelease(colorref1);
        CGColorSpaceRelease(colorSpace1);
        [btnForSure.layer setCornerRadius:10];
        [footerView addSubview:btnForSure];
    }else if([model.status isEqualToString:@"5"]){
        UIButton *btnForSure = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnForSure setTitle:@"再次购买" forState:UIControlStateNormal];
        [btnForSure addTarget:self action:@selector(changeToBuy:) forControlEvents:UIControlEventTouchUpInside];
        btnForSure.frame = CGRectMake((self.view.frame.size.width/5)*4 - 15, 10, self.view.frame.size.width/5+10, 35);
        btnForSure.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnForSure setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btnForSure.layer setBorderWidth:0.8];
        CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
        
        CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 1, 0, 0, 1 });
        [btnForSure.layer setBorderColor:colorref1];
        CGColorRelease(colorref1);
        CGColorSpaceRelease(colorSpace1);
        [btnForSure.layer setCornerRadius:10];
        [footerView addSubview:btnForSure];
    }else if([model.status isEqualToString:@"6"]){
        UIButton *btnForPay = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnForPay setTitle:@"去付款" forState:UIControlStateNormal];
        btnForPay.frame = CGRectMake((self.view.frame.size.width/5)*4 - 5, 10, self.view.frame.size.width/5, 35);
        [btnForPay setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btnForPay.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnForPay.layer setBorderWidth:0.8];
        [btnForPay addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
        
        CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 1, 0, 0, 1 });
        [btnForPay.layer setBorderColor:colorref1];
        CGColorRelease(colorref1);
        CGColorSpaceRelease(colorSpace1);
        [btnForPay.layer setCornerRadius:10];
        [footerView addSubview:btnForPay];
    }else if([model.status isEqualToString:@"7"]){
        
    }else if([model.status isEqualToString:@"8"]){
        UIButton *btnForSure = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnForSure setTitle:@"确认收货" forState:UIControlStateNormal];
        btnForSure.frame = CGRectMake((self.view.frame.size.width/5)*4 - 15, 10, self.view.frame.size.width/5+10, 35);
        [btnForSure setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btnForSure.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnForSure addTarget:self action:@selector(received:) forControlEvents:UIControlEventTouchUpInside];
        [btnForSure.layer setBorderWidth:0.8];
        CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
        
        CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 1, 0, 0, 1 });
        [btnForSure.layer setBorderColor:colorref1];
        CGColorRelease(colorref1);
        CGColorSpaceRelease(colorSpace1);
        [btnForSure.layer setCornerRadius:10];
        [footerView addSubview:btnForSure];
    }else if([model.status isEqualToString:@"9"]){
        
    }
    
    
    
    
    UIView *viewForLine = [[UIView alloc]initWithFrame:CGRectMake(0, footerView.frame.size.height, self.view.frame.size.width, 20)];
    viewForLine.backgroundColor = kColorBack;
    [footerView addSubview:viewForLine];
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //订单号的model
    shangpinModel *modell = [shangpinModel new];
    //    modell = self.modArray[indexPath.section];
    modell = [self.orderArray objectAtIndex:indexPath.section];
    shangpinModel *modelll = [shangpinModel new];
    modelll = [self.orderDic objectForKey:modell.orderId][indexPath.row];
    
    static NSString *string = @"myOrder";
    MyOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderViewCell" owner:self options:nil]lastObject];
    }
    cell.model = modelll;
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tagg isEqualToString:@"0"]) {
        //订单号的model
        shangpinModel *modell = [shangpinModel new];
        //    modell = self.modArray[indexPath.section];
        modell = [self.orderArray objectAtIndex:indexPath.section];
        shangpinModel *modelll = [shangpinModel new];
        modelll = [self.orderDic objectForKey:modell.orderId][indexPath.row];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [arr addObject:modelll];
        OrderDetailViewController *orderVC = [[OrderDetailViewController alloc]init];
        
        orderVC.orderId = modell.orderId;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
#pragma mark --确认收货
-(void)received:(UIButton *)button{
    
    shangpinModel *model = [shangpinModel new];
    model = _orderArray[button.tag];
    
    NSLog(@"确认收货%@",model.orderId);
    NSString *api_token = [RequestModel model:@"order" action:@"received"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":self.tempDic[@"data"][@"key"],@"order_id":model.orderId};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"order" action:@"received" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"获得的数据：%@",dic);
        
        
        
        [weakSelf waitpay:@"reciv_goods"];
        
    }];
    
}
#pragma mark -- 取消订单
-(void)cancel:(UIButton *)button{
    shangpinModel *model = [shangpinModel new];
    model = _orderArray[button.tag];
    NSLog(@"取消订单");
    
    NSString *api_token = [RequestModel model:@"order" action:@"qorder"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":self.tempDic[@"data"][@"key"],@"order_id":model.orderId};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"order" action:@"qorder" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"获得的数据：%@",dic);
        
        
        
        
        [weakSelf.table reloadData];
    }];
}
#pragma mark --去支付
-(void)payAction:(UIButton *)button{
    shangpinModel *model = [shangpinModel new];
    model = _orderArray[button.tag];
    CheckStandController * cherk=[[CheckStandController alloc]init];
    cherk.orderNs=model.orderId;
    [self.navigationController pushViewController:cherk animated:YES];
    
    
}
//再次购买
-(void)changeToBuy:(UIButton *)button{
    //order recart
    shangpinModel *model = [shangpinModel new];
    model = _orderArray[button.tag];
    NSLog(@"%@",model);
    
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"order" action:@"recart"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"order_id":model.orderId};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"order" action:@"recart" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        
        thirdViewController *thirdVC = [thirdViewController new];
        [weakSelf.navigationController pushViewController:thirdVC animated:YES];
        
        thirdVC.temp = @"1";
        
        [weakSelf.table reloadData];
    }];
}
#pragma mark -刷新
- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    refreshHeader.backgroundColor = [UIColor whiteColor];
    refreshHeader.delegate = self;
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置
//        refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.table];
    _refreshHeader = refreshHeader;
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    __weak typeof(self) weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.totalRowCount += 3;
            [weakSelf.table reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 动画view
    UIImageView *animationView = [[UIImageView alloc] init];
    
    animationView.frame = CGRectMake(30, 45, 40, 40);
    animationView.image = [UIImage imageNamed:@"a0v"];
    [refreshHeader addSubview:animationView];
    _animationView = animationView;
    
    NSArray *images = @[[UIImage imageNamed:@"a0v"],
                        [UIImage imageNamed:@"a0w"],
                        [UIImage imageNamed:@"a0x"],
                        [UIImage imageNamed:@"a0y"]
                        ];
    _animationView.animationImages = images;
    
    
    UIImageView *boxView = [[UIImageView alloc] init];
    boxView.frame = CGRectMake(150, 10, 15, 8);
    boxView.image = [UIImage imageNamed:@"box"];
    [refreshHeader addSubview:boxView];
    _boxView = boxView;
    
    UILabel *label= [[UILabel alloc] init];
    label.text = @"下拉加载最新数据";
    label.frame = CGRectMake((self.view.bounds.size.width - 200) * 0.5, 5, 200, 20);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [refreshHeader addSubview:label];
    _label = label;
    
    // 进入页面自动加载一次数据
    [refreshHeader autoRefreshWhenViewDidAppear];
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.table];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}


- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.totalRowCount += 2;
        [self.table reloadData];
        [self.refreshFooter endRefreshing];
    });
}

#pragma mark - SDRefreshView Animation Delegate

- (void)refreshView:(SDRefreshView *)refreshView didBecomeNormalStateWithMovingProgress:(CGFloat)progress
{
    refreshView.hidden = NO;
    
    if (progress == 0) {
        _animationView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _boxView.hidden = NO;
        
        _label.text = @"下拉可以刷新";
        
        [_animationView stopAnimating];
    }
    //    self.animationView.transform = CGAffineTransformMakeTranslation(progress * 20, -20 * progress);
    self.animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(progress * 30, -20 * progress), CGAffineTransformMakeScale(progress, progress));
    self.boxView.transform = CGAffineTransformMakeTranslation(- progress * 65, progress * 35);
    
}

- (void)refreshView:(SDRefreshView *)refreshView didBecomeRefreshingStateWithMovingProgress:(CGFloat)progress
{
    _label.text = @"正在加载数据...";
    [UIView animateWithDuration:1.5 animations:^{
        //        self.animationView.transform = CGAffineTransformMakeTranslation(200, -20);
    }];
}

- (void)refreshView:(SDRefreshView *)refreshView didBecomeWillRefreshStateWithMovingProgress:(CGFloat)progress
{
    _boxView.hidden = YES;
    _label.text = @"松开后刷新";
    _animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(30, -20), CGAffineTransformMakeScale(1, 1));
    [_animationView startAnimating];
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    if ([self.tagg isEqualToString:@"0"]) {
        label.text = @"全部订单";
       
    }else if ([self.tagg isEqualToString:@"1"]){
        label.text = @"待付款";
      
        
    }else if ([self.tagg isEqualToString:@"3"]){
        label.text = @"待发货";
     
        
    }else if ([self.tagg isEqualToString:@"4"]){
        label.text = @"待收货";
     
        
    }else if ([self.tagg isEqualToString:@"5"]){
        label.text = @"已完成";
      
        
    }
   
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
