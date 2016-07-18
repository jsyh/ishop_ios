//
//  OrderDetailModel.h
//  ecshop
//
//  Created by Jin on 16/5/9.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrderDetailModel : NSObject
@property(nonatomic,copy) NSString *bonus;//红包支付金额
@property(nonatomic,copy) NSString *integralMoney;//使用积分支付的金额
@property(nonatomic,copy) NSString *integral;//积分
@property(nonatomic,copy) NSString *order_status;//订单状态
@property(nonatomic,copy) NSString *consignee;//购买人姓名
@property(nonatomic,copy) NSString *moneyPaid;//实际支付金额
@property(nonatomic,copy) NSString *shippingFee;//运费
@property(nonatomic,copy) NSString *orderAmount;//订单总金额
@property(nonatomic,copy) NSString *shippingName;//配送方式
@property(nonatomic,copy) NSString *addTime;//创建订单实时间
@property(nonatomic,copy) NSString *orderSN;//订单编号
@property(nonatomic,copy) NSString *invoiceNO;//快递单号
@property(nonatomic,copy) NSString *mobile;//电话
@property(nonatomic,copy) NSString *address;//地址
@property(nonatomic,copy) NSString *payTime;//支付时间
@property(nonatomic,copy) NSString *shippingTime;//收货时间
@property(nonatomic,strong)NSMutableArray *goodsArray;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
