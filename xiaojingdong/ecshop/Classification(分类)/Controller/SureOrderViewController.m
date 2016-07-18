//
//  SureOrderViewController.m
//  ecshop
//
//  Created by Jin on 16/4/20.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "SureOrderViewController.h"
#import "UIColor+Hex.h"
#import "SelectAddressTableViewCell.h"
#import "SelectHongBaoTableViewCell.h"
#import "SelectGoodsTableViewCell.h"
#import "SelectAddressDefaltTableViewCell.h"
#import "RequestModel.h"
#import "AppDelegate.h"
#import "shangpinModel.h"
#import "UIImageView+WebCache.h"
#import "AddressViewController.h"
#import "hongBaoView.h"
#import "MessageTableViewCell.h"
#import "UseIntegralTableViewCell.h"
#import "AddressViewController.h"
#import "CheckStandController.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface SureOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)NSString *address;        //送货地址
@property(nonatomic,strong)NSString *addressID;      //送货地址id
@property(nonatomic,strong)NSString *mobile;         //电话
@property(nonatomic,strong)NSString *userName;       //用户名
@property(nonatomic,strong)NSString *integralScale;  //最多可以兑换的积分
@property(nonatomic,strong)NSString *integralPercent;//兑换积分的比例
@property(nonatomic,strong)NSString *integral;       //兑换积分
@property(nonatomic,strong)NSString *total;          //订单总价格
@property(nonatomic,strong)NSString *postPoints;     //商品积分(在积分商城兑换的时候获得商品的积分)
@property(nonatomic,strong)NSMutableArray *shopArr; //商店名称的数组
@property(nonatomic,strong)NSMutableDictionary *goodsDic;//存放商品信息
@property(nonatomic,assign)int shopCount;
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,assign)float freight;             //运费
@property(nonatomic,assign)float totalPrices;//所有商品的总价
@property(nonatomic,assign)float totalPrice;//选择红包时的总价（所有商品价格的总和）
@property(nonatomic,strong) UILabel *totalLab;//下面的合计

@property (nonatomic, copy) NSString * hongbaoNam;//红包名字
@property (nonatomic, copy) NSString * hongMuch;//红包面额
@property (nonatomic, copy) NSString * hongDiyong;//可以抵用的面额
@property (nonatomic, copy) NSString * hongId;//红包id
@property (nonatomic, copy) NSString * typeID;//类型id

@property (nonatomic,assign)BOOL integralYN;//是否使用积分
@property (nonatomic,strong)NSString *messageStr;//买家留言

@property (nonatomic,strong)NSString *psAction;//配送方式
@property (nonatomic,assign)double psPrice;//运费

@property(nonatomic,strong)NSString *giveIntegral;
@end

@implementation SureOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadInfo];
    _integralYN = NO;
    _totalPrice = 0.00;
    _freight = 0.00;
    _totalPrices = 0.00;
    _psAction = @"";
    _psPrice = 0.00;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    [self creatUI];
    NSNotificationCenter *ncollect=[NSNotificationCenter defaultCenter];
    [ncollect addObserver:self selector:@selector(showHongbao:) name:@"MonInfo" object:nil];
    // Do any additional setup after loading the view.
}
-(void)showHongbao:(NSNotification* )noti
{
    NSDictionary *info=noti.userInfo;
    _hongbaoNam=info[@"myMon"][@"monName"];
    _hongMuch=info[@"myMon"][@"monHow"];//可以使用的红包的面值
    _hongDiyong=info[@"myMon"][@"mondiyong"];//抵用金钱
    _hongId=info[@"myMon"][@"baoID"];//红包id
    _typeID=info[@"myMon"][@"typeIID"];
    
   
}
-(void)creatUI{
    //创建tableview
 
  
   

    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width, Height  - 114) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _myTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_myTableView];
    //底部的view
     float aW218 = 218.0/750.0;
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, Height - 50, Width, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    //下面的合计
    _totalLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width - aW218*Width-12 , 50)];
    
