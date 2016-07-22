//
//  OrderDetailViewController.m
//  ecshop
//
//  Created by Jin on 16/1/15.
//  Copyright © 2016年 jsyh. All rights reserved.
//订单详情 order lorder

#import "OrderDetailViewController.h"
#import "MyOrderViewCell.h"
#import "shangpinModel.h"
#import "RequestModel.h"
#import "AppDelegate.h"
#import "goodsModel.h"
#import "thirdViewController.h"
#import "CheckStandController.h"
#import "UIColor+Hex.h"
#define TextHeight 100
#define cellHeight 50
#define jiange 10
#define kColorBack [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel * personLab;//人名
    UILabel * phoneLab;//电话号码
    UILabel * totalFen;//总积分'
    UITextView * textView;
    UILabel *labSend2;//配送方式
    UILabel *goodsPrice3;//商品总额
    UILabel *goodsPrice4;//运费
    UILabel *creat2;//创建时间
    UILabel *real1 ;//实付款
    UILabel *labPayWay2;//支付方式
    UIButton *bottomBtn;//下面的按钮
    UILabel *labelTitle;//标题
}
@property (nonatomic,strong)NSMutableArray *goodsArr;
@property (nonatomic,strong) shangpinModel *model2;
@property (nonatomic,strong)UITableView *tableView;
//订单号
@property (nonatomic,strong)UILabel *labId;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"待收货";
    [self draw];
    [self myOrder];
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}
-(void)draw{
#pragma mark-收货地址
    UIView * firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TextHeight+80)];
    _labId = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
