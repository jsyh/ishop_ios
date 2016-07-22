//
//  shangpinModel.m
//  ecshop
//
//  Created by jsyh-mac on 15/12/1.
//  Copyright © 2015年 jsyh. All rights reserved.
//

#import "shangpinModel.h"

@implementation shangpinModel
-(void)setModel:(shangpinModel *)model{
    model.goodsName = _goodsName;
    model.goodsImage = _goodsImage;
    model.goodsPrice = _goodsPrice;
    model.goodsNumber = _goodsNumber;
    model.orderId = _orderId;
    model.orderSn = _orderSn;
    model.status = _status;
    model.total = _total;
    model.add_time =_add_time;
    model.address = _address;
    model.consignee = _consignee;
    model.mobile = _mobile;
    model.money_paid = _money_paid;
    model.order_amount = _order_amount;
    model.order_sn = _order_sn;
    model.pay_name = _pay_name;
    model.shipping_name = _shipping_name;
    model.shipping_fee = _shipping_fee;
    model.number = _number;
}
@end