//    NSString *price = [NSString stringWithFormat:@"¥%@",model.goodsPrice];
    NSString *price = @"合计:¥0.00";
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
    NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
    NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
    NSUInteger c = attributStr.length - [[attributStr string] rangeOfString:@"¥"].location;
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 3)];
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(3, 1)];
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, a)];
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a+3, b)];
  
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange(0,3)];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5000"] range:NSMakeRange(3,c)];
    _totalLab.textAlignment = NSTextAlignmentRight;
    _totalLab.attributedText = attributStr;
    [bottomView addSubview:_totalLab];
    //右侧确认按钮
   
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5000"];
    sureBtn.frame = CGRectMake(Width-aW218*Width, 0, aW218*Width, 50);
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:sureBtn];
    [self.view addSubview:bottomView];
}
#pragma mark --确认订单事件
-(void)sureAction{
    NSLog(@"%.2f",_totalPrice);
   
    //送货地址id addressID
    //商品recid  goodsID
    //商品总价格  totalPrices
    //实际付费   totalPrice
    //配送费用
    //配送方式id psAction
    //红包id   _hongId
    //购买数量(只有直接购买的时候才有) goodsNumber
    //type 0购物车购买 2直接购买
    //订单留言  _messageStr
    
    NSString *useInteg;//使用的积分
    NSString *integralMoney;//用积分抵用的钱
    if (_integralYN) {
        
        float scale = [_integralScale floatValue];
        int a = _totalPrices/100;
        float totalScale = a*scale;
        double percent = [_integralPercent doubleValue];
        double integral = (totalScale*100)/percent;//可使用积分
        double myIntegral = [_integral doubleValue];
        integralMoney =[NSString stringWithFormat:@"%.2f",totalScale];
        if (integral< myIntegral) {
            useInteg = [NSString stringWithFormat:@"%.2f",integral];
            //积分为 integral
            //积分抵的钱为 totalScale
        }else{
            useInteg = [NSString stringWithFormat:@"%.2f",myIntegral];
            //积分为 myIntegral
            //积分抵的钱为 totalScale
        }
       
    }else{
        //积分为0
        useInteg = @"0";
        integralMoney = @"0";
    }
    if (_hongId == nil) {
        _hongId = @"";
    }
    if (_messageStr == nil) {
        _messageStr = @"";
    }
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    NSString *fee = [NSString stringWithFormat:@"%.2f",_psPrice];
    NSDictionary *dict = @{@"key":app.tempDic[@"data"][@"key"],@"goods_id":self.goodsID,@"type":self.type,@"address_id":_addressID,@"integral":useInteg,@"integral_money":integralMoney,@"attr_id":self.propertyID,@"amount":[NSString stringWithFormat:@"%2.f",_totalPrices],@"money_paid":[NSString stringWithFormat:@"%2.f",_totalPrice],@"shipping_fee":fee,@"expressage_id":_psAction,@"bonus_id":_hongId,@"goods_number":self.goodsNumber,@"message":_messageStr,@"give_integral":self.giveIntegral};
    __weak typeof(self) weakSelf = self;
    _shopArr = [[NSMutableArray alloc]init];
    _goodsDic = [[NSMutableDictionary alloc]init];
    [RequestModel requestWithDictionary:dict model:@"order" action:@"create" block:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *dic = result;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"生产订单成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        CheckStandController *checkVC = [CheckStandController new];
        checkVC.jiage =[NSString stringWithFormat:@"%2.f",weakSelf.totalPrice];
        checkVC.type = weakSelf.type;
        NSArray *orderArr = dic[@"data"][@"order_sn"];
        NSLog(@"%@",orderArr);
        NSString *orderSN;
        for (NSString *temp in orderArr) {
            if (orderSN.length>0) {
                NSString *str = [NSString stringWithFormat:@"%@",temp];
                orderSN = [NSString stringWithFormat:@"%@,%@",orderSN,str];
            }else{
                NSString *str = [NSString stringWithFormat:@"%@",temp];
                orderSN = str;
            }
        }
        checkVC.orderNs = orderSN;
        [weakSelf.navigationController pushViewController:checkVC animated:YES];
    }];


}
#pragma mark-请求数据
-(void)reloadInfo{
    UIApplication *appli=[UIApplication sharedApplication];
    AppDelegate *app=appli.delegate;
    if (self.propertyID == nil) {
        self.propertyID = @"";
    }
    if (self.goodsNumber == nil) {
        self.goodsNumber = @"";
    }
    NSDictionary *dict = @{@"key":app.tempDic[@"data"][@"key"],@"goods_id":self.goodsID,@"type":self.type,@"attr_id":self.propertyID,@"goods_number":self.goodsNumber};
    __weak typeof(self) weakSelf = self;
    _shopArr = [[NSMutableArray alloc]init];
    _goodsDic = [[NSMutableDictionary alloc]init];
    [RequestModel requestWithDictionary:dict model:@"order" action:@"confirm" block:^(id result) {
        
        NSDictionary *dicResult = result;
        int code = [dicResult[@"code"] intValue];
        if (code==3) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"您还没有默认地址，是否新建地址？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                AddressViewController *addressVC = [AddressViewController new];
                [weakSelf.navigationController pushViewController:addressVC animated:YES];
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            

           
        }else{
            NSDictionary *dic = dicResult[@"data"];
            NSLog(@"获得的数据：%@",dic);
            weakSelf.address   = dic[@"address"];
            weakSelf.addressID = dic[@"address_id"];
            weakSelf.giveIntegral = dic[@"give_integral"];
            weakSelf.integral  = dic[@"integral"];
            weakSelf.integralPercent = dic[@"integral_percent"];
            weakSelf.integralScale   = dic[@"integral_scale"];
            weakSelf.mobile    = dic[@"mobile"];
            weakSelf.postPoints= dic[@"post_points"];
            weakSelf.total     = dic[@"total"];
            weakSelf.userName  = dic[@"user_name"];
            NSArray *goodArray;
            goodArray = dic[@"goods"];
            //存放商品信息的数组
            float totalPrice = 0.0;
            int totalNum = 0;
            for (NSMutableDictionary *dict in goodArray) {
                NSString *shopID = dict[@"goodsInfo"][0][@"supplier_id"];
                if (weakSelf.psAction.length>0) {
                    NSString *str = [NSString stringWithFormat:@"%@",dict[@"ps_id"]];
                    weakSelf.psAction = [NSString stringWithFormat:@"%@,%@-%@",weakSelf.psAction,str,shopID];
                }else{
                    NSString *str = [NSString stringWithFormat:@"%@",dict[@"ps_id"]];
                    weakSelf.psAction = [NSString stringWithFormat:@"%@-%@",str,shopID];
                }
                double aPrice = [dict[@"ps_price"] doubleValue];
                weakSelf.psPrice = weakSelf.psPrice + aPrice;
                NSMutableArray *goodsArr = [[NSMutableArray alloc]init];
                NSArray *goodsinfoArr = dict[@"goodsInfo"];
                for (NSMutableDictionary *goodsDic in goodsinfoArr) {
                    shangpinModel *model = [shangpinModel new];
                    model.psPrice = dict[@"ps_price"];
                    model.psID = dict[@"ps_id"];
                    model.peisong = dict[@"peisong"];
                    
                    model.supplierName = dict[@"supplier_name"];
                    model.goodsName = goodsDic[@"goods_name"];
                    model.goodsPrice = goodsDic[@"goods_price"];
                    model.goodsNumber = goodsDic[@"goods_number"];
                    model.goodsImage = goodsDic[@"goods_thumb"];
                    model.supplierID = goodsDic[@"supplier_id"];
                    model.attrArr = goodsDic[@"attr"];
                    
                    totalPrice = totalPrice +[model.goodsPrice floatValue];
                    totalNum = totalNum + [model.goodsNumber intValue];
                    
                    [goodsArr addObject:model];
                }
                weakSelf.totalPrice = totalPrice;
                if (weakSelf.hongMuch.length>0) {
                    //减去红包
                    double temp = [weakSelf.hongMuch doubleValue];
                    weakSelf.totalPrice = weakSelf.totalPrice - temp;
                }
                weakSelf.totalPrice = weakSelf.totalPrice + weakSelf.psPrice;
                NSString *price = [NSString stringWithFormat:@"合计:¥%.2f",weakSelf.totalPrice];
                NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
                NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
                NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
                NSUInteger c = attributStr.length - [[attributStr string] rangeOfString:@"¥"].location;
                [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 3)];
                [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(3, 1)];
                [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, a)];
                [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a+3, b)];
                
                [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange(0,3)];
                [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5000"] range:NSMakeRange(3,c)];
                weakSelf.totalLab.textAlignment = NSTextAlignmentRight;
                weakSelf.totalLab.attributedText = attributStr;
                
                
                weakSelf.totalPrices = totalPrice;
                [weakSelf.goodsDic setObject:goodsArr forKey:dict[@"supplier_name"]];
                [weakSelf.shopArr addObject:dict[@"supplier_name"]];
                
            }
            
        }
