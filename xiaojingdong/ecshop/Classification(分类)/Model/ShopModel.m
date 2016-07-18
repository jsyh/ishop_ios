//
//  ShopModel.m
//  ecshop
//
//  Created by Jin on 16/4/12.
//  Copyright © 2016年 jsyh. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
-(void)setModel:(ShopModel *)model{
    self.supplierID = model.supplierID;
    self.shopRage = model.shopRage;
    self.shopLogo = model.shopLogo;
    self.shopName = model.shopName;
    self.address  = model.address;
    self.goodsThumb = model.goodsThumb;
    self.goodsNum = model.goodsNum;
    self.shopUrl = model.shopUrl;
    self.sales =model.sales;
    self.goodsArr = model.goodsArr;
    self.attention = model.attention;
}
@end
