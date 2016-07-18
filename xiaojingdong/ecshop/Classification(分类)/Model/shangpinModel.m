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
     self.goodsName = model.goodsName;
     self.goodsImage = model.goodsImage;
     self.goodsPrice = model.goodsPrice;
     self.goodsNumber = model.goodsNumber;
     self.orderId = model.orderId;
     self.orderSn = model.orderSn;
     self.status = model.status;
     self.total = model.total ;
     self.add_time = model.add_time;
     self.address = model.address ;
     self.consignee = model.consignee;
     self.mobile = model.mobile;
     self.money_paid = model.money_paid ;
     self.order_amount = model.order_amount;
     self.order_sn = model.order_sn ;
     self.pay_name = model.pay_name ;
     self.shipping_name = model.shipping_name;
     self.shipping_fee = model.shipping_fee;
     self.number = model.number;
     self.attrArr = model.attrArr;
     self.supplierID = model.supplierID;
     self.supplierName = model.supplierName;
}
@end