//    shangpinModel *model = [shangpinModel new];
//    model = _orderArray[0];
//    NSString *orderSn = model.orderSn;
    _labId.text = [NSString stringWithFormat:@"订单号："];
    _labId.backgroundColor = [UIColor whiteColor];
    [firstView addSubview:_labId];
    
    firstView.backgroundColor=[UIColor colorWithRed:254/255.0 green:248/255.0 blue:239/255.0 alpha:1.0];
    firstView.opaque=YES;
    textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 85, self.view.frame.size.width, TextHeight-10)];
    textView.opaque=YES;
    textView.backgroundColor=[UIColor clearColor];
    textView.textColor=[UIColor lightGrayColor];
    textView.font =[UIFont systemFontOfSize:15];
    textView.tag=1888;
    textView.userInteractionEnabled = NO;
    [firstView addSubview:textView];
    //创建背景图片
    for (int i=0; i<2; i++) {
        UIImage * imga=[UIImage imageNamed:@"我的订单 -去付款（等待付款）-装饰"];
        imga=[imga imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *imagev=[[UIImageView alloc]initWithFrame:CGRectMake(0, 60+(TextHeight+20-5)*i, self.view.frame.size.width, 5)];
        imagev.opaque=YES;
        imagev.image=imga;
        [firstView addSubview:imagev];
    }
    //创建人名和电话

    
    UIImageView * smallImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 70, 15,15)];
    smallImage.opaque=YES;
    UIImage * imagee=[UIImage imageNamed:@"我的订单-去付款（等待付款）-人icon"];
    imagee=[imagee imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    smallImage.image=imagee;
    [firstView addSubview:smallImage];
    
    UIImageView * smallImage1=[[UIImageView alloc]initWithFrame:CGRectMake(130, 70, 12,20)];
    smallImage1.opaque=YES;
    UIImage * imagee1=[UIImage imageNamed:@"我的订单-去付款（等待付款）-手机icon"];
    imagee1=[imagee1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    smallImage1.image=imagee1;
    [firstView addSubview:smallImage1];
   
    //人名和电话
    personLab =[[UILabel alloc]initWithFrame:CGRectMake(30, 70, 100, 15)];
    personLab.font=[UIFont systemFontOfSize:13];
    personLab.opaque=YES;
    personLab.text = @"1111";
    phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(157, 70, 110, 15)];
    phoneLab.font=[UIFont systemFontOfSize:13];
    phoneLab.opaque=YES;
    phoneLab.text = @"222";
    [firstView addSubview:personLab];
    [firstView addSubview:phoneLab];
    [firstView addSubview:textView];
    
#warning --区尾
    
    UIView *lastView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
    //支付方式
    UIView *payWayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    UILabel *labPayWay1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, payWayView.frame.size.height)];
    labPayWay1.text = @"支付方式";
    labPayWay1.font = [UIFont systemFontOfSize:15];
    [payWayView addSubview:labPayWay1];
    
    labPayWay2 = [[UILabel alloc]initWithFrame:CGRectMake(payWayView.frame.size.width - 110,0 , 100, payWayView.frame.size.height)];
    labPayWay2.text = @"支付宝";
    labPayWay2.font = [UIFont systemFontOfSize:15];
    labPayWay2.textAlignment = NSTextAlignmentRight;

    [payWayView addSubview:labPayWay2];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    view1.backgroundColor = kColorBack;
    [payWayView addSubview:view1];
    
    //配送方式
    UIView *sendView = [[UIView alloc]initWithFrame:CGRectMake(0, payWayView.frame.size.height, self.view.frame.size.width, 80)];
    UILabel *labSend1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, sendView.frame.size.height/2)];
    labSend1.text = @"配送方式";
    labSend1.font = [UIFont systemFontOfSize:15];
    [sendView addSubview:labSend1];
    labSend2 = [[UILabel alloc]initWithFrame:CGRectMake(10, sendView.frame.size.height/2, 100, sendView.frame.size.height/2)];
    labSend2.text = @"申通快递";
    labSend2.font = [UIFont systemFontOfSize:15];
    labSend2.textColor = [UIColor grayColor];
   
    [sendView addSubview:labSend2];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    view2.backgroundColor = kColorBack;
    [sendView addSubview:view2];
    
    //商品总额
    UIView *goodsPriceView = [[UIView alloc]initWithFrame:CGRectMake(0, sendView.frame.size.height+payWayView.frame.size.height, self.view.frame.size.width, 80)];
    UILabel *goodsPrice1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, sendView.frame.size.height/2)];
    goodsPrice1.text = @"商品总额";
    goodsPrice1.font = [UIFont systemFontOfSize:15];
    [goodsPriceView addSubview:goodsPrice1];
    UILabel *goodsPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(10, sendView.frame.size.height/2, 100, sendView.frame.size.height/2)];
    goodsPrice2.text = @"+运费";
    goodsPrice2.font = [UIFont systemFontOfSize:15];
    [goodsPriceView addSubview:goodsPrice2];
    
    goodsPrice3 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 110, 0, 100, sendView.frame.size.height/2)];
    goodsPrice3.text = @"10";
    goodsPrice3.font = [UIFont systemFontOfSize:15];
    goodsPrice3.textAlignment = NSTextAlignmentRight;
    goodsPrice3.textColor = [UIColor redColor];
    [goodsPriceView addSubview:goodsPrice3];
    goodsPrice4 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 110, sendView.frame.size.height/2, 100, sendView.frame.size.height/2)];
    goodsPrice4.font = [UIFont systemFontOfSize:15];
    goodsPrice4.text = @"111";
    goodsPrice4.textAlignment = NSTextAlignmentRight;
    goodsPrice4.textColor = [UIColor redColor];
    [goodsPriceView addSubview:goodsPrice4];
    UIView *view3= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    view3.backgroundColor = kColorBack;
    [goodsPriceView addSubview:view3];
    
    //创建时间
    UIView *creatView = [[UIView alloc]initWithFrame:CGRectMake(0, goodsPriceView.frame.origin.y + goodsPriceView.frame.size.height, self.view.frame.size.width, 60)];
    UILabel *creat1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, creatView.frame.size.height)];
    creat1.text = @"创建时间";
    creat1.font = [UIFont systemFontOfSize:15];
    [creatView addSubview:creat1];
    
    creat2 = [[UILabel alloc]initWithFrame:CGRectMake(creatView.frame.size.width - 210,0 , 200, creatView.frame.size.height)];
    creat2.font = [UIFont systemFontOfSize:15];
    creat2.text = @"2016-01-15 14：46：55";
    creat2.textAlignment = NSTextAlignmentRight;
    [creatView addSubview:creat2];
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    view4.backgroundColor = kColorBack;
    [creatView addSubview:view4];
    //实付款
    UIView *realView = [[UIView alloc]initWithFrame:CGRectMake(0, creatView.frame.origin.y + creatView.frame.size.height, self.view.frame.size.width, 60)];
    real1 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 160, 0, 150, 60)];
    real1.text = @"实付款:73";
    real1.font = [UIFont systemFontOfSize:15];
    real1.textAlignment = NSTextAlignmentRight;
    [realView addSubview:real1];
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    view5.backgroundColor = kColorBack;
    [realView addSubview:view5];
    //下面的按钮
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, realView.frame.origin.y + realView.frame.size.height, self.view.frame.size.width, 60)];
    bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(self.view.frame.size.width - 100, 0, 90, 45);
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottomBtn.layer setCornerRadius:10];
    bottomBtn.backgroundColor = [UIColor redColor];
    [bottomView addSubview:bottomBtn];
    
   
    [lastView addSubview:payWayView];
    [lastView addSubview:sendView];//80
    [lastView addSubview:goodsPriceView];//80
    [lastView addSubview:creatView];//60
    [lastView addSubview:realView];//60
    [lastView addSubview:bottomView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = firstView;
    _tableView.tableFooterView = lastView;
    [self.view addSubview:_tableView];
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
#pragma mark --tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _goodsArray.count;
    return _goodsArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = @"myOrder";
    MyOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderViewCell" owner:self options:nil]lastObject];
    }
    cell.model = _goodsArr[indexPath.row];
    return cell;
}
#pragma mark --解析数据
-(void)myOrder{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"order" action:@"lorder"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"order_id":_orderId};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"order" action:@"lorder" block:^(id result) {
        NSDictionary *dic = result;
        weakSelf.goodsArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dicc in dic[@"data"]) {
            for (NSDictionary *diccc in dicc[@"goods"]) {
                shangpinModel *model = [shangpinModel new];
                model.goodsName = diccc[@"goods_name"];
                model.goodsPrice = diccc[@"goods_price"];
                NSString *number = diccc[@"goods_number"];
                model.goodsNumber = number;
                model.goodsImage = diccc[@"goods_thumb"];
                [weakSelf.goodsArr addObject:model];
            }
            
            weakSelf.model2 = [shangpinModel new];
            weakSelf.model2.add_time = dicc[@"add_time"];
            weakSelf.model2.address = dicc[@"address"];
            weakSelf.model2.consignee = dicc[@"consignee"];
            weakSelf.model2.mobile = dicc[@"mobile"];
            weakSelf.model2.money_paid = dicc[@"money_paid"];
            weakSelf.model2.order_amount = dicc[@"order_amount"];
            weakSelf.model2.order_sn = dicc[@"order_sn"];
            weakSelf.model2.order_status = dicc[@"order_status"];
            weakSelf.model2.pay_name = dicc[@"pay_name"];
            weakSelf.model2.shipping_fee = dicc[@"shipping_fee"];
            weakSelf.model2.shipping_name = dicc[@"shipping_name"];
            weakSelf.model2.total = dicc[@"total"];
            weakSelf.labId.text = [NSString stringWithFormat:@"订单号：%@",_model2.order_sn];
            personLab.text = weakSelf.model2.consignee;
            phoneLab.text= weakSelf.model2.mobile;
            labPayWay2.text = weakSelf.model2.pay_name;
            labSend2.text = weakSelf.model2.shipping_name;
            int a = [weakSelf.model2.money_paid intValue];
            int b = [weakSelf.model2.shipping_fee intValue];
            int c = a - b;
            
            goodsPrice3.text = [NSString stringWithFormat:@"￥%d",c];
            goodsPrice4.text = [NSString stringWithFormat:@"+￥%@",_model2.shipping_fee];
            real1.text = [NSString stringWithFormat:@"实付款：￥%@",_model2.money_paid];
            textView.text = _model2.address;
            NSString *time1 = [weakSelf.model2.order_sn substringToIndex:4];
            NSString *time2 = [weakSelf.model2.order_sn substringWithRange:NSMakeRange(4, 2)];
            NSString *time3 = [weakSelf.model2.order_sn substringWithRange:NSMakeRange(6, 2)];
            NSString *time4 = [weakSelf.model2.order_sn substringWithRange:NSMakeRange(8, 2)];
            NSString *time5 = [weakSelf.model2.order_sn substringWithRange:NSMakeRange(10, 2)];
            NSString *time6 = [weakSelf.model2.order_sn substringWithRange:NSMakeRange(12, 2)];
            creat2.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",time1,time2,time3,time4,time5,time6];
            if ([weakSelf.model2.order_status isEqualToString:@"5"]) {
                labelTitle.text = @"已完成";
                [bottomBtn setTitle:@"再次购买" forState:UIControlStateNormal];
                
                [bottomBtn addTarget:weakSelf action:@selector(changeToBuy:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([weakSelf.model2.order_status isEqualToString:@"1"]){
                labelTitle.text = @"待付款";
                [bottomBtn setTitle:@"去支付" forState:UIControlStateNormal];
                [bottomBtn addTarget:weakSelf action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if ([weakSelf.model2.order_status isEqualToString:@"2"]){
                labelTitle.text = @"取消订单";
                [bottomBtn setTitle:@"放回购物车" forState:UIControlStateNormal];
                [bottomBtn addTarget:weakSelf action:@selector(changeToBuy:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([weakSelf.model2.order_status isEqualToString:@"3"]){
                labelTitle.text = @"待发货";
//                [bottomBtn setTitle:@"去支付" forState:UIControlStateNormal];
                bottomBtn.hidden = YES;
            }else if ([weakSelf.model2.order_status isEqualToString:@"4"]){
                labelTitle.text = @"已发货";
                [bottomBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [bottomBtn addTarget:weakSelf action:@selector(received:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        NSLog(@"%@",_goodsArr);
        /*
         UILabel *labSend2;//配送方式
         UILabel *goodsPrice3;//商品总额
         UILabel *goodsPrice4;//运费
         UILabel *creat2;//创建时间
         UILabel *real1 ;//实付款
         UILabel *labPayWay2;//支付方式
         */
        [weakSelf.tableView reloadData];
    }];
}
//再次购买
-(void)changeToBuy:(UIButton *)button{
    //order recart
    shangpinModel *model = [shangpinModel new];
    model = _goodsArr[button.tag];
    NSLog(@"%@",model);
    
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"order" action:@"recart"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"order_id":self.orderId};
    __weak typeof(self) weakSelf = self;
    [RequestModel requestWithDictionary:dict model:@"order" action:@"recart" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        
        thirdViewController *thirdVC = [thirdViewController new];
        [weakSelf.navigationController pushViewController:thirdVC animated:YES];
        
        thirdVC.temp = @"1";
        
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark --去支付
-(void)payAction:(UIButton *)button{
    shangpinModel *model = [shangpinModel new];
    model = _goodsArr[button.tag];
    CheckStandController * cherk=[[CheckStandController alloc]init];
    cherk.orderNs=self.orderId;
    [self.navigationController pushViewController:cherk animated:YES];
    
    
}
#pragma mark --确认收货
-(void)received:(UIButton *)button{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    shangpinModel *model = [shangpinModel new];
    model = _goodsArr[button.tag];
    
    NSLog(@"确认收货%@",model.orderId);
    NSString *api_token = [RequestModel model:@"order" action:@"received"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"order_id":self.orderId};
    [RequestModel requestWithDictionary:dict model:@"order" action:@"received" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"获得的数据：%@",dic);
        
        
        
    }];
    
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
    labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    
    labelTitle.text = @"关注商品";
    
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
    
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
