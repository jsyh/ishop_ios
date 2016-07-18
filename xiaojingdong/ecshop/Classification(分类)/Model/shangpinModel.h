//
//  shangpinModel.h
//  ecshop
//
//  Created by jsyh-mac on 15/12/1.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shangpinModel : NSObject
@property (nonatomic,strong) NSString *titleName;
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
@property (nonatomic,strong)NSString *shippingTime;
@property (nonatomic,strong)NSString *bonus;
@property (nonatomic,strong)NSString *integralMoney;//积分抵用的钱
@property (nonatomic,strong)NSString *integral;//积分
@property (nonatomic,strong)NSString *invoiceNO;//快递单号
@property (nonatomic,strong)NSString *payTime;//付款时间
@property (nonatomic,strong)NSString *confirmTime;//成交时间
//确认订单时使用
/**
 *  attrArr         商品属性数组
 *  goodsName       商品名称
 *  goodsPrice      商品价格
 *  goodsImage      商品图片
 *  supplierID      商店id
 *  goodsNumber     商品数量
 *  supplierName    商店名称
 *
 */
@property(nonatomic,strong)NSMutableArray *attrArr;
@property(nonatomic,strong)NSString *supplierID;
@property(nonatomic,strong)NSString *supplierName;
@property(nonatomic,strong)NSString *shopUrl;       //店铺url
@property(nonatomic,strong)NSString *attrStr;       //购物车用 属性
@property(nonatomic,strong)NSString *recID;         //购物车用 唯一标识
@property(nonatomic,strong)NSString *attrvalueID;   //购物车用 商品属性id
@property(nonatomic,strong)NSString *goodsID;       //购物车用 商品id
//收藏宝贝用的
@property(nonatomic,strong)NSString *goodsComment;//评论条数
@property(nonatomic,strong)NSString *goodRage;//好评百分比


@property(nonatomic,strong)NSString *psPrice;        //运费
@property(nonatomic,strong)NSString *psID;           //快递id
@property(nonatomic,strong)NSString *peisong;        //快递名称

//退款退货列表
@property(nonatomic,strong)NSString *backID;//退货订单id

@end
