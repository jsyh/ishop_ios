//
//  MyAllOrderViewController.m
//  ecshop
//
//  Created by Jin on 16/5/3.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "MyAllOrderViewController.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"
#import "RequestModel.h"
#import "shangpinModel.h"
#import "MyOrderTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "CheckStandController.h"
#import "GoToCommentViewController.h"
#import "OrderDetailViewController.h"
#import "HorizontalMenuView.h"
#import "MyOrderFooterTableViewCell.h"
#import "MyOrderHeaderTableViewCell.h"
#import "MyTabBarViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface MyAllOrderViewController ()<UITableViewDataSource,UITableViewDelegate,HorizontalMenuProtocol>
{
   
    int currentIndex;

    float titleHeight;
    float bgViewHeight;
    
}
@property (nonatomic,strong)UITableView *tableView1;
@property (nonatomic,strong)UITableView *tableView2;
@property (nonatomic,strong)UITableView *tableView3;
@property (nonatomic,strong)UITableView *tableView4;
@property (nonatomic,strong)UITableView *tableView5;
@property (nonatomic,strong) NSMutableArray *orderArray;//存放订单信息
@property (nonatomic,strong) NSMutableDictionary *orderDic;//key为orderid的字典存放商品数组
@property (nonatomic,strong) NSMutableArray *modArray; //我的订单里面的商品的数组

@property (nonatomic,strong) NSMutableArray *orderArray1;//存放订单信息
@property (nonatomic,strong) NSMutableDictionary *orderDic1;//key为orderid的字典存放商品数组
@property (nonatomic,strong) NSMutableArray *modArray1; //我的订单里面的商品的数组
//待发货
@property (nonatomic,strong) NSMutableArray *orderArray2;//存放订单信息
@property (nonatomic,strong) NSMutableDictionary *orderDic2;//key为orderid的字典存放商品数组
@property (nonatomic,strong) NSMutableArray *modArray2; //我的订单里面的商品的数组
//待收货
@property (nonatomic,strong) NSMutableArray *orderArray3;//存放订单信息
@property (nonatomic,strong) NSMutableDictionary *orderDic3;//key为orderid的字典存放商品数组
@property (nonatomic,strong) NSMutableArray *modArray3; //我的订单里面的商品的数组
//待评价
@property (nonatomic,strong) NSMutableArray *orderArray4;//存放订单信息
@property (nonatomic,strong) NSMutableDictionary *orderDic4;//key为orderid的字典存放商品数组
@property (nonatomic,strong) NSMutableArray *modArray4; //我的订单里面的商品的数组

@property (nonatomic,strong)UIView *nullView;//没有数据的view
@end

