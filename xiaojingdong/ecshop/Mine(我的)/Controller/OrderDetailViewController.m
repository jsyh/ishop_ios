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
#import "CheckStandController.h"
#import "UIColor+Hex.h"
#import "OrderDetailModel.h"
#import "OrderDetailExpressTableViewCell.h"
#import "OrderDetailAddressTableViewCell.h"
#import "OrderDetailShippingTableViewCell.h"
#import "ApplyViewController.h"
#import "goodDetailViewController.h"
#import "GoToCommentViewController.h"
#define TextHeight 100
#define cellHeight 50
#define jiange 10
#define Width [UIScreen mainScreen].bounds.size.width
#define Heitht [UIScreen mainScreen].bounds.size.height
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
    UILabel *labelTitle;//标题
}
@property (nonatomic,strong)NSMutableArray *goodsArr;//存放商品信息
@property (nonatomic,strong)NSMutableDictionary *shopDic;//存放商品信息和店铺名称
@property (nonatomic,strong) shangpinModel *model2;
@property (nonatomic,strong)UITableView *tableView;
//订单号
@property (nonatomic,strong)UILabel *labId;
@property (nonatomic,strong)NSString *supplierName;//店铺名
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

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44,  self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.showsVerticalScrollIndicator = NO;
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
    if (section == 0) {
        return 2;
    }else{
        return _goodsArr.count;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([self.model2.order_status isEqualToString:@"1"]){
            //待付款
            if (indexPath.row == 0) {
                return 0;
            }else{
                return 90;
            }
        }else if ([self.model2.order_status isEqualToString:@"2"]){
            //待发货
            if (indexPath.row == 0) {
                return 0;
            }else{
                return 90;
            }
        }else if ([self.model2.order_status isEqualToString:@"3"]){
            //待收货
            return 90;
        }else if ([self.model2.order_status isEqualToString:@"4"]){
            //待评价
            return 90;
        }else if ([self.model2.order_status isEqualToString:@"5"]){
            //取消订单
            if (indexPath.row == 0) {
                return 0;
            }else{
                return 90;
            }
        }else if ([self.model2.order_status isEqualToString:@"6"]){
            //退货退款
            return 90;
        }else if ([self.model2.order_status isEqualToString:@"7"]){
            //已评价
            return 90;
        }
        else{
            return 0;
        }
    
//        return 90;
    }else if(indexPath.section == 1){
        return 120;
    }else{
        return 80;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            static NSString *string = @"OrderDetailExpressTableViewCell";
            OrderDetailExpressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailExpressTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectedBackgroundView = [[UIView alloc]init];
            cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
            cell.imgView.hidden = YES;
            cell.copyyBtn.hidden = YES;
            cell.shippingNameLab.hidden = YES;
            cell.shippingSnLab.hidden = YES;
            cell.statesLab.hidden = YES;
            cell.imgView.image = [UIImage imageNamed:@"order_detail_logistics"];
            cell.copyyBtn.layer.borderWidth = 0.5f;
            cell.copyyBtn.layer.cornerRadius = 3;
            cell.copyyBtn.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
            [cell.copyyBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            cell.shippingNameLab.text = [NSString stringWithFormat:@"承运来源：%@",self.model2.shipping_name];
            cell.shippingNameLab.textColor = [UIColor colorWithRed:44.0/255.0 green:172.0/255.0 blue:98.0/255.0 alpha:1.0];
            cell.shippingSnLab.text = [NSString stringWithFormat:@"运单编号：%@",self.model2.invoiceNO];
            cell.shippingSnLab.textColor = [UIColor colorWithRed:44.0/255.0 green:172.0/255.0 blue:98.0/255.0 alpha:1.0];
            cell.statesLab.text = @"物流状态：请到官方网站查询";
            cell.statesLab.textColor = [UIColor colorWithRed:44.0/255.0 green:172.0/255.0 blue:98.0/255.0 alpha:1.0];
            cell.copyyBtn.layer.masksToBounds = YES;
            [cell.copyyBtn addTarget:self action:@selector(copyLogisticsAction) forControlEvents:UIControlEventTouchUpInside];
            if ([self.model2.order_status isEqualToString:@"1"]){
               
            }else if ([self.model2.order_status isEqualToString:@"2"]){
             
            }else if([self.model2.order_status isEqualToString:@"5"]){
                
            }
            else{
                cell.imgView.hidden = NO;
                cell.copyyBtn.hidden = NO;
                cell.shippingNameLab.hidden = NO;
                cell.shippingSnLab.hidden = NO;
                cell.statesLab.hidden = NO;
            }
            return cell;

        }else {
            //收货人
            static NSString * cellid=@"OrderDetailAddressTableViewCell";
            
            OrderDetailAddressTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell=[[OrderDetailAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.selectedBackgroundView = [[UIView alloc]init];
            cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
            cell.nameLab.text    = [NSString stringWithFormat:@"收货人:%@",self.model2.consignee];
            cell.telLab.text     = [NSString stringWithFormat:@"%@",self.model2.mobile];
            cell.addressLab.text = [NSString stringWithFormat:@"收货地址: %@",self.model2.address];
            return cell;

        }
       
    }else if(indexPath.section == 1){
        static NSString *string = @"myOrder";
        MyOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderViewCell" owner:self options:nil]lastObject];
        }
        cell.model = _goodsArr[indexPath.row];
        //售后
        [cell.serviceBtn addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        if ([self.model2.order_status isEqualToString:@"1"]){
            //待付款
            cell.serviceBtn.hidden = YES;
        }else if ([self.model2.order_status isEqualToString:@"2"]){
            //待发货
            cell.serviceBtn.hidden = YES;
        }else if ([self.model2.order_status isEqualToString:@"3"]){
            //待收货
            cell.serviceBtn.hidden = YES;
        }else if ([self.model2.order_status isEqualToString:@"4"]){
            //待评价
            cell.serviceBtn.hidden = NO;
            
        }else if ([self.model2.order_status isEqualToString:@"5"]){
            //取消订单
            cell.serviceBtn.hidden = YES;
        }else if ([self.model2.order_status isEqualToString:@"6"]){
            //退款/售后
            cell.serviceBtn.hidden = YES;
        }else if ([self.model2.order_status isEqualToString:@"7"]){
            //已评价
            cell.serviceBtn.hidden = YES;
        }

        return cell;

    }else{
        //订单
        
        static NSString * cellid=@"OrderDetailShippingTableViewCell";
        
        OrderDetailShippingTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell=[[OrderDetailShippingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectedBackgroundView = [[UIView alloc]init];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        //创建时间
        NSString * time1=self.model2.add_time;
        NSDate * dt1 = [NSDate dateWithTimeIntervalSince1970:[time1 floatValue]];
        NSDateFormatter * df1 = [[NSDateFormatter alloc] init];
        [df1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString * creatTime = [df1 stringFromDate:dt1];
        //付款时间
        NSString * time2=self.model2.payTime;
        NSDate * dt2 = [NSDate dateWithTimeIntervalSince1970:[time2 floatValue]];
        NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
        [df2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString * payTime = [df2 stringFromDate:dt2];
        //发货时间
        NSString * time3=self.model2.shippingTime;
        NSDate * dt3 = [NSDate dateWithTimeIntervalSince1970:[time3 floatValue]];
        NSDateFormatter * df3 = [[NSDateFormatter alloc] init];
        [df3 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString * sendTime = [df3 stringFromDate:dt3];
        //成交时间
        NSString * time4=self.model2.confirmTime;
        NSDate * dt4 = [NSDate dateWithTimeIntervalSince1970:[time4 floatValue]];
        NSDateFormatter * df4 = [[NSDateFormatter alloc] init];
        [df4 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString * dealTime = [df4 stringFromDate:dt4];
        if ([self.model2.order_status isEqualToString:@"1"]){
            //待付款
            cell.lab1.text = [NSString stringWithFormat:@"订单编号:%@",self.model2.order_sn];
            cell.lab2.text = [NSString stringWithFormat:@"创建时间:%@",creatTime];
        }else if ([self.model2.order_status isEqualToString:@"2"]){
            //待发货
            cell.lab1.text = [NSString stringWithFormat:@"订单编号:%@",self.model2.order_sn];
            cell.lab2.text = [NSString stringWithFormat:@"创建时间:%@",creatTime];
            cell.lab3.text = [NSString stringWithFormat:@"付款时间:%@",payTime];
        }else if ([self.model2.order_status isEqualToString:@"3"]){
            //待收货
            cell.lab1.text = [NSString stringWithFormat:@"订单编号:%@",self.model2.order_sn];
            cell.lab2.text = [NSString stringWithFormat:@"创建时间:%@",creatTime];
            cell.lab3.text = [NSString stringWithFormat:@"付款时间:%@",payTime];
            cell.lab4.text = [NSString stringWithFormat:@"发货时间:%@",sendTime];
        }else if ([self.model2.order_status isEqualToString:@"4"]){
            //待评价
            cell.lab1.text = [NSString stringWithFormat:@"订单编号:%@",self.model2.order_sn];
            cell.lab2.text = [NSString stringWithFormat:@"创建时间:%@",creatTime];
            cell.lab3.text = [NSString stringWithFormat:@"付款时间:%@",payTime];
            cell.lab4.text = [NSString stringWithFormat:@"成交时间:%@",dealTime];
        }else if ([self.model2.order_status isEqualToString:@"5"]){
            //取消订单
            cell.lab1.text = [NSString stringWithFormat:@"订单编号:%@",self.model2.order_sn];
            cell.lab2.text = [NSString stringWithFormat:@"创建时间:%@",creatTime];
        }else if ([self.model2.order_status isEqualToString:@"6"]){
            //退货退款
            cell.lab1.text = [NSString stringWithFormat:@"订单编号:%@",self.model2.order_sn];
            cell.lab2.text = [NSString stringWithFormat:@"创建时间:%@",creatTime];
            cell.lab3.text = [NSString stringWithFormat:@"付款时间:%@",payTime];
            cell.lab4.text = [NSString stringWithFormat:@"成交时间:%@",dealTime];
        }else if ([self.model2.order_status isEqualToString:@"7"]){
            //已评价
            cell.lab1.text = [NSString stringWithFormat:@"订单编号:%@",self.model2.order_sn];
            cell.lab2.text = [NSString stringWithFormat:@"创建时间:%@",creatTime];
            cell.lab3.text = [NSString stringWithFormat:@"付款时间:%@",payTime];
            cell.lab4.text = [NSString stringWithFormat:@"成交时间:%@",dealTime];
        }
        [cell.coppyBtn addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
//复制订单编号
-(void)copyAction{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.model2.order_sn;

}
//复制运单编号
-(void)copyLogisticsAction{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.model2.invoiceNO;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 56;
    }else if(section == 2){
        return 12;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 56)];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 12)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [headerView addSubview:view];
        
        headerView.backgroundColor = [UIColor whiteColor];
        //店铺logo
        UIImageView *shopLogo = [[UIImageView alloc]initWithFrame:CGRectMake(12, 14+12, 15, 15)];
        shopLogo.image = [UIImage imageNamed:@"goods_detail_shop"];
        [headerView addSubview:shopLogo];
        //店铺名称
        UILabel *shopNameLab = [[UILabel alloc]initWithFrame:CGRectMake(shopLogo.frame.size.width+shopLogo.frame.origin.x+12, 14+12, 200, 15)];
        NSString *shopName = self.supplierName;
        if (shopName.length > 0) {
           shopNameLab.text = shopName;
        }else{
           shopNameLab.text = @"自营店";
        }
        
        shopNameLab.font = [UIFont systemFontOfSize:15];
        shopNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        [headerView addSubview:shopNameLab];
        return headerView;

    }else if(section == 2){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 12)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        return view;
        
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 130;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 120)];
        footerView.backgroundColor = [UIColor whiteColor];
        //运费
        UIView *shipView = [[UIView alloc]initWithFrame:CGRectMake(0, 12, Width, 12)];
        UILabel *shipLeftLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 12)];
        shipLeftLab.text = @"运费";
        shipLeftLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        shipLeftLab.font = [UIFont systemFontOfSize:12];
        [shipView addSubview:shipLeftLab];
        UILabel *shipRightLab = [[UILabel alloc]initWithFrame:CGRectMake(Width-100-12, 0, 100, 12)];
        shipRightLab.text = [NSString stringWithFormat:@"¥%@",self.model2.shipping_fee];
        shipRightLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        shipRightLab.font = [UIFont systemFontOfSize:12];
        shipRightLab.textAlignment = NSTextAlignmentRight;
        [shipView addSubview:shipRightLab];
        [footerView addSubview:shipView];
        //红包抵扣
        UIView *couponView = [[UIView alloc]initWithFrame:CGRectMake(0, shipView.frame.size.height+shipView.frame.origin.y+6, Width, 12)];
        UILabel *couponLeftLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 12)];
        couponLeftLab.text = @"红包抵扣";
        couponLeftLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        couponLeftLab.font = [UIFont systemFontOfSize:12];
        [couponView addSubview:couponLeftLab];
        UILabel *couponRightLab = [[UILabel alloc]initWithFrame:CGRectMake(Width-100-12, 0, 100, 12)];
        couponRightLab.text = [NSString stringWithFormat:@"-¥%@",self.model2.bonus];
        couponRightLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        couponRightLab.font = [UIFont systemFontOfSize:12];
        couponRightLab.textAlignment = NSTextAlignmentRight;
        [couponView addSubview:couponRightLab];
        [footerView addSubview:couponView];
        //积分抵扣
        UIView *integralView = [[UIView alloc]initWithFrame:CGRectMake(0, couponView.frame.size.height+couponView.frame.origin.y+6, Width, 12)];
        UILabel *integralLeftLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 12)];
        integralLeftLab.text = @"使用积分";
        integralLeftLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        integralLeftLab.font = [UIFont systemFontOfSize:12];
        [integralView addSubview:integralLeftLab];
        UILabel *integralRightLab = [[UILabel alloc]initWithFrame:CGRectMake(Width-100-12, 0, 100, 12)];
        integralRightLab.text = [NSString stringWithFormat:@"-%@",self.model2.integral];
        integralRightLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        integralRightLab.font = [UIFont systemFontOfSize:12];
        integralRightLab.textAlignment = NSTextAlignmentRight;
        [integralView addSubview:integralRightLab];
        [footerView addSubview:integralView];
     
        
        //实际付（含运费）
        UIView *totalView = [[UIView alloc]initWithFrame:CGRectMake(0, integralView.frame.size.height+integralView.frame.origin.y+6, Width, 12)];
        UILabel *totalLeftLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 12)];
        totalLeftLab.text = @"实际付（含运费）";
        totalLeftLab.textColor = [UIColor colorWithHexString:@"#43464c"];
        totalLeftLab.font = [UIFont systemFontOfSize:12];
        [totalView addSubview:totalLeftLab];
        UILabel *totalRightLab = [[UILabel alloc]initWithFrame:CGRectMake(Width-100-12, 0, 100, 12)];
        totalRightLab.text = [NSString stringWithFormat:@"¥%@",self.model2.money_paid];
        totalRightLab.textColor = [UIColor colorWithHexString:@"#ff5000"];
        totalRightLab.font = [UIFont systemFontOfSize:12];
        totalRightLab.textAlignment = NSTextAlignmentRight;
        [totalView addSubview:totalRightLab];
        [footerView addSubview:totalView];

        UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, totalView.frame.size.height+totalView.frame.origin.y+6, Width, 1)];
        viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
        [footerView addSubview:viewLine];
        //联系卖家及评价
        UIView *evaluationView = [[UIView alloc]initWithFrame:CGRectMake(0, viewLine.frame.origin.y+1, Width, 46)];
        UIButton *evaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [evaluationBtn setTitle:@"评价" forState:UIControlStateNormal];
        [evaluationBtn addTarget:self action:@selector(gotoCommentAction) forControlEvents:UIControlEventTouchUpInside];
        if ([self.model2.order_status isEqualToString:@"1"]){
            //待付款
          
        }else if ([self.model2.order_status isEqualToString:@"2"]){
            //待发货
         
        }else if ([self.model2.order_status isEqualToString:@"3"]){
            //待收货
         
        }else if ([self.model2.order_status isEqualToString:@"4"]){
            //待评价
         evaluationBtn.frame = CGRectMake(Width - 75-12, 9, 75, 28);
        }else if ([self.model2.order_status isEqualToString:@"5"]){
            //取消订单
            
        }else if ([self.model2.order_status isEqualToString:@"6"]){
            //退货
            
        }else if ([self.model2.order_status isEqualToString:@"7"]){
            //已评价
            
        }

        
        [evaluationBtn setTitleColor:[UIColor colorWithHexString:@"#ff5000"] forState:UIControlStateNormal];
        evaluationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        evaluationBtn.layer.borderWidth = 0.5;
        evaluationBtn.layer.cornerRadius = 3;
        evaluationBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff5000"].CGColor;
        evaluationBtn.layer.masksToBounds = YES;
        [evaluationView addSubview:evaluationBtn];
        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [phoneBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        if ([self.model2.order_status isEqualToString:@"1"]){
            //待付款
            phoneBtn.frame = CGRectMake(Width - 75-12, 9, 75, 28);
        }else if ([self.model2.order_status isEqualToString:@"2"]){
            //待发货
            phoneBtn.frame = CGRectMake(Width - 75-12, 9, 75, 28);
        }else if ([self.model2.order_status isEqualToString:@"3"]){
            //待收货
            phoneBtn.frame = CGRectMake(Width - 75-12, 9, 75, 28);
        }else if ([self.model2.order_status isEqualToString:@"4"]){
            //待评价
            phoneBtn.frame = CGRectMake(Width - evaluationBtn.frame.size.width - 24-75, 9, 75, 28);
        }else if ([self.model2.order_status isEqualToString:@"5"]){
            //待收货
            phoneBtn.frame = CGRectMake(Width - 75-12, 9, 75, 28);
        }else if ([self.model2.order_status isEqualToString:@"6"]){
            //待收货
            phoneBtn.frame = CGRectMake(Width - 75-12, 9, 75, 28);
        }else if ([self.model2.order_status isEqualToString:@"7"]){
            //待收货
            phoneBtn.frame = CGRectMake(Width - 75-12, 9, 75, 28);
        }
       
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        phoneBtn.layer.borderColor = [UIColor colorWithHexString:@"#43464c"].CGColor;
        phoneBtn.layer.borderWidth = 0.5;
        phoneBtn.layer.cornerRadius = 3;
        phoneBtn.layer.masksToBounds = YES;
        [phoneBtn addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
        [evaluationView addSubview:phoneBtn];
        [footerView addSubview:evaluationView];
        
        return footerView;
    }else{
        return nil;
    }
}
-(void)gotoCommentAction{
    //shopDic goodsArr
    NSArray *arr = _shopDic[self.supplierName];
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
    comment.orderID = self.orderId;
    [self.navigationController pushViewController:comment animated:YES];
}
-(void)phoneAction:(UIButton*)button{
    NSLog(@"%@",self.model2.mobile);
    if ([self.model2.mobile isEqualToString:@"暂无联系方式"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"暂无联系方式" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.model2.mobile];
        UIWebView *callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.section == 1) {
        shangpinModel *model;
        model =_goodsArr[indexPath.row];
        NSLog(@"%@",model.goodsID);
        goodDetailViewController *goodVC = [[goodDetailViewController alloc]init];
        goodVC.goodID = model.goodsID;
        
        [self.navigationController pushViewController:goodVC animated:YES];
    }
}
#pragma mark --cell按钮事件
//售后
-(void)applyAction:(UIButton *)button{
    MyOrderViewCell * cell = (MyOrderViewCell *)button.superview.superview;
    NSUInteger row = [_tableView indexPathForCell:cell].row;
    shangpinModel *model;
    model = _goodsArr[row];
    ApplyViewController *applyVC = [ApplyViewController new];
    applyVC.goodsID = model.goodsID;
    applyVC.orderID = self.orderId;
    applyVC.price = self.model2.order_amount;
    [self.navigationController pushViewController:applyVC animated:YES];
    
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
        NSDictionary *dicc = dic[@"data"];
        
        weakSelf.shopDic = [[NSMutableDictionary alloc]init];
        
        
        for (NSDictionary *diccc in dicc[@"goods"]) {
            
            weakSelf.goodsArr = [[NSMutableArray alloc]init];
            for (NSDictionary *goodsInfoDic in diccc[@"goodsInfo"]) {
                shangpinModel *model = [shangpinModel new];
                model.goodsID = goodsInfoDic[@"goods_id"];
                model.attrStr = goodsInfoDic[@"goods_attr"];
                model.goodsName = goodsInfoDic[@"goods_name"];
                model.goodsPrice = goodsInfoDic[@"shop_price"];
                NSString *number = goodsInfoDic[@"goods_number"];
                model.goodsNumber = number;
                model.goodsImage = goodsInfoDic[@"goods_thumb"];
                
                [ weakSelf.goodsArr addObject:model];
            }
            [weakSelf.shopDic setValue: weakSelf.goodsArr forKey:diccc[@"supplier_name"]];
            weakSelf.supplierName = diccc[@"supplier_name"];
        }
        
        
        weakSelf.model2 = [shangpinModel new];
        weakSelf.model2.bonus = dicc[@"bonus"];
        weakSelf.model2.integralMoney = dicc[@"integral_money"];
        weakSelf.model2.integral = dicc[@"integral"];
        weakSelf.model2.order_status = dicc[@"order_status"];
        weakSelf.model2.consignee = dicc[@"consignee"];
        weakSelf.model2.money_paid = dicc[@"money_paid"];
        weakSelf.model2.shipping_fee = dicc[@"shipping_fee"];
        weakSelf.model2.order_amount = dicc[@"order_amount"];
        weakSelf.model2.add_time = dicc[@"add_time"];
        weakSelf.model2.order_sn = dicc[@"order_sn"];
        weakSelf.model2.invoiceNO = dicc[@"invoice_no"];
        weakSelf.model2.address = dicc[@"address"];
        weakSelf.model2.mobile = dicc[@"mobile"];
        weakSelf.model2.payTime = dicc[@"pay_time"];
        weakSelf.model2.shippingTime = dicc[@"shipping_time"];
        weakSelf.model2.shipping_name = dicc[@"shipping_name"];
        weakSelf.model2.confirmTime = dicc[@"confirm_time"];
        weakSelf.labId.text = [NSString stringWithFormat:@"订单号：%@",_model2.order_sn];
        
        personLab.text = weakSelf.model2.consignee;
        
        phoneLab.text= weakSelf.model2.mobile;
        labPayWay2.text = weakSelf.model2.pay_name;
        labSend2.text = weakSelf.model2.shipping_name;
        
        
        
//            goodsPrice3.text = [NSString stringWithFormat:@"￥%d",c];
//            goodsPrice4.text = [NSString stringWithFormat:@"+￥%@",_model2.shipping_fee];
//            real1.text = [NSString stringWithFormat:@"实付款：￥%@",_model2.money_paid];
//            textView.text = _model2.address;
//            NSString *time1 = [weakSelf.model2.order_sn substringToIndex:4];
//            NSString *time2 = [weakSelf.model2.order_sn substringWithRange:NSMakeRange(4, 2)];
//            NSString *time3 = [weakSelf.model2.order_sn substringWithRange:NSMakeRange(6, 2)];
//            NSString *time4 = [weakSelf.model2.order_sn substringWithRange:NSMakeRange(8, 2)];
//            NSString *time5 = [weakSelf.model2.order_sn substringWithRange:NSMakeRange(10, 2)];
//            NSString *time6 = [weakSelf.model2.order_sn substringWithRange:NSMakeRange(12, 2)];
//            creat2.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",time1,time2,time3,time4,time5,time6];
        
        
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
#pragma mark --去支付
-(void)payAction:(UIButton *)button{

    CheckStandController * cherk=[[CheckStandController alloc]init];
    cherk.orderNs=self.orderId;
    [self.navigationController pushViewController:cherk animated:YES];
    
    
}
#pragma mark --确认收货
-(void)received:(UIButton *)button{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    shangpinModel *model;
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
    
    labelTitle.text = @"订单详情";
    
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
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-1, Width, 1)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:viewLine];
    
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
