//
//  ReturnGoodsViewController.m
//  ecshop
//
//  Created by Jin on 16/5/4.
//  Copyright © 2016年 jsyh. All rights reserved.
//退货退款 售后

#import "ReturnGoodsViewController.h"
#import "UIColor+Hex.h"
#import "ReturnGoodsTableViewCell.h"
#import "shangpinModel.h"
#import "AppDelegate.h"
#import "RequestModel.h"
#import "UIImageView+AFNetworking.h"
#import "LogisticsViewController.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface ReturnGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *nullView;
@property(nonatomic,strong)NSMutableArray *goodsArray;
@end

@implementation ReturnGoodsViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self myreload];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
     _goodsArray = [NSMutableArray array];
    [self draw];
    [self creatnullView];
    // Do any additional setup after loading the view.
}
-(void)creatnullView{
    _nullView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-64)];
    _nullView.hidden = YES;
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
    [self.view addSubview:_nullView];
}
-(void)draw{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _goodsArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    shangpinModel *model ;
    model = _goodsArray[indexPath.section];
    if ([model.status isEqualToString:@"0"]) {
        //通过退货申请
        
        if ([model.invoiceNO isEqualToString:@"0"]) {
            return 224;
        }else{
            return 175;
        }
    }else if ([model.status isEqualToString:@"1"]){
        return 175;
    }else if ([model.status isEqualToString:@"5"]){
        //申请退货中
        return 224;
    }else if ([model.status isEqualToString:@"6"]){
        return 175;
    }else if ([model.status isEqualToString:@"3"]){
        return 175;
    }else if ([model.status isEqualToString:@"8"]){
        return 175;
    }
    else{
        return 175;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = @"myOrder";
    ReturnGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReturnGoodsTableViewCell" owner:self options:nil]lastObject];
        //            cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    shangpinModel *model ;
    model = _goodsArray[indexPath.section];
    cell.backView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    NSURL *url = [NSURL URLWithString:model.goodsImage];
    [cell.imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_list_pic_error"]];
    //商品名称
    cell.goodsNameLab.text = model.goodsName;
    cell.goodsNameLab.font = [UIFont systemFontOfSize:12];
    cell.goodsNameLab.numberOfLines = 2;
    cell.goodsNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
    //颜色
    cell.colorLab.text = model.attrStr;
    cell.colorLab.font = [UIFont systemFontOfSize:12];
    cell.colorLab.textColor = [UIColor colorWithHexString:@"#999999"];
    //商店名称
    cell.shopName.text = model.supplierName;
    //状态
    
    
    cell.orderStatus.textAlignment = NSTextAlignmentRight;
    cell.orderStatus.textColor = [UIColor colorWithHexString:@"#ff5000"];
    //
    NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"交易金额¥%@退款金额:¥%@",model.goodsPrice,model.goodsPrice ]];
    NSUInteger a = [[priceStr string] rangeOfString:@":"].location;
    NSUInteger b = priceStr.length  - a-1;
    [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange(0,a)];
    [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5000"] range:NSMakeRange([[priceStr string] rangeOfString:@":"].location+1,b)];
    cell.moneyLab.attributedText = priceStr;
    cell.moneyLab.font = [UIFont systemFontOfSize:14];
    cell.moneyLab.textAlignment = NSTextAlignmentRight;
    
    [cell.qxMoneyBtn setTitle:@"取消退款" forState:UIControlStateNormal];
    [cell.qxMoneyBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
    [cell.qxMoneyBtn addTarget:self action:@selector(qxMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.qxMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    cell.qxMoneyBtn.layer.borderWidth = 0.5;
    cell.qxMoneyBtn.hidden = YES;
    cell.qxMoneyBtn.layer.cornerRadius = 3;
    cell.qxMoneyBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
    cell.qxMoneyBtn.layer.masksToBounds = YES;
    
    [cell.logisticsBtn setTitle:@"填写物流单号" forState:UIControlStateNormal];
    [cell.logisticsBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
    cell.logisticsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    cell.logisticsBtn.layer.borderWidth = 0.5;
    cell.logisticsBtn.hidden = YES;
    [cell.logisticsBtn addTarget:self action:@selector(logisticsAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.logisticsBtn.layer.cornerRadius = 3;
    cell.logisticsBtn.layer.borderColor = [UIColor colorWithHexString:@"#43464c"].CGColor;
    cell.logisticsBtn.layer.masksToBounds = YES;
    
    if ([model.status isEqualToString:@"0"]) {
        //通过退货申请
        if ([model.invoiceNO isEqualToString:@"0"]) {
            cell.orderStatus.text = @"请寄回商品";
            cell.qxMoneyBtn.hidden = NO;
            cell.logisticsBtn.hidden = NO;
        }else if ([model.invoiceNO isEqualToString:@"1"]){
            cell.orderStatus.text = @"商品已经寄出";
        }
        
    }else if ([model.status isEqualToString:@"1"]){
        cell.orderStatus.text = @"收到货";
    }else if ([model.status isEqualToString:@"5"]){
        //申请退货中
        cell.orderStatus.text = @"等待卖家处理";
        cell.qxMoneyBtn.hidden = NO;
    }else if ([model.status isEqualToString:@"6"]){
        cell.orderStatus.text = @"拒绝退货申请";
    }else if ([model.status isEqualToString:@"3"]){
        cell.orderStatus.text = @"退货完成";
    }else if ([model.status isEqualToString:@"8"]){
        cell.orderStatus.text = @"已取消申请";
    }
    else{
        cell.orderStatus.text = @"";
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 12)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    return view;
}
#pragma mark --取消退款
-(void)qxMoneyAction:(UIButton *)button{
    ReturnGoodsTableViewCell * cell = (ReturnGoodsTableViewCell *)button.superview.superview;
    NSUInteger section = [_tableView indexPathForCell:cell].section;
    shangpinModel *model ;
    model = _goodsArray[section];
    NSLog(@"%@",model.goodsName);
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"确定要取消退款吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
      __weak typeof(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIApplication *appli=[UIApplication sharedApplication];
        AppDelegate *app=appli.delegate;
        NSString *api_token = [RequestModel model:@"user" action:@"unapply"];
        NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"],@"back_id":model.backID,};
        
      
        [RequestModel requestWithDictionary:dict model:@"user" action:@"unapply" block:^(id result) {
            NSDictionary *dic = result;
            NSLog(@"%@",dic);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:dic[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            [weakSelf myreload];
        }];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];

    
   
}
//填写物流单号
-(void)logisticsAction:(UIButton *)button{
    ReturnGoodsTableViewCell * cell = (ReturnGoodsTableViewCell *)button.superview.superview;
    NSUInteger section = [_tableView indexPathForCell:cell].section;
    shangpinModel *model;
    model = _goodsArray[section];
    NSLog(@"%@",model.goodsName);
    LogisticsViewController *logisticsVC = [LogisticsViewController new];
    logisticsVC.backID = model.backID;
    [self.navigationController pushViewController:logisticsVC animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark --解析数据
-(void)myreload{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *api_token = [RequestModel model:@"user" action:@"back_order"];
    NSDictionary *dict = @{@"api_token":api_token,@"key":app.tempDic[@"data"][@"key"]};
    __weak typeof(self) weakSelf = self;
    [_goodsArray removeAllObjects];
    [RequestModel requestWithDictionary:dict model:@"user" action:@"back_order" block:^(id result) {
        NSDictionary *dic = result;
        NSLog(@"%@",dic);
        NSArray *dataArr;
        dataArr = dic[@"data"];
        for (NSDictionary *dict in dataArr) {
            shangpinModel *model = [shangpinModel new];
            model.supplierName = dict[@"supplier_name"];
            model.goodsName = dict[@"goods_name"];
            model.goodsPrice = dict[@"back_goods_price"];
            model.goodsNumber = dict[@"back_goods_number"];
            model.status = dict[@"status_back"];
            model.attrStr = dict[@"goods_attr"];
            model.goodsImage = dict[@"goods_thumb"];
            model.backID = dict[@"back_id"];
            model.invoiceNO = [NSString stringWithFormat:@"%@",dict[@"invoice_no"]];
            [weakSelf.goodsArray addObject:model];
        }
        
                if ([dic[@"msg"] isEqualToString:@"暂无订单信息" ]) {
            NSLog(@"暂无订单信息");
        }
        if (dic[@"data"] == nil) {
            weakSelf.tableView.hidden = YES;
            weakSelf.nullView.hidden = NO;
        }else{
            weakSelf.nullView.hidden = YES;
            weakSelf.tableView.hidden = NO;
        }
        
        
        [weakSelf.tableView reloadData];
        
        
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, self.view.frame.size.width - 200, 44)];
    
    label.text = @"售后";
    
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
    [self.navigationController popViewControllerAnimated:YES];
}

@end