@implementation MyAllOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getTag:_index];

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    float a78 = 78.0/1334.0;
    titleHeight= a78*Height;
    bgViewHeight=Height-64-titleHeight;
    [self creatTable1];
    [self creatTable2];
    [self creatTable3];
    [self creatTable4];
    [self creatTable5];
    HorizontalMenuView *menView = [[HorizontalMenuView alloc]init];
    menView.frame = CGRectMake(0, 64, self.view.frame.size.width, titleHeight);
    menView.backgroundColor = [UIColor whiteColor];
    menView.index = _index;
    [self.view addSubview:menView];
    
    NSArray *menuArray = [NSArray arrayWithObjects:@"全部",@"待付款",@"待发货", @"待收货",@"待评价",nil];
    [menView setNameWithArray:menuArray];
    menView.myDelegate = self;
    
    _orderArray = [[NSMutableArray alloc]init];
    _orderArray1 = [[NSMutableArray alloc]init];
    _orderArray2 = [[NSMutableArray alloc]init];
    _orderArray3 = [[NSMutableArray alloc]init];
    _orderArray4 = [[NSMutableArray alloc]init];
    _orderDic = [[NSMutableDictionary alloc]init];
    _orderDic1 = [[NSMutableDictionary alloc]init];
    _orderDic2 = [[NSMutableDictionary alloc]init];
    _orderDic3 = [[NSMutableDictionary alloc]init];
    _orderDic4 = [[NSMutableDictionary alloc]init];

    [self initNavigationBar];
    [self creatnullView];
  
   
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    
    // Do any additional setup after loading the view.
}
-(void)creatnullView{
    _nullView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+titleHeight, Width, Height-64-titleHeight)];
    _nullView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    float aY336 = 336.0/1334.0;
    float aW172 = 172.0/750.0;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - aW172*Width/2, aY336*Height, aW172*Width, aW172*Width)];
    imgView.image = [UIImage imageNamed:@"myorder_null_data"];
    [_nullView addSubview:imgView];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+18, Width, 16)];
    lab.text = @"没有相关的订单";
    lab.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textAlignment = NSTextAlignmentCenter;
    [_nullView addSubview:lab];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab.frame.origin.y+lab.frame.size.height+12, Width, 13)];
    lab2.text = @"可以去看看有哪些想买的";
    lab2.textColor = [UIColor colorWithHexString:@"#43464c"];
    lab2.font = [UIFont systemFontOfSize:13];
    lab2.textAlignment = NSTextAlignmentCenter;
    [_nullView addSubview:lab2];
     _nullView.hidden = YES;
    [self.view addSubview:_nullView];
}
#pragma mark --解析数据
-(void)myreload{
    _nullView.hidden = YES;
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"user" action:@"order"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"type":@"0"};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"order" block:^(id result) {
        [weakSelf.orderArray removeAllObjects];
        [weakSelf.orderDic removeAllObjects];
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        if (dic[@"data"] == nil) {
            weakSelf.tableView1.hidden = YES;
             weakSelf.nullView.hidden = NO;
        }else{
            weakSelf.tableView1.hidden = NO;
            
            for (NSMutableDictionary *dict in dic[@"data"]) {
                shangpinModel *model2 = [shangpinModel new];
                weakSelf.modArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dictt in dict[@"goods"]) {
                    shangpinModel *model1 = [shangpinModel new];
                    model1.goodsName = dictt[@"goods_name"];
                    model1.goodsNumber = dictt[@"goods_number"];
                    model1.goodsPrice = dictt[@"goods_price"];
                    model1.goodsImage = dictt[@"goods_thumb"];
                    model1.attrStr = dictt[@"attr"];
                    model1.goodsID = dictt[@"goods_id"];
                    [weakSelf.modArray addObject:model1];
                }
                model2.orderId = dict[@"order_id"];
                model2.orderSn = dict[@"order_sn"];
                model2.status = dict[@"status"];
                model2.total = dict[@"total"];
                model2.supplierName = dict[@"shop_name"];
                model2.mobile = dict[@"service_phone"];
                [weakSelf.orderArray addObject:model2];
                [weakSelf.orderDic setValue:weakSelf.modArray forKey:model2.orderId];
                
            }
            
            
        }
        
        [weakSelf.tableView1 reloadData];
    }];

}
-(void)myWait{
    _nullView.hidden = YES;
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"user" action:@"order"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"type":@"1"};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"order" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        if ([dic[@"msg"] isEqualToString:@"暂无订单信息" ]) {
            NSLog(@"暂无订单信息");
        }
        [weakSelf.orderArray1 removeAllObjects];
        [weakSelf.orderDic1 removeAllObjects];
        if (dic[@"data"] == nil) {
            weakSelf.tableView2.hidden = YES;
            if (weakSelf.tableView1.hidden == NO) {
                weakSelf.nullView.hidden = YES;
            }else{
                weakSelf.nullView.hidden = NO;
            }
            
            
        }else{
            weakSelf.tableView2.hidden = NO;
            
            for (NSMutableDictionary *dict in dic[@"data"]) {
                shangpinModel *model2 = [shangpinModel new];
                weakSelf.modArray1 = [[NSMutableArray alloc]init];
                for (NSDictionary *dictt in dict[@"goods"]) {
                    shangpinModel *model1 = [shangpinModel new];
                    model1.goodsName = dictt[@"goods_name"];
                    model1.goodsNumber = dictt[@"goods_number"];
                    model1.goodsPrice = dictt[@"goods_price"];
                    model1.goodsImage = dictt[@"goods_thumb"];
                    model1.attrStr = dictt[@"attr"];
                     model1.goodsID = dictt[@"goods_id"];
                    [weakSelf.modArray1 addObject:model1];
                }
                model2.orderId = dict[@"order_id"];
                model2.orderSn = dict[@"order_sn"];
                model2.status = dict[@"status"];
                model2.total = dict[@"total"];
                model2.mobile = dict[@"service_phone"];
                model2.supplierName = dict[@"shop_name"];
                [weakSelf.orderArray1 addObject:model2];
                [weakSelf.orderDic1 setValue:weakSelf.modArray1 forKey:model2.orderId];
                
            }
            
            
            
        }
        [weakSelf.tableView2 reloadData];
    }];
}
//待发货
-(void)myWaitSend{
    _nullView.hidden = YES;
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"user" action:@"order"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"type":@"2"};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"order" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        if ([dic[@"msg"] isEqualToString:@"暂无订单信息" ]) {
            NSLog(@"暂无订单信息");
        }
        [weakSelf.orderArray2 removeAllObjects];;
        [weakSelf.orderDic2 removeAllObjects];
        if (dic[@"data"] == nil) {
            weakSelf.tableView3.hidden = YES;
            if (weakSelf.tableView1.hidden == NO) {
                weakSelf.nullView.hidden = YES;
            }else{
                weakSelf.nullView.hidden = NO;
            }
            
            
        }else{
            weakSelf.tableView3.hidden = NO;
         
           
            for (NSMutableDictionary *dict in dic[@"data"]) {
                shangpinModel *model2 = [shangpinModel new];
                weakSelf.modArray2 = [[NSMutableArray alloc]init];
                for (NSDictionary *dictt in dict[@"goods"]) {
                    shangpinModel *model1 = [shangpinModel new];
                    model1.goodsName = dictt[@"goods_name"];
                    model1.goodsNumber = dictt[@"goods_number"];
                    model1.goodsPrice = dictt[@"goods_price"];
                    model1.goodsImage = dictt[@"goods_thumb"];
                    model1.attrStr = dictt[@"attr"];
                     model1.goodsID = dictt[@"goods_id"];
                    [weakSelf.modArray2 addObject:model1];
                }
                model2.orderId = dict[@"order_id"];
                model2.orderSn = dict[@"order_sn"];
                model2.status = dict[@"status"];
                model2.total = dict[@"total"];
                model2.mobile = dict[@"service_phone"];
                model2.supplierName = dict[@"shop_name"];
                [weakSelf.orderArray2 addObject:model2];
                [weakSelf.orderDic2 setValue:weakSelf.modArray2 forKey:model2.orderId];
                
            }
            
            
            
        }
        [weakSelf.tableView3 reloadData];
    }];

}
//待收货
-(void)myWaitshouhuo{
    _nullView.hidden = YES;
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"user" action:@"order"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"type":@"3"};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"order" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        if ([dic[@"msg"] isEqualToString:@"暂无订单信息" ]) {
            NSLog(@"暂无订单信息");
        }
        [weakSelf.orderArray3 removeAllObjects];
        [weakSelf.orderDic3 removeAllObjects];

        if (dic[@"data"] == nil) {
            weakSelf.tableView4.hidden = YES;
            if (weakSelf.tableView1.hidden == NO) {
                weakSelf.nullView.hidden = YES;
            }else{
                weakSelf.nullView.hidden = NO;
            }
            
        }else{
            weakSelf.tableView4.hidden = NO;
            
            for (NSMutableDictionary *dict in dic[@"data"]) {
                shangpinModel *model2 = [shangpinModel new];
                weakSelf.modArray3 = [[NSMutableArray alloc]init];
                for (NSDictionary *dictt in dict[@"goods"]) {
                    shangpinModel *model1 = [shangpinModel new];
                    model1.goodsName = dictt[@"goods_name"];
                    model1.goodsNumber = dictt[@"goods_number"];
                    model1.goodsPrice = dictt[@"goods_price"];
                    model1.goodsImage = dictt[@"goods_thumb"];
                    model1.attrStr = dictt[@"attr"];
                     model1.goodsID = dictt[@"goods_id"];
                    [weakSelf.modArray3 addObject:model1];
                }
                model2.orderId = dict[@"order_id"];
                model2.orderSn = dict[@"order_sn"];
                model2.status = dict[@"status"];
                model2.total = dict[@"total"];
                model2.mobile = dict[@"service_phone"];
                model2.supplierName = dict[@"shop_name"];
                [weakSelf.orderArray3 addObject:model2];
                [weakSelf.orderDic3 setValue:weakSelf.modArray3 forKey:model2.orderId];
                
            }
            
            
           
        }
         [weakSelf.tableView4 reloadData];
    }];
}
//待评价
-(void)waitpj{
    _nullView.hidden = YES;
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"user" action:@"order"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"type":@"4"};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"user" action:@"order" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        if ([dic[@"msg"] isEqualToString:@"暂无订单信息" ]) {
            NSLog(@"暂无订单信息");
        }
        [weakSelf.orderArray4 removeAllObjects];
        [weakSelf.orderDic4 removeAllObjects];
        if (dic[@"data"] == nil) {
            weakSelf.tableView5.hidden = YES;
            if (weakSelf.tableView1.hidden == NO) {
                weakSelf.nullView.hidden = YES;
            }else{
                weakSelf.nullView.hidden = NO;
            }
            
            
        }else{
            weakSelf.tableView5.hidden = NO;

           
            for (NSMutableDictionary *dict in dic[@"data"]) {
                shangpinModel *model2 = [shangpinModel new];
                weakSelf.modArray4 = [[NSMutableArray alloc]init];
                for (NSDictionary *dictt in dict[@"goods"]) {
                    shangpinModel *model1 = [shangpinModel new];
                    model1.goodsName = dictt[@"goods_name"];
                    model1.goodsNumber = dictt[@"goods_number"];
                    model1.goodsPrice = dictt[@"goods_price"];
                    model1.goodsImage = dictt[@"goods_thumb"];
                    model1.attrStr = dictt[@"attr"];
                     model1.goodsID = dictt[@"goods_id"];
                    [weakSelf.modArray4 addObject:model1];
                }
                model2.orderId = dict[@"order_id"];
                model2.orderSn = dict[@"order_sn"];
                model2.status = dict[@"status"];
                model2.total = dict[@"total"];
                model2.mobile = dict[@"service_phone"];
                model2.supplierName = dict[@"shop_name"];
                [weakSelf.orderArray4 addObject:model2];
                [weakSelf.orderDic4 setValue:weakSelf.modArray4 forKey:model2.orderId];
                
            }
            
            
            
        }
        [weakSelf.tableView5 reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatTable1{
    _tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+titleHeight, Width, bgViewHeight) style:UITableViewStylePlain];
    _tableView1.dataSource=self;
    _tableView1.delegate=self;
    _tableView1.hidden = YES;
    _tableView1.tableFooterView = [[UIView alloc]init];
    _tableView1.showsVerticalScrollIndicator = NO;
    
    _tableView1.tag=11;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshColl1)];
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"释放开始加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    _tableView1.mj_header = header;
    _tableView1.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:_tableView1];
    
}