//        _shopCount = (int)_shopArr.count;
        [weakSelf.myTableView reloadData];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if ( section == _shopArr.count+1){
        return 1;
    }else if ( section == _shopArr.count+2){
        return 1;
    }else if ( section == _shopArr.count+3){
        return 2;
    }else{
        int sectionCount = (int)section - 1;
        NSString *a = _shopArr[sectionCount];
        NSArray *arr = _goodsDic[a];
        return arr.count;
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4+_shopArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
//        static NSString * cellid=@"SelectAddressTableViewCell";
//        
//        SelectAddressTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//        if (!cell) {
//            cell=[[SelectAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//        }
//        
//        return cell;
        //收货人
        static NSString * cellid=@"SelectAddressDefaltTableViewCell";
        
        SelectAddressDefaltTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell=[[SelectAddressDefaltTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.nameLab.text    = _userName;
        cell.telLab.text     = _mobile;
        cell.addressLab.text = _address;
        return cell;
    }else if(indexPath.section == _shopArr.count+1){
        static NSString * cellid=@"SelectHongBaoTableViewCell";
        
        SelectHongBaoTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell=[[SelectHongBaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell.button setImage:[UIImage imageNamed:@"goods_detail_go"] forState:UIControlStateNormal];
        if (_hongbaoNam.length>0) {
            cell.label.text = [NSString stringWithFormat:@"满¥%@可以抵用¥%@",_hongDiyong,_hongMuch];
            
        }else{
            cell.label.text = @"选择红包";
//            _hongMuch
        }
        return cell;
    }else if(indexPath.section == _shopArr.count+2){
        static NSString * cellid=@"SelectHongBaoTableViewCell";
        
        UseIntegralTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell=[[UseIntegralTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        float scale = [_integralScale floatValue];
        int a = _totalPrices/100;
        float totalScale = a*scale;
        double percent = [_integralPercent doubleValue];
        double integral = (totalScale*100)/percent;//可使用积分
        double myIntegral = [_integral doubleValue];
        if (integral< myIntegral) {
            //如果自己拥有的积分超过最高可抵用的积分，则使用最高可抵用的积分
           
           cell.label.text =[NSString stringWithFormat:@"可用%.2f积分抵¥%.2f",integral,totalScale] ;
        }else{
            //如果自己拥有的积分低于最高可抵用的积分，则使用自己所有的积分
            //计算出自己拥有的积分能抵用多少钱
            double tempPrice = myIntegral*percent/100.0;
            NSString *sb = [self notRounding:tempPrice afterPoint:2];
            cell.label.text =[NSString stringWithFormat:@"可用%.2f积分抵¥%@",myIntegral,sb] ;
            
        }
        
        [cell.button setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
        cell.button.selected = NO;
        [cell.button addTarget:self action:@selector(useIntegralAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button setTitleColor:[UIColor colorWithHexString:@"#43464c"] forState:UIControlStateNormal];
        cell.button.titleLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }else if (indexPath.section == _shopArr.count + 3){
        
        if (indexPath.row == 0) {
            static NSString * cellid=@"MessageTableViewCell";
            
            MessageTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell=[[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.textField.delegate = self;
            return cell;
        }else{
            static NSString * cellid=@"SelectHongBaoTableViewCell";
            
            SelectHongBaoTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell=[[SelectHongBaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
        
            cell.label.text = [NSString stringWithFormat:@"本次赠送积分%@",self.giveIntegral];
            return cell;
        }
        

    }
    else {
        //商品
        if (_shopArr.count>0) {
            static NSString * cellid=@"SelectGoodsTableViewCell";
            
            SelectGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil) {
                cell=[[SelectGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            shangpinModel *model;
            int sectionCount = (int)indexPath.section -1;
            NSString *shopName = _shopArr[sectionCount];
            NSArray *arr = _goodsDic[shopName];
            model = arr[indexPath.row];
            cell.nameLab.text = model.goodsName;
            
            NSString *price = [NSString stringWithFormat:@"¥%@",model.goodsPrice];
            NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
             NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
            NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
             [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
            [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(1, a)];
            [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a, b)];
            cell.priceLab.attributedText = attributStr;
            cell.numLab.text = [NSString stringWithFormat:@"x%@",model.goodsNumber];
            NSString *attributeStr=@"";
            for (NSMutableDictionary *dic in model.attrArr) {
                if (attributeStr.length>0) {
                    attributeStr = [NSString stringWithFormat:@"%@ %@:%@",attributeStr,dic[@"attr_name"],dic[@"attr_value"]];
                }else{
                    attributeStr = [NSString stringWithFormat:@"%@:%@",dic[@"attr_name"],dic[@"attr_value"]];
                }
                
            }
            cell.attributeLab.text = attributeStr;
            NSString *imgUrl = model.goodsImage;
            NSURL *url = [NSURL URLWithString:imgUrl];
            [cell.imgView setImageWithURL:url];
            return cell;
        }else{
            return nil;
        }
        
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
//        float a104 = 104.0/1334.0;
        float a216 = 216.0/1334.0;
        return a216*Height;
    }
    else if(indexPath.section == _shopArr.count+1){
        float a92 = 92.0/1334.0;
        return a92*Height;
    }else if(indexPath.section == _shopArr.count+2){
        float a92 = 92.0/1334.0;
        return a92*Height;
    }else if(indexPath.section == _shopArr.count+3){
        float a92 = 92.0/1334.0;
        return a92*Height;
    }
    else{
        float a228 = 228.0/1334.0;
        return a228*Height;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_shopArr.count>0) {
        if (section == 0) {
            return nil;
        }else if(section == _shopArr.count+1){
            return nil;
        }else if(section == _shopArr.count+2){
            return nil;
        }else if(section == _shopArr.count + 3){
            return nil;
        }
        else {
            float aH88 = 88.0/1334.0;
            float aX24 = 24.0/750.0;
            float aY24 = 24.0/1334.0;
            float aW34 = 34.0/750.0;
            
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, aH88*Height)];
            headerView.backgroundColor = [UIColor whiteColor];
            //商店图标
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(aX24*Width, aY24*Height, aW34*Width, aW34*Width)];
            imgView.image = [UIImage imageNamed:@"shop_cart_shop_photo"];
            [headerView addSubview:imgView];
            //商店名称
            UILabel *shopNameLab = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width+imgView.frame.origin.x+aX24*Width, aY24*Height+1, 200, 15)];
            
            //设置粗体
            //        shopNameLab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15];
            //        shopNameLab.font = [UIFont boldSystemFontOfSize:15];
            shopNameLab.font = [UIFont systemFontOfSize:15];
            int sectionCount = (int)section - 1;
            shopNameLab.text = _shopArr[sectionCount];
            shopNameLab.textColor = [UIColor colorWithHexString:@"#43464c"];
            
            [headerView addSubview:shopNameLab];
            UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 1)];
            viewLine.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
            [headerView addSubview:viewLine];
            return headerView;
        }
    }else{
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
         return 0.0000000000001;
    }else if(section == _shopArr.count+1){
        return 0.0000000000001;
    }else if(section == _shopArr.count+2){
        return 0.0000000000001;
    }else if(section == _shopArr.count+3){
        return 0.0000000000001;
    }else {
        float aH88 = 88.0/1334.0;
        return aH88*Height;
    }
   
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_shopArr.count > 0) {
        if (section == 0) {
            return nil;
        }else if(section == _shopArr.count+1){
            return nil;
        }else if(section == _shopArr.count+2){
            return nil;
        }else if(section == _shopArr.count+3){
            
           
            return nil;
        }else{
            float aH92 = 92.0/1334.0;
            float aX24 = 24.0/750.0;
            float aY24 = 24.0/1334.0;
         
            
            
            int sectionCount = (int)section -1;
            NSString *shopName = _shopArr[sectionCount];
            NSArray *arr = _goodsDic[shopName];
            float totalPrice = 0.00;//总价
            int totalNum = 0;//总个数
            NSString *psName;
            for (shangpinModel *model in arr) {
                totalPrice = totalPrice +[model.goodsPrice floatValue];
                totalNum = totalNum + [model.goodsNumber intValue];
                psName = model.peisong;
            }
            shangpinModel *model = arr[0];
            NSString *ppp = model.psPrice;
            double fee = [ppp doubleValue];
            totalPrice = totalPrice + fee;
//            _totalPrices = _totalPrices+totalPrice;
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, aH92*Height*2+12)];
            footerView.backgroundColor = [UIColor whiteColor];
            //配送方式
            UIView *sendView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, aH92*Height)];
            
            UILabel *sendLab = [[UILabel alloc]initWithFrame:CGRectMake(aX24*Width, aY24*Height, 200, 15)];
            sendLab.textColor = [UIColor colorWithHexString:@"#43464c"];
            sendLab.font = [UIFont systemFontOfSize:15];
            sendLab.text =[NSString stringWithFormat:@"配送方式:%@",psName];
            [sendView addSubview:sendLab];
            
            UILabel *sendActionLab = [[UILabel alloc]initWithFrame:CGRectMake(Width - aX24*Width-100, sendLab.frame.origin.y, 100, 15)];
            sendActionLab.textColor = [UIColor colorWithHexString:@"#43464c"];
            sendActionLab.font = [UIFont systemFontOfSize:15];
            sendActionLab.text = [NSString stringWithFormat:@"运费:¥%@",ppp];
            sendActionLab.textAlignment = NSTextAlignmentRight;
            [sendView addSubview:sendActionLab];
            UIView *viewLine1 = [[UIView alloc]initWithFrame:CGRectMake(aX24*Width, sendView.frame.size.height-1, Width-aX24*Width, 1)];
            viewLine1.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
            [sendView addSubview:viewLine1];
            [footerView addSubview:sendView];
            
            //合计
            UIView *totalView = [[UIView alloc]initWithFrame:CGRectMake(0, aH92*Height, Width, aH92*Height)];
            
            
            UILabel *totalLab = [[UILabel alloc]initWithFrame:CGRectMake(aX24*Width, aY24*Height, Width-aX24*Width*2, 15)];
            float price = _freight + totalPrice;
            NSString *price2 = [NSString stringWithFormat:@"共%d件商品 合计:¥%.2f",totalNum,price];
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
            [priceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5000"] range:NSMakeRange([[priceStr string] rangeOfString:@"¥"].location,d)];
            
            totalLab.attributedText = priceStr;
            totalLab.textAlignment = NSTextAlignmentRight;
            [totalView addSubview:totalLab];
            //间距
            UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, footerView.frame.size.height - 12, Width, 12)];
            viewLine.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
            [footerView addSubview:viewLine];
            UIView *viewLined = [[UIView alloc]initWithFrame:CGRectMake(0, footerView.frame.size.height-12, Width, 1)];
            viewLined.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
            [footerView addSubview:viewLined];
            [footerView addSubview:totalView];
            return footerView;
        }
    }else{
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 12;
    }else if(section == _shopArr.count+1){
        return 12;
    }else if(section == _shopArr.count+2){
        return 12;
    }else if(section == _shopArr.count+3){
        return 12;
    }else{
        float aH92 = 92.0/1334.0;
        return aH92*Height*2+12;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSLog(@"选择地址");
        AddressViewController *addressVC = [AddressViewController new];
        [self.navigationController pushViewController:addressVC animated:YES];
    }
   else if(indexPath.section == _shopArr.count+1){
        //选择红包
        NSLog(@"选择红包");
       NSLog(@"%.2f",_totalPrice);
       hongBaoView *hongbaoVC = [hongBaoView new];
       hongbaoVC.money = [NSString stringWithFormat:@"%.2f",_totalPrice];
       [self.navigationController pushViewController:hongbaoVC animated:YES];
    }
}
#pragma mark --使用积分
-(void)useIntegralAction:(UIButton *)button{

    if (button.selected == NO) {
        _integralYN= YES;
        button.selected = YES;
        [button setImage:[UIImage imageNamed:@"switch_press"] forState:UIControlStateNormal];
        double percent = [_integralPercent doubleValue];
        float scale = [_integralScale floatValue];
        int aTotal = _totalPrices/100;
        float totalScale = aTotal*scale;
        double myIntegral = [_integral doubleValue];
        double integral = (totalScale*100)/percent;//可使用积分
        if (integral< myIntegral) {
            //如果自己拥有的积分超过最高可抵用的积分，则使用最高可抵用的积分
            _totalPrice = _totalPrice - totalScale;
        }else{
            //如果自己拥有的积分低于最高可抵用的积分，则使用自己所有的积分
            //计算出自己拥有的积分能抵用多少钱
            float tempPrice = myIntegral*percent*0.01;
            NSString *sb = [self notRounding:tempPrice afterPoint:2];
            double temp = [sb doubleValue];
            _totalPrice = _totalPrice - temp;
        }
        
        
        NSString *price = [NSString stringWithFormat:@"合计:¥%.2f",_totalPrice];
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
        NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
        NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
        NSUInteger c = attributStr.length - [[attributStr string] rangeOfString:@"¥"].location;
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 3)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(3, 1)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, a)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a+3, b)];
        
        [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange(0,3)];
        [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5000"] range:NSMakeRange(3,c)];
        _totalLab.textAlignment = NSTextAlignmentRight;
        _totalLab.attributedText = attributStr;

    }else{
        _integralYN = NO;
        button.selected = NO;
        [button setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
        double percent = [_integralPercent doubleValue];
        float scale = [_integralScale floatValue];
        int aTotal = _totalPrices/100;
        float totalScale = aTotal*scale;
        double myIntegral = [_integral doubleValue];
        double integral = (totalScale*100)/percent;//可使用积分
        if (integral< myIntegral) {
            //如果自己拥有的积分超过最高可抵用的积分，则使用最高可抵用的积分
            _totalPrice = _totalPrice + totalScale;
        }else{
            //如果自己拥有的积分低于最高可抵用的积分，则使用自己所有的积分
            //计算出自己拥有的积分能抵用多少钱
            float tempPrice = myIntegral*percent*0.01;
            NSString *sb = [self notRounding:tempPrice afterPoint:2];
            double temp = [sb doubleValue];
            _totalPrice = _totalPrice + temp;
        }
        NSString *price = [NSString stringWithFormat:@"合计:¥%.2f",_totalPrice];
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:price];
        NSUInteger a = [[attributStr string] rangeOfString:@"."].location - [[attributStr string] rangeOfString:@"¥"].location;
        NSUInteger b = attributStr.length - [[attributStr string] rangeOfString:@"."].location;
        NSUInteger c = attributStr.length - [[attributStr string] rangeOfString:@"¥"].location;
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 3)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(3, 1)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, a)];
        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(a+3, b)];
        
        [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#43464c"] range:NSMakeRange(0,3)];
        [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5000"] range:NSMakeRange(3,c)];
        _totalLab.textAlignment = NSTextAlignmentRight;
        _totalLab.attributedText = attributStr;
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
#pragma mark -- textField代理
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    _messageStr = textField.text;
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
    label.text = @"确认订单";
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
    
    //画线
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-1, Width, 1)];
    view1.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [view addSubview:view1];
    [self.view addSubview:view];
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
@end
