//
//  shangpinModel.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/1.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shangpinModel : NSObject
@property (nonatomic,retain) NSString *titleName;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,strong) NSString *goodsNumber;
@property (nonatomic,strong) NSString *goodsPrice;
@property (nonatomic,strong) NSString *goodsImage;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *orderSn;//订单号
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *total;
@property (nonatomic,strong) shangpinModel *model;
@property (nonatomic,strong) NSString *order_status;//订单状态
@property (nonatomic,strong) NSString *pay_status;//支付状态
@property (nonatomic,strong) NSString *shipping_status;//发货状态

//订单详情用的
@property (nonatomic,strong)NSString *add_time;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *consignee;//姓名
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *money_paid;//支付的钱
@property (nonatomic,strong)NSString *order_amount;
@property (nonatomic,strong)NSString *order_sn;
@property (nonatomic,assign)int number;
@property (nonatomic,strong)NSString *pay_name;
@property (nonatomic,strong)NSString *shipping_fee;//邮费
@property (nonatomic,strong)NSString *shipping_name;

@end