-(void)creatTable2{
    
    _tableView2=[[UITableView alloc] initWithFrame:CGRectMake(0,64+titleHeight, Width, bgViewHeight) style:UITableViewStylePlain];
    _tableView2.tableFooterView = [[UIView alloc]init];
     _tableView2.hidden = YES;
    _tableView2.showsVerticalScrollIndicator = NO;
    _tableView2.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _tableView2.tag=12;
    _tableView2.dataSource=self;
    _tableView2.delegate=self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshColl2)];
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"释放开始加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    _tableView2.mj_header = header;
//    _tableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView2];
}
-(void)creatTable3{
    _tableView3=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+titleHeight, Width, bgViewHeight) style:UITableViewStylePlain];
    _tableView3.tableFooterView = [[UIView alloc]init];
    _tableView3.showsVerticalScrollIndicator = NO;
    _tableView3.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _tableView3.tag=13;
    _tableView3.hidden = YES;
    _tableView3.dataSource=self;
    _tableView3.delegate=self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshColl3)];
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"释放开始加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    _tableView3.mj_header = header;
    [self.view addSubview:_tableView3];
}
-(void)creatTable4{
    _tableView4=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+titleHeight, Width, bgViewHeight) style:UITableViewStylePlain];
    _tableView4.tableFooterView = [[UIView alloc]init];
    _tableView4.showsVerticalScrollIndicator = NO;
    _tableView4.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
     _tableView4.hidden = YES;
    
    _tableView4.tag=14;
    
    _tableView4.dataSource=self;
    _tableView4.delegate=self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshColl4)];
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"释放开始加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    _tableView4.mj_header = header;
    _tableView4.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView4];
}
-(void)creatTable5{
    _tableView5=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+titleHeight, Width, bgViewHeight) style:UITableViewStylePlain];
    
    _tableView5.showsVerticalScrollIndicator = NO;
    _tableView5.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
     _tableView5.hidden = YES;
    _tableView5.tableFooterView = [[UIView alloc]init];
    
    _tableView5.tag=15;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshColl5)];
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"释放开始加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    _tableView5.mj_header = header;
    _tableView5.dataSource=self;
    _tableView5.delegate=self;
    _tableView5.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView5];
}
-(void)refreshColl1{
    [self myreload];
    [_tableView1.mj_header endRefreshing];
}
-(void)refreshColl2{
    [self myWait];
    [_tableView2.mj_header endRefreshing];
}
-(void)refreshColl3{
    [self myWaitSend];
    [_tableView3.mj_header endRefreshing];
}
-(void)refreshColl4{
    [self myWaitshouhuo];
    [_tableView4.mj_header endRefreshing];
}-(void)refreshColl5{
    [self waitpj];
    [_tableView5.mj_header endRefreshing];
}


#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag==11) {
        return _orderArray.count;
    }else if ( tableView.tag ==12){
        return _orderArray1.count;
    }else if ( tableView.tag ==13){
        return _orderArray2.count;
    }
    else if ( tableView.tag ==14){
        return _orderArray3.count;
    }else if ( tableView.tag ==15){
        return _orderArray4.count;
    }
    else{
        return 2;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==11) {
        
        shangpinModel *model1 ;
        model1 =_orderArray[section];
        NSArray *arr = _orderDic[model1.orderId];
        if (arr.count>0) {
            return arr.count+2;
        }else{
            return 0;
        }
    }else if (tableView.tag==12){
        shangpinModel *model1;
        model1 =_orderArray1[section];
        NSArray *arr = _orderDic1[model1.orderId];
        if (arr.count>0) {
            return arr.count+2;
        }else{
            return 0;
        }
        
    }else if (tableView.tag==13){
        shangpinModel *model1;
        model1 =_orderArray2[section];
        NSArray *arr = _orderDic2[model1.orderId];
        if (arr.count>0) {
            return arr.count+2;
        }else{
            return 0;
        }
        
    }else if (tableView.tag==14){
        shangpinModel *model1;
        model1 =_orderArray3[section];
        NSArray *arr = _orderDic3[model1.orderId];
        if (arr.count>0) {
            return arr.count+2;
        }else{
            return 0;
        }
    }else if(tableView.tag == 15){
        shangpinModel *model1 ;
        model1 =_orderArray4[section];
        NSArray *arr = _orderDic4[model1.orderId];
        if (arr.count>0) {
             return arr.count+2;
        }else{
            return 0;
        }
       
    }
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==11) {
        shangpinModel *model1 ;
        model1 =_orderArray[indexPath.section];
        NSArray *arr = _orderDic[model1.orderId];
        int row = (int)indexPath.row;
        if (row == 0) {
            static NSString *string = @"MyOrderHeaderTableViewCell";
            MyOrderHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderHeaderTableViewCell" owner:self options:nil]lastObject];
                //            cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                
            }
            //店铺名称
            cell.shopNameLab.text = model1.supplierName;
            cell.shopNameLab.font = [UIFont boldSystemFontOfSize:15];
            cell.shopNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
            //status 1等待买家付款  2等待卖家发货  3卖家已发货4交易成功 5交易关闭
            
            if ([model1.status isEqualToString:@"1"]) {
                cell.orderStatsLab.text = @"等待买家付款";
            }else if([model1.status isEqualToString:@"2"]){
                cell.orderStatsLab.text = @"等待卖家发货";
            }else if([model1.status isEqualToString:@"3"]){
                cell.orderStatsLab.text = @"卖家已发货";
            }else if([model1.status isEqualToString:@"4"]){
                cell.orderStatsLab.text = @"交易成功";
            }else if([model1.status isEqualToString:@"5"]){
                cell.orderStatsLab.text = @"交易关闭";
            }else if([model1.status isEqualToString:@"6"]){
                cell.orderStatsLab.text = @"退款/售后";
            }else if([model1.status isEqualToString:@"7"]){
                cell.orderStatsLab.text = @"已评价";
            }
            cell.orderStatsLab.font = [UIFont systemFontOfSize:15];
            cell.orderStatsLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
            cell.orderStatsLab.textAlignment = NSTextAlignmentRight;
            return cell;

        }
        else if (row  < arr.count+1) {
            static NSString *string = @"myOrder";
            MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil]lastObject];
                //            cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                
            }
            cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
            
            
            shangpinModel *model2;
            
            model2 = arr[indexPath.row-1];
            cell.goodsName.text = model2.goodsName;
            cell.goodsName.font = [UIFont systemFontOfSize:12];
            cell.goodsName.textColor = [UIColor colorWithHexString:@"#43464c"];
            cell.goodsNum.text = [NSString stringWithFormat:@"x%@",model2.goodsNumber];
            cell.goodsNum.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
            cell.goodsNum.font = [UIFont systemFontOfSize:12];
            cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",model2.goodsPrice];
            cell.goodsPrice.textColor = [UIColor colorWithHexString:@"#43464c"];
            cell.goodsPrice.font = [UIFont boldSystemFontOfSize:12];
            NSURL *url = [NSURL URLWithString:model2.goodsImage];
            [cell.goodsImgae setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_list_pic_error"]];
            cell.goodsColor.text = model2.attrStr;
            cell.goodsColor.font = [UIFont systemFontOfSize:12];
            cell.goodsColor.textColor = [UIColor colorWithHexString:@"#999999"];
            
            return cell;
        }else if(row == arr.count+1){
            static NSString *string = @"MyOrderFooterTableViewCell";
            MyOrderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderFooterTableViewCell" owner:self options:nil]lastObject];
                
                
            }
            //共几件商品合计多少
           
            double tempPrice = 0.0;
            int number = 0;
            for (shangpinModel *model2 in arr) {
                double modelMoney = [model2.goodsPrice doubleValue];
                int modelNum = [model2.goodsNumber intValue];
                tempPrice = tempPrice +modelMoney;
                number = number + modelNum;
                
            }
            //合计
            float price = [model1.total doubleValue];
            NSString *price2 = [NSString stringWithFormat:@"共%d件商品 合计:¥%.2f",number,price];
            NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc]initWithString:price2];
            NSUInteger a = [[priceStr string] rangeOfString:@"."].location - [[priceStr string] rangeOfString:@"¥"].location;
            NSUInteger b = [[priceStr string] rangeOfString:@":"].location;
            NSUInteger c = priceStr.length - [[priceStr string] rangeOfString:@"."].location;
            NSUInteger d = priceStr.length  - b-1;
            
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, b)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location, 1)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location+1, a)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[priceStr string] rangeOfString:@"."].location, c)];
            
            [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange(0,b)];
            [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location,d)];
            cell.goodsPriceLab.attributedText = priceStr;
            cell.goodsPriceLab.textAlignment = NSTextAlignmentRight;
            //确定按钮
            int sectionCount = (int)indexPath.section + 1000;
            cell.sureBtn.tag = sectionCount;
            [cell.sureBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
            cell.sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.sureBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
            cell.sureBtn.layer.borderWidth = 1.0f;
            cell.sureBtn.layer.cornerRadius = 5;
            cell.sureBtn.layer.masksToBounds = YES;
            if ([model1.status isEqualToString:@"1"]) {
                [cell.sureBtn setTitle:@"去付款" forState:UIControlStateNormal];
                [cell.sureBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
            }else if([model1.status isEqualToString:@"3"]){
                [cell.sureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [cell.sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
            }else if([model1.status isEqualToString:@"4"]){
                [cell.sureBtn setTitle:@"评价" forState:UIControlStateNormal];
                [cell.sureBtn addTarget:self action:@selector(gotoComment:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if([model1.status isEqualToString:@"5"]){
                [cell.sureBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [cell.sureBtn addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
                [cell.sureBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
                cell.sureBtn.layer.borderColor = [UIColor colorWithHexString:@"#43464c"].CGColor;
                
            }else if([model1.status isEqualToString:@"6"]){
                [cell.sureBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [cell.sureBtn addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
                [cell.sureBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
                cell.sureBtn.layer.borderColor = [UIColor colorWithHexString:@"#43464c"].CGColor;
                
            }else if([model1.status isEqualToString:@"7"]){
                [cell.sureBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [cell.sureBtn addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
                [cell.sureBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
                cell.sureBtn.layer.borderColor = [UIColor colorWithHexString:@"#43464c"].CGColor;
                
            }else{
                cell.sureBtn.hidden = YES;
            }
            
            if ([model1.status isEqualToString:@"1"]) {
                //取消订单
        
                [cell.qxOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                int sectionCount = (int)indexPath.section + 1000;
                cell.qxOrderBtn.tag = sectionCount;
                [cell.qxOrderBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.qxOrderBtn setTitleColor:[UIColor colorWithHexString:@"#656973"] forState:UIControlStateNormal];
                cell.qxOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                cell.qxOrderBtn.layer.borderColor = [UIColor colorWithHexString:@"#656973"].CGColor;
                cell.qxOrderBtn.layer.borderWidth = 1.0f;
                cell.qxOrderBtn.layer.cornerRadius = 5;
                cell.qxOrderBtn.layer.masksToBounds = YES;
                //联系卖家

                cell.phoneBtn.tag = sectionCount;
  
                [cell.phoneBtn addTarget:self action:@selector(phoneAciton:) forControlEvents:UIControlEventTouchUpInside];
                [cell.phoneBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
                [cell.phoneBtn setTitleColor:[UIColor colorWithHexString:@"#656973"] forState:UIControlStateNormal];
                cell.phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                cell.phoneBtn.layer.borderColor = [UIColor colorWithHexString:@"#656973"].CGColor;
                cell.phoneBtn.layer.borderWidth = 1.0f;
                cell.phoneBtn.layer.cornerRadius = 5;
                cell.phoneBtn.layer.masksToBounds = YES;
                
                
            } else if([model1.status isEqualToString:@"4"]){
                //删除订单
               
                [cell.qxOrderBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                int sectionCount = (int)indexPath.section + 1000;
                cell.qxOrderBtn.tag = sectionCount;
                [cell.qxOrderBtn addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
                [cell.qxOrderBtn setTitleColor:[UIColor colorWithHexString:@"#656973"] forState:UIControlStateNormal];
                cell.qxOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                cell.qxOrderBtn.layer.borderColor = [UIColor colorWithHexString:@"#656973"].CGColor;
                cell.qxOrderBtn.layer.borderWidth = 1.0f;
                cell.qxOrderBtn.layer.cornerRadius = 5;
                cell.qxOrderBtn.layer.masksToBounds = YES;
                cell.phoneBtn.hidden = YES;
                
            }else{
                cell.phoneBtn.hidden = YES;
                cell.qxOrderBtn.hidden = YES;
            }
            return cell;
        }
        
        
    }else if (tableView.tag==12){
        shangpinModel *model1;
        model1 =_orderArray1[indexPath.section];
        NSArray *arr = _orderDic1[model1.orderId];
        int row = (int)indexPath.row;
        if (row == 0) {
            static NSString *string = @"MyOrderHeaderTableViewCell";
            MyOrderHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderHeaderTableViewCell" owner:self options:nil]lastObject];
            }
            
            cell.shopNameLab.text = model1.supplierName;
            cell.shopNameLab.font = [UIFont boldSystemFontOfSize:15];
            cell.shopNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
            
            //等待买家付款
            
            cell.orderStatsLab.text = @"等待买家付款";
            cell.orderStatsLab.font = [UIFont systemFontOfSize:15];
            cell.orderStatsLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
            cell.orderStatsLab.textAlignment = NSTextAlignmentRight;
            return cell;
            
        }else if (row<arr.count+1) {
            static NSString *string = @"myOrder";
            MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil]lastObject];
                //            cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                
            }
            cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
            
            
            shangpinModel *model2 ;
            
            model2 = arr[indexPath.row-1];
            cell.goodsName.text = model2.goodsName;
            cell.goodsName.font = [UIFont systemFontOfSize:12];
            cell.goodsName.textColor = [UIColor colorWithHexString:@"#43464c"];
            cell.goodsNum.text = [NSString stringWithFormat:@"x%@",model2.goodsNumber];
            cell.goodsNum.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
            cell.goodsNum.font = [UIFont systemFontOfSize:12];
            cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",model2.goodsPrice];
            cell.goodsPrice.textColor = [UIColor colorWithHexString:@"#43464c"];
            cell.goodsPrice.font = [UIFont boldSystemFontOfSize:12];
            NSURL *url = [NSURL URLWithString:model2.goodsImage];
            [cell.goodsImgae setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_list_pic_error"]];
            cell.goodsColor.text = model2.attrStr;
            cell.goodsColor.font = [UIFont systemFontOfSize:12];
            cell.goodsColor.textColor = [UIColor colorWithHexString:@"#999999"];
            // Configure the cell...
            
            return cell;
        }else if (row == arr.count+1){
            static NSString *string = @"MyOrderFooterTableViewCell";
            MyOrderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderFooterTableViewCell" owner:self options:nil]lastObject];
                
                
            }
            int number = 0;
            for (shangpinModel *model2 in arr) {
                
                int modelNum = [model2.goodsNumber intValue];
                
                number = number + modelNum;
                
            }
            //合计

            double price = [model1.total doubleValue];
            NSString *price2 = [NSString stringWithFormat:@"共%d件商品 合计:¥%.2f",number,price];
            NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc]initWithString:price2];
            NSUInteger a = [[priceStr string] rangeOfString:@"."].location - [[priceStr string] rangeOfString:@"¥"].location;
            NSUInteger b = [[priceStr string] rangeOfString:@":"].location;
            NSUInteger c = priceStr.length - [[priceStr string] rangeOfString:@"."].location;
            NSUInteger d = priceStr.length  - b-1;
            
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, b)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location, 1)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location+1, a)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[priceStr string] rangeOfString:@"."].location, c)];
            
            [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange(0,b)];
            [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location,d)];
            cell.goodsPriceLab.textAlignment = NSTextAlignmentRight;
            cell.goodsPriceLab.attributedText = priceStr;
            //付款按钮
            [cell.sureBtn setTitle:@"付款" forState:UIControlStateNormal];
            int sectionCount = (int)indexPath.section + 5000;
            cell.sureBtn.tag = sectionCount;
            [cell.sureBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.sureBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
            cell.sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.sureBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
            cell.sureBtn.layer.borderWidth = 1.0f;
            cell.sureBtn.layer.cornerRadius = 5;
            cell.sureBtn.layer.masksToBounds = YES;
         //取消订单
            [cell.qxOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            cell.qxOrderBtn.tag = sectionCount;
            [cell.qxOrderBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.qxOrderBtn setTitleColor:[UIColor colorWithHexString:@"#656973"] forState:UIControlStateNormal];
            cell.qxOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.qxOrderBtn.layer.borderColor = [UIColor colorWithHexString:@"#656973"].CGColor;
            cell.qxOrderBtn.layer.borderWidth = 1.0f;
            cell.qxOrderBtn.layer.cornerRadius = 5;
            cell.qxOrderBtn.layer.masksToBounds = YES;
            //联系卖家
    
            [cell.phoneBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
            [cell.phoneBtn addTarget:self action:@selector(phoneAciton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.phoneBtn setTitleColor:[UIColor colorWithHexString:@"#656973"] forState:UIControlStateNormal];
            cell.phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.phoneBtn.layer.borderColor = [UIColor colorWithHexString:@"#656973"].CGColor;
            cell.phoneBtn.layer.borderWidth = 1.0f;
            cell.phoneBtn.layer.cornerRadius = 5;
            cell.phoneBtn.layer.masksToBounds = YES;
            return cell;
        }
        
        
    }else if (tableView.tag==13){
        shangpinModel *model1;
        model1 =_orderArray2[indexPath.section];
        NSArray *arr = _orderDic2[model1.orderId];

        int row = (int)indexPath.row;
        if (row == 0) {
            static NSString *string = @"MyOrderHeaderTableViewCell";
            MyOrderHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderHeaderTableViewCell" owner:self options:nil]lastObject];
            }
            
            cell.shopNameLab.text = model1.supplierName;
            cell.shopNameLab.font = [UIFont boldSystemFontOfSize:15];
            cell.shopNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
            
            //等待买家付款
            
            cell.orderStatsLab.text = @"卖家已付款";
            cell.orderStatsLab.font = [UIFont systemFontOfSize:15];
            cell.orderStatsLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
            cell.orderStatsLab.textAlignment = NSTextAlignmentRight;
            return cell;
            
        } else if (row<arr.count+1) {
            static NSString *string = @"myOrder";
            MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil]lastObject];
                //            cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                
            }
            cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
            
            shangpinModel *model2;
            
            model2 = arr[indexPath.row-1];
            cell.goodsName.text = model2.goodsName;
            cell.goodsName.font = [UIFont systemFontOfSize:12];
            cell.goodsName.textColor = [UIColor colorWithHexString:@"#43464c"];
            cell.goodsNum.text = [NSString stringWithFormat:@"x%@",model2.goodsNumber];
            cell.goodsNum.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
            cell.goodsNum.font = [UIFont systemFontOfSize:12];
            cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",model2.goodsPrice];
            cell.goodsPrice.textColor = [UIColor colorWithHexString:@"#43464c"];
            cell.goodsPrice.font = [UIFont boldSystemFontOfSize:12];
            NSURL *url = [NSURL URLWithString:model2.goodsImage];
            [cell.goodsImgae setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_list_pic_error"]];
            cell.goodsColor.text = model2.attrStr;
            cell.goodsColor.font = [UIFont systemFontOfSize:12];
            cell.goodsColor.textColor = [UIColor colorWithHexString:@"#999999"];
            
            return cell;
        }else if(row == arr.count+1){
            static NSString *string = @"MyOrderFooterTableViewCell";
            MyOrderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderFooterTableViewCell" owner:self options:nil]lastObject];
            }
            int number = 0;
            for (shangpinModel *model2 in arr) {
                
                int modelNum = [model2.goodsNumber intValue];
                
                number = number + modelNum;
                
            }
            //合计
            double price = [model1.total doubleValue];
            NSString *price2 = [NSString stringWithFormat:@"共%d件商品 合计:¥%.2f",number,price];
            NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc]initWithString:price2];
            NSUInteger a = [[priceStr string] rangeOfString:@"."].location - [[priceStr string] rangeOfString:@"¥"].location;
            NSUInteger b = [[priceStr string] rangeOfString:@":"].location;
            NSUInteger c = priceStr.length - [[priceStr string] rangeOfString:@"."].location;
            NSUInteger d = priceStr.length  - b-1;
            
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, b)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location, 1)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location+1, a)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[priceStr string] rangeOfString:@"."].location, c)];
            
            [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange(0,b)];
            [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location,d)];
            cell.goodsPriceLab.attributedText = priceStr;
            cell.goodsPriceLab.textAlignment = NSTextAlignmentRight;
            cell.phoneBtn.hidden = YES;
            cell.sureBtn.hidden = YES;
            cell.qxOrderBtn.hidden = YES;
            return cell;
        }
        
        
        
    }else if (tableView.tag==14){
        shangpinModel *model1 ;
        model1 =_orderArray3[indexPath.section];
        NSArray *arr = _orderDic3[model1.orderId];
        int row = (int)indexPath.row;
        if (row == 0) {
            static NSString *string = @"MyOrderHeaderTableViewCell";
            MyOrderHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderHeaderTableViewCell" owner:self options:nil]lastObject];
            }
            
            cell.shopNameLab.text = model1.supplierName;
            cell.shopNameLab.font = [UIFont boldSystemFontOfSize:15];
            cell.shopNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
            
           
            
            cell.orderStatsLab.text = @"卖家已发货";
            cell.orderStatsLab.font = [UIFont systemFontOfSize:15];
            cell.orderStatsLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
            cell.orderStatsLab.textAlignment = NSTextAlignmentRight;
            return cell;
            
        }else if (row < arr.count+1) {
            static NSString *string = @"myOrder";
            MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil]lastObject];
                //            cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                
            }
            cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
            
            
            shangpinModel *model2 ;
            
            model2 = arr[indexPath.row-1];
            cell.goodsName.text = model2.goodsName;
            cell.goodsName.font = [UIFont systemFontOfSize:12];
            cell.goodsName.textColor = [UIColor colorWithHexString:@"#43464c"];
            cell.goodsNum.text = [NSString stringWithFormat:@"x%@",model2.goodsNumber];
            cell.goodsNum.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
            cell.goodsNum.font = [UIFont systemFontOfSize:12];
            cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",model2.goodsPrice];
            cell.goodsPrice.textColor = [UIColor colorWithHexString:@"#43464c"];
            cell.goodsPrice.font = [UIFont boldSystemFontOfSize:12];
            NSURL *url = [NSURL URLWithString:model2.goodsImage];
            [cell.goodsImgae setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_list_pic_error"]];
            cell.goodsColor.text = model2.attrStr;
            cell.goodsColor.font = [UIFont systemFontOfSize:12];
            cell.goodsColor.textColor = [UIColor colorWithHexString:@"#999999"];
            // Configure the cell...
            
            return cell;
        }else if (row == arr.count+1){
            static NSString *string = @"MyOrderFooterTableViewCell";
            MyOrderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderFooterTableViewCell" owner:self options:nil]lastObject];
            }
            //共几件商品合计多少

            int number = 0;
            for (shangpinModel *model2 in arr) {
                
                int modelNum = [model2.goodsNumber intValue];
                
                number = number + modelNum;
                
            }
            //合计

            double price = [model1.total doubleValue];
            NSString *price2 = [NSString stringWithFormat:@"共%d件商品 合计:¥%.2f",number,price];
            NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc]initWithString:price2];
            NSUInteger a = [[priceStr string] rangeOfString:@"."].location - [[priceStr string] rangeOfString:@"¥"].location;
            NSUInteger b = [[priceStr string] rangeOfString:@":"].location;
            NSUInteger c = priceStr.length - [[priceStr string] rangeOfString:@"."].location;
            NSUInteger d = priceStr.length  - b-1;
            
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, b)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location, 1)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location+1, a)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[priceStr string] rangeOfString:@"."].location, c)];
            
            [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange(0,b)];
            [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location,d)];
            
            cell.goodsPriceLab.textAlignment = NSTextAlignmentRight;
            cell.goodsPriceLab.attributedText = priceStr;


            //确认收货

            [cell.sureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [cell.sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.sureBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
            cell.sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            int sectionCount = (int)indexPath.section + 5000;
            cell.sureBtn.tag = sectionCount;
            cell.sureBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
            cell.sureBtn.layer.borderWidth = 1.0f;
            cell.sureBtn.layer.cornerRadius = 5;
            cell.sureBtn.layer.masksToBounds = YES;
            //物流信息

            [cell.qxOrderBtn setTitle:@"物流信息" forState:UIControlStateNormal];
            cell.qxOrderBtn.hidden = YES;
            [cell.qxOrderBtn setTitleColor:[UIColor colorWithHexString:@"#656973"] forState:UIControlStateNormal];
            cell.qxOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.qxOrderBtn.layer.borderColor = [UIColor colorWithHexString:@"#656973"].CGColor;
            cell.qxOrderBtn.layer.borderWidth = 1.0f;
            cell.qxOrderBtn.layer.cornerRadius = 5;
            cell.qxOrderBtn.layer.masksToBounds = YES;
            cell.phoneBtn.hidden = YES;
            return cell;

            
        }
        
       
        
    }else if (tableView.tag==15){
        shangpinModel *model1 ;
        model1 =_orderArray4[indexPath.section];
        NSArray *arr = _orderDic4[model1.orderId];
        int row = (int)indexPath.row;
        if (row == 0) {
            static NSString *string = @"MyOrderHeaderTableViewCell";
            MyOrderHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderHeaderTableViewCell" owner:self options:nil]lastObject];
            }
            
            cell.shopNameLab.text = model1.supplierName;
            cell.shopNameLab.font = [UIFont boldSystemFontOfSize:15];
            cell.shopNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
            
            //等待买家付款
            
            cell.orderStatsLab.text = @"交易成功";
            cell.orderStatsLab.font = [UIFont systemFontOfSize:15];
            cell.orderStatsLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
            cell.orderStatsLab.textAlignment = NSTextAlignmentRight;
            return cell;
            
        }else if (row < arr.count+1) {
            static NSString *string = @"myOrder";
            MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil]lastObject];
                //            cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                
            }
            cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
            
            
            shangpinModel *model2 ;
            
            model2 = arr[indexPath.row-1];
            cell.goodsName.text = model2.goodsName;
            cell.goodsName.font = [UIFont systemFontOfSize:12];
            cell.goodsName.textColor = [UIColor colorWithHexString:@"#43464c"];
            cell.goodsNum.text = [NSString stringWithFormat:@"x%@",model2.goodsNumber];
            cell.goodsNum.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
            cell.goodsNum.font = [UIFont systemFontOfSize:12];
            cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",model2.goodsPrice];
            cell.goodsPrice.textColor = [UIColor colorWithHexString:@"#43464c"];
            cell.goodsPrice.font = [UIFont boldSystemFontOfSize:12];
            NSURL *url = [NSURL URLWithString:model2.goodsImage];
            [cell.goodsImgae setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_list_pic_error"]];
            cell.goodsColor.text = model2.attrStr;
            cell.goodsColor.font = [UIFont systemFontOfSize:12];
            cell.goodsColor.textColor = [UIColor colorWithHexString:@"#999999"];
            // Configure the cell...
            
            return cell;
        }else if(row == arr.count+1){
            static NSString *string = @"MyOrderFooterTableViewCell";
            MyOrderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderFooterTableViewCell" owner:self options:nil]lastObject];
            }

            //共几件商品合计多少
                 int number = 0;
            for (shangpinModel *model2 in arr) {
                
                int modelNum = [model2.goodsNumber intValue];
                
                number = number + modelNum;
                
            }
            //合计
            double price = [model1.total doubleValue];
            NSString *price2 = [NSString stringWithFormat:@"共%d件商品 合计:¥%.2f",number,price];
            NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc]initWithString:price2];
            NSUInteger a = [[priceStr string] rangeOfString:@"."].location - [[priceStr string] rangeOfString:@"¥"].location;
            NSUInteger b = [[priceStr string] rangeOfString:@":"].location;
            NSUInteger c = priceStr.length - [[priceStr string] rangeOfString:@"."].location;
            NSUInteger d = priceStr.length  - b-1;
            
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, b)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location, 1)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location+1, a)];
            [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange([[priceStr string] rangeOfString:@"."].location, c)];
            
            [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange(0,b)];
            [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location,d)];
            
            cell.goodsPriceLab.attributedText = priceStr;
            cell.goodsPriceLab.textAlignment = NSTextAlignmentRight;
       
     
            //评价
    
            int sectionCount = (int)indexPath.section + 5000;
            cell.sureBtn.tag = sectionCount;

            [cell.sureBtn setTitle:@"评价" forState:UIControlStateNormal];
            [cell.sureBtn addTarget:self action:@selector(gotoComment:) forControlEvents:UIControlEventTouchUpInside];
            [cell.sureBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
            cell.sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.sureBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
            cell.sureBtn.layer.borderWidth = 1.0f;
            cell.sureBtn.layer.cornerRadius = 5;
            cell.sureBtn.layer.masksToBounds = YES;

            //物流信息
    
            cell.qxOrderBtn.tag = sectionCount;
            [cell.qxOrderBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [cell.qxOrderBtn setTitleColor:[UIColor colorWithHexString:@"#656973"] forState:UIControlStateNormal];
            cell.qxOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.qxOrderBtn.layer.borderColor = [UIColor colorWithHexString:@"#656973"].CGColor;
            cell.qxOrderBtn.layer.borderWidth = 1.0f;
            cell.qxOrderBtn.layer.cornerRadius = 5;
            cell.qxOrderBtn.layer.masksToBounds = YES;
            [cell.qxOrderBtn addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
            cell.phoneBtn.hidden = YES;
            return cell;
            
        }
        
        
    }

    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==11) {
        
        shangpinModel *model1 ;
        model1 =_orderArray[indexPath.section];
        NSArray *arr = _orderDic[model1.orderId];
        if(indexPath.row == 0){
            return 44;
        }
        else if (indexPath.row<arr.count+1) {
            return 88;
        }else if(indexPath.row == arr.count+1){
            if ([model1.status isEqualToString:@"2"]) {
                //卖家已发货
                return 46;
            }
            else{
                return 92;
            }
        }
    }else if(tableView.tag == 12){
        shangpinModel *model1 ;
        model1 =_orderArray1[indexPath.section];
        NSArray *arr = _orderDic1[model1.orderId];
        if (indexPath.row == 0) {
            return 44;
        }else if (indexPath.row<arr.count+1) {
            return 88;
        }else if(indexPath.row == arr.count+1){
            return 92;
        }
    }
    else if(tableView.tag == 13){
        shangpinModel *model1 ;
        model1 =_orderArray2[indexPath.section];
        NSArray *arr = _orderDic2[model1.orderId];
        if (indexPath.row == 0) {
            return 44;
        }else if (indexPath.row<arr.count+1) {
            return 88;
        }else if(indexPath.row == arr.count+1){
            return 46;
        }

    }else if(tableView.tag == 14){
        shangpinModel *model1 ;
        model1 =_orderArray3[indexPath.section];
        NSArray *arr = _orderDic3[model1.orderId];
        if (indexPath.row == 0) {
            return 44;
        }else if (indexPath.row<arr.count+1) {
            return 88;
        }else if(indexPath.row == arr.count+1){
            return 92;
        }
    }else if (tableView.tag == 15){
        shangpinModel *model1 ;
        model1 =_orderArray4[indexPath.section];
        NSArray *arr = _orderDic4[model1.orderId];
        if (indexPath.row == 0) {
            return 44;
        }else if (indexPath.row<arr.count+1) {
            return 88;
        }else if(indexPath.row == arr.count+1){
            return 92;
        }
    }
    return 88;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
   
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 12)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    return footerView;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag == 11) {
        shangpinModel *model;
        model = _orderArray[indexPath.section];
        NSLog(@"ididididid------%@",model.orderId);
        OrderDetailViewController *orderDetailVC = [OrderDetailViewController new];
        orderDetailVC.orderId = model.orderId;
        orderDetailVC.status = model.status;

        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }else if (tableView.tag == 12){
        shangpinModel *model;
        model = _orderArray1[indexPath.section];
        NSLog(@"ididididid------%@",model.orderId);
        OrderDetailViewController *orderDetailVC = [OrderDetailViewController new];
        orderDetailVC.orderId = model.orderId;
        orderDetailVC.status = model.status;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }else if (tableView.tag == 13){
        shangpinModel *model ;
        model = _orderArray2[indexPath.section];
        NSLog(@"ididididid------%@",model.orderId);
        OrderDetailViewController *orderDetailVC = [OrderDetailViewController new];
        orderDetailVC.orderId = model.orderId;
        orderDetailVC.status = model.status;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }else if (tableView.tag == 14){
        shangpinModel *model ;
        model = _orderArray3[indexPath.section];
        NSLog(@"ididididid------%@",model.orderId);
        OrderDetailViewController *orderDetailVC = [OrderDetailViewController new];
        orderDetailVC.orderId = model.orderId;
        orderDetailVC.status = model.status;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }else if (tableView.tag == 15){
        shangpinModel *model ;
        model = _orderArray4[indexPath.section];
        NSLog(@"ididididid------%@",model.orderId);
        OrderDetailViewController *orderDetailVC = [OrderDetailViewController new];
        orderDetailVC.orderId = model.orderId;
        orderDetailVC.status = model.status;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
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
#pragma mark -- 按钮事件
//去付款
-(void)payAction:(UIButton *)button{
    int buttonTag = (int)button.tag;
    if (buttonTag>=5000) {
        int section = buttonTag - 5000;
        shangpinModel *model1 ;
        model1 =_orderArray1[section];
        NSString *orderID = model1.orderId;
        NSString *price = model1.total;
        CheckStandController *checkVC = [CheckStandController new];
        checkVC.orderNs = orderID;
        checkVC.jiage = price;
        [self.navigationController pushViewController:checkVC animated:YES];
        NSLog(@"%@",orderID);
    }else{
        int section = (int)button.tag - 1000;
        shangpinModel *model1 ;
        model1 =_orderArray[section];
        NSString *orderID = model1.orderId;
        NSString *price = model1.total;
        CheckStandController *checkVC = [CheckStandController new];
        checkVC.orderNs = orderID;
        checkVC.jiage = price;
        [self.navigationController pushViewController:checkVC animated:YES];
        NSLog(@"%@",orderID);
    }
  
}
//取消订单
-(void)cancelAction:(UIButton *)button{
    
    int buttonTag = (int)button.tag;
    if (buttonTag>=5000) {
        int section = buttonTag - 5000;
        shangpinModel *model1;
        model1 =_orderArray1[section];
        NSString *orderID = model1.orderId;
        
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString *api_token = [RequestModel model:@"order" action:@"qorder"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"order_id":orderID};
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"order" action:@"qorder" block:^(id result) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:result[@"msg"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
           
            [weakSelf myWait];
     
        }];
        NSLog(@"%d",section);
    }else{
        int section = (int)button.tag - 1000;
        shangpinModel *model1;
        model1 =_orderArray[section];
        NSString *orderID = model1.orderId;
        
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString *api_token = [RequestModel model:@"order" action:@"qorder"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"order_id":orderID};
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"order" action:@"qorder" block:^(id result) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:result[@"msg"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
    
            [weakSelf myreload];
        }];
        NSLog(@"%d",section);
    }
    
}
//联系卖家
-(void)phoneAciton:(UIButton *)button{
    int buttonTag = (int)button.tag;
    if (buttonTag>=5000) {
        int section = buttonTag - 5000;
        shangpinModel *model1;
        model1 =_orderArray1[section];
        NSString *phone = model1.mobile;
        if ([phone isEqualToString:@"暂无联系方式"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"暂无联系方式" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
            UIWebView *callWebview = [[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
    }else{
        int section = (int)button.tag - 1000;
        shangpinModel *model1;
        model1 =_orderArray[section];
        NSString *phone = model1.mobile;
        if ([phone isEqualToString:@"暂无联系方式"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"暂无联系方式" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
            UIWebView *callWebview = [[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
    }
   
    
}
//确认收货
-(void)sureAction:(UIButton *)button{
    int buttonTag = (int)button.tag;
    if (buttonTag>=5000) {
        int section = buttonTag - 5000;
        shangpinModel *model1;
        model1 =_orderArray3[section];
        NSString *orderID = model1.orderId;
        
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString *api_token = [RequestModel model:@"order" action:@"received"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"order_id":orderID};
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"order" action:@"received" block:^(id result) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:result[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [weakSelf myWaitshouhuo];
         
        }];
        NSLog(@"%d",section);
    }else{
        int section = (int)button.tag - 1000;
        shangpinModel *model1;
        model1 =_orderArray[section];
        NSString *orderID = model1.orderId;
        
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString *api_token = [RequestModel model:@"order" action:@"received"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"order_id":orderID};
        __weak typeof(self) weakSelf = self;
        [RequestModel requestWithDictionary:dict model:@"order" action:@"received" block:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:result[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
    
            [weakSelf myreload];
        }];
        NSLog(@"%d",section);
    }
    
    
}
//去评价
-(void)gotoComment:(UIButton *)button{
    int buttonTag = (int)button.tag;
    if (buttonTag>=5000) {
        int section = buttonTag - 5000;
        
        shangpinModel *model1 ;
        model1 =_orderArray4[section];
        NSString *orderID = model1.orderId;
        NSArray *arr = _orderDic4[model1.orderId];
        NSMutableArray *arrComment = [[NSMutableArray alloc]init];
        for (shangpinModel *model2 in arr) {
            NSString *goodsID = model2.goodsID;
            NSString *imgUrl = model2.goodsImage;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:goodsID forKey:@"goodsID"];
            [dic setObject:imgUrl forKey:@"imgUrl"];
            [arrComment addObject:dic];
        }
        GoToCommentViewController *comment = [GoToCommentViewController new];
        comment.arrr = [arrComment mutableCopy];
        comment.orderID = orderID;
        [self.navigationController pushViewController:comment animated:YES];

    }else{
        int section = buttonTag - 1000;
        
        shangpinModel *model1;
        model1 =_orderArray[section];
        NSString *orderID = model1.orderId;
        NSArray *arr = _orderDic[model1.orderId];
        NSMutableArray *arrComment = [[NSMutableArray alloc]init];
        for (shangpinModel *model2 in arr) {
            NSString *goodsID = model2.goodsID;
            NSString *imgUrl = model2.goodsImage;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:goodsID forKey:@"goodsID"];
            [dic setObject:imgUrl forKey:@"imgUrl"];
            [arrComment addObject:dic];
        }
        GoToCommentViewController *comment = [GoToCommentViewController new];
        comment.arrr = [arrComment mutableCopy];
        comment.orderID = orderID;
        [self.navigationController pushViewController:comment animated:YES];
    }
    
}
//删除订单
-(void)deleteOrder:(UIButton *)button{
    int buttonTag = (int)button.tag;
    int section;
    shangpinModel *model1 ;
    if (buttonTag>=5000) {
        section = buttonTag-5000;
        model1 = _orderArray4[section];
        NSString *orderID = model1.orderId;
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIApplication *appli=[UIApplication sharedApplication];
            AppDelegate *app=appli.delegate;
            NSString *api_token = [RequestModel model:@"order" action:@"delorder"];
            NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"order_id":orderID};
            [RequestModel requestWithDictionary:dict model:@"order" action:@"delorder" block:^(id result) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:result[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];

                [weakSelf waitpj];
                
            }];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        section = buttonTag - 1000;
        model1 = _orderArray[section];
        NSString *orderID = model1.orderId;
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIApplication *appli=[UIApplication sharedApplication];
            AppDelegate *app=appli.delegate;
            NSString *api_token = [RequestModel model:@"order" action:@"delorder"];
            NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"order_id":orderID};
            [RequestModel requestWithDictionary:dict model:@"order" action:@"delorder" block:^(id result) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:result[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];

               
                [weakSelf myreload];
            }];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }

   
    
    
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
    
    label.text = @"我的订单";
    
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
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height - 1, Width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
  
    [self.view addSubview:view];
    
    
}
-(void)back{
    MyTabBarViewController * tabBarViewController = (MyTabBarViewController * )self.tabBarController;
    UINavigationController * nav = [tabBarViewController.viewControllers objectAtIndex:4];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [nav popToRootViewControllerAnimated:YES];
    
    UIButton * button = [[UIButton alloc]init];
    button.tag = 104;
    [tabBarViewController buttonClicked:button];
}
//实现协议方法
-(void)getTag:(NSInteger)tag{

    if (tag == 0) {
        _index = 0;
       
        _tableView1.hidden = NO;
        _tableView2.hidden = YES;
        _tableView3.hidden = YES;
        _tableView4.hidden = YES;
        _tableView5.hidden = YES;
        [self myreload];
    }else if(tag == 1){
        _index= 1;
       
        _tableView1.hidden = YES;
        _tableView2.hidden = NO;
        _tableView3.hidden = YES;
        _tableView4.hidden = YES;
        _tableView5.hidden = YES;
         [self myWait];
    }else if(tag == 2){
        _index = 2;
        
        _tableView1.hidden = YES;
        _tableView2.hidden = YES;
        _tableView3.hidden = NO;
        _tableView4.hidden = YES;
        _tableView5.hidden = YES;
        [self myWaitSend];
    }else if(tag == 3){
        _index =3;
        
        _tableView1.hidden = YES;
        _tableView2.hidden = YES;
        _tableView3.hidden = YES;
        _tableView4.hidden = NO;
        _tableView5.hidden = YES;
        [self myWaitshouhuo];
    }else if(tag == 4){
        _index = 4;
        _tableView1.hidden = YES;
        _tableView2.hidden = YES;
        _tableView3.hidden = YES;
        _tableView4.hidden = YES;
        _tableView5.hidden = NO;
        [self waitpj];
        
    }
}
@end
